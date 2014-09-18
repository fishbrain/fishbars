validUnits = {
  weight:
    kg: { factor: ((x) -> x), name: 'kgs', fixedPoints: 1 }
    lb: (x) ->
      ounces = Math.round(x * 2.20462262 * 16)
      poundPart = Math.floor(ounces / 16)
      ouncePart = ounces - poundPart * 16

      if ouncePart == 0
        return "#{poundPart} lbs"
      else
        return "#{poundPart} lbs #{ouncePart} oz"

  length:
    m: { factor: ((x) -> x * 100), name: 'cm', fixedPoints: 0 }
    ft: (x) ->
      inches = x * 39.3700787
      flooredInches = Math.floor(inches)
      remainerInches = inches - flooredInches
      fractionIndex = Math.round(remainerInches * 4)
      fractions = {
        0: ''
        1: ' ¼'
        2: ' ½'
        3: ' ¾'
      }
      flooredInches + fractions[fractionIndex] + " in"

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
      else if obj['*']?
        obj['*']
      else
        throw new Error("No translation available for the #{key} #{value}")


  Object.keys(validUnits).forEach (unit) ->
    handlebars.registerHelper unit, (amount) ->
      conversion = validUnits[unit][units[unit]]
      if !conversion?
        throw new Error("No valid #{unit} unit configured")
      if typeof conversion == 'function'
        conversion(amount)
      else
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
      when 'sv'
        if lastLetter == 's' then name else name + "s"
      when "en"
        if lastLetter == 's' then name + "'" else name + "'s"
      else
        throw new Error("Possify not available in the language #{settings.language}")

    new handlebars.SafeString(output)

  handlebars.registerHelper 'catchTitle', (catchData) ->
    hasWeight = catchData.weight >= 0
    hasLength = catchData.length >= 0

    if hasWeight && hasLength
      template = "{{translate catch.species}} {{weight catch.weight}}, {{length catch.length}}"
    else if hasWeight
      template = "{{translate catch.species}} {{weight catch.weight}}"
    else if hasLength
      template = "{{translate catch.species}} {{length catch.length}}"
    else
      template = "{{translate catch.species}}"

    template = handlebars.compile(template)
    result = template({ catch: catchData })
