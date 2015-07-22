#!/bin/bash 
#set -x
url=$1
src=$2
dst=$3
wget -q -O $src $url
if file $src | grep -q PDF
then
 pdftotext -layout -nopgbrk $src $dst
 cp $dst /abitura/stale/
else
 name=`basename $dst`
 cp /a	bitura/stale/$name $dst 
fi
