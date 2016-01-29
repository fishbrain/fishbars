validUnits = {
  weight:
    kg: { factor: ((x) -> x), name: 'kg', fixedPoints: 1 }
    lb: { factor: ((x) -> x * 2.20462262), name: 'lbs', fixedPoints: 1 }

  length:
    m: { factor: ((x) -> x * 100), name: 'cm', fixedPoints: 0 }
    ft: { factor: ((x) -> x * 39.3700787), name: 'in', fixedPoints: 1 }

  temperature:
    C: { factor: ((x) -> x), name: 'C', fixedPoints: 0 }
    F: { factor: ((x) -> x * 9 / 5 + 32), name: 'F', fixedPoints: 0 }
  speed:
    'm/s': { factor: ((x) -> x), name: 'm/s', fixedPoints: 1 }
    'km/h': { factor: ((x) -> x * 3.6), name: 'km/h', fixedPoints: 1 }
    'mph': { factor: ((x) -> x * 2.23693629), name: 'mph', fixedPoints: 1 }
    'kn': { factor: ((x) -> x * 1.94384449), name: 'kn', fixedPoints: 1 }
}

localTranslations = {
  catch:
    sv: 'fångst'
    en: 'fish'
    ja: '魚'
    es: 'pez'
}

translations = [
  key: 'country'
  method: 'local'
,
  key: 'language'
  method: 'translate'
]

parseSize = (size) ->
  if !/^[\d]+x[\d]+$/.test(size)
    throw new Error("Invalid image size: use WIDTHxHEIGHT, e.g. 128x64")
  [width, height] = size.split('x').map (v) -> parseInt(v, 10)
  { width, height }

exports.registerHelpers = (handlebars, settings = {}) ->

  units = settings.units || {}

  Object.keys(units).forEach (unit) ->
    if !validUnits[unit][units[unit]]?
      throw new Error("The #{unit} unit '#{units[unit]}' is invalid")

  translations.forEach ({ key, method }) ->
    value = settings[key]
    handlebars.registerHelper method, (obj) ->

      if !obj?
        return ""

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
        new handlebars.SafeString(conversion(amount))
      else
        # Round with correct number of decimals. Also: 15.0 kg -> 15 kg
        roundedWithDecimals = conversion.factor(amount).toFixed(conversion.fixedPoints)
        firstDecimal = roundedWithDecimals.slice(-1)
        rounded = if conversion.fixedPoints is 1 and firstDecimal is "0"
          roundedWithDecimals.slice(0, roundedWithDecimals.length - 2)
        else
          roundedWithDecimals
        return rounded + " " + conversion.name

  handlebars.registerHelper 'inWater', (waterName) ->
    inString = settings.translations?.in?[settings.language]

    if !inString?
      throw new Error("No translation available for the string 'in' in the language #{settings.language}")

    if waterName?
      inString + " " + waterName
    else
      ""

  handlebars.registerHelper 'image', (op, size, images) ->

    reqSize = parseSize(size)

    parsedImages = (images || []).map (image) ->
      {width, height} = parseSize(image.size)
      url: image.url
      width: width
      height: height
      pixels: width * height

    sortedImages = parsedImages.sort (a, b) -> a.pixels - b.pixels

    if op == '>='
      filteredImages = sortedImages.filter (image) ->
        image.width >= reqSize.width && image.height >= reqSize.height
      if filteredImages.length == 0
        return sortedImages.slice(-1)[0]?.url
      return filteredImages[0].url
    else if op == '=='
      filteredImages = sortedImages.filter (image) ->
        image.width == reqSize.width && image.height == reqSize.height
      if filteredImages.length == 0
        return null
      return filteredImages[0].url
    else
      throw new Error("Unsupported operator '#{op}'")

  handlebars.registerHelper 'maybe', (a, b) ->
    if a then b else ''

  possifyTable = {
    sv: (name) ->
      lastLetter = name.slice(-1)[0]
      if lastLetter == 's' then name else name + "s"
    en: (name) ->
      lastLetter = name.slice(-1)[0]
      if lastLetter == 's' then name + "'" else name + "'s"
  }

  handlebars.registerHelper 'possify', (name) ->
    if !name?
      return ""

    possifyFunction = possifyTable[settings.language]
    if !possifyFunction
      return name

    output = possifyFunction(name)
    new handlebars.SafeString(output)

  handlebars.registerHelper 'catchTitle', (catchData) ->
    hasWeight = catchData?.weight > 0
    hasLength = catchData?.length > 0
    hasSpecies = catchData?.species?

    if !hasSpecies
      template = "{{translate localTranslations.catch}}"
    else if hasWeight && hasLength
      template = "{{local catch.species}} {{weight catch.weight}} ({{length catch.length}})"
    else if hasWeight
      template = "{{local catch.species}} {{weight catch.weight}}"
    else if hasLength
      template = "{{local catch.species}} {{length catch.length}}"
    else
      template = "{{local catch.species}}"

    template = handlebars.compile(template)
    result = template({
      catch: catchData
      localTranslations: localTranslations
    })
