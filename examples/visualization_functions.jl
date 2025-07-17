# Some examples showcasing the use of visualization functions
using GeoUtils, CairoMakie, Random

function run_main(;
    save_figure :: Bool = false
    )
    # Randomness
    rng  = Random.MersenneTwister()
    seed = 123
    Random.seed!(rng, seed)

    # Generate some dummy data
    x   = [i for i in 1:10]
    y   = [j for j in 1:10]
    x2D = [i for i in 1:4]
    y2D = [j for j in 1:4]
    x2Dn = 2.0 .* x2D
    y2Dn = 2.0 .* y2D
    z2D = [1 2 3 4; 5 6 7 8; 9 10 11 12; 13 14 15 16]

    # Initialise figure
    fig = Figure()
    ax1 = Axis(fig[1,1])
    ax2 = Axis(fig[1,2])
    sc1 = scatter!(ax1, x, y)
    ln1 = lines!(ax1, x, y)
    hm1 = heatmap!(ax2, x2D, y2D, z2D)
    display(fig)
    display(hm1[1][])

    # Update array
    y1 = deepcopy(y)
    y1[[4, 8]] .= 2

    # Update plot
    update_plot_Makie!(Plot1D(), sc1, x, y1)
    update_plot_Makie!(Plot1D(), ln1, x, y1)
    update_plot_Makie!(Plot2D(), hm1, z2D')
    display(fig)

    # Density map
    x = randn(rng, 100)
    y = randn(rng, 100)

    # Visualize
    fg2 = Figure()
    GL = fg2[1,1] = GridLayout()
    kde_map_Makie!(GL, x, y)
    display(fg2)

    if save_figure
        save("./docs/public/kde_map_Makie.png", fg2, px_per_unit = 2)
    end
    # Return nothing
    return nothing
end

# Run main
run_main(; save_figure = true);