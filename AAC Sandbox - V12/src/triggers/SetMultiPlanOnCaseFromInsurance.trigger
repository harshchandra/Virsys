trigger SetMultiPlanOnCaseFromInsurance on InsuranceVerificationForm__c (before insert, before update, after Insert, after update) 
{
	TBN_InsuranceVerificationForm_Handler objClass = new TBN_InsuranceVerificationForm_Handler(); 
    if(Trigger.isbefore)
    {
	    //store all case ids that are multi plan
	    Set<Id> caseIds = new Set<Id>();
	    
	    for(InsuranceVerificationForm__c i : trigger.new)
	    {
	        if(i.Case__c != null && i.Benefit_Type__c == 'MultiPlan')
	        {
	            caseIds.add(i.Case__c);
	        }
	    }
	    
	    //if we have any multiplan benefit types from the insurance side, update the case flag
	    if(caseIds.size() > 0)
	    {
	        List<Case> cases = [SELECT Id, CaseNumber, MultiPlan__c FROM Case WHERE Id IN :caseIds];
	    
	        for(Case c : cases)
	        {
	            c.MultiPlan__c = true;
	        }
	    
	        update cases;
	    }   
    } 
    if(Trigger.isAfter && Trigger.isInsert)
    	objClass.onAfterInsert(Trigger.new);
    if(Trigger.isAfter && Trigger.isInsert)
    	objClass.onAfterUpdate(Trigger.OldMap, Trigger.NewMap);
    if(Trigger.isAfter && Trigger.isInsert)
    	objClass.onAfterDelete(Trigger.old);
    
       
}