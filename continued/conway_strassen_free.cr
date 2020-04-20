require "big/big_int"

# 609*7766*2**2*4657**2
# D = 609*7766

D = BigInt.new(ARGV[0])

print("D = #{D}\n")

s = BigInt.new(Math.sqrt(D).floor)

a = BigInt.new(1)

# Reduced form

m = BigInt.new(Math.sqrt(2+D).floor)
b = BigInt.new(2*m)
c = BigInt.new(m**2-D)

sD = BigInt.new(Math.sqrt(b**2-4*a*c).floor)

d = BigInt.new((b+sD)//(2*c.abs()))

if (c<0)
  d = -d
end

p11 = BigInt.new(0)
p12 = BigInt.new(1)
p21 = BigInt.new(-1)
p22 = BigInt.new(-d)

i = 0

while (c!=1)

  i += 1

  a1 = c
  b1 = -b+2*c*d
  c1 = a-b*d+c*d**2

  a = a1
  b = b1
  c = c1

  d = (b+sD)//(2*c.abs())

  if (c<0)
    d = -d
  end

  dp12 = d*p12
  dp22 = d*p22
  
  q = p21
  r = p11
  p11 = p12
  p12 = -r+dp12
  p21 = p22
  p22 = dp22-q

end

print("Steps = #{i}\n")

print("x = #{(p11+m*p21).abs()}\n")
print("y = #{p21.abs()}\n")
