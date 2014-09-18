{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'maybe', ->

    beforeEach ->
      @template = """Caught{{maybe water.name " in "}}{{water.name}}: Gädda"""

    it 'works given an actual value', ->
      fishbars.registerHelpers(handlebars, {})
      template = handlebars.compile(@template)
      result = template({ water: name: 'Mälaren' })
      expect(result).to.eql 'Caught in Mälaren: Gädda'

    it 'works when the property is missing', ->
      fishbars.registerHelpers(handlebars, {})
      template = handlebars.compile(@template)
      result = template({ water: {} })
      expect(result).to.eql 'Caught: Gädda'

    it 'works when all the data is missing', ->
      fishbars.registerHelpers(handlebars, {})
      template = handlebars.compile(@template)
      result = template({ })
      expect(result).to.eql 'Caught: Gädda'
