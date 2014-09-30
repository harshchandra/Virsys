public class FlightStatusController {
    
    public string WebRequest {get;set;}
    public string WebResponse {get;set;}
    public string FormatResponse{get;set;}
    public string carrierCode {get;set;}
    public string flightNumber {get;set;}
    public String year {get;set;}
    public string month {get;set;}
    public string day {get;set;}
    public Flight flight {get;set;}
    public string selectedCarrier {get;set;}
    public RootObject rootObjectx {get;set;}
    public FlightStatus flightStatusx {get;set;}    
    public OperationalTimes operationalTimesx {get;set;}
    public Airport2 airport2x {get;set;}
    
	public AirportResources airportResourcesx {get;set;}
	public FlightEquipment flightEquipmentx {get;set;}
	public Equipment equipmentx {get;set;}
	public Airline airlinex {get;set;}
	public Flight flightx {get;set;}
	public FlightDate flightdatex {get;set;}
	public Utc utcx {get;set;}
	public Airport airportx {get;set;}
	public Request requestx {get;set;}
	public Airline2 airline2x {get;set;}
	public DepartureDate departuredatex {get;set;}
	public ArrivalDate arrivaldatex {get;set;}
	public Schedule schedulex {get;set;}
	public PublishedDeparture publisheddeparturex {get;set;}
	public PublishedArrival publishedarrivalx {get;set;}
    
    
    public List<SelectOption> getCarrierList()
    {
        List<SelectOption> carriers = new List<SelectOption>();
        carriers.add(new SelectOption('M3','ABSA'));
        carriers.add(new SelectOption('GB','ABX Air'));
        carriers.add(new SelectOption('6U','ACG Air Cargo Germany'));
        carriers.add(new SelectOption('VUE','AD Aviation'));
        carriers.add(new SelectOption('AEP','AEROTEC'));
        carriers.add(new SelectOption('QD','AEROVIP'));
        carriers.add(new SelectOption('LD','AHK'));
        carriers.add(new SelectOption('TLE','AIR TOULOUSE'));
        carriers.add(new SelectOption('TL*','AIRNORTH'));
        carriers.add(new SelectOption('C4','ALMA de Mexico'));
        carriers.add(new SelectOption('ALS','ALS'));
        carriers.add(new SelectOption('AMV','AMC Airlines'));
        carriers.add(new SelectOption('9N','ANA & JP Express'));
        carriers.add(new SelectOption('NH','ANA - All Nippon Airways'));
        carriers.add(new SelectOption('1N','ANA Cargo'));
        carriers.add(new SelectOption('EH','ANA Wings'));
        carriers.add(new SelectOption('XA','ARINC'));
        carriers.add(new SelectOption('U3','AS Avies'));
        carriers.add(new SelectOption('KP','ASKY Airlines'));
        carriers.add(new SelectOption('ML','ATTICO'));
        carriers.add(new SelectOption('6A','AVIACSA'));
        carriers.add(new SelectOption('GU','AVIATECA'));
        carriers.add(new SelectOption('9V','AVIOR'));
        carriers.add(new SelectOption('J2','AZAL'));
        carriers.add(new SelectOption('K5*','Aban Air'));
        carriers.add(new SelectOption('AAB','Abelag Aviation'));
        carriers.add(new SelectOption('BOI','Aboitiz Air'));
        carriers.add(new SelectOption('9B','AccesRail'));
        carriers.add(new SelectOption('KI','Adam Skyconnection'));
        carriers.add(new SelectOption('JP','Adria Airways'));
        carriers.add(new SelectOption('DF','AeBal'));
        carriers.add(new SelectOption('A3','Aegean Airlines'));
        carriers.add(new SelectOption('AAZ','Aeolus Air'));
        carriers.add(new SelectOption('RE','Aer Arann'));
        carriers.add(new SelectOption('EI','Aer Lingus'));
        carriers.add(new SelectOption('TUY','Aereotuy'));
        carriers.add(new SelectOption('EE','Aero Airlines'));
        carriers.add(new SelectOption('RSO','Aero Asia International'));
        carriers.add(new SelectOption('EM*','Aero Benin'));
        carriers.add(new SelectOption('CTA','Aero Charter and Transport'));
        carriers.add(new SelectOption('ADN','Aero Dienst'));
        carriers.add(new SelectOption('YP','Aero Lloyd'));
        carriers.add(new SelectOption('MNG','Aero Mongolia'));
        carriers.add(new SelectOption('OVA','Aero Nova'));
        carriers.add(new SelectOption('BES','Aero Services'));
        carriers.add(new SelectOption('RVP','Aero Vip'));
        carriers.add(new SelectOption('DW','Aero-Charter'));
        carriers.add(new SelectOption('BF*','Aero-Service'));
        carriers.add(new SelectOption('BRP','AeroBratsk'));
        carriers.add(new SelectOption('AJ','AeroContractors'));
        carriers.add(new SelectOption('2K','AeroGal'));
        carriers.add(new SelectOption('BOX','AeroLogic'));
        carriers.add(new SelectOption('5D','AeroMexico Connect'));
        carriers.add(new SelectOption('5L','AeroSur'));
        carriers.add(new SelectOption('7L','Aerocaribbean'));
        carriers.add(new SelectOption('A4','Aerocon'));
        carriers.add(new SelectOption('AZM','Aerocozumel'));
        carriers.add(new SelectOption('SU','Aeroflot'));
        carriers.add(new SelectOption('D9','Aeroflot - Don'));
        carriers.add(new SelectOption('KG','Aerogaviota'));
        carriers.add(new SelectOption('5P','Aerolinea Principal'));
        carriers.add(new SelectOption('AR','Aerolineas Argentinas'));
        carriers.add(new SelectOption('N2','Aerolineas Internacionales'));
        carriers.add(new SelectOption('N3','Aerolineas MAS'));
        carriers.add(new SelectOption('F2','Aerolineas Regionales'));
        carriers.add(new SelectOption('P4','Aerolineas Sosa'));
        carriers.add(new SelectOption('VW','Aeromar'));
        carriers.add(new SelectOption('BQ','Aeromar Airlines'));
        carriers.add(new SelectOption('AM','Aeromexico'));
        carriers.add(new SelectOption('QO','Aeromexpress'));
        carriers.add(new SelectOption('HT','Aeromist'));
        carriers.add(new SelectOption('VTM','Aeronaves TSM'));
        carriers.add(new SelectOption('OT','Aeropelican Air Services'));
        carriers.add(new SelectOption('WL','Aeroperlas'));
        carriers.add(new SelectOption('VH','Aeropostal'));
        carriers.add(new SelectOption('AOS','Aeros Del Sol'));
        carriers.add(new SelectOption('VV','Aerosvit Airlines'));
        carriers.add(new SelectOption('MY','Aerotransportes Mas de Carga'));
        carriers.add(new SelectOption('LET','Aerouneas Ejecutivas'));
        carriers.add(new SelectOption('6R','Aerounion'));
        carriers.add(new SelectOption('FK','Africa West'));
        carriers.add(new SelectOption('AFW','Africa World Airlines'));
        carriers.add(new SelectOption('AIK','African Airlines'));
        carriers.add(new SelectOption('XU','African Express Airways'));
        carriers.add(new SelectOption('AIN','African International Airways'));
        carriers.add(new SelectOption('QSC','African Safari Airways'));
        carriers.add(new SelectOption('8U','Afriqiyah Airways'));
        carriers.add(new SelectOption('X5','Afrique Airlines'));
        carriers.add(new SelectOption('ZI','Aigle Azur'));
        carriers.add(new SelectOption('BDI','Air & Training center-West'));
        carriers.add(new SelectOption('AH','Air Algerie'));
        carriers.add(new SelectOption('ZX','Air Alliance'));
        carriers.add(new SelectOption('A6','Air Alps Aviation'));
        carriers.add(new SelectOption('3S','Air Antilles'));
        carriers.add(new SelectOption('G9','Air Arabia'));
        carriers.add(new SelectOption('RBG','Air Arabia Egypt'));
        carriers.add(new SelectOption('3O','Air Arabia Maroc'));
        carriers.add(new SelectOption('QN*','Air Armenia'));
        carriers.add(new SelectOption('KC','Air Astana'));
        carriers.add(new SelectOption('EUK','Air Atlanta Europe'));
        carriers.add(new SelectOption('CC','Air Atlanta Icelandic'));
        carriers.add(new SelectOption('AAG','Air Atlantique'));
        carriers.add(new SelectOption('AAI','Air Aurora'));
        carriers.add(new SelectOption('UU','Air Austral'));
        carriers.add(new SelectOption('VC','Air Australia'));
        carriers.add(new SelectOption('W9*','Air Bagan'));
        carriers.add(new SelectOption('BT','Air Baltic'));
        carriers.add(new SelectOption('BP','Air Botswana'));
        carriers.add(new SelectOption('2J','Air Burkina'));
        carriers.add(new SelectOption('8Y','Air Burundi'));
        carriers.add(new SelectOption('BX','Air Busan'));
        carriers.add(new SelectOption('MSC','Air Cairo'));
        carriers.add(new SelectOption('TY','Air Caledonie'));
        carriers.add(new SelectOption('SB','Air Caledonie International'));
        carriers.add(new SelectOption('AC','Air Canada'));
        carriers.add(new SelectOption('TX','Air Caraibes'));
        carriers.add(new SelectOption('SNC','Air Cargo Carriers'));
        carriers.add(new SelectOption('NV','Air Central'));
        carriers.add(new SelectOption('ACS','Air Cess'));
        carriers.add(new SelectOption('RL','Air Charter'));
        carriers.add(new SelectOption('CV*','Air Chathams'));
        carriers.add(new SelectOption('CAO','Air China Cargo'));
        carriers.add(new SelectOption('CA','Air China Limited'));
        carriers.add(new SelectOption('3E','Air Choice One'));
        carriers.add(new SelectOption('A7','Air Comet'));
        carriers.add(new SelectOption('GG','Air Comores'));
        carriers.add(new SelectOption('AG','Air Contractors'));
        carriers.add(new SelectOption('XK','Air Corsica'));
        carriers.add(new SelectOption('VRE','Air Cote D\'Ivoire'));
        carriers.add(new SelectOption('YN','Air Creebec'));
        carriers.add(new SelectOption('HD','Air Do'));
        carriers.add(new SelectOption('EN','Air Dolomiti'));
        carriers.add(new SelectOption('ED','Air Dominicana'));
        carriers.add(new SelectOption('UX','Air Europa Lineas Aereas'));
        carriers.add(new SelectOption('X4','Air Excursions'));
        carriers.add(new SelectOption('OF','Air Finland'));
        carriers.add(new SelectOption('WAF','Air Flamenco'));
        carriers.add(new SelectOption('AF','Air France'));
        carriers.add(new SelectOption('5I','Air G'));
        carriers.add(new SelectOption('7T*','Air Glaciers'));
        carriers.add(new SelectOption('GL','Air Greenland'));
        carriers.add(new SelectOption('CGH','Air Guizhou'));
        carriers.add(new SelectOption('RN','Air Horizons'));
        carriers.add(new SelectOption('NY','Air Iceland'));
        carriers.add(new SelectOption('AI','Air India'));
        carriers.add(new SelectOption('IX','Air India Express'));
        carriers.add(new SelectOption('CD','Air India Regional'));
        carriers.add(new SelectOption('MPK','Air Indus'));
        carriers.add(new SelectOption('3H','Air Inuit'));
        carriers.add(new SelectOption('AEY','Air Italy'));
        carriers.add(new SelectOption('VU','Air Ivoire'));
        carriers.add(new SelectOption('JM','Air Jamaica'));
        carriers.add(new SelectOption('NQ','Air Japan Company'));
        carriers.add(new SelectOption('KBZ','Air KBZ'));
        carriers.add(new SelectOption('P2','Air Kenya Express'));
        carriers.add(new SelectOption('4A*','Air Kiribati'));
        carriers.add(new SelectOption('JS','Air Koryo'));
        carriers.add(new SelectOption('WJ','Air Labrador'));
        carriers.add(new SelectOption('LIZ','Air Liaison'));
        carriers.add(new SelectOption('DR','Air Link'));
        carriers.add(new SelectOption('FU','Air Littoral'));
        carriers.add(new SelectOption('NX','Air Macau'));
        carriers.add(new SelectOption('MD','Air Madagascar'));
        carriers.add(new SelectOption('QM','Air Malawi'));
        carriers.add(new SelectOption('KM','Air Malta'));
        carriers.add(new SelectOption('MBB','Air Manas'));
        carriers.add(new SelectOption('6T','Air Mandalay'));
        carriers.add(new SelectOption('CW','Air Marshall Islands'));
        carriers.add(new SelectOption('MR','Air Mauritanie'));
        carriers.add(new SelectOption('MK','Air Mauritius'));
        carriers.add(new SelectOption('BIE','Air Mediterranee'));
        carriers.add(new SelectOption('MHS','Air Memphis'));
        carriers.add(new SelectOption('ZV','Air Midwest'));
        carriers.add(new SelectOption('6M','Air Minas'));
        carriers.add(new SelectOption('MC','Air Mobility Command'));
        carriers.add(new SelectOption('9U','Air Moldova'));
        carriers.add(new SelectOption('TAH','Air Moorea'));
        carriers.add(new SelectOption('SW','Air Namibia'));
        carriers.add(new SelectOption('NTL','Air National'));
        carriers.add(new SelectOption('RLK','Air Nelson'));
        carriers.add(new SelectOption('NZ','Air New Zealand'));
        carriers.add(new SelectOption('7A','Air Next'));
        carriers.add(new SelectOption('EL','Air Nippon'));
        carriers.add(new SelectOption('PX','Air Niugini'));
        carriers.add(new SelectOption('MPE','Air Norterra'));
        carriers.add(new SelectOption('4N','Air North'));
        carriers.add(new SelectOption('M3*','Air Norway'));
        carriers.add(new SelectOption('YW','Air Nostrum'));
        carriers.add(new SelectOption('AP','Air One'));
        carriers.add(new SelectOption('OG','Air Onix'));
        carriers.add(new SelectOption('FJ','Air Pacific'));
        carriers.add(new SelectOption('PST','Air Panama'));
        carriers.add(new SelectOption('2P','Air Philippines'));
        carriers.add(new SelectOption('GZ','Air Rarotonga'));
        carriers.add(new SelectOption('PJ','Air Saint-Pierre'));
        carriers.add(new SelectOption('EX','Air Santo Domingo'));
        carriers.add(new SelectOption('6O','Air Satellite'));
        carriers.add(new SelectOption('SCY','Air Scandic'));
        carriers.add(new SelectOption('GRE','Air Scotland'));
        carriers.add(new SelectOption('X7*','Air Service'));
        carriers.add(new SelectOption('HM','Air Seychelles'));
        carriers.add(new SelectOption('4D','Air Sinai'));
        carriers.add(new SelectOption('GM','Air Slovakia'));
        carriers.add(new SelectOption('SZ','Air Southwest'));
        carriers.add(new SelectOption('ZP','Air St. Thomas'));
        carriers.add(new SelectOption('YI','Air Sunshine'));
        carriers.add(new SelectOption('VT','Air Tahiti'));
        carriers.add(new SelectOption('TN','Air Tahiti Nui'));
        carriers.add(new SelectOption('TC','Air Tanzania'));
        carriers.add(new SelectOption('HAT','Air Taxi'));
        carriers.add(new SelectOption('8T','Air Tindi'));
        carriers.add(new SelectOption('TS','Air Transat'));
        carriers.add(new SelectOption('JY','Air Turks And Caicos'));
        carriers.add(new SelectOption('RTQ','Air Turquoise'));
        carriers.add(new SelectOption('U7','Air Uganda'));
        carriers.add(new SelectOption('3N','Air Urga'));
        carriers.add(new SelectOption('DO','Air Vallee'));
        carriers.add(new SelectOption('NF','Air Vanuatu'));
        carriers.add(new SelectOption('VIM','Air Via'));
        carriers.add(new SelectOption('ZW','Air Wisconsin Airlines'));
        carriers.add(new SelectOption('ZT','Air Zambezi'));
        carriers.add(new SelectOption('UM','Air Zimbabwe'));
        carriers.add(new SelectOption('TWG','Air-Taxi Europe'));
        carriers.add(new SelectOption('AK','AirAsia'));
        carriers.add(new SelectOption('JW','AirAsia Japan'));
        carriers.add(new SelectOption('D7','AirAsia X'));
        carriers.add(new SelectOption('RU','AirBridge Cargo'));
        carriers.add(new SelectOption('VSG','AirClass Airways'));
        carriers.add(new SelectOption('DV','AirCompany SCAT'));
        carriers.add(new SelectOption('GL*','AirGlow Aviation Services'));
        carriers.add(new SelectOption('USC','AirNet Systems, Inc.'));
        carriers.add(new SelectOption('AQU','AirQuarius Aviation'));
        carriers.add(new SelectOption('TOW','AirTanker Services Limited'));
        carriers.add(new SelectOption('FL','AirTran'));
        carriers.add(new SelectOption('ABQ','Airblue'));
        carriers.add(new SelectOption('AIB','Airbus Industrie'));
        carriers.add(new SelectOption('BGA','Airbus Transport International'));
        carriers.add(new SelectOption('JAC','Aircompany Continent'));
        carriers.add(new SelectOption('KHO','Aircompany KHORS'));
        carriers.add(new SelectOption('0K','Aircompany Kokshetau'));
        carriers.add(new SelectOption('YQ','Aircompany Polet'));
        carriers.add(new SelectOption('Y8*','Aircompany Yakutia'));
        carriers.add(new SelectOption('LFM','Airlift Service'));
        carriers.add(new SelectOption('A5','Airlinair'));
        carriers.add(new SelectOption('XXX','Airline'));
        carriers.add(new SelectOption('RIN','Airline Transport Incorporation'));
        carriers.add(new SelectOption('CG','Airlines of Papua New Guinea'));
        carriers.add(new SelectOption('RT','Airlines of South Australia'));
        carriers.add(new SelectOption('ATM','Airlines of Tasmania'));
        carriers.add(new SelectOption('I4A','Airlink'));
        carriers.add(new SelectOption('FA','Airlink Airways'));
        carriers.add(new SelectOption('APC','Airpac Airlines'));
        carriers.add(new SelectOption('PL','Airstars Airways'));
        carriers.add(new SelectOption('AWV','Airwave Transport'));
        carriers.add(new SelectOption('AWK','Airwork (NZ)'));
        carriers.add(new SelectOption('BGM','Ak Bars Aero'));
        carriers.add(new SelectOption('6L','Aklak'));
        carriers.add(new SelectOption('2T','Alajnihah Air Transport'));
        carriers.add(new SelectOption('AS','Alaska Airlines'));
        carriers.add(new SelectOption('KO','Alaska Central Express'));
        carriers.add(new SelectOption('J5','Alaska Seaplane'));
        carriers.add(new SelectOption('LAV','Alba Star'));
        carriers.add(new SelectOption('LV','Albanian Airlines'));
        carriers.add(new SelectOption('D4','Alidaunia'));
        carriers.add(new SelectOption('AZ','Alitalia'));
        carriers.add(new SelectOption('CT','Alitalia CityLiner'));
        carriers.add(new SelectOption('ALO','Allegheny Airlines'));
        carriers.add(new SelectOption('G4','Allegiant Air'));
        carriers.add(new SelectOption('3A','Alliance Airlines'));
        carriers.add(new SelectOption('QQ','Alliance Airlines'));
        carriers.add(new SelectOption('AJK','Allied Air'));
        carriers.add(new SelectOption('UJ','Almasria'));
        carriers.add(new SelectOption('6T*','Almaty Aviation'));
        carriers.add(new SelectOption('VER','Almaver'));
        carriers.add(new SelectOption('KH','Aloha Air Cargo'));
        carriers.add(new SelectOption('N6','Alpine Air Private Ltd.'));
        carriers.add(new SelectOption('5A','Alpine Aviation'));
        carriers.add(new SelectOption('APF','Amapola'));
        carriers.add(new SelectOption('Z8*','Amaszonas'));
        carriers.add(new SelectOption('AMK','Amerer Air'));
        carriers.add(new SelectOption('AA','American Airlines'));
        carriers.add(new SelectOption('MQ','American Eagle'));
        carriers.add(new SelectOption('ALC','American Linehaul Corporation'));
        carriers.add(new SelectOption('AMF','Ameriflight'));
        carriers.add(new SelectOption('M6','Amerijet International'));
        carriers.add(new SelectOption('AJI','Ameristar Jet Charter'));
        carriers.add(new SelectOption('9K*','Amiyi Airlines'));
        carriers.add(new SelectOption('WD','Amsterdam Airlines'));
        carriers.add(new SelectOption('2V','Amtrak'));
        carriers.add(new SelectOption('AJA','AnadoluJet'));
        carriers.add(new SelectOption('EA','Andalus'));
        carriers.add(new SelectOption('OY','Andes Lineas Aereas'));
        carriers.add(new SelectOption('IK','Angara Airlines'));
        carriers.add(new SelectOption('8G','Angel Airlines'));
        carriers.add(new SelectOption('NGF','Angel Flight America'));
        carriers.add(new SelectOption('G6*','Angkor Airways'));
        carriers.add(new SelectOption('AGO','Angola Air Charter'));
        carriers.add(new SelectOption('AAS','Anguilla Air Services'));
        carriers.add(new SelectOption('ADB','Antonov Airlines'));
        carriers.add(new SelectOption('O4','Antrak Air'));
        carriers.add(new SelectOption('AWS','Arab Wings'));
        carriers.add(new SelectOption('5F','Arctic Circle Air'));
        carriers.add(new SelectOption('FG','Ariana Afghan Airlines'));
        carriers.add(new SelectOption('RIE','Ariella Airlines'));
        carriers.add(new SelectOption('W3','Arik Air'));
        carriers.add(new SelectOption('OR','Arkefly'));
        carriers.add(new SelectOption('IZ','Arkia - Israeli Airlines'));
        carriers.add(new SelectOption('U8','Armavia'));
        carriers.add(new SelectOption('MV','Armenian International Airways'));
        carriers.add(new SelectOption('R7','Aserca Airlines'));
        carriers.add(new SelectOption('OE*','Asia Overnight Express'));
        carriers.add(new SelectOption('KJ','Asian Air'));
        carriers.add(new SelectOption('OZ','Asiana Airlines'));
        carriers.add(new SelectOption('1H','Asiana Airways Cargo'));
        carriers.add(new SelectOption('ER','Astar Air Cargo'));
        carriers.add(new SelectOption('AZI','Astra Airlines'));
        carriers.add(new SelectOption('ACP','Astral Aviation'));
        carriers.add(new SelectOption('ZF','Athens Airways'));
        carriers.add(new SelectOption('7B','Atlant-Soyuz'));
        carriers.add(new SelectOption('HGH','Atlantic Air Lift'));
        carriers.add(new SelectOption('EX*','Atlantic Airlines'));
        carriers.add(new SelectOption('NPT','Atlantic Airlines'));
        carriers.add(new SelectOption('RC','Atlantic Airways Faroe Islands'));
        carriers.add(new SelectOption('4X','Atlantic Express'));
        carriers.add(new SelectOption('TLB','Atlantique Air Assistance'));
        carriers.add(new SelectOption('TD','Atlantis European Airways'));
        carriers.add(new SelectOption('5Y','Atlas Air'));
        carriers.add(new SelectOption('8A','Atlas Blue'));
        carriers.add(new SelectOption('KK','Atlasjet'));
        carriers.add(new SelectOption('V8','Atran'));
        carriers.add(new SelectOption('IP','Atyrau Aue Joly'));
        carriers.add(new SelectOption('ADI','Audeli Air'));
        carriers.add(new SelectOption('IQ','Augsburg Airways'));
        carriers.add(new SelectOption('GR','Aurigny Air Services'));
        carriers.add(new SelectOption('AU','Austral'));
        carriers.add(new SelectOption('XM*','Australian Air Express'));
        carriers.add(new SelectOption('OS','Austrian'));
        carriers.add(new SelectOption('AAT','Austrian Air Transport'));
        carriers.add(new SelectOption('ATV','Avanti Air'));
        carriers.add(new SelectOption('Z7','Avia Traffic Company'));
        carriers.add(new SelectOption('E6','AviaExpressCruise Airlines'));
        carriers.add(new SelectOption('ZR*','Aviacon Zitotrans'));
        carriers.add(new SelectOption('7U','Aviaenergo'));
        carriers.add(new SelectOption('NVI','Avial'));
        carriers.add(new SelectOption('TWN','Avialeasing'));
        carriers.add(new SelectOption('AV','Avianca'));
        carriers.add(new SelectOption('O6','Avianca Brazil'));
        carriers.add(new SelectOption('AO','Avianova'));
        carriers.add(new SelectOption('6I','Aviast Air'));
        carriers.add(new SelectOption('VIT','Aviastar Mandiri'));
        carriers.add(new SelectOption('4B','Aviastar-TU'));
        carriers.add(new SelectOption('CKL','Aviation Charter Services'));
        carriers.add(new SelectOption('SMJ','Avient Aviation'));
        carriers.add(new SelectOption('M4','Avioimpex'));
        carriers.add(new SelectOption('VSR','Aviostart'));
        carriers.add(new SelectOption('G2','Avirex Gabon'));
        carriers.add(new SelectOption('2Q','Avitrans Nordic AB'));
        carriers.add(new SelectOption('O8','Axis Lines'));
        carriers.add(new SelectOption('AHC','Azal Avia Cargo'));
        carriers.add(new SelectOption('AD','Azul'));
        carriers.add(new SelectOption('AB','airberlin'));
        carriers.add(new SelectOption('WN','Southwest Airlines'));
        return carriers;
    }
    public String getSelectedCarrier()
    {
        return selectedCarrier;
    }
    public void setSelectedCarrier(String selectedCarrier)
    {
        this.selectedCarrier = selectedCarrier;
    }
    
    
    public FlightStatusController()
    {
        year = string.valueOf(datetime.now().year());
        month = string.valueOf(datetime.now().month());
        day = string.valueOf(datetime.now().day());
    }
    
    public PageReference BasicFlightCallout()
    {
        HttpRequest request = new HTTPRequest();
        string baseURL = 'https://api.flightstats.com:443/flex/flightstatus/rest/v2/json/flight/status/';
        baseURL += selectedCarrier;
        baseURL += '/';
        baseURL += flightNumber;
        baseURL += '/dep/';
        baseURL += year;
        baseURL += '/';
        baseURL += month;
        baseURL += '/';
        baseURL += day;
        
        WebRequest = baseURL;
        request.setEndpoint(baseURL);
        request.setHeader('appId','9adde197');
        request.setHeader('appKey','1f7be2054fb955632a8a48c10d194764');
        request.setMethod('GET');
        try
        {
        Http http = new Http();
        HTTPResponse response = http.send(request);
        System.debug(response.getBody());
        WebResponse = response.getBody();
        System.JSONParser parser = JSON.createParser(WebResponse);
        RootObject ro = (RootObject)JSON.deserialize(WebResponse, FlightStatusController.RootObject.class);
        FormatResponse = 'Finished Processing: \n\n';
        if(ro.flightStatuses.size() > 0)
        {
            FormatResponse += 'Flight Number: ' + ro.flightStatuses[0].flightNumber + '\n\n';
            FormatResponse += 'Departure: ' + ro.flightStatuses[0].departureDate.dateLocal + '\n\n';
            FormatResponse += 'Arrival: ' + ro.flightStatuses[0].arrivalDate.dateLocal + '\n\n';
            FormatResponse += 'Flight Status: ' + ro.flightStatuses[0].status + '\n\n';
            if(ro.flightStatuses[0].delays != null)
            {
            	Delays d = ro.flightStatuses[0].delays;
	            FormatResponse += 'Delay at Departure Gate (Minutes): ' + d.departureGateDelayMinutes + '\n\n';
    	        FormatResponse += 'Delay at Departure Runway (Minutes): ' + d.departureRunwayDelayMinutes + '\n\n';
            }
            if(ro.flightStatuses[0].flightDurations != null)
            {
            	FlightDurations fd = ro.flightStatuses[0].flightDurations;
            	FormatResponse += 'Flight Time (Minutes): ' + fd.airMinutes + '\n\n';
            }
        }
        
        
        
        /*
        parser.nextToken(); //Start Object
        parser.nextToken();
            flight = new Flight(); 
            while(parser.nextToken() != null)
            {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'flightId')
                {
                    parser.nextValue();
                    flight.flightId = parser.getText();
                }
                    
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'carrierFsCode')
                {
                    parser.nextValue();
                    flight.carrierFsCode = parser.getText();
                }
                    
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'flightNumber')
                {
                    parser.nextValue();
                    flight.flightNumber = parser.getText();
                }
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'departureAirportFsCode')
                {
                    parser.nextValue();
                    flight.departureAirportFsCode = parser.getText();
                }
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'arrivalAirportFsCode')
                {
                    parser.nextValue();
                    flight.arrivalAirportFsCode = parser.getText();
                }
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'status')
                {
                    parser.nextValue();
                    flight.status = parser.getText();
                }
            }
            FormatResponse = 'Flight Id: ' + flight.flightId + '\n\n';
            FormatResponse += 'Carrier Code: ' + flight.carrierFsCode + '\n\n';
            FormatResponse += 'Flight Number: ' + flight.flightNumber + '\n\n';
            FormatResponse += 'Departing Airport: ' + flight.departureAirportFsCode + '\n\n';
            FormatResponse += 'Arriving Airport: ' + flight.arrivalAirportFsCode + '\n\n';
            FormatResponse += 'Status: ' + flight.status + '\n\n';
            FormatResponse += 'Departure Time: ' + flight.departureDate + '\n\n';
            FormatResponse += 'Arrival Time: ' + flight.arrivalDate + '\n\n';
            FormatResponse += 'Aircraft: ' + flight.equipmentName + '\n\n';
            
            */
        }
        catch(Exception e)
        {
            WebResponse = '' + e;
        }
        
        return null;
    }
    
    
    
    public class RootObject
    {
        public Request request { get; set; }
        public Appendix appendix { get; set; }
        public List<FlightStatus> flightStatuses { get; set; }
        
        public RootObject(Request request, Appendix appendix, List<FlightStatus> flightStatuses)
        {
            this.request = new Request();
            this.appendix = new Appendix();
            this.flightStatuses = new List<FlightStatus>();
        }
    }
    
    public class FlightStatus
    {
        public integer flightId { get; set; }
        public string carrierFsCode { get; set; }
        public string flightNumber { get; set; }
        public string departureAirportFsCode { get; set; }
        public string arrivalAirportFsCode { get; set; }
        public DepartureDate departureDate { get; set; }
        public ArrivalDate arrivalDate { get; set; }
        public string status { get; set; }
        public Schedule schedule { get; set; }
        public OperationalTimes operationalTimes { get; set; }
        public List<Codeshare> codeshares { get; set; }
        public Delays delays { get; set; }
        public FlightDurations flightDurations { get; set; }
        public AirportResources airportResources { get; set; }
        public FlightEquipment flightEquipment { get; set; }
        
        public FlightStatus(integer flightId, string carrierFsCode, string flightNumber,
        string departureAirportFsCode, DepartureDate departureDate, ArrivalDate arrivalDate,
        string status, Schedule schedule, OperationalTimes operationalTimes, List<Codeshare> codeshares,
        Delays delays, FlightDurations flightDurations, AirportResources airportResources, FlightEquipment flightEquipment)
        {
            this.flightId = flightId;
            this.carrierFsCode = carrierFsCode;
            this.flightNumber = flightNumber;
            this.departureAirportFsCode = departureAirportFsCode;
            this.departureDate = new DepartureDate();
            this.arrivalDate = new ArrivalDate();
            this.status = status;
            this.schedule = new Schedule();
            this.operationalTimes = new OperationalTimes();
            this.codeshares = new List<Codeshare>();
            this.delays = new Delays();
            this.flightDurations = new FlightDurations();
            this.airportResources = new AirportResources();
            this.flightEquipment = new FlightEquipment();
        }
        public FlightStatus()
        {
            
        }            
    }
    
    public class AirportResources
    {
        public string departureTerminal { get; set; }
        public string departureGate { get; set; }
        public string arrivalTerminal { get; set; }
        public string arrivalGate { get; set; }
        
        public AirportResources(string departureTerminal, string departureGate, string arrivalTerminal, string arrivalGate)
        {
            this.departureTerminal = departureTerminal;
            this.departureGate = departureGate;
            this.arrivalTerminal = arrivalTerminal;
            this.arrivalGate = arrivalGate;
        }
        public AirportResources()
        {
            
        }
    }
    public class FlightEquipment
    {
        public string scheduledEquipmentIataCode { get; set; }
        public string actualEquipmentIataCode { get; set; }
        public string tailNumber { get; set; }
        
        public FlightEquipment(string scheduledEquipmentIataCode, string actualEquipmentIataCode, string tailNumber)
        {
            this.scheduledEquipmentIataCode = scheduledEquipmentIataCode;
            this.actualEquipmentIataCode = actualEquipmentIataCode;
            this.tailNumber = tailNumber;
        }
        public FlightEquipment()
        {
            
        }
    }
    public class Equipment
    {
        public string iata { get; set; }
        public string name { get; set; }
        public boolean turboProp { get; set; }
        public boolean jet { get; set; }
        public boolean widebody { get; set; }
        public boolean regional { get; set; }
        
        public Equipment(string iata, string name, boolean turboProp, boolean jet, boolean widebody, boolean regional)
        {
            this.iata = iata;
            this.name = name;
            this.turboProp = turboProp;
            this.jet = jet;
            this.widebody = widebody;
            this.regional = regional;
        }
        public Equipment()
        {
            
        }
    }
    
    
    public class Airline
    {
        public string requestedCode { get; set; }
        public string fsCode { get; set; }
        
        public Airline(string requestedCode, string fsCode)
        {
            this.requestedCode = requestedCode;
            this.fsCode = fsCode;
        }
        public Airline()
        {
            
        }
    }
    
    public class Flight
    {
        public string requested { get; set; }
        public string interpreted { get; set; }
        
        public Flight(string requested, string interpreted)
        {
            this.requested = requested;
            this.interpreted = interpreted;
        }
        public Flight()
        {
            
        }
    }
    
    public class FlightDate
    {
        public string year { get; set; }
        public string month { get; set; }
        public string day { get; set; }
        public string interpreted { get; set; }
        
        public FlightDate(string year, string month, string day, string interpreted)
        {
            this.year = year;
            this.month = month;
            this.day = day;
            this.interpreted = interpreted;
        }
        public FlightDate()
        {
            
        }
    }
    
    public class Utc
    {
        public boolean interpreted { get; set; }
        
        public Utc(boolean interpreted)
        {
            this.interpreted = interpreted;
        }
        public Utc()
        {
            
        }
    }
    
    public class Airport
    {
        
    }
    
    public class CodeType
    {
        
    }
    
    public class ExtendedOptions
    {
        
    }
    
    public class Request
    {
        public Airline airline { get; set; }
        public Flight flight { get; set; }
        public FlightDate flightDate { get; set; }
        public Utc utc { get; set; }
        public Airport airport { get; set; }
        public CodeType codeType { get; set; }
        public ExtendedOptions extendedOptions { get; set; }
        public string url { get; set; }
        
        
        public Request()
        {
            
        }
        public Request(Airline airline, Flight flight, FlightDate flightDate, Utc utc, Airport airport, CodeType codeType, ExtendedOptions extendedOptions, string url)
        {
            this.airline = new Airline();
            this.flight = new Flight();
            this.flightDate = new FlightDate();
            this.utc = new Utc();
            this.airport = new Airport();
            this.codeType = new CodeType();
            this.extendedOptions = new ExtendedOptions();
            this.url = url;
        }
    }
    
    public class Airline2
    {
        public string fs { get; set; }
        public string iata { get; set; }
        public string icao { get; set; }
        public string name { get; set; }
        public boolean active { get; set; }
        public string phoneNumber { get; set; }
        
        public Airline2(string fs, string iata, string icao, string name, boolean active, string phoneNumber)
        {
            this.fs = fs;
            this.iata = iata;
            this.icao = icao;
            this.name = name;
            this.active = active;
            this.phoneNumber = phoneNumber;
        }
        public Airline2()
        {
            
        }
    }
    
    public class Airport2
    {
        public string fs { get; set; }
        public string iata { get; set; }
        public string icao { get; set; }
        public string faa { get; set; }
        public string name { get; set; }
        public string street1 { get; set; }
        public string city { get; set; }
        public string cityCode { get; set; }
        public string stateCode { get; set; }
        public string postalCode { get; set; }
        public string countryCode { get; set; }
        public string countryName { get; set; }
        public string regionName { get; set; }
        public string timeZoneRegionName { get; set; }
        public string weatherZone { get; set; }
        public string localTime { get; set; }
        public double utcOffsetHours { get; set; }
        public double latitude { get; set; }
        public double longitude { get; set; }
        public integer elevationFeet { get; set; }
        public integer classification { get; set; }
        public boolean active { get; set; }
        public string delayIndexUrl { get; set; }
        public string weatherUrl { get; set; }
        
        public Airport2(string fs, string iata, string icao, string faa, string name,
                        string street1, string city, string cityCode, string stateCode,
                        string postalCode, string countryCode, string countryName,
                        string regionName, string timeZoneRegionName,
                        string weatherZone, string localTime, double utcOffsetHours, 
                        double latitude, double longitude,
                        integer elevationFeet, integer classification, boolean active, string delayIndexUrl,
                        string weatherUrl)
        {
            this.fs = fs;
            this.iata = iata;
            this.icao = icao;
            this.faa = faa;
            this.name = name;
            this.street1 = street1;
            this.city = city;
            this.cityCode = cityCode;
            this.stateCode = stateCode;
            this.postalCode = postalCode;
            this.countryCode = countryCode;
            this.countryName = countryName;
            this.regionName = regionName;
            this.timeZoneRegionName = timeZoneRegionName;
            this.weatherZone = weatherZone;
            this.localTime = localTime;
            this.utcOffsetHours = utcOffsetHours;
            this.latitude = latitude;
            this.longitude = longitude;
            this.elevationFeet = elevationFeet;
            this.classification = classification;
            this.active = active;
            this.delayIndexUrl = delayIndexUrl;
            this.weatherUrl = weatherUrl;
        
        }
        
        public Airport2()
        {
            
        }
    }
    
    public class Appendix
    {
        public List<Airline2> airlines { get; set; }
        public List<Airport2> airports { get; set; }
        public List<Equipment> equipments { get; set; }
        
        public Appendix()
        {
            
        }
        public Appendix(List<Airline2> airlines, List<Airport2> airports, List<Equipment> equipments)
        {
            this.airlines = new List<Airline2>();
            this.airports = new List<Airport2>();
            this.equipments = new List<Equipment>();
        }
    }
        
    
    public class DepartureDate
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public DepartureDate(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public DepartureDate()
        {
            
        }
    }
    
    public class ArrivalDate
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public ArrivalDate(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public ArrivalDate()
        {
            
        }
    }
    
    public class Schedule
    {
        public string flightType { get; set; }
        public string serviceClasses { get; set; }
        public string restrictions { get; set; }
        
        public Schedule(string flightType, string serviceClasses, string restrictions)
        {
            this.flightType = flightType;
            this.serviceClasses = serviceClasses;
            this.restrictions = restrictions;
        }
        public Schedule()
        {
            
        }
    }
    
    public class PublishedDeparture
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public PublishedDeparture(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public PublishedDeparture()
        {
        }
        
    }
    
    public class PublishedArrival
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public PublishedArrival(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public PublishedArrival()
        {
            
        }
    }
    
    public class ScheduledGateDeparture
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public ScheduledGateDeparture(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public ScheduledGateDeparture()
        {
            
        }
    }
    
    public class ActualGateDeparture
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public ActualGateDeparture(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public ActualGateDeparture()
        {
            
        }
    }
    
    public class FlightPlanPlannedDeparture
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public FlightPlanPlannedDeparture(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public FlightPlanPlannedDeparture()
        {
            
        }
    }
    
    public class EstimatedRunwayDeparture
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public EstimatedRunwayDeparture(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public EstimatedRunwayDeparture()
        {
            
        }
    }
    
    public class ActualRunwayDeparture
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public ActualRunwayDeparture(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public ActualRunwayDeparture()
        {
            
        }
    }
    
    public class ScheduledGateArrival
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public ScheduledGateArrival(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public ScheduledGateArrival()
        {
            
        }
    }
    
    public class EstimatedGateArrival
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public EstimatedGateArrival(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public EstimatedGateArrival()
        {
            
        }
    }
    
    public class ActualGateArrival
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public ActualGateArrival(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public ActualGateArrival()
        {
            
        }
    }
    
    public class FlightPlanPlannedArrival
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public FlightPlanPlannedArrival(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public FlightPlanPlannedArrival()
        {
            
        }
    }
    
    public class EstimatedRunwayArrival
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public EstimatedRunwayArrival(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public EstimatedRunwayArrival()
        {
            
        }
    }
    
    public class ActualRunwayArrival
    {
        public string dateLocal { get; set; }
        public string dateUtc { get; set; }
        
        public ActualRunwayArrival(string dateLocal, string dateUtc)
        {
            this.dateLocal = dateLocal;
            this.dateUtc = dateUtc;
        }
        public ActualRunwayArrival()
        {
            
        }
    }
    
    public class OperationalTimes
    {
        public PublishedDeparture publishedDeparture { get; set; }
        public PublishedArrival publishedArrival { get; set; }
        public ScheduledGateDeparture scheduledGateDeparture { get; set; }
        public ActualGateDeparture actualGateDeparture { get; set; }
        public FlightPlanPlannedDeparture flightPlanPlannedDeparture { get; set; }
        public EstimatedRunwayDeparture estimatedRunwayDeparture { get; set; }
        public ActualRunwayDeparture actualRunwayDeparture { get; set; }
        public ScheduledGateArrival scheduledGateArrival { get; set; }
        public EstimatedGateArrival estimatedGateArrival { get; set; }
        public ActualGateArrival actualGateArrival { get; set; }
        public FlightPlanPlannedArrival flightPlanPlannedArrival { get; set; }
        public EstimatedRunwayArrival estimatedRunwayArrival { get; set; }
        public ActualRunwayArrival actualRunwayArrival { get; set; }
        
        public OperationalTimes(PublishedDeparture publishedDeparture, 
                            PublishedArrival publishedArrival,
                            ScheduledGateDeparture scheduledGateDeparture,
                            ActualGateDeparture actualGateDeparture,
                            FlightPlanPlannedDeparture flightPlanPlannedDeparture,
                            EstimatedRunwayDeparture estimatedRunwayDeparture,
                            ActualRunwayDeparture actualRunwayDeparture,
                            ScheduledGateArrival scheduledGateArrival,
                            EstimatedGateArrival estimatedGateArrival,
                            ActualGateArrival actualGateArrival,
                            FlightPlanPlannedArrival flightPlanPlannedArrival,
                            EstimatedRunwayArrival estimatedRunwayArrival,
                            ActualRunwayArrival actualRunwayArrival)
        {
            this.publishedDeparture = new PublishedDeparture();
            this.publishedArrival = new PublishedArrival();
            this.scheduledGateDeparture = new ScheduledGateDeparture();
            this.actualGateDeparture = new ActualGateDeparture();
            this.flightPlanPlannedDeparture = new FlightPlanPlannedDeparture();
            this.estimatedRunwayDeparture = new EstimatedRunwayDeparture();
            this.actualRunwayDeparture = new ActualRunwayDeparture();
            this.scheduledGateArrival = new ScheduledGateArrival();
            this.estimatedGateArrival = new EstimatedGateArrival();
            this.actualGateArrival = new ActualGateArrival();
            this.flightPlanPlannedArrival = new FlightPlanPlannedArrival();
            this.estimatedRunwayArrival = new EstimatedRunwayArrival();
            this.actualRunwayArrival = new ActualRunwayArrival();
        }
        public OperationalTimes()
        {
            
        }
    }
        
    public class FlightDurations
    {
        public integer scheduledBlockMinutes { get; set; }
        public integer blockMinutes { get; set; }
        public integer scheduledAirMinutes { get; set; }
        public integer airMinutes { get; set; }
        public integer scheduledTaxiOutMinutes { get; set; }
        public integer taxiOutMinutes { get; set; }
        public integer taxiInMinutes { get; set; }
        
        public FlightDurations(integer scheduledBlockMinutes, integer blockMinutes, integer scheduledAirMinutes, integer airMinutes, integer scheduledTaxiOutMinutes, integer taxiOutMinutes, integer taxiInMinutes )
        {
            this.scheduledBlockMinutes = scheduledBlockMinutes;
            this.blockMinutes = blockMinutes;
            this.scheduledAirMinutes = scheduledAirMinutes;
            this.airMinutes = airMinutes;
            this.scheduledTaxiOutMinutes = scheduledTaxiOutMinutes;
            this.taxiOutMinutes = taxiOutMinutes;
            this.taxiInMinutes = taxiInMinutes; 
        }
        public FlightDurations()
        {
            
        }
    }
    
    public class Delays
    {
        public integer departureGateDelayMinutes { get; set; }
        public integer departureRunwayDelayMinutes { get; set; }
        
        public Delays(integer departureGateDelayMinutes, integer departureRunwayDelayMinutes)
        {
            this.departureGateDelayMinutes = departureGateDelayMinutes;
            this.departureRunwayDelayMinutes = departureRunwayDelayMinutes; 
        }
        public Delays()
        {
            
        }
    }
    
    public class Codeshare
    {
        public string fsCode { get; set; }
        public string flightNumber { get; set; }
        public string relationship { get; set; }
        
        public CodeShare(string fsCode, string flightNumber, string relationship)
        {
            this.fsCode = fsCode;
            this.flightNumber = flightNumber;
            this.relationship = relationship;
        }
        public CodeShare()
        {
            
        }
    }
    
    
        
        
    /*
    public class Flight 
    {
        public string flightId;
        public string carrierFsCode;
        public string flightNumber;
        public string departureAirportFsCode;
        public string arrivalAirportFsCode;
        public string status;
        public datetime departureDate;
        public datetime arrivalDate;
        public string equipmentName;
        public Flight()
        {
            
        }
    }*/
    
 
    public static testMethod void TestFlightStats()
    {
        FlightStatusController controller = new FlightStatusController();
        controller.carrierCode = 'AA';
        controller.flightNumber = '100';
        Test.startTest();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('FlightStatsJSON');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type','application/json');
        Test.setMock(HttpCalloutMock.class, mock);
        List<SelectOption> carriers = controller.getCarrierList();
        controller.setSelectedCarrier('AA');
        controller.BasicFlightCallout();
        controller.rootObjectx = new RootObject(new Request(),new Appendix(),new List<FlightStatus>());
        controller.flightStatusx = new FlightStatus();
        controller.airport2x = new Airport2();
        controller.operationalTimesx = new OperationalTimes();
        controller.airportResourcesx = new AirportResources();
				controller.flightEquipmentx = new FlightEquipment();
				controller.equipmentx = new Equipment();
				controller.airlinex = new Airline();
				controller.flightx = new Flight();
				controller.flightdatex = new FlightDate();
				controller.utcx = new Utc();
				controller.airportx = new Airport();
				controller.requestx = new Request();
				controller.airline2x = new Airline2();
				controller.departuredatex = new DepartureDate();
				controller.arrivaldatex = new ArrivalDate();
				controller.schedulex = new Schedule();
				controller.publisheddeparturex = new PublishedDeparture();
				controller.publishedarrivalx = new PublishedArrival();
				CodeShare cs = new CodeShare('test','test','test');
				FlightDurations fd = new FlightDurations(1, 1, 1, 1, 1, 1, 1);
				Airport2 ap2 = new Airport2('fs', 'iata', 'icao', 'faa', 'name', 'street1', 'city', 'cityCode', 'stateCode', 'postalCode', 'countryCode', 'countryName','regionName','timeZoneRegionName','weatherZone', 'localTime', 0, 0, 0, 0, 0, false, 'delayIndexUrl','weatherUrl');
    		Test.stopTest();
    }
}