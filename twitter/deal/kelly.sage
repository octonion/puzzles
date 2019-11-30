# February 27, 2006
# Contestant Peter Montesanti

# Round 1 deal

p(B) = 20*log(B+17000) -( log(B+5)+log(B+10)+log(B+25)+log(B+50)+log(B+75)+log(B+100)+log(B+200)+log(B+300)+log(B+400)+log(B+500)+log(B+1000)+log(B+5000)+log(B+10000)+log(B+25000)+log(B+50000)+log(B+100000)+log(B+200000)+log(B+300000)+log(B+500000)+log(B+1000000) )

print(find_root(p(B), 1, 1000000000, maxiter=1000))

# Round 2 deal

p(B) = 15*log(B+22000) -( log(B+10)+log(B+25)+log(B+75)+log(B+100)+log(B+400)+log(B+500)+log(B+1000)+log(B+5000)+log(B+10000)+log(B+25000)+log(B+50000)+log(B+100000)+log(B+200000)+log(B+300000)+log(B+500000) )

print(find_root(p(B), 1, 1000000000, maxiter=1000))

# Round 3 deal

p(B) = 11*log(B+35000) -( log(B+10)+log(B+25)+log(B+75)+log(B+100)+log(B+400)+log(B+500)+log(B+10000)+log(B+25000)+log(B+50000)+log(B+300000)+log(B+500000) )

print(find_root(p(B), 1, 1000000000, maxiter=1000))

# Round 4 deal

p(B) = 8*log(B+68000) -( log(B+10)+log(B+25)+log(B+75)+log(B+100)+log(B+400)+log(B+10000)+log(B+25000)+log(B+500000) )

print(mean([10,25,75,100,400,10000,25000,500000]).n())

#print(find_root(p(B), 1, 1000000000, maxiter=1000))

# Round 5 deal

p(B) = 6*log(B+125000) -( log(B+10)+log(B+25)+log(B+75)+log(B+100)+log(B+25000)+log(B+500000) )

#print(find_root(p(B), 1, 1000000000, maxiter=1000))

# Round 6 deal

p(B) = 5*log(B+199000) -( log(B+10)+log(B+25)+log(B+100)+log(B+25000)+log(B+500000) )

#print(find_root(p(B), 1, 1000000000, maxiter=1000))

# Round 7 deal

p(B) = 4*log(B+279000) -( log(B+25)+log(B+100)+log(B+25000)+log(B+500000) )

#print(find_root(p(B), 1, 1000000000, maxiter=1000))

# Round 8 deal

p(B) = 3*log(B+359000) - ( log(B+25)+log(B+500000)+log(B+750000) )

print(find_root(p(B), 1, 1000000000, maxiter=1000))
