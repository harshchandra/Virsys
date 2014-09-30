@isTest
private class CallProcessorControllerTest {

		private static Account ParentAccount;
		private static Account PersonAccount;
		private static Lead TestLead;
		private static Contact TestContact;
		
		private static void InitializeTests()
		{
				ParentAccount = new Account();
        ParentAccount.Name = 'Test Business';
        ParentAccount.DID__c = '1111111111';
        ParentAccount.Phone = '1111111111';
        insert ParentAccount;
        
        PersonAccount = new Account();
        PersonAccount.FirstName = 'Test';
        PersonAccount.LastName = 'Test';
        PersonAccount.How_Did_Caller_Get_Our_Number__c = 'Test';
        PersonAccount.Phone = '1111231234';
        PersonAccount.BillingState = 'TN';
        PersonAccount.CID__c = '1111231234';
        insert PersonAccount;
        
        TestLead = new Lead();
        TestLead.Company = 'Test';
        TestLead.FirstName = 'Test1';
        TestLead.LastName = 'Test2';
        TestLead.Phone = '1111231234';
        TestLead.Email = 'test@test.com';
        insert TestLead;
        
        TestContact = new Contact();
        TestContact.FirstName = 'Test';
        TestContact.LastName = 'Test';
        TestContact.Phone = '1111231234';
        insert TestContact;
		}
    static testMethod void CallProcessorTesting() 
    {
        InitializeTests();
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('mockcallprocessorresponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        PageReference ref = new PageReference('apex/Pages/CallProcessor?ANI=1111231234&DNIS=1111111111');
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, mock);
        Test.setCurrentPageReference(ref);
        CallProcessorController controller = new CallProcessorController();
        controller.CallDetails();
        Test.stopTest();
        
    }
}