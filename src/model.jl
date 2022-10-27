abstract type GlogenModel end

struct BoundedModel{FloatType<:AbstractFloat, PrecType<:Integer}
    # Variable bounds (do not type ?)
    bnds::Vector{Interval{FloatType}}
    # ϵ is the floating point precision we seek for binary representation
    # integer number of digits
    # ϵ is 0 for integer variables
    ϵ::Vector{PrecType}
    # The domain of a given variable will be split into Δ*10**ϵ equals parts
    # We seek n the number of equal chunks : 
    # We seek n such that Δ*10**ϵ is in [2**(n-1), 2**n]
    # n-1 <= log2(Δ*10**ϵ) <= n
    # n = ceil(log2(Δ*10**ϵ))
    # n bits a required for the binary coding
    n::Vector{UInt64}
    # Cache, store Δ for efficiency purposes ?
    BoundedModel{FloatType, PrecType}(bnds, ϵ) where {FloatType<:AbstractFloat, PrecType<:Integer} = new(
        bnds,
        ϵ,
        bits(bnds, ϵ, PrecType)
    )
end
#bits(x,y,ϵ,type::Type{<:Integer}) = Δ(x,y) .* 10.0 .^ ϵ .|> log2 .|> ceil .|> type

lo(x::Interval) = x.lo
hi(x::Interval) = x.hi
Δ(x::Interval) = hi(x) - lo(x)
bits(x::Interval, ϵ::T, type::Type{T}) where {T<:Integer} = Δ(x) * 10 ^ ϵ |> log2 |> ceil |> type
bits(x::Interval) = bits(x, 3, Int)