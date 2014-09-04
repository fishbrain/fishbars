validUnits = {
  weight:
    kg: { factor: ((x) -> x), name: 'kgs', fixedPoints: 1 }
    lb: { factor: ((x) -> x * 2.20462262), name: 'lbs', fixedPoints: 1 }
  length:
    m: { factor: ((x) -> x * 100), name: 'cm', fixedPoints: 0 }
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

translations = [
  key: 'country'
  method: 'local'
,
  key: 'language'
  method: 'translate'
]

exports.registerHelpers = (handlebars, settings = {}) ->

  units = settings.units || {}

  Object.keys(units).forEach (unit) ->
    if !validUnits[unit][units[unit]]?
      throw new Error("The #{unit} unit '#{units[unit]}' is invalid")

  translations.forEach ({ key, method }) ->
    value = settings[key]
    handlebars.registerHelper method, (obj) ->
      if !value?
        throw new Error("No #{key} configured")

      if obj[value]?
        obj[value]
      else
        throw new Error("No translation available for the #{key} #{value}")


  Object.keys(validUnits).forEach (unit) ->
    handlebars.registerHelper unit, (amount) ->
      conversion = validUnits[unit][units[unit]]
      if !conversion?
        throw new Error("No valid #{unit} unit configured")
      return conversion.factor(amount).toFixed(conversion.fixedPoints) + " " + conversion.name

  handlebars.registerHelper 'inWater', (waterName) ->
    inString = settings.translations.in[settings.language]

    if !inString?
      throw new Error("No translation available for the string 'in' in the language #{settings.language}")

    if waterName?
      inString + " " + waterName
    else
      ""

  handlebars.registerHelper 'possify', (name) ->
    lastLetter = name?.slice(-1)?[0]

    output = switch settings.language
      when "se"
        if lastLetter == 's' then name else name + "s"
      when "en"
        if lastLetter == 's' then name + "'" else name + "'s"
      else
        throw new Error("Possify not available in the language #{settings.language}")

    new handlebars.SafeString(output)
