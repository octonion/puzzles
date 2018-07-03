```bash
./aw2c outcomes.alw -o outcomes.c
gcc -O3 -L. -I. outcomes.c -lalw -lm -lgc -o outcomes
./outcomes
```
