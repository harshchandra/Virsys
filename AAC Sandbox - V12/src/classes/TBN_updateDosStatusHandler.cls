public with sharing class TBN_updateDosStatusHandler 
{
	
	
	public TBN_updateDosStatusHandler()
	{
		
	}
	
	public void onBeforeUpdate(Map<Id,Dates_of_Service__c> oldMap,Map<Id,Dates_of_Service__c> newMap)
	{
		Integer intSubmitedDOS = 0;
		try
		{
			for(Dates_of_Service__History objSubmittedDOS : [Select ParentId, OldValue, NewValue, Field, CreatedDate 
																From Dates_of_Service__History 
																where Field='Bill_Status__c' AND ParentId IN: newMap.keySet()])
			{
				if(objSubmittedDOS.NewValue == 'Submitted')	
					intSubmitedDOS++;
			}
			for(Dates_of_Service__c objDos : newMap.values())
			{
				if(objDos.Bill_Status__c == 'Submitted' && objDos.Bill_Status__c != oldMap.get(objDos.Id).Bill_Status__c)
					objDos.Submitted__c = intSubmitedDOS+1;
				if((oldMap != newMap && objDos.Bill_Status__c == 'Submitted' && objDos.Bill_Status__c == oldMap.get(objDos.Id).Bill_Status__c) || (oldMap != newMap && objDos.Bill_Status__c == 'Printed' && objDos.Bill_Status__c == oldMap.get(objDos.Id).Bill_Status__c))
				{
					if(!(objDos.Bill_Status__c != oldMap.get(objDos.Id).Bill_Status__c))
					{
						objDos.Bill_Status__c = 'Reprocess';
						objDos.Flag_Bill_Status_Update__c = True;
					}
				}
			}
		}
		 catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    }
	}
}