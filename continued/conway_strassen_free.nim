import math
import bigints
import os
import strutils

# 609*7766*2**2*4657**2
# D = 609*7766

let arguments = commandLineParams()

var D = parseInt(string(arguments[0]))
echo "D = ",D

var s = initBigInt(int64(floor(sqrt(float64(D)))))
var a0 = int64(1)

# Reduced form

var m0 = int64(floor(sqrt(float64(2+D))))
var b0 = 2*m0
var c0 = m0^2-D

var sD = initBigInt(int64(floor(sqrt(float64(b0^2-4*a0*c0)))))

var a = initBigInt(a0)
var m = initBigInt(m0)
var b = initBigInt(b0)
var c = initBigInt(c0)

var d = initBigInt(0)

if c<0:
  d = (b+sD) div initBigInt(2)*(-c)
  d = -d
else:
  d = (b+sD) div initBigInt(2)*c

var p11 = initBigInt(0)
var p12 = initBigInt(1)
var p21 = initBigInt(-1)
var p22 = initBigInt(-d)

var dp12 = initBigInt(0)
var dp22 = initBigInt(0)
var q = initBigInt(0)
var r = initBigInt(0)

var a1 = a
var b1 = b
var c1 = c

var i = 0

while (c!=1):
  i += 1
  a1 = c
  b1 = -b+initBigInt(2)*c*d
  c1 = a-b*d+c*d*d
  a = a1
  b = b1
  c = c1

  if (c<0):
    d = (b+sD) div (initBigInt(2)*(-c))
    d = -d
  else:
    d = (b+sD) div (initBigInt(2)*c)

  dp12 = d*p12
  dp22 = d*p22
  
  q = p21
  r = p11
  p11 = p12
  p12 = -r+dp12
  p21 = p22
  p22 = dp22-q

echo "Steps = ",i

var x = p11+m*p21
if x<0:
  x = -x

var y = p21
if y<0:
  y = -y
  
echo "x = ",x
echo "y = ",y
