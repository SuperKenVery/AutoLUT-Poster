# Poster for [AutoLUT](https://github.com/SuperKenVery/AutoLUT/)

This is the typst source for the poster of out paper, _AutoLUT: LUT-Based Image Super-Resolution with Automatic Sampling and Adaptive Residual Learning_.

## Build

We use nix to manage the environment.

```sh
# watch
nix run .#watch # output at build/output.pdf

# Build
nix build . # output at ./result
```

## Files

- `src/main.typ` Poster for CVPR25
- `src/poster-valser.typ` Poster for VALSER 2025
