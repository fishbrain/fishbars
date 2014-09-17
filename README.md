[![Build Status](https://travis-ci.org/fishbrain/fishbars.svg?branch=master)](https://travis-ci.org/fishbrain/fishbars)
[![Coverage Status](https://coveralls.io/repos/fishbrain/fishbars/badge.png?branch=master)](https://coveralls.io/r/fishbrain/fishbars?branch=master)


# fishbars

Helpers for Handlebars templates used at FishBrain



### Installation

`npm install fishbars`



### Getting started

    var handlebars = require("handlebars");
    var fishbars = require("fishbars");

    fishbars.registerHelpers(handlebars, {
      language: 'sv'
    });

    var template = handlebars.compile("{{translate greeting}} {{name}}");
    var result = template({ name: 'jakob', greeting: { sv: 'hej', en: 'hi' } });

    console.log(result); // hej jakob



### Features

There are five functions:

    translate
    weight
    length
    temperature
    speed

Translate is used as in the "getting started"-example above. Given a string as `language` in `registerHelpers`, that key is looked up when `translate` is called on an object in the template. You can use any language code you want; to the function it's just a key in a lookup.

The remaining four functions are used to convert a number (given in SI-units) to a string representation in the configured unit, including the unit abbreviation. For example, getting my length in feet would go like this:

    var handlebars = require("handlebars");
    var fishbars = require("fishbars");

    fishbars.registerHelpers(handlebars, {
      units: {
        weight: 'lb'
      }
    });

    var template = handlebars.compile("{{name}} is {{length myLength}} tall");
    var result = template({ name: 'jakob', myLength: 1.81 }); // note that length is given in meters

    console.log(result); // Jakob is 5.94 ft tall

The full configuration would look like this:

    fishbars.registerHelpers(handlebars, {
      language: 'sv',
      units: {
        weight: 'kg',     // or 'lb'
        length: 'm',      // or 'ft'
        temperature: 'C', // or 'F'
        speed: 'm/s'      // or 'km/h' or 'mph' or 'kn'
      }
    });



### Developing

Make sure you have node installed. Running `node -v` should give you v0.10.29 or above.

Run `npm install` to install the dependencies of the project.

Run `npm test` to run all the tests. It will also show you the test coverage on completion.

You can run a subset of the tests using `TESTS="some pattern" npm test`, where the pattern is matched to the names of the tests.

In order to release a new version of the library, run `make release VERSION=x.x.x`. Your package file, git tags, coveralls and the global npm repository will all automatically be updated (but only if the tests pass, your working tree is clean and if you're on the right branch - master of course).
