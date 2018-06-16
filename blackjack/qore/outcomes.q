#!/usr/bin/env qore

int sub partitions($cards, int $subtotal)
{
    my int $m = 0;
    # Hit
    for(my int $i = 0; $i<10; $i++) {
	if ($cards[$i]>0) {
            my int $total = $subtotal+$i+1;
            if ($total<21) {
                # Stand
                $m += 1;
                # Hit again
		$cards[$i] -= 1;
                $m += partitions(\$cards,$total);
                $cards[$i] += 1;
            } else if ($total==21) {
                # Stand; hit again is an automatic bust
                $m += 1;
            }
	}
    }
    return $m;
}

int $d = 0;
list<int> $deck = (4,4,4,4,4,4,4,4,4,16);

for(int $i = 0; $i<10; $i++) {
    # Dealer showing
    $deck[$i] -= 1;
    int $p = 0;
    for(int $j = 0; $j<10; $j++) {
        $deck[$j] -= 1;
        $p += partitions(\$deck,$j+1);
        $deck[$j] += 1;
    }
    printf("Dealer showing %s partitions = %s\n",$i,$p);
    $d += $p;
    $deck[$i] += 1;
}

printf("Total partitions = %s\n",$d);
