Divergent Association Task

Main page:
https://www.datcreativity.com/task?

GitHub repo:
https://github.com/jayolson/divergent-association-task

The computation takes about 255 CPU core-hours. The best possible answer appears to be:

109.5832645424675
["includes", "propagandise", "downgraded", "feat", "replies", "briquette", "gamines"]

You will need to download and unzip glove.840B.300d.zip from https://nlp.stanford.edu/projects/glove/

```bash
julia -O 3 --threads 12 brute.jl
```
