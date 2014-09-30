global class ComcastMarketingProcessor 
{
	//Make sure remote settings are configured before testing against
	global class phoneType
	{
		webservice string firstName;
		webservice string lastName;
		webservice string campaignId;
		webservice DateTime timestamp;
		webservice string transactionId;
		webservice string phoneNumber;
	}
	
	webservice static string createPhoneCallRequest(phoneType p)
	{
		string responseString = '';
		try
		{
			Phone_Call_Request__c pr = new Phone_Call_Request__c();
			pr.First_Name__c = p.firstName;
			pr.Last_Name__c = p.lastName;
			pr.Campaign_ID__c = p.campaignId;
			pr.Timestamp__c = p.timestamp;
			pr.Transaction_ID__c = p.transactionId;
			pr.Phone_Number__c = p.phoneNumber;
			
			insert pr;
			
			responseString = 'Success: ' + pr.Id;
		}
		catch(Exception e)
		{
			responseString = 'Error: ' + e.getMessage();
		}
		
		return responseString;
	}

	webservice static string phoneType(phoneType p)
	{
		string responseString = '';
		try
		{
			Phone_Call_Request__c pr = new Phone_Call_Request__c();
			pr.First_Name__c = p.firstName;
			pr.Last_Name__c = p.lastName;
			pr.Campaign_ID__c = p.campaignId;
			pr.Timestamp__c = p.timestamp;
			pr.Transaction_ID__c = p.transactionId;
			pr.Phone_Number__c = p.phoneNumber;
			
			insert pr;
			
			responseString = 'Success: ' + pr.Id;
		}
		catch(Exception e)
		{
			responseString = 'Error: ' + e.getMessage();
		}
		
		return responseString;
	}
	
}