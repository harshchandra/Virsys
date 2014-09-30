public with sharing class TBN_EditPaymentBatch_Controller 
{
	public Top_Batch_Payment__c objBatchPay {get;set;}
	public List<TBN_BatchDetail> lstBatchDetail {get;set;}
	private List<Patient_Payment_Info__c> lstPatientPayementInfoToBeDeleted;
	
	public TBN_EditPaymentBatch_Controller()
	{
		initialize();
		fetchBatchDetails();
	}
	
	private void initialize()
	{
		objBatchPay = new Top_Batch_Payment__c();
		lstBatchDetail = new List<TBN_BatchDetail>();  
		lstPatientPayementInfoToBeDeleted = new List<Patient_Payment_Info__c>();
	}
	
	public void fetchBatchDetails()
	{
		String strPaymentBatchId = Apexpages.currentPage().getParameters().get('Id');
		Map<Id, Check_Info__c> mapCheckInfoDetails = new Map<Id, Check_Info__c>();
		Map<Id, List<Patient_Payment_Info__c>> mapPatInfoDetails = new Map<Id, List<Patient_Payment_Info__c>>();
		List<TBN_BatchDetail> lstBatchDetailOpen = new List<TBN_BatchDetail>();  
		List<TBN_BatchDetail> lstBatchDetailChild = new List<TBN_BatchDetail>(); 
		
		objBatchPay = [Select Id, Name, of_Check__c, Batch_Amount__c, Facility__c, Facility__r.Name, Status__c, RollUp_Amount__c, RollUp_Check__c 
											from Top_Batch_Payment__c 
											where Id =: strPaymentBatchId];
		
		mapCheckInfoDetails = new Map<Id, Check_Info__c>([Select Id, Name, Amount__c, Parent_Batch_Payment__c, Status__c, RollUp_Amount__c, RollUp_Patient__c
														  from Check_Info__c 
														  where Parent_Batch_Payment__c =: objBatchPay.Id order by CreatedDate desc]);
		if(mapCheckInfoDetails != null && mapCheckInfoDetails.size() > 0)
		{
			for(Patient_Payment_Info__c objPatInfo : [Select Id, Name, Amount__c, Check_Info__c, Patient__c, Patient__r.Name, Insurance__c, Insurance__r.Name, Insurance__r.Type__c, Status__c
													  from Patient_Payment_Info__c 
													  where Check_Info__c IN: mapCheckInfoDetails.keySet() Order By Status__c ASC])
		    {
		    	/*Checking the Patient_Payment_Info__c records that does not contain any value in Amount__c field and deleting them*/
		    	if(objPatInfo.Amount__c != null)
		    	{
		    		if(!mapPatInfoDetails.containsKey(objPatInfo.Check_Info__c))
			  			mapPatInfoDetails.put(objPatInfo.Check_Info__c, new List<Patient_Payment_Info__c>{objPatInfo});
			  		else
			  			mapPatInfoDetails.get(objPatInfo.Check_Info__c).add(objPatInfo);
		    	}
		    	else
		  			lstPatientPayementInfoToBeDeleted.add(objPatInfo);	
		    }
		    
		    for(Id objIdd : mapCheckInfoDetails.keySet())
		    {
		    	if(!mapPatInfoDetails.containsKey(objIdd))
		    	{
		    		system.debug('==============mapCheckInfoDetails==============='+mapCheckInfoDetails);
		    		system.debug('==============objIdd==============='+objIdd);
		    		TBN_BatchDetail objIC2 = new TBN_BatchDetail(mapCheckInfoDetails.get(objIdd), null);
	    			lstBatchDetailChild.add(objIC2);
	    			system.debug('=============objIC2================'+objIC2);
		    	}
		    }
		}
		
	    if(mapPatInfoDetails != null && mapPatInfoDetails.size() > 0)
	    for(Id objId : mapPatInfoDetails.keySet())
	    {
	    	if(mapCheckInfoDetails != null && mapCheckInfoDetails.containsKey(objId))
	    	{
	    		if(mapCheckInfoDetails.get(objId).Status__c == 'Open')
	    		{
	    			TBN_BatchDetail objICOpen = new TBN_BatchDetail(mapCheckInfoDetails.get(objId), mapPatInfoDetails.get(objId));
	    			lstBatchDetailOpen.add(objICOpen);
	    		}
	    		else
	    		{
	    			TBN_BatchDetail objIC = new TBN_BatchDetail(mapCheckInfoDetails.get(objId), mapPatInfoDetails.get(objId));
	    			lstBatchDetail.add(objIC);
	    		}
	    	}
	    }
	    if(lstBatchDetailOpen != null)
	    	lstBatchDetail.addAll(lstBatchDetailOpen);			
	    if(lstBatchDetailChild != null)
	    	lstBatchDetail.addAll(lstBatchDetailChild);									
	}
	
	public PageReference doContinue()
	{
		// logic need to be build
		 PageReference pr= new PageReference('/apex/TBN_CreateNewPayemBatchPage?blnContinue=true&topBatchPaymentId='+objBatchPay.Id);
	     pr.setRedirect(true);
	     return pr;
	}
	
	/*Method will be called on click of "Save And Close Button"*/
	public PageReference saveAndClose()
	{
		objBatchPay.Status__c = 'Closed';
		update objBatchPay;
		PageReference pr= new PageReference('/apex/TBN_EditPaymentBatch?Id='+objBatchPay.Id);
	    pr.setRedirect(true);
	    return pr;
	}
	
	/*Action function to be called on load of the page*/
	public void deletePatienetPaymentInfo()
	{
		/*Deleting the unnecessary Patient_Payment_Info__c records*/
		delete lstPatientPayementInfoToBeDeleted;
	}
	
	public class TBN_BatchDetail
	{
		public Check_Info__c objCheckInfo {get;set;}
		public List<Patient_Payment_Info__c> lstPatientInfo {get;set;}
		
		public TBN_BatchDetail(Check_Info__c objCheckInfoTemp, List<Patient_Payment_Info__c> lstPatientInfoTemp)
		{
			objCheckInfo = new Check_Info__c();
			lstPatientInfo = new List<Patient_Payment_Info__c>();
			objCheckInfo = objCheckInfoTemp;
			if(lstPatientInfoTemp != null)
			lstPatientInfo.addAll(lstPatientInfoTemp);
		}
	}
	
}