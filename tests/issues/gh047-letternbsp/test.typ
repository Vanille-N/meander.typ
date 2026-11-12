#import "/src/lib.typ" as meander

#set page(width: 3.5cm, height: 8cm, margin: 5mm)
#set par(justify: true)
#set text(lang: "en", hyphenate: true)

#meander.reflow({
  import meander: *
  opt.debug.post-thread()
  container(width: 100%, height: 38pt)
  container(width: 100%, height: 100%)
  content[It was in a~big house of a~man who lived by a~sea, and a~storm came in a~night. It was in a~big house of a~man who lived by a~sea, and a~storm came in a~night. It was in a~big house of a~man who lived by a~sea, and a~storm came in a~night. ]
})
