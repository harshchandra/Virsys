public with sharing class URFormUpdateController {

public URFormUpdateController()
{
	
}

public PageReference URFormUpdate()
{
	List<Utilization_Review__c>	forms = [SELECT Id, Treatment_Facility__c, TreatmentFacility__c FROM Utilization_Review__c];
	
	Map<String, Id> transMap = new Map<String, Id>();
	
	List<Facility__c> facilities = [SELECT Id,Name FROM Facility__c];
	for(Facility__c f : facilities)
	{
		transMap.put(f.Name, f.Id);
	}
	
	List<Utilization_Review__c> finalForms = new List<Utilization_Review__c>();
	
	for(Utilization_Review__c ur : forms)
	{
		if(ur.Treatment_Facility__c != null)
		{
			string fac = null;
			if(ur.Treatment_Facility__c == 'Anaheim (contracted)')
				fac = 'Anaheim';
			else
				fac = ur.Treatment_Facility__c;
				
			ur.TreatmentFacility__c = transMap.get(fac);
		}
		
		finalForms.add(ur);
	}
	
	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Uploading ' + finalForms.size()));
	update finalForms;
	
	return null;
}

private static testMethod void TestUpdate()
{
	Facility__c f = new Facility__c(Name = 'Greenhouse');
	insert f;	
	Account a = new Account(Name = 'Test Account');
	insert a;
	Case c = new Case(AccountId = a.Id, Treatment_Facility__c = 'Greenhouse', Treatment_Facility_Lookup__c = f.Id);
	insert c;


	Utilization_Review__c ur = new Utilization_Review__c(Case__c = c.Id,
	TreatmentFacility__c = f.Id,
	Completed_By__c = 'Test',
	Completed_Date__c = Date.today(),
	Diagnosis__c = '303.1',
	Pre_Cert_Company__c =  'Test Co',
	Pre_Cert_Company_Phone__c = '555-555-5555',	
	Reviewer_Name__c = 'Test Test',
	Reviewer_Phone__c = '555-555-1234'
	);

	upsert ur;
	
	URFormUpdateController con = new URFormUpdateController();
	Test.startTest();
	con.URFormUpdate();
	Test.stopTest();	
}
}