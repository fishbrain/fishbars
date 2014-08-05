{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'translations', ->

    beforeEach ->
      @template = "{{translate greet}} {{name}}"
      @context = { name: 'jakob', greet: { se: 'hej', en: 'hi' } }

    it 'can translate to swedish', ->
      fishbars.registerHelpers({
        handlebars: handlebars
        language: 'se'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql 'hej jakob'


    it 'can translate to english', ->
      fishbars.registerHelpers({
        handlebars: handlebars
        language: 'en'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql 'hi jakob'

    it 'throws if the requested language is not available', ->
      fishbars.registerHelpers({
        handlebars: handlebars
        language: 'dk'
      })

      template = handlebars.compile(@template)
      f = => template(@context)
      expect(f).to.throw "No translation available for the language dk"
