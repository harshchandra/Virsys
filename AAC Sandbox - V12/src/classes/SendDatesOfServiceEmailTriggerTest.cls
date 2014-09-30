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
private class SendDatesOfServiceEmailTriggerTest {

private static testMethod void TestDOSTrigger()
{
    Test.startTest();
    Facility__c f = new Facility__c();
    f.Name = 'FitRx';
    f.Facility_Internal_Email__c = 'boverlund@contactaac.com';
    insert f;
    
    Account a = new Account();
    a.FirstName = 'John';
    a.LastName = 'Doe';
    insert a;
    
    Case testCase = new Case();
    testCase.AccountId = a.Id;
    testCase.Treatment_Facility__c = 'FitRx';
    testCase.Treatment_Facility_Lookup__c = f.Id; 
    insert testCase;
    
    InsuranceVerificationForm__c insForm = new InsuranceVerificationForm__c();
    insForm.Case__c = testCase.Id;
		insert insForm;
   
    Utilization_Review__c ur = new Utilization_Review__c(
    TreatmentFacility__c = f.Id, 
    Case__c = testCase.Id,
    Completed_By__c = 'Test',
    Completed_Date__c = Date.today(),
    Diagnosis__c = '303.1',
    Pre_Cert_Company__c =  'Test Co',
    Pre_Cert_Company_Phone__c = '555-555-5555', 
    Reviewer_Name__c = 'Test Test',
    Reviewer_Phone__c = '555-555-1234'
    );
   
    upsert ur;
    
    
    Dates_of_Service__c d = dos(ur);
    insert d;
        
    
    System.assert(testCase != null);
    System.assert(ur != null);
    System.assert(d != null);
    Test.stopTest();
            
}
    public static Dates_of_Service__c dos(Utilization_Review__c ur)
    {
        Dates_of_Service__c d = new Dates_of_Service__c();
        d.Start_Date__c = Date.today();
        d.End_Date__c = Date.today();
        d.Authorization_Number__c = '1234x';
        d.Days_Per_Week__c = '5';
        d.Level_of_Care__c = 'DTX';
        d.Status__c = 'Approved';
        d.Total_Days_Authorized__c = 5;
        d.Utilization_Review_Form__c = ur.Id;
        return d;
    }   
}