#!/bin/sh

WORKSTATION=1
if [ `hostname` = "privet.umiacs.umd.edu" ] ; then
	WORKSTATION=0
fi
if [ `hostname` = "larch.umiacs.umd.edu" ] ; then
	WORKSTATION=0
fi
echo "Don't forget to set WORKSTATION appropriately...";
echo -n "Currently set to: "
if [ "$WORKSTATION" = "1" ] ; then
	echo Workstation
else
	echo Server
fi

dir=`pwd`
while [ $# -ge 1 ]; do
	name=`echo $1 | sed 's/_.*//'`
	echo "Doing dataset $name in directory ../$1"
	cd ../$1
	# Omit all1 results, since we do not expect those to be relevant
	if [ ! -f $dir/$name.results.txt ] ; then
		sh summarize_all_top.sh | grep -v all1 | grep -v n1 | grep -v v1 > $dir/$name.results.txt
	fi
	cd $dir
	#awk '{print $1}' $name.results.txt > $name.results.names.txt
	# Wall clock time
	#awk '{print $2}' $name.results.txt | cut -d, -f 2 > $name.results.times.txt
	# Max VM footprint
	#awk '{print $2}' $name.results.txt | cut -d, -f 3 > $name.results.vmmax.txt
	# Max RES footprint
	#awk '{print $2}' $name.results.txt | cut -d, -f 4 > $name.results.rsmax.txt
	shift
done

if [ "$WORKSTATION" = "1" ] ; then
	perl plot.pl -w chr22 chr2 whole
else
	perl plot.pl chr22 chr2 whole
fi

echo Done
