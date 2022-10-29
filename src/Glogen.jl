module Glogen

using IntervalArithmetic, Random

# Seed
Random.seed!(6227064)

include("model.jl")

i = [0..5,4..50,6..1000]
ϵ = [3, 3, 1]

optimize(false, i, ϵ, false)

@show rand(Interval{Float64})
@show rand(Interval{Int8})
end