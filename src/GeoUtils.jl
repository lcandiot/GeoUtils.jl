module GeoUtils

# Include functions
include("Types.jl")
include("VisualizationFunctions.jl")

# Export visualization utilities
export PlotType
export Plot1D, Plot2D
export update_plot_Makie!, kde_map_Makie!

end # module GeoUtils
