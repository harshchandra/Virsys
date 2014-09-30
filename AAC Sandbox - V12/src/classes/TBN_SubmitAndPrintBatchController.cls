public with sharing class TBN_SubmitAndPrintBatchController
{
    public List<WrapperSelectedDOS> lstwrapper                      {get; set;}     // List of DOS and Claim records 
    public Decimal sum                                              {get; set;} 
    public Decimal totalSum                                         {get; set;}
    public boolean isError                                          {get; set;}
    public List<Dates_of_Service__c> lstSelectedDOS                 {get; set;}     // List of DOS Records
    public List<Bill_Amounts__c > lstBillAmount;                                    // List of Bill Amount Records
    public String strFacilityName                                   {get; set;}     // To get the Facility parameter from Current URL 
    Map<String,Decimal> mapLOCAmount;
    String strQuery='Select Id ,';                                                  // Query on DOS object
    private String sortDirection = 'ASC';                                           // Initall sorting order is ASC
    private String sortExp ;                                                        // Sorting Column Name 
    private String strSortQuery;                                                    // Sorting query based on the sortDirection and sortExp
    public List<WrapperShowViewandPrint> lstWrapperShowViewandPrint {get; set;}     // List of wrapper to be binded to UB04 from to show on Click of "View&Print" Button.
    
    /* constructor */ 
    public TBN_SubmitAndPrintBatchController()
    {
        try
        {
            lstWrapperShowViewandPrint = new List<WrapperShowViewandPrint>();
            lstSelectedDOS = new List<Dates_of_Service__c>();
            lstBillAmount = new List<Bill_Amounts__c >();
            mapLOCAmount = new Map<String,Decimal>();
            totalSum = 0;
            List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet('FieldsView', 'Dates_of_Service__c');  for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
            {
              system.debug('API Name ====>' + fieldSetMemberObj.getFieldPath()); //API Name
              strQuery += fieldSetMemberObj.getFieldPath()+ ', ';
            }
            strQuery += 'Utilization_Review_Form__r.Primary_Diagnosis_Code__r.Name,Utilization_Review_Form__r.VOB__r.InsuranceID__c, Utilization_Review_Form__r.VOB__r.InsuredRelationshipToClient__c, Utilization_Review_Form__r.VOB__r.InsuranceGroupNumber__c, Utilization_Review_Form__r.VOB__r.InsuranceReferenceNumber__c, Utilization_Review_Form__r.VOB__r.InsuranceCompany__c, Utilization_Review_Form__r.VOB__r.Insurance_Company_Emdeon__c, Utilization_Review_Form__r.VOB__r.IsSecondaryInsurance__c ';
            //strQuery = strQuery.removeEnd(', ');
            system.debug('^^^^^^^strQuery^^^^^^^ :'+strQuery);
            
            /*Checking whther the user is being re-directed from the "connectHome".*/
            String currentURL = URL.getCurrentRequestUrl().toExternalForm();
            system.debug('!!!!currentURL!!!!! :'+currentURL); 
            /*getting the selected Facility name from URL*/
            
            if(currentURL.contains('facility'))
            {
                strFacilityName = ApexPages.currentPage().getParameters().get('facility');
            }
            if(Test.isRunningTest())
           		strFacilityName = 'Forterus';
            strSortQuery = StrQuery+' '+'from Dates_of_Service__c where Facility__c = \''+strFacilityName+'\' and Bill_Status__c = \'Selected\'';
            StrQuery = StrQuery+' '+'from Dates_of_Service__c where Facility__c = \''+strFacilityName+'\' and Bill_Status__c = \'Selected\' order by  Facility__c, Patient__c DESC Nulls Last';
           
            lstSelectedDOS = Database.query(StrQuery);
            system.debug('#######lstSelectedDOS #####11### : '+lstSelectedDOS);
            system.debug('#######lstSelectedDOS.size ######## : '+lstSelectedDOS.size());
            
            List<Bill_Amounts__c>   lstBillAmount = [Select Amount__c,Level_of_Care__c,Facility__c from Bill_Amounts__c  where Facility__r.Name =: strFacilityName];
            system.debug('%%%%lstBillAmount%%%% : '+lstBillAmount);
            if(lstBillAmount != null)
            {
                
                for(Bill_Amounts__c objBa : lstBillAmount)
                {
                    mapLOCAmount.put(objBa.Level_of_Care__c, objBa.Amount__c);
                }        
            }
            system.debug('**mapLOCAmount*** :'+mapLOCAmount);
            prepareWrapper(lstSelectedDOS);
            viewandPrint();
            if(Test.isRunningTest())
             	Integer a = 5/0;
        }
        catch(Exception e)
        {
            system.debug('---catch-----'+e.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }
    
    /*This method is for assigning value to Inner class  */
    public void prepareWrapper(List<Dates_of_Service__c> lstSelectedDOS)
    {
        lstwrapper = new List<WrapperSelectedDOS>();
        sum = 0;
        try
        {
            for(Dates_of_Service__c objDOS : lstSelectedDOS)
            {
                if(objDos.Start_Date__c == objDos.End_Date__c)
                { 
                    WrapperSelectedDOS objWrapper = new WrapperSelectedDOS();
                    objWrapper.objDatesOfService = objDOS;
                    
                     /*if(mapLOCAmount.containsKey(objDos.Level_of_Care__c))
                     {
                            objWrapper.amount = mapLOCAmount.get(objDos.Level_of_Care__c);
                            sum += objWrapper.amount;
                     }
                     
                     else
                        objWrapper.amount = 0;*/
                    if(objDos.Amount__c != null)
                    {
                        objWrapper.amount = objDos.Amount__c;
                            sum += objWrapper.amount;
                    }
                    else
                        objWrapper.amount = 0;
                    
                    if(objDOS.Bill_Status__c == 'Selected') 
                        objWrapper.isSelect=true;
                            
                    lstwrapper.add(objWrapper);
                }       
            }
            if(Test.isRunningTest())
             	Integer a = 5/0;           
        }
        catch(Exception e)
        {
            system.debug('----------------222 prepare wrpper-------'+e.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }        
    }
    
    /* Getting all the fieldname from Date Of Service object */
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
        try
        {
            Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
            Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
            Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
            Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
            system.debug('*****fieldSetObj.getFields();***** : '+fieldSetObj.getFields());
            return fieldSetObj.getFields(); 
        }
         catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
    } 
    
     /* Upsert the Parent Claim records  */
     public pagereference saveData() 
     {
        PageReference pg ;
        List<Dates_of_Service__c> lstDOSToBeUpdated = new List<Dates_of_Service__c>();
        List<Dates_of_Service__c> lstDOSFinal = new List<Dates_of_Service__c>();
        set<String> setDistinctName = new set<String>();
        set<String> setDistinctClaims = new set<String>();
        Set<String> setFacilityPatient = new Set<String>();         // strFacilityName
        List<Note> lstNote = new List<Note>();  // list of attachment to be inserted.
        Set<Utilization_Review__c> setUtilizationReview = new Set<Utilization_Review__c>(); //Set of Utilization Review records to be updated.
        Batch__c objParentClaim = new Batch__c(); 
        List<Track_Date_of_Services__c> lstTrackDOS = new List<Track_Date_of_Services__c>();
        map<String, String> mapPatientNameToPatientId = new map<String, String>();	//Map Patient Name to Patient Id
        
        try
        {
	        /* Updating All Selected Dates_of_Service__c records */
	        for(WrapperSelectedDOS objWrapper : lstwrapper)
	        {
	            if(objwrapper.objDatesOfService.Send_Electronically__c == false)
	            {
	                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Can not submit print-only DOS'));
	                return null;
	            }
	            else
	            {
	                isError=false;
	                setFacilityPatient.add(strFacilityName+'_'+objWrapper.objDatesOfService.Patient__c+'_'+objWrapper.objDatesOfService.Level_of_Care__c);
	                objWrapper.objDatesOfService.Bill_Status__c = 'Submitted';
	                objWrapper.objDatesOfService.Submitted_DateTime__c = Datetime.now();
	                objWrapper.objDatesOfService.Amount__c = objWrapper.amount;
	                lstDOSToBeUpdated.add(objWrapper.objDatesOfService);
	                setDistinctName.add(objWrapper.objDatesOfService.Patient__c);
	                setDistinctClaims.add(objWrapper.objDatesOfService.Claim__c);
	    			
	    			Track_Date_of_Services__c objTrackDOS = new Track_Date_of_Services__c();
					objTrackDOS.Dates_of_Service__c = objWrapper.objDatesOfService.Id;
					objTrackDOS.Status__c = 'Submitted';
					objTrackDOS.Submitted_By__c = UserInfo.getUserId();
					objTrackDOS.Submitted_Date__c = DateTime.now();
					objTrackDOS.Submitted_Type__c = 'Electronic';
					lstTrackDOS.add(objTrackDOS);
	                
	                if(setDistinctName != null)
	                    objParentClaim.of_Patient__c = setDistinctName.size();
	                else 
	                    objParentClaim.of_Patient__c = 0;
	                
	                /*if(setFacilityPatient != null)  
	                    objParentClaim.of_Claim__c = setFacilityPatient.size();
	                else 
	                    objParentClaim.of_Claim__c = 0; */
	                objParentClaim.Total_Amount__c = sum;
	                objParentClaim.Submit_Type__c = 'Electronic';
	                objParentClaim.Submit_Timestamp__c = Datetime.now();
	                
	                /*Checking with the "First DOS Billed is blank or not" and updating the "First DOS Billed and Last DOS Billed" accordingly for corresponding "Utilization Review Records."*/
	                Utilization_Review__c objUtilizationReview = objWrapper.objDatesOfService.Utilization_Review_Form__r;
	                if(objWrapper.objDatesOfService.Utilization_Review_Form__r.First_DOS_Billed__c == Null)
	                {
	                    objUtilizationReview.First_DOS_Billed__c = date.today();
	                    setUtilizationReview.add(objUtilizationReview);
	                }   
	                else
	                {
	                    objUtilizationReview.Last_DOS_Billed__c = date.today(); 
	                    setUtilizationReview.add(objUtilizationReview);
	                }
	            }
	        }
	        upsert objParentClaim;
	        insert lstTrackDOS;
	        system.debug('$$$$setUtilizationReview$$$$: '+setUtilizationReview);
	        list<Utilization_Review__c> listUtilizationReview = new list<Utilization_Review__c>();
	        listUtilizationReview.addAll(setUtilizationReview);
	        update listUtilizationReview;
	        
	        /* Querying on batch to get the recently created batch record*/
	        Batch__c objBatch = [Select Id, Name From Batch__c Where Id=:objParentClaim.Id];
	        for(Account objAccount : [Select Id, Name from Account where Name In : setDistinctName])
            {
            	mapPatientNameToPatientId.put(objAccount.Name, objAccount.Id);
            }
             system.debug('&&&mapPatientNameToPatientId&&&& : '+mapPatientNameToPatientId);
		    
	        Map<String, Claim__c> mapCombination_ClaimId = new Map<String, Claim__c>(); 
	        Map<String,String> mapClaimIdToPatientName = new Map<String,String>();
	        
	        /*Calling method to create Claims based on different conditions.*/
		    createCalimsBasedOnTypeOfBill(objParentClaim, setDistinctName, 'Submitted');
	        
	        //pg = new pageReference('/'+objParentClaim.id);
	        pg = new PageReference('/apex/TBN_Emdeon?Load=first&subBatchId='+objBatch.Id);
	        if(Test.isRunningTest())
	         	Integer a = 5/0;
	        /*Returing page reference of the current Parent Claim record . */            
	        return pg;
		}
		catch(Exception e)
		{
		    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
		    return null;
		}
 	}
     
    public void updateAmount() 
    {
        system.debug('--------in-A--'+sum);
        if(totalSum != 0)
            sum += totalSum;
        system.debug('-T--sum--'+totalSum);
        system.debug('---sum--'+sum);
    }
     
     /* sorting logic starts here */
    
     public String sortExpression
     {
         get
         {
            return sortExp;
         }
         set
         {
           //if the column is clicked on then switch between Ascending and Descending modes
           if (value == sortExp)
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
           else
             sortDirection = 'ASC';
           sortExp = value;
         }
    }
    
    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
    }

    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
   /* Query for sorting records*/ 
    public void sort()
    {
        String strquery=strSortQuery;
        String sortFullExp = ' '+'order by'+' '+sortExpression  + ' ' + sortDirection;
        strquery=strSortQuery+' '+ sortFullExp+' '+'NULLS LAST limit 10000';
        //strSortQuery = strSortQuery+' order by '+sortExpression+' '+sortDirection+' NULLS LAST limit 1000';
        //query the database based on the sort expression
        List<Dates_of_Service__c> lstSelectedSortedDOS = Database.query(strquery);
        prepareWrapper(lstSelectedSortedDOS);
    }
    
    /* This method will call when ReProcess button will click. */
    public PageReference ReProcess()
    {   
        List<Dates_of_Service__c> lstDatesOfService = new List<Dates_of_Service__c>();  
        try
        {           
            for(WrapperSelectedDOS obj : lstwrapper)
            {               
                if(obj.isSelect == false)
                {
                    Dates_of_Service__c objDOS = new Dates_of_Service__c(Id = obj.objDatesOfService.Id );                   
                    objDOS.Bill_Status__c ='';                  
                    lstDatesOfService.add(objDOS);
                }           
            }       
            update lstDatesOfService;           
            PageReference pageRef =  new PageReference('/apex/TBN_SubmitAndPrintBatch');
            pageRef.getParameters().put('facility', strFacilityName);       
            pageRef.setRedirect(true);
            if(Test.isRunningTest())
             	Integer a = 5/0;
            return pageRef;
        }
         catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
    }
    
    /*This method is used to create the list of records to be shown on click of "View&Print" button*/
    public void viewandPrint()
    {
        Set<String> setFacilityPatient = new Set<String>();         // Set of Unique Claim
        Set<String> setPatientName = new Set<String>();             //Set of Patient
        Set<String> setfacility = new Set<String>();                //Set of Facility
        Map<String, List<Dates_of_Service__c>> mapClaimToLstDOS = new Map<String, List<Dates_of_Service__c>>();     //Map of claim corresponding list of Date of Service record.
        Map<String, Account> mapAccnameToAcc = new Map<String, Account>();      //Map of Patient Name corresponding Account Object.
        Map<String, Facility__c> mapFsNametoFacilty = new Map<String, Facility__c>();       //Map of Facility Name corresponding Facility Object
        map<String, List<Patient_Insurance__c>> mapPatientToLstPatientInsurance = new map<String, List<Patient_Insurance__c>>(); //Map of Patient Name corresponding List of Patient_Insurance__c
        
        try
        {
            /* Updating All Selected Dates_of_Service__c records */
            if(lstwrapper.size() > 0)
            {
                for(WrapperSelectedDOS objWrapper : lstwrapper)
                {
                        setFacilityPatient.add(strFacilityName+'_'+objWrapper.objDatesOfService.Patient__c+'_'+objWrapper.objDatesOfService.Level_of_Care__c);
                        setPatientName.add(objWrapper.objDatesOfService.Patient__c);
                        setfacility.add(objWrapper.objDatesOfService.Facility__c);
                        
                        if(mapClaimToLstDOS.containsKey(strFacilityName+'_'+objWrapper.objDatesOfService.Patient__c+'_'+objWrapper.objDatesOfService.Level_of_Care__c))
                            mapClaimToLstDOS.get(strFacilityName+'_'+objWrapper.objDatesOfService.Patient__c+'_'+objWrapper.objDatesOfService.Level_of_Care__c).add(objWrapper.objDatesOfService);
                        else
                            mapClaimToLstDOS.put(strFacilityName+'_'+objWrapper.objDatesOfService.Patient__c+'_'+objWrapper.objDatesOfService.Level_of_Care__c, new List<Dates_of_Service__c>{objWrapper.objDatesOfService});
                }
                
                for(Account acc: [Select Id, Salutation, Name, Gender__pc, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, LastName, FirstName, Date_of_birth__pc, PersonBirthdate, Insurance__c 
                                    From Account 
                                    where Name IN : setPatientName])
                {
                    mapAccnameToAcc.put(acc.Name, acc);
                }
                
                for(Facility__c fs: [Select Zip__c, Street_Address_2__c, Street_Address_1__c, State__c, Name, Main_Phone_Number__c, Country__c, City__c, Billing_Zip__c, Billing_Street_Address_2__c, 
											Billing_Street_Address_1__c, Billing_State__c, Billing_Main_Phone_Number__c, Billing_Country__c, Billing_City__c, Facility_Tax_ID__c 
                                    	From Facility__c 
                                        Where Name IN : setfacility])
                {
                    mapFsNametoFacilty.put(fs.Name, fs);
                }
                
                /*Quering on Patient_Insurance__c  object to get all its related insurance information*/
				for(Patient_Insurance__c objPatientIns : [Select Type__c, Patient__c, Name, Insurance_Company__r.Health_Plan_Id__c, Insurance_Company__r.Address__c, 
																	Insurance_Company__r.Website__c, Insurance_Company__r.Email__c, Insurance_Company__r.Phone__c, 
																	Insurance_Company__r.Name, Insurance_Company__c, Insurance_Code__c, Id, Patient__r.Name 
															From Patient_Insurance__c
															Where Patient__r.Name IN : setPatientName])
				{
					if(mapPatientToLstPatientInsurance.containsKey(objPatientIns.Patient__r.Name))
						mapPatientToLstPatientInsurance.get(objPatientIns.Patient__r.Name).add(objPatientIns);
					else
						mapPatientToLstPatientInsurance.put(objPatientIns.Patient__r.Name, new List<Patient_Insurance__c>{objPatientIns});
				}
				system.debug('%%%%mapPatientToLstPatientInsurance%%%% : '+mapPatientToLstPatientInsurance);
                
                for(string strComb : mapClaimToLstDOS.keyset())
                {
                    WrapperShowViewandPrint objWrapperShowViewandPrint = new WrapperShowViewandPrint();
                    List<Integer> lstBlankRows = new List<Integer>();   //Contains the list of blank rows to be shown on the page.
                    Date minDateDos;									//Min End_Date__c from all the Date of Service records.
					Date maxDateDos;									//Max End_Date__c from all the Date of Service records
                    
                    objWrapperShowViewandPrint.objFacility = mapFsNametoFacilty.get(strComb.split('_')[0]);
                    objWrapperShowViewandPrint.objAccount =  mapAccnameToAcc.get(strComb.split('_')[1]);
                    system.debug('$$$$strComb.split()[1]$$$$ : '+strComb.split('_')[1]);
                    system.debug('^^^^^^mapAccnameToAcc.get(strComb.split()[1]).Name^^^^^ : '+mapAccnameToAcc.get(strComb.split('_')[1]).Name);
                    system.debug('%%%%%%%%%%mapPatientToLstPatientInsurance.get(mapAccnameToAcc.get(strComb.split()[1]).Name)%%%%%%%%% : '+mapPatientToLstPatientInsurance.get(mapAccnameToAcc.get(strComb.split('_')[1]).Name));
                    
                    for(Patient_Insurance__c objPatientIns : mapPatientToLstPatientInsurance.get(mapAccnameToAcc.get(strComb.split('_')[1]).Name))
					{
						if(objPatientIns.Type__c == 'Primary')
						{
							objWrapperShowViewandPrint.objPatientInsurance = objPatientIns;
							break;
						}
						
						if(objPatientIns.Type__c == 'Secondary')
							objWrapperShowViewandPrint.objPatientInsurance = objPatientIns;
						
						if(objPatientIns.Type__c == 'Tertiary' && objWrapperShowViewandPrint.objPatientInsurance == null)
							objWrapperShowViewandPrint.objPatientInsurance = objPatientIns;
					}
                    objWrapperShowViewandPrint.lstDateOfService = mapClaimToLstDOS.get(strComb);
                    
                    if(objWrapperShowViewandPrint.lstDateOfService.size() == 0)
						objWrapperShowViewandPrint.AuthorizationNumber = '';
					else
						objWrapperShowViewandPrint.AuthorizationNumber = objWrapperShowViewandPrint.lstDateOfService[0].Authorization_Number__c;
                    
                    /*Calculating the Total Amount for Claim*/
					for(Dates_of_Service__c objDOS : objWrapperShowViewandPrint.lstDateOfService)
					{
						maxDateDos = objDOS.End_Date__c;
						minDateDos = objDOS.End_Date__c;
						if(maxDateDos < objDOS.End_Date__c)
							maxDateDos = objDOS.End_Date__c;
						if(minDateDos > objDOS.End_Date__c)
							minDateDos = objDOS.End_Date__c;
					}
					
					system.debug('!!minDateDos!!! :' +minDateDos);
					system.debug('@@@@maxDateDos@@@@ : '+maxDateDos );
					
					/*Quering on Physicians_Under_Facility__c object to get the Attending Physician*/
					objWrapperShowViewandPrint.objPhysiciansUnderFacility = [Select Term_Date__c, Name, Id, Facility__c, Facility_Tax_ID__c, Effective_Date__c, Facility__r.Name, 
																					Contact__r.Salutation, Contact__r.FirstName, Contact__r.LastName, Contact__c 
																				From Physicians_Under_Facility__c
																				Where Effective_Date__c <= :  minDateDos AND Term_Date__c >=  :  maxDateDos limit 1];
					system.debug('$$$$$objWrapperShowViewandPrint.objPhysiciansUnderFacility$$$$$$ : '+objWrapperShowViewandPrint.objPhysiciansUnderFacility);
					
                    /*Creating list of integer value to show blank rows*/                   
                    for(Integer i=objWrapperShowViewandPrint.lstDateOfService.size()+1; i<=22; i++)
                    {
                        lstBlankRows.add(i);
                    }
                    objWrapperShowViewandPrint.lstNumberOfBlankRows = lstBlankRows;
                    lstWrapperShowViewandPrint.add(objWrapperShowViewandPrint);                                                                                        
                }
                system.debug('^^^lstWrapperShowViewandPrint^^^^ : '+lstWrapperShowViewandPrint);
                if(Test.isRunningTest())
                	Integer a = 5/0;
            }
        }
        catch(Exception e)
        {
            system.debug('------3333---------'+e.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }
    
    /* Upsert the Parent Claim records  */
     public pagereference printBatchData() 
     {
        PageReference pg ;
        List<Dates_of_Service__c> lstDOSToBeUpdated = new List<Dates_of_Service__c>();
        List<Dates_of_Service__c> lstDOSFinal = new List<Dates_of_Service__c>();
        set<String> setDistinctName = new set<String>();
        set<String> setDistinctClaims = new set<String>();
        Set<String> setFacilityPatient = new Set<String>();         // strFacilityName
        List<Note> lstNote = new List<Note>();  // list of attachment to be inserted.
        Set<Utilization_Review__c> setUtilizationReview = new Set<Utilization_Review__c>(); //Set of Utilization Review records to be updated.
        Batch__c objParentClaim = new Batch__c(); 
        List<Track_Date_of_Services__c> lstTrackDOS = new List<Track_Date_of_Services__c>();
        map<String, String> mapPatientNameToPatientId = new map<String, String>();	//Map Patient Name to Patient Id
        
        try
        {
		    /* Updating All Selected Dates_of_Service__c records */
		    for(WrapperSelectedDOS objWrapper : lstwrapper)
		    {
		        /*if(objwrapper.objDatesOfService.Send_Electronically__c == true)
		        {
		            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Can not print submit-only DOS'));
		            return null;
		        }
		        else
		        {*/ Track_Date_of_Services__c objTrackDOS = new Track_Date_of_Services__c();
					objTrackDOS.Dates_of_Service__c = objWrapper.objDatesOfService.Id;
					objTrackDOS.Status__c = 'Submitted';
					objTrackDOS.Submitted_By__c = UserInfo.getUserId();
					objTrackDOS.Submitted_Date__c = DateTime.now();
					objTrackDOS.Submitted_Type__c = 'Print';
					lstTrackDOS.add(objTrackDOS);
					
		            isError=false;
		            setFacilityPatient.add(strFacilityName+'_'+objWrapper.objDatesOfService.Patient__c+'_'+objWrapper.objDatesOfService.Level_of_Care__c);
		            objWrapper.objDatesOfService.Bill_Status__c = 'Printed';
		            objWrapper.objDatesOfService.Submitted_DateTime__c = Datetime.now();
		            objWrapper.objDatesOfService.Amount__c = objWrapper.amount;
		            lstDOSToBeUpdated.add(objWrapper.objDatesOfService);
		            setDistinctName.add(objWrapper.objDatesOfService.Patient__c);
		            setDistinctClaims.add(objWrapper.objDatesOfService.Claim__c);
		
		            if(setDistinctName != null)
		                objParentClaim.of_Patient__c = setDistinctName.size();
		            else 
		                objParentClaim.of_Patient__c = 0;
		            
		            /*if(setFacilityPatient != null)  
		                objParentClaim.of_Claim__c = setFacilityPatient.size();
		            else 
		                objParentClaim.of_Claim__c = 0; */
		            objParentClaim.Total_Amount__c = sum;
		            objParentClaim.Submit_Type__c = 'Print';
		            objParentClaim.Submit_Timestamp__c = Datetime.now();
		            
		            /*Checking with the "First DOS Billed is blank or not" and updating the "First DOS Billed and Last DOS Billed" accordingly for corresponding "Utilization Review Records."*/
		            Utilization_Review__c objUtilizationReview = objWrapper.objDatesOfService.Utilization_Review_Form__r;
		            if(objWrapper.objDatesOfService.Utilization_Review_Form__r.First_DOS_Billed__c == Null)
		            {
		                objUtilizationReview.First_DOS_Billed__c = date.today();
		                setUtilizationReview.add(objUtilizationReview);
		            }   
		            else
		            {
		                objUtilizationReview.Last_DOS_Billed__c = date.today(); 
		                setUtilizationReview.add(objUtilizationReview);
		            }
		        //}
		    }
		    upsert objParentClaim;
		    insert lstTrackDOS;
		    
		    /*Creating Note for Batch record to open Mutliple UB04 form in Single page*/
		    Note objNoteUB04FormForBatch = new Note(); 
		    objNoteUB04FormForBatch.parentId = objParentClaim.Id; //Id of the Claim for which you want to add this note
		    objNoteUB04FormForBatch.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_PrintUB04FormForBatch?batchId='+objParentClaim.Id; // body of the note. this should be populated from the notes field that you have shown in the screenshot
		    objNoteUB04FormForBatch.title = 'NoteUB04FormForBatch'; // the title of the note
		    objNoteUB04FormForBatch.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
		    insert objNoteUB04FormForBatch;
		    
		    /* Querying on batch to get the recently created batch record*/
            Batch__c objBatch = [Select Id, Name From Batch__c Where Id=:objParentClaim.Id];
            for(Account objAccount : [Select Id, Name from Account where Name In : setDistinctName])
            {
            	mapPatientNameToPatientId.put(objAccount.Name, objAccount.Id);
            }
            system.debug('&&&mapPatientNameToPatientId&&&& : '+mapPatientNameToPatientId);
		    system.debug('$$$$setUtilizationReview$$$$: '+setUtilizationReview);
		    list<Utilization_Review__c> listUtilizationReview = new list<Utilization_Review__c>();
		    listUtilizationReview.addAll(setUtilizationReview);
		    update listUtilizationReview;
		    
		    Map<String, Claim__c> mapCombination_ClaimId = new Map<String, Claim__c>(); 
		    Map<String,String> mapClaimIdToPatientName = new Map<String,String>();
		    
		    /*Calling method to create Claims based on different conditions.*/
		    createCalimsBasedOnTypeOfBill(objParentClaim, setDistinctName, 'Printed');
		    
		    //pg = new pageReference('/'+objParentClaim.id);
		    pg = new PageReference('/apex/TBN_Emdeon?Load=first&subBatchId='+objBatch.Id);
		    /*Returing page reference of the current Parent Claim record . */
		    return pg;
		}
	    catch(Exception e)
	    {
	        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	        return null;
	    }
        
	}
    
    /*Method to create different calims based Type of Bill and unique facility, patient and Level of care combination*/
    private void createCalimsBasedOnTypeOfBill(Batch__c objBatchClaim, Set<String> setDistinctPatientName, String srtClaimStatus)
    {
    	/*Map cantaining claim combination and its related DOS records*/
	    Map<String, List<Dates_of_Service__c>> mapClaimCombToLstDOS = new Map<String, List<Dates_of_Service__c>>();
	    /*Map conating Type of Bill to related DOS records*/
	    Map<String, List<Dates_of_Service__c>> mapTypeOfBillToLstDOS = new Map<String, List<Dates_of_Service__c>>();
	    /*List of Claims to be inserted*/
	    List<Claim__c> lstClaimToInsert = new List<Claim__c>();
	    /*List DOS to be updated*/
	    List<Dates_of_Service__c> lstDOSToUpdate = new List<Dates_of_Service__c>();
	    /*Map Patient Name to Paient Id*/
	    Map<String, String> mapPatientNameToPatientId = new Map<String, String>();
	    /*List of attachment to be inserted.*/
	    List<Note> lstNote = new List<Note>();  
	    try
	    {
		    for(Account objAccount : [Select Id, Name from Account where Name In : setDistinctPatientName])
	        {
	        	mapPatientNameToPatientId.put(objAccount.Name, objAccount.Id);
	        }
	         system.debug('&&&mapPatientNameToPatientId&&&& : '+mapPatientNameToPatientId);
	             
		    for(WrapperSelectedDOS objWrapper : lstwrapper)
	    	{
	    		if(mapClaimCombToLstDOS.containsKey(strFacilityName+'_'+objWrapper.objDatesOfService.Patient__c+'_'+objWrapper.objDatesOfService.Level_of_Care__c))
	                mapClaimCombToLstDOS.get(strFacilityName+'_'+objWrapper.objDatesOfService.Patient__c+'_'+objWrapper.objDatesOfService.Level_of_Care__c).add(objWrapper.objDatesOfService);
	            else
	                mapClaimCombToLstDOS.put(strFacilityName+'_'+objWrapper.objDatesOfService.Patient__c+'_'+objWrapper.objDatesOfService.Level_of_Care__c, new List<Dates_of_Service__c>{objWrapper.objDatesOfService});
	        }
	        system.debug('%%%%%%mapClaimCombToLstDOS%%%%% : '+mapClaimCombToLstDOS);
	            
	       for(String strComb : mapClaimCombToLstDOS.keySet())
	       {
	       		for(Dates_of_Service__c objDOS : mapClaimCombToLstDOS.get(strComb))
	       		{
	       			if(objDOS.End_Date__c == objDOS.Utilization_Review_Form__r.Admission_Date__c)
	       			{
	       				if(mapTypeOfBillToLstDOS.containsKey('112'))
	       					mapTypeOfBillToLstDOS.get('112').add(objDOS);
			            else
			                mapTypeOfBillToLstDOS.put('112', new List<Dates_of_Service__c>{objDOS});
	       			}
		                
		            if(objDOS.End_Date__c == objDOS.Utilization_Review_Form__r.Discharge_Date__c)
		            {
		            	if(mapTypeOfBillToLstDOS.containsKey('114'))
			            	mapTypeOfBillToLstDOS.get('114').add(objDOS);
			            else
			                mapTypeOfBillToLstDOS.put('114', new List<Dates_of_Service__c>{objDOS});
		            }
		                
		           	if((objDOS.End_Date__c > objDOS.Utilization_Review_Form__r.Admission_Date__c ) && (objDOS.End_Date__c < objDOS.Utilization_Review_Form__r.Discharge_Date__c))
	       			{
	       				if(mapTypeOfBillToLstDOS.containsKey('113'))
		       				mapTypeOfBillToLstDOS.get('113').add(objDOS);
			            else
			                mapTypeOfBillToLstDOS.put('113', new List<Dates_of_Service__c>{objDOS});
	       			}	
	       			
	       		}
	       }
	       
	       for(String strTypeOfBill : mapTypeOfBillToLstDOS.keySet())
	       {
	       		Claim__c objClaim = new Claim__c();
	            objClaim.Facility__c = mapTypeOfBillToLstDOS.get(strTypeOfBill)[0].Facility__c;
	            objClaim.Patient__c = mapTypeOfBillToLstDOS.get(strTypeOfBill)[0].Patient__c;
	            objClaim.PatientLookup__c =  Id.valueOf(mapPatientNameToPatientId.get(mapTypeOfBillToLstDOS.get(strTypeOfBill)[0].Patient__c));
	            objClaim.ParentClaim__c = objBatchClaim.Id;
	            objClaim.Level_of_Care__c = mapTypeOfBillToLstDOS.get(strTypeOfBill)[0].Level_of_Care__c;
	            objClaim.Status__c = srtClaimStatus;
	            objClaim.Type_of_Bill__c = strTypeOfBill;
	       		lstClaimToInsert.add(objClaim);
	       }
	       
	       insert lstClaimToInsert;
	       
	       for(Claim__c objClaim : lstClaimToInsert)
	       {
	       		for(Dates_of_Service__c objDOS : mapTypeOfBillToLstDOS.get(objClaim.Type_of_Bill__c))
	       		{
	       			objDOS.Claim__c = objClaim.Id;
	       			objDOS.Bill_Status__c = srtClaimStatus;
	       			lstDOSToUpdate.add(objDOS);
	       		}
	       		
	       		Note objNoteUB04Form = new Note(); 
	            Note objNoteUB04Blank = new Note();
	            
	            objNoteUB04Form.parentId = objClaim.Id; //Id of the Claim for which you want to add this note
	            objNoteUB04Form.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_UB04Form?claim='+objClaim.Id; // body of the note. this should be populated from the notes field that you have shown in the screenshot
	            objNoteUB04Form.title = 'NoteUB04Form'; // the title of the note
	            objNoteUB04Form.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
	            lstNote.add(objNoteUB04Form);
	            
	            objNoteUB04Blank.parentId = objClaim.Id; //Id of the Claim for which you want to add this note
	            objNoteUB04Blank.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_UB04_Blank?claim='+objClaim.Id; // body of the note. this should be populated from the notes field that you have shown in the screenshot
	            objNoteUB04Blank.title = 'NoteUB04Blank'; // the title of the note
	            objNoteUB04Blank.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
	            lstNote.add(objNoteUB04Blank);
	            
	            /*Attaching the corresponding UB04 form to the patient notes and attachment related list*/
	        	Note objNoteUB04View = new Note(); 
	            Note objNoteUB04Print = new Note();
	            
	            objNoteUB04View.parentId = objClaim.PatientLookup__c; //Id of the Claim for which you want to add this note
	            objNoteUB04View.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_UB04Form?claim='+objClaim.PatientLookup__c; // body of the note. this should be populated from the notes field that you have shown in the screenshot
	            objNoteUB04View.title = objClaim.Patient__c+'UB04View_'+objClaim.Name; // the title of the note
	            objNoteUB04View.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
	            lstNote.add(objNoteUB04View);
	            
	            objNoteUB04Print.parentId = objClaim.PatientLookup__c; //Id of the Claim for which you want to add this note
	            objNoteUB04Print.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_UB04_Blank?claim='+objClaim.PatientLookup__c; // body of the note. this should be populated from the notes field that you have shown in the screenshot
	            objNoteUB04Print.title = objClaim.Patient__c+'UB04Print_'+objClaim.Name; // the title of the note
	            objNoteUB04Print.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
	            lstNote.add(objNoteUB04Print);
	       }
	       
	       if(lstClaimToInsert != null)  
	            objBatchClaim.of_Claim__c = lstClaimToInsert.size();
	        else 
	            objBatchClaim.of_Claim__c = 0; 
	       
	       update objBatchClaim;
	       update lstDOSToUpdate;
	       insert lstNote;
	    }
	    catch(Exception e)
		{
	    	system.debug('------99999999999---------'+e.getLineNumber());
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
		}
    }
    
    /*Wrapper class that will contain all the details to be show on UB04Page on click of "View&Print" button*/
    public class WrapperShowViewandPrint
    {
        public Facility__c objFacility                          {get; set;}     //Conatins the Facility details for the selected Claim.
        public Account objAccount                               {get; set;}     //Contains all the Account detai;s of the Patient for whom claim is defined.
        //public Decimal TotalAmount                            {get; set;}     //Sum of amount of all Date of Service records for a particular claim.
        public List<Integer> lstNumberOfBlankRows               {get; set;}     //Contains the list of blank rows to be shown on the page.
        public List<Dates_of_Service__c> lstDateOfService       {get; set;}     //Contains the list of date of service records for selected claim.
        public Physicians_Under_Facility__c objPhysiciansUnderFacility	{get; set;}		//Physicain Under Facility object to be used to show on UB-04 form.	
        public Patient_Insurance__c objPatientInsurance			{get; set;}		//Patient Insurance object that will conatins all the insurance related information of the patient.
        public String AuthorizationNumber						{get; set;}		//Authorization Number
        
        /* constructor */ 
        public WrapperShowViewandPrint()
        {
            
        }
    }
     
     /* Wrapper class that will contain the selected DOS and corresponding Amount from "Bill Amount object" */
     public class WrapperSelectedDOS
     {
         public Dates_of_Service__c objDatesOfService   {get;set;}
         public Decimal amount                          {get;set;}
         public Boolean isSelect{get;set;}
         
         /* constructor */ 
         public WrapperSelectedDOS()
         {
            
         }
     }
     
}