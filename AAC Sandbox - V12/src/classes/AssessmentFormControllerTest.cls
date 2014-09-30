/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AssessmentFormControllerTest {
private static Account TestAccount;
private static Account PersonAccount;
private static Case TestCase;
private static Contact TestContact;
private static Assessment__c TestAssessment;

private static void InitializeTestEntities()
  {
	TestAccount = new Account(Name ='TestAccount',Phone='1231231234'); 
	PersonAccount = new Account(FirstName='John',LastName='Doe');
	insert TestAccount;
	insert PersonAccount;
	
	TestCase = new Case(Status='Case Opened', Origin='Phone',AccountId=PersonAccount.Id);
	insert TestCase;
	
	TestContact = new Contact(
      LastName = 'Doe', 
      AccountId = TestAccount.Id,
      Phone='1231231234'
    );
    insert TestContact;
    
    TestAssessment = new Assessment__c(Case__c = TestCase.Id);
    insert TestAssessment;
  }


    static testMethod void AssessmentFormControllerTest1() {
        InitializeTestEntities();
        ApexPages.Standardcontroller controller = new ApexPages.StandardController(TestAssessment);
        Test.startTest();
        AssessmentFormController ext = new AssessmentFormController(controller);
        System.assert(ext.ParentCase != null);
        System.assert(ext.Form != null);
    	System.assert(ext.FieldLabels != null);
    	System.assert(ext.FieldHelpText != null);
        test.stopTest();
    }
    
    static testMethod void AssessmentTestWorkflow()
    {
    	InitializeTestEntities();
    	TestAssessment.Assessment_Status__c = 'New';
    	update TestAssessment;
    	
    	ApexPages.Standardcontroller controller = new ApexPages.StandardController(TestAssessment);
        Test.startTest();
        AssessmentFormController ext = new AssessmentFormController(controller);
        System.assert(ext.ParentCase != null);
        ext.SubmitAssessment();
        ext.ApproveAssessment();
        ext.RejectAssessment();
        ext.TakeAssessment();
        ext.Save();
        ext.Cancel();
        
        Test.stopTest();
    }
    static testMethod void testPdfGenerator() 
    {
 		InitializeTestEntities();
	    PageReference pref = Page.AssessmentViewer;
	    pref.getParameters().put('id',TestAssessment.id);
	    Test.setCurrentPage(pref);
	 
      	ApexPages.Standardcontroller controller = new ApexPages.StandardController(TestAssessment);
        AssessmentFormController ext = new AssessmentFormController(controller);
        Test.startTest();
        ext.ApproveAssessment();
	    // assert that an attachment exists for the record
	    System.assertEquals(1,[select count() from attachment where parentId = :TestAssessment.id]); 
	    Test.stopTest(); 
  	}
    
    
}