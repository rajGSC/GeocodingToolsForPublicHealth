# gGeoCode.r
# Ezgraphs. GoogleGeocodeMap.R, 2010. https://github.com/ezgraphs/R-Programs/blob/master/GoogleGeocodeMap.R.
# also see suggested improvements at
# http://stackoverflow.com/questions/3257441/geocoding-in-r-with-google-maps

getDocNodeVal <- function(doc, path){
    sapply(getNodeSet(doc, path), function(el) xmlValue(el))
  }
 
gGeoCode <- function(str, first=T){
  if(!require(XML)) install.packages('XML'); require(XML)
  u=paste('http://maps.google.com/maps/api/geocode/xml?sensor=false&address=',str)
  doc = xmlTreeParse(u, useInternal=TRUE)
  str=gsub(' ','%20',str)
  lat=getDocNodeVal(doc, '/GeocodeResponse/result/geometry/location/lat')
  lng=getDocNodeVal(doc, '/GeocodeResponse/result/geometry/location/lng')
  if(length(lng) == 1 & first == F){
  #type=getDocNodeVal(doc, '/GeocodeResponse/result/geometry/location_type')
  #status <- getDocNodeVal(doc, '/GeocodeResponse/result/geometry/status')
  #out<-c(str, lat, lng,type,status)
  #out<-as.data.frame(t(out))
  #names(out) <- c('address','lat','long','type', 'status')
  #return(out)
  out<-c(str, lat, lng)
  } else if(length(lng) >= 1 & first == T) {
  out<-c(str, lat[1], lng[1])
  } else {
  out<-c(str, NA, NA)
  }
  out<-as.data.frame(t(out))
  names(out) <- c('address','lat','long')
  return(out)

 }
 # gGeoCode('Malakoff, France')
 # gGeoCode('Parliament House, Canberra')
 # gGeoCode('Parliament House, Australia')
 # gGeoCode('Parliament House, Australia', first = F)
 # TODO want to incorporate the status and location_type checks.
 # location_type stores additional data about the specified location. The following values are currently supported:
 # ROOFTOP indicates that the returned result is a precise geocode for which we have location information accurate down to street address precision.
 # RANGE_INTERPOLATED indicates that the returned result reflects an approximation (usually on a road) interpolated between two precise points (such as intersections). Interpolated results are generally returned when rooftop geocodes are unavailable for a street address.
 # GEOMETRIC_CENTER indicates that the returned result is the geometric center of a result such as a polyline (for example, a street) or polygon (region).
 # APPROXIMATE indicates that the returned result is approximate.
