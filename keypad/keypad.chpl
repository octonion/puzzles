use BigInteger;
use LinearAlgebra;

var Q = Matrix(6,6,eltType=bigint);
Q = Matrix([0,0,1,0,2,0],
	   [0,0,0,1,0,0],
	   [1,0,0,1,0,2],
	   [0,2,1,0,0,0],
	   [1,0,0,0,0,0],
	   [0,0,1,0,0,0]);

var r = Vector(1,0,0,0,0,0,eltType=bigint);

writeln(+ reduce dot(matPow(Q,1000000),r));
