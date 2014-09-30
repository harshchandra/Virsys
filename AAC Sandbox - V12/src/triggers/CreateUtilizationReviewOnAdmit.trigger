trigger CreateUtilizationReviewOnAdmit on Case (before update)
{
    List<Utilization_Review__c> urForms = new List<Utilization_Review__c>();
    for(Case c : trigger.new)
    {
	    if(c.Status == 'Admitted' && Trigger.oldMap.get(c.Id).Status != 'Admitted')
	    {
	    	  try
	        {
	            List<Utilization_Review__c> existingForms = [SELECT Id FROM Utilization_Review__c WHERE Case__c = :c.Id];
	            if(existingForms.size() <= 0)
	            {
	            	Utilization_Review__c ur = new Utilization_Review__c();
		            ur.Case__c = c.Id;
		            ur.TreatmentFacility__c = c.Treatment_Facility_Lookup__c;
		            ur.Completed_By__c = UserInfo.getName();
		            ur.Completed_Date__c = datetime.now();
		            urForms.add(ur);	
	            }
	        }
	        catch(Exception e)
	        {
	            
	        }
	    }
    }
    insert urForms;
}