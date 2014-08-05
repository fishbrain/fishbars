validWeightUnits = ['kg', 'lb']

contains = (array, element) ->
  array.indexOf(element) != -1

exports.registerHelpers = ({
  handlebars
  language
  weightUnit
}) ->

  if weightUnit? && !contains(validWeightUnits, weightUnit)
    throw new Error("The weight unit '#{weightUnit}' is invalid")

  handlebars.registerHelper 'translate', (obj) ->
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
