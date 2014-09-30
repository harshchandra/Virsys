@isTest
private class HistoricalReportDataTest {
	public static testMethod void test()
	{
		Test.startTest();
		Account a = new Account(FirstName='John',LastName='Doe');
		insert a;
		
		Case c = new Case();
		c.AccountId = a.Id;
		c.Treatment_Facility__c = 'Greenhouse';
		c.Funding_Type__c = 'Private Pay';
		c.Status = 'Admitted';
		insert c;
		
		String jobID = System.schedule('testSchedule',HistoricalReportData.CRON_EXP, new HistoricalReportData());
		CronTrigger ct = [SELECT Id,CronExpression,TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
		System.assertEquals(HistoricalReportData.CRON_EXP, ct.CronExpression);
		System.assertEquals(0, ct.TimesTriggered);
		
		Test.stopTest();
		
	}
}