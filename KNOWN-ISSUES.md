# Roadmap and known issues

## Content segmentation
- [ ] improve `list.item`
  - [ ] correct indentation
  - [ ] parameterize bullet
- [ ] improve `enum.item`
  - [ ] correct indentation
  - [ ] fix and parameterize numbering pattern
- [ ] properly split vertical spaces

## Page segmentation
- [ ] include previous containers when segmenting vertically.
- [ ] do not use as horizontal marks the obstacles that don't intersect the container
- [ ] handle multipage setups

## Threading
- [X] boxes must not stretch beyond containers
- [ ] parameterization of alignment inside boxes
- [ ] justification
  - [X] working baseline
  - [ ] content broken by `[ ]`
- [ ] hyphenation
- [ ] handle paragraph breaks
- [ ] relax upper bounds on text growing vertically
- [ ] line spacing not properly updated when font size changes ?

## QoL

- [X] phantom placed objects that do not count as obstacles
- [ ] group displacement
- [X] retiling functions
  - [X] horizontal
  - [X] vertical
  - [X] grid
- [ ] inverse retiling (define a container with a complex shape through retiling functions)

## Parameterization

- [ ] obstacle margin
- [ ] do-no-split list
- [ ] full algorithm replacement
  - [ ] tiling
  - [ ] bisection
  - [ ] threading

## Documentation

- [ ] retiling functions
  - [ ] tutorial
  - [ ] doc comments

