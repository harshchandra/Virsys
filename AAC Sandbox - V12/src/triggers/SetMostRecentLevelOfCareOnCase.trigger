trigger SetMostRecentLevelOfCareOnCase on Dates_of_Service__c (after insert, after update) 
{
    Map<Id, string> UrFormLocMap = new Map<Id, string>();
    List<Case> cases = new List<Case>();
    
    for(Dates_of_Service__c dos : trigger.new)
    {
        if(dos.Utilization_Review_Form__c != null && dos.Level_of_Care__c != '' && dos.Level_of_Care__c != null)
        {
            UrFormLocMap.put(dos.Utilization_Review_Form__c, dos.Level_of_Care__c);
        }
    }

    for(Utilization_Review__c ur : [SELECT Id, Case__c FROM Utilization_Review__c WHERE Id IN :UrFormLocMap.keySet()])
    {
        List<Dates_of_Service__c> dos = [SELECT Id, Level_of_Care__c, End_Date__c FROM Dates_of_Service__c WHERE Utilization_Review_Form__c = :ur.Id ORDER BY End_Date__c DESC LIMIT 1];
        
        Case c = new Case();
        c.Id = ur.Case__c;
        c.Most_Recent_Level_of_Care__c = dos[0].Level_of_Care__c;
        cases.add(c);   
    }
    
    update cases;
}