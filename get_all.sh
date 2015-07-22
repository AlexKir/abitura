#!/bin/bash
#set -x
d=`date +%m%d`
cd /abitura
mkdir -p csv/$d

for f in `ls get_scripts/*pl`
do
 #echo $f
 fname=`basename $f|sed -e 's/\.pl$/\.csv/'`
 vuz=`basename $f|sed -e 's/\.pl$//'`
 perl $f | sort -u > csv/$d/$fname
 perl load2bd.pl $vuz csv/$d/$fname 
done
find /var/lib/nginx/cache -type f -delete
cat csv/$d/* > /var/www/html/abitura/$d.txt
