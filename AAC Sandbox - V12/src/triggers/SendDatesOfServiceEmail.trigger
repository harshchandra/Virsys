trigger SendDatesOfServiceEmail on Dates_of_Service__c (before insert, before update) 
{
    Set<Id> urFormIds = new Set<Id>();
    for(Dates_of_Service__c d : trigger.new)
    {
        if(!urFormIds.contains(d.Utilization_Review_Form__c))
            urFormIds.add(d.Utilization_Review_Form__c);
    }
    
    
    Map<Id, Facility__c> Facilities = new Map<Id, Facility__c>([SELECT Id,Name,Facility_Internal_Email__c FROM Facility__c]);
    Map<Id, Utilization_Review__c> urForms = new Map<Id, Utilization_Review__c>([SELECT Id, Name, TreatmentFacility__c FROM Utilization_Review__c WHERE Id IN :urFormIds]);
    for(Dates_of_Service__c d : trigger.new)
    {
        if(urForms.containsKey(d.Utilization_Review_Form__c))
        {
            Id fId = urForms.get(d.Utilization_Review_Form__c).TreatmentFacility__c;
            if(Facilities.containsKey(fId))
            {
                d.Facility_Internal_Email__c = Facilities.get(fId).Facility_Internal_Email__c;
            }
        }
    }
}