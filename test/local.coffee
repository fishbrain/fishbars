{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'local', ->

    beforeEach ->
      @template = "{{local holidayGreet}} {{name}}"
      @context = { name: 'Jakob', holidayGreet: { us: 'Merry Christmas', uk: 'Happy Christmas' } }

    it 'can translate to uk english', ->
      fishbars.registerHelpers(handlebars, {
        country: 'uk'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql 'Happy Christmas Jakob'

    it 'can translate to american english', ->
      fishbars.registerHelpers(handlebars, {
        country: 'us'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql 'Merry Christmas Jakob'

    it 'uses the *-country if the requested language is not available', ->
      fishbars.registerHelpers(handlebars, {
        country: 'dk'
      })

      template = handlebars.compile(@template)
      result = template({ name: 'Jakob', holidayGreet: { us: 'Merry Christmas', uk: 'Happy Christmas', '*': 'No Christmas for you' } })
      expect(result).to.eql 'No Christmas for you Jakob'

    it 'skips the localized part of string if there is no data to translate', ->
      fishbars.registerHelpers(handlebars, {
        country: 'dk'
      })

      template = handlebars.compile(@template)
      result = template({ name: 'Jakob' })
      expect(result).to.eql ' Jakob'

    it 'throws if the requested country is not available and there is no fallback', ->
      fishbars.registerHelpers(handlebars, {
        country: 'dk'
      })

      template = handlebars.compile(@template)
      f = => template(@context)
      expect(f).to.throw "No translation available for the country dk"

    it 'throws on templating if no language is assigned', ->
      fishbars.registerHelpers(handlebars, {})

      template = handlebars.compile(@template)
      f = => template(@context)
      expect(f).to.throw "No country configured"

