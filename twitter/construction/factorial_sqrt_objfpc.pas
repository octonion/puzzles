program FactorialSqrt;

{$mode objfpc}

uses gset,gqueue,gmap,gutil,gmp;

type
   lessint = specialize TLess<integer>;
   setint = specialize TSet<integer, lessint>;

type
   queueint = specialize TQueue<integer>;

type
   mapint = specialize TMap<integer, integer, lessint>;

var
   queue      : queueint;
   found      : setint;
   paths      : mapint;
   sqrts      : mapint;
   w,v,m,i    : integer;
   bound,n    : mpz_t;
   nn         : integer;
   j          : integer;
   
begin

   mpz_init_set_ui(Bound,20000);

   found := setint.create;
   found.insert(3);

   queue := queueint.create;
   queue.push(3);
   
   paths := mapint.create;
   paths[3] := 3;

   sqrts := mapint.create;
   sqrts[3] := 0;

   while (queue.size>0) do
   begin
      m := queue.front;
      queue.pop;
      mpz_fac_ui(n,m);
      i := 0;

      while (mpz_cmp_ui(n,1)>0) do
      begin
      
         if (mpz_cmp(bound,n)>0) then
         begin

            nn := mpz_get_ui(n);
            if (found.find(nn)=nil) then
            begin
               found.insert(nn);
               queue.push(nn);
               paths[nn] := m;
               sqrts[nn] := i;
            end;
         end;
         
         mpz_sqrt(n,n);
         i := i+1;
      end;
   end;

   for j:=2 to 1000 do
   begin
      if (found.find(j)=nil) then
      begin
         write(j,' ');
      end;
   end;
   writeln;
   writeln;
   
   v := 9;
   while not(v=3) do
   begin
      w := paths[v];
      writeln(V,' <- ',w,'! + ',sqrts[v],' sqrt');
      v := w;
   end;

end.
