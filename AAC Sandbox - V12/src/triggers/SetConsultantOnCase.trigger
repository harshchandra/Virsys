trigger SetConsultantOnCase on Case (before insert, before update) 
{
	Map<string, Id> userMap = new Map<string, Id>();
	List<User> userList = [SELECT Id, Name FROM User];
	for(User u : userList)
	{
		userMap.put(u.Name, u.Id);
	}
	
	for(Case c : trigger.new)
	{
		if(c.Consultant__c != null && c.Consultant__c != '' && c.Consultant__c != ' ')
		{
			if(userMap.containskey(c.Consultant__c))
				c.Consultant_Lookup__c = userMap.get(c.Consultant__c);
		}
	}
}