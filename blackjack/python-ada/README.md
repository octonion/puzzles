You'll need the gnat dev headers installed e.g. libgnatvsn7-dev.
```bash
gnatmake -Ofast -gnatp -fPIC -c unit
gnatbind -n unit
gcc -Ofast -shared -o libpartitions.so unit.o -L/usr/lib/gcc/x86_64-linux-gnu/7/adalib -lgnat
```
