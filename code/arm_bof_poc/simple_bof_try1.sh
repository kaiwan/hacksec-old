#!/bin/bash
PUT=arm_bof_vuln  # Program Under Test

echo "1. BOF on ${PUT}:"
perl -e 'print "A"x12 . "B"x4 . "C"x4' | ./${PUT}

echo
PUT=arm_bof_vuln_stackprot
echo "2. BOF on ${PUT}:"
echo -n " 2.1 Stack Guard: "
readelf -s ${PUT} |grep -q __stack_chk_guard && echo "Found" || echo "Nope"
perl -e 'print "A"x12 . "B"x4 . "C"x4' | ./${PUT}

echo
PUT=arm_bof_vuln_fortified
echo "3. BOF on ${PUT}:"
perl -e 'print "A"x12 . "B"x4 . "C"x4' | ./${PUT}
