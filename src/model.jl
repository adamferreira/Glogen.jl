using Random

abstract type GlogenModel end

#bits(x,y,ϵ,type::Type{<:Integer}) = Δ(x,y) .* 10.0 .^ ϵ .|> log2 .|> ceil .|> type

lo(x::Interval) = x.lo
hi(x::Interval) = x.hi
Δ(x::Interval) = hi(x) - lo(x)
# Minimal number of bits required to encode every number (with ϵ precision) in the interval
# The domain of a given variable will be split into Δ*10**ϵ equals parts
# We seek n the number of equal chunks : 
# We seek n such that Δ*10**ϵ is in [2**(n-1), 2**n]
# n-1 <= log2(Δ*10**ϵ) <= n
# n = ceil(log2(Δ*10**ϵ))
# n bits a required for the binary coding
# ϵ is the floating point precision we seek for binary representation
# integer number of digits
# ϵ is 0 for integer variables
bits(x::Interval, ϵ::T, type::Type{T}) where {T<:Integer} = Δ(x) * 10 ^ ϵ |> log2 |> ceil |> type
bits(x::Interval, ϵ::Integer = 3) = bits(x, ϵ, Int)

# Returns binary representation of the cartesian product of the intervals with ϵ precision
# This is a BitArray with the minimal number of bits required to represents
# Every combination possible in the cartesian product of x
# With ϵ floating point precision
bindna(bnds, ϵ::Vector{Integer}) = BitArray(undef, sum(bits.(bnds, ϵ, Integer)))
bindna(bnds) = BitVector(undef, sum(bits.(bnds)))

# Select a random value inside the interval
Random.rand(x::Interval) = x.lo + 2. * radius(x) * rand(typeof(x.lo))

# Creates a random interval
function Random.rand(::Type{Interval{T}}) where {T<:AbstractFloat}
    a, b = Random.rand(T), Random.rand(T)
    return rand(UInt16) * (min(a,b)..max(a,b))
end

function Random.rand(::Type{Interval{T}}) where {T<:Integer}
    a, b = Random.rand(T), Random.rand(T)
    return min(a,b)..max(a,b)
end

function optimize(f, bnds, ϵ, x₀, min = false)
    # Cache lower bounds
    l = lo.(bnds)
    # Cache variables interval sizes
    d = Δ.(bnds)
    # Cache bit size representations
    n = bits.(bnds, ϵ)
    # Cache slices sizes
    slices = d ./ ((1 .<< n) .- 1)

    # Temporary random selection
    x₀ = Random.rand.(bnds)
    
    @show l
    @show d
    @show n
    @show slices
    @show x₀
end