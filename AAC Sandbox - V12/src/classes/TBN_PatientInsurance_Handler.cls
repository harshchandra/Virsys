public with sharing class TBN_PatientInsurance_Handler 
{
	public TBN_PatientInsurance_Handler()
	{
		// do nothing
	}
	
	public void onBeforeInsert(List<Patient_Insurance__c> lstPatIns)
	{
		Set<Id> setInsuranceCompany = new Set<Id>();
		Set<Id> setCaseId = new Set<Id>();
		Set<Id> setAccountId = new Set<Id>();
		Map<Id, InsuranceVerificationForm__c> mapInsCompId_VerificationForm = new Map<Id, InsuranceVerificationForm__c>();
		for(Patient_Insurance__c objPatIns : lstPatIns)
		{
			if(objPatIns.Insurance_Company__c != null)
				setInsuranceCompany.add(objPatIns.Insurance_Company__c);
			if(objPatIns.Patient__c != null)	
				setAccountId.add(objPatIns.Patient__c);
		}
		if(setAccountId != null && setAccountId.size() > 0)
		{
			for(Case objCase : [Select Id, AccountId from Case where AccountId IN: setAccountId])
			{
				setCaseId.add(objCase.Id);
			}
		}
		if(setCaseId != null && setCaseId.size() > 0 && setInsuranceCompany != null && setInsuranceCompany.size() > 0)
		{
			for(InsuranceVerificationForm__c objVerification : [Select Id, Case__c, IsSecondaryInsurance__c, InsuranceID__c, InsuranceGroupNumber__c, Insurance_Company__c
																from InsuranceVerificationForm__c 
																where Insurance_Company__c IN: setInsuranceCompany AND Case__c IN: setCaseId AND VerificationComplete__c = true 
																Order By LastModifiedDate Desc])
			{
				if(objVerification.Insurance_Company__c != null && !mapInsCompId_VerificationForm.containsKey(objVerification.Insurance_Company__c))
				mapInsCompId_VerificationForm.put(objVerification.Insurance_Company__c, objVerification);
			}
			if((mapInsCompId_VerificationForm == null || mapInsCompId_VerificationForm.size() == 0) && setInsuranceCompany != null)
			{
				for(InsuranceVerificationForm__c objVerification : [Select Id, Case__c, IsSecondaryInsurance__c, InsuranceID__c, InsuranceGroupNumber__c, Insurance_Company__c
																from InsuranceVerificationForm__c 
																where Insurance_Company__c IN: setInsuranceCompany AND VerificationComplete__c = true 
																Order By LastModifiedDate Desc])
				{
					if(objVerification.Insurance_Company__c != null && !mapInsCompId_VerificationForm.containsKey(objVerification.Insurance_Company__c))
					mapInsCompId_VerificationForm.put(objVerification.Insurance_Company__c, objVerification);
				}
			}
		}
		else if(setInsuranceCompany != null && setInsuranceCompany.size() > 0)
		{
			for(InsuranceVerificationForm__c objVerification : [Select Id, Case__c, IsSecondaryInsurance__c, InsuranceID__c, InsuranceGroupNumber__c, Insurance_Company__c
																from InsuranceVerificationForm__c 
																where Insurance_Company__c IN: setInsuranceCompany AND VerificationComplete__c = true 
																Order By LastModifiedDate Desc])
			{
				if(objVerification.Insurance_Company__c != null && !mapInsCompId_VerificationForm.containsKey(objVerification.Insurance_Company__c))
				mapInsCompId_VerificationForm.put(objVerification.Insurance_Company__c, objVerification);
			}
		}
		system.debug('----------mapInsCompId_VerificationForm----------'+mapInsCompId_VerificationForm);
		if(mapInsCompId_VerificationForm != null && mapInsCompId_VerificationForm.size() > 0)
		{
			for(Patient_Insurance__c objPatIns : lstPatIns)
			{
				if(objPatIns.Insurance_Company__c != null && mapInsCompId_VerificationForm.containsKey(objPatIns.Insurance_Company__c))
				{
					system.debug('----------objPatIns----------'+objPatIns);
					objPatIns.Group_Number__c = mapInsCompId_VerificationForm.get(objPatIns.Insurance_Company__c).InsuranceGroupNumber__c;
					objPatIns.Insurance_ID__c = mapInsCompId_VerificationForm.get(objPatIns.Insurance_Company__c).InsuranceID__c;
					if(mapInsCompId_VerificationForm.get(objPatIns.Insurance_Company__c).IsSecondaryInsurance__c)
						objPatIns.Type__c = 'Secondary';
					else
						objPatIns.Type__c = 'Primary';	
				}
			}
		}
	}
	
	public void onBeforeUpdate(Map<Id, Patient_Insurance__c> mapOldPatIns, Map<Id, Patient_Insurance__c> mapNewPatIns)
	{
		Set<Id> setInsuranceCompany = new Set<Id>();
		Set<Id> setCaseId = new Set<Id>();
		Set<Id> setAccountId = new Set<Id>();
		Map<Id, InsuranceVerificationForm__c> mapInsCompId_VerificationForm = new Map<Id, InsuranceVerificationForm__c>();
		for(Patient_Insurance__c objPatIns : mapNewPatIns.values())
		{
			if(objPatIns.Insurance_Company__c != null && objPatIns.Insurance_Company__c != mapOldPatIns.get(objPatIns.Id).Insurance_Company__c)
			{
				if(objPatIns.Insurance_Company__c != null)
					setInsuranceCompany.add(objPatIns.Insurance_Company__c);
				if(objPatIns.Patient__c != null)	
					setAccountId.add(objPatIns.Patient__c);
			}
		}
		if(setAccountId != null && setAccountId.size() > 0)
		{
			for(Case objCase : [Select Id, AccountId from Case where AccountId IN: setAccountId])
			{
				setCaseId.add(objCase.Id);
			}
		}
		if(setCaseId != null && setCaseId.size() > 0 && setInsuranceCompany != null && setInsuranceCompany.size() > 0)
		{
			for(InsuranceVerificationForm__c objVerification : [Select Id, Case__c, IsSecondaryInsurance__c, InsuranceID__c, InsuranceGroupNumber__c, Insurance_Company__c
																from InsuranceVerificationForm__c 
																where Insurance_Company__c IN: setInsuranceCompany AND Case__c IN: setCaseId AND VerificationComplete__c = true 
																Order By LastModifiedDate Desc])
			{
				if(objVerification.Insurance_Company__c != null && !mapInsCompId_VerificationForm.containsKey(objVerification.Insurance_Company__c))
				mapInsCompId_VerificationForm.put(objVerification.Insurance_Company__c, objVerification);
			}
			if((mapInsCompId_VerificationForm == null || mapInsCompId_VerificationForm.size() == 0) && setInsuranceCompany != null)
			{
				for(InsuranceVerificationForm__c objVerification : [Select Id, Case__c, IsSecondaryInsurance__c, InsuranceID__c, InsuranceGroupNumber__c, Insurance_Company__c
																from InsuranceVerificationForm__c 
																where Insurance_Company__c IN: setInsuranceCompany AND VerificationComplete__c = true 
																Order By LastModifiedDate Desc])
				{
					if(objVerification.Insurance_Company__c != null && !mapInsCompId_VerificationForm.containsKey(objVerification.Insurance_Company__c))
					mapInsCompId_VerificationForm.put(objVerification.Insurance_Company__c, objVerification);
				}
			}
		}
		else if(setInsuranceCompany != null && setInsuranceCompany.size() > 0)
		{
			for(InsuranceVerificationForm__c objVerification : [Select Id, Case__c, IsSecondaryInsurance__c, InsuranceID__c, InsuranceGroupNumber__c, Insurance_Company__c
																from InsuranceVerificationForm__c 
																where Insurance_Company__c IN: setInsuranceCompany AND VerificationComplete__c = true 
																Order By LastModifiedDate Desc])
			{
				if(objVerification.Insurance_Company__c != null && !mapInsCompId_VerificationForm.containsKey(objVerification.Insurance_Company__c))
				mapInsCompId_VerificationForm.put(objVerification.Insurance_Company__c, objVerification);
			}
		}
		if(mapInsCompId_VerificationForm != null && mapInsCompId_VerificationForm.size() > 0)
		{
			for(Patient_Insurance__c objPatIns : mapNewPatIns.values())
			{
				if(objPatIns.Insurance_Company__c != null && objPatIns.Insurance_Company__c != mapOldPatIns.get(objPatIns.Id).Insurance_Company__c)
				{	
					if(objPatIns.Insurance_Company__c != null && mapInsCompId_VerificationForm.containsKey(objPatIns.Insurance_Company__c))
					{
						objPatIns.Group_Number__c = mapInsCompId_VerificationForm.get(objPatIns.Insurance_Company__c).InsuranceGroupNumber__c;
						objPatIns.Insurance_ID__c = mapInsCompId_VerificationForm.get(objPatIns.Insurance_Company__c).InsuranceID__c;
						if(mapInsCompId_VerificationForm.get(objPatIns.Insurance_Company__c).IsSecondaryInsurance__c)
							objPatIns.Type__c = 'Secondary';
						else
							objPatIns.Type__c = 'Primary';	
					}
				}
			}
		}
	}
}