exports.registerHelpers = ({
  handlebars
  language
}) ->

  handlebars.registerHelper 'translate', (obj) ->
    if obj[language]?
      obj[language]
    else
      throw new Error("No translation available for the language #{language}")
