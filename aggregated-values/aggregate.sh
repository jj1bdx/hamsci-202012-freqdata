#!/bin/sh
cat ../measured-values/JJ1BDX_Z_*-freq.txt | awk '$2 > 990' | sort -n > jj1bdx-eclipse-202012-freq.txt
cat ../measured-values/JJ1BDX_Z__2020-12-*.pps.txt | awk '$3 != "-inf" {print $2, $3;}' | sort -n > jj1bdx-eclipse-202012-pps.txt
