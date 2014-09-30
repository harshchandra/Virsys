@isTest
private class DatesOfServiceBilledControllerTest 
{
    public static testMethod void BilledControllerTest() 
    {
    	Account a = new Account();
	    a.Phone = '1231231234';
	    a.FirstName = 'Test';
	    a.LastName = 'Test';
	    a.PersonEmail = 'test@test.com';
	    insert a;
	    Support_Group_Member__c spm = new Support_Group_Member__c();
	    spm.Name = 'Test Test';
	    spm.Home_Phone__c = '1231231234';
	    spm.Relationship_To_Client__c = 'Brother';
	    spm.Authorized_on_Release_Form__c = false;
	    spm.Person_Account__c = a.Id;
	    insert spm;
    	Case c = new Case();
    	c.AccountId = a.Id;
    	insert c;
    	
    	Utilization_Review__c ur = new Utilization_Review__c();
    	ur.Case__c = c.Id;
    	insert ur;
    	
    	Dates_of_Service__c dos = new Dates_of_Service__c();
    	dos.Start_Date__c = Date.today();
    	dos.End_Date__c = Date.today();
    	dos.Level_of_Care__c = 'DTX';
    	dos.Status__c = 'Approved';
    	dos.Days_Per_Week__c = '7';
    	dos.Utilization_Review_Form__c = ur.Id;
    	dos.Total_Days_Authorized__c = 7;
    	dos.Billable_Day__c = true;
    	insert dos;
      
      Test.startTest();
      ApexPages.StandardController controller = new ApexPages.StandardController(ur);
      DatesOfServiceBilledController ext = new DatesOfServiceBilledController(controller);
      ext.StartDate = Date.today();
      ext.EndDate = Date.today().addDays(3);
      ext.Save();
      ext = new DatesOfServiceBilledController(controller);
      ext.StartDate = Date.today().addDays(-1);
      ext.EndDate = Date.today().addDays(3);
      
      ext.RedirectToParent();
      
      Test.stopTest();
      
      
    }
}