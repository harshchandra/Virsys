@isTest
private class DatesOfServiceControllerTests {
	private static Account TestBusinessAccount;
	private static Account TestPersonAccount;
	private static Case TestCase;
	private static Contact TestContact;
	private static Assessment__c TestAssessment;
	private static InsuranceVerificationForm__c TestInsurance;
	private static Utilization_Review__c TestUtilizationReview;
	private static Dates_of_Service__c TestDatesOfService;
	
	private static void InitializeTest()
	{
		TestBusinessAccount = new Account(Name ='TestParentAccount',Phone='1231231234'); 
		TestPersonAccount = new Account(FirstName='John',LastName='Doe');
		insert TestBusinessAccount;
		insert TestPersonAccount;
		
		TestCase = new Case(Status='Case Opened', Origin='Phone',AccountId=TestPersonAccount.Id);
		insert TestCase;
		
		TestContact = new Contact(
	      LastName = 'Doe', 
	      AccountId = TestBusinessAccount.Id,
	      Phone='1231231234'
	    );
	    insert TestContact;
	    
	    TestAssessment = new Assessment__c(Case__c = TestCase.Id);
	    insert TestAssessment;
	    
	    TestInsurance = new InsuranceVerificationForm__c(Case__c = TestCase.Id);
	    insert TestInsurance;
	    
	    TestUtilizationReview = new Utilization_Review__c(Case__c = TestCase.Id, VOB__c = TestInsurance.Id, Completed_By__c = 'User1', Completed_Date__c = DateTime.now().date());
	    insert TestUtilizationReview;
	    
	    TestDatesOfService = new Dates_of_Service__c(Total_Days_Authorized__c = 5, Utilization_Review_Form__c = TestUtilizationReview.Id, Start_Date__c = DateTime.now().date(), End_Date__c = DateTime.now().addDays(1).date(), Level_of_Care__c = 'DTX');
	    insert TestDatesOfService;

	}
	static testMethod void TestDatesOfService()
	{
		InitializeTest();
		Dates_of_Service__c d = new Dates_of_Service__c();
		d.Utilization_Review_Form__c = TestUtilizationReview.Id;
		d.Authorization_Number__c = '123';
		d.CM__c = 'Test CM';
		d.Date_of_Review__c = DateTime.now().date();
		d.Days_Per_Week__c = '3';
		d.Start_Date__c = DateTime.now().addDays(1).date();
		d.End_Date__c = DateTime.now().addDays(5).date();
		d.Level_of_Care__c = 'DTX';
		d.Status__c = 'Approved';
		d.Total_Days_Authorized__c = 5;
		
    ApexPages.Standardcontroller controller = new ApexPages.StandardController(d);
    Test.startTest();
    DatesOfServiceController ext = new DatesOfServiceController(controller);
    ext.Monday = true;
    ext.Tuesday = true;
    ext.Wednesday = true;
    ext.Thursday = true;
    ext.Friday = true;
    ext.Saturday = true;
    ext.Sunday = true;
    ext.SetDaysOfWeekVisibility();
    
    System.assert(ext.Form != null);
			ext.save();
			
    test.stopTest();
		
	}
    static testMethod void TestSorting(){
    	InitializeTest();
        List<Account> accList = [select Name,AccountNumber from Account limit 100];
        DatesOfServiceController.sortList(accList,'Name', 'ASC');
        String lastValue = '';
        String currentValue = '';        
        for (Account acc : accList) 
        {
               currentValue = acc.Name;
               System.assertEquals(currentValue.compareTo(lastValue)>=0, true);
        }
        lastValue = currentValue;
     }
}