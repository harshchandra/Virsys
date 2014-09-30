public class SupportGroupExtension
{
private final Support_Group_Member__c sg;
public string accountID {get;set;}
public string accountName{get;set;}


    public SupportGroupExtension(ApexPages.StandardController controller)
    {
        this.sg = (Support_Group_Member__c)controller.getRecord();
        accountID = ApexPages.currentPage().getParameters().get('accountID');
        if(accountID != null)
        {
            Account a = [select Id, Name from Account where Id = :accountID];
            accountName = a.Name;
            sg.Person_Account__c = accountID;
        }       
    }
}