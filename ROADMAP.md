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
- [ ] improper justification when the split occurs in a sequence rather than in a `has-text`.
- [ ] can't measure a `ref`

## Page segmentation
- [ ] layout save slots
  - [ ] save an obstacle for a future invocation
  - [ ] save a filled content box for a future invocation
    - [ ] including configurable margins
  - [ ] overflow to a predefined layout
- [ ] automatically order obstacles before containers, except if there are labels
- [ ] optimize the rectangles in ascii (need fewer of them for performance)
  - [ ] rotate + flip ascii map
- [ ] adjust container default width + height to only take the remaining space, not 100%
- [X] new overflow option: repeat
- [ ] template("name") to include parts of a previously defined layout
- [ ] validate compatibility between placement and overflow

## Threading
- [ ] handle paragraph breaks
- [ ] relax upper bounds on text growing vertically
- [ ] very small text (4pt) is only ever threaded two lines at a time
- [ ] send content to one specific container
- [ ] priority levels to fill boxes in a different order than they were defined

## Performance
- [ ] don't rebuild the entire array all the time

## QoL

- [ ] group displacement
- [ ] group labeling
- [ ] inverse retiling (define a container with a complex shape through retiling functions)
- [ ] define styles based on labels
- [ ] retiling function by concatenating two others
- [ ] set-container, set-placed, set-content

## Parameterization

- [ ] do-no-split list
- [ ] full algorithm replacement
  - [ ] tiling
  - [ ] bisection
  - [ ] threading

## Testing

- [ ] continuous testing setup for regressions on fixed issues
- [ ] `exact` is now useless thanks to tiling improvements

## Refactoring

## Documentation

- [ ] non-doc regular comments about the algorithm
- [ ] Remind that meander can segment an arbitrary container, not just an entire page

