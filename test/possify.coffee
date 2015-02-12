{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'possify', ->

    beforeEach ->
      @template = "{{possify actor.name}} abc"
      @verify = (lang, actor, output) =>
        fishbars.registerHelpers(handlebars, {
          language: lang
        })
        template = handlebars.compile(@template)
        result = template({ actor: name: actor })
        expect(result).to.eql output


    it 'works in swedish for words that does not end with s', ->
      @verify('sv', 'Jakob', "Jakobs abc")

    it 'works in english for words that does not end with s', ->
      @verify('en', 'Jakob', "Jakob's abc")

    it 'works in swedish for words that ends with s', ->
      @verify('sv', 'Jens', "Jens abc")

    it 'works in english for words that ends with s', ->
      @verify('en', 'Jens', "Jens' abc")

    it 'defaults to just the name if the language is not implemented', ->
      @verify('non-existing-language', 'Jakob', "Jakob abc")

    it 'outputs empty string if the input is non-existent', ->
      fishbars.registerHelpers(handlebars, {
        language: 'sv'
      })
      template = handlebars.compile(@template)
      result = template({ })
      expect(result).to.eql ' abc'
