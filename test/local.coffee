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

    it 'throws if the requested country is not available', ->
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

