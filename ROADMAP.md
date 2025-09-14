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

## Page segmentation
- [ ] include previous containers when segmenting vertically.
- [ ] layout save slots
  - [ ] save an obstacle for a future invocation
  - [ ] save a filled content box for a future invocation
    - [ ] including configurable margins
  - [ ] overflow to a predefined layout

## Threading
- [X] parameterization of alignment inside boxes
- [X] hyphenation
  - [X] language aware
  - [X] contextual or parameterizable
- [ ] handle paragraph breaks
- [ ] relax upper bounds on text growing vertically
- [X] line spacing not properly updated when font size changes
- [ ] very small text (4pt) is only ever threaded two lines at a time
- [ ] send content to one specific container

## Performance
- [ ] Dichotomy in bisection
- [ ] eliminate obvious non-candidates from tiling
  - [ ] do not use as horizontal marks the obstacles that don't intersect the container

## QoL

- [ ] group displacement
- [ ] inverse retiling (define a container with a complex shape through retiling functions)

## Parameterization

- [ ] do-no-split list
- [ ] full algorithm replacement
  - [ ] tiling
  - [ ] bisection
  - [ ] threading

## Documentation

- [ ] Talk more in depth about overflow options
- [ ] non-doc regular comments about the algorithm
- [ ] Remind that meander can segment an arbitrary container, not just an entire page
- [ ] style-sensitive layout parameters
  - [ ] `text-size`
  - [ ] `text-lang` and `text-hyphenate`

