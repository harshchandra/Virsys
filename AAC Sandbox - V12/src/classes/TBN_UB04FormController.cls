public with sharing class TBN_UB04FormController 
{
	public Facility__c objFacility							{get; set;}		//Conatins the Facility details for the selected Claim.
	public Claim__c objClaim								{get; set;}		//Contains the details of Selected Claim.
	public Account objAccount								{get; set;}		//Contains all the Account detai;s of the Patient for whom claim is defined.
	public Decimal TotalAmount								{get; set;}		//Sum of amount of all Date of Service records for a particular claim.
	public List<Integer> lstNumberOfBlankRows				{get; set;}		//Contains the list of blank rows to be shown on the page.
	public List<Dates_of_Service__c> lstDateOfService		{get; set;}		//Contains the list of date of service records for selected claim.
	public String AuthorizationNumber						{get; set;}		//Authorization Number
	public Physicians_Under_Facility__c objPhysiciansUnderFacility	{get; set;}		//Physicain Under Facility object to be used to show on UB-04 form.	
	public Patient_Insurance__c objPatientInsurance			{get; set;}		//Patient Insurance object that will conatins all the insurance related information of the patient.
	private Date minDateDos;												//Min End_Date__c from all the Date of Service records.
	private Date maxDateDos;												//Max End_Date__c from all the Date of Service records
	String claimId;
	public String strInsAdd1 {get;set;}
	public String strInsAdd2 {get;set;}
	
	public String strAttPhy1 {get;set;}
	public String strAttPhy2 {get;set;}
	
	/*Controller*/
	public TBN_UB04FormController()
	{
		lstDateOfService = new List<Dates_of_Service__c>();
		lstNumberOfBlankRows = new List<Integer>();
		strInsAdd1 = strInsAdd2 = strAttPhy1 = strAttPhy2 = '';
		TotalAmount = 0;
		try
		{
			if(Apexpages.currentPage().getParameters().get('claim') !='' && Apexpages.currentPage().getParameters().get('claim') != null)
				claimId = Apexpages.currentPage().getParameters().get('claim');
				
			
			/*Getting the Claims details from the claim id*/
			objClaim = [Select Status__c, Patient__c, ParentClaim__c, Name, Level_of_Care__c, Id, Facility__c, Type_of_Bill__c 
						From Claim__c 
						Where Id = : claimId];
						
						
			/*Getting the Facility details for the selected claim facility*/
			objFacility = [Select Zip__c, Street_Address_2__c, Street_Address_1__c, State__c, Name, Main_Phone_Number__c, Country__c, City__c, Billing_Zip__c, Billing_Street_Address_2__c, 
									Billing_Street_Address_1__c, Billing_State__c, Billing_Main_Phone_Number__c, Billing_Country__c, Billing_City__c, Facility_Tax_ID__c  
							From Facility__c 
							Where Name = : objClaim.Facility__c];
							
			/*Getting the Account details of the Patient for whom claim is defined*/		
			objAccount = [Select Id, Salutation, Name, Gender__pc, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, LastName, FirstName, Date_of_birth__pc, PersonBirthdate, Insurance__c 
							From Account
							Where Name = : objClaim.Patient__c];
							
			/*Getting list of Date of Service record for particular claim.*/				
			lstDateOfService = [Select Total_Calendar_Days__c, Start_Date__c, Revenue_Code__c, Notes__c, Id, Claim__c, New_Revenue_Code__c, New_CPT_HCSPCS_Code__c, Billing_Code__c, Amount__c, End_Date__c, Insurance_Company__c, 
										Authorization_Number__c, Utilization_Review_Form__r.Primary_Diagnosis_Description__c, Utilization_Review_Form__r.Primary_Diagnosis_Code__r.Name, 
										Utilization_Review_Form__r.Diagnosis__c, Utilization_Review_Form__r.Discharge_Date__c, Utilization_Review_Form__c, 
										Utilization_Review_Form__r.VOB__r.InsuranceID__c, Utilization_Review_Form__r.VOB__r.InsuredRelationshipToClient__c, 
										Utilization_Review_Form__r.VOB__r.InsuranceGroupNumber__c, Utilization_Review_Form__r.VOB__r.InsuranceReferenceNumber__c, 
										Utilization_Review_Form__r.VOB__r.InsuranceCompany__c, Utilization_Review_Form__r.VOB__r.Insurance_Company_Emdeon__c, 
										Utilization_Review_Form__r.VOB__r.IsSecondaryInsurance__c 
								From Dates_of_Service__c
								Where Claim__c = : objClaim.Id order by Start_Date__c asc];
			if(lstDateOfService.size() == 0)
				AuthorizationNumber = '';
			else
				AuthorizationNumber = lstDateOfService[0].Authorization_Number__c;	
			
			/*Calculating the Total Amount for Claim*/
			for(Dates_of_Service__c objDOS : lstDateOfService)
			{
				if(objDOS.Amount__c != null)
				TotalAmount += objDOS.Amount__c;
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
			objPhysiciansUnderFacility = [Select Term_Date__c, Name, Id, Facility__c, Facility_Tax_ID__c, Effective_Date__c, Facility__r.Name, Contact__r.Salutation, 
													Contact__r.FirstName, Contact__r.LastName, Contact__c
											From Physicians_Under_Facility__c
											Where Effective_Date__c <= :  minDateDos AND Term_Date__c >=  :  maxDateDos limit 1];
			system.debug('$$$$$objPhysiciansUnderFacility$$$$$$ : '+objPhysiciansUnderFacility);
			if(objPhysiciansUnderFacility != null)
			{
				if(objPhysiciansUnderFacility.Name.contains(' '))
				{
					strAttPhy1 = objPhysiciansUnderFacility.Name.split(' ')[0];
					strAttPhy2 = objPhysiciansUnderFacility.Name.split(' ')[1];
				}
				else
				{
					strAttPhy1 = objPhysiciansUnderFacility.Name;
				}
			}
			
			/*Quering on Patient_Insurance__c  object to get all its related insurance information*/
			for(Patient_Insurance__c objPatientIns : [Select Type__c, Patient__c, Name, Insurance_Company__r.Health_Plan_Id__c, Insurance_Company__r.Address__c, 
																Insurance_Company__r.Website__c, Insurance_Company__r.Email__c, Insurance_Company__r.Phone__c, 
																Insurance_Company__r.Name, Insurance_Company__c, Insurance_Code__c, Id 
														From Patient_Insurance__c
														Where Patient__c = : objAccount.Id])
			{
				system.debug('============objPatientIns============'+objPatientIns);
				if(objPatientIns.Type__c == 'Primary')
				{
					objPatientInsurance = objPatientIns;
					break;
				}
				
				if(objPatientIns.Type__c == 'Secondary')
					objPatientInsurance = objPatientIns;
				
				if(objPatientIns.Type__c == 'Tertiary' && objPatientInsurance == null)
					objPatientInsurance = objPatientIns;
			}
			
			/*Creating list of integer value to show blank rows*/					
			for(Integer i=lstDateOfService.size()+1; i<=22; i++)
			{
				lstNumberOfBlankRows.add(i);
			}
			system.debug('*****lstNumberOfBlankRows**** : '+lstNumberOfBlankRows);
			strInsAdd1 = String.valueOf(objPatientInsurance.Insurance_Company__r.Address__c).left(32);
			strInsAdd2 = String.valueOf(objPatientInsurance.Insurance_Company__r.Address__c).subString(32, String.valueOf(objPatientInsurance.Insurance_Company__r.Address__c).length());
		}
		
		 catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    	system.debug('77777777777777 : '+e.getLineNumber());
	    }
	}
}