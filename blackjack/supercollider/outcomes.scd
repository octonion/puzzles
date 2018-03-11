var partitions = { arg cards, subtotal;
    var m, total;
    m = 0;
    // Hit
    for (0,9, {arg i;
        if (cards[i]>0,{
            total = subtotal+i+1;
            if (total<21,{
                cards[i] = cards[i]-1;
                // Stand
                m = m+1;
                // Hit again
                m = m+partitions.value(cards, total);
                cards[i] = cards[i]+1;
            });
            if (subtotal+i+1==21,{
                // Stand; hit again is an automatic bust
                m = m+1;});
            });
    });
    m;
};

var deck = Array.with(4,4,4,4,4,4,4,4,4,16);
var d = 0;
var p;

for (0, 9, { arg i;
    // Dealer showing
    deck[i] = deck[i]-1;
    p = 0;
    for (0, 9, { arg j;
        deck[j] = deck[j]-1;
        p = p+partitions.value(deck, j+1);
        deck[j] = deck[j]+1;});
    "Dealer showing ".post; i.post; " partitions = ".post; p.postln;
    d = d+p;
    deck[i] = deck[i]+1;
});

"Total partitions = ".post; d.postln;

0.exit;
