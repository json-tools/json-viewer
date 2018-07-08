# json-viewer

JSON value viewer. [Demo](https://1602.github.io/json-viewer/).

## When to use this module

### Debugging

Alternative to state debugger. In case if you want to see a value, but don't want to write decoder and presentation.

### Presentation of unknown data structures

In the times of continuous delivery we often encounter unknown data structures even on production (think of rich error details object, which may contain information about the context of an error).

## Features

- [x] standard init-update-view API
- [x] expand/collapse of nested values (object, array)
- [x] preview of expandable values
- [x] visual highlight of some JSON values (number, string, null, boolean)
- [x] custom element `<json-viewer value='{ "foo": "bar" }'></json-viewer>`
- [x] preview of object/array with values for collapsed nodes
- [x] display newlines characters as ↵

## Upcoming features

- [ ] configurable appearance
- [ ] display hidden unicode characters
- [ ] configurable pagination for long arrays
- [ ] node operation (copy to clipboard, save as file, etc..)
- [ ] configurable expandable view of long strings
- [ ] configurable preview of media data

## Usage

There are two ways of using this component:

- as custom element (using web-components API)
- as elm library

### Custom element

1. Register custom element
```
<script src="//unpkg.com/json-viewer-custom-element"></script>
```

2. Use in your code, as html
```
<json-viewer value='{ "foo": "bar" }'></json-viewer>
```

Currently there's only one attribute supported: `value` which should be a valid JSON value, more attributes will be added in future releases in order to support additional feature, such as copying node to clipboard. [See demo of web-component usage](http://jsfiddle.net/6w7jfrq5/6/).

3. Customize web component

Example styling using colors from dark theme of chrome devtools

```
--font-family: menlo, monospace;
--preview-background: transparent;
--key-color: #e36eec;
--string-value-color: #e93f3b;
--numeric-value-color: #9980ff;
--null-value-color: #7f7f7f;
--boolean-value-color: #9980ff;
--toggle-color: #bbb;
```

### Elm library

1. Install dependency

```
elm-package install 1602/json-viewer
```

2. Use in your code, as elm component. This component uses standard init-update-view cycle. Check [API documentation](http://package.elm-lang.org/packages/1602/json-viewer/latest) for examples of usage.
