# Changelog

## v0.2.2 -> dev

### Segmentation
- obstacles have labels and containers have an `invisible` field

### Performance
- better choice of horizontal marks by eliminating obvious failures

## v0.2.1 -> v0.2.2

### Bisection
- now capable of splitting links and aligned content
- hyphenation now auto-detects the language
- parameters can be passed to `content` to update the style locally

### Segmentation
- hack to solve the issue where a single `container` on the page will overflow vertically
- `colbreak` jumps to the next container
- full containers now count as obstacles to other containers
- containers have a configurable margin

### Threading
- box spacing now respects `text.size` and `par.leading`.
- styling options can be passed to `container` to apply alignment and color post-hoc
- placement options can control the relationship to other content on the page

### Internal
- tiling algorithm is now interactive, which will enable more complex layouts in the future

### Bugfix
- "unreachable" path was hit

## v0.2.0 -> v0.2.1

### Segmentation
- layout can now span multiple pages
- configurable warning when the text overflows the container
- margin around an obstacle can be configured independently for the 4 directions

### Display
- option to hide obstacles (`display: false`)

### Documentation
- ASCII art option added
- general improvements in the docs and more examples

## v0.1.0 -> v0.2.0

### Syntax
- changed to use code instead of content

### Obstacle control
- retiling functions added to control the precise boundaries of obstacles
- margin around obstacles is now parameterizable
- phantom objects that do not count as obstacles

### Typesetting
- contextually correct justified text
- experimental support for hyphenation

