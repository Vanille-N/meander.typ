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

## Threading
- [ ] parameterization of alignment inside boxes
- [ ] hyphenation
  - [ ] language aware
  - [ ] contextual or parameterizable
- [ ] handle paragraph breaks
- [ ] relax upper bounds on text growing vertically
- [ ] line spacing not properly updated when font size changes
- [ ] very small text (4pt) is only ever threaded two lines at a time
- [ ] send content to one specific container

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

