@isTest
private class TransportationFormExtTest {
    public static testMethod void myTest() {
        Account myBusinessAccount = new Account();
        myBusinessAccount.Name = 'TestBusiness';
        myBusinessAccount.RecordTypeId = '012G000000178KZIAY';
        myBusinessAccount.Phone = '1231231234';
        insert myBusinessAccount;
        
        Account myPersonAccount = new Account();
        myPersonAccount.FirstName = 'John';
        myPersonAccount.LastName = 'Doe';
        myPersonAccount.Phone = '1231231234';
        //myPersonAccount.BillingStreet = '123 fake street';
        myPersonAccount.BillingCity = 'Fake City';
        myPersonAccount.BillingState = 'CA';
        myPersonAccount.BillingPostalCode = '12345';
        //myPersonAccount.Date_of_birth__pc = datetime.now().date();
        //myPersonAccount.Demographics__c = 'Male';
        //myPersonAccount.How_did_caller_get_our_phone_number__c = 'Internet';
        
        insert myPersonAccount;
        
        Case myCase = new Case();
        myCase.AccountId = myPersonAccount.Id;
        myCase.Gender__c = 'Male';
        myCase.Funding_Type__c = 'Insurance';
        insert myCase;
        
        InsuranceVerificationForm__c myInsuranceForm = new InsuranceVerificationForm__c();
        myInsuranceForm.Case__c = myCase.Id;
        myInsuranceForm.VerificationComplete__c = true;
        //myInsuranceForm.Benefit_Type__c = 'In Network';
        //myInsuranceForm.InsuranceCompany__c = 'Testco';
        //myInsuranceForm.InsuredRelationshipToClient__c = 'Self';
        //myInsuranceForm.InsuredName__c = 'John Doe';
        //myInsuranceForm.InsuredEmployer__c = 'NA';
        //myInsuranceForm.InsuredDateOfBirth__c = datetime.now().date();
        //myInsuranceForm.InsurancePhoneNumber__c = '1234561234';
        //myInsuranceForm.InsuranceID__c = '123ABC';
        insert myInsuranceForm;
        
        Assessment__c myAssessment = new Assessment__c();
        myAssessment.Case__c = myCase.Id;
        //myAssessment.Assessment_Status__c = 'Approved';
        myAssessment.fitrx_height__c = '5\'10';
        //myAssessment.fitrx_weight__c = 120;
        myAssessment.sah_substance1__c = 'Food';
        insert myAssessment;
        
        Transportation__c myTransportation = new Transportation__c();
        myTransportation.Case__c = myCase.Id;
        
        Test.startTest();
        ApexPages.Standardcontroller controller = new ApexPages.StandardController(myTransportation);
        TransportationFormExt ext = new TransportationFormExt(controller);
        
        Test.stopTest();
        
        
    }
}