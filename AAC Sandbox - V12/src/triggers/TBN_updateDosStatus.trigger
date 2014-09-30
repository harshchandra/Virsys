trigger TBN_updateDosStatus on Dates_of_Service__c (before update) 
{
    /* 
    This trigger  will check if DOS Bill Status is Submitted and any field value is changed then update the DOS record's Bill Status to "Reprocess". 
    */
    TBN_updateDosStatusHandler objHandler=new TBN_updateDosStatusHandler();
    
    if(trigger.isBefore && trigger.isUpdate)
    {
        objHandler.onBeforeUpdate(trigger.oldMap, trigger.newMap);
    }
}