
require("UpSetR")
args <- commandArgs(trailingOnly = TRUE)
outFile <- args[3]
df <- read.csv(args[1], header=TRUE, sep=",")

bin1 <- df[df$BINSIZE %in% c("BIN1: <50bp"),]
bin2 <- df[df$BINSIZE %in% c("BIN2: 50-100bp"),]
bin3 <- df[df$BINSIZE %in% c("BIN3: 100-1000bp"),]
bin4 <- df[df$BINSIZE %in% c("BIN4: 1000-10000bp"),]
bin5 <- df[df$BINSIZE %in% c("BIN5: >10000bp"),]

pdf(outFile, paper = "a4")

upset(
    df, order.by = "freq",
    sets.bar.color="#56B4E9",
    empty.intersections = "on",
    text.scale = c(2, 1.3, 1, 1, 1.5, 2),
    point.size = 4,
    mainbar.y.label="All Size: Number of overlaps"
)

upset(
    bin1, order.by = "freq",
    sets.bar.color="#56B4E9",
    empty.intersections = "on",
    text.scale = c(2, 1.3, 1, 1, 1.5, 2),
    point.size = 4,
    mainbar.y.label="BIN1: <50bp: Number of overlaps"
)

upset(
    bin2, order.by = "freq",
    sets.bar.color="#56B4E9",
    empty.intersections = "on",
    text.scale = c(2, 1.3, 1, 1, 1.5, 2),
    point.size = 4,
    mainbar.y.label="BIN2: 50-100bp: Number of overlaps"
)

upset(
    bin3, order.by = "freq",
    sets.bar.color="#56B4E9",
    empty.intersections = "on",
    text.scale = c(2, 1.3, 1, 1, 1.5, 2),
    point.size = 4,
    mainbar.y.label="BIN3: 100-1000bp: Number of overlaps"
)

upset(
    bin4, order.by = "freq",
    sets.bar.color="#56B4E9",
    empty.intersections = "on",
    text.scale = c(2, 1.3, 1, 1, 1.5, 2),
    point.size = 4,
    mainbar.y.label="BIN4: 1000-10000bp: Number of overlaps"
)

upset(
    bin5, order.by = "freq",
    sets.bar.color="#56B4E9",
    empty.intersections = "on",
    text.scale = c(2, 1.3, 1, 1, 1.5, 2),
    point.size = 4,
    mainbar.y.label="BIN5: >10000bp: Number of overlaps"
)

#c(intersection size title, intersection size tick labels, set size title, set size tick labels, set names, numbers above bars)

dev.off()