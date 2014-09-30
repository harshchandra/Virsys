trigger TBN_DOSAmountRollupForAccounts on Dates_of_Service__c (after delete, after insert, after update,before update,before insert) 
{
    /* 
    This trigger  will check if DOS Patient_Id__c filed is having any value or not. If contains id then search all the DOS records having same Patient_Id__c and calculate the sum of 
    Amount_Paid__c and Patient_Responsibility_Amount__c and update the summary field of corresponding Account record.
    */
        
    TBN_DOSAmountRollUpHandler objDOSAmountRollUpHandler = new TBN_DOSAmountRollUpHandler();
    
    if(trigger.isBefore && trigger.isInsert)
    {
        objDOSAmountRollUpHandler.onBeforeInsert(trigger.new);
    } 
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
    if(trigger.isBefore && trigger.isUpdate)
    {
        objDOSAmountRollUpHandler.onBeforeUpdate(trigger.oldMap, trigger.newMap);
    }
}