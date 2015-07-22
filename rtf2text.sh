#!/bin/bash
set -x
src=$1
dst=$2
if file $src | grep -q "Rich Text Format"
then 
 unoconv -f html -o $dst $src
 cp $dst /abitura/stale/
else
 name=`basename $dst`
 cp /abitura/stale/$name $dst 
fi
