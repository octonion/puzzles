```bash
gnatmake -Ofast -gnatp -fPIC -c unit
gnatbind -n unit
gcc -Ofast -shared -o libpartitions.so unit.o -L/usr/lib/gcc/x86_64-linux-gnu/7/adalib -lgnat
```
