public class AvayaLookupController
{
    private Account acct;
    public List<CallRecord> xCalls {get;set;}
    public String ManualNumber {get;set;}
    public AvayaLookupController(ApexPages.StandardController controller)
    {
        this.acct = (Account)controller.getRecord();
        try
        {
        acct = [SELECT Id,Phone FROM Account WHERE Id = :acct.Id];
        if(acct != null)
        {
            if(acct.Phone != null)
            {
                string phoneNumber = acct.Phone;
                if(phoneNumber.length() > 0)
                {
                    phoneNumber = phoneNumber.replace('(','');
                    phoneNumber = phoneNumber.replace(')','');
                    phoneNumber = phoneNumber.replace(' ','');
                    phoneNumber = phoneNumber.replace('-','');
                    phoneNumber = phoneNumber.replace('.','');
                    phoneNumber = phoneNumber.replace('x','');
                    
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Searching Avaya for: ' + phoneNumber));
                    AvayaService2.QueryServiceSoap service = new AvayaService2.QueryServiceSoap();
                    service.timeout_x = 90000;
                    AvayaService2.ArrayOfCallDetail calls = service.GetCallsForNumber(phoneNumber);
                    xCalls = new List<CallRecord>();
                    if(calls.CallDetail != null)
                    {
	                    for(AvayaService2.CallDetail a : calls.CallDetail)
	                    {
	                        CallRecord x = new CallRecord();
	                        x.PhoneNumber = a.PhoneNumber;
	                        x.AgentName = a.AgentName;
	                        x.HuntGroup = a.HuntGroup;
	                        x.CallDate = a.CallDate;
	                        x.CallLength = a.CallLength;
	                        x.CallId = a.CallId;
	                        x.DID = a.DDI;
	                        x.Direction = a.Direction;
	                        xCalls.add(x);
	                    }
                    }
                    else
                    {
                    	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'No data found or an error occurred.'));
                    }
                }
            }
         }
        }
        catch(Exception ex)
        {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'No data found or an error occurred.'));
        }
    }
    private static testMethod void TestCallerLookup()
    {
        Account a= new Account(Name = 'Test Account', Phone = '6157711988');
        insert a;
        ApexPages.StandardController controller = new ApexPages.StandardController(a);
        AvayaLookupController ext = new AvayaLookupController(controller);
        Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock4());
        Test.startTest();
        CallRecord cr = new CallRecord();
        
        ext.Refresh();
        ext.ManualNumber = '6157711988';
        ext.Manual();
        
        Test.stopTest();
    }
    public PageReference Manual()
    {
    	if(ManualNumber != null)
    	{
    		try
    		{
    			string phoneNumber = ManualNumber;
	        if(phoneNumber.length() > 0)
	        {
	            phoneNumber = phoneNumber.replace('(','');
	            phoneNumber = phoneNumber.replace(')','');
	            phoneNumber = phoneNumber.replace(' ','');
	            phoneNumber = phoneNumber.replace('-','');
	            phoneNumber = phoneNumber.replace('.','');
	            phoneNumber = phoneNumber.replace('x','');
	            
	            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'Searching Avaya for: ' + phoneNumber));
	            AvayaService2.QueryServiceSoap service = new AvayaService2.QueryServiceSoap();
	            service.timeout_x = 90000;
	            AvayaService2.ArrayOfCallDetail calls = service.GetCallsForNumber(phoneNumber);
	            xCalls = new List<CallRecord>();
	            if(calls.CallDetail != null)
	            {
	                for(AvayaService2.CallDetail a : calls.CallDetail)
	                {
	                    CallRecord x = new CallRecord();
	                    x.PhoneNumber = a.PhoneNumber;
	                    x.AgentName = a.AgentName;
	                    x.HuntGroup = a.HuntGroup;
	                    x.CallDate = a.CallDate;
	                    x.CallLength = a.CallLength;
	                    x.CallId = a.CallId;
	                    x.DID = a.DDI;
	                    x.Direction = a.Direction;
	                    xCalls.add(x);
	                }
	            }
	            else
	            {
	            	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'No data found or an error occurred.'));
	            }
          }
    		}
    		catch(Exception e)
    		{
    			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, e.getMessage()));
    		}
    	}
    	return null;
    }
    public PageReference Refresh()
    {
        AvayaService2.QueryServiceSoap service = new AvayaService2.QueryServiceSoap();
        service.timeout_x = 90000;
        AvayaService2.ArrayOfCallDetail calls = service.GetCallsForNumber('6157711988');
        xCalls = new List<CallRecord>();
        if(calls.CallDetail != null)
        {
            for(AvayaService2.CallDetail a : calls.CallDetail)
            {
                CallRecord x = new CallRecord();
                x.PhoneNumber = a.PhoneNumber;
                x.AgentName = a.AgentName;
                x.HuntGroup = a.HuntGroup;
                x.CallDate = a.CallDate;
                x.CallLength = a.CallLength;
                x.CallId = a.CallId;
                x.DID = a.DDI;
                x.Direction = a.Direction;
                xCalls.add(x);
            }
        }
        else
        {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'No data found or an error occurred.'));
        }
        
        return null;

    }
   
    public class CallRecord
    {
        public string PhoneNumber{get;set;}
        public string AgentName{get;set;}
        public string HuntGroup{ get; set; }
        public DateTime CallDate{ get; set; }
        public long CallLength{get; set; }
        public long CallId{ get; set; }
        public string DID {get;set;}
        public string Direction {get;set;}
        public CallRecord(){}
    }
}