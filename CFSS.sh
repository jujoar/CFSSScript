#!/bin/bash

#NOMBRE=$1
DIRECTORY=$1

if [ -d "$DIRECTORY" ]; then
	tar -cvzf $DIRECTORY.tar.gz $DIRECTORY
	DIRECTORY=$1.tar.gz
fi

gpg --sign --armor $DIRECTORY

openssl ts -query -data $DIRECTORY -cert -sha256 -no_nonce -out request.tsq

cat request.tsq | curl -s -S -H 'Content-Type: application/timestamp-query' --data-binary @- http://tsa.sinpe.fi.cr/tsaHttp/ -o $DIRECTORY.tsr

rm -f request.tsq

openssl sha1 -out $DIRECTORY.sha1 $DIRECTORY
