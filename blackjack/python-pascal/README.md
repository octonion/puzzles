```bash
fpc -olibpartitions.so partitions.pas
python outcomes2.py
python3 outcomes3.py
```

```bash
fpc -O4 -olibpartitions.so partitions.pas
python outcomes2.py
python3 outcomes3.py
```

```bash
fpc -O4 -FWpartitions-1.wpo -OWall -CX -XX -Xs- -al -olibpartitions.so partitions.pas
fpc -O4 -FWpartitions-2.wpo -OWall -Fwpartitions-1.wpo -Owall -CX -XX -Xs- -al -olibpartitions.so partitions.pas
fpc -O4 -Fwpartitions-2.wpo -Owall -CX -XX -Xs- -al -olibpartitions.so partitions.pas
python outcomes2.py
python3 outcomes3.py
```
