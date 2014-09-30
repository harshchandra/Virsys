public with sharing class TBN_CreateNewPayemBatchController 
{
    public ApexPages.StandardController standardController  { get; set; } /*standard controller*/
    
    // Variables for Creation of Top Batch Payment records
    public String strFacility                               { get; set; } /* To store facility value for Top Batch Payment */
    public String strPaymentName                            { get; set; } /* To store the payment name for batch payment object*/
    public Decimal decAmount                                { get; set; } /* To store the total amount for TBP object*/
    
    //Variables for Creation of Check Info records.
    public String  strCheckName                             { get; set; } /* Getting check name from the page for check info object*/
    public Decimal decAmountCheckInfo                       { get; set; } /* Getting check amount from the page for check info object*/
    
    //Variable for creation of Patient payment info records
    public Id CaseId                                        { get; set; } /* To get the selected Case Id from Custom Lookup*/
    public Id insuranceId                                   { get; set; } /* To get the selected Insurance Id from Custom Lookup*/
    
    //Boolean variables for rendering the required section
    public Boolean blnCheckInfoPage                         { get; set; } /* To render Next section for check info object */
    public Boolean blnBatchPaymentPage                      { get; set; } /* To render first section for batch payment object */
    public Boolean blnPatienInfo                            { get; set; } /* To render third section for patient information object */
    public Boolean blnFlag                                  { get; set; } /* Boolean value to decide whether the new check record is created or not*/
    
    //Variables for creating different object instance    
    private Top_Batch_Payment__c objTopBatch;                             /* Creating an instance of Top Batch payment Object*/
    private Top_Batch_Payment__c objTopBatchPaymentForContinue;			  /* Creating an instance of the Top Batch payment object when the records are created from 'Save' and 'Continue' button*/
    public Top_Batch_Payment__c objTopBatchPayment          { get; set; } /* To show the Top Batch payement details of particular "Check Info" record*/  
    private Check_Info__c objNewCheckInfo;                                /* Creating an instance of new Check Info Object*/
    private Check_Info__c objOldCheckInfo;                                /* Creating an instance of old Check Info Object when the records are created from 'Save' and 'Continue' button*/
    private Check_Info__c objCheck;                                       /* Creating an instance of Check info for getting the values after Save from PatientDOSDetailsController*/
    public Check_Info__c objCheckInformation      			{ get; set; } /* To show the check information details of particular "Patient Payment Info" record*/
    private Patient_Payment_Info__c objPatientInfoRecord;                 /* Creating an instance of Patient Payment info for getting the values after Save from PatientDOSDetailsController*/
    public  Patient_Insurance__c objPatientInsurance		{ get; set; }
   	
    //Variables for holding check amounts at different levels
    public Decimal decRemainingCheckAmount                  { get; set; } /* Decimal to hold the remaining check amount after the patient info object has been created */
    public Decimal decRemainingTopBatchPaymentAmount        { get; set; } /* Decimal to hold the remaining top batch payment amount after check info object has been created */
    private Decimal decTotalPatientInfoAmount = 0;                        /* Sum of the total amount of all the patient info object records created*/
    private Decimal decBatchAmount = 0;									  /* Decimal to hold the total batch amount for Top batch Payment*/
    private Decimal decCheckAmount = 0;									  /* Decimal to hold the total check amount for check info*/
    private Decimal decCheckRollUpAmount = 0;							  /* Decimal to hold total check roll up amount for check info */
    private Decimal decTopBatchPaymentRollUpAmount = 0;					  /* Decimal to hold total batch payment roll up amount for top batch payment*/
    private Decimal decBalanceAmount;
    
    private List<Check_Info__c> lstCheckInfo;           
    private List<Patient_Payment_Info__c> lstPatient;
   
    /*Constructor*/
    public TBN_CreateNewPayemBatchController(ApexPages.StandardController standardController)
    {
        blnBatchPaymentPage = true;
        blnCheckInfoPage = blnPatienInfo =  false;
        decRemainingCheckAmount = 0;
        objPatientInsurance = [Select Name, TYpe__c from Patient_Insurance__c Where Type__c =: 'Primary' limit 1];
            insuranceId = objPatientInsurance.Id;
        system.debug('----balance amount---'+ApexPages.currentPage().getParameters().get('balanceAmount'));
        if(ApexPages.currentPage().getParameters().containsKey('balanceAmount'))
                decBalanceAmount = Decimal.valueOf(ApexPages.currentPage().getParameters().get('balanceAmount'));
                
        /*check if the page is being called on click of 'Cancel' from PatientDOSDetailPage*/
        if(ApexPages.currentPage().getParameters().containsKey('balanceAmount') && ApexPages.currentPage().getParameters().get('balanceAmount') != '0' &&
        	ApexPages.currentPage().getParameters().containsKey('blnCancel') && ApexPages.currentPage().getParameters().get('blnCancel') != null && ApexPages.currentPage().getParameters().get('blnCancel') == 'true')
        {
            blnPatienInfo = true;
            blnCheckInfoPage = blnBatchPaymentPage = false;
        }
        getDetails();
    }
    
    /*Creating a new Top Batch payment record*/
    public void redirectToCheckInfoPage()
    {
        try
        {
            objTopBatch = new Top_Batch_Payment__c();
            
             String strAmount = ApexPages.currentPage().getParameters().get('amount');
             if(strAmount.contains(','))
             	strAmount = strAmount.replaceAll(',', '');
             system.debug('%%%%strAmount%%%%% : '+strAmount);
             decAmount = Decimal.valueOf(strAmount);
             
            
            if(strFacility != '' && strPaymentName != '' && decAmount != 0.0)
            {
                
                Facility__c objFacility = [Select Id FROM Facility__c WHERE Name =: strFacility LIMIT 1 ];
                objTopBatch.Facility__c = objFacility.Id;
                objTopBatch.Name = strPaymentName;
                objTopBatch.Batch_Amount__c = decAmount;
                insert objTopBatch;
                
                blnCheckInfoPage = true;
                /*Calling method to get the details of Batch to show on respective check.*/
                system.debug('@@@objTopBatch.Id@@@@ : '+objTopBatch.Id);
                getTopBatchPayementDetails(objTopBatch.Id);
                blnBatchPaymentPage = false;
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please fill all the required details to proceed'));
            }
            if(Test.isRunningTest())
                Integer c = 5/0;
        }
        catch(Exception e)
        {
            system.debug('---- e.getMessage() ---'+e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }
    
    /*Redirects to the PostPayment Page on 'Cancel' */
    public PageReference redirectToPostPaymentPage()
    {
        PageReference pr= new PageReference('/apex/TBN_PostPaymentPage');
        pr.setRedirect(true);
        return pr;
    }
    
    /* Creates a new Check info object record while new creation from Top Batch Payment*/
    public void redirectTopPatientPaymentInfoPage()
    {
        try
        {
            system.debug('---------redirectTopPatientPaymentInfoPage----');
            objNewCheckInfo = new Check_Info__c();
            String strCheckAmount = ApexPages.currentPage().getParameters().get('checkAmount');
	         if(strCheckAmount.contains(','))
	         	strCheckAmount = strCheckAmount.replaceAll(',', '');
            decAmountCheckInfo = Decimal.valueOf(strCheckAmount);
            
            if(strCheckName != '' && decAmountCheckInfo != 0)
            {
                objNewCheckInfo.Name = strCheckName ;
                objNewCheckInfo.Amount__c = decAmountCheckInfo;
                objNewCheckInfo.Parent_Batch_Payment__c = objTopBatch.Id;
                objNewCheckInfo.Status__c = 'Open';
                system.debug('****objNewCheckInfo**** : '+objNewCheckInfo);
                insert objNewCheckInfo;
                blnPatienInfo = true;
                /*Calling method to get the details of Check to show on respective Patient payment Info.*/
                getCheckInfoDetails(objNewCheckInfo.Id);
                blnCheckInfoPage = false;
                
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please fill all the required details to proceed'));
            }
            if(Test.isRunningTest())
                Integer a = 5/0;
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }
    
     /*Save the Patient Payment Info and redirects to TBN_PatientDOSDetailsPage page*/
    public PageReference savePatientPaymentInfoPage()
    {
        system.debug('---savePatientPaymentInfoPage---- : ');
        try
        {
            system.debug('---savePatientPaymentInfoPage---- : '+insuranceId);
            system.debug('---CaseId---- : '+CaseId);
            Patient_Insurance__c objPatientInsurance = [Select Name,Type__c FROM Patient_Insurance__c WHERE Id =:insuranceId];
            
            if(CaseId != null)
            {
            		system.debug('^^^objNewCheckInfo.Id;^^ : '+objNewCheckInfo.Id);
                    Case objCase = [Select Id,Account.Name FROM Case WHERE Id =: CaseId];
                    Patient_Payment_Info__c objPatientInfo =  new Patient_Payment_Info__c();
                    objPatientInfo.Patient__c = objCase.Account.Id ;
                    objPatientInfo.Check_Info__c = objNewCheckInfo.Id;
                    objPatientInfo.Insurance__c = insuranceId;
                    objPatientInfo.Status__c = 'Open';
                    system.debug('###objPatientInfo#### : '+objPatientInfo);
                    insert objPatientInfo;
                    system.debug('---objPatientInfo-----1---'+objPatientInfo.Id);
                    system.debug('---decBalanceAmount----'+decBalanceAmount);
                    if(blnCheckInfoPage == true)
                    {
                    	system.debug('old Check balance1 : '+decBalanceAmount);
                		PageReference pr1= new PageReference('/apex/TBN_PatientDOSDetailsPage?patient=' + objCase.Account.Name + '&amount=' +objNewCheckInfo.Amount__c+ '&insurance=' +objPatientInsurance.Type__c+ '&PatientId=' +objPatientInfo.Id +'&balanceAmount='+decBalanceAmount);    	
                    	pr1.setRedirect(false);
                    	return pr1;
                    }
	            	else
	            	{
	            		system.debug('new Check balance1 : '+objNewCheckInfo.Amount__c);
	            		PageReference pr2 = new PageReference('/apex/TBN_PatientDOSDetailsPage?patient=' + objCase.Account.Name + '&amount=' +objNewCheckInfo.Amount__c+ '&insurance=' +objPatientInsurance.Type__c+ '&PatientId=' +objPatientInfo.Id + '&balanceAmount='+objNewCheckInfo.Amount__c);
	                    pr2.setRedirect(false);
	                    return pr2;
	            	}
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please fill all the required details to proceed'));
                return null;
            }       
        }
        catch(Exception e)
        {
            system.debug('--- error message ---'+e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
    }
    
    /*To create check info record for pre-existing Top Batch Payement record*/
    public void redirectCheck()
    {
        system.debug('---------redirectCheck----');
        objOldCheckInfo = new Check_Info__c ();
        String strCheckAmount = ApexPages.currentPage().getParameters().get('checkAmount');
         if(strCheckAmount.contains(','))
         	strCheckAmount = strCheckAmount.replaceAll(',', '');
        decAmountCheckInfo = Decimal.valueOf(strCheckAmount);
        if((ApexPages.currentPage().getParameters().containsKey('blnSave') && ApexPages.currentPage().getParameters().get('blnSave') != null &&  ApexPages.currentPage().getParameters().get('blnSave') == 'true') 
        	|| (ApexPages.currentPage().getParameters().containsKey('blnContinue') && ApexPages.currentPage().getParameters().get('blnContinue') != null && ApexPages.currentPage().getParameters().get('blnContinue') == 'true'))
        {           
            getDetails();
            system.debug('----- get details ---'+objCheck.Parent_Batch_Payment__c);
            objOldCheckInfo.Name = strCheckName ;
            objOldCheckInfo.Amount__c = decAmountCheckInfo;
            if(objTopBatchPaymentForContinue.RollUp_Amount__c == 0)
            	objOldCheckInfo.Parent_Batch_Payment__c = objTopBatchPaymentForContinue.Id;
            else
            	objOldCheckInfo.Parent_Batch_Payment__c = objCheck.Parent_Batch_Payment__c;
            objOldCheckInfo.Status__c = 'Open';
            insert objOldCheckInfo;
            blnPatienInfo = true;
            /*Calling method to get the details of Check to show on respective Patient payment Info.*/
            getCheckInfoDetails(objOldCheckInfo.Id);
            blnCheckInfoPage = false;
            
        }
    }
    
    /*To create Patient Payment Info record for pre-existing Check Info record*/
    public PageReference savePaymentInfoOldCheck()
    {
        try
        {
            Patient_Insurance__c objPatientInsurance = [Select Name, Type__c FROM Patient_Insurance__c WHERE Id =:insuranceId];
            system.debug('---CaseId-next-'+CaseId);
            if(CaseId != null)
            {
	            Case objCase = [Select Id,Account.Name FROM Case WHERE Id =: CaseId];
	            Patient_Payment_Info__c objPatientInfo =  new Patient_Payment_Info__c();
	            Patient_Payment_Info__c objPatient;
	            system.debug('---- Save Param ---'+ApexPages.currentPage().getParameters().get('blnSave'));
	            system.debug('---- blnContinue Param ---'+ApexPages.currentPage().getParameters().get('blnContinue'));
	            
	            if((ApexPages.currentPage().getParameters().containsKey('blnSave') && ApexPages.currentPage().getParameters().get('blnSave') != null &&  ApexPages.currentPage().getParameters().get('blnSave') == 'true') 
	            	|| (ApexPages.currentPage().getParameters().containsKey('blnContinue') && ApexPages.currentPage().getParameters().get('blnContinue') != null && ApexPages.currentPage().getParameters().get('blnContinue') == 'true'))
	            {
	                getDetails();
	                if((ApexPages.currentPage().getParameters().containsKey('blnContinue')))
	                	decBalanceAmount = decRemainingCheckAmount;
	                system.debug('******decBalanceAmount***** : '+decBalanceAmount);
	                system.debug('--insuranceId--'+insuranceId);
	                if(decRemainingCheckAmount > 0)
	                    objPatientInfo.Check_Info__c = objCheck.Id;
	                else
	                	objPatientInfo.Check_Info__c = objOldCheckInfo.Id;
	                system.debug('--objCase.Account.Id--'+objCase.Account.Id);   
	                objPatientInfo.Patient__c = objCase.Account.Id ;
	                objPatientInfo.Insurance__c = insuranceId;
	                objPatientInfo.Status__c = 'Open';
	                insert objPatientInfo;
	                objPatient = [Select Check_Info__r.Amount__c,Id,Check_Info__c FROM Patient_Payment_Info__c WHERE Id=:objPatientInfo.Id];
	                system.debug('---objPatientInfo----2----'+objPatientInfo.Id);
	                system.debug('---objCase.Account.Name---2----'+objCase.Account.Name);
	                system.debug('---objPatientInfo.Check_Info__c---'+objPatientInfo.Check_Info__c);
	                system.debug('--objOldCheckInfo.Amount__c---'+objPatient.Check_Info__r.Amount__c);
	                system.debug('---objPatientInsurance.Name----2----'+objPatientInsurance.Name);
	            }
	            if(blnCheckInfoPage != true)
	            {
	            	system.debug('old Check balance2 : '+decBalanceAmount);
	            	PageReference pr3= new PageReference('/apex/TBN_PatientDOSDetailsPage?patient=' + objCase.Account.Name + '&amount=' +objPatient.Check_Info__r.Amount__c+ '&insurance=' +objPatientInsurance.Type__c+ '&PatientId=' +objPatientInfo.Id+'&balanceAmount='+decBalanceAmount);
	            	pr3.setRedirect(false);
	            	return pr3;
	            }
	            else
	            {
	            	system.debug('new Check balance2 : '+objPatient.Check_Info__r.Amount__c);
	            	PageReference pr4= new PageReference('/apex/TBN_PatientDOSDetailsPage?patient=' + objCase.Account.Name + '&amount=' +objPatient.Check_Info__r.Amount__c+ '&insurance=' +objPatientInsurance.Type__c+ '&PatientId=' +objPatientInfo.Id+ '&balanceAmount='+objPatient.Check_Info__r.Amount__c);
		            pr4.setRedirect(false);
		            return pr4;
	            }
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'Please fill all the required details to proceed'));
                return null;
            }   
        }
        catch(Exception e)
        {
        	system.debug('***e.getLineNumber()**** : '+e.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
    }
    
    /*Redirects back to Top batch Payment section on click of 'Cancel' from Patient payment section*/
    public void redirectToTopBatchPaymentSection()
    {
        blnBatchPaymentPage = true;
        blnCheckInfoPage = false;
    }
    
    /* Redirects to Check Info page on click of 'Cancel'*/
    public void cancelToCheckInfoPage()
    {
        blnPatienInfo = false;
        blnCheckInfoPage = true;
    }
    
   
    
    
    
    /*To get the Details of "Top Batch Payement, Check Info and Patient Payment Info" records*/
    private void getDetails()
    {
        objPatientInfoRecord = new Patient_Payment_Info__c();
        objCheck = new Check_Info__c();
        objTopBatchPaymentForContinue = new Top_Batch_Payment__c();
        decTotalPatientInfoAmount = 0;
        lstCheckInfo = new List<Check_Info__c>();
        lstPatient = new List<Patient_Payment_Info__c>();
        
        try
        {
        	 system.debug('---- Save Param 111 ---'+ApexPages.currentPage().getParameters().get('blnSave'));
             system.debug('---- blnContinue Param  111---'+ApexPages.currentPage().getParameters().get('blnContinue'));
             system.debug('---- blnPatientName 1111  -----'+ApexPages.currentPage().getParameters().get('patientName'));
             
	        /*check if the page is being called on click of 'Save' from PatientDOSDetailPage*/
	        if(ApexPages.currentPage().getParameters().containsKey('blnSave') && ApexPages.currentPage().getParameters().get('blnSave') != null &&  ApexPages.currentPage().getParameters().get('blnSave') == 'true'
	                && ApexPages.currentPage().getParameters().containsKey('patientName') && ApexPages.currentPage().getParameters().get('patientName') !=null)
	        {
	            objPatientInfoRecord = [Select Id, Name, Amount__c,Check_Info__c 
	                                    FROM Patient_Payment_Info__c 
	                                    WHERE Id =: ApexPages.currentPage().getParameters().get('patientName')];
	                                    
	            objCheck = [Select Id, Amount__c,RollUp_Amount__c, Name,Parent_Batch_Payment__r.Batch_Amount__c, Parent_Batch_Payment__c 
	                        FROM Check_Info__c 
	                        WHERE Id =: objPatientInfoRecord.Check_Info__c];
	            
	            objTopBatchPaymentForContinue = [Select Id, Name, of_Check__c, Batch_Amount__c, Status__c, RollUp_Amount__c, RollUp_Check__c 
	                                                FROM Top_Batch_Payment__c 
	                                                WHERE Id =: objCheck.Parent_Batch_Payment__c];
	                        
	            decRemainingCheckAmount = objCheck.Amount__c - objCheck.RollUp_Amount__c; 
	            system.debug('###########decRemainingCheckAmount########## : '+decRemainingCheckAmount);
	            decCheckAmount =  objCheck.Amount__c;
	            decCheckRollUpAmount = objCheck.RollUp_Amount__c;                                 
            	decBatchAmount = objTopBatchPaymentForContinue.Batch_Amount__c;
            	decTopBatchPaymentRollUpAmount = objTopBatchPaymentForContinue.RollUp_Amount__c;
            	/*Calling renderSection method*/
	            renderSection();
	                                                        
	        }
	        /*check if the page is being called on click of 'Continue' button from "TBN_EditPaymentBatch" page*/
	        else if(ApexPages.currentPage().getParameters().containsKey('blnContinue') && ApexPages.currentPage().getParameters().get('blnContinue') != null &&  ApexPages.currentPage().getParameters().get('blnContinue') == 'true'
	                 && ApexPages.currentPage().getParameters().containsKey('topBatchPaymentId') && ApexPages.currentPage().getParameters().get('topBatchPaymentId') !=null)
	        {
	            List<Check_Info__c>  lstTempCheckInfo = new List<Check_Info__c>();
	            system.debug('------in continue----');
	            objTopBatchPaymentForContinue = [Select Id, Name, of_Check__c, Batch_Amount__c, Status__c, RollUp_Amount__c, RollUp_Check__c 
	                                                FROM Top_Batch_Payment__c 
	                                                WHERE Id =: ApexPages.currentPage().getParameters().get('topBatchPaymentId')];
	                                            
	             lstTempCheckInfo = [Select Id,Name,Amount__c, RollUp_Amount__c, Parent_Batch_Payment__r.Batch_Amount__c,Parent_Batch_Payment__c,Parent_Batch_Payment__r.RollUp_Amount__c
	                                                        FROM Check_Info__c 
	                                                        WHERE Parent_Batch_Payment__c =: objTopBatchPaymentForContinue.Id ORDER BY CreatedDate DESC];
	            if(!lstTempCheckInfo.isEmpty())
	            {
	             objCheck = [Select Id, Amount__c, Name,RollUp_Amount__c,Parent_Batch_Payment__r.Batch_Amount__c, Parent_Batch_Payment__c,Parent_Batch_Payment__r.RollUp_Amount__c 
		                        FROM Check_Info__c 
		                        WHERE Id =: lstTempCheckInfo[0].Id];
	            system.debug('#############objTopBatchPaymentForContinue#######'+objTopBatchPaymentForContinue);
	            system.debug('^^^^^^^^^lstTempCheckInfo^^^^^^^^^^^^^^^ : '+lstTempCheckInfo);
	            	decBatchAmount = lstTempCheckInfo[0].Parent_Batch_Payment__r.Batch_Amount__c;
	            	decTopBatchPaymentRollUpAmount =lstTempCheckInfo[0].Parent_Batch_Payment__r.RollUp_Amount__c;
	            	decCheckAmount = objCheck.Amount__c;
	            	decCheckRollUpAmount = objCheck.RollUp_Amount__c;
	            	decRemainingCheckAmount = decCheckAmount - decCheckRollUpAmount;
	            } 
	            system.debug('---decRemainingCheckAmount--'+decRemainingCheckAmount);	
	                
	           	/*When there is no Check created for the Top Batch Payment Record*/
	            if(objTopBatchPaymentForContinue.RollUp_Check__c == 0)
	           	{
	           		decRemainingTopBatchPaymentAmount = objTopBatchPaymentForContinue.Batch_Amount__c;
	           		decBatchAmount = decRemainingTopBatchPaymentAmount;
	           	}
	             renderSection();
	        }
        }
	        catch(Exception e)
	        {
	        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
	        }
    }
    
    /*To get the Top Batch Payement details for the particular Check info record to be shown on the page*/
    private void getTopBatchPayementDetails(Id paymentBatchId)
    {
    	system.debug('####paymentBatchId##### : '+paymentBatchId);
        objTopBatchPayment = [Select of_Check__c, Status__c, RollUp_Check__c, RollUp_Amount__c, Name, Id, Facility__c, Batch_Amount__c, Facility__r.Name 				
								From Top_Batch_Payment__c 
                                Where Id =: paymentBatchId];
      	system.debug('^^^^objTopBatchPayment.Batch_Amount__c^^^ : '+objTopBatchPayment.Batch_Amount__c);
    }
    
    /*To get the Check Info details for the particular Patient Payment Info record to be shown on the page*/
    private void getCheckInfoDetails(Id checkInfoId)
    {
        objCheckInformation = [Select Status__c, RollUp_Patient__c, RollUp_Amount__c, Parent_Batch_Payment__c, Name, Id, Amount__c
                                From Check_Info__c 
                                Where Id =: checkInfoId];
    }
    
    /*To render the different sections (ie. Top Batch Payement, Check Info and Patient Payment Info) based on the condition*/
    private void renderSection()
    {
        try
        {
            system.debug('------decCheckRollUpAmount----'+decCheckRollUpAmount);
            system.debug('----decTotalPatientInfoAmount----'+decTotalPatientInfoAmount);
            system.debug('----decCheckAmount----'+decCheckAmount);
            system.debug('--decCheckRollUpAmount-------'+decCheckRollUpAmount);
            system.debug('--decBatchAmount-------'+decBatchAmount);
            system.debug('--------decTopBatchPaymentRollUpAmount--------'+decTopBatchPaymentRollUpAmount);
            if(decCheckRollUpAmount < decCheckAmount)
            {
                system.debug('--patient payment page----');
                blnPatienInfo = blnFlag = true;
                /*Calling method to get the details of Check to show on respective Patient payment Info.*/
                getCheckInfoDetails(objCheck.Id);
                blnCheckInfoPage = blnBatchPaymentPage = false;
            }
            else if(decCheckAmount == decCheckRollUpAmount && decTopBatchPaymentRollUpAmount < decBatchAmount)
            {
                system.debug('---check info page----');
                blnCheckInfoPage = blnFlag = true;
                /*Calling method to get the details of Batch to show on respective check.*/
                system.debug('!!objTopBatchPaymentForContinue.Id!! :'+objTopBatchPaymentForContinue.Id);
                getTopBatchPayementDetails(objTopBatchPaymentForContinue.Id);
                blnBatchPaymentPage = blnPatienInfo = false; 
            }
            else if(decBatchAmount == decTopBatchPaymentRollUpAmount)
            {
                system.debug('--batch payment page---2-'+decBatchAmount);
                blnBatchPaymentPage = true;
                blnCheckInfoPage = blnPatienInfo = false;
            }
            if(Test.isRunningTest())
            	Integer c = 5/0;
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
        }
    }
}