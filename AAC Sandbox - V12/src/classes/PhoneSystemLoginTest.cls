@IsTest
private with sharing class PhoneSystemLoginTest {

    public static testMethod void test()
    {       
        PhoneSystemLogin__c psl1 = new PhoneSystemLogin__c();
        psl1.Timestamp__c = datetime.newInstance(2013, 7, 10, 12, 30, 2);        
        insert psl1;
        
        IncomingCall__c ic1 = new IncomingCall__c();
        ic1.PhoneSystemLogin__c = psl1.Id;
        ic1.Length__c = 20;
        ic1.Timestamp__c = datetime.newInstance(2013, 7, 10, 12, 35, 17); 
        ic1.Phone__c = '100200300';
        ic1.Identifier__c = 'abc';
        insert ic1;
        
        PhoneSystemLogin__c psl2 = [SELECT CallsNewTemp__c, CallsNewLengthTemp__c FROM PhoneSystemLogin__c WHERE Id =:psl1.Id];
        System.assertEquals(psl2.CallsNewTemp__c, 1);
        System.assertEquals(psl2.CallsNewLengthTemp__c, 20);
        
        ic1.Length__c = 25;
        update ic1;
        
        PhoneSystemLogin__c psl3 = [SELECT CallsNewLengthTemp__c FROM PhoneSystemLogin__c WHERE Id =:psl1.Id];
        System.assertEquals(psl3.CallsNewLengthTemp__c, 25);
        
        IncomingCall__c ic2 = new IncomingCall__c();
        ic2.NewClient__c = false;
        ic2.PhoneSystemLogin__c = psl1.Id;
        ic2.Length__c = 10;
        ic2.Timestamp__c = datetime.newInstance(2013, 7, 10, 12, 36, 19); 
        ic2.Phone__c = '100200301';
        ic2.Identifier__c = 'def';
        insert ic2;
        
        PhoneSystemLogin__c psl4 = [SELECT CallsKnownTemp__c, CallsKnownLengthTemp__c FROM PhoneSystemLogin__c WHERE Id =:psl1.Id];
        System.assertEquals(psl4.CallsKnownTemp__c, 1);
        System.assertEquals(psl4.CallsKnownLengthTemp__c, 10);
        
        ic2.Length__c = 15;
        update ic2;
        
        PhoneSystemLogin__c psl5 = [SELECT CallsKnownLengthTemp__c FROM PhoneSystemLogin__c WHERE Id =:psl1.Id];
        System.assertEquals(psl5.CallsKnownLengthTemp__c, 15);
        
    }
}