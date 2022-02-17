d = 800

#Sum[ (-1)^m * Binomial[d-1,m] * Binomial[m,j] * ((j+2)!)/(m+1)^(j+3),{m,0,d},{j,0,d} ]

print()
print("2 copies, 800 coupons.")

# Myers & Wilf exact expectation

ev = d^2*sum((-1)^m*binomial(d-1,m)*binomial(m,j)*factorial(j+2)/(m+1)^(j+3) for m in [0..(d-1)] for j in [0..m])


print()
print("Myers & Wilf, exact EV =", ev.n())

ev = 1-d+lambert_w(-1,((-1+d)/d)**d * (exp(-euler_gamma)+1/d)*log((-1+d)/d))/log((-1+d)/d)

print()
print("Lambert W approximation, EV =", ev.n())
