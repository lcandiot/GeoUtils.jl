using Test
using GeoUtils

# Initialisations
A       = [8 4 7 10 8; 6 1 6 9 3; 4 7 4 6 10; 4 9 10 1 8]
nx, ny  = size(A)
Av      = zeros(Float64, nx-1, ny-1)
av      = zeros(Float64, nx-1, ny-1)
av_xa   = zeros(Float64, nx-1, ny  )
av_ya   = zeros(Float64, nx,   ny-1)
av_xi   = zeros(Float64, nx-1, ny-2)
av_yi   = zeros(Float64, nx-2, ny-1)
d_dxa   = zeros(Float64, nx-1, ny  )
d_dya   = zeros(Float64, nx,   ny-1)
d_dxi   = zeros(Float64, nx-1, ny-2)
d_dyi   = zeros(Float64, nx-2, ny-1)
d2_dx2a = zeros(Float64, nx-2, ny  )
d2_dy2a = zeros(Float64, nx  , ny-2)

# Solutions
Av_sol    = [4.75 4.5 8.0 7.5; 4.5 4.5 6.25 7.0; 6.0 7.5 5.25 6.25]
av_sol    = [4.75 4.5 8.0 7.5; 4.5 4.5 6.25 7.0; 6.0 7.5 5.25 6.25]
av_xa_sol = [7.0 2.5 6.5 9.5 5.5; 5.0 4.0 5.0 7.5 6.5; 4.0 8.0 7.0 3.5 9.0]
av_ya_sol = [6.0 5.5 8.5 9.0; 3.5 3.5 7.5 6.0; 5.5 5.5 5.0 8.0; 6.5 9.5 5.5 4.5]
av_xi_sol = [2.5 6.5 9.5; 4.0 5.0 7.5; 8.0 7.0 3.5]
av_yi_sol = [3.5 3.5 7.5 6.0; 5.5 5.5 5.0 8.0]
d_dxa_sol = [-2.0 -3.0 -1.0 -1.0 -5.0; -2.0 6.0 -2.0 -3.0 7.0; 0.0 2.0 6.0 -5.0 -2.0]
d_dya_sol = [-4.0 3.0 3.0 -2.0; -5.0 5.0 3.0 -6.0; 3.0 -3.0 2.0 4.0; 5.0 1.0 -9.0 7.0]
d_dxi_sol = [-3.0 -1.0 -1.0; 6.0 -2.0 -3.0; 2.0 6.0 -5.0]
d_dyi_sol = [-5.0 5.0 3.0 -6.0; 3.0 -3.0 2.0 4.0]
d2_dx2a_sol = [0.0 9.0 -1.0 -2.0 12.0; 2.0 -4.0 8.0 -2.0 -9.0]
d2_dy2a_sol = [7.0 0.0 -5.0; 10.0 -2.0 -9.0; -6.0 5.0 2.0; -4.0 -10.0 16.0]

# Calculations
Av .= @Av(A)
for idy in axes(A, 2)
    for idx in axes(A, 1)
        if idx < nx && idy < ny
            av[idx, idy] = @av(A)
        end
    end
end
for idy in axes(A, 2)
    for idx in axes(A, 1)
        if idx < nx
            av_xa[idx, idy] = @av_xa(A)
        end
    end
end
for idy in axes(A, 2)
    for idx in axes(A, 1)
        if idy < ny
            av_ya[idx, idy] = @av_ya(A)
        end
    end
end
for idy in axes(A, 2)
    for idx in axes(A, 1)
        if idx < nx && idy < ny - 1
            av_xi[idx, idy] = @av_xi(A)
        end
    end
end
for idy in axes(A, 2)
    for idx in axes(A, 1)
        if idy < ny && idx < nx - 1
            av_yi[idx, idy] = @av_yi(A)
        end
    end
end
for idy in axes(A, 2)
    for idx in axes(A, 1)
        if idx < nx
            d_dxa[idx, idy] = @d_dxa(A)
        end
    end
end
for idy in axes(A, 2)
    for idx in axes(A, 1)
        if idy < ny
            d_dya[idx, idy] = @d_dya(A)
        end
    end
end
for idy in axes(A, 2)
    for idx in axes(A, 1)
        if idx < nx && idy < ny - 1
            d_dxi[idx, idy] = @d_dxi(A)
        end
    end
end
for idy in axes(A, 2)
    for idx in axes(A, 1)
        if idy < ny && idx < nx - 1
            d_dyi[idx, idy] = @d_dyi(A)
        end
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

# Averaging tests
@testset "Averaging" begin
    @test    Av == Av_sol
    @test    av == av_sol
    @test av_xa == av_xa_sol
    @test av_ya == av_ya_sol
    @test av_xi == av_xi_sol
    @test av_yi == av_yi_sol
end

# Stencil operator tests
@testset "FD operators" begin
    @test   d_dxa == d_dxa_sol
    @test   d_dya == d_dya_sol
    @test   d_dxi == d_dxi_sol
    @test   d_dyi == d_dyi_sol
    @test d2_dx2a == d2_dx2a_sol
    @test d2_dy2a == d2_dy2a_sol
end