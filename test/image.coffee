{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'image', ->

    describe '>=', ->

      it 'returns empty string if there are no images', ->
        fishbars.registerHelpers(handlebars)
        template = handlebars.compile("{{image '>=' '200x300' data.pics}}")
        result = template({ data: pics: [] })
        expect(result).to.eql ""

      it 'returns the image fulfilling the requirments if one does and do not', ->
        fishbars.registerHelpers(handlebars)
        template = handlebars.compile("{{image '>=' '200x300' data.pics}}")
        result = template({ data: pics: [{
          size: '64x64'
          url: 'p1.png'
        }, {
          size: '640x640'
          url: 'p2.png'
        }] })
        expect(result).to.eql 'p2.png'

      it 'returns the smallest image fulfilling the requirments if both do', ->
        fishbars.registerHelpers(handlebars)
        template = handlebars.compile("{{image '>=' '200x300' data.pics}}")
        result = template({ data: pics: [{
          size: '400x400'
          url: 'p1.png'
        }, {
          size: '640x640'
          url: 'p2.png'
        }] })
        expect(result).to.eql 'p1.png'

      it 'returns the the largest image if none fulfils the requirments', ->
        fishbars.registerHelpers(handlebars)
        template = handlebars.compile("{{image '>=' '200x300' data.pics}}")
        result = template({ data: pics: [{
          size: '40x40'
          url: 'p1.png'
        }, {
          size: '64x64'
          url: 'p2.png'
        }] })
        expect(result).to.eql 'p2.png'

    it 'throws an error if an unsupported operator is used', ->
      fishbars.registerHelpers(handlebars)
      f = -> handlebars.compile("{{image '>' '200x300' data.pics}}")()
      expect(f).to.throw "Unsupported operator '>'"

    it 'throws an error if an invalid image size is specified', ->
      fishbars.registerHelpers(handlebars)
      f = -> handlebars.compile("{{image '>' '200300' data.pics}}")()
      expect(f).to.throw "Invalid image size: use WIDTHxHEIGHT, e.g. 128x64"

    it 'returns empty string if there is no data', ->
      fishbars.registerHelpers(handlebars)
      template = handlebars.compile("{{image '>=' '200x300' data.pics}}")
      result = template({ })
      expect(result).to.eql ""

    describe '==', ->

      it 'returns empty string if there are no images', ->
        fishbars.registerHelpers(handlebars)
        template = handlebars.compile("{{image '==' '200x300' data.pics}}")
        result = template({ data: pics: [] })
        expect(result).to.eql ""

      it 'returns the image fulfilling the requirments if one does and do not', ->
        fishbars.registerHelpers(handlebars)
        template = handlebars.compile("{{image '==' '200x300' data.pics}}")
        result = template({ data: pics: [{
          size: '64x64'
          url: 'p1.png'
        }, {
          size: '200x300'
          url: 'p2.png'
        }] })
        expect(result).to.eql 'p2.png'

      it 'returns the first image fulfilling the requirments if both do', ->
        fishbars.registerHelpers(handlebars)
        template = handlebars.compile("{{image '==' '200x300' data.pics}}")
        result = template({ data: pics: [{
          size: '200x300'
          url: 'p1.png'
        }, {
          size: '200x300'
          url: 'p2.png'
        }] })
        expect(result).to.eql 'p1.png'

      it 'returns empty string if none fulfils the requirments', ->
        fishbars.registerHelpers(handlebars)
        template = handlebars.compile("{{image '==' '200x300' data.pics}}")
        result = template({ data: pics: [{
          size: '40x40'
          url: 'p1.png'
        }, {
          size: '64x64'
          url: 'p2.png'
        }] })
        expect(result).to.eql ''
