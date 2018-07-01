const Elm = require('./JsonViewerCustomElement');
const css = require('../stylesheets/standalone.css').toString();


customElements.define('json-viewer',
    class extends HTMLElement {

        static get observedAttributes() {
            return ['value', 'enable-clipboard'];
        }

        constructor() {
            super();

            const appRoot = document.createElement('div');
            const appStyles = document.createElement('style');
            appStyles.textContent = css;

            const shadowRoot = this.attachShadow({mode: 'open'});
            shadowRoot.appendChild(appStyles);
            shadowRoot.appendChild(appRoot);

            const json = this.getAttribute('value');
            const value = JSON.parse(json);
            const app = Elm.Main.embed(appRoot, value);
            this.app = app;
            // app.ports.loadSnippet.subscribe(x => app.ports.snippet.send(snippets[x]));
        }

        attributeChangedCallback(name, oldValue, newValue) {
            switch (name) {
                case 'value':
                    this.app.ports.valueChange.send(JSON.parse(newValue));
                    break;
            }
        }
});
