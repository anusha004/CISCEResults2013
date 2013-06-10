#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'results';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="psql template1 -t -c \"create database results\" > /dev/null 2>&1"
   eval $cmd
fi

psql results -f create_schema_results.sql

cp ./isc_students.csv /tmp
cp ./isc_scores.csv /tmp
chmod 777 /tmp/isc_*.csv
psql results -f load_results_isc.sql
rm -f /tmp/isc_*.csv

exit 0
