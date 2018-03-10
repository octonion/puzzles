```bash
fpc -O4 outcomes.p
./outcomes
```

```bash
fpc -O4 -FWoutcomes-1.wpo -OWall -CX -XX -Xs- -al outcomes.p
fpc -O4 -FWoutcomes-2.wpo -OWall -Fwoutcomes-1.wpo -Owall -CX -XX -Xs- -al outcomes.p
fpc -O4 -Fwoutcomes-2.wpo -Owall -CX -XX -Xs- -al outcomes.p
./outcomes
```
