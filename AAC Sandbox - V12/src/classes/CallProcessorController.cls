public class CallProcessorController 
{
	public Map<string, string> ParamMap {get;set;}
	public string ParsedInfo {get;set;}
	public string DDI {get;set;}
	public string WebResponse {get;set;}
	public Account ParentAccount {get;set;}
	public List<Account> AccountList {get;set;}
	public List<Lead> LeadList {get;set;}
	
	public CallProcessorController()
	{
		ParamMap = ApexPages.currentPage().getParameters();
	}
	public PageReference CallDetails()
	{
		string EndPoint = 'http://68.71.110.242:8080/Calls/' + ParamMap.get('ANI') + '/GetDNIS';
		Http h = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(EndPoint);
		req.setMethod('GET');
		HttpResponse res = h.send(req);
		JSONParser parser = JSON.createParser(res.getBody());
		WebResponse = res.getBody();
		Records r = (Records)parser.readValueAsStrict(Records.class);
		Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
		DDI = r.Records.DDI;
		
		if(DDI == null || DDI == '')
			DDI = '5555555555';

		string parentQuery = 'FIND \'' + DDI + '\' IN PHONE FIELDS RETURNING Account(Id,Name WHERE IsPersonAccount = false)';
		List<List<sObject>> parentSearchList = search.query(parentQuery);
		List<Account> ParentAccounts = ((List<Account>)parentSearchList[0]);
		
		//List<Account> ParentAccounts = [SELECT Id, Name FROM Account WHERE IsPersonAccount = false AND DID__c Phone = :DDI)]; 
		if(ParentAccounts.size() > 0)
			ParentAccount = ParentAccounts[0];

		AccountList = new List<Account>();
		LeadList = new List<Lead>();	
		
		string query = 'FIND \'' + ParamMap.get('ANI') + '\' IN PHONE FIELDS RETURNING Account(Id,Name), Lead(Id, Name)';
		List<List<sObject>> searchList = search.query(query);
		AccountList = ((List<Account>)searchList[0]);
		LeadList = ((List<Lead>)searchList[1]);
		PageReference ref;
		if(AccountList.size() > 0 && ParentAccount != null)
		{
			//we have an existing account and a parent account, so just go to existing record
			ref = new PageReference('/' + AccountList[0].Id);
		}
		else if(AccountList.size() > 0 && ParentAccount == null)
		{
			//the parent account is null, but we already have a person account, so just go to the existing record
			ref = new PageReference('/' + AccountList[0].Id);
		}
		else if(LeadList.size() > 0)
		{
			//we have an existing lead, so go to that
			ref = new PageReference('/' + LeadList[0].Id);
		}
		else
		{
			//no existing account, create a lead
			if(ParentAccount != null)
		  	ref = new PageReference('/00Q/e?RecordType=012G0000001QF0Y&lea5=Parent Account&lea8=' + ParamMap.get('ANI') + '&CF00NG000000CrQ5P=' + ParentAccount.Name + '&CF00NG000000CrQ5P_lkid=' + ParentAccount.Id);
		  else
		  	ref = new PageReference('/00Q/e?RecordType=012G0000001QF0Y&lea5=Parent Account&lea8=' + ParamMap.get('ANI'));
		}
		
		ref.setRedirect(true);
		return ref;
	}
	public class Records
	{
		public string Result {get;set;}
		public RecordObject Records {get;set;}		
	}
	public class RecordObject
	{
		public string DDI {get;set;}
		public string CallDate {get;set;}
		public string CallListId {get;set;}
	}
}