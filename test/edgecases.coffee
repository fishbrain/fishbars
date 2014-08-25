{expect} = require 'chai'
jscov = require 'jscov'
handlebars = require 'handlebars'
fishbars = require jscov.cover('..', 'src', 'index')

describe 'fishbars', ->

  it 'does not crash if not given a configration', ->
    fishbars.registerHelpers(handlebars)
    template = handlebars.compile("hi {{name}}")
    result = template({ name: 'Jakob' })
    expect(result).to.eql 'hi Jakob'
