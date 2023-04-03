#!/bin/bash

echo -n "user: "
read user

echo -n "host: "
read host

echo -n "port: "
read port

echo -n "database: "
read database

echo -n "dump_file: "
read dump_file

echo "database is $database"
echo "host is $host"
echo "port is $port"

psql -h $host -p $port -U $user $database < $dump_file
