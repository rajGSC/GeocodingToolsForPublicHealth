
get.geocode <- function (id='', street='', city='', state='', zip='', country = '', trustFirstResult = T){
# Glynn, Earl F. GoogleGeocode.R. Franklin Center for Government and Public Integrity, 2010. http://cdn.watchdogmedia.org/national/computer-assisted-reporting/project/geocoding-and-distances/missouri-sex-offenders/GoogleGeocode.R.
# Glynn, Earl F. Geocoding addresses from Missouri Sex Offender Registry: Computer Assisted Reporting, 2011. http://www.franklincenterhq.org/2541/geocoding-addresses-from-missouri-sex-offender-registry/.


# Function to call Google's Geocoding API for given street, city and state.
# Google Geocoding
# http://code.google.com/apis/maps/documentation/geocoding/index.html
# location_type stores additional data about the specified location. The following values are currently supported:
 # ROOFTOP indicates that the returned result is a precise geocode for which we have location information accurate down to street address precision.
 # RANGE_INTERPOLATED indicates that the returned result reflects an approximation (usually on a road) interpolated between two precise points (such as intersections). Interpolated results are generally returned when rooftop geocodes are unavailable for a street address.
 # GEOMETRIC_CENTER indicates that the returned result is the geometric center of a result such as a polyline (for example, a street) or polygon (region).
 # APPROXIMATE indicates that the returned result is approximate.
# 'id' could be used to add a 'key' to the data record being processed.

# city = placeNames[38,1];id=''; street=''; state=''; zip=''; country =  placeNames[38,2]
  if (!require(XML)) install.packages('XML', repos='http://cran.csiro.au'); require(XML)    # htmlTreeParse
  street <- gsub('#', 'Apt+', street)   # kludge fix for Apartment number symbol, 22 Jan 2010
  address <- paste(street, city, state, zip, country, sep=', ')
  URL <- paste('http://maps.googleapis.com/maps/api/geocode/xml?address=',
               gsub(' ', '+', address), '&sensor=false', sep='')
  xml <- htmlTreeParse(URL, useInternal=TRUE)

  # http://code.google.com/apis/maps/documentation/webservices/index.html#XMLParsing
  # http://code.google.com/apis/maps/documentation/geocoding/index.html#StatusCodes
  status <- unlist(xpathApply(xml, '//status', xmlValue))

  # if more than one, pick only the first in result[1]
  if (status == 'OK')
  {
    results <- getNodeSet(xml, '//result')
    result.count <- length(results)
    # TODO study why this is ever > 1
    
    if(trustFirstResult == F & result.count > 1){
     if(!file.exists('diagnostics')) {dir.create('diagnostics')}
     sink(file.path('diagnostics',paste(city,'Check.txt',sep='')))
     print(results)
     sink()
     }
    # for now just take the first
    formatted.address <- unlist(xpathApply(xml, '//result[1]/formatted_address', xmlValue))
    if (is.null(formatted.address)) formatted.address <- ''
    zip5              <- unlist(xpathApply(xml, "//result[1]/address_component[* = 'postal_code']/long_name", xmlValue))
    if (is.null(zip5)) zip5 <- ''
    country              <- unlist(xpathApply(xml, "//result[1]/address_component[* = 'country']/long_name", xmlValue))
    if (is.null(country)) country <- ''
    # use 'state.code' since 'state.name' is a defined R dataset
    state.code        <- unlist(xpathApply(xml, "//result[1]/address_component[* = 'administrative_area_level_1']/long_name", xmlValue))
    if (is.null(state.code)) state.code <- ''

    county            <- unlist(xpathApply(xml, "//result[1]/address_component[* = 'administrative_area_level_2']/long_name", xmlValue))
    if (is.null(county)) county <- ''

    lat <- unlist(xpathApply(xml, '//result[1]/geometry/location/lat', xmlValue))
    if (is.null(lat)) lat <- ''
    lng <- unlist(xpathApply(xml, '//result[1]/geometry/location/lng', xmlValue))
    if (is.null(lng)) lng <- ''

    location.type <- unlist(xpathApply(xml, '//result[1]/geometry/location_type', xmlValue))
    if (is.null(location.type)) location.type <- ''
  } else {
    formatted.address <- ''
    zip5 <- ''
    state.code <- ''
    county <- ''
    lat <- ''
    lng <- ''
    location.type <- ''
    result.count <- 0
  }

  free(xml)

  data.frame(id, status, street, city, state, state.code, zip5, county,
             lat, lng, location.type,
             formatted.address, result.count, stringsAsFactors=FALSE)
 }
# test
# debug(get.geocode)        
# get.geocode(city='New York',country = 'USA', trustFirstResult = F)       
# get.geocode(city='Philidelphia',country = 'USA', trustFirstResult = F)
# get.geocode(city='Kingston',country = 'Australia', trustFirstResult = F)
# get.geocode(city='Kingston',country = 'Australia', state = 'ACT', trustFirstResult = F)
# undebug(get.geocode)
