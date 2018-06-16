#!/usr/bin/env qore

sub partitions($cards, $subtotal) {
    my $m = 0;
    # Hit
    for(my $i = 0; $i<10; $i++) {
	if ($cards[$i]>0) {
            my $total = $subtotal+$i+1;
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
		break;
            }
	}
    }
    return $m;
}

$d = 0;
$deck = (4,4,4,4,4,4,4,4,4,16);

for($i = 0; $i<10; $i++) {
    # Dealer showing
    $deck[$i] -= 1;
    $p = 0;
    for($j = 0; $j<10; $j++) {
        $deck[$j] -= 1;
        $p += partitions(\$deck,$j+1);
        $deck[$j] += 1;
    }
    printf("Dealer showing %s partitions = %s\n",$i,$p);
    $d += $p;
    $deck[$i] += 1;
}

printf("Total partitions = %s\n",$d);
