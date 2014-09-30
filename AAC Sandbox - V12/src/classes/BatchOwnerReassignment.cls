global class BatchOwnerReassignment implements Database.Batchable<sObject>{
public String query;
public String email;
public Id toUserId;
public Id fromUserId;
public String objectType;

global Database.querylocator start(Database.BatchableContext BC)
{
 return Database.getQueryLocator(query);
}


global void execute(Database.BatchableContext BC, List<sObject> scope)
{

    if(objectType == 'account')
    {
    List<Account> accs = new List<Account>();
    List<Account> fixAccs = new List<Account>();
//overriding the default to map our special field, and then clear it
   for(sObject s : scope)
   {
    Account a = (Account)s;
    if(a.Contact_Owner__pc != null && a.OwnerId != a.Contact_Owner__pc)
    {
     a.OwnerId = (Id)a.Contact_Owner__pc;
     accs.add(a);
    }
    }

update accs;

   for(sObject s : scope)
   {
    Account a = (Account)s;
    if(a.Contact_Owner__pc == a.OwnerId)
    {
     a.SFDC_Owner_ID_Container__c = '';
     fixAccs.add(a);
    }
    }
update fixAccs;
    }
else if(objectType == 'contact')
{
  List<Contact> contacts  = new List<Contact>();

//overriding the default to map our special field, and then clear it
   for(sObject s : scope)
   {
    Contact c = (Contact)s;
    if(c.Contact_Owner__c != null && c.OwnerId != c.Contact_Owner__c)   
    {
     c.OwnerId = (Id)c.Contact_Owner__c;
     contacts.add(c);     
    }
   }

update contacts;

}
}



global void finish(Database.BatchableContext BC)
{
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

mail.setToAddresses(new String[] {email});
mail.setReplyTo('boverlund@contactaac.com');
mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed');
mail.setPlainTextBody('Batch Process has completed');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}