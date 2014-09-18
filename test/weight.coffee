{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'weight', ->

    beforeEach ->
      @template = "{{weight num}}"
      @verify = (unit, num, expectancy) ->
        fishbars.registerHelpers(handlebars, {
          units: weight: unit
        })
        template = handlebars.compile(@template)
        result = template({ num })
        expect(result).to.eql expectancy

    it 'can convert to kilos', ->
      @verify('kg', 5, '5.0 kg')

    it 'can convert to pounds, without oz', ->
      @verify('lb', 5, '11 lbs')

    it 'can convert to pounds, with oz', ->
      @verify('lb', 2.01281614, '4 lbs 7 oz')

    it 'throws if an invalid unit is given', ->
      f = -> fishbars.registerHelpers(handlebars, {
        units: weight: 'notaunit'
      })
      expect(f).to.throw "The weight unit 'notaunit' is invalid"

    it 'throws on templating if no unit is given', ->
      fishbars.registerHelpers(handlebars, {})

      template = handlebars.compile(@template)
      f = => template({ num: 5 })
      expect(f).to.throw "No valid weight unit configured"
