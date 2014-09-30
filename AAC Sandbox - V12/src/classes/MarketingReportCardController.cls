public class MarketingReportCardController 
{
	public Account myAccount {get;set;}
	public DateTime StartDate {get;set;}
	public DateTime EndDate {get;set;}
	public string FormattedStartDate{get;set;}
	public string FormattedEndDate{get;set;}
	public string SelectedMarketingSource {get;set;}
	public transient List<Account> Accounts {get;set;}
	public transient List<Case> Cases {get;set;}
	public transient List<Case> AdmitCases {get;set;}
	public transient List<InsuranceVerificationForm__c> InsuranceForms {get;set;}
	public transient List<Assessment__c> Assessments {get;set;}
	public transient List<CallRecord> Calls {get;set;}
	public List<MarketingSourceReportCard> ReportCardList {get;set;}
	public List<MarketingSourceReportCardDetail> ReportCardDetailList {get;set;}
	public list<string> selectedSources {get;set;}
	public List<SelectOption> getSources()
	{
	    List<SelectOption> sources = new List<SelectOption>();
	 	Schema.DescribeFieldResult fieldResult = Account.Marketing_Group__c.getDescribe();
 
   		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();      
   		for( Schema.PicklistEntry f : ple)
 	    {
 	      sources.add(new SelectOption(f.getLabel(), f.getValue()));
 		}       
 
   		return sources;
	}
	public String[] getSelectedSources()
	{
	    return selectedSources;
	}
	public void setSelectedSources(String[] selectedSources)
	{
	    this.selectedSources = selectedSources;
	}
	
	
	public MarketingReportCardController()
	{
		myAccount = new Account();
		if(ApexPages.currentPage().getParameters().get('SelectedMarketingSource') != null)
			GenerateReportDetail();
	}
	public PageReference GenerateReport()
	{
		system.debug('Started Processing Report.....');
		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Searching...'));
		StartDate = myAccount.Credit_Card_Expiration_Date__pc;
		EndDate = myAccount.Date_of_birth__pc;
		
		if(StartDate == null)
			StartDate = DateTime.now().date();
		else
		{
			Date startD = Date.valueOf(myAccount.Credit_Card_Expiration_Date__pc);
			Time startT = Time.newInstance(0,0,0,0);
			StartDate = DateTime.newInstance(startD, startT);			
		}
		
		if(EndDate == null)
			EndDate = DateTime.now().addDays(1).date();
		else
		{
			Date endD = Date.valueOf(myAccount.Date_of_birth__pc);
			Time endT = Time.newInstance(23,59,59,59);
			EndDate = DateTime.newInstance(endD, endT);
		}
		
		
		if(StartDate == null || StartDate.year() < 2013)
		{
			myAccount.Credit_Card_Expiration_Date__pc = datetime.now().date();
			StartDate = myAccount.Credit_Card_Expiration_Date__pc;
		}
		if(EndDate == null || EndDate.year() < 2013)
		{
			myAccount.Date_of_birth__pc = datetime.now().addDays(-1).date();
			EndDate = myAccount.Date_of_birth__pc;
		}
		
		
		DateTime searchStart = DateTime.valueOf(StartDate).date();
		DateTime searchEnd = DateTime.valueOf(EndDate).date();
		system.debug('SEARCHSTART: ' + searchStart);
		system.debug('SEARCHEND: ' + searchEnd);
		
		
		string StartDateDisplay = string.valueOf(myAccount.Credit_Card_Expiration_Date__pc);
		string EndDateDisplay = string.valueOf(myAccount.Date_of_birth__pc);
		FormattedStartDate = StartDateDisplay;
		FormattedEndDate = EndDateDisplay;
		
		string StartDateString = StartDate + 'T00:00:00Z';
		string EndDateString = EndDate + 'T23:59:59Z';
		
		system.debug('StartDate: ' + StartDate + ' EndDate: ' + EndDate);
		
		List<Account> marketingAccounts = [SELECT Name,Phone,Marketing_Group__c FROM Account WHERE RecordTypeId = '012G00000017990IAA' And Phone != null AND Marketing_Group__c != null];
		system.debug('Found ' + marketingAccounts.size() + ' marketing accounts!');
		
		ReportCardList = new List<MarketingSourceReportCard>();
		/*
		string[] selectedGroups = new string[]{};
		if(myAccount.Marketing_Group__c != null)
			 selectedGroups = myAccount.Marketing_Group__c.split(';');
		else
			selectedGroups.add('Other');
		*/
		system.debug('Searching groups set to '  + selectedSources.size() +  ' items.');
		
		//only get calls 1 time
		//===================================================
		AvayaService2.QueryServiceSoap service = new AvayaService2.QueryServiceSoap();
		service.timeout_x = 90000;
		AvayaService2.ArrayOfCallDetail callRecords = new AvayaService2.ArrayOfCallDetail();
		
		try
		{
			system.debug('Searching for StartDate: ' + StartDate + ' EndDate:  ' + EndDate);
			callRecords = service.GetUniqueCallsCountByDIDAndDate(datetime.valueOf(StartDateString), datetime.valueOf(EndDateString));
		}
		catch(Exception ex)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Bad input data.  Search cancelled.'));
		}
		Calls = new List<CallRecord>();
		if(callRecords.CallDetail != null)
		{
			for(AvayaService2.CallDetail call : callRecords.CallDetail)
			{
				CallRecord cr = new CallRecord();
				cr.CallCount = call.CallCount;
				cr.TotalTalkTimeMinutes = call.TotalTalkTimeMinutes;
				cr.DID = call.DDI;
				Calls.add(cr);
			}
		}
		//======================================================
		for(string s : selectedSources)
		{
			system.debug('Searching for ' + s);

			
			//these need modified to only show parent multimedia accounts matching the calls
			Accounts = [SELECT Id 
						FROM Account 
						WHERE CreatedDate >= :DateTime.valueOf(StartDateString) 
						AND CreatedDate <= :DateTime.valueOf(EndDateString) 
						AND IsPersonAccount = true
						AND IsDeleted = false 
						AND Parent_Account__r.RecordTypeId = '012G00000017990IAA' 
						AND Parent_Account__r.Marketing_Group__c = :s];
						
 			system.debug('Accounts: ' + Accounts.size());
 			
 			Cases = [SELECT Id,Status,Facility_Admission_Date__c, (SELECT Verified_Cash__c FROM Payment_Arrangements__r) 
 					FROM Case 
 					WHERE (CreatedDate >= :DateTime.valueOf(StartDateString).date() AND CreatedDate <= :DateTime.valueOf(EndDateString).date())
 					AND IsDeleted = false
 				  AND AccountId IN (SELECT Id FROM Account WHERE IsPersonAccount = true
 					AND Parent_Account__r.RecordTypeId = '012G00000017990IAA'
 					AND Parent_Account__r.Marketing_Group__c = :s)];
 			
 			AdmitCases = [SELECT Id,CaseNumber,Status,Facility_Admission_Date__c 
 					FROM Case 
 					WHERE (Facility_Admission_Date__c >= :DateTime.valueOf(StartDateString).date() AND Facility_Admission_Date__c <= :DateTime.valueOf(EndDateString).date())
 					AND IsDeleted = false
 				  AND AccountId IN (SELECT Id FROM Account WHERE IsPersonAccount = true
 					AND Parent_Account__r.RecordTypeId = '012G00000017990IAA'
 					AND Parent_Account__r.Marketing_Group__c = :s) ORDER BY CaseNumber];
 			//AND Facility_Admission_Date__c <= LAST_MONTH
 			system.debug('Cases: ' + Cases.size());
 			system.debug('******AdmitCases: ' + AdmitCases.size());	
 									
 			InsuranceForms = [SELECT Id FROM InsuranceVerificationForm__c 
 								WHERE (CreatedDate >= :DateTime.valueOf(StartDateString).date() AND CreatedDate <= :DateTime.valueOf(EndDateString).date())
			 					AND IsDeleted = false
 								AND Case__r.Account.Parent_Account__r.RecordTypeId = '012G00000017990IAA'
 								AND Case__r.Account.Parent_Account__r.Marketing_Group__c = :s];
			
			system.debug('InsuranceForms: ' + InsuranceForms.size());


 			Assessments = [SELECT Id FROM Assessment__c 
 							WHERE (CreatedDate >= :DateTime.valueOf(StartDateString).date() AND CreatedDate <= :DateTime.valueOf(EndDateString).date())
 							AND IsDeleted = false
 							AND Case__r.Account.Parent_Account__r.RecordTypeId = '012G00000017990IAA'
 							AND Case__r.Account.Parent_Account__r.Marketing_Group__c = :s];
 			
 			system.debug('Assessments: ' + Assessments.size());
 			
			MarketingSourceReportCard myReportCard = new MarketingSourceReportCard();
			
			myReportCard.MarketingGroupName = s;
			integer TotalGroupCalls = 0;
			integer TotalTalkTime = 0;
			myReportCard.Calls = 0;
			myReportCard.TotalTalkTimeMinutes = 0;
			if(calls.size() > 0)
			{
				system.debug('Found calls...');
				for(Account mka : marketingAccounts)
				{
					system.debug('checking marketing account ' + mka.Name + ' , phone: ' + mka.Phone);
					string phoneNumber = mka.Phone;
					phoneNumber = phoneNumber.replace('(','');
                    phoneNumber = phoneNumber.replace(')','');
                    phoneNumber = phoneNumber.replace(' ','');
                    phoneNumber = phoneNumber.replace('-','');
                    phoneNumber = phoneNumber.replace('.','');
                    phoneNumber = phoneNumber.replace('x','');
                    system.debug('Phone fixed to: ' + phoneNumber);
                    
					if(mka.Marketing_Group__c == s)
					{
						system.debug('Marketing Group Match!');
						for(CallRecord mkcr : Calls)
						{						
							if(mkcr.DID == phoneNumber)
							{
								system.debug('Found a matching DID from Avaya, CallCount: ' + string.valueOf(mkcr.CallCount));
								TotalGroupCalls += mkcr.CallCount.intValue();
								system.debug(TotalGroupCalls);
								TotalTalkTime += mkcr.TotalTalkTimeMinutes.intValue();
								system.debug(TotalTalkTime);
							}
						}
					}
				}
			}
			myReportCard.Calls = TotalGroupCalls;
			myReportCard.TotalTalkTimeMinutes = TotalTalkTime;
			if(myReportCard.Calls != null && myReportCard.Calls != 0 && myReportCard.TotalTalkTimeMinutes != null && myReportCard.TotalTalkTimeMinutes != 0)
				myReportCard.AverageTalkTime = myReportCard.TotalTalkTimeMinutes / myReportCard.Calls;
			else
				myReportCard.AverageTalkTime = 0;
			
			myReportCard.Accounts = Accounts.size();
			myReportCard.Cases = Cases.size();
			myReportCard.InsuranceForms = InsuranceForms.size();
 			myReportCard.Assessments = Assessments.size();
			myReportCard.Admissions = AdmitCases.size();
			
			decimal totalCash = 0;
			for(Case c : Cases)
			{			
				for(Payment_Arrangement__c p : c.Payment_Arrangements__r)
    			{
        			totalCash += p.Verified_Cash__c;
    			}
			}
			myReportCard.TotalCashCollected = totalCash;

			
			if(myReportCard.Admissions > 0 && myReportCard.Calls > 0)
			{
				myReportCard.ConversionRatio = (decimal.valueOf(myReportCard.Admissions) / decimal.valueOf(myReportCard.Calls)) * 100;
				myReportCard.ConversionRatio = myReportCard.ConversionRatio.setScale(2);
			}
			else
				myReportCard.ConversionRatio = 0;
			
			ReportCardList.add(myReportCard);
		}
		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Report Card Generated!'));
		return null;
	}
	public PageReference GenerateReportDetail()
	{
		
		system.debug('Started Processing Report.....');
		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Searching...'));


		if(ApexPages.currentPage().getParameters().get('StartDate') == null)
			StartDate = DateTime.now().date();
		else
		{
			Date startD = Date.valueOf(ApexPages.currentPage().getParameters().get('StartDate') + ' 00:00:00');
			Time startT = Time.newInstance(0,0,0,0);
			StartDate = DateTime.newInstance(startD, startT);			
		}
		
		if(ApexPages.currentPage().getParameters().get('EndDate') == null)
			EndDate = DateTime.now().addDays(1).date();
		else
		{
			Date endD = Date.valueOf(ApexPages.currentPage().getParameters().get('EndDate') + ' 23:59:59');
			Time endT = Time.newInstance(23,59,59,59);
			EndDate = DateTime.newInstance(endD, endT);
		}


		
		if(ApexPages.currentPage().getParameters().get('SelectedMarketingSource') == null)	
			SelectedMarketingSource = 'Other';
		else
			SelectedMarketingSource = ApexPages.currentPage().getParameters().get('SelectedMarketingSource');

			
		if(StartDate == null || StartDate.year() < 2013)
		{
			myAccount.Credit_Card_Expiration_Date__pc = datetime.now().date();
			StartDate = myAccount.Credit_Card_Expiration_Date__pc;
		}
		if(EndDate == null || EndDate.year() < 2013)
		{
			myAccount.Date_of_birth__pc = datetime.now().date();
			EndDate = myAccount.Date_of_birth__pc;
		}
		
		
		DateTime searchStart = DateTime.valueOf(StartDate).date();
		DateTime searchEnd = DateTime.valueOf(EndDate).date();
		system.debug('SEARCHSTART: ' + searchStart);
		system.debug('SEARCHEND: ' + searchEnd);
		
		
		string StartDateDisplay = string.valueOf(myAccount.Credit_Card_Expiration_Date__pc);
		string EndDateDisplay = string.valueOf(myAccount.Date_of_birth__pc);
		
		string StartDateString = StartDate + 'T00:00:00Z';
		string EndDateString = EndDate + 'T23:59:59Z';
		
		system.debug('StartDate: ' + StartDate + ' EndDate: ' + EndDate);
		
		List<Account> marketingAccounts = [SELECT Id,
												  Name,
												  Phone,
												  Marketing_Group__c 
												  FROM Account 
												  WHERE RecordTypeId = '012G00000017990IAA' 
												  And Phone != null 
												  AND Marketing_Group__c = :SelectedMarketingSource];
		
		Accounts = [SELECT 
						Id,
						Name,
						Parent_Account__r.Id, 
						Parent_Account__r.Name 
						FROM Account 
						WHERE CreatedDate >= :DateTime.valueOf(StartDateString) 
						AND CreatedDate <= :DateTime.valueOf(EndDateString) 
						AND IsPersonAccount = true 
						AND IsDeleted = false
						AND Parent_Account__r.RecordTypeId = '012G00000017990IAA'
						AND Parent_Account__r.Id IN :marketingAccounts];
						 			
 		Cases = [SELECT Id,Status,Facility_Admission_Date__c,Account.Parent_Account__r.Id,Account.Parent_Account__r.Name, (SELECT Verified_Cash__c FROM Payment_Arrangements__r) 
		 					FROM Case 
		 					WHERE (CreatedDate >= :DateTime.valueOf(StartDateString).date() AND CreatedDate <= :DateTime.valueOf(EndDateString).date())
		 					AND IsDeleted = false
		 				  AND AccountId IN (SELECT Id FROM Account WHERE IsPersonAccount = true
		 				  AND Parent_Account__r.Id IN :marketingAccounts)];
 			
 		AdmitCases = [SELECT Id,CaseNumber,Status,Facility_Admission_Date__c,Account.Parent_Account__r.Id,Account.Parent_Account__r.Name
 					        FROM Case 
 						      WHERE (Facility_Admission_Date__c >= :datetime.valueOf(StartDateString).date() AND Facility_Admission_Date__c <= :datetime.valueOf(EndDateString).date())
		 						  AND IsDeleted = false
 				          AND AccountId IN (SELECT Id FROM Account WHERE IsPersonAccount = true
 					        AND Parent_Account__r.Id IN  :marketingAccounts) ORDER BY CaseNumber];
					
		InsuranceForms = [SELECT Id,Case__r.Account.Parent_Account__r.Id,Case__r.Account.Parent_Account__r.Name FROM InsuranceVerificationForm__c 
				 							 WHERE (CreatedDate >= :datetime.valueOf(StartDateString).date() AND CreatedDate <=  :datetime.valueOf(EndDateString).date())
							 				 AND IsDeleted = false
				 							 AND Case__r.Account.Parent_Account__r.Id IN :marketingAccounts];
 							  
		Assessments = [SELECT Id,Case__r.Account.Parent_Account__r.Id, Case__r.Account.Parent_Account__r.Name FROM Assessment__c 
		 						   WHERE (CreatedDate = :datetime.valueOf(StartDateString).date() AND CreatedDate <= :datetime.valueOf(StartDateString).date())
		 						   AND IsDeleted = false
		 						   AND Case__r.Account.Parent_Account__r.Id IN :marketingAccounts];
		
		system.debug('Found ' + marketingAccounts.size() + ' marketing accounts!');
		
		ReportCardDetailList = new List<MarketingSourceReportCardDetail>();


		
		//only get calls 1 time
		//===================================================
		AvayaService2.QueryServiceSoap service = new AvayaService2.QueryServiceSoap();
		service.timeout_x = 90000;
		AvayaService2.ArrayOfCallDetail callRecords = new AvayaService2.ArrayOfCallDetail();
		
		try
		{
			system.debug('Searching for StartDate: ' + StartDate + ' EndDate:  ' + EndDate);
			callRecords = service.GetUniqueCallsCountByDIDAndDate(datetime.valueOf(StartDateString), datetime.valueOf(EndDateString));
		}
		catch(Exception ex)
		{
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Bad input data.  Search cancelled.'));
		}
		Calls = new List<CallRecord>();
		if(callRecords.CallDetail != null)
		{
			for(AvayaService2.CallDetail call : callRecords.CallDetail)
			{
				CallRecord cr = new CallRecord();
				cr.CallCount = call.CallCount;
				cr.TotalTalkTimeMinutes = call.TotalTalkTimeMinutes;
				cr.DID = call.DDI;
				Calls.add(cr);
			}
		}
		//======================================================
		for(Account marketingAccount : marketingAccounts)
		{
			integer accountsCreated = 0;
			integer casesCreated = 0;
			integer insuranceCreated = 0;
			integer assessmentCreated = 0;
			integer rescuesCreated = 0;
			
			for(Account myAcc : Accounts)
			{
				if(myAcc.Parent_Account__r.Id == marketingAccount.Id)
					accountsCreated++;		
			}
			for(Case myCase : Cases)
			{
				if(myCase.Account.Parent_Account__r.Id == marketingAccount.Id)
						casesCreated++;
			}
			for(InsuranceVerificationForm__c myInsurance : InsuranceForms)
			{
				if(myInsurance.Case__r.Account.Parent_Account__r.Id == marketingAccount.Id)
					insuranceCreated++;
			}
			for(Assessment__c myAssessment : Assessments)
			{
				if(myAssessment.Case__r.Account.Parent_Account__r.Id == marketingAccount.Id)
					assessmentCreated++;
			}
			for(Case myRescues : AdmitCases)
			{
				if(myRescues.Account.Parent_Account__r.Id == marketingAccount.Id)
					rescuesCreated++;	
			}
			
			system.debug('Searching for ' + marketingAccount.Name);
			//these need modified to only show parent multimedia accounts matching the calls			
 			system.debug('Accounts: ' + Accounts.size() + ' matched ' + accountsCreated);
 			system.debug('Cases: ' + Cases.size() + ' matched ' + casesCreated);
 			system.debug('AdmitCases: ' + AdmitCases.size() + ' matched ' + rescuesCreated);										
			system.debug('InsuranceForms: ' + InsuranceForms.size() + ' matched ' + insuranceCreated);								
 			system.debug('Assessments: ' + Assessments.size() + ' matched ' + assessmentCreated);
 			
 			MarketingSourceReportCardDetail myReportCard = new MarketingSourceReportCardDetail();
 			myReportCard.AccountName = marketingAccount.Name;
 			myReportCard.MarketingGroupName = marketingAccount.Marketing_Group__c;
 			integer TotalGroupCalls = 0;
 			integer TotalTalkTime = 0;
 			myReportCard.Calls = 0;
 			myReportCard.TotalTalkTimeMinutes = 0;
 			
 			
			if(calls.size() > 0)
			{
				string phoneNumber = marketingAccount.Phone;
				phoneNumber = phoneNumber.replace('(','');
                phoneNumber = phoneNumber.replace(')','');
                phoneNumber = phoneNumber.replace(' ','');
                phoneNumber = phoneNumber.replace('-','');
                phoneNumber = phoneNumber.replace('.','');
                phoneNumber = phoneNumber.replace('x','');
                system.debug('Phone fixed to: ' + phoneNumber);
                for(CallRecord callRec : Calls)
                {
                	if(callRec.DID == phoneNumber)
                	{
                		system.debug('Found a matching DID from Avaya, CallCount: ' + string.valueOf(callRec.CallCount));
						TotalGroupCalls += callRec.CallCount.intValue();
						system.debug(TotalGroupCalls);
						TotalTalkTime += callRec.TotalTalkTimeMinutes.intValue();
						system.debug(TotalTalkTime);
                	}	
                }
			}
			
 			
			myReportCard.Calls = TotalGroupCalls;
			myReportCard.TotalTalkTimeMinutes = TotalTalkTime;
			if(myReportCard.Calls != null && myReportCard.Calls != 0 && myReportCard.TotalTalkTimeMinutes != null && myReportCard.TotalTalkTimeMinutes != 0)
				myReportCard.AverageTalkTime = myReportCard.TotalTalkTimeMinutes / myReportCard.Calls;
			else
				myReportCard.AverageTalkTime = 0;
			
			myReportCard.Accounts = accountsCreated;
			myReportCard.Cases = casesCreated;
			myReportCard.InsuranceForms = insuranceCreated;
 			myReportCard.Assessments = assessmentCreated;
			myReportCard.Admissions = rescuesCreated;
			
			decimal totalCash = 0;
			for(Case c : Cases)
			{
				if(c.Account.Parent_Account__r.Name == marketingAccount.Name)			
				{
					for(Payment_Arrangement__c p : c.Payment_Arrangements__r)
    				{
        				totalCash += p.Verified_Cash__c;
    				}
				}
			}
			myReportCard.TotalCashCollected = totalCash;

			
			if(myReportCard.Admissions > 0 && myReportCard.Calls > 0)
			{
				myReportCard.ConversionRatio = (decimal.valueOf(myReportCard.Admissions) / decimal.valueOf(myReportCard.Calls)) * 100;
				myReportCard.ConversionRatio = myReportCard.ConversionRatio.setScale(2);
			}
			else
				myReportCard.ConversionRatio = 0;
			
			ReportCardDetailList.add(myReportCard);
		}
		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Report Card Generated!'));
		return null;
	}
	public class CallRecord
	{        
	  public string PhoneNumber{get;set;}
	  public string AgentName{get;set;}
	  public string HuntGroup{ get; set; }
	  public string DID {get;set;}
	  public DateTime CallDate{ get; set; }
	  public long CallLength{get; set; }
	  public long CallId{ get; set; }
	  public long CallCount {get;set;}
	  public long TotalTalkTimeMinutes {get;set;}
	  public CallRecord(){}
	}
	public class MarketingSourceReportCardDetail
	{
	 public string AccountName {get;set;}
	 public string MarketingGroupName {get;set;}
	 public integer Calls {get;set;}
	 public integer Accounts {get;set;}
	 public integer Cases {get;set;}
	 public integer InsuranceForms {get;set;}
	 public integer Assessments {get;set;}
	 public integer Admissions {get;set;}
	 public decimal ConversionRatio {get;set;}
	 public decimal TotalCashCollected {get;set;}
	 public integer TotalTalkTimeMinutes{get;set;}
	 public decimal AverageTalkTime {get;set;}
	
	 public MarketingSourceReportCardDetail()
	 {
	 }
		
	}
	public class MarketingSourceReportCard
	{
	//Avaya, salesforce and calculate conversion ratio, VOB, Assessments, accounts open, cases opened
	 public string MarketingGroupName {get;set;}
	 public integer Calls {get;set;}
	 public integer Accounts {get;set;}
	 public integer Cases {get;set;}
	 public integer InsuranceForms {get;set;}
	 public integer Assessments {get;set;}
	 public integer Admissions {get;set;}
	 public decimal ConversionRatio {get;set;}
	 public decimal TotalCashCollected {get;set;}
	 public integer TotalTalkTimeMinutes{get;set;}
	 public decimal AverageTalkTime {get;set;}
	
	 public MarketingSourceReportCard()
	 {
	 }
	}
	@isTest(seealldata=true)
	private static void TestReportCard()
	{
		Account mka = new Account(Name = 'Test Co', phone = '5555555555', Marketing_Group__c = 'Other');
		insert mka;
		Account a = new Account(FirstName = 'John', LastName = 'Doh', Phone='5555555555', Credit_Card_Expiration_Date__pc =  datetime.parse('04/01/2013 12:00 AM').date(), date_of_birth__pc = datetime.parse('04/30/2013 11:59 PM').date());
		insert a;
		a.Parent_Account__c = mka.Id;
		update a;
		Case c = new Case(AccountId = a.Id, Facility_Admission_Date__c = datetime.now().date());
		insert c;
		Assessment__c assessment = new Assessment__c(Case__c = c.Id);
		insert assessment;
		InsuranceVerificationForm__c insurance = new InsuranceVerificationForm__c(Case__c = c.Id, ClientName__c = 'John Doe');
		insert insurance;

		MarketingReportCardController controller = new MarketingReportCardController();
		Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock7());
		Test.startTest();
		controller.StartDate = a.Credit_Card_Expiration_Date__pc;
		controller.EndDate = a.Date_of_birth__pc;
		controller.selectedSources = new string[] { 'Other' };
		controller.GenerateReport();
		Test.stopTest();
		
	}
	@isTest(seealldata=true)
	private static void TestReportCardDetail()
	{
		PageReference detailPage = new PageReference('MarketingSourceReportCardDetail?StartDate=2013-05-01&EndDate=2013-05-22&SelectedMarketingSource=AAC-Internet');
		Account mka = new Account(Name = 'Test Co', phone = '5555555555', Marketing_Group__c = 'Other');
		insert mka;
		Account a = new Account(FirstName = 'John', LastName = 'Doh', Phone='5555555555', Credit_Card_Expiration_Date__pc =  datetime.parse('04/01/2013 12:00 AM').date(), date_of_birth__pc = datetime.parse('04/30/2013 11:59 PM').date());
		insert a;
		a.Parent_Account__c = mka.Id;
		update a;
		Case c = new Case(AccountId = a.Id, Facility_Admission_Date__c = datetime.now().date());
		insert c;
		Assessment__c assessment = new Assessment__c(Case__c = c.Id);
		insert assessment;
		InsuranceVerificationForm__c insurance = new InsuranceVerificationForm__c(Case__c = c.Id, ClientName__c = 'John Doe');
		insert insurance;
		
		MarketingReportCardController controller = new MarketingReportCardController();
		Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock7());
		Test.startTest();
		controller.StartDate = a.Credit_Card_Expiration_Date__pc;
		controller.EndDate = a.Date_of_birth__pc;
		controller.selectedSources = new string[] { 'Other' };
		controller.GenerateReportDetail();
		Test.stopTest();
	}
	
	
}