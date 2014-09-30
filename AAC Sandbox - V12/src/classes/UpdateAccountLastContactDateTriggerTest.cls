@isTest
private class UpdateAccountLastContactDateTriggerTest {

    static testMethod void TestUpdateAccountLastContactDateTrigger() 
    {
    	Test.StartTest();
        Account a = new Account();
        a.Name = 'Test Co';
        insert a;
        
        Task t = new Task();
        t.ActivityDate = datetime.now().date();
        t.Status = 'Completed';
        t.WhatId = a.Id;
        t.Subject = 'Call';
        insert t;
        
        Account acc = [SELECT Id, Last_Contact_Date__c FROM Account WHERE Id = :a.Id];
        system.assert(acc.Last_Contact_Date__c == datetime.now().date());
        Test.StopTest();
    }
}