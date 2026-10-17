#!/usr/bin/ksh
#
# Script for taking snapshots from cron (and only keeping a set number of them)
#
# Written by: A. Hettinger (ahettinger@prominic.net)
#
Version='2.2.0'

help() {
echo "$0

$0 [options] [zfs path]

\tzfs path\tthe path which snapshots need taken for

\toptions
\t\t-p <prefix>\tprefix for snapshot. defaults to 'snapshot'
\t\t-r\t\tRecurse - snapshot all sub-filesystems
\t\t-n #\t\tNumber of snapshots to keep, if 0 do not delete any. Defaults to 0.
\t\t-V\t\tDisplay version and exit.
\t\t-q\t\trun any quiesce/unquiesce commands before/after taking the snapshot.
\t\t-h\t\tdisplay this message and exit."
exit 0
}

runall() {
	find $1 -name $2 |
	while read SCRIPT
	do
		$SCRIPT
	done
}

history=0
prefix='snapshot'
quiesce=false
while getopts "n:p:rqVh" Op
do
case $Op in
	p) prefix="$OPTARG" ;;
	n) history="$OPTARG" ;;
	r) recurse='-r' ;;
	q) quiesce=true ;;
	V) echo $Version; exit 0 ;;
	*) help ;;
esac
done

#goto last operand (zfs path)
shift $(expr $OPTIND - 1)
# strip off trailling slash (if present)
zfspath=$(echo $1 | sed -e 's,\(.\)/$,\1,')
#check that a path was entered
if [ -z "$zfspath" ]; then help; fi

if $quiesce ; then runall /$zfspath "quiesce"; fi
#take snapshot
/usr/sbin/zfs snapshot $recurse $zfspath@$prefix-$(date +%Y%m%d-%H%M)
if $quiesce ; then runall /$zfspath "unquiesce"; fi

# This is a horrible peice of code for parsing something which was never designed to be parsed by a script.
# So we see if a scrub/resilver is not running, and if it is not running we can run deletions.
scrub=$(/usr/sbin/zpool status $(echo $zfspath | cut -d '/' -f1) | /usr/bin/grep -E 'scan:.*(repaired|none|resilvered)')

#date >> /snapshoter.log
#/usr/sbin/zpool status $(echo $zfspath | cut -d '/' -f1) >> /snapshoter.log
#echo " processed: '$scrub'" >> /snapshoter.log

if [ -n "$scrub" ]; then
	#get the number of snapshots
	tmp=$(/usr/sbin/zfs list -rHt snapshot $zfspath | grep $zfspath@$prefix- | wc -l)

	#make sure we really need to delete something
	if [ $tmp -gt $history ] && [ $history -gt 0 ]; then
		# get the listing of entries to delete & delete them
		/usr/sbin/zfs list -rHt snapshot $zfspath | grep $zfspath@$prefix- | head -n $(expr $tmp - $history) | cut -f1 | while read OnePath; do
			/usr/sbin/zfs destroy $recurse $OnePath
		done
	fi
fi
