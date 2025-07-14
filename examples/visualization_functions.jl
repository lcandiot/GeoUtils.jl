# Some examples showcasing the use of visualization functions
using GeoUtils, CairoMakie

function run_main()
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
    update_CairoMakie_plot!(Plot1D(), sc1, x, y1)
    update_CairoMakie_plot!(Plot1D(), ln1, x, y1)
    update_CairoMakie_plot!(Plot2D(), hm1, z2D')
    display(fig)

    # Return nothing
    return nothing
end

# Run main
run_main();