{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'optionalWater', ->

    beforeEach ->
      @template = "Something something {{inWater water.name}}"
      @translations = {
        in: {
          sv: 'i'
          en: 'in'
        }
      }

    it 'works in swedish', ->
      fishbars.registerHelpers(handlebars, {
        translations: @translations
        language: 'sv'
      })
      template = handlebars.compile(@template)
      result = template({ water: name: 'dark' })
      expect(result).to.eql 'Something something i dark'

    it 'works in english', ->
      fishbars.registerHelpers(handlebars, {
        translations: @translations
        language: 'en'
      })
      template = handlebars.compile(@template)
      result = template({ water: name: 'dark' })
      expect(result).to.eql 'Something something in dark'

    it 'works without a water', ->
      fishbars.registerHelpers(handlebars, {
        translations: @translations
        language: 'en'
      })
      template = handlebars.compile(@template)
      result = template({ })
      expect(result).to.eql 'Something something '

    it 'yields an error if there is no language', ->
      fishbars.registerHelpers(handlebars, {
        translations: @translations
        language: 'dk'
      })
      template = handlebars.compile(@template)
      f = -> template({ })
      expect(f).to.throw "No translation available for the string 'in' in the language dk"
