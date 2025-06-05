#import "../utils/scripts.typ": *


#let focus-box(
  color: none,
  body
) = {
    locate(loc =>
    {
      let primary-color = color-primary.get()
      show heading: set text(white)
      show heading: set align(center+horizon)
      show heading: set block(width: 108.696%,
                              height: 1.2em,
                              fill: primary-color)
      if color != none [
        // Overwrite the color if provided
        #let focus-color = color
        #box(
          width: 100%,
          stroke: primary-color+.2em,
          fill: color,
          inset: 0%,
          [
            #box(
              inset: (top: 0%, left: 4%, right: 4%, bottom: 4%),
              body
              )
          ]
        )
      ] else [
        #let focus-color = color-accent.get()
        #box(
          width: 100%,
          stroke: none,//primary-color+.2em,
          fill: focus-color,
          inset: 0%,
          [
            #box(
              inset: (top: 0%, left: 4%, right: 4%, bottom: 4%),
              body
              )
          ]
        )
      ]
  })
}


#let normal-box(
  color: none,
  height: auto,
  body
) = {
    locate(loc =>
    {
      let primary-color = color-primary.get()
      show heading.where(level: 1): set text(white)
      show heading: set align(center)
      show heading.where(level: 1): set block(
        width: 108.696%,
        height: 1.2em,
        inset: 8pt,
        fill: primary-color,
      )
      // show heading.where(level: 2): set block(
      //   width: 108.696%,
      //   height: 1.2em,
      //   // fill: primary-color.lighten(20%),
      // )


      if color != none [
        // Overwrite the default if provided
        #let focus-color = color
        #box(
          width: 100%,
          height: height,
          stroke: primary-color+.2em,
          fill: focus-color,
          (top: 0%, left: 4%, right: 4%, bottom: 4%),
          outset: 0%,
          body
        )
      ] else [
        #let focus-color = color
        #box(
          width: 100%,
          height: height,
          // stroke: none,//primary-color+.2em,
          stroke: primary-color + 1mm,
          fill: color,
          inset: (top: 0%, left: 4%, right: 4%, bottom: 4%),
          body
        )
      ]
  })
}





#let poster-content(
  col: 3,
  body
)={
    locate(loc =>
    {
      let primary-color = color-primary.get()
      let bg-color = color-background.get()
      let titletext-color = color-titletext.get()
      let titletext-size = size-titletext.get()

      let current-title = context title-content.get()
      let current-subtitle = context subtitle-content.get()
      let current-author = context author-content.get()
      let current-affiliation = context affiliation-content.get()
      let current-right-part = context right-part-content.get()
      let current-footer = context footer-content.get()

      // Table captions go above
      // TO DO: Numbering is not working properly
      show figure.where(kind:table) : set figure.caption(position:top)
      show figure.caption: it => [
        // #context it.counter.display(it.numbering)
        #it.body
      ]

      // First, need body (hidden) to update header and footer
      block(height: 0pt, hide[#body])
      v(0pt, weak: true)

      grid(
        columns: 1,
        rows: (7%, 93%),

        // Top = title row
        [
          #box(
            stroke: none,
            fill: primary-color,
            height: 100%,
            width: 100%,
            inset: 4%,

            grid(
              columns: (70%, 30%),
              rows: 100%,
              stroke: none,

              // Left
              [
                #place(horizon)[
                    #set text(size: titletext-size,
                    fill: titletext-color,
                    )
                    *#current-title* #current-subtitle \
                    #set text(size: 0.5em)
                    #current-author \
                    #current-affiliation
                  ]
              ],

              [
                #set text(fill: titletext-color)
                #place(horizon)[#current-right-part]
              ]
            )
          )
        ],

        // Middle = body
        [
          #box(
            height: 100%,
            inset: 20pt,
            fill: bg-color,

            columns(col, gutter: 15pt)[#body]
          )
        ],
      )

    })
}
