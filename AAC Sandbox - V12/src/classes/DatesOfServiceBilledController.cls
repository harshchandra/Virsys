public class DatesOfServiceBilledController 
{
	public Utilization_Review__c Form {get;set;}
	public Dates_of_Service__c PlaceHolder {get;set;}
	public List<Dates_of_Service__c> DatesOfService {get;set;}
	public Date StartDate {get;set;}
	public Date EndDate {get;set;}
	public boolean IsError {get;set;}
	public string ErrorText {get;set;}
	
	public DatesOfServiceBilledController(ApexPages.StandardController controller)
	{
		Form = (Utilization_Review__c)controller.getRecord();
		PlaceHolder = new Dates_of_Service__c();
		try
		{
			DatesOfService = [SELECT Id,
														 Name, 
														 Start_Date__c, 
														 End_Date__c, 
														 Has_Been_Billed__c, 
														 Billable_Day__c,
														 Level_Of_Care__c,
														 Status__c,
														 Utilization_Review_Form__c,
														 Authorization_Number__c,
														 CM__c,
														 Date_of_Review__c,
														 Day_of_Week__c,
														 Days_Per_Week__c,
														 Review_Assigned_To_Lookup__c,
														 Total_Calendar_Days__c,
														 Total_Days_Authorized__c
														 FROM Dates_of_Service__c
														 WHERE Utilization_Review_Form__c = :Form.Id ORDER BY End_Date__c DESC];
		}
		catch(Exception e)
		{
			RedirectToParent();			
		}
	}
	public PageReference RedirectToParent()
	{
		PageReference ref = new PageReference('/' + Form.Id);
		ref.setRedirect(true);
		return ref;
	}
	public PageReference Save()
	{
		IsError = false;
		ErrorText = '';
		List<Dates_of_Service__c> updatedDatesOfService = new List<Dates_of_Service__c>();
		StartDate = PlaceHolder.Start_Date__c;
		EndDate = PlaceHolder.End_Date__c;
		if(StartDate != null && EndDate != null && (EndDate >= StartDate))
		{
			for(Dates_of_Service__c d : DatesOfService)
			{
				if(d.Billable_Day__c == true)
				{
					boolean isUpdated = false;
					if(d.Start_Date__c == StartDate || d.End_Date__c == EndDate)
					{
						d.Has_Been_Billed__c = true;
						isUpdated = true;
					}
					if(d.Start_Date__c <= StartDate && d.End_Date__c >= EndDate)
					{
						d.Has_Been_Billed__c = true;
						isUpdated = true;
					}
					if(d.Start_Date__c >= StartDate && d.End_Date__c <= EndDate && d.Start_Date__c == d.End_Date__c)
					{
						d.Has_Been_Billed__c = true;
						isUpdated = true;
					}
					
					if(isUpdated)
						updatedDatesOfService.Add(d);
				}
			}
			
			try
			{
				update updatedDatesOfService;
				PageReference ref = new PageReference('/' + Form.Id);
				ref.setRedirect(true);
				return ref;
			}
			catch(Exception e)
			{
				IsError = true;
				ErrorText = e.getMessage();
				return null;
			}
		}
		else
		{
			IsError = true;
			ErrorText = 'The dates you specified are invalid.  Please try something else.';
			return null;
		}
		
		return null;	
	}
}