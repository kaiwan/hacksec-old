#!/bin/bash
# ASLR_show.sh
# ASLR = Address Space Layout Randomization
#
# Last Updated : 09Oct2018
# Created      : 15Mar2017
# 
# Author:
# Kaiwan N Billimoria
# kaiwan -at- kaiwantech -dot- com
# kaiwanTECH
# 
# License:
# MIT License.
name=$(basename $0)

test_ASLR_abit()
{
echo '
Quick test: Doing twice: egrep \"heap|stack\" /proc/self/maps'
egrep "heap|stack" /proc/self/maps
echo
egrep "heap|stack" /proc/self/maps
}

# ASLR_try
# Parameters:
# $1 : integer; value to set ASLR to
ASLR_try()
{
echo -n $1 > /proc/sys/kernel/randomize_va_space
echo -n "Kernel ASLR setting now is: "
cat /proc/sys/kernel/randomize_va_space

case $1 in
 0) echo " : turn OFF ASLR" ;;
 1) echo " : turn ON ASLR only for stack, VDSO, shmem regions" ;;
 2) echo " : turn ON ASLR for stack, VDSO, shmem regions and data segments [OS default]" ;;
 *) echo "Invalid!" ; exit 2 ;;
esac
test_ASLR_abit
}

usage()
{
  echo "Usage: ${name} [ASLR_value] ; 
0 = turn OFF ASLR
1 = turn ON ASLR only for stack, VDSO, shmem regions
2 = turn ON ASLR for stack, VDSO, shmem regions and data segments [OS default]
  "
}


## "main" here
[ $(id -u) -ne 0 ] && {
  echo "${name}: require root"
  exit 1
}
usage

[ ! -f /proc/sys/kernel/randomize_va_space ] && {
	echo "ASLR : no support (very old kernel?)"
	exit 1
}


# KASLR: from 3.14 onwards
mj=$(uname -r |awk -F"." '{print $1}')
mn=$(uname -r |awk -F"." '{print $2}')
[ ${mj} -lt 3 ] && {
	echo "KASLR : 2.6 or earlier kernel, no KASLR support (very old kernel?)"
	exit 1
}
[ ${mj} -eq 3 -a ${mn} -lt 3 ] && {
	echo "KASLR : 3.14 or later kernel required for KASLR support."
	exit 1
}

# ok, we're on >= 3.14
grep -q -w "nokaslr" /proc/cmdline && {
  echo "Kernel ASLR (KASLR) turned OFF! (unusual)"
}  || {
  KASLR=$(grep CONFIG_RANDOMIZE_BASE /boot/config-$(uname -r) |awk -F"=" '{print $2}')
  if [ ${KASLR} = 'y' ]; then
	  echo "Kernel ASLR (KASLR) is On [default]"
  else 
	grep -q -w "kaslr" /proc/cmdline && echo "Kernel ASLR (KASLR) turned ON via cmdline" ||
						echo "Kernel ASLR (KASLR) turned OFF!"
  fi
}

echo -n "ASLR (Address Space Layout Randomization) setting now is: "
cat /proc/sys/kernel/randomize_va_space

[ $# -eq 1 ] && {
 [ $1 -ne 0 -a $1 -ne 1 -a $1 -ne 2 ] && {
   echo "${name}: invalid ASLR value, aborting ..."
   exit 1
 }
 ASLR_try $1
} || {
 test_ASLR_abit
}
exit 0
