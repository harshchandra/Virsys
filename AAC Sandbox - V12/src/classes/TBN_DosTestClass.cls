@isTest
private class TBN_DosTestClass {

    static testMethod void myUnitTest() {
    	
    	ApexPages.currentPage().getParameters().put('facility', 'TestFacility');
        ApexPages.currentPage().getParameters().put('LevelOfCare', 'EAP');
        ApexPages.currentPage().getParameters().put('Status', 'ReSubmit');
        ApexPages.currentPage().getParameters().put('Format', 'Send Electronically');
        
        Facility__c objFac = new Facility__c();
        objFac.Name = 'TestFacility';
        objFac.Desired_Capacity__c = 250;
        insert objFac;
        
        Case objCase = new Case();
        insert objCase;
        
        Utilization_Review__c objUR = new Utilization_Review__c();
        objUR.TreatmentFacility__c = objFac.Id;
        objUR.Completed_By__c = 'Test User';
        objUR.Completed_Date__c = Datetime.now();  
        objUR.Case__c = objCase.Id;
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
        System.assertEquals(objDos11.Bill_Status__c, 'Selected');
        System.assertEquals(objDos11.Amount__c, objBA.Amount__c);
        
        
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
    
  
}