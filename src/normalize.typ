// This file's job is to normalize an input stream in a few ways that are important
// to Meander. For example:
// - as noted in the longstanding issue #3 (https://github.com/Vanille-N/meander.typ/issues/3),
//   references should be boxed.
// - enumerations should not be left for automatic counting.
// - etc.

#let box-refs(seq) = {
  let ref-accum = []
  for (i, obj) in seq.enumerate() {
    if obj.func() == ref {
      ref-accum += obj
      seq.at(i) = []
    } else if ref-accum != [] and obj.func() == [ ].func() and i + 1 < seq.len() and seq.at(i + 1).func() == ref {
      ref-accum += obj
      seq.at(i) = []
    } else {
      if ref-accum != [] {
        seq.at(i - 1) = box(ref-accum)
        ref-accum = []
      }
    }
  }
  if ref-accum != [] {
    seq.last() = box(ref-accum)
    ref-accum = []
  }
  seq
}

#let count-enums(seq) = {
  let cur-number = 1
  for (i, obj) in seq.enumerate() {
    if obj.func() == enum.item {
      let (body, ..fields) = obj.fields()
      if "number" in fields {
        cur-number = fields.remove("number")
      }
      obj = enum.item(cur-number, body, ..fields)
      seq.at(i) = obj
      cur-number += 1
    } else if obj.func() in ([ ].func(), parbreak) {
      continue
    } else {
      cur-number = 1
    }
  }
  seq
}

#let normalize(seq) = {
  seq = box-refs(seq)
  seq = count-enums(seq)
  seq
}
