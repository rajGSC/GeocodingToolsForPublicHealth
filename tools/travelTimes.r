
# travelTimes.r
# inspired by
# http://ekonometrics.blogspot.com.au/2011/04/google-maps-and-travel-times.html
# TODO
#fix Warning message:            
#In readLines(json_file) :
#  incomplete final line found on #'http://maps.google.com/maps/nav?output=js&q=from:%20
travelTimes <- function(origin, destination, walking = FALSE){
if (!require(rjson)) install.packages('rjson'); require(rjson)

if(walking == TRUE){
        # walking
        json_file<- paste("http://maps.google.com/maps/nav?output=js&q=from:%20",origin,"%20to:",destination,"&dirflg=w",sep="")
        json_data <- fromJSON(paste(readLines(json_file), collapse=""))
        out<- c(origin,destination,json_data$Directions$Duration$html,json_data$Directions$Routes[[1]]$Distance$meters, 'TRUE')
} else {
        #driving
        json_file<- paste("http://maps.google.com/maps/nav?output=js&q=from:%20",origin,"%20to:",destination,sep="")
        json_data <- fromJSON(paste(readLines(json_file), collapse=""))
        out<- c(origin,destination,json_data$Directions$Duration$html,json_data$Directions$Routes[[1]]$Distance$meters,'FALSE')
}

out<-as.data.frame(t(out))
names(out) <- c('origin','destination','duration','distance', 'walking')
return(out)
}

# times <- travelTimes(origin='Scullin,ACT', destination='Hawker,ACT')
