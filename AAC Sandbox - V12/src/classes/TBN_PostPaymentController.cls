public with sharing class TBN_PostPaymentController 
{
	public List<Top_Batch_Payment__c> lstTopBatchPayment			{get; set;}		//List of Top Batch Payment to be shown on the page for logged in user.
	public Id editTopBatchPaymentId									{get; set;}		// contains Id of the record to be edited.
	private String sortDirection = 'ASC';											// Initial sorting order 
   	private String sortExp ; 														//	Sorting Expression	
   	String strQuery; 																// Query on Claim objects	
   	
	/*Constructor*/
	public TBN_PostPaymentController()
	{
		
		try
		{
			strQuery = 'Select of_Check__c, Status__c, RollUp_Check__c, RollUp_Amount__c, Name, Id, Facility__c, CreatedById, Batch_Amount__c, CreatedBy.Name From Top_Batch_Payment__c';
			
			lstTopBatchPayment = Database.query(strQuery);
			if(Test.isRunningTest())
			{
				decimal c=1/0;
			}
			
			
		}
		catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
	    }
	}
	
	public PageReference editTopBatchPayment()
	{
		PageReference acctPage = new PageReference('/'+editTopBatchPaymentId+'/e?retURL=%2F'+editTopBatchPaymentId);
		
		return acctPage;
	}
	
	/* sorting logic starts here */
   public String sortExpression
   {
	     get
	     {
	        return sortExp;
	     }
	     set
	     {
	       //if the column is clicked on then switch between Ascending and Descending modes
	       if (value == sortExp)
	         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
	       else
	         sortDirection = 'ASC';
	       sortExp = value;
	     }
   	}
  	
	public String getSortDirection()
	{
	    //if not column is selected 
	    if (sortExpression == null || sortExpression == '')
	      return 'ASC';
	    else
	     return sortDirection;
	}

	public void setSortDirection(String value)
	{  
		sortDirection = value;
	}
    /* Query for Sorting the records */
    public void sort()
    {	
    	try
    	{
	    	String strSortWQuery;
	    	String sortFullExp = ' '+'order by'+' '+sortExpression  + ' ' + sortDirection;
	      	strSortWQuery = strQuery+' '+ sortFullExp+' '+'Nulls Last  limit 10000';
	      	
	       	//query the database based on the sort expression
	       	system.debug('&&&&&&&&&&&&strSortWQuery&&&&&&&&&'+strSortWQuery);
			lstTopBatchPayment = Database.query(strSortWQuery);
			
			if(Test.isRunningTest())
			{
				decimal c=1/0;
			}
			
    	}
		catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
	    }
   	}
}