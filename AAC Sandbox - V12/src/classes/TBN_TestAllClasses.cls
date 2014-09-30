@isTest(SeeAllData=false)
private class TBN_TestAllClasses 
{
	/*This is the Test class for "TBN_SubmitAndPrintBatchController.cls"*/
    static testMethod void TBN_SubmitAndPrintBatchController_Test() 
    {
    	
        Facility__c objFac = new Facility__c();
        objFac.Name = 'Forterus';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        
        Account objAcc = new Account();
        objAcc.FirstName = 'Test';
        objAcc.LastName = 'Account';
        insert objAcc;   
        
        Case objCase = new Case();
        objCase.Treatment_Facility__c = 'Forterus';
        objCase.AccountId = objAcc.Id;
        insert objCase;
        
        Insurance_Company__c  objINC = new Insurance_Company__c();
        objINC.Name = 'Test Insurance';
        objINC.Send_Electronically__c = true;
        insert objINC;
        
        Utilization_Review__c objUR = new Utilization_Review__c();
        objUR.TreatmentFacility__c = objFac.Id;
        objUR.Completed_By__c = 'Test User';
        objUR.Completed_Date__c = Datetime.now();
        objUR.Case__c = objCase.Id;
        objUR.Insurance_CompanyLookUp__c = objINC.Id;
        objUR.First_DOS_Billed__c = Date.today().addDays(-2);
        //objUR.Account__c = objAcc.Id;
        insert objUR;
        
        Bill_Amounts__c objBA = new Bill_Amounts__c();
        objBA.Level_of_Care__c = 'IR';
        objBA.Amount__c = 200;
        objBA.Facility__c = objFac.Id;
        insert objBA;
        
        Dates_of_Service__c objDOS = new Dates_of_Service__c();
        objDOS.Level_of_Care__c = 'IR';
        objDOS.Status__c = 'Selected';
        objDOS.Bill_Status__c = 'Selected';
        objDOS.Utilization_Review_Form__c = objUR.Id;
        objDOS.Start_Date__c = Date.today().addDays(-2);
        objDOS.End_Date__c = Date.today().addDays(-2);
        objDOS.Day_of_Week__c = '5';
        objDOS.Total_Days_Authorized__c = 4;
        objDOS.Authorization_Number__c = '123';
        objDOS.CM__c = 'Test CM';
        objDOS.Date_of_Review__c = Date.Today();
        objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
        objDOS.Level_of_Care_Description__c = 'Test';   
        objDOS.Amount__c = 1000;  
        //objDOS.Account__c =  objAcc.Id; 
        insert objDOS;
        
     
        
        
        TBN_SubmitAndPrintBatchController objPrintBatch = new TBN_SubmitAndPrintBatchController();    
        PageReference PageRef = Page.TBN_SubmitAndPrintBatch;
    	Test.setCurrentPage(PageRef);
    	ApexPages.currentPage().getParameters().put('facility', 'TestFacility');
    	
        objPrintBatch.sortExpression = 'Facility__c';
        objPrintBatch.getSortDirection();
        objPrintBatch.saveData();
        objPrintBatch.updateAmount();
        objPrintBatch.sort();
        objPrintBatch.ReProcess();
        objPrintBatch.printBatchData();
        
        Case objCase1 = new Case();
        objCase1.Treatment_Facility__c = 'Forterus';        
        insert objCase1;
        
        Insurance_Company__c  objINC1 = new Insurance_Company__c();
        objINC1.Name = 'Test Insurance';
        objINC1.Send_Electronically__c = false;
        insert objINC1;
        
        Utilization_Review__c objUR1 = new Utilization_Review__c();
        objUR1.TreatmentFacility__c = objFac.Id;
        objUR1.Completed_By__c = 'Test User';
        objUR1.Completed_Date__c = Datetime.now();
        objUR1.Case__c = objCase1.Id;
        objUR1.Insurance_CompanyLookUp__c = objINC1.Id;
       // objUR1.Account__c = objAcc.Id;
        insert objUR1;
        
        Dates_of_Service__c objDOS1 = new Dates_of_Service__c();
        objDOS1.Level_of_Care__c = 'IR';
        objDOS1.Status__c = 'Selected';
        objDOS1.Bill_Status__c = 'Selected';
        objDOS1.Utilization_Review_Form__c = objUR1.Id;
        objDOS1.Start_Date__c = Date.today().addDays(-2);
        objDOS1.End_Date__c = Date.today().addDays(-2);
        objDOS1.Day_of_Week__c = '5';
        objDOS1.Total_Days_Authorized__c = 4;
        objDOS1.Authorization_Number__c = '123';
        objDOS1.CM__c = 'Test CM';
        objDOS1.Date_of_Review__c = Date.Today();
        objDOS1.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
        objDOS1.Level_of_Care_Description__c = 'Test'; 
        //objDOS1.Account__c = objAcc.Id;       
        insert objDOS1;
        
        TBN_SubmitAndPrintBatchController objPrintBatch1 = new TBN_SubmitAndPrintBatchController();            
        PageReference PageRef1 = Page.TBN_SubmitAndPrintBatch;
    	Test.setCurrentPage(PageRef1);
    	ApexPages.currentPage().getParameters().put('facility', 'TestFacility');
    	
        objPrintBatch1.sortExpression = 'Facility__c';
        objPrintBatch1.setSortDirection('ASC');
        objPrintBatch1.getSortDirection();
        objPrintBatch1.saveData();
        objPrintBatch1.updateAmount();
        objPrintBatch1.sort();
        objPrintBatch1.ReProcess();
        objPrintBatch1.printBatchData();      
        
    }
    
    /*This is the Test class for TBN_Select_DOS_Charges.cls */
    static testMethod void TBN_Select_DOS_Charges_Test() 
    {
        ApexPages.currentPage().getParameters().put('facility', 'TestFacility');
        ApexPages.currentPage().getParameters().put('LevelOfCare', 'EAP');
        ApexPages.currentPage().getParameters().put('Status', 'ReSubmit');
        ApexPages.currentPage().getParameters().put('Format', 'Send Electronically');
        
        Facility__c objFac = new Facility__c();
        objFac.Name = 'TestFacility';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Case objCase = new Case();
        insert objCase;
        
        Utilization_Review__c objUR = new Utilization_Review__c();
        objUR.TreatmentFacility__c = objFac.Id;
        objUR.Completed_By__c = 'Test User';
        objUR.Completed_Date__c = Datetime.now();  
        objUR.Case__c = objCase.Id;    
        //objUR.Account__c =  objAcc.id; 
        insert objUR;
        
        
        Bill_Amounts__c objBA = new Bill_Amounts__c();
        objBA.Level_of_Care__c = 'IR';
        objBA.Amount__c = 200;
        objBA.Facility__c=objFac.Id;        
        insert objBA;
        
        Dates_of_Service__c objDOS = new Dates_of_Service__c();
        objDOS.Level_of_Care__c = 'IR';
        objDOS.Status__c = '';
        objDOS.Utilization_Review_Form__c = objUR.Id;
        objDOS.Start_Date__c = Date.today().addDays(-1);
        objDOS.End_Date__c = Date.today().addDays(-1);
        objDOS.Day_of_Week__c = '5';
        objDOS.Total_Days_Authorized__c = 4;
        objDOS.Billable_Day__c = true;
        objDOS.Authorization_Number__c = '123';
        objDOS.CM__c = 'Test CM';
        objDOS.Date_of_Review__c = Date.Today();
        objDOS.Level_of_Care_Description__c = 'Test';
        objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
        //objDOS.Account__c = objAcc.Id;
        insert objDOS;
        
        Dates_of_Service__c objDOS1 = new Dates_of_Service__c();
        objDOS1.Level_of_Care__c = 'IR';
        objDOS1.Status__c = 'Reprocess';
        objDOS1.Utilization_Review_Form__c = objUR.Id;
        objDOS1.Start_Date__c = Date.today().addDays(-2);
        objDOS1.End_Date__c = Date.today().addDays(-2);
        objDOS1.Day_of_Week__c = '5';
        objDOS1.Total_Days_Authorized__c = 4;
        objDOS1.Billable_Day__c = true;
        objDOS1.Authorization_Number__c = '123';
        objDOS1.CM__c = 'Test CM';
        objDOS1.Date_of_Review__c = Date.Today();
        objDOS1.Level_of_Care_Description__c = 'Test';
        objDOS1.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
       // objDOS1.Account__c = objAcc.Id;
        insert objDOS1;
         
        
        
        Apexpages.StandardSetController objSet = new Apexpages.StandardSetController(Database.getQueryLocator('Select Id, Level_of_Care__c, Status__c, Review_Assigned_To_Lookup__c, Level_of_Care_Description__c, Utilization_Review_Form__c, Start_Date__c, End_Date__c, Day_of_Week__c, Total_Days_Authorized__c, Authorization_Number__c, CM__c, Date_of_Review__c from Dates_of_Service__c')); 
        
        String strQuery='Select Id, Level_of_Care__c, Status__c, Review_Assigned_To_Lookup__c, Level_of_Care_Description__c, Utilization_Review_Form__c, Start_Date__c, End_Date__c, Day_of_Week__c, Total_Days_Authorized__c, Authorization_Number__c, CM__c, Date_of_Review__c from Dates_of_Service__c';
        List<Dates_of_Service__c> lstDisplayedDOS=new List<Dates_of_Service__c>();
        lstDisplayedDOS = Database.Query(strQuery);
        
        TBN_Select_DOS_Charges objDOSCharges = new TBN_Select_DOS_Charges();
        objDOSCharges.getDocWrapper(lstDisplayedDOS);
        objDOSCharges.renderToViewSelectedDOScharges();
       // objDOSCharges.ExportPdf();
        //objDOSCharges.doNext();
        //objDOSCharges.doPrevious();
        objDOSCharges.doSelectItem();
        objDOSCharges.doDeselectItem();
        objDOSCharges.nextPage();
        objDOSCharges.previousPage();
		objDOSCharges.getSortDirection();
		objDOSCharges.setSortDirection('ASC');
        objDOSCharges.lastPage();
        objDOSCharges.nextPage();
        objDOSCharges.updateStatusOfDOS();
        objDOSCharges.selectAll();
        objDOSCharges.firstPage();
        objDOSCharges.sortExpression = 'Level_of_Care__c';
        objDOSCharges.sort();
        objDOSCharges.closePopup();
        objDOSCharges.Save();
        
        Dates_of_Service__c objDos11=[select Bill_Status__c,Amount__c From Dates_of_Service__c where Id=:objDOS1.Id];
        System.debug('------------DOs--------'+objDos11);
        //System.assertEquals(objDos11.Bill_Status__c, 'Selected');
        //System.assertEquals(objDos11.Amount__c, objBA.Amount__c);
        
        
        objDOSCharges.renderToViewSelectedDOScharges();
        
        
        //TBN_Select_DOS_Charges.WrapperSelectDOSCharges(objDOS, true, 250);
        
        /*objDOSCharges.previous();
        objDOSCharges.next();*/
        
        
        ApexPages.currentPage().getParameters().put('LevelOfCare', 'AP');
        ApexPages.currentPage().getParameters().put('Format', 'Send non');
        TBN_Select_DOS_Charges objDOSCharges1 = new TBN_Select_DOS_Charges();
        objDOSCharges1.isAllSelected=true;
        
        ApexPages.currentPage().getParameters().put('LevelOfCare', 'EAP');
        ApexPages.currentPage().getParameters().put('Format', 'Send Ele');
        TBN_Select_DOS_Charges objDOSCharges2 = new TBN_Select_DOS_Charges();
        
        ApexPages.currentPage().getParameters().put('LevelOfCare', 'AP');
        ApexPages.currentPage().getParameters().put('Format', 'Send Electronically');
        TBN_Select_DOS_Charges objDOSCharges3= new TBN_Select_DOS_Charges();
      }
    
    
    
    /*This is the Test class for  TBN_Submitted_DOS.cls */
    static testMethod void TBN_Submitted_DOS_Test() 
    {
        Facility__c objFac = new Facility__c();
        objFac.Name = 'TestFacility';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Acc';
        insert objAcc;
        
        Case objCase = new Case();
        objCase.AccountId = objAcc.Id;
        insert objCase;
        
        Utilization_Review__c objUR = new Utilization_Review__c();
        objUR.TreatmentFacility__c = objFac.Id;
        objUR.Completed_By__c = 'Test User';
        objUR.Completed_Date__c = Datetime.now();  
        objUR.Case__c = objCase.Id;
       // objUR.Account__c = objAcc.Id;
        insert objUR;
        
        Bill_Amounts__c objBA = new Bill_Amounts__c();
        objBA.Level_of_Care__c = 'IR';
        objBA.Amount__c = 200;
        insert objBA;
        
        Dates_of_Service__c objDOS = new Dates_of_Service__c();
        objDOS.Level_of_Care__c = 'IR';
        objDOS.Status__c = 'submitted';
        objDOS.Utilization_Review_Form__c = objUR.Id;
        objDOS.Start_Date__c = Date.today().addDays(-2);
        objDOS.End_Date__c = Date.today().addDays(-1);
        objDOS.Day_of_Week__c = '5';
        objDOS.Total_Days_Authorized__c = 4;
        objDOS.Authorization_Number__c = '123';
        objDOS.CM__c = 'Test CM';
        objDOS.Date_of_Review__c = Date.Today();
        objDOS.Level_of_Care_Description__c = 'Test';
        objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
        objDOS.Amount__c = 250;
        //objDOS.Account__c = objAcc.Id;
        insert objDOS;
        ApexPages.currentPage().getParameters().put('patient', 'Acc');
        TBN_Submitted_DOS objClass = new TBN_Submitted_DOS();
        objClass.sortExpression = 'Level_of_Care__c';
        objClass.sort();
        objClass.getSortDirection();
        objClass.setSortDirection('ASC');
    	
        
    }
    
     /*This is the Test class for  TBN_UB04FormController.cls */
    
     static testMethod void TBN_UB04FormControllerTest()
     {
     	
		Claim__c objClaim=new Claim__c();
		objClaim.Status__c='submitted';
		objClaim.Facility__c='TestFacility';
		objClaim.Patient__c='testAccount';
		insert objClaim;
		
		Facility__c objFac = new Facility__c();
		objFac.Name = objClaim.Facility__c;
		objFac.Desired_Capacity__c = 250;
		insert objFac;
		
		Account objAcc = new Account();
		objAcc.Name = objClaim.Patient__c;
		insert objAcc;
		
		
		Case objCase = new Case();
		objCase.AccountId = objAcc.Id;
		insert objCase;
		
		Utilization_Review__c objUR = new Utilization_Review__c();
		objUR.TreatmentFacility__c = objFac.Id;
		objUR.Completed_By__c = 'Test User';
		objUR.Completed_Date__c = Datetime.now();  
		objUR.Case__c = objCase.Id;
		//objUR.Account__c = objAcc.Id;
		insert objUR;
		
		Dates_of_Service__c objDOS = new Dates_of_Service__c();
		objDOS.Level_of_Care__c = 'IR';
		objDOS.Status__c = 'submitted';
		objDOS.Start_Date__c = Date.today().addDays(-2);
		objDOS.End_Date__c = Date.today().addDays(-1);
		objDOS.Day_of_Week__c = '5';
		objDOS.Total_Days_Authorized__c = 4;
		objDOS.Authorization_Number__c = '123';
		objDOS.CM__c = 'Test CM';
		objDOS.Date_of_Review__c = Date.Today();
		objDOS.Level_of_Care_Description__c = 'Test';
		objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
		objDOS.Amount__c = 250;
		objDOS.Claim__c=objClaim.Id;
		objDOS.Utilization_Review_Form__c = objUR.Id;
		//objDOS.Account__c = objAcc.Id;
		insert objDOS;
		
		
		System.debug('---claimId--'+objClaim.Id); 
		ApexPages.currentPage().getParameters().put('claim',objClaim.Id);  
		TBN_UB04FormController  obj=new TBN_UB04FormController ();
		     	
     }
     
     /*This is the Test class for  TBN_updateDosStatus.trigger */
       
     static testMethod void TBN_updateDosStatus_Test()
     {
     	
     	Facility__c objFac = new Facility__c();
        objFac.Name = 'TestFacility';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        
        Case objCase = new Case();
        insert objCase;
        
        Account objAcc=new Account(name='TestAccount');
     	insert objAcc;
     	
        Utilization_Review__c objUR = new Utilization_Review__c();
        objUR.TreatmentFacility__c = objFac.Id;
        objUR.Completed_By__c = 'Test User';
        objUR.Completed_Date__c = Datetime.now();
        objUR.Case__c = objCase.Id;
        //objUR.Account__c = objAcc.Id;
        insert objUR;
        
        Bill_Amounts__c objBA = new Bill_Amounts__c();
        objBA.Level_of_Care__c = 'IR';
        objBA.Amount__c = 200;
        objBA.Facility__c = objFac.Id;
        insert objBA;
        
        Dates_of_Service__c objDOS = new Dates_of_Service__c();
        objDOS.Level_of_Care__c = 'IR';
        objDOS.Status__c = 'selected';
        objDOS.Bill_Status__c = 'Submitted';
        objDOS.Utilization_Review_Form__c = objUR.Id;
        objDOS.Start_Date__c = Date.today().addDays(-2);
        objDOS.End_Date__c = Date.today().addDays(-2);
        objDOS.Day_of_Week__c = '5';
        objDOS.Total_Days_Authorized__c = 4;
        objDOS.Authorization_Number__c = '123';
        objDOS.CM__c = 'Test CM';
        objDOS.Date_of_Review__c = Date.Today();
        objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
        objDOS.Level_of_Care_Description__c = 'Test';
        //objDOS.Account__c = objAcc.Id;
        insert objDOS;
        
        Dates_of_Service__History objHis=new Dates_of_Service__History();
        objHis.ParentId=objDOS.Id;
        objHis.Field='Bill_Status__c';
        insert objHis;
        
        objDOS.Level_of_Care_Description__c = 'Test1';
        objDOS.Bill_Status__c='submitted';
       
        
     	update objDOS;
     } 
     
    /* This is the test class for TBN_PostPaymentController */
    
    static testMethod void TBN_PostPaymentController_Test()
    {
    	
    	Facility__c objFac = new Facility__c();
        objFac.Name = 'TestFacility';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        
    	Top_Batch_Payment__c objTopBatchPayment=new Top_Batch_Payment__c();
    	
    	objTopBatchPayment.of_Check__c=2;
    	objTopBatchPayment.Status__c='Open';
    	objTopBatchPayment.Facility__c = objFac.Id;
    	objTopBatchPayment.Batch_Amount__c=200;
    	objTopBatchPayment.Name='test';
    	
    	insert objTopBatchPayment;
    	
    	TBN_PostPaymentController objPostPaymentController=new TBN_PostPaymentController();
    	objPostPaymentController.editTopBatchPaymentId=objTopBatchPayment.Id;
    	objPostPaymentController.editTopBatchPayment();
    	objPostPaymentController.getSortDirection();
    	objPostPaymentController.setSortDirection('ASC');
    	objPostPaymentController.sortExpression='Status__c';
    	objPostPaymentController.sort();
    	
    }
    
    /* This is the test class for TBN_PatientDOSDetailsController */
    
    static testMethod void TBN_PatientDOSDetailsController_Test()
    {
    	
    	ApexPages.currentPage().getParameters().put('patient', '');
        ApexPages.currentPage().getParameters().put('insurance', 'insurance1');
        ApexPages.currentPage().getParameters().put('amount','600');
        
        Account objAcc=new Account(name='TestAccount');
     	insert objAcc;
     	
    	Facility__c objFac = new Facility__c();
        objFac.Name = 'TestFacility';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        
        Case objCase = new Case();
        objCase.AccountId = objAcc.Id;
        insert objCase;
        
        Utilization_Review__c objUR = new Utilization_Review__c();
        objUR.TreatmentFacility__c = objFac.Id;
        objUR.Completed_By__c = 'Test User';
        objUR.Completed_Date__c = Datetime.now();  
        objUR.Case__c = objCase.Id;
       // objUR.Account__c = objAcc.Id;
        insert objUR;
        
        Bill_Amounts__c objBA = new Bill_Amounts__c();
        objBA.Level_of_Care__c = 'IR';
        objBA.Amount__c = 200;
        objBA.Facility__c=objFac.Id;
        insert objBA;
        
        
        Top_Batch_Payment__c objTopBatchPayment=new Top_Batch_Payment__c();
    	objTopBatchPayment.of_Check__c=2;
    	objTopBatchPayment.Status__c='open';
    	objTopBatchPayment.Facility__c=objFac.Id;
    	objTopBatchPayment.Batch_Amount__c=200;
    	objTopBatchPayment.Name='test';    	
    	insert objTopBatchPayment;
    	
     	Check_Info__c objCheckInfo=new Check_Info__c();
     	objCheckInfo.Name='testcheckInfo';
     	objCheckInfo.Amount__c=150;
     	objCheckInfo.Parent_Batch_Payment__c=objTopBatchPayment.id;
     	insert objCheckInfo;
     	
         
     	Patient_Payment_Info__c objPatientPaymentInfo=new Patient_Payment_Info__c();
     	objPatientPaymentInfo.Patient__c=objAcc.id;
     	objPatientPaymentInfo.Check_Info__c=objCheckInfo.Id; 
     	objPatientPaymentInfo.Amount__c=180;
     	insert objPatientPaymentInfo;
     	
     	Dates_of_Service__c objDOS = new Dates_of_Service__c();
        objDOS.Level_of_Care__c = 'IR';
        objDOS.Status__c = '';
        objDOS.Utilization_Review_Form__c = objUR.Id;
        objDOS.Start_Date__c = Date.today().addDays(-1);
        objDOS.End_Date__c = Date.today().addDays(2);
        objDOS.Day_of_Week__c = '5';
        objDOS.Total_Days_Authorized__c = 4;
        objDOS.Billable_Day__c = true;
        objDOS.Authorization_Number__c = '123';
        objDOS.CM__c = 'Test CM';
        objDOS.Date_of_Review__c = Date.Today();
        objDOS.Level_of_Care_Description__c = 'Test';
        objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
        //objDOS.Amount_Paid__c = 1000;
        objDOS.Amount__c = 1500;
       // objDOS.Account__c = objAcc.Id;
        objDOS.Bill_Status__c = 'Submitted';
        //objDOS.Patient_Responsibility_Amount__c = 100;
        //objDOS.Insurance_Adjusted_Amount__c = 500;
        //objDOS.Allowed_Amount__c = 200;
        objDOS.Adjustment_Type__c = 'Secondary Insurance';
        //objDOS.PatientPaymentInfo__c = objPatientPaymentInfo.Id;
        insert objDOS;
        
        system.debug('---------objDOS.Bill_Status__c-----------'+objDOS.Bill_Status__c);
        system.debug('--------objDOS.PatientPaymentInfo__c----------'+objDOS.PatientPaymentInfo__c);
        
        ApexPages.currentPage().getParameters().put('PatientId',objPatientPaymentInfo.Id); 
        
        /*
        Dates_of_Service__c objDOS1 = new Dates_of_Service__c();
        objDOS1.Level_of_Care__c = 'IR';
        objDOS1.Status__c = 'Reprocess';
        objDOS1.Utilization_Review_Form__c = objUR.Id;
        objDOS1.Start_Date__c = Date.today().addDays(-2);
        objDOS1.End_Date__c = Date.today().addDays(-2);
        objDOS1.Day_of_Week__c = '5';
        objDOS1.Total_Days_Authorized__c = 4;
        objDOS1.Billable_Day__c = true;
        objDOS1.Authorization_Number__c = '123';
        objDOS1.CM__c = 'Test CM';
        objDOS1.Date_of_Review__c = Date.Today();
        objDOS1.Level_of_Care_Description__c = 'Test';
        objDOS1.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
        objDOS1.Amount_Paid__c = 800;
        insert objDOS1;
         */
        TBN_PatientDOSDetailsController objPatientDOSDetailsController=new TBN_PatientDOSDetailsController();
        
        objPatientDOSDetailsController.decAmount=1000;
       /* objPatientDOSDetailsController.strUpdatedPaidAmount='1000,100,0,';
        objPatientDOSDetailsController.strUpdatedAllowedAmount='500,20,30,';
        objPatientDOSDetailsController.strUpdatedInsuranceAmount='200,100,50,';
        objPatientDOSDetailsController.strUpdatedPatientAmount='500,100,20,';
        objPatientDOSDetailsController.strUpdatedPatientStatus = 'Paid,none,none,';
        objPatientDOSDetailsController.strUpdatedAdjustmentType = 'Secondary Insurance,none,none,';*/
        objPatientDOSDetailsController.strEditedDosiIDs =  objDOS.Id;
        
        objPatientDOSDetailsController.saveDOSPatientRecord();
        objPatientDOSDetailsController.cancelToPatienPaymentInfo();
        objPatientDOSDetailsController.setSortDirection('ASC');
        objPatientDOSDetailsController.getSortDirection();
        objPatientDOSDetailsController.sortExpression='Facility__c';
        objPatientDOSDetailsController.sort();
        ApexPages.currentPage().getParameters().put('patient', 'TestAccount');
        ApexPages.currentPage().getParameters().put('balanceAmount', String.Valueof(objCheckInfo.Amount__c));
        
        
        
        TBN_PatientDOSDetailsController objPatientDOSDetailsController1 = new TBN_PatientDOSDetailsController();
        objPatientDOSDetailsController1.decAmount=1000;
        //objPatientDOSDetailsController.strUpdatedAmount='100,200,300';
        objPatientDOSDetailsController1.saveDOSPatientRecord();
        objPatientDOSDetailsController1.cancelToPatienPaymentInfo();
        objPatientDOSDetailsController1.setSortDirection('');
        objPatientDOSDetailsController1.getSortDirection();
        objPatientDOSDetailsController1.sortExpression='Facility__c';
        objPatientDOSDetailsController1.sort();
        
    	
    }
    
    /* This is the test class for TBN_CreateNewPayemBatchController */
     static testMethod void TBN_CreateNewPayemBatchController_Test()
     {
     	
     	ApexPages.currentPage().getParameters().put('blnCancel','false');
     	ApexPages.currentPage().getParameters().put('blnSave','true');
     	ApexPages.currentPage().getParameters().put('amount','5000');
     	ApexPages.currentPage().getParameters().put('numberOfCheck','1');
     	ApexPages.currentPage().getParameters().put('blnContinue','true');
     	
     	RecordType objRecordType =  [Select SobjectType, Id From RecordType where SobjectType = 'Case' limit 1];
     	
     	Facility__c objFac = new Facility__c();
        objFac.Name = 'TestFacility';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        	
     	Account objAcc=new Account(name='TestAccount');
     	insert objAcc;
     	
     	Case objCase = new Case();
     	objCase.AccountId = objAcc.Id;
     	objCase.RecordTypeId = objRecordType.Id;
     	insert objCase;
     	
     	
     	Top_Batch_Payment__c objTopBatchPayment=new Top_Batch_Payment__c();
    	objTopBatchPayment.of_Check__c=2;
    	objTopBatchPayment.Status__c='Open';
    	objTopBatchPayment.Facility__c=objFac.Id;
    	objTopBatchPayment.Batch_Amount__c=200;
    	objTopBatchPayment.Name='test';    	
    	insert objTopBatchPayment;
    	
     	Check_Info__c objCheckInfo=new Check_Info__c();
     	objCheckInfo.Name='testcheckInfo';
     	objCheckInfo.Amount__c=150;
     	objCheckInfo.Parent_Batch_Payment__c=objTopBatchPayment.id;
     	insert objCheckInfo;
     	
         
     	Patient_Payment_Info__c objPatientPaymentInfo=new Patient_Payment_Info__c();
     	objPatientPaymentInfo.Patient__c=objAcc.id;
     	objPatientPaymentInfo.Check_Info__c=objCheckInfo.Id; 
     	objPatientPaymentInfo.Amount__c=180;
     	insert objPatientPaymentInfo;
     	
     	Patient_Insurance__c objPatientInsurance = new Patient_Insurance__c();
     	objPatientInsurance.Insurance_Code__c = 'INC-001';
     	objPatientInsurance.Patient__c = objAcc.Id;
     	objPatientInsurance.Type__c = 'Primary';
     	insert objPatientInsurance;
     	
     	ApexPages.currentPage().getParameters().put('patientName',objPatientPaymentInfo.Id);
     	
     	ApexPages.StandardController sc = new ApexPages.standardController(objTopBatchPayment);
     	TBN_CreateNewPayemBatchController objCreateNewPayemBatchController=new TBN_CreateNewPayemBatchController(sc);
     	objCreateNewPayemBatchController.blnBatchPaymentPage = true;
     	objCreateNewPayemBatchController.blnCheckInfoPage = objCreateNewPayemBatchController.blnPatienInfo = false;
     	objCreateNewPayemBatchController.redirectToCheckInfoPage();
     	objCreateNewPayemBatchController.strFacility ='TestFacility';
     	objCreateNewPayemBatchController.strPaymentName = 'PB-001'; 
     	objCreateNewPayemBatchController.insuranceId = objPatientInsurance.Id;
     	objCreateNewPayemBatchController.CaseId = objCase.Id;
     	
     	objCreateNewPayemBatchController.redirectToCheckInfoPage();
     	objCreateNewPayemBatchController.redirectToPostPaymentPage();
     	ApexPages.currentPage().getParameters().put('checkAmount','2500');
     	objCreateNewPayemBatchController.strCheckName = 'CK-001';
     	objCreateNewPayemBatchController.redirectTopPatientPaymentInfoPage();
     	objCreateNewPayemBatchController.redirectToTopBatchPaymentSection();
     	objCreateNewPayemBatchController.redirectCheck();
     	objCreateNewPayemBatchController.cancelToCheckInfoPage();
     	ApexPages.currentPage().getParameters().put('patientAmount','2000');  
     	objCreateNewPayemBatchController.savePatientPaymentInfoPage();
     	objCreateNewPayemBatchController.savePaymentInfoOldCheck();
     	
     	/*Test function 2nd time calling */
     	
     	ApexPages.currentPage().getParameters().put('blnCancel','false');
     	ApexPages.currentPage().getParameters().put('blnSave','test');
     	ApexPages.currentPage().getParameters().put('amount','5000');
     	ApexPages.currentPage().getParameters().put('numberOfCheck','1');
     	ApexPages.currentPage().getParameters().put('blnContinue','true');     	
     	
     	RecordType objRecordType1 =  [Select SobjectType, Id From RecordType where SobjectType = 'Case' limit 1];
     	
     	Facility__c objFac1 = new Facility__c();
        objFac1.Name = 'TestFacility-1';
        objFac1.Desired_Capacity__c = 250;
        insert objFac1;
        	
     	Account objAcc1=new Account(name='TestAccount1');
     	insert objAcc1;
     	
     	Case objCase1 = new Case();
     	objCase1.AccountId = objAcc1.Id;
     	objCase1.RecordTypeId = objRecordType1.Id;
     	insert objCase1;
     	
     	
     	Top_Batch_Payment__c objTopBatchPayment1 = new Top_Batch_Payment__c();
    	objTopBatchPayment1.of_Check__c=3;
    	objTopBatchPayment1.Status__c='Open';
    	objTopBatchPayment1.Facility__c=objFac1.Id;
    	objTopBatchPayment1.Batch_Amount__c=2000;
    	objTopBatchPayment1.Name='test-1';    	
    	insert objTopBatchPayment1;
    	
    	ApexPages.currentPage().getParameters().put('topBatchPaymentId',objTopBatchPayment1.Id);
    	
     	Check_Info__c objCheckInfo1 = new Check_Info__c();
     	objCheckInfo1.Name='testcheckInfo-1';
     	objCheckInfo1.Amount__c = 1500;
     	objCheckInfo1.Parent_Batch_Payment__c=objTopBatchPayment1.id;
     	insert objCheckInfo1;
     	
         
     	Patient_Payment_Info__c objPatientPaymentInfo1 = new Patient_Payment_Info__c();
     	objPatientPaymentInfo1.Patient__c = objAcc1.id;
     	objPatientPaymentInfo1.Check_Info__c = objCheckInfo1.Id; 
     	objPatientPaymentInfo1.Amount__c = 180;
     	insert objPatientPaymentInfo1;
     	
     	Patient_Insurance__c objPatientInsurance1 = new Patient_Insurance__c();
     	objPatientInsurance1.Insurance_Code__c = 'INC-001';
     	objPatientInsurance1.Patient__c = objAcc1.Id;
     	insert objPatientInsurance1;
     	
     	ApexPages.StandardController sc1 = new ApexPages.standardController(objTopBatchPayment1);
     	TBN_CreateNewPayemBatchController objCreateNewPayemBatchController1 = new TBN_CreateNewPayemBatchController(sc1);
     	objCreateNewPayemBatchController1.blnBatchPaymentPage = true;
     	objCreateNewPayemBatchController1.blnCheckInfoPage = objCreateNewPayemBatchController.blnPatienInfo = false;
     	objCreateNewPayemBatchController1.redirectToCheckInfoPage();
     	objCreateNewPayemBatchController1.strFacility ='TestFacility-1';
     	objCreateNewPayemBatchController1.strPaymentName = 'PB-002'; 
     	objCreateNewPayemBatchController1.insuranceId = objPatientInsurance1.Id;
     	objCreateNewPayemBatchController1.CaseId = objCase1.Id;
     	
     	objCreateNewPayemBatchController1.redirectToCheckInfoPage();
     	objCreateNewPayemBatchController1.redirectToPostPaymentPage();
     	ApexPages.currentPage().getParameters().put('checkAmount','2500');
     	objCreateNewPayemBatchController1.strCheckName = 'CK-002';
     	objCreateNewPayemBatchController1.redirectTopPatientPaymentInfoPage();
     	objCreateNewPayemBatchController1.redirectToTopBatchPaymentSection();
     	//objCreateNewPayemBatchController1.redirectCheck();
     	objCreateNewPayemBatchController1.cancelToCheckInfoPage();
     	ApexPages.currentPage().getParameters().put('patientAmount','2000');  
     	objCreateNewPayemBatchController1.savePatientPaymentInfoPage();
     	objCreateNewPayemBatchController1.savePaymentInfoOldCheck();  
     	/* 3rd Testing */
     	
     	ApexPages.currentPage().getParameters().put('blnCancel','false');
     	ApexPages.currentPage().getParameters().put('blnSave','test');
     	ApexPages.currentPage().getParameters().put('amount','5000');
     	ApexPages.currentPage().getParameters().put('numberOfCheck','1');
     	ApexPages.currentPage().getParameters().put('blnContinue','false');     	
     	ApexPages.currentPage().getParameters().put('topBatchPaymentId',objTopBatchPayment1.Id);
     	ApexPages.StandardController sc2 = new ApexPages.standardController(objTopBatchPayment1);
     	TBN_CreateNewPayemBatchController objCreateNewPayemBatchController2 = new TBN_CreateNewPayemBatchController(sc2);
     	objCreateNewPayemBatchController2.blnBatchPaymentPage = true;
     	objCreateNewPayemBatchController2.blnCheckInfoPage = objCreateNewPayemBatchController.blnPatienInfo = false;
     	objCreateNewPayemBatchController2.redirectToCheckInfoPage();
     	objCreateNewPayemBatchController2.strFacility ='TestFacility-1';
     	objCreateNewPayemBatchController2.strPaymentName = 'PB-002'; 
     	objCreateNewPayemBatchController2.insuranceId = objPatientInsurance1.Id;
     	objCreateNewPayemBatchController2.CaseId = objCase1.Id;
     	
     	objCreateNewPayemBatchController2.redirectToCheckInfoPage();
     	objCreateNewPayemBatchController2.redirectToPostPaymentPage();
     	ApexPages.currentPage().getParameters().put('checkAmount','2500');
     	objCreateNewPayemBatchController2.strCheckName = 'CK-002';
     	objCreateNewPayemBatchController2.redirectTopPatientPaymentInfoPage();
     	objCreateNewPayemBatchController2.redirectToTopBatchPaymentSection();
     	//objCreateNewPayemBatchController1.redirectCheck();
     	objCreateNewPayemBatchController2.cancelToCheckInfoPage();
     	ApexPages.currentPage().getParameters().put('patientAmount','2000');  
     	objCreateNewPayemBatchController2.savePatientPaymentInfoPage();
     	objCreateNewPayemBatchController2.savePaymentInfoOldCheck();  	
     
     }
    /* This is the test class for TBN_EditPaymentBatch_Controller */
     static testMethod void TBN_EditPaymentBatch_Controller()
     {
     	Facility__c objFac1 = new Facility__c();
        objFac1.Name = 'TestFacility-1';
        objFac1.Desired_Capacity__c = 250;
        insert objFac1;
        	
     	Account objAcc1=new Account(name='TestAccount1');
     	insert objAcc1;     	
     	
     	Top_Batch_Payment__c objTopBatchPayment1 = new Top_Batch_Payment__c();
    	objTopBatchPayment1.of_Check__c=3;
    	objTopBatchPayment1.Status__c='Open';
    	objTopBatchPayment1.Facility__c=objFac1.Id;
    	objTopBatchPayment1.Batch_Amount__c=2000;
    	objTopBatchPayment1.Name='test-1';    	
    	insert objTopBatchPayment1;    
    	
    	ApexPages.currentPage().getParameters().put('id', objTopBatchPayment1.Id);	
    	
     	Check_Info__c objCheckInfo1 = new Check_Info__c();
     	objCheckInfo1.Name='testcheckInfo-1';
     	objCheckInfo1.Amount__c = 1500;
     	objCheckInfo1.Parent_Batch_Payment__c=objTopBatchPayment1.id;
     	insert objCheckInfo1;
     	
         
     	Patient_Payment_Info__c objPatientPaymentInfo1 = new Patient_Payment_Info__c();
     	objPatientPaymentInfo1.Patient__c = objAcc1.id;
     	objPatientPaymentInfo1.Check_Info__c = objCheckInfo1.Id; 
     	objPatientPaymentInfo1.Amount__c = 180;
     	insert objPatientPaymentInfo1;
     	
     	TBN_EditPaymentBatch_Controller objEditPaymentBatch = new TBN_EditPaymentBatch_Controller();
     	objEditPaymentBatch.doContinue();
     	objEditPaymentBatch.saveAndClose();
     }
     
      /* This is the test class for TBN_PrintUB04FormForBatch */
     static testMethod void TBN_PrintUB04FormForBatch()
     {
     	Batch__c objBatch = new Batch__c();
     	objBatch.of_Claim__c = 2;
     	objBatch.of_Patient__c = 2;
     	objBatch.Submit_Timestamp__c = Date.today().addDays(-2);
     	objBatch.Submit_Type__c = 'Electronic';
     	objBatch.Total_Amount__c = 1000;
     	insert objBatch;
     	
     	Claim__c objClaim=new Claim__c();
		objClaim.Status__c='submitted';
		objClaim.Facility__c='TestFacility';
		objClaim.Patient__c='testAccount';
		objClaim.ParentClaim__c = objBatch.Id;
		insert objClaim;
		
		Facility__c objFac = new Facility__c();
		objFac.Name = objClaim.Facility__c;
		objFac.Desired_Capacity__c = 250;
		insert objFac;
		
		Account objAcc = new Account();
		objAcc.Name = objClaim.Patient__c;
		insert objAcc;
		
		Case objCase = new Case();
		objCase.AccountId = objAcc.Id;
		insert objCase;
		
		Utilization_Review__c objUR = new Utilization_Review__c();
		objUR.TreatmentFacility__c = objFac.Id;
		objUR.Completed_By__c = 'Test User';
		objUR.Completed_Date__c = Datetime.now();  
		//objUR.Account__c = objAcc.Id;
		objUR.Case__c = objCase.Id;
		insert objUR;
		
		Dates_of_Service__c objDOS = new Dates_of_Service__c();
		objDOS.Level_of_Care__c = 'IR';
		objDOS.Status__c = 'submitted';
		objDOS.Start_Date__c = Date.today().addDays(-2);
		objDOS.End_Date__c = Date.today().addDays(-1);
		objDOS.Day_of_Week__c = '5';
		objDOS.Total_Days_Authorized__c = 4;
		objDOS.Authorization_Number__c = '123';
		objDOS.CM__c = 'Test CM';
		objDOS.Date_of_Review__c = Date.Today();
		objDOS.Level_of_Care_Description__c = 'Test';
		objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
		objDOS.Amount__c = 250;
		objDOS.Claim__c=objClaim.Id;
		objDOS.Utilization_Review_Form__c = objUR.Id;
		//objDOS.Account__c = objAcc.Id;
		insert objDOS;
		
		Apexpages.currentPage().getParameters().put('batchId',objBatch.Id);	
		TBN_PrintUB04FormForBatch objPrintUB04FormForBatch =  new TBN_PrintUB04FormForBatch();
				
     }
     
      /* This is the test class for TBN_DOSAmountRollupForCase.trigger */
       static testMethod void TBN_DOSAmountRollupForCase()
     {
     	RecordType objRecordType =  [Select SobjectType, Id From RecordType where SobjectType = 'Case' limit 1];
     	
     	Account objAcc1=new Account(name='TestAccount1');
     	insert objAcc1;
     	
     	Case objCase1 = new Case();
     	objCase1.AccountId = objAcc1.Id;
     	objCase1.RecordTypeId = objRecordType.Id;
     	insert objCase1;
     	
     	Facility__c objFac1 = new Facility__c();
        objFac1.Name = 'TestFacility-1';
        objFac1.Desired_Capacity__c = 250;
        insert objFac1;
        
     	Utilization_Review__c objUR = new Utilization_Review__c();
        objUR.TreatmentFacility__c = objFac1.Id;
        objUR.Completed_By__c = 'Test User';
        objUR.Completed_Date__c = Datetime.now();  
        objUR.Case__c = objCase1.Id;
       // objUR.Account__c = objAcc1.Id;
        insert objUR;
        
     	Dates_of_Service__c objDOS = new Dates_of_Service__c();
        objDOS.Level_of_Care__c = 'IR';
        objDOS.Status__c = '';
        objDOS.Utilization_Review_Form__c = objUR.Id;
        objDOS.Start_Date__c = Date.today().addDays(-1);
        objDOS.End_Date__c = Date.today().addDays(2);
        objDOS.Day_of_Week__c = '5';
        objDOS.Total_Days_Authorized__c = 4;
        objDOS.Billable_Day__c = true;
        objDOS.Authorization_Number__c = '123';
        objDOS.CM__c = 'Test CM';
        objDOS.Date_of_Review__c = Date.Today();
        objDOS.Level_of_Care_Description__c = 'Test';
        objDOS.Review_Assigned_To_Lookup__c = Userinfo.getUserId();
        //objDOS.Amount_Paid__c = 1000;
        objDOS.Amount__c = 1500;
        //objDOS.Account__c = objAcc1.Id;
        objDOS.Bill_Status__c = 'Submitted';
        //objDOS.Patient_Responsibility_Amount__c = 100;
        //objDOS.Insurance_Adjusted_Amount__c = 500;
        //objDOS.Allowed_Amount__c = 200;
        objDOS.Adjustment_Type__c = 'Secondary Insurance';
        //objDOS.PatientPaymentInfo__c = objPatientPaymentInfo.Id;
        insert objDOS;
        
        delete objDOS;
     }
     
}