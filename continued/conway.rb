#!/usr/bin/env ruby

require 'matrix'

D = eval(ARGV[0])

print("D = #{D}\n")

s = Integer.sqrt(D)

a = 1

# Reduced form

m = Integer.sqrt(2+D)
b = 2*m
c = m**2-D

MR = Matrix[[1,-m],[0,1]]
ML = Matrix[[1,m],[0,1]]

sD = Integer.sqrt(b**2-4*a*c)

d = (b+sD)/(2*c.abs)

if (c<0)
  d = -d
end

p = -Matrix[[0,1],[-1,-d]]

i = 0

while c!=1

  i += 1

  a1 = c
  b1 = -b+2*c*d
  c1 = a-b*d+c*d**2

  a = a1
  b = b1
  c = c1

  d = (b+sD)/(2*c.abs)

  if (c<0)
    d = -d
  end

  p = p*Matrix[[0,-1],[1,d]]

end

print("Steps = #{i}\n")

pa = ML*p*MR

print("x = #{pa[0,0].abs}\n")
print("y = #{pa[1,0].abs}\n")
