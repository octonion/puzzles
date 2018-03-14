```bash
gcc -O3 outcomes.c
./a.out
```

```bash
gcc -Ofast outcomes.c
./a.out
```

```bash
mkdir prof
icc -O3 -no-prec-div -xAVX -ipo -prof-gen -prof-dir=prof outcomes.c
./a.out
icc -O3 -no-prec-div -xAVX -ipo -prof-use -prof-dir=prof outcomes.c
./a.out
rm -rf prof
```

```bash
 gcc -O3 -march=native -pg -fprofile-generate outcomes.c
 ./a.out
 gcc -O3 -march=native -fprofile-use outcomes.c
 ```
