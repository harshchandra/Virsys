trigger CreateLevelOfCareFormOnCaseAdmit on Case (after insert, after update) 
{
    Map<Id, Utilization_Review__c> forms = new Map<Id, Utilization_Review__c>();
    for(Utilization_Review__c u : [SELECT Id, Case__c FROM Utilization_Review__c WHERE Case__c IN : trigger.new])
    {
        forms.put(u.Case__c, u);
    }
    
    List<Utilization_Review__c> newForms = new List<Utilization_Review__c>();
    
    for(Case c : trigger.new)
    {
        if(c.Status == 'Admitted')
        {
            if(!forms.containsKey(c.Id))
            {
                Utilization_Review__c form = new Utilization_Review__c();
                form.Case__c = c.Id;
                //form.Completed_By__c = '';
                //form.Completed_Date__c ='';
                //form.Diagnosis__c = '';
                newForms.add(form);         
            }
        }
    }
    
    insert newForms;
}