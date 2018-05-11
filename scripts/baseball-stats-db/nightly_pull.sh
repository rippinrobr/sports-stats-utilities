#!/bin/bash
RELEASE_VERSION=6
SEASON=2017
BASEBALLDATABANK_DIR=~/src/baseballdatabank
STATS_DB_DIR=~/go/src/github.com/rippinrobr/baseball-stats-db
latest_commit_hash=`cat LATEST_DATABANK_COMMIT_HASH`

echo "This is what I fould for a hash ${latest_commit_hash}"
home_dir=`pwd`

cd $BASEBALLDATABANK_DIR
echo "In ${BASEBALLDATABANK_DIR}"

git pull origin master 
files_changed=`git diff-tree --no-commit-id --name-only -r $latest_commit_hash | cut -c 6-`

#echo "Files changed: $files_changed"
if [ "${files_changed}" = "People.csv" ];
then
	echo "only people changed"
	cd $STATS_DB_DIR
	make people
	make people_tar
	
fi
# commit_hash=`git log -1 | head -1 | cut -d\  -f2`
# echo "commit_hash: ${commit_hash}"
# if [ "${latest_commit_hash}" -eq "${commit_hash}" ];
# then 
# 	echo "there are the same has, no new updates" 
# fi

# no_update=`git pull origin master | grep up-to-date | wc -l | head -1`

# if [ $no_update -eq 1 ]; then
# 	echo "No update, exiting"
# 	exit
# fi

# echo "There was an update, now I need to make a new nightly release"

# # commit_hash=`git log -1 | head -1 | cut -d\  -f2`
# # echo "Shortened Hash => ${commit_hash:0-7}"

# # cd $STATS_DB_DIR
# # make sqlitedb_bd INC_VERSION=${RELEASE_VERSION} SEASON=${SEASON} 
cd $home_dir
# echo "${commit_hash}" >./LATEST_DATABANK_COMMIT_HASH
