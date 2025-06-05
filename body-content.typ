#import "@preview/muchpdf:0.1.0": muchpdf
#import "@preview/cades:0.3.0": qr-code
#import "postercise.typ": *
#import themes.boxes: *
#import "@preview/wrap-it:0.1.1": wrap-content

#let body-content = [
  #normal-box(height: 49%)[
    = Challenges
    DNN based image super-resolution are effective at restoring details, but are slow to run. Therefore,
    previous works propose to export DNNs to lookup tables.
    #figure(
      stack(
          dir: ltr,       // left-to-right
          spacing: 15mm,   // space between contents
          muchpdf(read("figures/export_lut.pdf", encoding: none), width: 36%),
          muchpdf(read("figures/MuLUT_SR.pdf", encoding: none), width: 56%),
      ),
      // muchpdf(read("figures/export_lut.pdf", encoding: none), width: 35%),
      caption: [
        *Left*: Exporting SR DNNs to Look Up Tables

        *Right*: MuLUT using multiple LUTs to expand RF
      ],
    )
    However, the storage size requirement grows exponentially: $ N = 256^("Number of input pixels") $

    Previous work MuLUT enlarged reception field with linear size, by using multiple lookup tables.
    But it relies on manual design of sampling patterns, and didn't incorporate any residual connections.
  ]

  #normal-box(height: 49.2%)[
    = Overview of AutoLUT pipeline
    #figure(
      muchpdf(read("figures/overview.pdf", encoding: none), width: 90%),
    )

    #set enum(numbering: "(a)")
    + *Outline of AutoLUT-Based SR Framework*. It is composed of many AutoLUT groups.
    + *AutoLUT Group*. It consists of multiple branches. They are same on architecture but have different weights.
    + *AutoLUT*. This is the basic SR unit. Extending an LUT which replaces a CNN network, we add AutoSample layer to
      sample 4 pixels out of sample area and AdaRL layer to use information from previous AutoLUT group.
  ]

  #normal-box(height: 100%)[
    = Methods
    == AutoSample
    #figure(
      muchpdf(read("figures/autosample.pdf", encoding: none)),
      caption: [The AutoSample Layer]
    )
    We propose AutoSample layer which samples 4 pixels out of a configurable range of pixels
    (in the figure, $3 times 3$). Previous methods shown in (b) rely on manually designed sampling
    patterns (s, d, y from top to bottom). In AutoSample, each of the four output pixels is a
    weighed average of all the input pixels, as shown in (c). Formally,
    $ Y_n^((c)) = sum_(i=1)^k sum_(j=1)^k X_n^((i,j)) dot W^((i,j,1,c)) $
    where $k$ is the configured sample size, and $W$ is the learned weight.

    #v(30pt)

    == AdaRL
    #figure(
      image("figures/adarl.svg"),
      caption: [The Adaptive Residual Learning Layer]
    )
    Directly adding previous input would push the color range from $[0,255]$ to $[0,510]$, which
    results in an unacceptable LUT size. Therfore, for each of the four pixels we do a weighed
    average of the previous and the current input. The weights are learned by the network, and
    the weights sum to $1$ which ensures that the result still lies in the range $[0,255]$.
    // Formally, $ R_(n-1)^((i,j)) = (1 - W_("Residual")^((i,j))) dot.circle P_(n-1)^((i,j)) + W_("Residual")^((i,j)) dot.circle P_(n-2)^((i,j)) $
  ]

  #normal-box(height: 100%)[
    = Experiments

    #figure(
      stack(
        dir: ltr,
        spacing: 10mm,
        muchpdf(read("figures/perf_vs_rf.pdf", encoding: none), width: 50%),
        muchpdf(read("figures/perf_vs_storage.pdf", encoding: none), width: 50%)
      ),
      caption: [
        *Left*: Reception field vs performance. Dot size is storage size.

        *Right*: Storage size vs performance.
      ]
    )

    On the left, our methods are denoted with yellow dots. Applying our methods on MuLUT, we get
    larger RF and better performance while maintaining similar storage size. Applying on SPF-LUT,
    we achieve similar performance while reducing storage size. On the right, our methods are highlighted in red. Our method can reduce storage size, increase
    performance, or do both.

    #show table.cell.where(y: 0): strong
    #show table.cell: set text(size: 22pt)
    #set table(
      stroke: (_, y) => (
        top: if y <= 1 { 1pt } else { 0pt },
        bottom: 1pt,
      ),
      align: center,
      fill: (x, y) =>
        if y==10 or y==13 {
          gray
        }else{
          none
        }
    )
    #set table.hline(stroke: 0.7pt)

    #figure(
      table(
        columns: (1fr, 1.2fr, 1.2fr, 1fr, 1fr, 1fr, 1fr, 1fr, ),
        [], [Method], [Storage Size], [Set5], [Set14], [BSDS100], [Urban100], [Manga109],

        table.cell(rowspan:7, align: horizon+center, [Classical]),
        [Nearest], [-], [26.25/0.7372], [24.65/0.6529], [25.03/0.6293], [22.17/0.6154], [23.45/0.7414],
        [Zeyde et al.], [-], [26.69/0.8429], [26.90/0.7354], [26.53/0.6968], [23.90/0.6962], [26.24/0.8241],
        [Bilinear], [-], [27.55/0.7884], [25.42/0.6792], [25.54/0.6460], [22.69/0.6346], [24.21/0.7666],
        [Bicubic], [-], [28.42/0.8101], [26.00/0.7023], [25.96/0.6672], [23.14/0.6574], [24.91/0.7871],
        [NE + LLE], [1.434MB], [29.62/0.8404], [26.82/0.7346], [26.49/0.6970], [23.84/0.6942], [26.10/0.8195],
        [ANR], [1.434MB], [29.70/0.8422], [26.86/0.7386], [26.52/0.6992], [23.89/0.6964], [26.18/0.8214],
        [A+], [15.17MB], [30.27/0.8602], [27.30/0.7498], [26.73/0.7088], [24.33/0.7189], [26.91/0.8480],
        table.hline(),

        table.cell(rowspan: 3, align: horizon+center, [MuLUT]),
        [MuLUT], [4.062MB], [30.60/0.8653], [27.60/0.7541], [26.86/0.7110], [24.46/0.7194], [27.90/0.8633],
        [MuLUT+DFC], [0.407MB], [30.55/0.8642], [27.56/0.7532], [26.83/0.7104], [24.41/0.7177], [27.82/0.8613],
        [MuLUT+ours], [4.067MB], [30.85/0.8699], [27.77/0.7584], [26.96/0.7144], [24.60/0.7257], [28.27/0.8706],
        table.hline(),

        table.cell(rowspan: 3, align: horizon+center, [SPF-LUT]),
        [SPF-LUT], [17.284MB], [31.11/0.8764], [27.92/0.7640], [27.10/0.7197], [24.87/0.7378], [28.68/0.8796],
        [SPF-LUT+DFC], [2.018MB], [31.05/0.8755], [27.88/0.7632], [27.08/0.7190], [24.81/0.7357], [28.58/0.8779],
        [SPF-Light], [0.907MB], [31.02/0.8751], [27.88/0.7629], [27.07/0.7186], [24.78/0.7342], [28.54/0.8769],
        table.hline(),

        table.cell(rowspan: 4, align: horizon+center, [DNN]),
        [RRDB], [63.942MB], [32.68/0.8999], [28.88/0.7891], [27.82/0.7444], [27.02/0.8146], [31.57/0.9185],
        [EDSR], [164.396MB], [32.46/0.8968], [28.80/0.7876], [27.71/0.7420], [26.64/0.8033], [31.02/0.9148],
        [RCAN], [59.74MB], [32.61/0.8999], [28.93/0.7894], [27.80/0.7436], [26.85/0.8089], [31.45/0.9187],
        [SwinIR], [170.4MB], [32.44/0.8976], [28.77/0.7858], [27.69/0.7406], [26.47/0.7980], [30.92/0.9151],
      ),
      caption: [*Table 1.* Applying our methods vs not applying them]
    )

    #figure(
      table(
        columns: (0.3fr, auto, auto, 1fr, 1fr, 1fr, 1fr, 1fr),
        align: center+horizon,

        [], [Automatic Sampling], [AdaRL], [Set5], [Set14], [BSDS100], [Urban100], [Manga109],

        numbering("①", 1), [-], [-], [30.60/0.8653], [27.60/0.7541], [26.86/0.7110], [24.46/0.7194], [27.90/0.8633],
        numbering("①", 2), [$checkmark$], [-], [30.63/0.8657], [27.63/0.7550], [26.86/0.7112], [24.49/0.7204], [28.02/0.8627],
        numbering("①", 3), [-], [$checkmark$], [30.70/0.8687], [27.67/0.7572], [26.89/0.7136], [24.51/0.7242], [28.07/0.8685],
        numbering("①", 4), [$checkmark$], [$checkmark$], [30.79/0.8693], [27.72/0.7579], [26.94/0.7142], [24.57/0.7249], [28.20/0.8696],
      ),
      caption: [*Table 2.* Ablation studies on AutoSample and AdaRL]
    )

    #let runtime-comparison = figure(
      table(
        columns: 3,
        [Model], [Runtime (ms)], [PSNR],

        [MuLUT], [5938.1], [30.60],
        [MuLUT+Ours 1×5], [2043.95], [30.62],
        [MuLUT+Ours], [5984.00], [30.85],
        [SPF-LUT+DFC], [31921.65], [31.05],
        [SPF-Light (Ours)], [9910.95], [31.02],
      ),
      caption: [*Table 3.* Runtime comparison]
    )

    #wrap-content(runtime-comparison, [
      In *Table 1* we compare performance with or without our methods. Our methods are highlighted in grey.
      In *Table 2* we do ablation studies on AutoSample and AdaRL modules. It shows that both AdaRL and AutoSample
      are effective at improving the SR performance on their own, and is even better when combined.
      In *Table 3* we compare the run time with or without our methods. On MuLUT, our method can improve performance
      or reduce run time. On SPF-LUT, our method can greatly reduce run time.
    ])

  ]
]
