using GeoUtils, Random

# Define main
function run_main()

    # Randomness
    rng  = Random.MersenneTwister()
    seed = 123
    Random.seed!(rng, seed)

    # Initialise array
    nx, ny  = 4, 5
    A       = rand(rng, 1:10, nx,  ny)
    Av      = zeros(Float64, nx-1, ny-1)
    av      = zeros(Float64, nx-1, ny-1)
    av_xa   = zeros(Float64, nx-1, ny  )
    av_ya   = zeros(Float64, nx,   ny-1)
    av_xi   = zeros(Float64, nx-1, ny-2)
    av_yi   = zeros(Float64, nx-2, ny-1)
    d_dxa   = zeros(Float64, nx-1, ny  )
    d_dya   = zeros(Float64, nx  , ny-1)
    d_dxi   = zeros(Float64, nx-1, ny-2)
    d_dyi   = zeros(Float64, nx-2, ny-1)
    d2_dx2a = zeros(Float64, nx-2, ny  )
    d2_dy2a = zeros(Float64, nx,   ny-2)

    # Averaging
    Av .= @Av(A)
    for idy in axes(av, 2)
        for idx in axes(av, 1)
            av[idx, idy] = @av(A)
        end
    end
    for idy in axes(av_xa, 2)
        for idx in axes(av_xa, 1)
            av_xa[idx, idy] = @av_xa(A)
        end
    end
    for idy in axes(av_ya, 2)
        for idx in axes(av_ya, 1)
            av_ya[idx, idy] = @av_ya(A)
        end
    end
    for idy in axes(av_xi, 2)
        for idx in axes(av_xi, 1)
            av_xi[idx, idy] = @av_xi(A)
        end
    end
    for idy in axes(av_yi, 2)
        for idx in axes(av_yi, 1)
            av_yi[idx, idy] = @av_yi(A)
        end
    end

    # FD operations
    for idy in axes(d_dxa, 2)
        for idx in axes(d_dxa, 1)
            d_dxa[idx, idy] = @d_dxa(A)
        end
    end
    for idy in axes(d_dya, 2)
        for idx in axes(d_dya, 1)
            d_dya[idx, idy] = @d_dya(A)
        end
    end
    for idy in axes(d_dxi, 2)
        for idx in axes(d_dxi, 1)
            d_dxi[idx, idy] = @d_dxi(A)
        end
    end
    for idy in axes(d_dyi, 2)
        for idx in axes(d_dyi, 1)
            d_dyi[idx, idy] = @d_dyi(A)
        end
    end
    for idy in axes(A, 2)
        for idx in axes(A, 1)
            if idx > 1 && idx < nx
                d2_dx2a[idx-1, idy] = @d2_dx2a(A)
            end
        end
    end
    for idy in axes(A, 2)
        for idx in axes(A, 1)
            if idy > 1 && idy < ny
                d2_dy2a[idx, idy-1] = @d2_dy2a(A)
            end
        end
    end
    display(A)
    # display(Av)
    # display(av)
    # display(av_xa)
    # display(av_ya)
    # display(av_xi)
    # display(av_yi)
    # display(d_dxa)
    # display(d_dya)
    # display(d_dxi)
    # display(d_dyi)
    println(d2_dx2a)
    println(d2_dy2a)

    # Return
    return nothing
end

# Run main
run_main();