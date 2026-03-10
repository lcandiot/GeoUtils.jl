using CairoMakie, DocumenterVitepress, FFMPEG
# ----------------------------------------- #
#|       Update CairoMakie plots           |#
# ----------------------------------------- #
"""
# Methods:

    update_plot_Makie!(::Plot1D, ::Union{Scatter{Tuple{Vector{Point{2, Float64}}}}, Lines{Tuple{Vector{Point{2, Float64}}}}}, ::AbstractArray, ::AbstractArray)
    update_plot_Makie!(::Plot2D, ::Heatmap{Tuple{Vector{Float64}, Vector{Float64}, Matrix{Float32}}},                         ::AbstractArray)

# Description:

Updates a CairoMakie plot without emptying axis or recalling the plot itself. Arguments depend on the method selected.

# Arguments:

* `Plot1D()`, `Plot2D()` ...    : Structure that defines the type of plot
* `plh`                         : Plot handle
* `x`, `y`, `z`                 : Data used to update the plot
"""
function update_plot_Makie!(
        ::Plot1D,
    plh ::Union{Scatter{Tuple{Vector{Point{2, Float64}}}}, Lines{Tuple{Vector{Point{2, Float64}}}}},
    x   ::AbstractArray,
    y   ::AbstractArray
)
    # Form new data and update
    data = [Point2f(x[i], y[i]) for i in eachindex(x)]
    plh[1][] = data

    # Return
    return nothing
end
function update_plot_Makie!(
        ::Plot2D,
    plh ::Heatmap{Tuple{Vector{Float64}, Vector{Float64}, Matrix{Float32}}},
    z   ::AbstractArray
)
    # Update
    plh[3][] = z

    # Return
    return nothing
end

# ----------------------------------------- #
#|         Kernel density maps             |#
# ----------------------------------------- #
"""
# Methods:

    kde_map_Makie!(::GridLayout, ::AbstractArray, ::AbstractArray; kwargs...)

# Description:

Creates a 2D kernel-density map and visualizes the density into an existing GridLayout.

# Arguments:

* `GL`      : Grid Layout into which the density is plotted
* `x`, `y`  : Data arrays

# Keyword arguments:

* `σx`, `σy`         : Standard deviation of `x` and `y`, respectively
* `npts`             : No. of points in the grid
* `marg`             : Marginal plot type (passed as a symbol)
* `colormap`         : The colormap used for the plot
* `bar_color`        : Color of the histogram bars (passed as a symbol)
* `xlabel`, `ylabel` : Labels used on axes
"""
function kde_map_Makie!(
    GL        ::GridLayout,
    x         ::AbstractArray,
    y         ::AbstractArray;
    σx        ::Float64                        = 1.0,
    σy        ::Float64                        = 1.0,
    npts      ::Int64                          = 100,
    marg      ::Symbol                         = :hist,
    colormap  ::Union{Symbol, Reverse{Symbol}} = Reverse(:bilbao),
    bar_color ::Union{Symbol, Reverse{Symbol}} = :skyblue,
    xlabel    ::AbstractString                 = "x",
    ylabel    ::AbstractString                 = "y"
)
    # Set limits
    xmin, xmax = minimum(x), maximum(x)
    ymin, ymax = minimum(y), maximum(y)

    # Create grid arrays
    xgrid = LinRange(xmin, xmax, npts) |> collect
    ygrid = LinRange(ymin, ymax, npts) |> collect
    x2D   = repeat(xgrid, npts) |> xgrid -> reshape(xgrid, npts, npts)
    y2D   = repeat(ygrid, npts) |> ygrid -> reshape(ygrid, npts, npts)' |> Matrix{Float64}

    # Calculate Gaussian kernel
    ρ̃ = zeros(Float64, npts, npts)
    A = 1.0 / (length(x) * 2π *σx*σy)
    for idx in eachindex(x)
        ρ̃ .+= A .* exp.( -( (x2D .- x[idx]).^2 ./ σx.^2 .+ (y2D .- y[idx]).^2 ./ σy.^2 ) )
    end

    # Prepare plot
    GL1 = GL[2:4, 1:3] = GridLayout()
    GL2 = GL[1,   1:3] = GridLayout()
    GL3 = GL[2:4,   4] = GridLayout()
    GL4 = GL[5,   1:3] = GridLayout(width = Relative(1.0), height = 40)
    ax1 = Axis(GL1[1,1], xlabel = xlabel, ylabel = ylabel)
    ax2 = Axis(GL2[1,1])
    ax3 = Axis(GL3[1,1])

    # Draw map
    cnf = contourf!(ax1, x2D, y2D, ρ̃, colormap = colormap)
    if marg == :hist
        hist!(ax2, x, color = bar_color)
        hist!(ax3, y, direction = :x, color = bar_color)
    end
    vmin = round(minimum(ρ̃); sigdigits=3)
    vmax = round(maximum(ρ̃); sigdigits=3)

    # Add colorbar at the bottom
    Colorbar(
        GL4[1, 1],
        cnf,
        vertical = false,
        ticks    = ([vmin, vmax], ["low", "high"]),
        label    = L"$$Kernel Density [ ]",
        flipaxis = false
    )

    # Clip axes
    ax1.limits = (xmin, xmax, ymin, ymax)
    xlims!(ax2, (xmin, xmax))
    ylims!(ax3, (ymin, ymax))

    # Return
    return nothing
end

# ----------------------------------------- #
#|       Update CairoMakie plots           |#
# ----------------------------------------- #
"""
# Methods:

    write_gif(::String, ::String; kwargs...)

# Description:

Writes a GIF from pngs.

# Arguments:

* `src_dir`      : Path to png directory
* `str_root`     : The root of png name. This will be used to name the GIF

# Keyword arguments:

* `fps`     : Frame rate
"""
function write_gif(
    src_dir  ::String,
    str_root ::String;
    fps      ::Float64 = 5.0
)

    # See which files already exist
    dir_list = readdir(src_dir)

    # Remove existing color palettes and GIFs
    idx_palette = findfirst(x -> x == "palette.png", dir_list)
    if !isnothing(idx_palette)
        rm("$(src_dir)/palette.png")
    end

    # Create a new palette
    @ffmpeg_env run(`$(FFMPEG.ffmpeg) -pattern_type glob -i $(src_dir)/$(str_root)'*'.png -vf palettegen $(src_dir)/palette.png`)
    
    # Remove any existing version of the GIF
    idx_GIF = findfirst(x -> contains(x, ".gif"), dir_list)
    if !isnothing(idx_GIF)
        rm("$(src_dir)/$(str_root).gif")
    end

    # Write GIF
    @ffmpeg_env run(`$(FFMPEG.ffmpeg) -framerate $(fps) -pattern_type glob -i $(src_dir)/$(str_root)'*'.png -i $(src_dir)/palette.png -filter_complex "paletteuse" "$(src_dir)/$(str_root).gif"`)
    
    # Return
    return nothing
end

# ----------------------------------------- #
#|       Mineral phase abundance plot      |#
# ----------------------------------------- #
"""
# Methods:

    plot_mineral_abundance_Makie!(ax, df; kwargs...)

# Description:

Plots mineral abundance data using Makie.

# Arguments:

* `ax`           : Axis object
* `df`           : DataFrame containing the data. First column will be used as x-axis (e.g., temperature), and the rest of the columns will be used as y-axis (e.g., mineral abundances). The column names will be used as labels for the legend.

# Keyword arguments:

* `normalize`     : Whether to normalize the data
* `sys_unit`      : System of units ("frac" or "wt")
"""
function plot_mineral_abundance_Makie!(
    ax        ::Axis,
    df        ::DataFrame;
    normalize ::Bool = false,
    sys_unit  ::String = "frac"
)
    # Set units
    fact = 1.0
    if sys_unit == "wt"
        fact = 100.0
    end

    # Get colormap
    colormap = cgrad(:bilbao, length(names(df)) - 1; categorical = true)

    # Clean up data frame and extract header
    for (iCol, Col) in enumerate(eachcol(df))
        findall(x -> ~isa(x, Union{Float64, Int64}), Col) |> idx -> df[idx, iCol] .= 0.0
        df[!, iCol] = convert.(Float64, Col)
    end

    # Normalize if requested
    if normalize
        for iRow in axes(df, 1)
            row_sum = sum(df[iRow, 2:end])
            row_sum == 0.0 ? continue : nothing
            abund = [df[iRow, iCol] for iCol in axes(df, 2) if iCol != 1]
            abund ./= row_sum
            for (iCol, _) in enumerate(df[iRow, 2:end])
                df[iRow, iCol + 1] = abund[iCol] * fact
            end
        end
    end

    # Set baseline to 0.0 and loop through phase
    baseline = [0.0 for _ in eachrow(df)]
    for (iCol, Col) in enumerate(eachcol(df))
        # First column must be temperature -> skip
        iCol == 1 ? continue : nothing

        # Extract phase abundance
        phase = names(df)[iCol]

        # Skip if phase abundance is 0 for every point
        sum(Col) == 0.0 ? continue : nothing

        # Add band and text for current phase
        band!(ax, Float64.(df[:, 1]), baseline, baseline .+ Col, color = colormap[iCol-1])
        idx = argmax(Col)
        position = [df[idx, 1], baseline[idx] + Col[idx] / 2]
        idx == 1 ? position[1] = df[idx, 1] + 20.0 : nothing
        idx == size(Col, 1) ? position[1] = df[idx, 1] - 20.0 : nothing
        txt_col = :white
        iCol > cld(size(Col, 1), 2) ? txt_col = :black : nothing
        text!(ax, phase, position = (position[1], position[2]), align = (:center, :center), color = txt_col)

        # Update baseline
        baseline .+= Col
    end

    # Return
    return nothing
end