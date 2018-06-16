sub partitions(@cards, $subtotal) {
    my int $m = 0;
    # Hit
    loop (my $i = 0; $i < 10; $i++) {
	if @cards[$i]>0 {
            my $total = $subtotal+$i+1;
            if $total < 21 {
                # Stand
                $m += 1;
                # Hit again
		@cards[$i] -= 1;
                $m += partitions(@cards, $total);
		@cards[$i] += 1;
            } elsif $total==21 {
                # Stand; hit again is an automatic bust
                $m += 1;
		last;
            }
	}
    }
    return $m;
}

my $d = 0;
my int @deck = 4,4,4,4,4,4,4,4,4,16;

loop (my $i = 0; $i < 10; $i++) {
    # Dealer showing
    @deck[$i] -= 1;
    my $p = 0;
    loop (my $j = 0; $j < 10; $j++) {
        @deck[$j] -= 1;
        $p += partitions(@deck, $j+1);
	@deck[$j] += 1;
    }
    say "Dealer showing ",$i," partitions = ",$p;
    $d += $p;
    @deck[$i] += 1;
}

say "Total partitions = ",$d;
