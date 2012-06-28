Geocoding Tools for Public Health.
-------

This was developed as a presentation to the NCEPH Public Health Surveillance short course in March 2012.

It is currently just a reproducible research report, faithfully following the online tutorial [1,2] using google maps [3].

I've made subsequent improvements to this code, but it is still in development.  The issue is the handling of multiple hits and dealing with false positives.  THis is hard coded to take the first match that google returns.  I've fixed it to give you a clerical review step for all multiple hit addresses.  In the near future I'll share that too and it will become a citable code project in it's own right [4].

Ivan Hanigan
2012-06-29

References
----
[1] Earl F Glynn. Geocoding addresses from MissouriSex Offender Registry: Computer Assisted Reporting.
http://www.franklincenterhq.org/2541/geocoding-addresses-from-missouri-sex-offender-registry/. Technical report, Franklin Center for Government and Public Integrity, Bismarck, ND, 2011.

[2] Earl F Glynn. GoogleGeocode.R, http://cdn.watchdogmedia.org/national/computer-assisted-reporting/project/geocoding-and-distances/missouri-sex-offenders/GoogleGeocode.R, 2010.

[3] Google. Google Geocoding API, http://code.google.com/apis/maps/documentation/geocoding/index.html.

[4] Hanigan, IC. 2012. Geocoding Tools For Public Health [Computer Software]. 
https://github.com/ivanhanigan/GeocodingToolsForPublicHealth
