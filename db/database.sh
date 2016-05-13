killall postgres
export PGDATA=/usr/local/src/PGDB
echo $PGDATA
rm -fr $PGDATA
mkdir $PGDATA
initdb -D $PGDATA
sleep 2
echo "Starting server now"
pg_ctl -l logfile start 
sleep 2
#dropuser ha-rw 
#dropdb happyanimals 
createuser -r -d -s ha-rw && createdb -O ha-rw happyanimals &&  cat init_database.sql | psql -U ha-rw happyanimals
cat animals.sql | psql -U ha-rw happyanimals
