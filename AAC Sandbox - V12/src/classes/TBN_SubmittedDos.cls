@isTest
private class TBN_SubmittedDos {

    static testMethod void myUnitTest() {
    	
    	Facility__c objFac = new Facility__c();
        objFac.Name = 'TestFacility';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
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
        
        Bill_Amounts__c objBA = new Bill_Amounts__c();
        objBA.Level_of_Care__c = 'IR';
        objBA.Amount__c = 200;
        insert objBA;
        
        Dates_of_Service__c objDOS = new Dates_of_Service__c();
        objDOS.Level_of_Care__c = 'IR';
        objDOS.Status__c = 'submitted';
        objDOS.Utilization_Review_Form__c = objUR.Id;
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
        insert objDOS;
        system.debug('******************objDOS********************'+objDOS);
        system.debug('******************objDOS**********Patient__c**********'+objDOS.Patient__c);
        ApexPages.currentPage().getParameters().put('patient', 'Acc');
        TBN_Submitted_DOS objClass = new TBN_Submitted_DOS();
        objClass.sortExpression = 'Level_of_Care__c';
        objClass.sort();
        objClass.getSortDirection();
        objClass.setSortDirection('ASC');
    	
        
    }
}