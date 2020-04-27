#!/usr/bin/env ruby

require 'prime'

class Pell
  attr_accessor :x, :y, :d

  def initialize(x, y, d)
    @x = x
    @y = y
    @d = d
  end

  def *(other)
    return Pell.new(@x*other.y+@y*other.x,
                    @d*@x*other.x+@y*other.y,
                    @d)
  end
  
  def **(n)
    p = Pell.new(0,1,@d)
    f = self
    m = n

    while m >= 1
        if (m%2)==1
          p = p*f
        end
        m = (m/2).floor
        f = f*f
    end
    return p
  end

end

class Integer
  def proper_divisors
    return [] if self == 1
    primes = prime_division.flat_map{|prime, freq| [prime] * freq}
    (1...primes.size).each_with_object([1]) do |n, res|
      primes.combination(n).map{|combi| res << combi.inject(:*)}
    end.flatten.uniq
  end
end

def jacobi(a, n)
  raise ArgumentError.new "n must be positive and odd" if n < 1 || n.even?
  res = 1
  until (a %= n) == 0
    while a.even?
      a >>= 1
      res = -res if [3, 5].include? n % 8
    end
    a, n = n, a
    res = -res if [a % 4, n % 4] == [3, 3]
  end
  n == 1 ? res : 0
end

def squarefree_part(x)
  sf = 1
  factors = x.prime_division
  for f in factors
    if (f[1] % 2==1)
      sf = sf*f[0]
    end
  end
  return(sf)
end

# 609*7766*2**2*4657**2
# D = 609*7766
D = eval(ARGV[0])

print("D = #{D}\n")

# Squarefree part
sfD = squarefree_part(D)
print(sfD,"\n")

# Square part
sD = D/sfD

a = 1

# Reduced form

m = Integer.sqrt(2+sfD)
b = 2*m
c = m**2-sfD

sDel = Integer.sqrt(b**2-4*a*c)

d = (b+sDel)/(2*c.abs())

if (c<0)
  d = -d
end

p11 = 0
p12 = 1
p21 = -1
p22 = -d

steps = 0

while (c!=1)

  steps += 1

  a1 = c
  b1 = -b+2*c*d
  c1 = a-b*d+c*d**2

  a = a1
  b = b1
  c = c1

  d = (b+sDel)/(2*c.abs())

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

print("Steps = #{steps}\n")

x = p21.abs()
y = (p11+m*p21).abs()

print("x = #{x}\n")
print("y = #{y}\n")

print("squarefree equation: #{sfD}*x^2 + 1 = y^2\n")
print("squarefree solution = [#{x}, #{y}]\n")
print("steps = #{steps}\n")

print("#{x.to_s.length}, #{y.to_s.length}\n")

# Find power for each p^k factor, take LCM

e = 1

if (sD>1)

  rs = Integer.sqrt(sD)
  rs_f = rs.prime_division

  powers = []

  a = Pell.new(x, y, sfD)

  #print(rs_f,"\n")
  for factor in rs_f

    # Need to handle p=2 later
    
    if factor[0]==2
      next
    end
    
    #i = 1
    m = factor[0]**factor[1]
        
    b = Pell.new(a.x % m, a.y % m, a.d)
    r = b.x
    c = b

    j = jacobi((sfD%factor[0]),factor[0])

    order = (factor[0]-j)/2

    power = 1
    for i in order.prime_division
      term = i[0]**i[1]
      ei = order/term
      eb = b**ei
      if (eb.x % m)!=0
        k = 1
        while (eb.x % m)!=0 and k<i[1]
          eb = eb**i[0]
          power = power*i[0]
          k += 1
        end
        if (eb.x % m)!=0
          power = power*i[0]
        end
      end
    end

    powers.append(power)
    
  end

  e = powers.reduce(1, :lcm)
  b = a**e
  x, y = (b.x/rs).floor, b.y
end

#v = y**2-D*x**2
print("\n")
print("full equation: #{D}*x^2 + 1 = y^2\n")
#print("full solution = [#{x}, #{y}]\n")
print("power = #{e}\n")
#print("#{Math.log(x, 10).floor+1}, #{Math.log(y, 10).floor+1}\n")
#print("#{x.to_s.length}, #{y.to_s.length}\n")
