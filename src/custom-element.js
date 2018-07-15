const Elm = require('./JsonViewerCustomElement');
const css = require('../stylesheets/standalone.css').toString();


customElements.define('json-viewer',
    class extends HTMLElement {

        static get observedAttributes() {
            return ['value', 'expanded-nodes', 'enable-clipboard'];
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
            const expandedNodes = this.hasAttribute('expanded-nodes') ? JSON.parse(this.getAttribute('expanded-nodes')) : [];
            const app = Elm.Main.embed(appRoot, { value, expandedNodes });
            this.app = app;
        }

        attributeChangedCallback(name, oldValue, newValue) {
            switch (name) {
                case 'value':
                    if (oldValue !== newValue) {
                        this.app.ports.valueChange.send(JSON.parse(newValue));
                    }
                    break;

                case 'expanded-nodes':
                    if (oldValue !== newValue) {
                        this.app.ports.expandedNodesChange.send(JSON.parse(newValue));
                    }
                    break;
            }
        }
});
