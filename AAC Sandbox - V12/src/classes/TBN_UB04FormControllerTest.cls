@isTest
private class TBN_UB04FormControllerTest {

    static testMethod void myUnitTest() {
      
 	Claim__c objClaim=new Claim__c();
  	objClaim.Status__c='submitted';
  	objClaim.Facility__c='TestFacility';
  	objClaim.Patient__c='testAccount';
  	insert objClaim;
      
  Facility__c objFac = new Facility__c();
  objFac.Name = objClaim.Facility__c;
  objFac.Desired_Capacity__c = 250;
  insert objFac;
	  
	Account objAcc = new Account();
    objAcc.Name = objClaim.Patient__c;
    insert objAcc;
      
	  
	Case objCase = new Case();
    objCase.AccountId = objAcc.Id;
    insert objCase;
      
    Utilization_Review__c objUR = new Utilization_Review__c();
    objUR.TreatmentFacility__c = objFac.Id;
    objUR.Completed_By__c = 'Test User';
    objUR.Completed_Date__c = Datetime.now();  
    objUR.Case__c = objCase.Id;
    insert objUR;
    
	Dates_of_Service__c objDOS = new Dates_of_Service__c();
    objDOS.Level_of_Care__c = 'IR';
    objDOS.Status__c = 'submitted';
    objDOS.Start_Date__c = Date.today().addDays(-2);
    objDOS.End_Date__c = Date.today().addDays(-1);
    objDOS.Day_of_Week__c = '5';
    objDOS.Total_Days_Authorized__c = 4;
    objDOS.Authorization_Number__c = '123';
    objDOS.CM__c = 'Test CM';
    objDOS.Date_of_Review__c = Date.Today();
    objDOS.Level_of_Care_Description__c = 'Test';
    objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
    objDOS.Amount__c = 250;
    objDOS.Claim__c=objClaim.Id;
    objDOS.Utilization_Review_Form__c = objUR.Id;
    insert objDOS;
    
    
	System.debug('---claimId--'+objClaim.Id); 
    ApexPages.currentPage().getParameters().put('claim',objClaim.Id);  
    TBN_UB04FormController  obj=new TBN_UB04FormController ();
    }
}