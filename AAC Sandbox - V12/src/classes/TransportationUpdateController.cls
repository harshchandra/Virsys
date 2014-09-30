public class TransportationUpdateController {

public TransportationUpdateController()
{
	
}
public PageReference DeleteDuplicates()
{
	List<Transportation__c> trans = new List<Transportation__c>();
	for(Transportation__c t : [SELECT Id FROM Transportation__c WHERE Case__r.CaseNumber = '00025620' AND Name != 'TR00003737'])
	{
		trans.add(t);								
	}
	
	delete trans;
	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Deleted ' + trans.size()));
	return null;
}
public PageReference TransportationUpdate()
{
	List<Transportation__c> trans = [SELECT Id, 
									Date_Time_of_Client_s_Arrival__c, Detox_Location__c, Treatment_Facility__c,Transportation_Status__c,
									Date_Time_of_Clients_Arrival__c,
									DetoxFacility__c,
									TreatmentFacility__c,
									TransportationStatus__c
									FROM Transportation__c];

	
	Map<String, Id> transMap = new Map<String, Id>();

	List<Facility__c> facilities = [SELECT Id,Name FROM Facility__c];
	
	for(Facility__c f : facilities)
	{
		transMap.put(f.Name, f.Id);
	}


	List<Transportation__c> finalTrans = new List<Transportation__c>();
	
	for(Transportation__c t : trans)
	{
		if(t.Transportation_Status__c != null)
		{
			t.TransportationStatus__c = t.Transportation_Status__c;
		}
		if(t.Date_Time_of_Client_s_Arrival__c != null && t.Date_Time_of_Client_s_Arrival__c != 'Z')
		{
			string dt = t.Date_Time_of_Client_s_Arrival__c;
			//dt = dt.Replace(' ','T');
			t.Date_Time_of_Clients_Arrival__c = DateTime.valueOf(dt);
		}
		
		if(t.Detox_Location__c != null)
			t.DetoxFacility__c = transMap.get(t.Detox_Location__c);
		
		if(t.Treatment_Facility__c != null)
		{
			string fac = null;
			if(t.Treatment_Facility__c == 'Anaheim (contracted)')
				fac = 'Anaheim';
			else
				fac = t.Treatment_Facility__c;
				
			t.TreatmentFacility__c = transMap.get(fac);
		}
			
		
		finalTrans.add(t);
	}

	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Uploading ' + finalTrans.size()));
	update finalTrans;
	
	return null;
}

private static testMethod void TestUpdate()
{
	
	Account a = new Account(Name = 'Test Account');
	insert a;
	Case c = new Case(AccountId = a.Id);
	insert c;
	Transportation__c t = new Transportation__c(Case__c = c.Id);
	insert t;
	
	
	TransportationUpdateController con = new TransportationUpdateController();
	Test.startTest();
	con.TransportationUpdate();
	con.DeleteDuplicates();
	Test.stopTest();	
}
}