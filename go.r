
setwd("~/PHSurveillanceShortcourse")
oldwd<- getwd()
download.file(url='http://cdn.watchdogmedia.org/national/computer-assisted-reporting/project/geocoding-and-distances/missouri-sex-offenders/Missouri-Sex-Offenders.R',destfile
= 'analysis/src/Missouri-Sex-Offenders.r',mode = 'wb')
# to run specific source files
# list all files with
 dir('analysis/src',pattern='.r',full.names=T)
# we could just source() this file and run all its contents however on inspection realise that the downloaded R file has a couple of edits to make by hand first, to reflect our working directory.
source('analysis/src/Missouri-Sex-Offenders.r')

download.file(url='http://cdn.watchdogmedia.org/national/computer-assisted-reporting/project/geocoding-and-distances/missouri-sex-offenders/GoogleGeocode.R',destfile = 'analysis/src/GoogleGeocode.r',mode = 'wb')
dir('analysis/src',pattern='.r',full.names=T)
# we could just source() this file and run all its contents however on inspection realise that the downloaded R file has a couple of edits to make by hand first, to reflect our working directory.
source('analysis/src/GoogleGeocode.r')

download.file(url='http://cdn.watchdogmedia.org/national/computer-assisted-reporting/project/geocoding-and-distances/missouri-sex-offenders/GoogleGeocodeMOSexOffenders.R',destfile = 'analysis/src/GoogleGeocodeMOSexOffenders.r',mode = 'wb')
 
# we could just source() this file, but make edits by hand first
# source('analysis/src/GoogleGeocodeMOSexOffenders.r')

# first line up the data
#rm(d)
if(!exists('d')) d <- read.table(file.path('analysis/data',"geocode-MO-offender-out.txt"), header=T)
head(d)
select <- (d$status == "OK") & (d$result.count > 0) & (d$state == 'Missouri')
d <- d[select,]
d$fuzzy <- (d$result.count > 1) | (d$location.type != "ROOFTOP")
head(d)
offender.data <- d

# now make a map
library(maps)
png('offenders.png', res = 100)
map("county", "Missouri", col="grey")
mtext(paste("Missouri Sexual Offenders",Sys.Date()), adj=0, col="red")
points(offender.data$lng, offender.data$lat,
col=ifelse(offender.data$fuzzy, "palevioletred", "red"))
dev.off()

nrow(offender.data)
names(offender.data)
offender.data[1,]
which(offender.data$Name == 'ALLISON, JANET')

offender <- read.csv(file.path('analysis/data','msor-offender-master-file.csv'))
offender[grep('ALLISON', offender$Name),c('Name','Address','Comments')]

print(offender[grep('AARON, JEFFERY W', offender$Name),c('Name','Address','Comments')])

offender.data[which(offender.data$Name == 'AARON, JEFFERY W'),]
offender[grep('AARON, JEFFERY W', offender$Name),c('Name','Address','Comments')]
png('offenderIdentified.png', res = 100)
map("county", "Missouri", col="grey")
mtext(paste("Missouri Sexual Offenders",Sys.Date()), adj=0, col="red")
points(offender.data$lng, offender.data$lat,
col=ifelse(offender.data$fuzzy, "palevioletred", "red"))
identified <- offender.data[which(offender.data$Name == 'AARON, JEFFERY W'),]
points(identified$lng, identified$lat,col='blue', pch = 16)

dev.off()

# tools
if(!require(rgdal)) install.packages('rgdal'); require(rgdal)
epsg<-make_EPSG()

# project as GDA94
epsg[grep('GDA94',epsg$note),] 
# find correct code is 4283
d1 <- SpatialPointsDataFrame(coords = offender.data[,c('lng', 'lat')],
        data = offender.data,
        proj4string=CRS(epsg$prj4[epsg$code %in% '4283']))

summary(d1)

# reproject as WGS84, this is a trivial example. the difference will be miniscule.
epsg[grep('WGS 84',epsg$note),]
# yuck so many options,  figured out using google
epsg[grep(4326,epsg$code),] 
d2 <- spTransform(d1, CRS(epsg$prj4[grep(4326,epsg$code)]))
summary(d2)

# write out as projected shapefile
writeOGR(d2,"test","test","ESRI Shapefile")
