validUnits = {
  weight:
    kg: { factor: 1, name: 'kgs', fixedPoints: 1 }
    lb: { factor: 2.20462262, name: 'lbs', fixedPoints: 1 }
  length:
    m: { factor: 1, name: 'm', fixedPoints: 2 }
    ft: { factor: 3.2808399, name: 'ft', fixedPoints: 2 }
}


exports.registerHelpers = ({
  handlebars
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

  ['weight', 'length'].forEach (unit) ->
    handlebars.registerHelper unit, (amount) ->
      conversion = validUnits[unit][units[unit]]
      if !conversion?
        throw new Error("No valid #{unit} unit configured")
      return (conversion.factor * amount).toFixed(conversion.fixedPoints) + " " + conversion.name
