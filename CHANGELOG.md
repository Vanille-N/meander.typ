# Changelog

## v0.3.1 -> dev

### Layout
- new construct: `callback`
- `query` module reworked to be compatible with `callback`-style definitions

### Bugfixes
- #5 appeared again


## v0.3.0 -> v0.3.1

### i18n
- problematic `hy-dro-gen` invocation without appropriate fallback fixed

### Geometry
- panics caused by obstacles and containers that overflow the page

## v0.2.5 -> v0.3.0

### Configuration
- `opt.placement._()` replaces `placement: _`
- `opt.overflow._()` replaces `overflow: _`

### Testing
- improved the test harness organization

## v0.2.4 -> v0.2.5

### Configuration
- changed specification of debug mode
- paved the way for the migration of other options
- `meander.regions` is deprecated

### Tiling
- new overflow option: repeat the last page

### Internals
- `fill-box` linebreaks are configurable

### Bugfixes
- container dimensions resolve relative to the remaining size of the page

## v0.2.3 -> v0.2.4

### Performance
- bisection algorithm now uses dichotomy, some compilation times went from 25s to 3s

### Expressivity
- `internals` module exposes `fill-box` if you need a low-level primitive

### Bugfixes
- `sym.angle.l` wasn't correctly split
- nonmonotonicity in paragraph leading due to `geometry`'s `tolerance`
- compatibility for Typst 0.14 (`angle` deprecated)

### Documentation
- additional README example

## v0.2.2 -> v0.2.3

### Segmentation
- container margin can be customized on all 4 sides
- `anchor` option on `placed` allows controlling where the alignment occurs

### Queries
- new `query` module allows using properties of previous elements during the layout
- obstacles and containers can have labels
- containers have an `invisible` option to ignore some obstacles
- implemented `query.position`
- implemented `query.width`
- implemented `query.height`

### Threading
- added `colfill` as an alternative to `colbreak`

### Convenience
- `reflow` and `regions` no longer crash if passed
  an empty sequence.
- overflow can be saved to a global state
- some error messages improved

### Performance
- better choice of horizontal marks by eliminating obvious failures
- refactored shared code between layout functions

### Bugfix
- overflow preserves styling options

### Documentation
- major rework

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

