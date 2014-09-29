
# Archimedes cattle problem
# Removing factor 2^2*4657^2

#D = 609*7766*2^2*4657^2

#D = int64(609*7766)

D = BigInt(ARGS[1])

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

#while !(h in [BigInt(1),BigInt(2),BigInt(4)])
while !(h==1)

    x = div((m_init*x_init+y_init),h_init)
    y = div((D*x_init+m_init*y_init),h_init)

    #println(D-m_init^2, " ", h_init, " ", div((D-m_init^2),h_init))
    h = div((D-m_init^2),h_init)

    #println(-y," ",x," ",h," ",mod(-y,h)," ",invmod(x,h))
    #i = mod(div(-y,x),h)
    i = mod(mod(-y,h)*invmod(x,h),h)
    
    m = h*div(sD,h)+i
    #println("[x, y, h, i, m] = [$x, $y, $h, $i, $m]")

    if (m>sD)
        m += -h
    end

    #println("m = $m")

    x_init = x
    y_init = y
    h_init = h
    m_init = m
    steps += 1

    println("[h, m] = [$h, $m]")

end

if (steps % 2)==0
    a = x
    b = y
    x = 2*a*b
    y = D*a^2+b^2
end

v = y^2-D*x^2
println("Solution = [$x, $y, $v]")
println("Steps = $steps")

#if (h==2):
#    (x,y) = (2*x*y, D*x**2+y**2)
#    (x,y) = (x/2, y/2)
#elif (h==4):
#    (a, b) = (Rational(x)/2, Rational(y)/2)
#    print(a,b)
#    if (a.is_integral() & b.is_integral()):
#        (x,y) = (a,b)
#    else:
#        (a_1, b_1) = (2*a*b, D*a**2+b**2)
#        print(a_1,b_1)
#        if (a_1.is_integral() & b_1.is_integral()):
#            (x,y) = (a_1,b_1)
#        else:
#            (x, y) = (a*b_1+a_1*b, b*b_1+D*a*a_1)
#            if (steps % 2)==0:
#                (x,y) = (2*x*y, D*x**2+y**2)
#else:
#    if (steps % 2)==0:
#        (x,y) = (2*x*y, D*x**2+y**2)

#v = y**2-D*x**2
#print("Solution = [%s, %s, %s]" % (x, y, v))
#print("Steps = %s" % steps)
