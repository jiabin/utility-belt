#!/bin/bash
# MongoDB S3 Backup
# Requires s3cmd
if [ "$#" == "0" ]; then
    echo "Usage: $0 [s3-bucket]"
    exit 1
fi

DBHOST="127.0.0.1"
DBPORT="27017"

BUCKET=$1
PREFIX="mongodb"
HOSTNAME=`hostname`
DATE=`date +%Y-%m-%dT%H-%M-%S`
OUTNAME=$PREFIX-$HOSTNAME-$DATE

mkdir $OUTNAME
mongodump --host=$DBHOST:$DBPORT --out=$OUTNAME

tar -zcvf $OUTNAME.tar.gz $OUTNAME
rm -rf $OUTNAME

s3cmd put $OUTNAME.tar.gz s3://$BUCKET