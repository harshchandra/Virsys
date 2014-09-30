global class MarketingMonthlyCallsCallout 
{
	@future(callout=true)
	public static void ProcessUniqueCalls()
	{
		//generate start date
		DateTime now = datetime.now();
		DateTime startDate = datetime.newInstance(now.year(),now.month(),1, 0,0,0);
		DateTime endDate = datetime.newInstance(now.year(),now.month(), now.day(),23,59,59);
		
		AvayaService2.QueryServiceSoap service = new AvayaService2.QueryServiceSoap();
		service.timeout_x = 90000;
		AvayaService2.ArrayOfCallDetail callRecords = new AvayaService2.ArrayOfCallDetail();
	
		system.debug('Searching for StartDate: ' + StartDate + ' EndDate:  ' + EndDate);
		callRecords = service.GetUniqueCallsCountByDIDAndDate(startDate, endDate);
		if(callRecords.CallDetail != null)
		{
			List<Account> finalMarketingAccounts = new List<Account>();
			List<Account> marketingAccounts = [SELECT Name,Phone,Marketing_Group__c,Unique_Calls_This_Month__c FROM Account WHERE RecordTypeId = '012G00000017990IAA' And Phone != null AND Marketing_Group__c != null];
			for(Account mka : marketingAccounts)
			{
				system.debug('checking marketing account ' + mka.Name + ' , phone: ' + mka.Phone);
				string phoneNumber = mka.Phone;
				phoneNumber = phoneNumber.replace('(','');
	            phoneNumber = phoneNumber.replace(')','');
	            phoneNumber = phoneNumber.replace(' ','');
	            phoneNumber = phoneNumber.replace('-','');
	            phoneNumber = phoneNumber.replace('.','');
	            phoneNumber = phoneNumber.replace('x','');
	            system.debug('Phone fixed to: ' + phoneNumber);
	            
	            for(AvayaService2.CallDetail call : callRecords.CallDetail)
	            {
	            	if(call.DDI == phoneNumber)
	            	{
	            		mka.Unique_Calls_This_Month__c = call.CallCount;
	            		finalMarketingAccounts.add(mka);
	            	}
	            }            
			}
			
			update finalMarketingAccounts;
		}
	}
	
	public static testMethod void testMarketingMonthlyCalls()
	{
		Test.startTest();
		Account a = new Account(Name='test account',phone = '5555555555', marketing_group__c = 'Other', RecordTypeId = '012G00000017990IAA');
		insert a;
		
		MarketingMonthlyCallsCallout.ProcessUniqueCalls();

		String jobID = System.schedule('testSchedule',MarketingMonthlyCalls.CRON_EXP, new MarketingMonthlyCalls());
		CronTrigger ct = [SELECT Id,CronExpression,TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
		System.assertEquals(MarketingMonthlyCalls.CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		Test.stopTest();
	}

}