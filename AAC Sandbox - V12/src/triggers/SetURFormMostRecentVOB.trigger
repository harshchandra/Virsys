trigger SetURFormMostRecentVOB on Utilization_Review__c (before update) {
    
    for(Utilization_Review__c u : trigger.new)
    {
        if(u.Case__c != null  && u.VOB__c == null)
        {
            if(u.Primary_Insurance_UR__c == true)
            {
                List<InsuranceVerificationForm__c> insuranceForms = [SELECT Id FROM InsuranceVerificationForm__c WHERE Case__c = :u.Case__c AND VerificationComplete__c = true AND IsSecondaryInsurance__c = false ORDER BY VerificationCompleted__c DESC];
                if(insuranceForms.size() > 0)
                {
                    u.VOB__c =  insuranceForms[0].Id;
                }
            }
            else
            {
                List<InsuranceVerificationForm__c> insuranceForms = [SELECT Id FROM InsuranceVerificationForm__c WHERE Case__c = :u.Case__c AND VerificationComplete__c = true AND IsSecondaryInsurance__c = true ORDER BY VerificationCompleted__c DESC];
                if(insuranceForms.size() > 0)
                {
                    u.VOB__c =  insuranceForms[0].Id;
                }
            }
        }
    }
    
}