
using DataStructures

bound = 20000

queue = [3]

found = SortedSet([3])

paths = Dict([(3,3)])
sqrts = Dict([(3,0)])

while (length(queue)> 0)
    m = popfirst!(queue)
    n = factorial(big(m))
    i = 0
    while (n>3)
        if (n<bound) && !(n in found)
            push!(found,n)
            push!(queue,n)
            paths[n] = m
            sqrts[n] = i
        end
        n = isqrt(n)
        i += 1
    end
end
        
println(found)
println()

v = 9
while (v>3)
    w = paths[v]
    println("$v <- $(w)! + $(sqrts[v]) sqrt")
    global v = w
end
