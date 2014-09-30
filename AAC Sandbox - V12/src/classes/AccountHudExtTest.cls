@isTest
private class AccountHudExtTest {

    public static testMethod void AccoundHudTest() 
    {
        Account a = new Account();
        a.Phone = '1231231234';
        a.FirstName = 'Test';
        a.LastName = 'Test';
        a.PersonEmail = 'test@test.com';
        insert a;
        Support_Group_Member__c spm = new Support_Group_Member__c();
        spm.Name = 'Test Test';
        spm.Home_Phone__c = '1231231234';
        spm.Relationship_To_Client__c = 'Brother';
        spm.Authorized_on_Release_Form__c = false;
        spm.Person_Account__c = a.Id;
        insert spm;
        Test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(a);
        AccountHudExt ext = new AccountHudExt(controller);
        Test.stopTest();
    }
}