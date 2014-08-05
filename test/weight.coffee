{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'weight', ->

    beforeEach ->
      @template = "{{weight num}}"
      @context = { num: 5 }

    it 'can convert to kilos', ->
      fishbars.registerHelpers({
        handlebars: handlebars
        weightUnit: 'kg'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '5.0 kgs'

    it 'can convert to pounds', ->
      fishbars.registerHelpers({
        handlebars: handlebars
        weightUnit: 'lb'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '11.0 lbs'

    it 'throws if an invalid unit is given', ->
      f = -> fishbars.registerHelpers({
        handlebars: handlebars
        weightUnit: 'notaunit'
      })
      expect(f).to.throw "The weight unit 'notaunit' is invalid"

    it 'throws on templating if no unit is given', ->
      fishbars.registerHelpers({
        handlebars: handlebars
      })

      template = handlebars.compile(@template)
      f = => template(@context)
      expect(f).to.throw "No valid weight unit configured"
