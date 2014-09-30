public with sharing class SupervisorViewExt {
public User u
{ get {return [select Id,Name,State,Department from User WHERE Id = :UserInfo.getUserId()];}
  private set;
}

public string Department{get;set;}
public string State{get;set;}
public Id PlacementQueueId
{
    get
    {
        List<Group> queues_lst = [Select Id, Name, Type from Group where Type = 'Queue' AND Name LIKE :('A&P Placement Decision Queue%'+u.State)];
        if (queues_lst.size() > 0)
        {
            return queues_lst[0].Id;
        }
        else
        {
            return null;
        }
    }
    set;
}
public Id getPlacementQueueId()
{
return PlacementQueueId;
}
public Id AdmissionsQueueId
{
    get
    {
        List<Group> queues_lst = [Select Id, Name, Type from Group where Type = 'Queue' AND Name LIKE :('Admissions -%' + u.Department)];

        if (queues_lst.size() > 0)
        {    
          return queues_lst[0].Id;
        }
        else
        {
            return null;
        }
    }
    set;
}
public Id getAdmissionsQueueId()
{
return AdmissionsQueueId;
}

private List<Case> PlacementCases;
private List<Case> AdmissionsCases;

private String sortDirectionPlacement = 'ASC';
private String sortDirectionAdmissions = 'ASC';
private String sortExpPlacement = 'Account.Name';
private String sortExpAdmissions = 'Account.Name';
public String sortExpressionPlacement
{
    get{ return sortExpPlacement; }
    set{ 
        //if the column is clicked on then switch between Ascending and Descending modes
        if (value == sortExpPlacement)
            sortDirectionPlacement = (sortDirectionPlacement == 'ASC')? 'DESC' : 'ASC';
        else
            sortDirectionPlacement = 'ASC';
        
        sortExpPlacement = value;
        }
}
public String sortExpressionAdmissions
{
    get{ return sortExpAdmissions; }
    set{ 
        //if the column is clicked on then switch between Ascending and Descending modes
        if (value == sortExpAdmissions)
            sortDirectionAdmissions = (sortDirectionAdmissions == 'ASC')? 'DESC' : 'ASC';
        else
            sortDirectionAdmissions = 'ASC';
        
        sortExpAdmissions = value;
        }
}

public String getSortDirectionPlacement() {
        //if not column is selected
if (sortExpressionPlacement == null || sortExpressionPlacement == '')
    return 'ASC';
else
    return sortDirectionPlacement; 
}

public String getSortDirectionAdmissions() {
        //if not column is selected
if (sortExpressionAdmissions == null || sortExpressionAdmissions == '')
    return 'ASC';
else
    return sortDirectionAdmissions; 
} 
 
public void setSortDirectionPlacement(String value) 
{     
    sortDirectionPlacement = value; 
}
public void setSortDirectionAdmissions(String value) 
{     
    sortDirectionAdmissions = value; 
}

public List<Case> getPlacementCases()
{
    return PlacementCases;
}
public List<Case> getAdmissionsCases()
{
    return AdmissionsCases;
}

public PageReference RefreshViewData()
{
    PlacementViewData();
    AdmissionsViewData();
    return null;
}
public PageReference PlacementViewData() 
{
    //build the full sort expression
    string sortFullExp = sortExpressionPlacement  + ' ' + sortDirectionPlacement;
    //query the database based on the sort expression
    if(PlacementQueueId != null)    
    {    
     string query = null;
     if(sortExpressionPlacement != null)
     {
         query = 'SELECT c.Id, c.CaseNumber, c.Account.Name, c.Insurance_Status__c, c.Priority, c.CreatedDate FROM Case c WHERE c.OwnerId = :PlacementQueueId ORDER BY ' + sortExpressionPlacement;    
     }
     else
     {
         query = 'SELECT c.Id, c.CaseNumber, c.Account.Name, c.Insurance_Status__c, c.Priority, c.CreatedDate FROM Case c WHERE c.OwnerId = :PlacementQueueId ORDER BY c.CreatedDate';         
     }    
     PlacementCases = (List<Case>)database.query(query);
     }        
    else
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Placement Queue algorithm failed to match you.'));

    return null;
}


public PageReference AdmissionsViewData() 
{


    //build the full sort expression
    string sortFullExp = sortExpressionAdmissions  + ' ' + sortDirectionAdmissions;
    //query the database based on the sort expression
    if(AdmissionsQueueId != null)
     { 
         string query = null;
         if(sortExpressionPlacement != null)
         {
         query = 'SELECT c.Id, c.CaseNumber, c.Account.Name, c.Insurance_Status__c, c.Priority, c.CreatedDate FROM Case c WHERE c.OwnerId = :AdmissionsQueueId ORDER BY ' + sortExpressionPlacement;    
         }
         else
         {
         query = 'SELECT c.Id, c.CaseNumber, c.Account.Name, c.Insurance_Status__c, c.Priority, c.CreatedDate FROM Case c WHERE c.OwnerId = :AdmissionsQueueId ORDER BY c.CreatedDate';         
         }    
         AdmissionsCases = (List<Case>)database.query(query);
      }          
     else
         ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Admissions Queue algorithm failed to match you.'));

    return null;
}

public SupervisorViewExt(ApexPages.StandardController controller)
{
    this.u = u;
    this.Department = u.Department;
    this.State = u.State;
    this.AdmissionsQueueId = getAdmissionsQueueId();
    this.PlacementQueueId = getPlacementQueueId();
    PlacementViewData();
    AdmissionsViewData();

}

private static testMethod void TestSupervisorExt()
{
	Account a= new Account(FirstName ='John', LastName ='Doe', Phone='5555555555');
	insert a;
	Case c = new Case(AccountId = a.Id);
	insert c;
	ApexPages.StandardController controller = new ApexPages.StandardController(c);
	SupervisorViewExt ext = new SupervisorViewExt(controller);
	Test.startTest();
	ext.RefreshViewData();
	Test.stopTest();
}
}