trigger SetOwnerOnVOBVerifiedWithUCRTask on Task (before insert) 
{
    Set<Id> insuranceIds = new Set<Id>();
    boolean isRightTypeOfTask = false;
    Set<Group> groups = new Set<Group>([SELECT Id FROM Group]);
    Set<Id> groupIds = new Set<Id>();
    for(Group g : groups)
    {
        groupIds.add(g.Id);
    }
    for(Task t : Trigger.new)
    {
        if(t.Subject == 'Needs Action: Insurance is Verified with UCR Rate' || t.Subject == 'Needs Action: Insurance is Verified')
        {
            insuranceIds.add(t.WhatId);
            isRightTypeOfTask = true;   
        }
    }
    
    if(isRightTypeOfTask)
    {
        List<InsuranceVerificationForm__c> insuranceForms = [SELECT Id, Case__c, Case_Created_By_Id__c, Case_Owner_Id__c FROM InsuranceVerificationForm__c WHERE Id IN :insuranceIds];
        Map<Id, InsuranceVerificationForm__c> m = new Map<Id, InsuranceVerificationForm__c>(insuranceForms);
        for(Task t : Trigger.new)
        {
            if(insuranceIds.contains(t.WhatId))
            {
                Id caseId = m.get(t.WhatId).Case__c;
                Id caseOwnerId = m.get(t.WhatId).Case_Owner_Id__c;
                Id caseCreatorId = m.get(t.WhatId).Case_Created_By_Id__c;
            
                if(caseId != null)
                {
                    //reassign the task from VOB to the case
                    t.WhatId = caseId;
                    t.Type = 'Internal Process';
                    //set the reminder time to now
                    t.ReminderDateTime = datetime.now();
                    //see if the Case Owner is a queue, and if it is assign it to the creator
                    if(!groupIds.contains(caseOwnerId))
                        t.OwnerId = caseOwnerId;
                    else
                        t.OwnerId = caseCreatorID;
                }
            }
        }
    }
}