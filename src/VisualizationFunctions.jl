using CairoMakie, DocumenterVitepress

# Update CairoMakie plots
"""
# Methods

    update_CairoMakie_plot!(::Plot1D, plh::Union{Scatter{Tuple{Vector{Point{2, Float64}}}}, Lines{Tuple{Vector{Point{2, Float64}}}}}, x::AbstractArray, y::AbstractArray)
    update_CairoMakie_plot!(::Plot2D, plh::Heatmap{Tuple{Vector{Float64}, Vector{Float64}, Matrix{Float32}}}, z::AbstractArray)

# Description:

Updates a CairoMakie plot without emptying axis or recalling the plot itself. Arguments depend on the method selected.

# Arguments:

* `Plot1D()`, `Plot2D()` ...    : Structure that defines the type of plot
* `plh`                         : Plot handle
* `x`, `y`, `z`                 : Data used to update the plot
"""
function update_CairoMakie_plot!(
        :: Plot1D,
    plh :: Union{Scatter{Tuple{Vector{Point{2, Float64}}}}, Lines{Tuple{Vector{Point{2, Float64}}}}},
    x   :: AbstractArray,
    y   :: AbstractArray
)
    # Form new data and update
    data = [Point2f(x[i], y[i]) for i in eachindex(x)]
    plh[1][] = data

    # Return
    return nothing
end
function update_CairoMakie_plot!(
        :: Plot2D,
    plh :: Heatmap{Tuple{Vector{Float64}, Vector{Float64}, Matrix{Float32}}},
    z   :: AbstractArray
)
    # Update
    plh[3][] = z

    # Return
    return nothing
end
