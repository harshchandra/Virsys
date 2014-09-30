trigger CreateAlumniLeadFromDischarge on Case (after update) {
	List<Lead> alumniLeads = new List<Lead>();
	
	for(Case c : Trigger.new)
	{
			Case oldCase = Trigger.oldMap.get(c.Id);
			if(oldCase.Status != c.Status && c.Status == 'Discharged')
			{
				List<Lead> leadCheck = [SELECT Id FROM Lead Where RecordTypeId = '012G00000017DCtIAM' AND Alumni_Record__r.Id = :c.Id];
				if(leadCheck.size() == 0)
				{
					Account a = [SELECT Id,FirstName,LastName, Phone,PersonEmail,PersonDoNotCall,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry FROM Account WHERE Id = :c.AccountId];
					Lead l = new Lead();
					l.Alumni_Record__c = c.Id;
					l.FirstName = a.FirstName;
					l.LastName = a.LastName;
					l.LeadSource = 'Alumni';
					l.OwnerId = '00GG0000002trgAMAQ';
					l.Prior_Treatment_Facility__c = c.Treatment_Facility_Lookup__c;
					l.Prior_Admit_Date__c = c.Facility_Admission_date__c;
					l.Prior_Discharge_Date__c = c.Facility_Date_of_Discharge__c;
					l.RecordTypeId = '012G00000017DCtIAM';
					l.Phone = a.Phone;
					l.Email = a.PersonEmail;
					l.DoNotCall = a.PersonDoNotCall;
					l.Street = a.BillingStreet;
					l.City = a.BillingCity;
					l.State = a.BillingState;
					l.PostalCode = a.BillingPostalCode;
					l.Country = a.BillingCountry;
					alumniLeads.add(l); 
				}
			}
	}
	insert alumniLeads;
}