#!/bin/bash
RELEASE_VERSION=5
BASEBALLDATABANK_DIR=~/src/baseballdatabank
STATS_DB_DIR=~/go/src/github.com/rippinrobr/baseball-stats-db
SEASON=2017

home_dir=`pwd`
cd $BASEBALLDATABANK_DIR
echo "In ${BASEBALLDATABANK_DIR}"
no_update=`git pull origin master | grep up-to-date | wc -l | head -1`

if [ $no_update -eq 1 ]; then
	echo "No update, exiting"
	exit
fi

echo "There was an update, now I need to make a new nightly release"

commit_hash=`git log -1 | head -1 | cut -d\  -f2`
echo "Shortened Hash => ${commit_hash:0-7}"

cd $STATS_DB_DIR
make sqlitedb_bd INC_VERSION=${RELEASE_VERSION} SEASON=${SEASON} 
cd $home_dir
