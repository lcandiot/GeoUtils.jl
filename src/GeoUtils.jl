module GeoUtils

# Include functions
include("Types.jl")
include("VisualizationFunctions.jl")
include("GeoUtils_Macros.jl")

# Export visualization utilities
export PlotType
export Plot1D, Plot2D
export update_plot_Makie!, kde_map_Makie!, write_gif

# Export macros
export @Av, @Av_xa, @Av_ya, @Av_xi, @Av_yi
export @av, @av_xa, @av_ya, @av_xi, @av_yi, @d_dxa, @d_dya, @d_dxi, @d_dyi, @d2_dx2a, @d2_dy2a

end # module GeoUtils
