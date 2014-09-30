public with sharing class TBN_InsuranceVerificationForm_Handler 
{
	public TBN_InsuranceVerificationForm_Handler()
	{
		//do nothing
	}
	
	public void onafterInsert(List<InsuranceVerificationForm__c> lstInsVrForm)
	{
		createUpdatePAtientIns(lstInsVrForm);
	}
	public void onafterUpdate(Map<Id, InsuranceVerificationForm__c> mapOldInsVrForm, Map<Id, InsuranceVerificationForm__c> mapNewInsVrForm)
	{
		createUpdatePAtientIns(mapNewInsVrForm.values());
	}
	public void onafterDelete(List<InsuranceVerificationForm__c> lstInsVrForm)
	{
		// for now dont do anything
	}
	
	public void createUpdatePAtientIns(List<InsuranceVerificationForm__c> lstInsVrForm)
	{
		system.debug('=================lstInsVrForm=========='+lstInsVrForm);
		Set<String> strAllCombination = new Set<String>();
		Set<Id> setAccountId = new Set<Id>();
		List<Patient_Insurance__c> lstPatInsToBeInserted = new List<Patient_Insurance__c>();
		for(InsuranceVerificationForm__c objInsNew : lstInsVrForm)
		{
			if(objInsNew.Patient__c != null && objInsNew.Insurance_Company__c != null)
			{
				setAccountId.add(objInsNew.Patient__c);
			}
		}
		if(setAccountId != null && setAccountId.size() > 0)
		{
			for(Patient_Insurance__c objPatIns : [Select Id, Patient__c, Type__c, Insurance_Company__c, Group_Number__c
												  From Patient_Insurance__c
												  Where Patient__c IN: setAccountId])
		    {
		  		String strPatComb = objPatIns.Patient__c +'--'+objPatIns.Type__c+'--'+objPatIns.Insurance_Company__c;
		  		strAllCombination.add(strPatComb);
		    }
		    for(InsuranceVerificationForm__c objInsNew : lstInsVrForm)
			{
				if(objInsNew.Patient__c != null && objInsNew.Insurance_Company__c != null)
				{
					String strInsType = 'Primary';
					if(objInsNew.IsSecondaryInsurance__c)
						strInsType = 'Secondary';
					String strComb = objInsNew.Patient__c +'--'+strInsType+'--'+objInsNew.Insurance_Company__c;
					if(!strAllCombination.contains(strComb))
					{
						Patient_Insurance__c objPatInsNew = new Patient_Insurance__c();
						objPatInsNew.Address_Line_1__c = objInsNew.ClaimsAddressLine1__c;
						objPatInsNew.Address_Line_2__c = objInsNew.ClaimsAddressLine2__c;
						objPatInsNew.Address_Line_3__c = objInsNew.ClaimsAddressCity__c;
						objPatInsNew.Address_Line_4__c = objInsNew.ClaimsAddressState__c;
						objPatInsNew.Bill_to_Name__c = objInsNew.BillToName__c;
						objPatInsNew.Group_Number__c = objInsNew.InsuranceGroupNumber__c;
						//objPatInsNew.Insurance_Code__c = objInsNew.InsuranceID__c;
						objPatInsNew.Insurance_Company__c = objInsNew.Insurance_Company__c;
						objPatInsNew.Insurance_ID__c = objInsNew.InsuranceID__c;
						objPatInsNew.Patient__c = objInsNew.Patient__c;
						objPatInsNew.Policy_Effective_Date__c = objInsNew.PolicyEffectiveDate__c;
						objPatInsNew.Type__c = strInsType;
						lstPatInsToBeInserted.add(objPatInsNew);
						
					}
				}
			}
		}
		if(lstPatInsToBeInserted != null && lstPatInsToBeInserted.size() > 0)
			insert lstPatInsToBeInserted;
	}
}