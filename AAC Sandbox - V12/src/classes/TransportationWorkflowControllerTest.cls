@isTest
private class TransportationWorkflowControllerTest {
private static Account TestAccount;
private static Account PersonAccount;
private static Case TestCase;
private static Contact TestContact;
private static Transportation__c Trans;


private static void InitializeTestEntities()
  {
    TestAccount = new Account(Name ='TestAccount',Phone='1231231234'); 
    PersonAccount = new Account(FirstName='John',LastName='Doe',Phone='1231231234');
    insert TestAccount;
    insert PersonAccount;
    
    TestCase = new Case(Status='Case Opened',Treatment_Facility__c = 'Greenhouse', Origin='Phone',AccountId=PersonAccount.Id);
    insert TestCase;
    
    
    
    TestContact = new Contact(
      LastName = 'Doe', 
      AccountId = TestAccount.Id,
      Phone='1231231234'
    );
    insert TestContact;
    
    Trans = new Transportation__c(Case__c = TestCase.Id);
    insert Trans;

  }

public static testMethod void GenericTest() 
{
    InitializeTestEntities();
    
    ApexPages.StandardController controller = new ApexPages.StandardController(TestCase);
    
    Test.startTest();
    TransportationWorkflowController ext = new TransportationWorkflowController(controller);
    System.assert(ext.ParentCase != null);
    Test.stopTest();
}

public static testMethod void WorkflowTestButtonAction()
{
    InitializeTestEntities();
    
    ApexPages.StandardController controller = new ApexPages.StandardController(TestCase);
    
    Test.startTest();
    TransportationWorkflowController ext = new TransportationWorkflowController(controller);
    System.assert(ext.ButtonText == 'Request Transportation');
    PageReference page = ext.ButtonAction();
    Test.stopTest();
}

public static testMethod void WorkflowTestProperties()
{
    InitializeTestEntities();
    TestCase.Status = 'Case Opened';
    TestCase.Assessment_Approved_By__c = UserInfo.getUserId();
    TestCase.Transportation_Approved__c = true;
    TestCase.Payment_Arrangements_Approved__c = true;
    TestCase.Transportation_Status__c = 'Requested';
    update TestCase;
    Test.startTest();
    
    ApexPages.StandardController controller = new ApexPages.StandardController(TestCase);
    TransportationWorkflowController ext = new TransportationWorkflowController(controller);
    System.assert(ext.ButtonText == 'Update Transportation');
    
    TestCase.Transportation_Status__c = 'Requested';
    TestCase.Type_of_Travel__c = 'Fly';
    update TestCase;
    ext = new TransportationWorkflowController(controller);
    System.assert(ext.ButtonText == 'Update Transportation');
    
    TestCase.Transportation_Status__c = 'Requested';
    TestCase.Type_of_Travel__c = 'Drive in';
    update TestCase;
    ext = new TransportationWorkflowController(controller);
    System.assert(ext.ButtonText == 'Transportation Unavailable');
    
    
    User u = StandardTestUser();
    System.runAs(u)
    {
        ext = new TransportationWorkflowController(new ApexPages.StandardController(TestCase));
        //System.assert(ext.ButtonAction() == null);
    }
    
    TestCase.Transportation_Status__c = null;
    update TestCase;
    ext = new TransportationWorkflowController(new ApexPages.StandardController(TestCase));
    ext.TransportationRecord = null;
    ext.ParentCase = TestCase;
    System.assert(ext.ButtonText == 'Request Transportation');
    ext.ParentCase = null;
    ext.ButtonAction();

    
    Test.stopTest();
}

public static User StandardTestUser()
{
    // Setup test data      
    // This code runs as the system user
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    User u = new User(Alias = 'test1234', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles',State='', UserName='standarduserTransportation@testorg.com');
    return u;
}
}