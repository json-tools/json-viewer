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

## Upcoming features

- [ ] highlight space characters (tab, newline, etc..)
- [ ] display hidden unicode characters
- [ ] configurable pagination for long arrays
- [ ] node operation (copy to clipboard, save as file, etc..)
- [ ] configurable expandable view of long strings
- [ ] configurable preview of media data
