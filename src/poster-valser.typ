#import "@preview/muchpdf:0.1.0": muchpdf
#import "@preview/cades:0.3.0": qr-code
#import "postercise.typ": *
#import themes.boxes: *
#import "@preview/wrap-it:0.1.1": wrap-content
#import "body-content.typ": body-content

#set page(width: 84in * 0.6, height: 42in * 0.6)
#set text(size: 24pt)
#show: theme.with(
  primary-color: rgb("#63CCFA")
)

#poster-content()[
  #poster-header(
    title: [AutoLUT: LUT-Based Image Super-Resolution with Automatic Sampling and Adaptive Residual Learning],
    authors: [Yuheng Xu\*, Shijie Yang\*, Xin Liu, Jie Liu, Jie Tang, Gangshan Wu (\* equal contribution)],
    // affiliation: [NanJing University],
    right-part: stack(
      dir: ltr,
      spacing: 1em,

      image("figures/valser.png", height: 80%),
      image("figures/nju_logo.png"),
      align(
        center,
        stack(
          dir: ttb,
          spacing: 1mm,
          qr-code("https://arxiv.org/abs/2503.01565", width: 20mm),
          [arXiv]
        )
      )
      ,
      align(
        center,
        stack(
          dir: ttb,
          spacing: 1mm,
          qr-code("https://github.com/SuperKenVery/AutoLUT", width: 20mm),
          [GitHub]
        )
      )
    )
  )

  #body-content

  #poster-footer[
    #stack(
      dir: ltr,
      spacing: 10mm,
    )
  ]

]
