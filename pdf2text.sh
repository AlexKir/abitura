#!/bin/bash
src=$1
dst=$2
if file $src | grep -q PDF
then
 pdftotext -layout -nopgbrk $src $dst
 cp $dst /abitura/stale/
else
 name=`basename $dst`
 cp /abitura/stale/$name $dst 
fi
