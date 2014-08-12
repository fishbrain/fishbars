{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'length', ->

    beforeEach ->
      @template = "{{length num}}"
      @context = { num: 5 }

    it 'can convert to meters', ->
      fishbars.registerHelpers(handlebars, {
        units: length: 'm'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '5.00 m'

    it 'can convert to feet', ->
      fishbars.registerHelpers(handlebars, {
        units: length: 'ft'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '16.40 ft'

    it 'throws if an invalid unit is given', ->
      f = -> fishbars.registerHelpers(handlebars, {
        units: length: 'notaunit'
      })
      expect(f).to.throw "The length unit 'notaunit' is invalid"

    it 'throws on templating if no unit is given', ->
      fishbars.registerHelpers(handlebars, {})

      template = handlebars.compile(@template)
      f = => template(@context)
      expect(f).to.throw "No valid length unit configured"
