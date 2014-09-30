@isTest
private class InsuranceVerificationTest
{
  private static Account TestAccount;
  private static Case TestCase;
  private static Contact TestContact;
  private static InsuranceVerificationForm__c TestForm;
  private static Client_Calculator__c TestCalc;
  private static Group TestGroup;
  
  private static void InitializeTestEntities()
  {
    TestAccount = new Account(
      Name='TestAccount',Phone='1231231234'
    );
    insert TestAccount;
    
    TestCase = new Case(
      Status = 'New',
      Origin = 'Phone',
      AccountId = TestAccount.Id
    );
    insert TestCase;
    
    TestContact = new Contact(
      LastName = 'Doe', 
      AccountId = TestAccount.Id
      ,Phone='1231231234'
    );
    insert TestContact;
    
    TestForm = new InsuranceVerificationForm__c(Case__c = TestCase.Id, ClientName__c = 'Test 1');
    insert TestForm;
    
    TestCalc = new Client_Calculator__c(Insurance_Verification_Form__c = TestForm.Id);
    insert TestCalc;
    
    TestGroup = new Group(Name = 'Test Group', Type = 'Regular');
    insert TestGroup;
  }
  
  public static testMethod void FormTestProperties() 
  {
    InitializeTestEntities();
    
    InsuranceVerificationForm__c form = new InsuranceVerificationForm__c();
    form.Case__c = TestCase.Id;
    form.ClientName__c = 'Test Client';
    insert form;

    ApexPages.StandardController controller = new ApexPages.StandardController(form);
    
    Test.startTest();  
       
    InsuranceVerificationFormController extension = new InsuranceVerificationFormController(controller);
    System.assert(extension.ParentCase != null);
    System.assert(extension.Form != null);
    System.assert(extension.FieldLabels != null);
    System.assert(extension.FieldHelpText != null);
    
    Test.stopTest();
  }
  
  public static testMethod void FormTestWorkflowSubmitButton()
  {
    Account wfAccount = new Account(Name = 'John Doe',Phone='1231231234');
    insert wfAccount;
    Case wfCase = new Case(AccountId = wfAccount.Id);
    insert wfCase;
    
      
    ApexPages.StandardController controller = new ApexPages.StandardController(wfCase);
    Test.startTest();
    InsuranceVerificationWorkflowController ext = new InsuranceVerificationWorkflowController(controller);
    //submit once since it doesnt exist
    ext.SubmitInsurance();
    //submit again should do a Resubmit
    ext.SubmitInsurance();
    
    
    Test.stopTest();
  }  

  
  public static testMethod void FormTestViewCalculator()
  {
    InitializeTestEntities();

    InsuranceVerificationForm__c form = TestForm;           
    
    form.SubstanceAbuseDTXCopay__c = 50;
    form.SubstanceAbuseDTXPercentage__c = 0;
    form.SubstanceAbuseIOPCopay__c = 0;
    form.SubstanceAbuseIOPPercentage__c = 0;
    form.SubstanceAbuseIPCopay__c = 0;
    form.SubstanceAbuseIPPercentage__c = 0;
    form.SubstanceAbuseOPCopay__c = 0;
    form.SubstanceAbuseOPPercentage__c = 0;
    form.SubstanceAbusePHPCopay__c = 0;
    form.SubstanceAbusePHPPercentage__c = 0;
    form.SubstanceAbuseRESCopay__c = 0;
    form.SubstanceAbuseRESPercentage__c = 0;
    form.SubstanceAbuseBenefitsCopay__c = 0;
    form.SubstanceAbuseBenefitsCopayMet__c = 0;
    form.SubstanceAbuseDTXLifetimeMax__c = 0;
    form.SubstanceAbuseBenefitsOutOfPocket__c = 0;
    form.SubstanceAbuseBenefitsOutOfPocketMet__c = 0;
    form.SubstanceAbuseDTXLifetimeMax__c = 0;
    upsert form;
    
    Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(Form);
    InsuranceVerificationFormController extension = new InsuranceVerificationFormController(controller); 
    extension.Form = form;
    extension.ViewCalculator();
    delete TestCalc;
    extension.ViewCalculator();
    Test.stopTest(); 
  }
  
  
  
  private static testMethod void FormTestResubmit()
  {
    InitializeTestEntities();
    TestForm.Insurance_Status__c = 'Returned to TC';
    update TestForm;
    TestCase.Insurance_Status__c = 'Returned to TC';
    TestCase.X2nd_Insurance_Status__c = 'Returned to TC';
    update TestCase;
    
    Test.startTest();
    ApexPages.StandardController controller = new ApexPages.StandardController(TestForm);
    InsuranceVerificationFormController extension = new InsuranceVerificationFormController(controller);    
    extension.Resubmit();
    TestForm.IsSecondaryInsurance__c = true;
    update TestForm;
    extension.Resubmit();
    
    Test.stopTest();
  }
  
  public static testMethod void FormTestTake()
  {
    InitializeTestEntities();
    
    InsuranceVerificationForm__c form = new InsuranceVerificationForm__c();
    form.Case__c = TestCase.Id;
    form.ClientName__c = 'Test Client';
    form.OwnerId = '005G0000002jZAKIA2';
    insert form;
    
    form = [SELECT Id,Case__c,ClientName__c,OwnerId FROM InsuranceVerificationForm__c WHERE Id = :form.Id];

    ApexPages.StandardController controller = new ApexPages.StandardController(form);
    
    Test.startTest();  

    InsuranceVerificationFormController extension = new InsuranceVerificationFormController(controller);
    
    extension.Form = null;
    System.assert(extension.ShowTakeButton == false);
    
    extension.Form = form;
    System.assert(extension.ShowTakeButton, 'Current UserId: ' + UserInfo.getUserId() + ' Form OwnerId: ' + form.OwnerId);
    
    extension.Take();
    System.assert(extension.ShowTakeButton == false);
    
    form = [SELECT Id,Case__c,ClientName__c,OwnerId FROM InsuranceVerificationForm__c WHERE Id = :form.Id];
    System.assert(form.OwnerId == UserInfo.getUserId());
    
    TestCase = [SELECT Id,Insurance_Status__c FROM Case WHERE Id = :TestCase.Id];
    System.assert(TestCase.Insurance_Status__c == 'In-Progress');
    
    Test.stopTest();
  }

  public static testMethod void FormTestRedirect()
  {
    InitializeTestEntities();
    
    InsuranceVerificationForm__c form = new InsuranceVerificationForm__c();
    form.Case__c = TestCase.Id;
    form.ClientName__c = 'Test Client';
    insert form;

    ApexPages.StandardController controller = new ApexPages.StandardController(form);
            
    Test.startTest();  

    InsuranceVerificationFormController extension = new InsuranceVerificationFormController(controller);
    
    PageReference expected = new PageReference('/' + TestCase.Id);            
    PageReference page = extension.Cancel();
    System.assert(page != null && expected != null && page.getUrl() == expected.getUrl(), 'Expected: ' + expected.getUrl() + ' Recieved: ' + page.getUrl());

    ApexPages.currentPage().getParameters().put('fromQueue', '1');
    expected = new PageReference('/a0K/o');     
    page = extension.Cancel();
    System.assert(page != null && expected != null && page.getUrl() == expected.getUrl(), 'Expected: ' + expected.getUrl() + ' Recieved: ' + page.getUrl());
    
    Test.stopTest();
  }
  
  public static testMethod void FormTestSavePrimary()
  {
    InitializeTestEntities();
    
    InsuranceVerificationForm__c form = new InsuranceVerificationForm__c();
    form.Case__c = TestCase.Id;
    form.ClientName__c = 'Test Client';
    insert form;

    ApexPages.StandardController controller = new ApexPages.StandardController(form);
    
    Test.startTest();  

    InsuranceVerificationFormController extension = new InsuranceVerificationFormController(controller);
    
    form.VerificationComplete__c = true;
    form.SummaryOfBenefits__c = 'Summary of Benefits Test';
    System.assert(extension.Save() != null);
    form = [SELECT Id,VerificationCompleted__c,SummaryOfBenefits__c FROM InsuranceVerificationForm__c WHERE Id = :form.Id];
    TestCase = [SELECT Id,Status,Insurance_Summary_of_Benefits__c,Insurance_Status__c,Primary_Insurance_Form__c FROM Case WHERE Id = :TestCase.Id];

    //System.assert(TestCase.Status == '2- Pending Completion of Assessment');
    System.Assert(TestCase.Insurance_Summary_of_Benefits__c == form.SummaryOfBenefits__c);
    System.Assert(TestCase.Insurance_Status__c == 'Verified');
    System.Assert(TestCase.Primary_Insurance_Form__c == form.Id);
    System.assert(form.VerificationCompleted__c != null);
    
    datetime dt = form.VerificationCompleted__c;
    extension.Save();
    System.assert(dt == form.VerificationCompleted__c);

    Test.stopTest();
  }
  
  
  public static testMethod void FormTestSaveSecondary()
  {
    InitializeTestEntities();
    
    InsuranceVerificationForm__c form = new InsuranceVerificationForm__c();
    form.Case__c = TestCase.Id;
    form.ClientName__c = 'Test Client';
    form.IsSecondaryInsurance__c = true;
    insert form;

    ApexPages.StandardController controller = new ApexPages.StandardController(form);
    
    Test.startTest();  

    InsuranceVerificationFormController extension = new InsuranceVerificationFormController(controller);
    
    form.VerificationComplete__c = true;
    form.SummaryOfBenefits__c = 'Summary of Benefits Test';
    System.assert(extension.Save() != null);

    form = [SELECT Id,VerificationCompleted__c,SummaryOfBenefits__c FROM InsuranceVerificationForm__c WHERE Id = :form.Id];
    TestCase = [SELECT Id,Status,Insurance_Summary_of_Benefits__c,X2nd_Summary_of_Benefits__c,Insurance_Status__c,X2nd_Insurance_Status__c,Secondary_Insurance_Form__c,Primary_Insurance_Form__c FROM Case WHERE Id = :TestCase.Id];

    //System.assert(TestCase.Status == '2- Pending Completion of Assessment');
    System.Assert(TestCase.X2nd_Summary_of_Benefits__c == form.SummaryOfBenefits__c);
    System.Assert(TestCase.X2nd_Insurance_Status__c == 'Verified');
    System.Assert(TestCase.Secondary_Insurance_Form__c == form.Id);
    System.assert(form.VerificationCompleted__c != null);

    
    datetime dt = form.VerificationCompleted__c;
    extension.Save();
    System.assert(dt == form.VerificationCompleted__c);

    Test.stopTest();
  }

  
  public static testMethod void FormTestCancel()
  {
    InitializeTestEntities();
    
    InsuranceVerificationForm__c form = new InsuranceVerificationForm__c();
    form.Case__c = TestCase.Id;
    form.ClientName__c = 'Test Client';
    insert form;

    ApexPages.StandardController controller = new ApexPages.StandardController(form);
    
    Test.startTest();  

    InsuranceVerificationFormController extension = new InsuranceVerificationFormController(controller);
    System.assert(extension.Cancel() != null);
    
    Test.stopTest();
  }
  
  public static testMethod void FormTestReturnToTC()
  {
    InitializeTestEntities();
    
    
    InsuranceVerificationForm__c form = new InsuranceVerificationForm__c();
    form.Case__c = TestCase.Id;
    form.ClientName__c = 'Test Client';
    insert form;

    ApexPages.StandardController controller = new ApexPages.StandardController(form);
    
    Test.startTest();  

    InsuranceVerificationFormController extension = new InsuranceVerificationFormController(controller);
    System.assert(extension.ReturnToTC() != null);    
    
    form = [SELECT Id,VerificationCompleted__c,VerificationComplete__c FROM InsuranceVerificationForm__c WHERE Id = :form.Id];
    System.assert(form.VerificationCompleted__c == null);
    System.assert(form.VerificationComplete__c == false);

    TestCase = [SELECT Id,Insurance_Status__c FROM Case WHERE Id = :TestCase.Id];
    System.assert(TestCase.Insurance_Status__c == 'Returned to TC');

    // Code coverage will be hit for the mail portion, but not really sure how to actually test it.
    
    Test.stopTest();
  }
  
  
}