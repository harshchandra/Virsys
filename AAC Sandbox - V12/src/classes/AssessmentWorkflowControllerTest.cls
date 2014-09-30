@isTest
private class AssessmentWorkflowControllerTest {
private static Account TestAccount;
private static Account PersonAccount;
private static Case TestCase;
private static Contact TestContact;
private static Group TestGroup;
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
      ,Phone='1231231234'
    );
    insert TestContact;
    
    TestGroup = new Group();
    TestGroup.Type = 'Queue';
    TestGroup.Name = 'A&P Placement Queue - CA';
    TestGroup.Email = 'boverlund@contactaac.com';
    insert TestGroup;

  }

public static testMethod void GenericTest() 
{
	InitializeTestEntities();
	
	ApexPages.StandardController controller = new ApexPages.StandardController(TestCase);
	
	Test.startTest();
	AssessmentWorkflowController ext = new AssessmentWorkflowController(controller);
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
	AssessmentWorkflowController ext = new AssessmentWorkflowController(controller);
	System.assert(ext.ButtonText == 'Required Fields Missing');
	TestCase.Status = '1- Pending Verification of Benefits';
	MakeTestCaseInvalid();
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ButtonText == 'Submit Assessment');
	
	MakeTestCaseValid();
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ButtonText == 'Submit Assessment');
	
	
	TestCase.Status = '3';
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ButtonText == 'Assessment Submitted');
	
	TestCase.Status = 'Case Opened';
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ButtonAction() == null);
	
	Test.stopTest();
}

public static void MakeTestCaseValid()
{
	TestCase.Funding_Type__c = 'Insurance';
	TestCase.FitRx_Candidate__c = 'No';
	TestCase.Substance_1__c = 'Test';
	TestCase.X1st_Policy_Company__c = 'Test';
	TestCase.Employment_Status__c = 'Employed';
	TestCase.Employer_Name__c = 'Test Employer';
	
}
public static void MakeTestCaseInvalid()
{
	TestCase.Funding_Type__c = 'Private Pay';
	TestCase.Employment_Status__c = 'Employed';
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
	
	
	AssessmentWorkflowController ext = new AssessmentWorkflowController(controller);
	System.assert(ext.ShowAssessmentApprovedPanel == true);
	
	
	TestCase.Status = '3- Pending Assessment Review & Approval';
	TestCase.Assessment_Approved_By__c = null;
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ShowAssessmentApprovedPanel == false);
	
	System.assert(ext.ShowSupervisorPanel == true);
	
	System.assert(ext.ShowApprovalButton == true);
	
	TestCase.Status = 'Case Opened';
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ShowApprovalButton == false);
	
	Id testId = null;
	System.assert(ext.QueueId('CA') != testId);
	
	
	User u = StandardTestUser();
	System.runAs(u)
	{
		ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
		System.assert(ext.ShowSupervisorPanel == false);
		System.assert(ext.ButtonAction() == null);
		u.State = 'CA';
		update u;
		ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
		System.assert(ext.ButtonAction() == null);
	}
	
	
	TestCase.Payment_Arrangements_Approved__c = false;
	TestCase.Transportation_Approved__c = false;
	TestCase.Status = 'Case Opened';
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ShowApprovalOptions == false);
	
	TestCase.Payment_Arrangements_Approved__c = false;
	TestCase.Transportation_Approved__c = true;
	TestCase.Status = '3- Pending Assessment Review & Approval';
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.ShowApprovalOptions == true);
	
	System.assert(ext.SupervisorButtonAction() == null);
	TestCase.Detox_Location__c ='Greenhouse';
	TestCase.Treatment_Facility__c = 'Greenhouse';
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.SupervisorButtonAction() == null);
	
	TestCase.Status = 'Case Opened';
	update TestCase;
	ext = new AssessmentWorkflowController(new ApexPages.StandardController(TestCase));
	System.assert(ext.SupervisorButtonAction() == null);
	
	System.assert(ext.QueueId('JP') == null);
	
	
	
	
	
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
      TimeZoneSidKey='America/Los_Angeles',State='', UserName='standarduserAssessment@testorg.com');
    return u;
}
}