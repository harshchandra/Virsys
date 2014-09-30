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
private class TestCreateAlumniLeadTrigger {

    private static testMethod void TestCreateAlumniTrigger() 
    {
    	Account a = new Account();
    	a.FirstName = 'John';
    	a.LastName = 'Doe';
    	a.PersonEmail = 'test@test.com';
    	a.Phone = '5555551234';
    	a.BillingStreet = '123 fakestreet';
    	a.BillingCity = 'TestCity';
    	a.BillingState = 'CA';
    	a.BillingCountry = 'USA';
    	a.BillingPostalCode = '12345';
    	insert a;
    	
    	Facility__c f = new Facility__c();
    	f.Name = 'Test fac';
    	insert f;
    	
        Case c = new Case();
        c.AccountId = a.Id;
        c.Treatment_Facility_Lookup__c = f.Id;
        c.Facility_Admission_Date__c = datetime.now().date();
        c.Facility_Date_of_Discharge__c = datetime.now().date();
        insert c;
        
        
        c = [SELECT Id,Account.FirstName,Account.LastName, Status FROM Case WHERE Id = :c.Id];
        c.Status = 'Discharged';
        update c;
    
       
        
    }
}