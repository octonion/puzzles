program FactorialSqrt;

{$mode delphi}

uses Generics.Collections, GMP;

type 
   TlDictionary =  TDictionary<integer, Integer>;
   TlPair = TPair<integer,integer>;
 
var
   Queue      : TQueue<Integer>;
   Found      : TList<Integer>;
   Paths      : TlDictionary;
   Sqrts      : TlDictionary;
   W,V,M,I    : Integer;
   Bound,N    : mpz_t;
   FoundIndex : Int64;
   nn         : Integer;
   j          : Integer;
   
begin

   mpz_init_set_ui(Bound,20000);

   Found := TList<Integer>.Create;
   Found.Add(3);

   Queue := TQueue<Integer>.Create;
   Queue.Enqueue(3);
   
   Paths := TlDictionary.Create;
   Paths.Add(3, 3);

   Sqrts := TlDictionary.Create;
   Sqrts.Add(3, 0);

   while (Queue.Count>0) do
   begin
      m := Queue.Dequeue;
      mpz_fac_ui(n,m);
      i := 0;

      while (mpz_cmp_ui(n,1)>0) do
      begin
      
         if (mpz_cmp(bound,n)>0) then
         begin

            nn := mpz_get_ui(n);
            if not(Found.BinarySearch(nn, FoundIndex)) then
            begin
               Found.Add(nn);
               Found.Sort;
               Queue.Enqueue(nn);
               Paths.Add(nn, m);
               Sqrts.Add(nn, i);
            end;
         end;
         
         mpz_sqrt(n,n);
         i := i+1;
      end;
   end;

   for j:=2 to 1000 do
   begin
      if not(Found.BinarySearch(j, FoundIndex)) then
      begin
         write(j,' ');
      end;
   end;
   writeln;
   writeln;
   
   v := 9;
   while not(v=3) do
   begin
      w := Paths[v];
      writeln(V,' <- ',w,'! + ',Sqrts[v],' sqrt');
      v := w;
   end;

end.
