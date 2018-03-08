```bash
createdb test
psql test -f outcomes.sql
psql test -c "select outcomes();"
dropdb test
```
