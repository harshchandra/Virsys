@isTest
public class BatchOwnerReassignmentTest
{

public static testMethod void testBatch() {
    
   user u = [SELECT ID, UserName FROM User WHERE alias='boverlu'];
   user u2 = [SELECT ID, UserName FROM User WHERE alias='aaccoun'];
   String uId = u.id;   
   String u2id = u2.id;
// Create 200 test accounts - this simulates one execute.   
    
// Important - the Salesforce.com test framework only allows you to  
    
// test one execute.   
    

   List <Account> accns = new List<Account>();
      for(integer i = 0; i<50; i++){
         Account a = new Account(FirstName='testAccount'+'i',LastName='Test',Contact_Owner__pc = u.Id, RecordTypeId='012G000000178SYIAY',Phone='1231231234', Ownerid = u2id, SFDC_Owner_ID_Container__c = '005G0000002jZAKIA2'); 
         accns.add(a);
      }
   
   insert accns;
   
   List<Contact> contacts = new List<Contact>();
   for(integer i = 0; i<50; i++)
   {
    Contact c = new Contact(FirstName='Test',LastName='Test',Contact_Owner__c = u2id,Phone='1231231234');
    contacts.add(c);
   }
   
   insert contacts;
   
   Test.StartTest();
   
   BatchOwnerReassignment reassign = new BatchOwnerReassignment();
   reassign.query='SELECT ID,FirstName,LastName,Contact_Owner__pc, Ownerid,SFDC_Owner_ID_Container__c FROM Account WHERE OwnerId=\'' + u2id + '\' LIMIT 200';
   reassign.email='boverlund@contactaac.com';
   reassign.objectType = 'account';
   reassign.toUserId = u2id;
   reassign.fromUserId = uId;
   ID batchprocessid = Database.executeBatch(reassign);


   BatchOwnerReassignment reassign2 = new BatchOwnerReassignment();
   reassign2.query='SELECT ID, Firstname,Lastname,Contact_Owner__c,Ownerid FROM Contact WHERE OwnerId=\'' + u2id + '\' LIMIT 200';
   reassign2.email='boverlund@contactaac.com';
   reassign2.objectType = 'contact';
   reassign2.toUserId = u2id;
   reassign2.fromUserId = uId;
   ID batchprocessid2 = Database.executeBatch(reassign2);   
   
   Test.StopTest();

   database.countquery('SELECT COUNT() FROM Account WHERE OwnerId=\'005G0000002jZAKIA2\'');
   }
}