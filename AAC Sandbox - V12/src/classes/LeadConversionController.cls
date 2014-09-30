public class LeadConversionController 
{
	public Id PersonAccTypeId {get;set;}
	public Id WebFormChatParentId {get;set;}
	public Id ParentAccountId {get;set;}
	public Id GeneralCatchallId {get;set;}
	public Lead MasterLead {get; set;}
	public Id WebLeadsRecordTypeId {get;set;}
	public string FirstName {get;set;}
	public string LastName {get;set;}
	public string NewAccountId {get;set;}
	
	public LeadConversionController(ApexPages.StandardController controller)
	{
		MasterLead = (Lead)controller.getRecord();
		RefreshMasterLead();
		WebLeadsRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Web Leads' LIMIT 1].Id;
		FirstName = MasterLead.FirstName;
		LastName = MasterLead.LastName;
	}
	public void RefreshMasterLead()
	{
		MasterLead = [SELECT Id, FirstName, LastName, Company, Phone, Source__c, State, LeadSource, Description, Website, Email, Parent_Account__c, RecordTypeId, How_Did_Caller_Get_Our_Number__c, How_Did_You_Hear_About_AAC__c, How_Did_You_Hear_About_AAC_Description__c FROM Lead WHERE Id = :MasterLead.Id];
	}
	public PageReference ViewLead()
	{
		PageReference ref = new PageReference('/' + MasterLead.Id);
		ref.setRedirect(true);
		return ref;
	}
	public void CreateValidationAlert(string msg)
	{
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, msg));
	}
	public boolean IsValidated()
	{
		boolean valid = true;
		Id InboundCallLeads = [SELECT Id FROM RecordType WHERE Name ='Inbound Calls' AND SobjectType = 'Lead' LIMIT 1].Id;
		if(MasterLead.RecordTypeId == InboundCallLeads)
		{
			if(MasterLead.FirstName == '' || MasterLead.FirstName == null)
			{
				CreateValidationAlert('First Name is required before converting.');
				valid = false;
			}
			if(MasterLead.Phone == '' || MasterLead.Phone == null)
			{
				CreateValidationAlert('Phone is required before converting.');
				valid = false;
			}
			if(MasterLead.State == '' || MasterLead.State == null)
			{
				CreateValidationAlert('Address is required before converting');
				valid = false;
			}
		}
		
		return valid;
	}
	public PageReference ConvertLead()
	{
		if(!IsValidated())
		{
			return null;
		}
		else
		{
			MasterLead.Company = '';
			update MasterLead;
			RefreshMasterLead();
			if(Test.isRunningTest())
			{
				PersonAccTypeId = [select id, name from recordtype WHERE IsPersonType = true LIMIT 1].Id;
				WebFormChatParentId = [select id, name from account WHERE Name = 'Web Form or Chat' LIMIT 1].Id;
				GeneralCatchallId = [select id, name from account WHERE IsPersonAccount = false AND Name = 'GENERAL CATCHALL' LIMIT 1].Id;
			}
			else
			{
				PersonAccTypeId = [select id, name from recordtype where IsPersonType = true AND name = 'Person Account' LIMIT 1].Id;
				WebFormChatParentId = [select id, name from account where Name = 'Web Form or Chat' LIMIT 1].Id;
				GeneralCatchallId = [select id, name from account WHERE IsPersonAccount = false AND Name = 'GENERAL CATCHALL' LIMIT 1].Id;
				ParentAccountId = MasterLead.Parent_Account__c;
			}
			Account pa = new Account();
			pa.FirstName = FirstName == null || FirstName == '' ? 'FIX ME' : FirstName;
			pa.LastName = LastName == null || LastName == '' ? 'FIX ME' : LastName;
			pa.Email__c = MasterLead.Email;
			pa.RecordTypeId = PersonAccTypeId;

			string phone = MasterLead.Phone;
			if(phone != null && phone != '')
			{
				phone = phone.replaceAll('[^\\d]','');
			}
			phone = phone == null || phone == '' ? '0000000000' : phone;
			pa.Phone = phone;
			pa.CID__c = phone;
			pa.BillingState = MasterLead.State == null || MasterLead.State == '' ? 'TN' : MasterLead.State.Left(2);
			insert pa;
			
			pa = [select Id FROM Account WHERE Id = :pa.Id];
			
			Id userId = UserInfo.getUserId();
			Database.LeadConvert lc = new Database.LeadConvert();
			lc.setLeadId(MasterLead.Id);
			lc.setDoNotCreateOpportunity(true);
			lc.setSendNotificationEmail(true);
			lc.setOwnerId(userId);
			lc.setAccountId(pa.Id);
					
			LeadStatus convertStatus = [Select Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
			lc.setConvertedStatus(convertStatus.MasterLabel);
			
			Database.LeadConvertResult convertResult = Database.convertLead(lc);
			if(convertResult.isSuccess())
			{
				Id accId = pa.Id;
			
				Account a = [SELECT FirstName, LastName, PersonContactId, PersonEmail, Email__c, Phone, CID__c, Scratch_Pad__c, Parent_Account__c, RecordTypeId, How_Did_Caller_Get_Our_Number__c, How_Did_You_Hear_About_AAC__c, How_Did_You_Hear_About_AAC_Description__c FROM Account WHERE Id = :accId];
				a.FirstName = FirstName;
				a.LastName = LastName;
				a.RecordTypeId = PersonAccTypeId;
				a.Phone = phone;
				a.CID__c = phone;
				a.Scratch_Pad__c = MasterLead.Description;
				if(MasterLead.Parent_Account__c == null)
				{
					if(MasterLead.RecordTypeId == WebLeadsRecordTypeId)
						a.Parent_Account__c = WebFormChatParentId;
					else
						a.Parent_Account__c = GeneralCatchallId;
				}
				else
					a.Parent_Account__c = MasterLead.Parent_Account__c;
					 
				a.How_Did_Caller_Get_Our_Number__c = MasterLead.How_Did_Caller_Get_Our_Number__c;
				a.How_Did_You_Hear_About_AAC__c = MasterLead.How_Did_You_Hear_About_AAC__c;
				a.How_Did_You_Hear_About_AAC_Description__c = MasterLead.How_Did_You_Hear_About_AAC_Description__c;
				a.PersonEmail = MasterLead.Email;
				a.Email__c = MasterLead.Email;
				a.OwnerId = userId;
				
				update a;
								
				Case c = new Case();
				c.AccountId = a.Id;
				c.Origin = 'Phone';
				c.ContactId = a.PersonContactId;
				insert c;
				
				Task t = new Task();
				t.ActivityDate = datetime.now().date();
				t.IsReminderSet = true;
				t.Description = 'Automatically Generated Lead Conversion Follup-up Task';
				t.OwnerId = userId;
				t.Priority = 'High';
				t.ReminderDateTime = DateTime.now();
				t.Status = 'New';
				t.Subject = 'Contact New Web Lead: ' + a.FirstName + ' ' + a.LastName;
				t.WhatId = a.Id;
				
				insert t;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Created account ' + a.FirstName + ' ' + a.LastName + '.'));
				NewAccountId = string.valueOf(a.Id);
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Conversion was successful.'));
				PageReference ref = new PageReference('/' + c.Id);
				ref.setRedirect(true);
				
				return ref;
			}
			else
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Conversion failed.'));
				return null;
			}
		}
	}
}