#import "/src/lib.typ" as meander

#let title-text = text(size: 20pt, fill: red)[*Talmudifier Test Page*]

#let left-text = [
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis vehicula ligula at est bibendum, in eleifend erat dictum. Etiam sit amet tellus id ex ullamcorper faucibus. Suspendisse sed elit vel neque convallis iaculis id in urna. Sed tincidunt varius ipsum at scelerisque. Phasellus lacus lectus, sodales sit amet orci in, rutrum malesuada diam. Cras pulvinar elit sit amet lacus fringilla, in elementum mauris maximus. Phasellus euismod dolor sed pretium elementum. Nulla sagittis, elit eget semper porttitor, erat nunc commodo turpis, et bibendum ex lorem laoreet ipsum. Morbi auctor dignissim velit eget consequat. R. Seth: Blah blah blah blah. As it is written: "Aecenas lacinia nisi diam, vel pulvinar metus aliquet ut. Sed non lorem quis dui ultrices volutpat quis at diam."=Lorem&1:23 Quisque at nisi magna. Duis nec lacus arcu. Morbi vel fermentum leo. Pellentesque hendrerit sagittis vulputate. Fusce laoreet malesuada odio, sit amet fringilla lectus ultrices porta. Aliquam feugiat finibus turpis id malesuada. Suspendisse hendrerit eros sit amet tempor pulvinar. Duis velit mauris, facilisis ut tincidunt sed, pharetra eu libero. Aenean lobortis tincidunt nisi. Praesent metus lacus, tristique sed porta non, tempus id quam. Lא I use these red Hebrew letters in my own WIP project along with various other font changes... You might find this funcitonality useful. R. Alter: I strongly disgree with you, and future readers of this will have to comb through pages upon pages of what might as well be lorem ipsum to figure out why we're dunking on each other so much. As it is written: "Sed ut eros id arcu tincidunt accumsan. Vestibulum vitae nisl blandit, commodo odio vitae, dictum nunc. Suspendisse pharetra lorem vitae ex tincidunt ornare. Maecenas efficitur tristique libero, eget commodo urna. Pellentesque libero sem, interdum ut nibh interdum, consequat elementum magna."=Ipsum&69:420 Lב Aliquam facilisis vel turpis eu semper. Donec eget purus lectus. -> Check out how nice that little hand looks. Nice. -> Fusce porta pretium diam. Etiam venenatis nisl nec tempus fringilla. Vivamus vehicula nunc sed libero scelerisque viverra a quis libero. Integer ac urna ut lectus faucibus mattis ac id nunc. Morbi fermentum magna dui, at rhoncus nibh porttitor quis. Donec dui ante, semper non quam at, accumsan volutpat leo. Maecenas magna risus, finibus sit amet felis ut, vulputate euismod nunc.
  #linebreak(justify: true)
]

#let center-text = [
  Quisque at nisi magna. Duis nec lacus arcu. Morbi vel fermentum leo. Pellentesque hendrerit sagittis vulputate. Fusce laoreet malesuada odio, sit amet fringilla lectus ultrices porta. Aliquam feugiat finibus turpis id malesuada. Lא Suspendisse hendrerit eros sit amet tempor pulvinar. Duis velit mauris, facilisis ut tincidunt sed, pharetra eu libero. Aenean lobortis tincidunt nisi. Lב Praesent metus lacus, tristique sed porta non, tempus id quam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Rא In eu porta velit, quis pellentesque elit. Rב Quisque vehicula massa sit amet justo rhoncus auctor.
  #linebreak(justify: true)
]

#let right-text = [
  Aenean sed dolor suscipit, dignissim nisl at, blandit eros. Pellentesque scelerisque viverra ligula, vel congue lorem semper non. Nulla nec convallis neque. Donec ut leo velit. Donec felis odio, tincidunt non vestibulum ut, consectetur eget lectus. Donec varius finibus scelerisque. Aliquam nisl odio, sollicitudin eget sem non, tincidunt tempor felis. Curabitur et ullamcorper lacus. Cras eu ante quis arcu dictum ultrices. Proin vel ante quis elit sollicitudin auctor. Nullam ultricies tempor neque, varius scelerisque neque. Nam et arcu ut odio maximus tempor et sit amet elit. Rא Morbi fermentum dapibus elementum. Proin id metus ipsum. Aenean posuere nunc quis lacus varius, eget molestie mauris accumsan. | Fusce sapien ipsum, cursus a tincidunt vel, dignissim eu mi. Morbi id velit ac turpis ullamcorper lacinia. | Cras bibendum tellus vitae eros rutrum scelerisque. Vivamus sed pellentesque elit, non imperdiet massa. Curabitur dictum nisi sollicitudin luctus malesuada. Vestibulum id pulvinar risus, sit amet ornare libero. Etiam a nunc dolor. Rב In ac velit maximus, elementum ex et, blandit massa. Aliquam vehicula at neque sit amet ultrices. Integer id justo est. Quisque luctus erat eget aliquam faucibus. Etiam eu mi ac odio pretium dictum. Vestibulum viverra congue risus, ac egestas est dapibus eget. Aenean ut orci leo. Nulla dignissim erat pulvinar elit facilisis, ac venenatis leo tincidunt. Quisque eu lorem tortor. Quisque nec porttitor elit. Ut finibus ullamcorper odio, in porttitor lorem suscipit ut.
  #linebreak(justify: true)
]

#set text(hyphenate: true)
#set par(justify: true)
#set page(margin: 2cm)

#let title-box = box(width: 100%, inset: 5mm,  align(center, title-text))
#let center-box = box(width: 5cm, center-text)

#meander.reflow({
  import meander: *
  //opt.debug.post-thread()
  placed(top, title-box)
  placed(
    center,
    dy: 4cm,
    boundary: contour.margin(5mm),
    center-box,
  )
  container(align: right, width: 48%)
  container()

  content(right-text)
  colbreak()
  content(left-text)
})

