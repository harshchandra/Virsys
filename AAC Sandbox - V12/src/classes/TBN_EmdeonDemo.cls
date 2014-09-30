public without sharing class TBN_EmdeonDemo 
{
	public String strBatchId 									{get; set;}	/*String to hold the Submission Batch Id*/
	public Facility__c objFacility								{get; set;}	/*Facility Object to hold the details of facility object related to the submission batch*/
	public List<Dates_of_Service__c>lstDatesOfService 			{get; set;} /*List Of dates of service records for displaying the insurance number*/
	public String strPatientInsuranceType						{get; set;} /*For binding the patient insurance type*/
	public List<Account> lstAccount								{get; set;}	/*For binding patient details*/
	public List<Patient_Insurance__c> lstPatientIns				{get; set;}	/*For binding patient insurance object*/
	private Id patientInsuranceId;
	
	public TBN_EmdeonDemo()
	{
		try
		{
			lstDatesOfService = new List<Dates_of_Service__c>();
			lstPatientIns = new List<Patient_Insurance__c>();
			
			/*Getting the submission batch id passed from the URL on click of submit*/
			if(Apexpages.currentPage().getParameters().containsKey('subBatchId') && Apexpages.currentPage().getParameters().get('subBatchId') != null)
			{
				strBatchId = Apexpages.currentPage().getParameters().get('subBatchId');
			}
			system.debug('-------strBatchId------'+strBatchId);
			String escapeSingleQuotes = strBatchId;
			
			/*Getting the Submission Batch details from the Batch id*/
			Batch__c objBatch = [SELECT Id,Name,(Select Id,Facility__c,Patient__c From Claims__r)
								 FROM Batch__c 
								  Where Id =: strBatchId];
			
			/*Getting the facility realted to the submission batch*/
			objFacility = [SELECT Id, Facility_Tax_ID__c, Name,Billing_Street_Address_1__c,Billing_Street_Address_2__c,City__c,State__c,Zip__c
									   FROM Facility__c WHERE Name =: objBatch.Claims__r[0].Facility__c LIMIT 1];
									   
			List<String> lstClaimNames =  new List<String>();		   
			for(Claim__c objClaims : objBatch.Claims__r)
			{
				lstClaimNames.add(objClaims.Patient__c);
				
			}
			
			/*Getting the Account details of the Patient for whom claim is defined*/		
		    lstAccount = [Select Id, Salutation, Name, Gender__pc, BillingStreet, BillingState, BillingPostalCode, BillingCountry, BillingCity, LastName, FirstName, Date_of_birth__pc, Insurance__c 
							From Account
							Where Name IN : lstClaimNames];
			
			system.debug('------------lstAccount-----------'+lstAccount);				
			lstPatientIns = [Select Type__c, Patient__c, Name, Insurance_Company__r.Health_Plan_Id__c, Insurance_Company__r.Address__c, 
									Insurance_Company__r.Website__c, Insurance_Company__r.Email__c, Insurance_Company__r.Phone__c, 
									Insurance_Company__r.Name, Insurance_Company__c, Insurance_Code__c, Id,Insurance_Company__r.Billing_Code__c
							From Patient_Insurance__c
							Where Patient__c IN :lstAccount];
			system.debug('-----lstPatientIns------------'+lstPatientIns);
														
			for(Patient_Insurance__c objPatientIns : lstPatientIns)
			{
				if(objPatientIns.Type__c == 'Primary')
				{
					strPatientInsuranceType = 'P';
					patientInsuranceId = objPatientIns.Id;
					break;
				}
				
				if(objPatientIns.Type__c == 'Secondary')
				{
					patientInsuranceId = objPatientIns.Id;
					strPatientInsuranceType = 'S';
					
				}					
				
				if(objPatientIns.Type__c == 'Tertiary' && strPatientInsuranceType == null)
				{
					patientInsuranceId = objPatientIns.Id;
					strPatientInsuranceType = 'T';
				}
					
			}
			system.debug('--------patientInsuranceId-----'+patientInsuranceId);				
		    lstDatesOfService = [Select Patient_Insurance__c, Patient_Id__c, Claim__c,
									 Patient_Insurance__r.Type__c, Patient_Insurance__r.Insurance_Company__c, 
									 Patient_Insurance__r.Insurance_Code__c, Patient_Insurance__r.Name,
									 Utilization_Review_Form__r.VOB__r.InsuranceGroupNumber__c
									 From Dates_of_Service__c
									 Where Patient_Insurance__c =: Id.valueOf(patientInsuranceId)];
			
			
			system.debug('-------lstDatesOfService---------'+lstDatesOfService);
			
		}
		catch(exception e)
		{
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    	system.debug('-------error---- : '+e.getLineNumber());
		}
	}
	public Pagereference doCreateAttachment()
	{
		String strLoad = Apexpages.currentPage().getParameters().get('Load');
		String strBatchIdNew = Apexpages.currentPage().getParameters().get('subBatchId');
		Batch__c objBatchNew = [SELECT Id,Name,(Select Id,Facility__c,Patient__c From Claims__r)
								 FROM Batch__c 
								  Where Id =: strBatchIdNew];
		if(strLoad != null && strLoad=='first')
		{
			PageReference objPR = new PageReference('/apex/TBN_Emdeon?subBatchId='+strBatchIdNew);
	        Attachment att = new Attachment();
	        att.Name = 'Emdeon_'+objBatchNew.Name; 
	        //objPR.getParameters().put('subBatchId', objBatch.Id);
	        att.ContentType = 'text/html';
	        system.debug('-----objPR.getContent()---'+objPR.getContent());
			att.body = objPR.getContent();
	        att.parentid = objBatchNew.Id;
	        
	        
	        String strResponse = V12_SendPostRequestController.sendRequest(String.valueOf(att.body), objBatchNew.Name);
	        Attachment att1 = new Attachment();
	        att1.Name = 'Emdeon_Response'; 
	        att1.ContentType = 'text/html';
			att1.body = Blob.valueOf(strResponse);
	        att1.parentid = objBatchNew.Id;
	        
	        insert att;
	        insert att1;
	        
	        Pagereference objPR1 = new Pagereference('/'+strBatchIdNew);
			return objPR1;
		}
		else
			return null;
		
		
		
	}
}