// This file's job is to normalize an input stream in a few ways that are important
// to Meander. For example:
// - as noted in the longstanding issue #3 (https://github.com/Vanille-N/meander.typ/issues/3),
//   references should be boxed.
// - enumerations should not be left for automatic counting.
// - etc.

#let box-refs(seq) = {
  seq.map(obj => {
    if obj.func() == ref {
      box(obj)
    } else {
      obj
    }
  })
}

#let count-enums(seq) = {
  // TODO: implement the actual transformation
  seq
}

#let normalize(seq) = {
  seq = box-refs(seq)
  seq = count-enums(seq)
  seq
}
