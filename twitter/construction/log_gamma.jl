using DataStructures
using SpecialFunctions

setprecision(400)

bound = 1000000000

lb = log(bound)

queue = [3]

found = SortedSet([3])

paths = Dict([(3,3)])
sqrts = Dict([(3,0)])

while (length(queue)> 0)
    m = popfirst!(queue)
    x = loggamma(BigFloat(m)+BigFloat(1))
        #one)

    i = 0
    p = ceil(log(2,x/lb))
    q = max(p,0)

    i += q

    n = round(exp(x/2^q))

    while (floor(n)>3)
#        if (n<bound) && !(n in found)
        if !(floor(n) in found)
            push!(found,floor(n))
            push!(queue,floor(n))
            paths[n] = m
            sqrts[n] = i
        end
        #n = isqrt(floor(n))
        n = isqrt(BigInt(floor(n)))
        i += 1
    end
end

for i = 3:9999999
    if !(i in found)
        print("$i ")
        break
    end
end
println()
println()

v = 9
while (v>3)
    w = paths[v]
    println("$v <- $(w)! + $(sqrts[v]) sqrt")
    global v = w
end

println()

v = 522
while (v>3)
   w = paths[v]
   println("$v <- $(w)! + $(sqrts[v]) sqrt")
   global v = w
end

println()

v = 1074
while (v>3)
   w = paths[v]
   println("$v <- $(w)! + $(sqrts[v]) sqrt")
   global v = w
end

println()

v = 1337
while (v>3)
   w = paths[v]
   println("$v <- $(w)! + $(sqrts[v]) sqrt")
   global v = w
end
