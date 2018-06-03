'use strict';

require('../stylesheets/index.css');

const snippets = require('../snippets');
const Elm = require('./Main');

const app = Elm.Main.fullscreen();
app.ports.loadSnippet.subscribe(x => app.ports.snippet.send(snippets[x]));
