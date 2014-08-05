validWeightUnits = ['kg', 'lb']
validLengthUnits = ['m', 'ft']

contains = (array, element) ->
  array.indexOf(element) != -1

exports.registerHelpers = ({
  handlebars
  language
  weightUnit
  lengthUnit
}) ->

  if weightUnit? && !contains(validWeightUnits, weightUnit)
    throw new Error("The weight unit '#{weightUnit}' is invalid")

  if lengthUnit? && !contains(validLengthUnits, lengthUnit)
    throw new Error("The length unit '#{lengthUnit}' is invalid")

  handlebars.registerHelper 'translate', (obj) ->
    if !language?
      throw new Error("No language configured")

    if obj[language]?
      obj[language]
    else
      throw new Error("No translation available for the language #{language}")

  handlebars.registerHelper 'weight', (kilos) ->
    if weightUnit == 'kg'
      return (kilos).toFixed(1) + " kgs"
    if weightUnit == 'lb'
      return (kilos*2.20462262).toFixed(1) + " lbs"
    throw new Error("No valid weight unit configured")

  handlebars.registerHelper 'length', (meters) ->
    if lengthUnit == 'm'
      return (meters).toFixed(2) + " m"
    if lengthUnit == 'ft'
      return (meters*3.2808399).toFixed(2) + " ft"
    throw new Error("No valid length unit configured")
