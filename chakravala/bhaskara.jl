
# Archimedes cattle problem
# Removing factor 2^2*4657^2

#D = 609*7766*2^2*4657^2

#D = int64(609*7766)

D = parse(BigInt,ARGS[1])

sD = isqrt(D)

x_init = BigInt(1)
y_init = BigInt(sD)
h_init = D*x_init^2 - y_init^2

i = mod(-y_init,h_init)*invmod(x_init,h_init)
m_init = h_init*div(sD,h_init)+i

if (m_init>sD)
    m_init += -h_init
end

steps = 0

x = x_init
y = y_init
h = h_init
m = m_init

println("[h, m] = [$h, $m]")

while !(h==1 || h==2 || h==4)

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
println("Solution = [$x, $y, $v]")
println("Steps = $steps")
