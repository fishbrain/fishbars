validUnits = {
  weight:
    kg: { factor: ((x) -> x), name: 'kgs', fixedPoints: 1 }
    lb: { factor: ((x) -> x * 2.20462262), name: 'lbs', fixedPoints: 1 }
  length:
    m: { factor: ((x) -> x), name: 'm', fixedPoints: 2 }
    ft: { factor: ((x) -> x * 3.2808399), name: 'ft', fixedPoints: 2 }
  temperature:
    C: { factor: ((x) -> x), name: 'C', fixedPoints: 0 }
    F: { factor: ((x) -> x * 9 / 5 + 32), name: 'F', fixedPoints: 0 }
  speed:
    'm/s': { factor: ((x) -> x), name: 'm/s', fixedPoints: 1 }
    'km/h': { factor: ((x) -> x * 3.6), name: 'km/h', fixedPoints: 1 }
    'mph': { factor: ((x) -> x * 2.23693629), name: 'mph', fixedPoints: 1 }
    'kn': { factor: ((x) -> x * 1.94384449), name: 'kn', fixedPoints: 1 }
}


exports.registerHelpers = (handlebars, {
  language
  units
}) ->

  units ?= {}

  Object.keys(units).forEach (unit) ->
    if !validUnits[unit][units[unit]]?
      throw new Error("The #{unit} unit '#{units[unit]}' is invalid")

  handlebars.registerHelper 'translate', (obj) ->
    if !language?
      throw new Error("No language configured")

    if obj[language]?
      obj[language]
    else
      throw new Error("No translation available for the language #{language}")

  Object.keys(validUnits).forEach (unit) ->
    handlebars.registerHelper unit, (amount) ->
      conversion = validUnits[unit][units[unit]]
      if !conversion?
        throw new Error("No valid #{unit} unit configured")
      return conversion.factor(amount).toFixed(conversion.fixedPoints) + " " + conversion.name
