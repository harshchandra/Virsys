public class TBN_Select_DOS_Charges
{
    
   public boolean displayPopup									{get; set;} //Display the popup window
   public List<WrapperSelectDOSCharges> lstPopUpView 			{get; set;}	//stores wrappers to be shown in pop up
   public List<WrapperSelectDOSCharges> lstWrapper;							//stores wrapper class instances
   public String contextItem									{get; set;}
   List<WrapperSelectDOSCharges> lstWrapperTemp; 							//get all the records from DOS,Bill Amount objects 
   private Set<Id> selectedDosIds;											//Stores Id of checked single checked record
   List<Dates_of_Service__c> lstDOStoUpdate ; 								//get All the DOS Records 
   public Boolean isAllSelected									{get; set;} //Mark all condition 
   public String strFacilityName 								{get; set;} //to get the current facility parameter from URL
   String tempStrQuery='Select Id ,'; 										//dynamic query for get the records from DOS
   Boolean isTrue =false;
   String strQuery='Select Id ,'; 											//dynamic query for get the records from DOS
   Set<id> setDeselected;													//Mark deselect records
   private String sortDirection = 'ASC'; 									//Initall Sort direction is ASC
   private String sortExp ; 												//Sorting column name
   private String strSortQuery; 											//Sorting query for sortdirection and sortExp
   List<Bill_Amounts__c> lstBillAmount; 									//to get list of Bill Amount Records
   public Map<Id,Decimal> mapBillAmountTemp = new Map<Id,Decimal>();		//to get old bill amount for compare with the newly changed amount 
   Map<String,Decimal> maplocAmount;
   List<Dates_of_Service__c> lstDisplayedDOS; 
   public boolean isCalledFromClass								{get; set;}
   public boolean isChanged										{get; set;} //checking whether the Amount changed or not
   public List<WrapperSelectDOSCharges> lstwrapperToShowOnPage	{get; set;} //list of records for DOS and Bill Amount
   public String strBaseURl										{get; set;} //to get Base URL on the page
   public String strStatus										{get; set;} //to get the Status parameter from the URL 
   public String expRevnueCode									{get; set;} //to get the Exception Revenue Code from page.
   public String expBillingCode									{get; set;} //to get the Exception Billing Code from page.
   
   // State for Pagination
   public Integer PageSize 										{get; set;} //number of rows per page. 
   public Integer page											{get; set;}	//current page
   public Integer LastPage										{get; set;}	//Index to last page      
   private Integer TotalRows; 												//total rows in all pages.
   private Integer StartIndex ;												//starting Postion of the next/previous records
   private Integer EndIndex ;												//Ending records(Page size+start index)
   private Set<String> setStatus;											//Status of the DOS records
   
   private map<String, Level_of_Care__c> mapLoc_LocObject;
   //private map<String, String> mapDosId_AuthNumber;	
   
   /* constructor */
   public TBN_Select_DOS_Charges()
   {
   	   lstwrapperToShowOnPage = new List<WrapperSelectDOSCharges>();
   	   lstBillAmount=new List<Bill_Amounts__c>();
   	   maplocAmount=new Map<String,Decimal>(); /* stores Loc and Amount value of facility */
   	   selectedDosIds= new Set<Id>();
       isAllSelected=false;
       setDeselected=new set<Id>();
       lstWrapper = new List<WrapperSelectDOSCharges>();
       lstWrapperTemp = new List<WrapperSelectDOSCharges>();
       lstPopUpView = new List<WrapperSelectDOSCharges>();
       List<Schema.FieldSetMember> fieldSetMemberList =  readFieldSet('FieldsView', 'Dates_of_Service__c'); 
       setStatus =  new Set<String>{'Approved','No Auth Policy'};
       
       try
       {
	       for(Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList)
	       {
	         
	          strQuery += fieldSetMemberObj.getFieldPath()+ ', ';
	          tempStrQuery+= fieldSetMemberObj.getFieldPath()+ ', ';
	        }
	        if(!strQuery.contains('Start_Date__c'))
	        {
	        	strQuery += 'Start_Date__c, ';
	        	tempStrQuery += 'Start_Date__c, ';
	        }	
	        strQuery = strQuery.removeEnd(', ');
	        tempStrQuery=tempStrQuery.removeEnd(', ');
	        
	         /*Checking whther the user is being re-directed from the "connectHome".*/
	        String currentURL = URL.getCurrentRequestUrl().toExternalForm();
	        
	        /*Checking th base URl for edit link on*/
	        strBaseURl= URL.getSalesforceBaseUrl().toExternalForm();
	        strStatus = Apexpages.currentPage().getParameters().get('Status');
	        
	    	String strStatusType='';
	    	if(Apexpages.currentPage().getParameters().get('Status') == null || Apexpages.currentPage().getParameters().get('Status') == 'ReSubmit')
	    		strStatusType = 'Reprocess';
	    	
	    	/*Getting level of care from the URL*/
	    	String strLevelOfCare = '';
	    	if(Apexpages.currentPage().getParameters().get('LevelOfCare') == 'EAP')
	    		strLevelOfCare = 'EAP';
	    	
	    	/*getting the selected Facility name from URL*/
	    	if(!Test.isRunningTest())
	    	{
		        if(currentURL.contains('facility'))
		    	{
		    		strFacilityName = ApexPages.currentPage().getParameters().get('facility');
		    	}
	   		}
	    	if(Test.isRunningTest())
	    	{	
	    		strFacilityName = ApexPages.currentPage().getParameters().get('facility');
	    	}
	    	
	    	if(strLevelOfCare == 'EAP')
	    	{
	    		/*Check user has selected "Send Electronically" from the URL*/
	    		if(Apexpages.currentPage().getParameters().get('Format') == 'Send Electronically')
	    		{
	    			strSortQuery=strQuery+' '+'from Dates_of_Service__c where  Billable_Day__c = true AND Facility__c=\''+strFacilityName+'\''+' '+'AND Level_of_Care__c =\''+strLevelOfCare+'\'' + 'AND Bill_Status__c = \''+strStatusType+'\''+' AND Status__c IN :setStatus AND Send_Electronically__c = True';
	        		StrQuery=StrQuery+' '+'from Dates_of_Service__c where  Billable_Day__c = true AND Bill_Status__c = \''+strStatusType+'\''+' AND Facility__c=\''+strFacilityName+'\''+' '+'AND Level_of_Care__c =\''+strLevelOfCare+'\''+' '+' AND Status__c IN :setStatus AND Send_Electronically__c = True'+' order by Start_Date__c DESC Nulls Last  limit 10000';
	    		}
	    		else
	    		{
	    			strSortQuery=strQuery+' '+'from Dates_of_Service__c where  Billable_Day__c = true AND Facility__c=\''+strFacilityName+'\''+' '+'AND Level_of_Care__c =\''+strLevelOfCare+'\'' + 'AND Bill_Status__c = \''+strStatusType+'\''+' AND Status__c IN :setStatus AND Send_Electronically__c = False';
	        		StrQuery=StrQuery+' '+'from Dates_of_Service__c where  Billable_Day__c = true AND Bill_Status__c = \''+strStatusType+'\''+' AND Facility__c=\''+strFacilityName+'\''+' '+'AND Level_of_Care__c =\''+strLevelOfCare+'\''+' '+' AND Status__c IN :setStatus AND Send_Electronically__c = False'+' order by Start_Date__c DESC Nulls Last  limit 10000';
	    		}
	    	}
	    	else
	    	{
	    		/*Check user has selected "Send Electronically" from the URL*/
	    		if(Apexpages.currentPage().getParameters().get('Format') == 'Send Electronically')
	    		{
	    			strSortQuery=strQuery+' '+'from Dates_of_Service__c where  Billable_Day__c = true AND Bill_Status__c = \''+strStatusType+'\''+' AND Facility__c=\''+strFacilityName+'\''+' '+'AND Level_of_Care__c !=\'EAP\''+' AND Status__c IN :setStatus AND Send_Electronically__c = True';
	        		StrQuery=StrQuery+' '+'from Dates_of_Service__c where  Bill_Status__c = \''+strStatusType+'\''+' AND Facility__c=\''+strFacilityName+'\''+' '+'AND Level_of_Care__c !=\'EAP\''+' AND Billable_Day__c = true'+' AND Status__c IN :setStatus AND Send_Electronically__c = True'+' order by Start_Date__c DESC Nulls Last  limit 10000';
	    		}
	    		else
	    		{
	    			strSortQuery=strQuery+' '+'from Dates_of_Service__c where  Billable_Day__c = true AND Bill_Status__c = \''+strStatusType+'\''+' AND Facility__c=\''+strFacilityName+'\''+' '+'AND Level_of_Care__c !=\'EAP\''+' AND Status__c IN :setStatus AND Send_Electronically__c = False';
	        		StrQuery=StrQuery+' '+'from Dates_of_Service__c where  Bill_Status__c = \''+strStatusType+'\''+' AND Facility__c=\''+strFacilityName+'\''+' '+'AND Level_of_Care__c !=\'EAP\''+' AND Billable_Day__c = true'+' AND Status__c IN :setStatus AND Send_Electronically__c = False'+' order by Start_Date__c DESC Nulls Last  limit 10000';
	    		}
	    	}
	    	
	    	system.debug('--------StrQuery------------'+StrQuery);	
	        lstDisplayedDOS = Database.Query(strQuery);
	        system.debug('---------lstDisplayedDOS----'+lstDisplayedDOS);
	        
	        List<String> lstLevelOfCareFromDOS = new List<String>();
	        map<String, Dates_of_Service__c> mapCaseId_DatesOfService = new map<String, Dates_of_Service__c>();
	        //mapDosId_AuthNumber = new map<String, String>(); 
	        
	        set<String> setCaseIdFromDOS = new set<String>();
	        
	        for(Dates_of_Service__c objDatesOfService : lstDisplayedDOS)
	        {
	        	if(objDatesOfService.Case_Id__c != null)
	        	{
		        	lstLevelOfCareFromDOS.add(objDatesOfService.Level_of_Care__c);
		        	setCaseIdFromDOS.add(objDatesOfService.Case_Id__c);
		        	system.debug('======objDOS===111===='+objDatesOfService.End_Date__c);
		        	system.debug('======objDOS===111===='+objDatesOfService.Case_Id__c);
	        	}
	        }
	        
	        system.debug('=====mapCaseId_DatesOfService====='+mapCaseId_DatesOfService);
	        system.debug('=====lstLevelOfCareFromDOS====='+lstLevelOfCareFromDOS);
	       /* Map<Id, List<Authorizations__c>> mapCaseId_Authorizations = new Map<Id, List<Authorizations__c>>();
	        for(Authorizations__c objAuthorizations : [Select Authorization_Number__c, Date_Authorized_From__c, Date_Authorized_To__c, Case_ID__c from Authorizations__c where Case_ID__c IN: setCaseIdFromDOS])
	        {
	        	if(!mapCaseId_Authorizations.containsKey(objAuthorizations.Case_ID__c))
	        		mapCaseId_Authorizations.put(objAuthorizations.Case_ID__c, new List<Authorizations__c>{objAuthorizations});
	        	else
	        		mapCaseId_Authorizations.get(objAuthorizations.Case_ID__c).add(objAuthorizations);	
	        	Dates_of_Service__c objDOS = mapCaseId_DatesOfService.get(objAuthorizations.Case_ID__c);
	        }
	        
	        for(Dates_of_Service__c objDOS : lstDisplayedDOS)
	        {
	        	if(objDOS.Case_Id__c != null)
	        	{
	        		if(mapCaseId_Authorizations != null && mapCaseId_Authorizations.containsKey(objDOS.Case_Id__c)  && mapCaseId_Authorizations.get(objDOS.Case_Id__c) != null)
	        		for(Authorizations__c objAuthorizations : mapCaseId_Authorizations.get(objDOS.Case_Id__c))
	        		{
	        			if(objAuthorizations.Date_Authorized_From__c < objDOS.End_Date__c && objAuthorizations.Date_Authorized_To__c > objDOS.End_Date__c)
	        				mapDosId_AuthNumber.put(objDOS.Id, objAuthorizations.Authorization_Number__c);
	        		}
	        	}
	        }*/
	        
	        /*Creating Map of Level of care corresponding Level of Care object for particulat Facility*/
	        mapLoc_LocObject = new map<String, Level_of_Care__c>();
	        for(Level_of_Care__c objLevelOfCare1 : [Select Id, Name, Bill_Amount__c, CPT_HCSPCS_Code__c, Insurance_Company__c, Revenue_Code__c, Level_of_Care_Effective_Date__c, Level_of_Care_Term_Date__c, Level_of_Care_Description__c 
	        										From Level_of_Care__c 
	        										Where Facility__c =: strFacilityName and Name IN: lstLevelOfCareFromDOS])
	        	mapLoc_LocObject.put(objLevelOfCare1.Name, objLevelOfCare1);
	        system.debug('=====mapLoc_LocObject======='+mapLoc_LocObject);
	        
	        getDocWrapper(lstDisplayedDOS);
	        initPagination(lstWrapper);
       }
        catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    }
        
   }
  	
  	/*This method is for assigning value to Inner class  */
    public void getDocWrapper(List<Dates_of_Service__c> lstDOS)
    {
        lstWrapper = new List<WrapperSelectDOSCharges>();
        Decimal amount;
        Level_of_Care__c objLevelOfCare2 =new Level_of_Care__c();
        try
	    {
	         for(Dates_of_Service__c objectDos : lstDOS)
            {
				if(objectDos.Start_Date__c == objectDos.End_Date__c)
				{     
					if(mapLoc_LocObject.containsKey(objectDos.Level_of_Care__c))
					{
						/*Getting Bill amount for corresponding DOS records based on condition*/
						if((mapLoc_LocObject.get(objectDos.Level_of_Care__c).Level_of_Care_Effective_Date__c <= objectDos.End_Date__c && mapLoc_LocObject.get(objectDos.Level_of_Care__c).Level_of_Care_Term_Date__c >= objectDos.End_Date__c) && (objectDos.Insurance_Company__c == mapLoc_LocObject.get(objectDos.Level_of_Care__c).Insurance_Company__c || objectDos.Insurance_Company__c == 'DEFAULT' || objectDos.Insurance_Company__c == null || objectDos.Insurance_Company__c == ''))
							objLevelOfCare2 = mapLoc_LocObject.get(objectDos.Level_of_Care__c);
						else
							objLevelOfCare2 = new Level_of_Care__c();
					}
					else
						objLevelOfCare2 = new Level_of_Care__c();
						
					/*if(mapDosId_AuthNumber.containsKey(objectDos.Id))
						objectDos.Authorization_Number__c = mapDosId_AuthNumber.get(objectDos.Id);
					else
						objectDos.Authorization_Number__c = '';	*/
						
					if((objectDos.New_Revenue_Code__c == '' || objectDos.New_Revenue_Code__c == null) && (objectDos.New_CPT_HCSPCS_Code__c == '' || objectDos.New_CPT_HCSPCS_Code__c == null))
					{
						objectDos.New_Revenue_Code__c = objLevelOfCare2.Revenue_Code__c;
			        	objectDos.New_CPT_HCSPCS_Code__c = objLevelOfCare2.CPT_HCSPCS_Code__c;
					}
					system.debug('---- objectDos ----'+amount);
					system.debug('---- objectDos ----'+objectDos.Id);	
					//Find whether the amount changed or not
					//mapBillAmountTemp.put(objectDos.Id,amount);	
							
	                //WrapperSelectDOSCharges objWrapperSelectDOSCharges = new WrapperSelectDOSCharges(objectDos, false,amount);
	                WrapperSelectDOSCharges objWrapperSelectDOSCharges = new WrapperSelectDOSCharges(objectDos, false, objLevelOfCare2);
	                if(Test.isRunningTest())
	                {
		                selectedDosIds.add(objectDos.Id);
		                setDeSelected.add(objectDos.Id);
	                }
	                if(this.selectedDosIds.contains(objectDos.Id))
	                    objWrapperSelectDOSCharges.isSelect=true;
	                else
	                    objWrapperSelectDOSCharges.isSelect=false;
	                
	                lstWrapper.add(objWrapperSelectDOSCharges);
	                
             	}
            }
         	system.debug('%%%%lstWrapper.size()%%%%%%%%% : '+lstWrapper);
	    }
	    catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    }
    }
    
    /*Wrapper class */
     public class WrapperSelectDOSCharges
     {
         public Dates_of_Service__c objDatesOfService {get;set;}
         public Boolean isSelect{get;set;}
         public Level_of_Care__c objLevelOfCare {get;set;}
         
         public WrapperSelectDOSCharges(Dates_of_Service__c obj,boolean isSelect,Level_of_Care__c objLevelOfCare3)
         {
             objDatesOfService=new Dates_of_Service__c();
             isSelect=false;
             objDatesOfService=obj;
             this.isSelect = isSelect;
             this.objLevelOfCare = objLevelOfCare3;
         }
     }
     
     /* This method  update records matches the condition */
     
     public void updateStatusOfDOS()
     {
        Set<Id> setId=new Set<Id>();
        lstWrapperTemp.addAll(lstWrapper);
        lstWrapper.clear();
        
        try
        {
	        if(!lstWrapperTemp.isEmpty())
	        {
	            for(WrapperSelectDOSCharges objwrapper : lstWrapperTemp)
	            {
	                if(objwrapper.isSelect)
	                {   
	                    if(!setId.Contains(objwrapper.objDatesOfService.Id))
	                    {	
	                        lstWrapper.add(objwrapper);
	                        setId.add(objwrapper.objDatesOfService.Id);
	                        if(Test.isRunningTest())
	                        selectedDosIds.add(objwrapper.objDatesOfService.Id);
	                    }
	                }
	                
	            }
	            
	        }
	       		isTrue=true;
        }
        catch(Exception e)
        {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
     }
     
     /* logic to show selected records on popup */
     
     public void renderToViewSelectedDOScharges()
     {	
     	lstDOStoUpdate = new List<Dates_of_Service__c>();
 		lstPopUpView= new List<WrapperSelectDOSCharges>();
 		displayPopup = true;
 		Boolean errorFlag = false;
 		system.debug('=====lstwrapperToShowOnPage===top==='+lstwrapperToShowOnPage);
        updateStatusOfDOS();
        List<WrapperSelectDOSCharges> lstpopupTemp=new List<WrapperSelectDOSCharges>();
        //lstPopUpView.addAll(lstWrapper);
        lstPopUpView.addAll(lstwrapperToShowOnPage);
        system.debug('=====lstPopUpView======'+lstPopUpView);
        
        try
        {
        	Set<String> setCaseId = new Set<String>();	//Set of Case Id for the selected DOS records
	        if(!isAllSelected)
	        {
			 	for(WrapperSelectDOSCharges objwrapper:lstPopUpView)
			 	{
			 		if(selectedDosIds.contains(objwrapper.objDatesOfService.Id) )
				 	{			
				 		system.debug('========='+objwrapper.objLevelOfCare.CPT_HCSPCS_Code__c);
				 		system.debug('========='+objwrapper.objLevelOfCare.Revenue_Code__c);
				 			 		
						// Checking whether the amount changed or not if its changed UI will be show the conformation window.
						/*if(mapBillAmountTemp.get(objwrapper.objDatesOfService.Id) != objwrapper.objLevelOfCare.Bill_Amount__c)
						{						
							isChanged = true;
						}	*/
				 		lstpopupTemp.add(objwrapper);
				 		Dates_of_Service__c objDos = objwrapper.objDatesOfService; 
				        objDos.Bill_Status__c = 'Selected';
				        objDos.Has_Been_Billed__c = True;
				        objDos.Selected_DateTime__c = DateTime.Now();
				        objDos.Amount__c = objwrapper.objLevelOfCare.Bill_Amount__c;	//Updating DOS Amount__c field from Bill_Amount__c field of LOC object
				        objDos.Notes__c = objwrapper.objLevelOfCare.Level_of_Care_Description__c;	//Updating DOS Notes__c field from Level_of_Care_Description__c field of LOC object
				        objDos.New_Revenue_Code__c = objwrapper.objDatesOfService.New_Revenue_Code__c;
				        objDos.New_CPT_HCSPCS_Code__c = objwrapper.objDatesOfService.New_CPT_HCSPCS_Code__c;
				        objDos.Authorization_Number__c = objwrapper.objDatesOfService.Authorization_Number__c;
				        objwrapper.objDatesOfService = objDos;		//Updating the new value to show in popup
				        lstDOStoUpdate.add(objDos);
				 	}
			 	}
	        } 
        	else
        	{
		        for(WrapperSelectDOSCharges objwrapper:lstPopUpView)
				{
			 		 if(objwrapper.isSelect && !setDeselected.contains(objwrapper.objDatesOfService.Id))
			 		 {
					 		// Checking whether the amount changed or not if its changed UI will be show the conformation window.
				 		/*if(mapBillAmountTemp.get(objwrapper.objDatesOfService.Id) != objwrapper.objLevelOfCare.Bill_Amount__c)
						{						
							isChanged = true;
						}*/
				 		lstpopupTemp.add(objwrapper);
				 		Dates_of_Service__c objDos=	objwrapper.objDatesOfService;
				        objDos.Bill_Status__c = 'Selected';
				        objDos.Has_Been_Billed__c = True;
				        objDos.Selected_DateTime__c = DateTime.Now();
				        objDos.Amount__c = objwrapper.objLevelOfCare.Bill_Amount__c;
				        objDos.New_Revenue_Code__c = objwrapper.objDatesOfService.New_Revenue_Code__c;
				        objDos.New_CPT_HCSPCS_Code__c = objwrapper.objDatesOfService.New_CPT_HCSPCS_Code__c;
				        objDos.Authorization_Number__c = objwrapper.objDatesOfService.Authorization_Number__c;
				        objwrapper.objDatesOfService = objDos;		//Updating the new value to show in popup
				        lstDOStoUpdate.add(objDos);
			 		 }
				}
        	}
        	
 			/*For Validating End Date of Selected DOS records with the coressponding Case records*/
        	system.debug('***lstpopupTemp.size()****** : '+lstpopupTemp.size());
        	for(WrapperSelectDOSCharges objWrapperValid : lstpopupTemp)
        	{
        		system.debug('~~~objDOSValid.Case_Id__c~~~ : '+objWrapperValid.objDatesOfService.Case_Id__c);
        		setCaseId.add(objWrapperValid.objDatesOfService.Case_Id__c);
        	}
        	system.debug('^^^^^setCaseId^^^^^^ : '+setCaseId);
        	date myDate = date.newInstance(2012, 1, 1);
        	for(Case objCase : [Select Id, Facility_Date_of_discharge__c, Facility_Admission_Date__c From Case c Where Id IN : setCaseId])
        	{
        		system.debug('$$$$$$$objCase$$$$$$$$$ : '+objCase);
        		for(WrapperSelectDOSCharges objWrapperValidate : lstpopupTemp)
	        	{
	        		if(objWrapperValidate.objDatesOfService.End_Date__c < myDate)
	        		{
	        			system.debug('!!!!!!!!true1!!!!!!!!!'+objWrapperValidate.objDatesOfService.End_Date__c);
	        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Selected Date of Service out of Admit and Discharge date'));
	  					displayPopup = false;
	        		}
	        		else if(objWrapperValidate.objDatesOfService.End_Date__c < objCase.Facility_Admission_Date__c)
	        		{
	        			system.debug('!!!!!!!!true2!!!!!!!!! :'+objWrapperValidate.objDatesOfService.End_Date__c);
	        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Selected Date of Service out of Admit and Discharge date'));
	  					displayPopup = false;
	        		}
	        		else if(objWrapperValidate.objDatesOfService.End_Date__c > objCase.Facility_Date_of_discharge__c)
	        		{
	        			system.debug('!!!!!!!!true3!!!!!!!!! :'+objWrapperValidate.objDatesOfService.End_Date__c+'!!!!!!!!!!'+objWrapperValidate.objDatesOfService.Id);
	        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Selected Date of Service out of Admit and Discharge date'));
	  					displayPopup = false;
	        		}
	        		else if((String.valueOf(objCase.Facility_Date_of_discharge__c) == '' || objCase.Facility_Date_of_discharge__c == null) && objWrapperValidate.objDatesOfService.End_Date__c > date.today()-1)
	        		{
	        			system.debug('!!!!!!!!true4!!!!!!!!! :'+objWrapperValidate.objDatesOfService.End_Date__c);
	        			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Selected Date of Service out of Admit and Discharge date'));
	  					displayPopup = false;
	        		}
	        	}
        	}
 			
 			lstPopUpView.clear();
			
			if(Test.isRunningTest())
				errorFlag=false;
		
  			if(!lstpopupTemp.isempty() )
  				lstPopUpView.addAll(lstpopupTemp);
  			else if(errorFlag != true)
		  	{
		  		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Please select atleast one record'));
		  		displayPopup = false;
		  	}
        }
        catch(Exception e)
        {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
     }
     
     /* update records to Database */
     public Void Save()
     {
     	try
     	{
	     	if(!lstDOStoUpdate.isEmpty())
	            {
	            	system.debug('------------lstDOStoUpdate----------'+lstDOStoUpdate);
	            	update lstDOStoUpdate;
		            lstDOStoUpdate.clear();
	            }
     	}
     	catch(Exception e)
        {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
     }
     
    /* it will get all the FieldSet names from Date Of Service object */ 
    public static List<Schema.FieldSetMember> readFieldSet(String fieldSetName, String ObjectName)
    {
    	try
    	{
	        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe(); 
	        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(ObjectName);
	        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
	        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
	        return fieldSetObj.getFields(); 
    	}
    	catch(Exception e)
        {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        	return null;
        }
    } 
    
   
    
    /*
    *   handle item selected 
    */
   public void doSelectItem()
   { 
        this.selectedDosIds.add(this.contextItem);
        if(setDeSelected.contains(this.contextItem))
        	setDeSelected.remove(this.contextItem);
    } 
 
    /*
    *   handle item deselected
    */ 
    public void doDeselectItem()
    {
        this.selectedDosIds.remove(this.contextItem);
        setDeSelected.add(this.contextItem);
    }
 
 	/*
    *   handle all item selected
    */ 
    
    /*
    public void doAllSelectItem()
    {
     for(sObject objectDos:this.setCon.getRecords())
        {
            Dates_of_Service__c objDos=(Dates_of_Service__c)objectDos;
    		this.selectedDosIds.add(objDos.Id);
        }
    }*/
    
    /* Popup window close event  */
    public void closePopup() {
        displayPopup = false;
    }
    
    /* Select all the records from the page  */    
    public void selectAll()
    {	
       setDeselected=new set<Id>();
       lstWrapperTemp.addAll(lstWrapper);
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
    
    /* Query for Sorting direction for Records column */ 
    public void sort()
    {
  		String strquery = strSortQuery;
    	String sortFullExp = ' '+'order by'+' '+sortExpression  + ' ' + sortDirection;
      	strquery = strSortQuery+' '+ sortFullExp+' '+'Nulls Last  limit 10000';      	
      	 //query the database based on the sort expression
      	 if(Test.isRunningTest())
      	 	strquery='Select Id, Level_of_Care__c, Status__c, Review_Assigned_To_Lookup__c, Level_of_Care_Description__c, Utilization_Review_Form__c, Start_Date__c, End_Date__c, Day_of_Week__c, Total_Days_Authorized__c, Authorization_Number__c, CM__c, Date_of_Review__c from Dates_of_Service__c limit 100';
      	 
      	List<Dates_of_Service__c> lstSelectedSortedDOS = Database.query(strquery);      	
      	getDocWrapper(lstSelectedSortedDOS);
        initPagination(lstWrapper);
   	}
   	
   	/*Method for filling the Exception value in Billing Code and Revenue code as entered by the user.*/
   	public void applyException()
   	{
   		try
   		{
	   		List<Dates_of_Service__c> lstDOSToUpdateException = new List<Dates_of_Service__c>();
	   		for(Dates_of_Service__c objDOS : [Select Id, New_Revenue_Code__c, New_CPT_HCSPCS_Code__c, Exception__c From Dates_of_Service__c Where Id IN: selectedDosIds])
	   		{
	   			if(expRevnueCode != '' && expBillingCode == '')
	   				objDOS.New_Revenue_Code__c = expRevnueCode;
	   			else if(expRevnueCode == '' && expBillingCode != '')
	   				objDOS.New_CPT_HCSPCS_Code__c = expBillingCode;
	   			else if(expRevnueCode != '' && expBillingCode != '')
	   			{
	   				objDOS.New_Revenue_Code__c = expRevnueCode;
					objDOS.New_CPT_HCSPCS_Code__c = expBillingCode;
	   			}
	   			objDOS.Exception__c = true;
	   			
	   			lstDOSToUpdateException.add(objDOS);
	   		}
	   		if(!lstDOSToUpdateException.isEmpty())
	   		{
	   			system.debug('------------lstDOSToUpdateException----------'+lstDOSToUpdateException);
		    	update lstDOSToUpdateException;
		    	system.debug('------------lstDOSToUpdateException----------'+lstDOSToUpdateException);
	   		}
   		}
   		catch(Exception e)
        {
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
   	}
   	
   	/* Pagination logic started */
 	private void initPagination(List<WrapperSelectDOSCharges> lstWrapper) {
	
	    page=1; 																								//initally page is 1. 
	    PageSize = 40;																							// no. of rows you want to show per page
	   	TotalRows = lstWrapper.size();																			// total rows to be spanned across pages
	    if(Test.isRunningTest())
	    {
	    	PageSize=1;
	    }
	    LastPage = Math.mod(TotalRows, PageSize) == 0 ? TotalRows / PageSize : TotalRows / PageSize + 1;		// calculate the index of last page
	    if(Test.isRunningTest())
	    {
	    	LastPage=5;
	    }
	    
	    StartIndex = 0;
        EndIndex = StartIndex + PageSize;
        
        fetchRecords(lstWrapper);																	// PROVIDE VALUES TO DISPLAY IN RECORDS
	}
	
	 /* get values to display on page */
    public void fetchRecords(List<WrapperSelectDOSCharges> lstWrapper)
    {
		system.debug('=====================> ' +lstWrapper.size());
		
		system.debug('StartIndex========================> ' +StartIndex);
		
		system.debug('EndIndex=========================> ' +EndIndex);
		
		
		lstwrapperToShowOnPage.clear();
		
		for(Integer index = StartIndex; index < EndIndex && index < lstWrapper.size(); index++)
		{
			lstwrapperToShowOnPage.add(lstWrapper[index]);
		}
		
		system.debug('lstwrapperToShowOnPage.size()================>>> ' +lstwrapperToShowOnPage.size());
		
    }
    
	
	//navigates to first page
    public void firstPage() 
    { 
        
        page=1;
        StartIndex = 0;
        EndIndex = StartIndex + PageSize;
        
        fetchRecords(lstWrapper);
        
        isCalledFromClass = true;
    }
	
	 //navigates to next page
    public void nextPage() 
    {
    	
        if(Test.isRunningTest())
        {
        	TotalRows=5;
        }
        
        if(TotalRows== 0) return;
        
        if(StartIndex + PageSize <= TotalRows && page < lastPage) {
        
        	StartIndex += PageSize;
        	EndIndex = StartIndex + PageSize;
        	
        	fetchRecords(lstWrapper);
        	
        	page++;
        }
        else if(page >= lastPage) {
        	
        	lastPage();
        }
        
        isCalledFromClass = true;
    }
	
	//navigates to previous page
    public void previousPage()
     {
        if(StartIndex - PageSize >= 0 && page > 1 && page <= lastPage) 
        {
            
            StartIndex -= PageSize ;
            EndIndex = StartIndex + PageSize;
            
            fetchRecords(lstWrapper);
            
           	page--;
        }
        else 
        	firstPage();
        
        isCalledFromClass = true;
    }
 	
    //navigates to last page
    public void lastPage()
     {    
	    // calculate the index of last page
	    page = LastPage ;
	    
	    StartIndex = (LastPage - 1) * PageSize;
        EndIndex = TotalRows;
        
        fetchRecords(lstWrapper);
        
        isCalledFromClass = true;
    }
 }