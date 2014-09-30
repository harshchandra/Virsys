trigger TBN_PatientInsurance on Patient_Insurance__c (before insert, before update) 
{
	TBN_PatientInsurance_Handler objHandler = new TBN_PatientInsurance_Handler();
	
	if(Trigger.isBefore)
	{
		if(Trigger.isInsert)
			objHandler.onBeforeInsert(Trigger.new);
		if(Trigger.isUpdate)
			objHandler.onBeforeUpdate(Trigger.oldMap, Trigger.newMap);	
	}
}