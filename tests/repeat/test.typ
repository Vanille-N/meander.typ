#import "/src/lib.typ" as meander

#meander.reflow(
  overflow: repeat,
  {
    import meander: *
    container(width: 60%)
    container()
    content[#lorem(2000)]
  },
)
