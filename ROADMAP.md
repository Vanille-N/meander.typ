# Roadmap and known issues

## Content segmentation
- [ ] improve `list.item`
  - [ ] correct indentation
  - [ ] parameterize bullet
  - [ ] known bug: show rule depth exceeded when an item gets split too many times
- [ ] improve `enum.item`
  - [ ] correct indentation
  - [ ] fix and parameterize numbering pattern
  - [ ] known bug: show rule depth exceeded when an item gets split too many times
- [ ] properly split vertical spaces
- [ ] path thought unreachable can be hit during hyphenation calcs
- [ ] single word on line will overflow if box is too small
- [ ] raw code seems to possibly trigger an assertion error
- [ ] crashes when we try to `split-word` a `sym.angle.l`
- [ ] improper justification when the split occurs in a sequence rather than in a `has-text`.

## Page segmentation
- [ ] layout save slots
  - [ ] save an obstacle for a future invocation
  - [ ] save a filled content box for a future invocation
    - [ ] including configurable margins
  - [ ] overflow to a predefined layout
- [ ] automatically order obstacles before containers, except if there are labels
- [ ] container margin 4 directions
- [ ] optimize the rectangles in ascii (need fewer of them for performance)
  - [ ] rotate + flip ascii map
- [X] added `anchor` to placed

## Threading
- [ ] handle paragraph breaks
- [ ] relax upper bounds on text growing vertically
- [ ] very small text (4pt) is only ever threaded two lines at a time
- [ ] send content to one specific container
- [ ] priority levels to fill boxes in a different order than they were defined
- [X] colfill
  - [X] check for maybe bug: does colfill properly fill the current container ?
- [X] apply styles to structured overflow
- [X] save overflow to state

## Performance
- [ ] Dichotomy in bisection (?)

## QoL

- [ ] group displacement
- [ ] group labeling
- [ ] inverse retiling (define a container with a complex shape through retiling functions)
- [ ] define styles based on labels
- [ ] retiling function by concatenating two others
- [ ] use default `()` if reflow receives `none`.

## Parameterization

- [ ] do-no-split list
- [ ] full algorithm replacement
  - [ ] tiling
  - [ ] bisection
  - [ ] threading

## Refactoring
- [X] extract regions and reflow's `wrapper`.

## Documentation

- [ ] obstacle labels
- [ ] use latest updates to simplify the README examples a bit
- [ ] non-doc regular comments about the algorithm
- [ ] Remind that meander can segment an arbitrary container, not just an entire page
- [X] example of colbreak vs colfill

