create or replace function partitions(cards int[10], subtotal int)
       returns int as
$$
declare
	m int := 0;
	total int;
begin
    m := 0;
    -- Hit
    for i in 1 .. 10 loop
      if (cards[i]>0) then
        total := subtotal+i;
        if (total < 21) then
	   cards[i] := cards[i]-1;
	   -- Stand
	   m := m+1;
	   -- Hit again
	   m := m+partitions(cards, total);
	   cards[i] := cards[i]+1;
	elsif (total=21) then
          -- Stand; hit again is an automatic bust
          m := m+1;
	end if;
      end if;  
    end loop;
    return m;
end;
$$ language plpgsql;

create or replace function outcomes()
       returns int as
$$
declare
	deck int[10];
	d int;
	p int;
	n int;
begin
	deck := '{4,4,4,4,4,4,4,4,4,16}';
	d := 0;
	for i in 1 .. 10 loop
	  -- Dealer showing
	  deck[i] := deck[i]-1;
	  p := 0;
	  for j in 1 .. 10 loop
	    deck[j] := deck[j]-1;
	    n := partitions(deck, j);
	    deck[j] := deck[j]+1;
	    p := p+n;
	  end loop;
	  raise notice 'Dealer showing % partitions = %',i-1,p;
	  --return next;
          d := d+p;
          deck[i] := deck[i]+1;
        end loop;
	raise notice 'Total partitions = %',d;
	return d;
end;
$$ language plpgsql;
