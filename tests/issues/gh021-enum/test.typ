#import "/src/lib.typ" as meander

#meander.reflow({
	import meander: *

	placed(top+right, rect(width: 6cm, height: 3cm, fill:red ))

	container()

	content[
		#enum(
			lorem(30),
			lorem(30),
		)
	]
})
