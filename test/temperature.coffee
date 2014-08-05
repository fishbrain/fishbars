{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'temperature', ->

    beforeEach ->
      @template = "{{temperature num}}"
      @context = { num: 5 }

    it 'can convert to celcius', ->
      fishbars.registerHelpers({
        handlebars: handlebars
        units: temperature: 'C'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '5 C'

    it 'can convert to fahrenheit', ->
      fishbars.registerHelpers({
        handlebars: handlebars
        units: temperature: 'F'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '41 F'

    it 'throws if an invalid unit is given', ->
      f = -> fishbars.registerHelpers({
        handlebars: handlebars
        units: temperature: 'notaunit'
      })
      expect(f).to.throw "The temperature unit 'notaunit' is invalid"

    it 'throws on templating if no unit is given', ->
      fishbars.registerHelpers({
        handlebars: handlebars
      })

      template = handlebars.compile(@template)
      f = => template(@context)
      expect(f).to.throw "No valid temperature unit configured"
