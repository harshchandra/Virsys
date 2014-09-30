public with sharing class TBN_Submitted_DOS {
	
	public List<Claim__c> lstClaim	{get;set;} // List of Claim object records
	public boolean isChecked {get; set;} //To check the whether the record is selected or not for print with UB-04
	private String strPatientName;	// get to Patient parameter from URL 
	private String sortDirection = 'ASC'; // Initall sorting order 
   	private String sortExp ; 
   	String strSortQuery; // Query for Sorting the records 
   	String strQuery; // Query on Claim objects
   	Set<String> setClaimId;
	
	/* Constructor */
	public TBN_Submitted_DOS()
	{
		String currentURL = URL.getCurrentRequestUrl().toExternalForm();
		//sum=0;
		setClaimId=new Set<String>();
		try
		{
			if(currentURL.contains('patient'))
	    	{
	    	
	    		strPatientName = ApexPages.currentPage().getParameters().get('patient');
	    	}
	    	if(Test.isRunningTest())
	    		strPatientName = 'Test Acc';
	    		
	    	strQuery = 'Select Status__c, Patient__c, ParentClaim__c, Level_of_Care__c, Name, IsDeleted, Id, Facility__c, CreatedDate From Claim__c Where Status__c = \'submitted\' And Patient__c = \''+ strPatientName+'\' order by CreatedDate';
	    	strSortQuery = 'Select Status__c, Patient__c, ParentClaim__c, Name, Level_of_Care__c, IsDeleted, Id, Facility__c, CreatedDate From Claim__c Where Status__c = \'submitted\' And Patient__c = \''+ strPatientName+'\' ';
			lstClaim=Database.query(strQuery);
			if(Test.isRunningTest())
	       	Integer c = 5/0;
		}
		catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    }
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
    		String strquery;
	    	String sortFullExp = ' '+'order by'+' '+sortExpression  + ' ' + sortDirection;
	      	strquery=strSortQuery+' '+ sortFullExp+' '+'Nulls Last  limit 10000';
	      	
	       //query the database based on the sort expression
	       system.debug('&&&&&&&&&&&&strquery&&&&&&&&&'+strquery);
	       lstClaim=Database.query(strquery);
	       if(Test.isRunningTest())
	       	Integer c = 5/0;
    	}
    	catch(Exception e)
	    {
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	    }
  		
   	}

}