// Color and size states
#let color-primary = state("color-primary", teal)
#let color-background = state("color-background", white)
#let color-accent = state("color-accent", yellow)
#let color-titletext = state("color-titletext", black)
#let size-titletext = state("size-titletext", 2em)

// Content states
#let title-content = state("title-body")
#let subtitle-content = state("subtitle-body")
#let author-content = state("author-body")
#let affiliation-content = state("affiliation-body")
#let right-part-content = state("right-part-body")


#let focus-content = state("focus-body")
#let footer-content = state("footer-body")


#let theme(
  primary-color: rgb(28,55,103), // Dark blue
  background-color: white,
  accent-color: rgb(243,163,30), // Yellow
  titletext-color: white,
  titletext-size: 2em,
  body,
) = {
  set page(
    margin: 0pt,
  )

  color-primary.update(primary-color)
  color-background.update(background-color)
  color-accent.update(accent-color)
  color-titletext.update(color-titletext => titletext-color)
  size-titletext.update(size-titletext => titletext-size)

  body
}


#let poster-header(
  title: none,
  subtitle: none,
  authors: none,
  affiliation: none,
  right-part: none
) = {
  title-content.update(title-body => title)
  subtitle-content.update(subtitle-body => subtitle)
  author-content.update(author-body => authors)
  affiliation-content.update(affiliation-body => affiliation)
  right-part-content.update(right-part-body => right-part)
}


#let poster-footer(
  footer-kwargs: none,
  body
) = {
  footer-content.update(footer-body => body)
}
