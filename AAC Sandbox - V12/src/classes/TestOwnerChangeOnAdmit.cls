@isTest
private class TestOwnerChangeOnAdmit
{
private static testMethod void TestOwnerChange()
{

User user2 = new User();
user2.Username = 'test2@us.xyz.com';
user2.LastName = 'Last2TestName';
user2.Email = 'test2@us.xyz.com';
user2.alias = 'testA2';
user2.TimeZoneSidKey = 'America/New_York';
user2.LocaleSidKey = 'en_US';
user2.EmailEncodingKey = 'ISO-8859-1';
user2.ProfileId = [select id from Profile where Name='System Administrator'].Id;
user2.LanguageLocaleKey = 'en_US';
System.runAs(user2)
{                
Group g1 = new Group(Name='group name', type='Queue');
insert g1;
QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');
insert q1;
}

}

@future
private static void CreateAndGetQueueId()
{
Case c = new Case();
Account a = new Account();
a.FirstName = 'Test';
a.LastName = 'Test';
insert a;
c.AccountId = a.Id;
c.Status = 'New';
insert c;
CreateAndGetQueueId();
Group g = [SELECT Id FROM Group where Name='group name' and type='Queue'];
c.OwnerId = g.Id;
update c;
c.Status = 'Admitted';
update c;

System.assertEquals(c.OwnerId, c.CreatedById);

}

}