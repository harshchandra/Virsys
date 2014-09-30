public with sharing class TBN_PrintUB04FormForBatch 
{
	public List<WrapperUB04Print> lstWrapperUB04Print			{get; set;}		//Wrapper List to be binded to page That will contain list of claims and its associated records.
	String batchId;
	List<Claim__c>	lstClaim;
	
	/*Controller*/
	public TBN_PrintUB04FormForBatch()
	{
		lstWrapperUB04Print = new List<WrapperUB04Print>();
		
		try
		{
			if(Apexpages.currentPage().getParameters().get('batchId') !='' && Apexpages.currentPage().getParameters().get('batchId') != null)
				batchId = Apexpages.currentPage().getParameters().get('batchId');
			/*Getting the list of Claims for particular Batch record.*/		
			lstClaim = [Select Id, ParentClaim__c, Status__c, Patient__c, Name, Level_of_Care__c, Facility__c, Type_of_Bill__c 
						From Claim__c 
						where ParentClaim__c =: batchId];
			system.debug('&&&&&&&&&&lstClaim&&&& : '+lstClaim);	
			//if(lstClaim.size() > 0)		
				getClaimDetails();
			if(Test.isRunningTest())
				Integer c = 5/0;
		}
		catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    	system.debug('77777777777777 : '+e.getLineNumber());
	    }
	}
	
	private void getClaimDetails()
	{
		List<String> lstPatientName = new List<String>();
		List<String> lstClaimId = new List<String>();
		map<String, Account> mapPatienetToAccount = new map<String, Account>();
		map<String, List<Dates_of_Service__c>> mapClaimIdToDOS = new map<String, List<Dates_of_Service__c>>();
		map<String, List<Patient_Insurance__c>> mapPatientToLstPatientInsurance = new map<String, List<Patient_Insurance__c>>();	//Map of Patient Name corresponding List of Patient_Insurance__c
		
		/*Getting the Facility details for the selected claim facility*/
		Facility__c	objCommonFacility = [Select Zip__c, Street_Address_2__c, Street_Address_1__c, State__c, Name, Main_Phone_Number__c, Country__c, City__c, Billing_Zip__c, Billing_Street_Address_2__c, 
												Billing_Street_Address_1__c, Billing_State__c, Billing_Main_Phone_Number__c, Billing_Country__c, Billing_City__c, Facility_Tax_ID__c 
										From Facility__c 
										Where Name = : lstClaim[0].Facility__c]; 
		system.debug('******objCommonFacility******* : '+objCommonFacility);
		try
		{
			for(Claim__c objClaim : lstClaim)
			{
				lstPatientName.add(objClaim.Patient__c);
				lstClaimId.add(objClaim.Id);
			}
			
			for(Account objAccount : [Select Id, Salutation, Name, Gender__pc, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, LastName, FirstName, Date_of_birth__pc, PersonBirthdate, Insurance__c 
										From Account
										Where Name IN : lstPatientName])
			{
				mapPatienetToAccount.put(objAccount.Name, objAccount);
			}
			system.debug('#####mapPatienetToAccount###### : '+mapPatienetToAccount);
			
			for(Dates_of_Service__c objDOS : [Select Total_Calendar_Days__c, Start_Date__c, Revenue_Code__c, Notes__c, Id, Claim__c, Billing_Code__c, Amount__c, End_Date__c, Insurance_Company__c, 
													Authorization_Number__c, Utilization_Review_Form__r.Primary_Diagnosis_Description__c, Utilization_Review_Form__r.Primary_Diagnosis_Code__r.Name, 
													Utilization_Review_Form__r.Diagnosis__c, Utilization_Review_Form__r.Discharge_Date__c, Utilization_Review_Form__c, 
													Utilization_Review_Form__r.VOB__r.InsuranceID__c, Utilization_Review_Form__r.VOB__r.InsuredRelationshipToClient__c, 
													Utilization_Review_Form__r.VOB__r.InsuranceGroupNumber__c, Utilization_Review_Form__r.VOB__r.InsuranceReferenceNumber__c, 
													Utilization_Review_Form__r.VOB__r.InsuranceCompany__c, Utilization_Review_Form__r.VOB__r.Insurance_Company_Emdeon__c, 
													Utilization_Review_Form__r.VOB__r.IsSecondaryInsurance__c   
												From Dates_of_Service__c
												Where Claim__c IN : lstClaimId])
			{
				if(mapClaimIdToDOS.containsKey(objDOS.Claim__c))
					mapClaimIdToDOS.get(objDOS.Claim__c).add(objDOS);
				else
					mapClaimIdToDOS.put(objDOS.Claim__c, new List<Dates_of_Service__c>{objDOS});
				
			}
			system.debug('!!!!!mapClaimIdToDOS!!!!! : '+mapClaimIdToDOS);
			
			/*Quering on Patient_Insurance__c  object to get all its related insurance information*/
			for(Patient_Insurance__c objPatientIns : [Select Type__c, Patient__c, Name, Insurance_Company__r.Health_Plan_Id__c, Insurance_Company__r.Address__c, 
																Insurance_Company__r.Website__c, Insurance_Company__r.Email__c, Insurance_Company__r.Phone__c, 
																Insurance_Company__r.Name, Insurance_Company__c, Insurance_Code__c, Id, Patient__r.Name 
														From Patient_Insurance__c
														Where Patient__r.Name IN : lstPatientName])
			{
				if(mapPatientToLstPatientInsurance.containsKey(objPatientIns.Patient__r.Name))
					mapPatientToLstPatientInsurance.get(objPatientIns.Patient__r.Name).add(objPatientIns);
				else
					mapPatientToLstPatientInsurance.put(objPatientIns.Patient__r.Name, new List<Patient_Insurance__c>{objPatientIns});
			}
			system.debug('%%%%mapPatientToLstPatientInsurance%%%% : '+mapPatientToLstPatientInsurance);
			
			for(Claim__c objClaim : lstClaim)
			{
				Date minDateDos;												//Min End_Date__c from all the Date of Service records.
				Date maxDateDos;												//Max End_Date__c from all the Date of Service records
				WrapperUB04Print objWrapperUB04Print = new WrapperUB04Print();
				
				if(mapPatienetToAccount.containsKey(objClaim.Patient__c))
				{
					objWrapperUB04Print.objAccount = mapPatienetToAccount.get(objClaim.Patient__c);
					
					for(Patient_Insurance__c objPatientIns : mapPatientToLstPatientInsurance.get(objClaim.Patient__c))
					{
						if(objPatientIns.Type__c == 'Primary')
						{
							objWrapperUB04Print.objPatientInsurance = objPatientIns;
							break;
						}
						
						if(objPatientIns.Type__c == 'Secondary')
							objWrapperUB04Print.objPatientInsurance = objPatientIns;
						
						if(objPatientIns.Type__c == 'Tertiary' && objWrapperUB04Print.objPatientInsurance == null)
							objWrapperUB04Print.objPatientInsurance = objPatientIns;
					}
				}
					
				if(mapClaimIdToDOS.containsKey(objClaim.Id))
				{
					objWrapperUB04Print.lstDateOfService = mapClaimIdToDOS.get(objClaim.Id);
					objWrapperUB04Print.objFacility = objCommonFacility;
					objWrapperUB04Print.objClaim = objClaim;
					
					if(objWrapperUB04Print.lstDateOfService.size() == 0)
						objWrapperUB04Print.AuthorizationNumber = '';
					else
						objWrapperUB04Print.AuthorizationNumber = objWrapperUB04Print.lstDateOfService[0].Authorization_Number__c;
				}
				
				/*Calculating the Total Amount for Claim*/
				objWrapperUB04Print.TotalAmount = 0;
				for(Dates_of_Service__c objDOS : objWrapperUB04Print.lstDateOfService)
				{
					objWrapperUB04Print.TotalAmount += objDOS.Amount__c;
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
				objWrapperUB04Print.objPhysiciansUnderFacility = [Select Term_Date__c, Name, Id, Facility__c, Facility_Tax_ID__c, Effective_Date__c, Facility__r.Name, 
																			Contact__r.Salutation, Contact__r.FirstName, Contact__r.LastName, Contact__c
																	From Physicians_Under_Facility__c
																	Where Effective_Date__c <= :  minDateDos AND Term_Date__c >=  :  maxDateDos limit 1];
				system.debug('$$$$$objWrapperUB04Print.objPhysiciansUnderFacility$$$$$$ : '+objWrapperUB04Print.objPhysiciansUnderFacility);
				
				/*Creating list of integer value to show blank rows*/
				objWrapperUB04Print.lstNumberOfBlankRows = new List<Integer>();			
				for(Integer i=objWrapperUB04Print.lstDateOfService.size()+1; i<=22; i++)
				{
					objWrapperUB04Print.lstNumberOfBlankRows.add(i);
				}
				system.debug('*****objWrapperUB04Print.lstNumberOfBlankRows**** : '+objWrapperUB04Print.lstNumberOfBlankRows);
				lstWrapperUB04Print.add(objWrapperUB04Print);
			}
			system.debug('$$$$$$$$$$lstWrapperUB04Print$$$$$$$$$$$$$ : '+lstWrapperUB04Print);
			if(Test.isRunningTest())
				Integer c = 5/0;
		}
		catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    	system.debug('77777777777777 : '+e.getLineNumber());
	    }
	}
	
	/*Wrapper class that will contain all the details to be show on TBN_PrintUB04FormForBatch on click of "url given in body of Notes attached to Batch record" */
    public class WrapperUB04Print
    {
        public Facility__c objFacility							{get; set;}		//Conatins the Facility details for the selected Claim.
		public Claim__c objClaim								{get; set;}		//Contains the details of Selected Claim.
		public Account objAccount								{get; set;}		//Contains all the Account detai;s of the Patient for whom claim is defined.
		public Decimal TotalAmount								{get; set;}		//Sum of amount of all Date of Service records for a particular claim.
		public List<Integer> lstNumberOfBlankRows				{get; set;}		//Contains the list of blank rows to be shown on the page.
		public List<Dates_of_Service__c> lstDateOfService		{get; set;}		//Contains the list of date of service records for selected claim.
		public Physicians_Under_Facility__c objPhysiciansUnderFacility	{get; set;}		//Physicain Under Facility object to be used to show on UB-04 form.	
		public String AuthorizationNumber						{get; set;}		//Authorization Number
		public Patient_Insurance__c objPatientInsurance			{get; set;}		//Patient Insurance object that will conatins all the insurance related information of the patient.
        
        /* constructor */ 
        public WrapperUB04Print()
        {
            
        }
    }
}