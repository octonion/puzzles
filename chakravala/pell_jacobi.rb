#!/usr/bin/env ruby

require 'gmp'
require 'prime'
require 'openssl'

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

def factors_of(number)
  primes, powers = number.prime_division.transpose
  exponents = powers.map{|i| (0..i).to_a}
  divisors = exponents.shift.product(*exponents).map do |powers|
    primes.zip(powers).map{|prime, power| prime ** power}.inject(:*)
  end
  #divisors.sort.map{|div| [div, number / div]}
  divisors.sort.map{|div| div}
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

# Solving y^2 - D*x^2 = 1

# Archimedes cattle problem
# Removing factor 2^2*4657^2

#a = 609*7766*2**2*4657**2
arg = eval(ARGV[0])

# Squarefree part
d = squarefree_part(arg)

# Square part
s = arg/d

sd = Integer.sqrt(d)

x_init = 1
y_init = sd
h_init = d*x_init**2 - y_init**2

i = (-y_init % h_init)*(x_init.to_bn.mod_inverse(h_init)) % h_init
m_init = h_init*(sd/h_init).floor+i

if (m_init>sd)
  m_init += -h_init
end

steps = 0

x = x_init
y = y_init
h = h_init
m = m_init

print
print("[h, m] = [#{h}, #{m}]\n")

while not([1,2,4].include?(h))

  #print("[x, y, h, m] = [#{x}, #{y}, #{h}, #{m}]\n")

  x = (m_init*x_init+y_init)/h_init
  y = (d*x_init+m_init*y_init)/h_init

  h = (d-m_init**2)/h_init

  #print("[x, y, h, m] = [#{x}, #{y}, #{h}, #{m}]\n")

  i = (-y % h)*(x.to_bn.mod_inverse(h)) % h
  m = h*(sd/h).floor+i

  #print("[x, y, h, m] = [#{x}, #{y}, #{h}, #{m}]\n")

  if (m>sd)
    m += -h
  end

  #print("[x, y, h, m] = [#{x}, #{y}, #{h}, #{m}]\n")

  x_init = x
  y_init = y
  h_init = h
  m_init = m
  steps = steps+1

  print("[h, m] = [#{h}, #{m}]\n")
end

print("\n")
print("h = #{h}\n")

if h==1 && (steps % 2)==0

  x, y = 2*x*y, d*x**2+y**2
  
elsif h==2
  
  x, y = 2*x*y, d*x**2+y**2
  x, y = x/2, y/2
  
elsif h==4
  
  a, b = Rational(x,2), Rational(y,2)
  
  if a.is_a?(Integer) && b.is_a?(Integer)
    
    x, y = a.to_i, b.to_i
    
  else

    a_1, b_1 = 2*a*b, d*a**2+b**2
    
    if a_1.is_a?(Integer) && b_1.is_a?(Integer)
      x, y = a_1.to_i, b_1.to_i
    else
      
      x, y = a*b_1+a_1*b, b*b_1+d*a*a_1
      if (steps % 2)==0
        x, y = 2*x*y, d*x**2+y**2
      end
      x, y = x.to_i, y.to_i
      
    end
    
  end
end

#v = y**2-d*x**2
print("\n")
print("squarefree equation: #{d}*x^2 + 1 = y^2\n")
#print("squarefree solution = [#{x}, #{y}, #{v}]\n")
print("steps = #{steps}\n")

# Find power for each p^k factor, take LCM

e = 1

if (s>1)

  rs = Integer.sqrt(s)
  rs_pd = rs.prime_division

  powers = []

  a = Pell.new(x, y, d)
    
  for prime,exponent in rs_pd

    if !(prime==2)
      j = GMP::Z.jacobi(GMP::Z(d),GMP::Z(prime))
      #print("prime = #{prime}, j = #{j}\n")
      if (j==1)
        order = prime**(exponent-1)*(prime-1)
      elsif (j==-1)
        order = prime**(exponent-1)*((prime+1)/2)
      else
        order = prime**exponent
      end
    else
      j = nil
      if (exponent==1) and !(d%2==0)
        order = prime
      else
        order = prime**(exponent-1)
      end
    end
    
    m = prime**exponent
        
    b = Pell.new(a.x % m, a.y % m, a.d)
    ##c = b
    ##r = b.x

    if (order>1)
      fo = factors_of(order)
    else
      fo = [1]
    end
    #print(fo,"\n")

    fo.each do |factor|
      #print(factor,"\n")
      #if (factor==fo[-1])
      #  i = factor
      #  break
      #end
      r = (b**factor).x % m
      if (r==0)
        i = factor
        break
      end
    end

    ##k = 1
    ##r = b.x
    ##while not(r==0)
    ##  c = c*b
    ##  r = c.x % m
    ##  k += 1
    ##end

    ##if !(prime==2)
    ##  print("p = #{prime}, e = #{exponent}, j = #{j}, O = #{order}, i = #{i}, o = #{k}, o | O ? = #{order%k==0}\n")
    ##else
    ##  print("p = #{prime}, e = #{exponent}, O = #{order}, i = #{i}, o = #{k}, o | O ? = #{order%i==0}\n")
    ##end

    if !(prime==2)
      print("p = #{prime}, e = #{exponent}, j = #{j}, O = #{order}, o = #{i}, o | O ? = #{order%i==0}\n")
    else
      print("p = #{prime}, e = #{exponent}, O = #{order}, o = #{i}, o | O ? = #{order%i==0}\n")
    end
    powers.append(i)
  end

  #print(powers,"\n")
  e = powers.reduce(1, :lcm)
  #print(e,"\n")
  #b = a**e
  #x, y = (b.x/rs).floor, b.y
end

#v = y**2-arg*x**2
print("\n")
print("full equation: #{arg}*x^2 + 1 = y^2\n")
#print("full solution = [#{x}, #{y}, #{v}]\n")
print("power = #{e}\n")
#print("#{Math.log(x, 10).floor+1}, #{Math.log(y, 10).floor+1}\n")
#print("#{x.to_s.length}, #{y.to_s.length}\n")
