{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'translations', ->

    beforeEach ->
      @template = "{{translate greet}} {{name}}"
      @context = { name: 'jakob', greet: { sv: 'hej', en: 'hi' } }

    it 'can translate to swedish', ->
      fishbars.registerHelpers(handlebars, {
        language: 'sv'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql 'hej jakob'

    it 'can translate to english', ->
      fishbars.registerHelpers(handlebars, {
        language: 'en'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql 'hi jakob'

    it 'throws if the requested language is not available', ->
      fishbars.registerHelpers(handlebars, {
        language: 'dk'
      })

      template = handlebars.compile(@template)
      f = => template(@context)
      expect(f).to.throw "No translation available for the language dk"

    it 'throws on templating if no language is assigned', ->
      fishbars.registerHelpers(handlebars, {})

      template = handlebars.compile(@template)
      f = => template(@context)
      expect(f).to.throw "No language configured"

