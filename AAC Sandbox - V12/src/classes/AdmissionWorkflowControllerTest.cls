@isTest
private class AdmissionWorkflowControllerTest {
private static Account TestAccount;
private static Account PersonAccount;
private static Case TestCase;
private static Contact TestContact;

private static void InitializeTestEntities()
  {
	TestAccount = new Account(Name ='TestAccount',Phone='1231231234'); 
	PersonAccount = new Account(FirstName='John',LastName='Doe',Phone='1231231234');
	insert TestAccount;
	insert PersonAccount;
	
	TestCase = new Case(Status='Case Opened', Origin='Phone',AccountId=PersonAccount.Id);
	insert TestCase;
	
	TestContact = new Contact(
      LastName = 'Doe', 
      AccountId = TestAccount.Id
    );
    insert TestContact;

  }

public static testMethod void GenericTest() 
{
	InitializeTestEntities();
	
	ApexPages.StandardController controller = new ApexPages.StandardController(TestCase);
	
	Test.startTest();
	AdmissionWorkflowController ext = new AdmissionWorkflowController(controller);
	System.assert(ext.ParentCase != null);
	Test.stopTest();
}

public static testMethod void WorkflowTestButtonAction()
{
	InitializeTestEntities();
	TestCase.Status = '4- Pending Flight Travel Booking';
	update TestCase;
	
	ApexPages.StandardController controller = new ApexPages.StandardController(TestCase);
	
	Test.startTest();
	AdmissionWorkflowController ext = new AdmissionWorkflowController(controller);
	System.assert(ext.ButtonText == 'Complete Admission');
	PageReference expected = null;
	PageReference page = ext.ButtonAction();
	System.assert(ext.ButtonText == 'Admission Processed');
	Test.stopTest();
}

public static testMethod void WorkflowTestProperties()
{
	InitializeTestEntities();
	TestCase.Status = 'Case Opened';
	TestCase.Assessment_Approved_By__c = UserInfo.getUserId();
	TestCase.Transportation_Approved__c = true;
	TestCase.Payment_Arrangements_Approved__c = true;
	update TestCase;
	Test.startTest();
	
	ApexPages.StandardController controller = new ApexPages.StandardController(TestCase);
	
	
	AdmissionWorkflowController ext = new AdmissionWorkflowController(controller);
	System.assert(ext.ShowAdmissionApprovedPanel == true);
	
	
	TestCase.Status = '4- Pending Flight Travel Booking';
	update TestCase;
	ext = new AdmissionWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ShowAdmissionApprovedPanel == false);
	
	
	ext.UpdatePaymentSetting();
	System.assert(ext.PaymentChecked == false);
	
	ext.UpdatePaymentSetting();
	System.assert(ext.PaymentChecked == true);
	 
	System.assert(TestCase.Payment_Arrangements_Approved__c == ext.PaymentChecked);
	
	
	ext.UpdateTransportationSetting();
	System.assert(ext.TransportationChecked == false);
	
	ext.UpdateTransportationSetting();
	System.assert(ext.TransportationChecked == true);
	
	System.assert(TestCase.Transportation_Approved__c == ext.TransportationChecked);
	
	System.assert(ext.ShowSupervisorPanel == true);
	
	System.assert(ext.ShowApprovalButton == true);
	
	TestCase.Status = 'Case Opened';
	update TestCase;
	ext = new AdmissionWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ShowApprovalButton == false);
	
	Id testId = null;
	System.assert(ext.QueueId('CA') != testId);
	
	
	User u = StandardTestUser();
	System.runAs(u)
	{
		ext = new AdmissionWorkflowController(new ApexPages.StandardController(TestCase));
		System.assert(ext.ShowSupervisorPanel == false);
		System.assert(ext.ButtonAction() == null);
	}
	
	
	TestCase.Payment_Arrangements_Approved__c = false;
	TestCase.Transportation_Approved__c = false;
	TestCase.Status = 'Case Opened';
	update TestCase;
	ext = new AdmissionWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ShowApprovalOptions == false);
	
	TestCase.Payment_Arrangements_Approved__c = false;
	TestCase.Transportation_Approved__c = true;
	TestCase.Status = '3- Pending Assessment Review & Approval';
	update TestCase;
	ext = new AdmissionWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ShowApprovalOptions == true);
	
	System.assert(ext.SupervisorButtonAction() == null);
	TestCase.Detox_Location__c ='Greenhouse';
	TestCase.Treatment_Facility__c = 'Greenhouse';
	update TestCase;
	ext = new AdmissionWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.SupervisorButtonAction() == null);
	
	TestCase.Status = 'Case Opened';
	update TestCase;
	ext = new AdmissionWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.SupervisorButtonAction() == null);
	
	System.assert(ext.QueueId('JP') == null);
	
	
	
	Test.stopTest();
}

public static User StandardTestUser()
{
	// Setup test data      
	// This code runs as the system user
    Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
    User u = new User(Alias = 'test123', Email='standarduser@testorg.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles',State='', UserName='standarduserAdmission@testorg.com');
    return u;
}
}