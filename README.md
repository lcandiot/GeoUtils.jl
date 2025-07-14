# GeoUtils.jl

A collection of functions that are hopefully useful to facilitate workflows for Earth Scientists.

> [!WARNING]
> 🚧 This package is under constant development. 🚧

## Visualisation routines
### Plot updates in CairoMakie
When monitoring convergence in geodynamic solvers or running simulations it is often very useful to visualize diagnostic quantities. The functions `update_CairoMakie_plot!(...)` facilitate the update of plots within loops.
