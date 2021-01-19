datestring="20201212"
#
basetime=as.numeric(as_datetime(datestring))
#
freqoffset=998.8689
#
plot((0:86399)/3600, smoothlevelfun(basetime+0:86399), type="l", col="blue",
     xlim=c(0, 24), ylim=c(-180,-20), xaxt="n", yaxt="n", xlab = "", ylab = "")
axis(side=2, at=c(-90,-80, -70,-60,-50,-40,-30,-20), col="blue",
     tck=1.0, lty="dotted", las=TRUE)
par(new=t)
plot((0:86399)/3600, smoothfreqfun(basetime+0:86399) - freqoffset, type="l", 
     col="black",
     xlim=c(0, 24), ylim=c(-2,8), xaxt="n", yaxt="n",xlab = "", ylab = "")
mtext(side=1, text = paste(datestring, "UTC hours"), line = 2, col="black")
axis(side=1, xaxp=c(0, 24, 24), las=TRUE, tck=1.0, lty="dotted")
axis(side=2, at=c(-2.0, -1.5, -1.0, -0.5, 0, 0.5, 1.0, 1.5, 2.0), col="black", 
     tck=1.0, lty="dotted", las=TRUE)
mtext(side=2, text = "signal strength[dB]", line = 0, col="blue", adj=0.85)
mtext(side=2, text = "offset[Hz]", line = 0, col="black", adj=0.2)
#legend("bottomleft", lty=1,
#               legend = c("frequency offset [Hz]", "signal strength [dB]"),
#               col    = c("black", "blue"))
