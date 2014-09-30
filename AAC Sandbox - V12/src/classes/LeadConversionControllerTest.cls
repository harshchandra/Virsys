@isTest
private class LeadConversionControllerTest 
{
	
    public static testMethod void InitializeTest() 
    {
    	Account ga = new Account();
    	ga.Name = 'GENERAL CATCHALL';
    	ga.Phone = '1231231234';
    	ga.BillingState = 'TN';
    	insert ga;
    	Account wf = new Account();
    	wf.Name = 'Web Form or Chat';
    	wf.Phone = '1231231234';
    	wf.BillingState = 'TN';
    	insert wf;
    	
    	Lead l = new Lead();
    	l.Description = 'Test';
    	l.LeadSource = 'Test';
    	l.Email = 'test@test.com';
    	l.Phone = '1231231234';
    	l.FirstName = 'Test';
    	l.LastName = 'Test';
    	l.Website = 'www.test.com';
    	l.State = 'TN';
    	l.Status = 'New';
    	l.How_Did_Caller_Get_Our_Number__c = 'Test';
    	l.How_Did_You_Hear_About_AAC__c = 'Test';
    	l.How_Did_You_Hear_About_AAC_Description__c = 'Test';
    	insert l;

    	Test.startTest();
    	ApexPages.StandardController controller = new ApexPages.StandardController(l);
    	LeadConversionController ext = new LeadConversionController(controller);
    	ext.ConvertLead();
    	Test.stopTest();
    }
}