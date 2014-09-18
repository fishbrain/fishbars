{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  describe 'local', ->

    verify = (data, output) ->
      fishbars.registerHelpers(handlebars, {
        language: 'sv'
        country: 'SE'
        units:
          weight: 'kg'
          length: 'm'
      })

      template = handlebars.compile("{{catchTitle data}}")
      result = template({ data: data })
      expect(result).to.eql output

    it 'produces a default value if there is null data', ->
      verify(null, 'fångst')

    it 'produces a default value if there is empty data', ->
      verify({}, 'fångst')

    it 'produces a default value if there is no species', ->
      verify({ weight: 1, length: 1 }, 'fångst')

    it 'produces the name of the species, if that is all there is', ->
      verify({ species: { SE: 'Gädda', GB: 'Pike' } }, 'Gädda')

    it 'produces name, length and weight if all are given', ->
      verify({ species: { SE: 'Gädda', GB: 'Pike' }, weight: 1, length: 1 }, 'Gädda 1.0 kg, 100 cm')

    it 'produces name and length if no weight is given', ->
      verify({ species: { SE: 'Gädda', GB: 'Pike' }, length: 1 }, 'Gädda 100 cm')

    it 'produces name and weight if no length is given', ->
      verify({ species: { SE: 'Gädda', GB: 'Pike' }, weight: 1 }, 'Gädda 1.0 kg')
