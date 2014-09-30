public class CloneToPersonAccountExt
{
public Account pAcc = new Account();
public Account oAcc {get;set;}
public String PersonName {get;set;}
public String FirstName {get;set;}
public String LastName {get;set;}
public String orgAccId {get;set;}
public String NewID {get;set;}

public CloneToPersonAccountExt(ApexPages.StandardController controller)
{
this.oAcc = (Account)controller.getRecord();
orgAccId = this.oAcc.Id;

}

private Id queryForPersonRecType()
{
  return [Select Id From RecordType where Name = 'Person Account'].Id;
}


public PageReference save() 
{        
try
{
    Account oAcc = [select Id, DID__c from Account where Id = :orgAccId];
    pAcc.RecordTypeId = queryForPersonRecType();
    pAcc.FirstName = FirstName;
    pAcc.LastName = LastName;
    pAcc.DID__c = oAcc.DID__c;
    insert pAcc;
    
    NewID = pAcc.id;
    PageReference acctPage = new PageReference('/' + pAcc.id);
    acctPage.setRedirect(true);
    return acctPage;
}
catch(Exception e)
{
    ApexPages.addMessages(e);
    return null;
}
}
}