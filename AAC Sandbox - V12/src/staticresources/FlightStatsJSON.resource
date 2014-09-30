{"request":
{
"airline":
{
"requestedCode":"AA","fsCode":"AA"},"flight":{"requested":"100","interpreted":"100"},"date":{"year":"2013","month":"5","day":"8","interpreted":"2013-05-08"}
,"utc":{"interpreted":false},"airport":{},"codeType":{},"extendedOptions":{},"url":"https://api.flightstats.com/flex/flightstatus/rest/v2/json/flight/status/AA/100/dep/2013/5/8"},
"appendix":{
"airlines":
[
{"fs":"GF","iata":"GF","icao":"GFA","name":"Gulf Air","active":true},
{"fs":"LY","iata":"LY","icao":"ELY","name":"El Al","active":true},
{"fs":"BA","iata":"BA","icao":"BAW","name":"British Airways","phoneNumber":"1-800-AIRWAYS","active":true},
{"fs":"AA","iata":"AA","icao":"AAL","name":"American Airlines","phoneNumber":"1-800-433-7300","active":true},
{"fs":"IB","iata":"IB","icao":"IBE","name":"Iberia","active":true}
],
"airports":
[
{"fs":"JFK","iata":"JFK","icao":"KJFK","faa":"JFK","name":"John F. Kennedy International Airport","street1":"JFK Airport","city":"New York","cityCode":"NYC","stateCode":"NY","postalCode":"11430","countryCode":"US","countryName":"United States","regionName":"North America","timeZoneRegionName":"America/New_York","weatherZone":"NYZ178","localTime":"2013-05-09T03:25:35.346","utcOffsetHours":-4.0,"latitude":40.642335,"longitude":-73.78817,"elevationFeet":13,"classification":1,"active":true,"delayIndexUrl":"https://api.flightstats.com/flex/delayindex/rest/v1/json/airports/JFK?codeType=fs","weatherUrl":"https://api.flightstats.com/flex/weather/rest/v1/json/all/JFK?codeType=fs"},
{"fs":"LHR","iata":"LHR","icao":"EGLL","name":"London Heathrow Airport","city":"London","cityCode":"LON","stateCode":"EN","countryCode":"GB","countryName":"United Kingdom","regionName":"Europe","timeZoneRegionName":"Europe/London","localTime":"2013-05-09T08:25:35.346","utcOffsetHours":1.0,"latitude":51.469603,"longitude":-0.453566,"elevationFeet":80,"classification":1,"active":true,"delayIndexUrl":"https://api.flightstats.com/flex/delayindex/rest/v1/json/airports/LHR?codeType=fs","weatherUrl":"https://api.flightstats.com/flex/weather/rest/v1/json/all/LHR?codeType=fs"}
],
"equipments":
[
{"iata":"77W","name":"Boeing 777-300ER Passenger","turboProp":false,"jet":true,"widebody":true,"regional":false},
{"iata":"B77W","name":"??","turboProp":false,"jet":false,"widebody":false,"regional":false}
]
},
"flightStatuses":
[
{
"flightId":296299371,
"carrierFsCode":"AA",
"flightNumber":"100",
"departureAirportFsCode":"JFK",
"arrivalAirportFsCode":"LHR",
"departureDate":{"dateLocal":"2013-05-08T18:05:00.000","dateUtc":"2013-05-08T22:05:00.000Z"},
"arrivalDate":{"dateLocal":"2013-05-09T06:20:00.000","dateUtc":"2013-05-09T05:20:00.000Z"},
"status":"L",
"schedule":{"flightType":"J","serviceClasses":"RFJY","restrictions":""},
"operationalTimes":{"publishedDeparture":{"dateLocal":"2013-05-08T18:05:00.000","dateUtc":"2013-05-08T22:05:00.000Z"},
"publishedArrival":{"dateLocal":"2013-05-09T06:20:00.000","dateUtc":"2013-05-09T05:20:00.000Z"},
"scheduledGateDeparture":{"dateLocal":"2013-05-08T18:05:00.000","dateUtc":"2013-05-08T22:05:00.000Z"},
"actualGateDeparture":{"dateLocal":"2013-05-08T18:17:00.000","dateUtc":"2013-05-08T22:17:00.000Z"},
"flightPlanPlannedDeparture":{"dateLocal":"2013-05-08T18:42:00.000","dateUtc":"2013-05-08T22:42:00.000Z"},
"estimatedRunwayDeparture":{"dateLocal":"2013-05-08T18:54:00.000","dateUtc":"2013-05-08T22:54:00.000Z"},
"actualRunwayDeparture":{"dateLocal":"2013-05-08T18:47:00.000","dateUtc":"2013-05-08T22:47:00.000Z"},
"scheduledGateArrival":{"dateLocal":"2013-05-09T06:20:00.000","dateUtc":"2013-05-09T05:20:00.000Z"},
"estimatedGateArrival":{"dateLocal":"2013-05-09T06:30:00.000","dateUtc":"2013-05-09T05:30:00.000Z"},
"actualGateArrival":{"dateLocal":"2013-05-09T06:17:00.000","dateUtc":"2013-05-09T05:17:00.000Z"},
"flightPlanPlannedArrival":{"dateLocal":"2013-05-09T06:26:00.000","dateUtc":"2013-05-09T05:26:00.000Z"},
"estimatedRunwayArrival":{"dateLocal":"2013-05-09T06:23:00.000","dateUtc":"2013-05-09T05:23:00.000Z"},
"actualRunwayArrival":{"dateLocal":"2013-05-09T06:11:00.000","dateUtc":"2013-05-09T05:11:00.000Z"}},
"codeshares":
[
{"fsCode":"LY","flightNumber":"8051","relationship":"L"},
{"fsCode":"BA","flightNumber":"1511","relationship":"L"},
{"fsCode":"GF","flightNumber":"6654","relationship":"L"},
{"fsCode":"IB","flightNumber":"4218","relationship":"L"}
],
"delays":{"departureGateDelayMinutes":12,"departureRunwayDelayMinutes":5},
"flightDurations":{"scheduledBlockMinutes":435,"blockMinutes":420,"scheduledAirMinutes":404,"airMinutes":384,"scheduledTaxiOutMinutes":37,"taxiOutMinutes":30,"taxiInMinutes":6},
"airportResources":{"departureTerminal":"8","departureGate":"B2","arrivalTerminal":"3","arrivalGate":"27"},
"flightEquipment":{"scheduledEquipmentIataCode":"77W","actualEquipmentIataCode":"B77W","tailNumber":"N721AN"}
}
]
}