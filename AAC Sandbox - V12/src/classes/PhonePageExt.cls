public class PhonePageExt {
public List<Account> accounts {get; private set;}
public List<Contact> contacts {get; private set;}
public String CallerID {get;set;}
public String DID {get;set;}
public String FirstName {get;set;}
public String LastName {get;set;}
public String ScratchPad {get;set;}
public String CallType {get;set;}


public boolean ShowName {get;set;}
public boolean ShowOther {get;set;}
public boolean ShowInternet{get;set;}
public boolean ShowRadio{get;set;}
public boolean ShowSearchEngine{get;set;}
public boolean ShowEmployer{get;set;}
public boolean ShowClinic{get;set;}


public string OtherText {get;set;}
public string InternetText{get;set;}
public string InternetWebsiteText{get;set;}
public string RadioText{get;set;}
public string SearchEngineText{get;set;}
public string SearchEngineSiteText{get;set;}
public string EmployerNameText{get;set;}
public string EmployerWhoText{get;set;}
public string ClinicNameText{get;set;}
public string ClinicWhoText{get;set;}



public String ParentAccountId {get;set;}
public boolean NoName {get;set;}

public void DisplayCallTypeFields()
{
	if(CallType == 'Other')
	    ShowOther = true;
	else
	    ShowOther = false;
	    
	if(CallType == 'Website/Internet')
		ShowInternet = true;
	else
		ShowInternet = false;
	
	if(CallType == 'Search Engine')
		ShowSearchEngine = true;
	else
		ShowSearchEngine = false;
	
	if(CallType == 'Radio')
		ShowRadio = true;
	else
		ShowRadio = false;
		
	if(CallType == 'Physician/Clinician')
		ShowClinic = true;
	else
		ShowClinic = false;
	
	if(CallType == 'Employer')
		ShowEmployer = true;
	else
		ShowEmployer = false;
		
}

public void DisplayNameFields()
{
  if(NoName != null && NoName != false)
    {
       ShowName = false;    
    }
  else
    {
       ShowName = true;    
    } 
}

public List<SelectOption> getCallTypes()
{
List<SelectOption> options = new List<SelectOption>();
options.add(new SelectOption('Website/Internet','Website/Internet'));
options.add(new SelectOption('Search Engine','Search Engine'));
options.add(new SelectOption('Believable Hope','Believable Hope'));
options.add(new SelectOption('Radio','Radio'));
options.add(new SelectOption('Print','Print'));
options.add(new SelectOption('Physician/Clinician','Physician/Clinician'));
options.add(new SelectOption('Employer','Employer'));
options.add(new SelectOption('Other','Other'));

return options;
}

public boolean getNoName()
{
return this.NoName;
}
public void setNoName(boolean noName)
{
this.NoName = noName;
}
public string getOtherText()
{
return this.OtherText;
}
public void setOtherText(string otherText)
{
this.OtherText = otherText;
}
public string getScratchPad()
{
return this.ScratchPad;
}
public void setScratchPad(string scratchPad)
{
this.ScratchPad = scratchPad;
}


public string getCallType()
{
return this.CallType;
}

public void setCallType(string callType)
{
this.CallType = callType;
}


public string getParentAccountId()
{
return this.ParentAccountId;
}
public void setParentAccountId(string parentId)
{
this.ParentAccountId = parentId;
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



public PhonePageExt(ApexPages.StandardController controller) 
{
if(ApexPages.currentPage().getParameters().get('DNIS') != null)
{
DID = ApexPages.currentPage().getParameters().get('DNIS');
}

if(ApexPages.currentPage().getParameters().get('ANI') != null)
{
CallerID = ApexPages.currentPage().getParameters().get('ANI');

if(CallerID != null)
{
List<List<SObject>> searchList = [FIND :CallerID IN PHONE FIELDS RETURNING Account(Id, Name, BillingCity,Phone), Contact(Id, Name, MailingCity, Phone)];

if(searchList != null)
{
accounts = ((List<Account>)searchList[0]);
contacts = ((List<Contact>)searchList[1]);
}
}
}

DisplayNameFields();
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
if(NoName && CallerID != null)
{
a.FirstName = 'ANON';
a.LastName = CallerID;
}
else if(NoName && CallerID == null)
{
a.FirstName = 'ANON';
a.LastName = 'No Number Provided';
}
else
{
a.FirstName = FirstName;
a.LastName = LastName;
}
if(OtherText != null)
{
a.Other_Call_Source__c = OtherText;
}
if(ScratchPad != null)
{
a.Scratch_Pad__c = ScratchPad;
}
if(ParentAccountId != null)
{
a.Parent_Account__c = ParentAccountId;
}
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




}