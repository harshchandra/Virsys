public class MasterViewController {


public List<Account> accounts {get;set;}
public List<Case> cases{get;set;}
public List<InsuranceVerificationForm__c> forms{get;set;}
public List<Assessment__c> assessments{get;set;}
public List<Payment_Arrangement__c> paymentArrangements{get;set;}

public integer TotalCount{get{ return cases.size(); } private set;}
public integer TotalInsurance{get{ return forms.size(); } private set;}
public integer TotalAssessments{get{return assessments.size();} private set;}
public integer TotalPaymentArrangements{get{return paymentArrangements.size();} private set;}

private string lastScript {get;set;}

public string SelectedTab
{
	get; set;
}
public string UserState {
	get
	{
		User u = [SELECT Id,Alias,Name,ProfileId,State from User WHERE Id = :UserInfo.getUserId()];
		if(u.Alias == 'bstet' || u.Alias == 'abarn')
			return 'ALL';
		else
			return u.State;	
	}
}
public String sortExpression 
{
	get
	{
		if(sortExpression == null || sortExpression == '')
			return 'CaseNumber';
		else 
			return sortExpression;
	}
	set
	{
		sortExpression = value;	
	}
}
public String sortDirection 
{
	get
	{
		if(sortDirection == null || sortDirection == '')
			return 'DESC';
		else
			return sortDirection;
	}
	set
	{
		sortDirection = value; 
	}
}


public PageReference SortData() 
{
	
	if(sortDirection == 'ASC')
		sortDirection = 'DESC';
	else
		sortDirection = 'ASC';
	
	if(sortExpression == 'CaseNumber')
	{
			string q = 'SELECT AccountId,Account.Name,Account.Parent_Account_Type__c,Id,CaseNumber,CreatedDate,OwnerId,Owner.Name,Status,Primary_Insurance_Form__c,Insurance_Status__c,X1st_Policy_Insurance_Type__c, ';
			q += '(SELECT Id,Name FROM Insurance_Verification_Forms__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),';
 			q += '(SELECT Id,Name,TransportationStatus__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)';
 			q += ' FROM Case WHERE Status IN(';
 			q += '\'3- Pending Assessment Review & Approval\',';
 			q += '\'5- Pending Confirmation of Admission\') AND IsDeleted = FALSE ';
			if(UserState != 'ALL')
 				q += ' AND CreatedBy.State = \'' + UserState + '\'';
 			q += ' ORDER BY CaseNumber ';
 			q +=  sortDirection;
 			
 			
 			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
			cases = (List<Case>)database.query(q);
	}
	else if(sortExpression == 'CaseStatus')
	{
			string q = 'SELECT AccountId,Account.Name,Account.Parent_Account_Type__c,Id,CaseNumber,CreatedDate,OwnerId,Owner.Name,Status,Primary_Insurance_Form__c,Insurance_Status__c,X1st_Policy_Insurance_Type__c, ';
			q += '(SELECT Id,Name FROM Insurance_Verification_Forms__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),';
 			q += '(SELECT Id,Name,TransportationStatus__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)';
 			q += ' FROM Case WHERE Status IN(';
 			q += '\'3- Pending Assessment Review & Approval\',';
 			q += '\'5- Pending Confirmation of Admission\') AND IsDeleted = FALSE ';
 			if(UserState != 'ALL')
 				q += ' AND CreatedBy.State = \'' + UserState + '\'';
 			q += ' ORDER BY Status ';
 			q +=  sortDirection;
 			
 			
 			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
			cases = (List<Case>)database.query(q);
	}
	else if(sortExpression == 'CreatedDate')
	{
		string q = 'SELECT AccountId,Account.Name,Account.Parent_Account_Type__c,Id,CaseNumber,CreatedDate,OwnerId,Owner.Name,Status,Primary_Insurance_Form__c,Insurance_Status__c,X1st_Policy_Insurance_Type__c, ';
			q += '(SELECT Id,Name FROM Insurance_Verification_Forms__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),';
 			q += '(SELECT Id,Name,TransportationStatus__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)';
 			q += ' FROM Case WHERE Status IN(';
 			q += '\'3- Pending Assessment Review & Approval\',';
 			q += '\'5- Pending Confirmation of Admission\') AND IsDeleted = FALSE ';
 			if(UserState != 'ALL')
 				q += ' AND CreatedBy.State = \'' + UserState + '\'';
 			q += ' ORDER BY CreatedDate ';
 			q +=  sortDirection;
 			
 			
 			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
			cases = (List<Case>)database.query(q);
	}
	else if(sortExpression == 'AccountName')
	{
		string q = 'SELECT AccountId,Account.Name,Account.Parent_Account_Type__c,Id,CaseNumber,CreatedDate,OwnerId,Owner.Name,Status,Primary_Insurance_Form__c,Insurance_Status__c,X1st_Policy_Insurance_Type__c, ';
			q += '(SELECT Id,Name FROM Insurance_Verification_Forms__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),';
 			q += '(SELECT Id,Name,TransportationStatus__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)';
 			q += ' FROM Case WHERE Status IN(';
 			q += '\'3- Pending Assessment Review & Approval\',';
 			q += '\'5- Pending Confirmation of Admission\') AND IsDeleted = FALSE ';
 			if(UserState != 'ALL')
 				q += ' AND CreatedBy.State = \'' + UserState + '\'';
 			q += ' ORDER BY Account.Name ';
 			q +=  sortDirection;
 			
 			
 			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
			cases = (List<Case>)database.query(q);
	}
	else if(sortExpression == 'AssessmentName')
	{
		//cant sort by assessment because its not a direct object
	}
	else if(sortExpression == 'AssessmentStatus')
	{
		
	}
	else if(sortExpression == 'InsuranceStatus')
	{
		string q = 'SELECT AccountId,Account.Name,Account.Parent_Account_Type__c,Id,CaseNumber,CreatedDate,OwnerId,Owner.Name,Status,Primary_Insurance_Form__c,Insurance_Status__c,X1st_Policy_Insurance_Type__c, ';
			q += '(SELECT Id,Name FROM Insurance_Verification_Forms__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),';
 			q += '(SELECT Id,Name,TransportationStatus__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)';
 			q += ' FROM Case WHERE Status IN(';
 			q += '\'3- Pending Assessment Review & Approval\',';
 			q += '\'5- Pending Confirmation of Admission\') AND IsDeleted = FALSE ';
 			if(UserState != 'ALL')
 				q += ' AND CreatedBy.State = \'' + UserState + '\''; 				
 			q += ' ORDER BY Insurance_Status__c ';
 			q +=  sortDirection;
 			
 			
 			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
			cases = (List<Case>)database.query(q);
		
	}
	else if(sortExpression == 'PolicyType')
	{
		string q = 'SELECT AccountId,Account.Name,Account.Parent_Account_Type__c,Id,CaseNumber,CreatedDate,OwnerId,Owner.Name,Status,Primary_Insurance_Form__c,Insurance_Status__c,X1st_Policy_Insurance_Type__c, ';
			q += '(SELECT Id,Name FROM Insurance_Verification_Forms__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),';
 			q += '(SELECT Id,Name,TransportationStatus__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)';
 			q += ' FROM Case WHERE Status IN(';
 			q += '\'3- Pending Assessment Review & Approval\',';
 			q += '\'5- Pending Confirmation of Admission\') AND IsDeleted = FALSE ';
 			if(UserState != 'ALL')
 				q += ' AND CreatedBy.State = \'' + UserState + '\''; 			
 			q += ' ORDER BY X1st_Policy_Insurance_Type__c ';
 			q +=  sortDirection;
 			
 			
 			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
			cases = (List<Case>)database.query(q);
		
	}
	else if(sortExpression == 'OwnerName')
	{
		string q = 'SELECT AccountId,Account.Name,Account.Parent_Account_Type__c,Id,CaseNumber,CreatedDate,OwnerId,Owner.Name,Status,Primary_Insurance_Form__c,Insurance_Status__c,X1st_Policy_Insurance_Type__c, ';
			q += '(SELECT Id,Name FROM Insurance_Verification_Forms__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),';
 			q += '(SELECT Id,Name,TransportationStatus__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)';
 			q += ' FROM Case WHERE Status IN(';
 			q += '\'3- Pending Assessment Review & Approval\',';
 			q += '\'5- Pending Confirmation of Admission\') AND IsDeleted = FALSE ';
 			if(UserState != 'ALL')
 				q += ' AND CreatedBy.State = \'' + UserState + '\''; 			
 			q += ' ORDER BY Owner.Name ';
 			q +=  sortDirection;
 			
 			
 			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
			cases = (List<Case>)database.query(q);
	}
	else if(sortExpression == 'ParentAccountType')
	{
		string q = 'SELECT AccountId,Account.Name,Account.Parent_Account_Type__c,Id,CaseNumber,CreatedDate,OwnerId,Owner.Name,Status,Primary_Insurance_Form__c,Insurance_Status__c,X1st_Policy_Insurance_Type__c, ';
			q += '(SELECT Id,Name FROM Insurance_Verification_Forms__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1),'; 
 			q += '(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),';
 			q += '(SELECT Id,Name,TransportationStatus__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)';
 			q += ' FROM Case WHERE Status IN(';
 			q += '\'3- Pending Assessment Review & Approval\',';
 			q += '\'5- Pending Confirmation of Admission\') AND IsDeleted = FALSE ';
 			if(UserState != 'ALL')
 				q += ' AND CreatedBy.State = \'' + UserState + '\''; 			
 			q += ' ORDER BY Account.Parent_Account_Type__c ';
 			q +=  sortDirection;
 			
 			
 			//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
			cases = (List<Case>)database.query(q);
	}
	else if(sortExpression == 'PaymentVerified')
	{
		
	}
	
	return null;
}

public PageReference SortDataInsurance()
{
	string q = 'SELECT Id,Name,Case__r.Id, Case__r.CaseNumber, ClientName__c, Case_Insurance_Status__c, Owner.Name, CreatedDate FROM InsuranceVerificationForm__c WHERE VerificationComplete__c = false AND IsDeleted = FALSE  ';
	if(UserState != 'ALL')
	{
		if(UserState == 'TN')
			q += ' AND CreatedBy.State IN(\'CA\',\'TN\')';
		else
			q += ' AND CreatedBy.State = \'' + UserState + '\'';
	}
	q += ' ORDER BY CreatedDate ASC';
	
	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
	forms =(List<InsuranceVerificationForm__c>)database.query(q);

	return null;
}

public PageReference SortDataAssessment()
{
	
	string q = 'SELECT Id,Name,Case__r.Account.Name,Person_Completing_Assessment__c, Assessment_Status__c,Assessment_DateTime__c, Case__r.Id, Case__r.CaseNumber, CreatedBy.Name, CreatedDate, Placement_Queue__c FROM Assessment__c WHERE Assessment_Approved_By__c = null AND IsDeleted = FALSE  ';
		if(UserState != 'ALL')
			q += ' AND CreatedBy.State = \'' + UserState + '\'';
	
	q += ' ORDER BY CreatedDate ASC';
	
	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
	assessments =(List<Assessment__c>)database.query(q);

	return null;
}

public PageReference SortDataPaymentArrangement()
{
	
	string q = 'SELECT Id,Name,Case__r.Account.Name, Case__r.Id, Case__r.CaseNumber, CreatedBy.Name, CreatedDate, Payment_Arrangement_Status__c FROM Payment_Arrangement__c WHERE Payment_Arrangement_Status__c != \'Approved\' AND IsDeleted = FALSE ';
		if(UserState != 'ALL')
			q += ' AND CreatedBy.State =\'' + UserState + '\'';
		
		q += ' ORDER BY CreatedDate ASC';
		
	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,q));
	paymentArrangements =(List<Payment_Arrangement__c>)database.query(q);

	return null;
		
}



public MasterViewController()
{
	/*
	cases = [SELECT 
			AccountId,
			Account.Name,
			Account.Parent_Account_Type__c, 
			Id, 
			CaseNumber,
			CreatedDate,
			OwnerId, 
			Owner.Name,
			Status,  
			Primary_Insurance_Form__c,
			Insurance_Status__c, 
			X1st_Policy_Insurance_Type__c,
			(SELECT Id,Name FROM Insurance_Verification_Forms__r ORDER BY CreatedDate DESC LIMIT 1), 
 			(SELECT Id,Name,Payment_Arrangement_Status__c FROM Payment_Arrangements__r ORDER BY CreatedDate DESC LIMIT 1), 
 			(SELECT Id,Name,Assessment_Status__c FROM Assessments__r ORDER BY CreatedDate DESC LIMIT 1),
 			(SELECT Id,Name,TransportationStatus__c FROM Transportation__r ORDER BY CreatedDate DESC LIMIT 1)
 			FROM Case WHERE Status IN('3- Pending Assessment Review & Approval','5- Pending Confirmation of Admission')
 			ORDER BY CaseNumber DESC];
 			*/
 	SortData();	
	SortDataInsurance();
	SortDataAssessment();
	SortDataPaymentArrangement();
}



public InsuranceViewItem[] getInsuranceItems()
{
	InsuranceViewItem[] items = new InsuranceViewItem[]{};

	if(forms.size() > 0)
	{
		for(InsuranceVerificationForm__c f : forms)
		{
			InsuranceViewItem i = new InsuranceViewItem();
			i.Id = f.Id;
			i.Name = f.Name;
			i.CaseId = f.Case__r.Id;
			i.CaseNumber = f.Case__r.CaseNumber;
			i.ClientName = f.ClientName__c;
			i.InsuranceStatus = f.Case_Insurance_Status__c;
			i.OwnerName = f.Owner.Name;
			i.CreatedDate = f.CreatedDate;
			
			items.add(i);
		}
	}
	
	return items;
}
public AssessmentViewItem[] getAssessmentItems()
{
	AssessmentViewItem[] items = new AssessmentViewItem[]{};

	if(assessments.size() > 0)
	{
		for(Assessment__c a : assessments)
		{
			AssessmentViewItem i = new AssessmentViewItem();
			i.Id = a.Id;
			i.Name = a.Name;
			i.CaseId = a.Case__r.Id;
			i.CaseNumber = a.Case__r.CaseNumber;
			i.ClientName = a.Case__r.Account.Name;
			i.AssessmentStatus = a.Assessment_Status__c;
			i.OwnerName = a.CreatedBy.Name;
			i.CreatedDate = a.CreatedDate;
			
			items.add(i);
		}
	}
	
	return items;
}
public PaymentArrangementViewItem[] getPaymentArrangementItems()
{
	PaymentArrangementViewItem[] items = new PaymentArrangementViewItem[]{};

	if(paymentArrangements.size() > 0)
	{
		for(Payment_Arrangement__c a : paymentArrangements)
		{
			PaymentArrangementViewItem i = new PaymentArrangementViewItem();
			i.Id = a.Id;
			i.Name = a.Name;
			i.CaseId = a.Case__r.Id;
			i.CaseNumber = a.Case__r.CaseNumber;
			i.ClientName = a.Case__r.Account.Name;
			i.PaymentArrangementStatus = a.Payment_Arrangement_Status__c;
			i.OwnerName = a.CreatedBy.Name;
			i.CreatedDate = a.CreatedDate;
			
			items.add(i);
		}
	}
	
	return items;
}

public MasterViewItem[] getItems()
{
	
	MasterViewItem[] items = new MasterViewItem[]{};
	
	if(cases.size() > 0)
	{
		for(integer i = 0; i < cases.size(); i++)
		{
			Case c = cases[i];
			MasterViewItem x = new MasterViewItem();
			x.CaseId = cases[i].Id;
			x.CaseNumber = cases[i].CaseNumber;
			x.CreatedDate = cases[i].CreatedDate;
			x.OwnerId = cases[i].OwnerId;
			x.OwnerName = cases[i].Owner.Name;
			x.Status = cases[i].Status;
			
			
			x.AccountId = cases[i].AccountId;
			x.AccountName = cases[i].Account.Name; 
			x.ParentAccountType = cases[i].Account.Parent_Account_Type__c;

			x.InsuranceStatus = cases[i].Insurance_Status__c;
			x.PolicyType = cases[i].X1st_Policy_Insurance_Type__c;
			
			for(InsuranceVerificationForm__c n : c.Insurance_Verification_Forms__r)
			{
				x.InsuranceId = n.Id;
				x.InsuranceName = n.Name;
			}
			
			for(Assessment__c a : c.Assessments__r)
			{
				x.AssessmentId = a.Id;
				x.AssessmentName = a.Name;
				x.AssessmentStatus = a.Assessment_Status__c;
			}
			for(Transportation__c t : c.Transportation__r)
			{
				x.TransportationId = t.Id;
				x.TransportationName = t.Name;
				x.TransportationStatus = t.TransportationStatus__c;				
			}
			for(Payment_Arrangement__c p : c.Payment_Arrangements__r)
			{
				x.PaymentArrangementId = p.Id;
				x.PaymentArrangementName = p.Name;
				x.PaymentArrangementStatus = p.Payment_Arrangement_Status__c;				
			}
			
			items.add(x);
		}			
	}
	
	
	return items;
}

public PageReference Refresh()
{
	PageReference ref = new PageReference('/apex/MasterView?sfdc.tabName=01rG0000000ieGf');
	ref.setRedirect(true);
	return ref;
}

}