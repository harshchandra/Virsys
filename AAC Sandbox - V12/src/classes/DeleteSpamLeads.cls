global class DeleteSpamLeads implements Schedulable 
{
	public static string CRON_EXP = '0 0 0,4,8,12,16,20 ? * *'; 
	global static void RunSchedule()
	{
		DeleteSpamLeads dsl = new DeleteSpamLeads();
		string jobId = system.schedule('Delete Spam Leads', CRON_EXP, dsl);
	}
	global void execute(SchedulableContext ctx)
	{
		List<Lead> leads = [SELECT Id FROM Lead WHERE Spam__c = true];
		delete leads;
	}	
}