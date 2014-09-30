public class PhonePageController
{

    public PhonePageController(ApexPages.StandardController controller) {

    }

public List<Account> accounts {get; private set;}
public List<Contact> contacts {get; private set;}
public String CallerID {get;set;}
public String DID {get;set;}
public String FirstName {get;set;}
public String LastName {get;set;}

public PhonePageController()
{
CallerID = ApexPages.currentPage().getParameters().get('ANI');
DID = ApexPages.currentPage().getParameters().get('DNIS');

List<List<SObject>> searchList = [FIND :CallerID IN PHONE FIELDS RETURNING Account(Id, Name, BillingCity,Phone), Contact(Id, Name, MailingCity, Phone)];
if(searchList != null)
{
accounts = ((List<Account>)searchList[0]);
contacts = ((List<Contact>)searchList[1]);
}
}

public PageReference NewContact()
{
try
{
Contact c = new Contact();
c.Contact_CallerID__c = CallerID;
c.Contact_DID__c = DID;
c.Phone = CallerID;
c.HomePhone = CallerID;
c.FirstName = FirstName;
c.LastName = LastName;
insert c;

PageReference conPage = new PageReference('/' + c.Id);
conPage.setRedirect(true);
return conPage;
}
catch(Exception e)
{
ApexPages.addMessages(e);
return null;
}
}

public PageReference NewAccount()
{
try
{
Account a = new Account();
a.RecordTypeId = queryForPersonRecType();
a.CID__c = CallerID;
a.DID__c = DID;
a.Phone = CallerID;
a.FirstName = FirstName;
a.LastName = LastName;
insert a;

PageReference accPage = new PageReference('/' + a.Id);
accPage.setRedirect(true);
return accPage;
}
catch(Exception e)
{
ApexPages.addMessages(e);
return null;
}
}


public String getCallerID()
{
return this.CallerID;
}
public void setCallerID(String callerID)
{
this.CallerID = callerID;
}
public String getDID()
{
return this.DID;
}
public void setDID(String did)
{
this.DID = did;
}
public String getFirstName()
{
return this.FirstName;
}
public string getLastName()
{
return this.LastName;
}
public void setFirstName(String firstName)
{
this.FirstName = firstName;
}
public void setLastName(String lastName)
{
this.LastName = lastName;
}
private Id queryForPersonRecType()
{  
    return [Select Id From RecordType where Name = 'Person Account'].Id;
}

}