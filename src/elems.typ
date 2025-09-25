#import "std.typ"

/// Core function to create an obstacle.
/// -> obstacle
#let placed(
  /// Reference position on the page (or in the parent container).
  /// -> alignment
  align,
  /// Horizontal displacement.
  /// -> relative
  dx: 0% + 0pt,
  /// Vertical displacement.
  /// -> relative
  dy: 0% + 0pt,
  /// An array of functions to transform the bounding box of the content.
  /// By default, a 5pt margin.
  /// See `contour.typ` for a list of available functions.
  /// -> (..function,)
  boundary: (auto,),
  /// Whether the obstacle is shown.
  /// Useful for only showing once an obstacle that intersects several invocations.
  /// Contrast the following:
  /// - `boundary: contour.phantom` will display the object without using it as an obstacle,
  /// - `display: false` will use the object as an obstacle but not display it.
  /// -> bool
  display: true,
  /// Inner content.
  /// -> content
  content,
  /// Optional unique name so that future elements can refer to this one.
  /// -> label | none
  name: none,
  /// Optional set of tags so that future element can refer to this one
  /// and others with the same tag.
  /// -> array(label)
  tags: (),
) = {
  ((
    type: place,
    align: align,
    dx: dx,
    dy: dy,
    display: display,
    boundary: boundary,
    content: content,
    aux: (
      name: name,
      tags: tags,
    ),
  ),)
}

/// Core function to create a container.
/// -> container
#let container(
  /// Location on the page.
  /// -> alignment
  align: top + left,
  /// Horizontal displacement.
  /// -> relative
  dx: 0% + 0pt,
  /// Vertical displacement.
  /// -> relative
  dy: 0% + 0pt,
  /// Width of the container.
  /// -> relative
  width: 100%,
  /// Height of the container.
  /// -> relative
  height: 100%,
  /// Styling options for the content that ends up inside this container.
  /// If you don't find the option you want here, check if it might be in
  /// the `style` parameter of `content` instead.
  /// - `align`: flush text `left`/`center`/`right`
  /// - `text-fill`: color of text
  /// -> dictionnary
  style: (:),
  /// Margin around the eventually filled container so that text from
  /// other paragraphs doesn't come too close.
  /// -> length
  margin: 5mm,
  /// One or more labels that will not affect this element's positioning.
  /// -> array(label)
  ignore-labels: (),
  /// Optional unique name so that future elements can refer to this one.
  /// -> label | none
  name: none,
  /// Optional set of tags so that future element can refer to this one
  /// and others with the same tag.
  /// -> array(label)
  tags: (),
) = {
  ((
    type: box,
    align: align,
    dx: dx,
    dy: dy,
    width: width,
    height: height,
    margin: margin,
    aux: (
      style: style,
      ignore-labels: ignore-labels,
      name: name,
      tags: tags,
    ),
  ),)
}

/// Continue layout to next page.
#let pagebreak() = {
  ((
    type: std.pagebreak,
  ),)
}

/// Continue content to next container.
/// Has the same internal fields as `content` so that we don't have to
/// check for `key in elem` all the time.
/// -> flowing
#let colbreak() = {
  ((
    type: std.colbreak,
    data: none,
    style: (
      size: auto,
      lang: auto,
      leading: auto,
      hyphenate: auto,
    )
  ),)
}

/// Continue content to next container after filling the current container
/// with whitespace.
/// -> flowing
#let colfill() = {
  ((
    type: pad,
    data: none,
    style: (
      size: auto,
      lang: auto,
      leading: auto,
      hyphenate: auto,
    )
  ),)
}

/// Core function to add flowing content.
/// -> flowing
#let content(
  /// Inner content.
  /// -> content
  data,
  /// Applies `#set text(size: ...)`.
  /// -> length
  size: auto,
  /// Applies `#set text(lang: ...)`.
  /// -> string
  lang: auto,
  /// Applies `#set text(hyphenate: ...)`.
  /// -> bool
  hyphenate: auto,
  /// Applies `#set par(leading: ...)`.
  /// -> length
  leading: auto,
) = {
  if size != auto {
    data = text(size: size, data)
  }
  if lang != auto {
    data = text(lang: lang, data)
  }
  if hyphenate != auto {
    data = text(hyphenate: hyphenate, data)
  }
  if leading != auto {
    data = [#set par(leading: leading); #data]
  }
  ((
    type: text,
    data: data,
    style: (
      size: size,
      lang: lang,
      leading: leading,
      hyphenate: hyphenate,
    ),
  ),)
}

