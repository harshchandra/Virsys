global class MarketingMonthlyCalls implements Schedulable 
{
    public static string CRON_EXP = '0 0 9 * * ? 2014';
    
    global void execute(SchedulableContext ctx)
    {
        MarketingMonthlyCallsCallout.ProcessUniqueCalls();
    }
    
    public static testMethod void testMarketingMonthlyCalls()
    {
        Test.startTest();
        Account a = new Account(Name='test account',phone = '5555555555', marketing_group__c = 'Other', RecordTypeId = '012G00000017990IAA');
        insert a;

        String jobID = System.schedule('testSchedule',MarketingMonthlyCalls.CRON_EXP, new MarketingMonthlyCalls());
        CronTrigger ct = [SELECT Id,CronExpression,TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(MarketingMonthlyCalls.CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}