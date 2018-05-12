```bash
nim compile -d:release --opt:speed outcomes.nim
./outcomes
```

'''bash
nim -c -d:release c outcomes.nim
gcc -O3 -c nimcache/stdlib_system.c
gcc -O3 -c nimcache/outcomes.c
gcc -o outcomes nimcache/stdlib_system.o nimcache/outcomes.o
./outcomes
```
