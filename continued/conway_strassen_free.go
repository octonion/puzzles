package main
 
import (
	"fmt"
	"os"
	"math/big"
)

func main() {

	//bigInt := &big.Int{}

	// 609*7766*2**2*4657**2;
	//D := big.NewInt(609*7766*2*2*4657*4657)
	var D big.Int
	D.SetString(os.Args[1],10)
	fmt.Println("D = ",&D)

	a := *big.NewInt(1)

	// Reduced form

	var m,b,c,d big.Int
	var tmp big.Int

	//var b big.Int
	//fmt.Printf("%T\n", m)
	m.Sqrt(m.Add(big.NewInt(2), &D))
	//fmt.Println(&m)
	b.Mul(big.NewInt(2), &m)
	//fmt.Println(&b)
	c.Add(c.Mul(&m,&m), tmp.Neg(&D))
	//fmt.Println(&c)

	var sD big.Int

	tmp.Mul(&a,&c)
	tmp.Mul(big.NewInt(-4),&tmp)
	sD.Sqrt(sD.Add(sD.Mul(&b,&b),&tmp))
	//fmt.Println(&sD)

	tmp.Mul(big.NewInt(2),tmp.Abs(&c))
	d.Div(d.Add(&b,&sD),&tmp)

	if (c.Sign()<0) {
		d.Neg(&d)
	}

	var p11,p12,p21,p22 big.Int
	var a1,b1,c1 big.Int
	//var a1,b1,c1 big.Int
	var dp12,dp22 big.Int
	var q,r big.Int

	p11 = *big.NewInt(0)
	p12 = *big.NewInt(1)
	p21 = *big.NewInt(-1)
	p22.Neg(&d)

	steps := 0

	for (c.Cmp(big.NewInt(1))!=0) {
		//for (steps < 10) {

		//fmt.Println(&a,&b,&c)

		steps += 1

		a1.Set(&c)
		b1.Add(b1.Neg(&b), tmp.Mul(big.NewInt(2),tmp.Mul(&c,&d)))
		c1.Add(&a,c1.Add(c1.Mul(c1.Neg(&b),&d), tmp.Mul(&c,tmp.Mul(&d,&d))))

		a.Set(&a1)
		b.Set(&b1)
		c.Set(&c1)

		//d.Div(d.Add(&b,&sD), tmp.Mul(big.NewInt(2), tmp.Abs(&c)))
		tmp.Mul(big.NewInt(2),tmp.Abs(&c))
		d.Div(d.Add(&b,&sD),&tmp)
		
		if (c.Sign()<0) {
			d.Neg(&d)
		}

		dp12.Mul(&d,&p12)
		dp22.Mul(&d,&p22)
  
		q.Set(&p21)
		r.Set(&p11)
		p11.Set(&p12)
		p12.Add(p12.Neg(&r), &dp12)
		p21.Set(&p22)
		p22.Add(&dp22,p22.Neg(&q))
		
		//fmt.Println(&q,&r,&p11,&p12,&p21,&p22)

	}

	fmt.Println("Steps = ",steps)
	fmt.Println("x = ", tmp.Abs(&p21))
	fmt.Println("y = ", tmp.Abs(tmp.Add(&p11,tmp.Mul(&m,&p21))))
}
