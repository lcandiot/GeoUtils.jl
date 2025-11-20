# GeoUtils.jl

A collection of functions that are hopefully useful to facilitate workflows for Earth Scientists.

> [!WARNING]
> 🚧 This package is under constant development. 🚧

## 📦 Installation
To install GeoUtils, add the package directly from GitHub
```
using Pkg
Pkg.add(url="https://github.com/lcandiot/GeoUtils.jl.git")
```

To use it in your scripts or in the REPL type
```
using GeoUtils
```

For help you can query the functions by typing in the REPL
```
julia> ?kde_map_Makie!
```

## 📊 Visualisation routines
### Plot updates in CairoMakie
When monitoring convergence in geodynamic solvers or running simulations it is often very useful to visualize the evolution of diagnostic quantities in (pseudo-) time. The functions `update_plot_Makie!(...)` facilitate the update of plots within loops.

### Kernel density maps
The `kde_map_Makie!(...)` functions plot kernel-density distributions of bivariate data.

![](https://github.com/lcandiot/GeoUtils.jl/blob/main/docs/public/kde_map_Makie.png)

### Write GIFs
The function `write_gif(...)` allows you to write GIFs from existing pngs using [FFMPEG.jl](https://github.com/JuliaIO/FFMPEG.jl). This package provides macros and functions that run ffmpeg terminal commands from within Julia.
