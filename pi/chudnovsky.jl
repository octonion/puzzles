# Julia version 1.0

setprecision(40000)

function term(k::Integer)
    return((-1)^k*factorial(BigInt(6*k))*(545140134*k+13591409)/( factorial(BigInt(3*k))*(factorial(BigInt(k)))^3*(BigFloat(640320))^(3*k+3/2) ))
end

p = BigFloat(term(0))
q = BigFloat(0)
for i in 1:800
    global q = p
    global p += term(i)
end
println(1/(12*p))
println("Diff = ",1/(12*p)-1/(12*q))

