# Use TTR in CRAN
library(TTR)
library(tidyverse)
library(lubridate)
# Read base data
freqdata=read.table("jj1bdx-eclipse-202012-freq.txt", header=TRUE)
ppsdata=read.table("jj1bdx-eclipse-202012-pps.txt", header=TRUE)
# Make interpolation functions for the base data
freqfun = stats::approxfun(freqdata$Time, freqdata$Freq)
levelfun = stats::approxfun(ppsdata$Time, ppsdata$Level)
# UNIX Time:
# 8-DEC-2020 2358UTC -> TZ=UTC date -j 1208235820 "+%s" -> 1607471880
# 9-DEC-2020 0000UTC -> TZ=UTC date -j 1209000020 "+%s" -> 1607472000
# 17-DEC-2020 0000UTC -> TZ=UTC date -j 1217000000 "+%s" -> 1608163200
# Smoothing for a minute (60 seconds)
smoothtime=c(1607471880:1608163200)
smoothfreq=SMA(freqfun(smoothtime),60)
smoothlevel=SMA(levelfun(smoothtime),60)
# Make interpolation functions for the smoothed data
smoothfuntime=c(1607472000:1608163200)
smoothfreqfun=stats::approxfun(smoothtime,smoothfreq)
smoothlevelfun=stats::approxfun(smoothtime,smoothlevel)
