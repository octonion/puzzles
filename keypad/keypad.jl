using LinearAlgebra

Q = Array{BigInt,2}([0 0 1 0 2 0; 0 0 0 1 0 0; 1 0 0 1 0 2; 0 2 1 0 0 0; 1 0 0 0 0 0; 0 0 1 0 0 0])

r = Array{BigInt,2}([1 0 0 0 0 0]')

p = sum(Q^1000000*r)

println(p)
#print Q.eigenvalues()
