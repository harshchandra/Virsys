public class CaseFormUpdateController {
	
	public CaseFormUpdateController()
	{
		
	}
	
	public PageReference CaseUpdate()
	{
		List<Case> cases = [SELECT Id, CaseNumber,
							Treatment_Facility__c, Treatment_Facility_Lookup__c,
							Detox_Location__c, RecordTypeId, Detox_Facility_Lookup__c  FROM Case];
		
		Map<String, Id> facilityMap = new Map<String, Id>();
		
		List<Facility__c> facilities = [SELECT Id, Name FROM Facility__c];
		for(Facility__c f : facilities)
		{
			facilityMap.put(f.Name, f.Id);
		}
		
		List<Case> finalCases = new List<Case>();
		for(Case c : cases)
		{
			
			if(c.Detox_Location__c != null)
			{
				string fac = null;
				if(c.Detox_Location__c == 'Anaheim (contracted)')
					fac = 'Anaheim';
				else
					fac = c.Detox_Location__c;
					
				c.Detox_Facility_Lookup__c = facilityMap.get(fac);
			}
			
			
			if(c.Treatment_Facility__c != null)
			{
				string fac = null;
				if(c.Treatment_Facility__c == 'Anaheim (contracted)')
					fac = 'Anaheim';
				else
					fac = c.Treatment_Facility__c;
					
				c.Treatment_Facility_Lookup__c = facilityMap.get(fac);
			}
			
			
			finalCases.add(c);
		}
		
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Uploading ' + finalCases.size()));
		update finalCases;
		return null;
	}
	public PageReference RecordTypeUpdate()
	{
		List<Case> cases = [SELECT RecordTypeId FROM Case WHERE RecordTypeId IN('012G00000017959IAA','012G000000179Z7IAI','012G00000017954IAA')];
		List<Case> finalCases = new List<Case>();
		for(Case c : cases)
		{
			c.RecordTypeId = '012G00000017ABRIA2';
			finalCases.add(c);
		}
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Uploading ' + finalCases.size()));
		update finalCases;
		return null;
	}
	public PageReference InsuranceBenefitTypeUpdate()
	{
		List<InsuranceVerificationForm__c> forms = [SELECT Id, Case__c, Case__r.Id, Benefit_Type__c FROM InsuranceVerificationForm__c WHERE IsSecondaryInsurance__c = false AND Case__c != null AND benefit_type__c != null];
		//List<Case> cases = [SELECT Id,CaseNumber,Benefit_Type__c FROM Case];
		
		Map<Id, Case> cases = new Map<Id, Case>([SELECT Id,CaseNumber,Benefit_Type__c FROM Case]);
		Map<Case, InsuranceVerificationForm__c> insMap = new Map<Case, InsuranceVerificationForm__c>();
				
		List<Case> finalCases = new List<Case>();
		
		for(InsuranceVerificationForm__c i : forms)
		{
			if(cases.get(i.Case__r.Id) != null)
				insMap.put(cases.get(i.Case__r.Id), i);

		}
		
		for(Case c : insMap.keySet())
		{
			c.Benefit_Type__c = insMap.get(c).Benefit_Type__c;
			finalCases.add(c);
		}
		
		
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Uploading ' + finalCases.size()));
		update finalCases;
		return null;
	}
	public static testMethod void testCaseFormUpdate()
	{
		
		Account TestAccount = new Account(Name ='TestAccount',Phone='1231231234'); 
		Account PersonAccount = new Account(FirstName='John',LastName='Doe');
		insert TestAccount;
		insert PersonAccount;
		Facility__c f = new Facility__c();
		f.Name = 'Greenhouse';
		insert f;
		
		Case TestCase = new Case(Status='Case Opened',Benefit_Type__c = 'Out of Network', RecordTypeId ='012G00000017959IAA', Origin='Phone',AccountId=PersonAccount.Id,Treatment_Facility__c = 'Greenhouse',treatment_facility_lookup__c = f.Id, detox_location__c = 'Greenhouse', detox_facility_lookup__c = f.Id);
		insert TestCase;
		
		InsuranceVerificationForm__c insurance = new InsuranceVerificationForm__c();
		insurance.case__c = TestCase.Id;
		insurance.IsSecondaryInsurance__c = false;
		insurance.Benefit_type__c = 'Out of Network';
		insert insurance;
	
		Contact TestContact = new Contact(
      	LastName = 'Doe', 
      	AccountId = TestAccount.Id,
      	Phone='1231231234'
   		);
    	insert TestContact;
    
    	Assessment__c TestAssessment = new Assessment__c(Case__c = TestCase.Id);
    	insert TestAssessment;
		
		
		Test.StartTest();
		CaseFormUpdateController controller = new CaseFormUpdateController();
		controller.CaseUpdate();
		controller.RecordTypeUpdate();
		controller.InsuranceBenefitTypeUpdate();
		Test.StopTest();
	}

}