@isTest
private class TBN_SubmitAndPrintBatchControllerTest {

    static testMethod void myUnitTest() {
      	Facility__c objFac = new Facility__c();
        objFac.Name = 'TestFacility';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        
        Case objCase = new Case();
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
        objBA.Facility__c = objFac.Id;
        insert objBA;
        
        Dates_of_Service__c objDOS = new Dates_of_Service__c();
        objDOS.Level_of_Care__c = 'IR';
        objDOS.Status__c = 'Selected';
        objDOS.Bill_Status__c = 'Selected';
        objDOS.Utilization_Review_Form__c = objUR.Id;
        objDOS.Start_Date__c = Date.today().addDays(-2);
        objDOS.End_Date__c = Date.today().addDays(-2);
        objDOS.Day_of_Week__c = '5';
        objDOS.Total_Days_Authorized__c = 4;
        objDOS.Authorization_Number__c = '123';
        objDOS.CM__c = 'Test CM';
        objDOS.Date_of_Review__c = Date.Today();
        objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
        objDOS.Level_of_Care_Description__c = 'Test';
        insert objDOS;
        
        TBN_SubmitAndPrintBatchController objPrintBatch = new TBN_SubmitAndPrintBatchController();
        objPrintBatch.sortExpression = 'Facility__c';
        objPrintBatch.getSortDirection();
        objPrintBatch.saveData();
        objPrintBatch.sort();
        objPrintBatch.ReProcess();
        
    }
}