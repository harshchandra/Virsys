@isTest
private class PhoneSystemLoginControllerTest {

    public static testMethod void test() 
    {
        Test.setCurrentPage(new PageReference('/apex/PhoneSystemLoginPage'));       
    
        PhoneSystemLoginController c = new PhoneSystemLoginController();
        c.filterPhoneSystemLogin();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            
        User u = new User(Username='testing@testorg.com', LastName='Testing', Email='testing@testorg.com', Alias = 'testing',
        CommunityNickname='Testing', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId = p.Id, LanguageLocaleKey='en_US');
        insert u;
            
        PhoneSystemLogin__c sc = new PhoneSystemLogin__c();
        sc.User__c = u.Id; 
        c.SearchCriteria = sc;    
    
        PhoneSystemLogin__c psl = new PhoneSystemLogin__c();
        psl.User__c = u.Id;
        psl.Timestamp__c = datetime.newInstance(2013 , 7, 10, 12, 30, 2);
        psl.TimestampEnd__c = datetime.newInstance(2013 , 7, 10, 16, 55, 47);
        insert psl;
    
        PhoneSystemLogin__c psl2 = new PhoneSystemLogin__c();
        psl2.User__c = u.Id;
        psl2.Timestamp__c = datetime.newInstance(2013 , 8, 12, 10, 38, 2);
        psl2.TimestampEnd__c = datetime.newInstance(2013 , 8, 12, 10, 55, 47);
        psl2.CallsKnownTemp__c = 2;
        psl2.CallsKnownLengthTemp__c = 2000;
        psl2.CallsNewTemp__c = 3;
        psl2.CallsNewLengthTemp__c = 3000;
        insert psl2;
        
        PhoneSystemLogin__c psl3 = new PhoneSystemLogin__c();
        psl3.User__c = u.Id;
        psl3.Timestamp__c = datetime.newInstance(2013 , 8, 12, 14, 10, 20);
        insert psl3;
        
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