# February 27, 2006
# Contestant Peter Montesanti

# First deal

p(B) = 20*log(B+17000) -( log(B+5)+log(B+10)+log(B+25)+log(B+50)+log(B+75)+log(B+100)+log(B+200)+log(B+300)+log(B+400)+log(B+500)+log(B+1000)+log(B+5000)+log(B+10000)+log(B+25000)+log(B+50000)+log(B+100000)+log(B+200000)+log(B+300000)+log(B+500000)+log(B+1000000) )

print(find_root(p(B), 1, 1000000000, maxiter=1000))

# Final deal

p(B) = 3*log(B+359000) - ( log(B+25)+log(B+500000)+log(B+750000) )

print(find_root(p(B), 1, 1000000000, maxiter=1000))
