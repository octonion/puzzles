# Julia version 1.0

setprecision(40000)

function term(k::Integer)
    return(factorial(BigInt(6*k))*(545140134*k+13591409)/( factorial(BigInt(3*k))*(factorial(BigInt(k)))^3*(-BigFloat(262537412640768000))^k ))
end

p = BigFloat(term(0))
q = BigFloat(0)
for i in 1:800
    global q = p
    global p += term(i)
end
println((426880*sqrt(BigFloat(10005)))/p)
println("self diff = ",(426880*sqrt(BigFloat(10005)))/p-(426880*sqrt(BigFloat(10005)))/q)
println("pi diff = ",BigFloat(pi)-(426880*sqrt(BigFloat(10005)))/p)


