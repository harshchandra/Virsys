@isTest
private class PhoneSystemLoginController2Test {

    public static testMethod void test() 
    {
        Test.setCurrentPage(new PageReference('/apex/PhoneSystemLoginPage2'));
        
        PhoneSystemLoginController2 c = new PhoneSystemLoginController2();
        c.filterPhoneSystemLogin();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User u = new User(Username='testing@testorg.com', LastName='Testing', Email='testing@testorg.com', Alias = 'testing',
        CommunityNickname='Testing', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId = p.Id, LanguageLocaleKey='en_US');
        insert u;
        
        PhoneSystemLogin__c psl = new PhoneSystemLogin__c();
        psl.User__c = u.Id;
        psl.Timestamp__c = datetime.newInstance(2013 , 7, 10, 12, 30, 2);
        psl.TimestampEnd__c = datetime.newInstance(2013 , 7, 10, 16, 55, 47);
        insert psl;
           
        PhoneSystemLogin__c psl2 = new PhoneSystemLogin__c();
        psl2.Timestamp__c = datetime.newInstance(2013 , 8, 16, 4, 15, 10);
        psl.TimestampEnd__c = datetime.newInstance(2013 , 8, 16, 16, 55, 47);
        insert psl2;

        c.filterPhoneSystemLogin();
        
        c.DateFrom = date.newinstance(2012, 2, 17);
        c.DateTo= date.newinstance(2014, 2, 17);
        c.filterPhoneSystemLogin();
    
        c.DateFrom = date.newinstance(2012, 2, 17);
        c.DateTo= null;   
        c.filterPhoneSystemLogin();
    
        c.DateFrom = null;
        c.DateTo= date.newinstance(2014, 2, 17);
        c.filterPhoneSystemLogin();        
    }

}