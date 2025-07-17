# GeoUtils.jl

A collection of functions that are hopefully useful to facilitate workflows for Earth Scientists.

> [!WARNING]
> 🚧 This package is under constant development. 🚧

## Visualisation routines
### Plot updates in CairoMakie
When monitoring convergence in geodynamic solvers or running simulations it is often very useful to visualize the evolution of diagnostic quantities in (pseudo-) time. The functions `update_plot_Makie!(...)` facilitate the update of plots within loops.

### Kernel density maps
The `kde_map_Makie!(...)` functions plot kernel-density distributions of bivariate data.
