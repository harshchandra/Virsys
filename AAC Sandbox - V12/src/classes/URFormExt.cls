public class URFormExt 
{
	public List<Dates_of_Service__c> dos { get; set; }
	public Utilization_Review__c URForm { get; set; } 
	
	public URFormExt(ApexPages.StandardController controller)
	{
		this.URForm = (Utilization_Review__c)controller.getRecord();
		GetDatesOfService();
	}
	public void GetDatesOfService()
	{
		if(dos == null)
		{
			try
			{
				dos = [SELECT Id, Start_Date__c, End_Date__c FROM Dates_of_Service__c WHERE Utilization_Review_Form__c = :URForm.Id ORDER BY Start_Date__c];
			}
			catch(Exception ex)
			{
				dos = new List<Dates_of_Service__c>();
			}
		}
	}
	
	
	public void ValidateDOS()
	{	
		//no start dates are the same
		//no dates start with a gap between two entries
		//check if last covered date is a saturday
		
	}
}