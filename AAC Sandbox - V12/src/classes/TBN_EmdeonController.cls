public with sharing class TBN_EmdeonController  
{
	public String strBatchId 									{get; set;}	/*String to hold the Submission Batch Id*/
	public Facility__c objFacility								{get; set;}	/*Facility Object to hold the details of facility object related to the submission batch*/
	public List<Dates_of_Service__c>lstDatesOfService 			{get; set;} /*List Of dates of service records for displaying the insurance number*/
	public String strPatientInsuranceType						{get; set;} /*For binding the patient insurance type*/
	public Account objAccount									{get; set;}	/*For binding patient details*/
	public List<Patient_Insurance__c> lstPatientIns				{get; set;}	/*For binding patient insurance object*/
	
	public TBN_EmdeonController()
	{
		try
		{
			Id batchId;
			/*Getting the submission batch id passed from the URL on click of submit*/
			if(Apexpages.currentPage().getParameters().containsKey('subBatchId') && Apexpages.currentPage().getParameters().get('subBatchId') != null)
			{
				//strBatchId = Apexpages.currentPage().getParameters().get('subBatchId');
				batchId = Id.valueOf(Apexpages.currentPage().getParameters().get('subBatchId'));
			}
			system.debug('-------strBatchId------'+strBatchId);
			//strBatchId = strBatchId.left(15);
			//Id batchId = Id.valueOf(strBatchId);
			//String strTemp = strBatchId;
			
			system.debug('===============batchId===============' + batchId);
			
			/*Getting the Submission Batch details from the Batch id*/
			Batch__c objBatch = [SELECT Id,Name,(Select Id,Facility__c,Patient__c From Claims__r)
								 FROM Batch__c 
								 WHERE Id =: batchId LIMIT 1];
			
			system.debug('--objBatch---'+objBatch);
			
			/*Getting the facility realted to the submission batch*/
			objFacility = [SELECT Id, Facility_Tax_ID__c, Name,Billing_Street_Address_1__c,Billing_Street_Address_2__c,City__c,State__c,Zip__c
									   FROM Facility__c WHERE Name =: objBatch.Claims__r[0].Facility__c LIMIT 1];
									   
			List<String> lstPatientName = new List<String>();
			List<Id> lstClaimId =  new List<Id>();
			
			/*Getting the Account details of the Patient for whom claim is defined*/		
		   objAccount = [Select Id, Salutation, Name, Gender__pc, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, LastName, FirstName, Date_of_birth__pc, Insurance__c 
							From Account
							Where Name = : objBatch.Claims__r[0].Patient__c];
							
			lstPatientIns = [Select Type__c, Patient__c, Name, Insurance_Company__r.Health_Plan_Id__c, Insurance_Company__r.Address__c, 
									Insurance_Company__r.Website__c, Insurance_Company__r.Email__c, Insurance_Company__r.Phone__c, 
									Insurance_Company__r.Name, Insurance_Company__c, Insurance_Code__c, Id,Insurance_Company__r.Billing_Code__c
							From Patient_Insurance__c
							Where Patient__c = : objAccount.Id];
														
			for(Patient_Insurance__c objPatientIns : lstPatientIns)
			{
				if(objPatientIns.Type__c == 'Primary')
				{
					strPatientInsuranceType = 'P';
					break;
				}
				
				if(objPatientIns.Type__c == 'Secondary')
					strPatientInsuranceType = 'S';
				
				if(objPatientIns.Type__c == 'Tertiary' && strPatientInsuranceType == null)
					strPatientInsuranceType = 'T';
			}
							
		    lstDatesOfService = [Select Patient_Insurance__c, Patient_Id__c, Claim__c,
		    												 Patient_Insurance__r.Type__c, Patient_Insurance__r.Insurance_Company__c, 
		    												 Patient_Insurance__r.Insurance_Code__c, Patient_Insurance__r.Name,
		    												 Utilization_Review_Form__r.VOB__r.InsuranceGroupNumber__c
		    												 From Dates_of_Service__c
		    												 Where  Claim__c =:objBatch.Claims__r[0].Id];
			
			
			system.debug('-------lstDatesOfService---------'+lstDatesOfService);
			
		}
		catch(exception e)
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    	system.debug('-------error---- : '+e.getLineNumber());
		}
	}
}