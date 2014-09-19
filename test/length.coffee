{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'length', ->

    beforeEach ->
      @template = "{{length num}}"
      @verify = (unit, num, expectancy) ->
        fishbars.registerHelpers(handlebars, {
          units: length: unit
        })
        template = handlebars.compile(@template)
        result = template({ num })
        expect(result).to.eql expectancy

    it 'can convert to meters', ->
      @verify('m', 5, '500 cm')

    it 'can convert to feet including decimals', ->
      @verify('ft', 5, '196 ¾ in')

    it 'can convert to feet without decimals', ->
      @verify('ft', 5.03, '198 in')

    it 'can convert to feet when rounding up from ¾ to a whole', ->
      @verify('ft', 0.38, '15 in')

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
