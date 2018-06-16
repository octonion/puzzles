sub partitions(@$)
{
    my @cards = @{$_[0]};
    my $subtotal = $_[1];
    my $m = 0;
    # Hit
    for(my $i = 0; $i<10; $i++) {
	if ($cards[$i]>0) {
            my $total = $subtotal+$i+1;
            if ($total < 21) {
                # Stand
                $m += 1;
                # Hit again
		$cards[$i] = $cards[$i]-1;
                $m += partitions(\@cards,$total);
                $cards[$i] = $cards[$i]+1;
            } elsif ($total==21) {
                # Stand; hit again is an automatic bust
                $m += 1;
		break;
            }
	}
    }
    return $m;
}

my $d = 0;
my @deck = (4,4,4,4,4,4,4,4,4,16);

for(my $i = 0; $i<10; $i++) {
    # Dealer showing
    $deck[$i] = $deck[$i]-1;
    my $p = 0;
    for(my $j = 0; $j<10; $j++) {
        $deck[$j] = $deck[$j]-1;
        my $n = partitions(\@deck,$j+1);
        $deck[$j] = $deck[$j]+1;
        $p += $n;
    }

    print "Dealer showing ",$i," partitions = ",$p,"\n";
    $d += $p;

    $deck[$i] = $deck[$i]+1;
}

print "Total partitions = ",$d,"\n";
