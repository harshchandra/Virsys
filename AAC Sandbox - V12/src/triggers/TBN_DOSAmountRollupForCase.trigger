trigger TBN_DOSAmountRollupForCase on Dates_of_Service__c (after delete, after insert, after update) 
{
	/* 
    This trigger  will check if DOS Case_Id__c filed is having any value or not. If contains id then search all the DOS records having same Case_Id__c and calculate the sum of 
    Amount_Paid__c and Patient_Responsibility_Amount__c and update the summary field of corresponding Case record.
    */
	
	TBN_DOSAmountRollUpHandler objDOSAmountRollUpHandler = new TBN_DOSAmountRollUpHandler();
	
	if(trigger.isAfter && trigger.isInsert)
    {
        objDOSAmountRollUpHandler.onAfterInsert(trigger.oldMap, trigger.newMap);
    }
    
    if(trigger.isAfter && trigger.isUpdate)
    {
    	objDOSAmountRollUpHandler.onAfterUpdate(trigger.oldMap, trigger.newMap);
    }
    
    if(trigger.isAfter && trigger.isDelete)
    {
    	objDOSAmountRollUpHandler.onAfterDelete(trigger.oldMap, trigger.newMap);
    }
}