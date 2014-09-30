trigger UpdateAccountLastContactDateFromActivity on Task (after insert) 
{
	List<Account> accounts = new List<Account>();
	for(Task t : trigger.new)
	{
		//Check the tasks in the batch
		//If they are tied to an account, and the status is completed
		//update the Last Contact Date
		if(t.WhatId != null && t.Status == 'Completed')
		{
			string accountPrefix = Schema.Sobjecttype.Account.getKeyPrefix();
			if(string.valueOf(t.WhatId).startsWith(accountPrefix))
			{
				try
				{
					Account a = [SELECT Id, Last_Contact_Date__c FROM Account WHERE Id = :t.WhatId];
					a.Last_Contact_Date__c = datetime.now().date();
					accounts.add(a);
				}
				catch(Exception ex)
				{
					
				}
			}
		}	
	}
	update accounts;
}