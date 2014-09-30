public class TrackingReportController {

public transient Map<String, List<TrackingReportViewItem>> caseStatusMap {get;set;}
public transient Map<Integer, String> caseStatusIdMap {get;set;}
//should end up caseStatusMap[caseStatusIdMap[0]].TrackingField
public string UserState {
	get
	{
		User u = [SELECT Id,Alias,Name,ProfileId,State from User WHERE Id = :UserInfo.getUserId()];
		if(u.Alias == 'bstet' || u.Alias == 'abarn')
			return 'ALL';
		else
			return u.State;	
	}
	set;
}


public TrackingReportController()
{
	List<string> caseStatusTypes = new List<string>();
	Schema.DescribeFieldResult fr = Case.Status.getDescribe();
	List<Schema.PicklistEntry> p = fr.getPicklistValues();
	
	for(Schema.PicklistEntry f : p)
	{
		if(f.getValue() != 'Admitted' && f.getValue() != 'Discharged' && f.getValue() != 'DWB' && f.getValue() != 'Closed' && f.getValue() != 'Leave of Absence' && f.getValue() != 'DWOB' && f.getValue() != 'DWLB')
			caseStatusTypes.add(f.getValue());
	}
	
	for(integer i = 0; i < caseStatusTypes.size(); i++)
	{
		string q = 'SELECT Id,CaseNumber,Benefit_Type__c,CreatedDate,AccountId,Account.Name,OwnerId,Owner.Name,Treatment_Facility_Lookup__c,Treatment_Facility_Lookup__r.Id,Treatment_Facility_Lookup__r.Name,Detox_Facility_Lookup__c,Detox_Facility_Lookup__r.Id,Detox_Facility_Lookup__r.Name,Facility_Admission_Date__c,Facility_Date_of_Discharge__c,Account.Parent_Account_Type__c,Account.Parent_Account__r.Id,Account.Parent_Account__r.Name,Status,Split_Commission_With__r.Name,Pay_Commission_to__r.Name, ';
		q += '(SELECT Id,Name,InsuranceCompany__c,Insurance_Status__c, TypeOfPlan__c FROM Insurance_Verification_Forms__r WHERE IsSecondaryInsurance__c = false ORDER BY CreatedDate DESC LIMIT 1),';
		q += '(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1),';
		q += '(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),';
		q += '(SELECT Id,Name,Transportation_Status__c,Paperworkhasbeensent__c,Date_Time_of_Clients_Arrival__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)';
		q += ' FROM Case '; 
		q += ' WHERE Status = \'' + caseStatusTypes[i] + '\'';
		q += ' AND IsDeleted = False';
		if(UserState != 'ALL')
		{
			q += ' AND CreatedBy.State =\'' + UserState + '\'';
		}
		q += ' ORDER BY CaseNumber DESC';
		q += ' LIMIT 1000';

		//get the list of cases for this status
		List<Case> cases = (List<Case>)database.query(q);
		
		
		TrackingReportViewItem[] items = getTrackingReportItems(cases);

		//add the Status as the key, the TRViewItems as the value
		if(caseStatusMap == null)
			caseStatusMap = new Map<String, List<TrackingReportViewItem>>();
		if(caseStatusIdMap == null)
			caseStatusIdMap = new Map<Integer, String>();
			
		caseStatusMap.put(caseStatusTypes[i], items);
		caseStatusIdMap.put(i,caseStatusTypes[i]);
		
		cases = null;
		items = null;
	}
	
	caseStatusTypes = null;
	fr = null;
	p = null;
}

public TrackingReportViewItem[] getTrackingReportItems(List<Case> cases)
{
	TrackingReportViewItem[] items = new TrackingReportViewItem[]{};
		//iterate cases, assigning proper value into TRViewItems
		for(Case c : cases)
		{
			TrackingReportViewItem x = new TrackingReportViewItem();
			x.CaseId = c.Id;
			x.CaseNumber = c.CaseNumber;
			x.CaseStatus = c.Status;
			x.BenefitType = c.Benefit_Type__c;
			x.ContactId = c.Account.Id;
			x.ContactName = c.Account.Name;
			x.CreatedDate = c.CreatedDate;
			x.DetoxFacility = c.Detox_Facility_Lookup__r.Name;
			x.TreatmentFacility = c.Treatment_Facility_Lookup__r.Name;
			x.FacilityAdmissionDate = c.Facility_Admission_Date__c;
			x.FacilityDischargeDate = c.Facility_Date_of_discharge__c;
			x.OwnerName = c.Owner.Name;
			
			x.ParentAccountId = c.Account.Parent_Account__r.Id;
			x.ParentAccountName = c.Account.Parent_Account__r.Name;
			x.ParentAccountType = c.Account.Parent_Account_Type__c;
			x.PayCommissionTo = c.Pay_Commission_to__r.Name;
			x.SplitCommissionWith = c.Split_Commission_With__r.Name;
			
			for(InsuranceVerificationForm__c ins : c.Insurance_Verification_Forms__r)
			{
				x.InsuranceId = ins.Id;
				x.InsuranceStatus = ins.Insurance_Status__c;
				x.FirstPolicyCompany = ins.InsuranceCompany__c;
				x.FirstPolicyInsuranceType = ins.TypeOfPlan__c;
				
			}
			for(Transportation__c t : c.Transportation__r)
			{
				x.TransportationId = t.Id;
				x.TransportationStatus = t.Transportation_Status__c;
				x.DateTimeClientArrives = t.Date_Time_of_Clients_Arrival__c;
				x.PaperworkSent = t.Paperworkhasbeensent__c;
			}
			
			items.add(x);	
		}
	return items;
}

private static testMethod void TestTrackingReportController()
{
    Account a = new Account(firstname = 'john', lastname ='doh');
    insert a;
    
    Case c = new Case(AccountId = a.Id, Insurance_Status__c = 'Submitted',Status = '3- Pending Assessment Review & Approval',X1st_Policy_Insurance_Type__c = 'PPO');
    insert c;
    
    InsuranceVerificationForm__c i = new InsuranceVerificationForm__c(Case__c = c.Id, ClientName__c = 'John Doe');
    insert i;
    
    Assessment__c s = new Assessment__c(Case__c = c.Id);
    insert s;
    
    Transportation__c t = new Transportation__c(Case__c = c.Id);
    insert t;
    
    Payment_Arrangement__c p = new Payment_Arrangement__c(Case__c = c.Id);
    insert p;
    
    Test.startTest();
    TrackingReportController con = new TrackingReportController();
    System.assert(con.caseStatusMap != null);
    Test.stopTest();
}

}