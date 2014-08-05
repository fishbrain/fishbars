# fishbars

Helpers for Handlebars templates used at FishBrain



### Installation

`npm install fishbars`



### Getting started

	var handlebars = require("handlebars");
	var fishbars = require("fishbars");

	fishbars.registerHelpers({
	  handlebars: handlebars,
	  language: 'se'
	});

    var template = handlebars.compile("{{translate greet}} {{name}}");
    var result = template({ name: 'jakob', greet: { se: 'hej', en: 'hi' } });

    console.log(result); // hej jakob



### Developing

Make sure you have node installed. Running `node -v` should give you v0.10.29 or above.

Run `npm install` to install the dependencies of the project.

Run `npm test` to run all the tests. It will also show you the test coverage on completion.

You can run a subset of the tests using `TESTS="some pattern" npm test`, where the pattern is matched to the names of the tests.

In order to release a new version of the library, run `make release VERSION=x.x.x`. Your package file, git tags, coveralls and the global npm repository will all automatically be updated (but only if the tests pass, your working tree is clean and if you're on the right branch - master of course).
