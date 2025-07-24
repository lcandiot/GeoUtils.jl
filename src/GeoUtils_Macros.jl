# Operating on entire Arrays
"""
# Expression:

    @Av(A) = 0.25 * (A[1:end-1, 1:end-1] + A[2:end, 1:end-1] + A[1:end-1, 2:end] + A[2:end, 2:end])

# Description:

Calculates the average of an array in two dimensions on the fly. This macro is useful mainly together with stencil operations.
"""
macro Av(A)    esc(:( ($A[1:end-1, 1:end-1] .+ $A[2:end, 1:end-1] .+ $A[1:end-1, 2:end] .+ $A[2:end, 2:end]) .* 0.25 )) end

"""
# Expression:

    @Av_xi(A) = 0.5 * (A[1:end-1, 2:end-1] + A[2:end, 2:end-1])

# Description:

Calculates the average of an array in the first dimension on the fly only considering the inner points of the second dimension. This macro is useful mainly together with stencil operations.
"""
macro Av_xi(A) esc(:( ($A[1:end-1, 2:end-1] .+ $A[2:end, 2:end-1]) .* 0.5 )) end

"""
# Expression:

    @Av_yi(A) = 0.5 * (A[2:end-1, 1:end-1] + A[2:end-1, 2:end])

# Description:

Calculates the average of an array in the second dimension on the fly only considering the inner points of the first dimension. This macro is useful mainly together with stencil operations.
"""
macro Av_yi(A) esc(:( ($A[2:end-1, 1:end-1] .+ $A[2:end-1, 2:end]) .* 0.5 )) end

"""
# Expression:

    @Av_xa(A) = 0.5 * (A[1:end-1, :] + A[2:end, :])

# Description:

Calculates the average of an array in the first dimension on the fly only considering all points of the second dimension. This macro is useful mainly together with stencil operations.
"""
macro Av_xa(A) esc(:( ($A[1:end-1, :] .+ $A[2:end, :]) .* 0.5 )) end

"""
# Expression:

    @Av_ya(A) = 0.5 * (A[:, 1:end-1] + A[:, 2:end])

# Description:

Calculates the average of an array in the second dimension on the fly only considering all points of the first dimension. This macro is useful mainly together with stencil operations.
"""
macro Av_ya(A) esc(:( ($A[:, 1:end-1] .+ $A[:, 2:end]) .* 0.5 )) end

# Operate on the stencil level
"""
# Expression:

    @inn_x(A) = A[idx + 1, idy]

# Description:

Use the only the inner array points in the first dimension. This macro is useful mainly together with stencil operations.
"""
macro inn_x(A)  esc(:( $A[idx + 1, idy    ])) end

"""
# Expression:

    @inn_y(A) = A[idx, idy + 1]

# Description:

Use the only the inner array points in the second dimension. This macro is useful mainly together with stencil operations.
"""
macro inn_y(A)  esc(:( $A[idx    , idy + 1])) end

"""
# Expression:

    @d_dxa(A) = (A[idx + 1, idy] - A[idx, idy])

# Description:

Stencil operator that calculates the forward finite difference in the first dimension using all points of the second dimension.
"""
macro d_dxa(A)  esc(:( ($A[idx + 1, idy    ] - $A[idx, idy     ]))) end

"""
# Expression:

    @d_dya(A) = (A[idx, idy + 1] - A[idx, idy])

# Description:

Stencil operator that calculates the forward finite difference in the second dimension using all points of the first dimension.
"""
macro d_dya(A)  esc(:( ($A[idx    , idy + 1] - $A[idx, idy     ]))) end

"""
# Expression:

    @d_dxi(A) = (A[idx + 1, idy + 1] - A[idx, idy + 1])

# Description:

Stencil operator that calculates the forward finite difference in the first dimension using only the inner points of the second dimension.
"""
macro d_dxi(A)  esc(:( ($A[idx + 1, idy + 1] - $A[idx, idy + 1]))) end

"""
# Expression:

    @d_dyi(A) = (A[idx + 1, idy + 1] - A[idx + 1, idy])

# Description:

Stencil operator that calculates the forward finite difference in the second dimension using only the inner points of the first dimension.
"""
macro d_dyi(A)  esc(:( ($A[idx + 1, idy + 1] - $A[idx + 1, idy]))) end

"""
# Expression:

    @d2_dx2a(A) = (A[idx + 1, idy] - 2.0 * A[idx, idy] + A[idx - 1, idy])

# Description:

Stencil operator that caculates the 2nd order central finite difference in the first dimension using all points of the second dimension.
"""
macro d2_dx2a(A) esc(:( ($A[idx + 1, idy    ] - 2.0 * $A[idx, idy] + $A[idx - 1, idy    ]) )) end

"""
# Expression:

    @d2_dy2a(A) = (A[idx, idy + 1] - 2.0 * A[idx, idy] + A[idx, idy - 1])

# Description:

Stencil operator that caculates the 2nd order central finite difference in the second dimension using all points of the first dimension.
"""
macro d2_dy2a(A) esc(:( ($A[idx,     idy + 1] - 2.0 * $A[idx, idy] + $A[idx,     idy - 1]) )) end

"""
# Expression:

    @av(A) = 0.25 * (A[idx, idy] + A[idx + 1, idy] + A[idx, idy + 1] + A[idx + 1, idy + 1])

# Description:

Stencil operator that calculates the average of neighbouring cell values.
"""
macro av(A)    esc(:( ($A[idx, idy] + $A[idx + 1, idy] + $A[idx, idy + 1] + $A[idx + 1, idy + 1]) * 0.25 )) end

"""
# Expression:

    @av_xa(A) = 0.5 * (A[idx, idy] + A[idx + 1, idy])

# Description:

Stencil operator that calculates the average of neighbouring cells along the first dimension using all points of the second dimension.
"""
macro av_xa(A) esc(:( ($A[idx, idy] + $A[idx + 1, idy]) * 0.5 )) end

"""
# Expression:

    @av_ya(A) = 0.5 * (A[idx, idy] + A[idx, idy + 1])

# Description:

Stencil operator that calculates the average of neighbouring cells along the second dimension using all points of the first dimension.
"""
macro av_ya(A) esc(:( ($A[idx, idy] + $A[idx, idy + 1]) * 0.5 )) end

"""
# Expression:

    @av_xi(A) = 0.5 * (A[idx, idy + 1] + A[idx + 1, idy + 1])

# Description:

Stencil operator that calculates the average of neighbouring cells along the first dimension using only the inner points of the second dimension.
"""
macro av_xi(A) esc(:( ($A[idx, idy + 1] + $A[idx + 1, idy + 1]) * 0.5 )) end

"""
# Expression:

    @av_yi(A) = 0.5 * (A[idx + 1, idy] + A[idx + 1, idy + 1])

# Description:

Stencil operator that calculates the average of neighbouring cells along the second dimension using only the inner points of the first dimension.
"""
macro av_yi(A) esc(:( ($A[idx + 1, idy] + $A[idx + 1, idy + 1]) * 0.5 )) end