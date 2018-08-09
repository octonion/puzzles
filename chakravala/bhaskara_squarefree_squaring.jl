# Julia version 1.0

# You will need to install Primes:
# pkg> add Primes
# Primes was in base Julia in earlier versions

using Primes

# Can import operators this way; not stylistically preferred

#import Base: +
#import Base: *
#import Base: ^

# To explictly import

#Base.(:(+))
#Base.(:(*))
#Base.(:(^))

mutable struct modular
    x
    d
    function modular(x, d)
        x = mod(x, d)
        new(Int64(x), Int64(d))
    end
end

function Base.:(+)(a::modular, b::modular)
    if !(a.d == b.d)
        error("error: modulus must be the same")
    end
    modular(a.x+b.x, a.d)
end

function Base.:(*)(a::modular, b::modular)
    if !(a.d == b.d)
        error("error: modulus must be the same")
    end
    modular(a.x*b.x, a.d)
end

mutable struct Pell
    x
    y
    D
end

function Base.:(*)(p1::Pell, p2::Pell)
    if !(p1.D == p2.D)
        error("error: D must be the same")
    end
    Pell(p1.x*p2.y+p1.y*p2.x, p1.D*p1.x*p2.x+p1.y*p2.y, p1.D)
end

function Base.:(^)(p1::Pell, n::Integer)
    P = Pell(0,1,p1.D)
    F = p1
    m = n
    while m >= 1
        if (m % 2==1)
            P = P*F
        end
        m = floor(m/2)
        F = F*F
    end
    P
end

function squarefree_part(x)
    sf = 1
    f = factor(x)
    for key in keys(f)
       if (f[key] % 2==1)
           sf = sf*key
       end
    end
    return(sf)
end

# Archimedes cattle problem
# Removing factor 2^2*4657^2

#D = 609*7766*2^2*4657^2

#D = int64(609*7766)

# Deprecated
#d = BigInt(ARGS[1])

d = parse(BigInt,ARGS[1])

D = squarefree_part(d)
S = div(d,D)

sD = isqrt(D)

x_init = BigInt(1)
y_init = BigInt(sD)
h_init = D*x_init^2 - y_init^2

i = mod(-y_init,h_init)*invmod(x_init,h_init)
m_init = h_init*div(sD,h_init)+i

if (m_init>sD)
    m_init += -h_init
end

(x, y, h, m) = (x_init, y_init, h_init, m_init)
steps = 0

println("[h, m] = [$h, $m]")

while !(h==1 || h==2 || h==4)

    global x_init, y_init, h_init, m_init
    global x, y, h, m
    global i, steps

    x = div((m_init*x_init+y_init),h_init)
    y = div((D*x_init+m_init*y_init),h_init)

    h = div((D-m_init^2),h_init)
    i = mod(mod(-y,h)*invmod(x,h),h)
    
    m = h*div(sD,h)+i

    if (m>sD)
        m += -h
    end

    (x_init, y_init, h_init, m_init) = (x, y, h, m)
    steps += 1

    println("[h, m] = [$h, $m]")

end

if (h==1) && (steps % 2)==0
    
    (x, y) = (2*x*y, D*x^2+y^2)
    
elseif (h==2)

    # Separated to illustrate the algorithmic steps
    
    (x, y) = (2*x*y, D*x^2+y^2)
    (x, y) = (div(x,2), div(y,2))
    
elseif (h==4)

    # Need to use rational arithmetic to handle certain cases
    
    (a, b) = (x//2, y//2)
    
    if (isinteger(a) && isinteger(b))
        (x, y) = (num(a), num(b))
    else
        (a_1, b_1) = (2*a*b, D*a^2+b^2)

        if (isinteger(a_1) && isinteger(b_1))
            (x, y) = (num(a_1), num(b_1))
        else
            (x, y) = (num(a*b_1+a_1*b), num(b*b_1+D*a*a_1))
            if (steps % 2)==0
                (x,y) = (2*x*y, D*x^2+y^2)
            end
        end
    end

end

v = y^2-D*x^2
println("squarefree equation: $D*x^2 + 1 = y^2")
println("squarefree solution = [$x, $y, $v]")
println("steps = $steps")

e = 1
if (S>1)

    rS = isqrt(S)
    rS_f = factor(rS)

    powers = Int64[]
    A = Pell(x, y, D)

    for factor in rS_f

        local B

        M = factor[1]^factor[2]
        B = Pell(modular(A.x, M), modular(A.y, M), modular(A.D, M))

        r = B.x
        C = B

        j = 1
        while !(r.x==0)
            C = C*B
            r = C.x
            j += 1
        end
        push!(powers,j)
    end

    e = lcm(powers)
    B = A^e
    #println(typeof(B.x))
    #println(typeof(rS))
    (x, y) = (floor(Integer, B.x/rS), B.y)
end

#println(typeof(x))
#println(typeof(y))
#println(typeof(d))
v = y^2-d*x^2
print
println("full equation: $d*x^2 + 1 = y^2")
println("full solution = [$x, $y, $v]")
println("power = $e")

println(floor(BigInt, log10(x)+1), " ", floor(BigInt, log10(y)+1))
