{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'speed', ->

    beforeEach ->
      @template = "{{speed num}}"
      @context = { num: 5 }

    it 'can convert to m/s', ->
      fishbars.registerHelpers(handlebars, {
        units: speed: 'm/s'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '5.0 m/s'

    it 'can convert to km/h', ->
      fishbars.registerHelpers(handlebars, {
        units: speed: 'km/h'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '18.0 km/h'

    it 'can convert to mph', ->
      fishbars.registerHelpers(handlebars, {
        units: speed: 'mph'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '11.2 mph'

    it 'can convert to kn', ->
      fishbars.registerHelpers(handlebars, {
        units: speed: 'kn'
      })

      template = handlebars.compile(@template)
      result = template(@context)
      expect(result).to.eql '9.7 kn'

    it 'throws if an invalid unit is given', ->
      f = -> fishbars.registerHelpers(handlebars, {
        units: speed: 'notaunit'
      })
      expect(f).to.throw "The speed unit 'notaunit' is invalid"

    it 'throws on templating if no unit is given', ->
      fishbars.registerHelpers(handlebars, {})

      template = handlebars.compile(@template)
      f = => template(@context)
      expect(f).to.throw "No valid speed unit configured"
