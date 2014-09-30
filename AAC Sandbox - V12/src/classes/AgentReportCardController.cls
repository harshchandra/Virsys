public class AgentReportCardController
{
public List<String> selectedUsers {get;set;}

public List<SelectOption> getUserList()
{
    List<SelectOption> users = new List<SelectOption>();
    for(User u : [SELECT Id,Name,Extension FROM User WHERE IsActive = true AND Extension != null AND Profile.Name IN('AAC-Inside Sales User','AAC-Intervention Specialists') ORDER BY NAME])
    {
       users.add(new SelectOption(u.Extension, u.Name));
    }
    return users;
}
public String[] getSelectedUsers()
{
    return selectedUsers;
}
public void setSelectedUsers(String[] selectedUsers)
{
    this.selectedUsers = selectedUsers;
}

public List<AgentReportCard> ReportCardList {get;set;} 
public Date StartDate {get;set;}
public Date EndDate {get;set;}
public string StartDateDisplay {get;set;}
public string EndDateDisplay {get;set;}
public string StartDateString {get;set;}
public string EndDateString{get;set;}
public transient List<Account> Accounts {get;set;}
public transient List<Case> Cases {get;set;}
public transient List<Case> AdmitCases {get;set;}
public transient List<InsuranceVerificationForm__c> InsuranceForms {get;set;}
public transient List<Assessment__c> Assessments {get;set;}
public transient List<Payments__c> Payments {get;set;}
public transient List<CallRecord> Calls {get;set;}
public Case TempCase {get;set;}
public boolean RenderPDFButton 
{
    get 
    {
        return ReportCardList != null && ReportCardList.size() > 0;
    }
}

public AgentReportCardController()
{
  TempCase = new Case(); 
}
public PageReference GeneratePDF()
{
    PageReference gpdf = new PageReference('/apex/AgentReportCardViewer');
    gpdf.setRedirect(false);
    return gpdf;
}
public PageReference GetAgentReportCard()
{
 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Searching...'));
 StartDate = TempCase.Facility_Admission_Date__c;
 EndDate = TempCase.Facility_Date_of_discharge__c;
 
 if(StartDate == null || StartDate.year() < 2013)
 {
    TempCase.Facility_Admission_Date__c = datetime.now().date();
    StartDate = TempCase.Facility_Admission_Date__c;
 }
 if(EndDate == null || EndDate.year() < 2013)
 {
    TempCase.Facility_Date_of_discharge__c = datetime.now().date();
    EndDate = TempCase.Facility_Date_of_discharge__c;
 }
 
 StartDateDisplay = string.valueOf(TempCase.Facility_Admission_Date__c);
 EndDateDisplay = string.valueOf(TempCase.Facility_Date_of_discharge__c);   
 
 StartDateString = StartDate + 'T00:00:00Z';
 EndDateString = EndDate + 'T23:59:59Z';
 
 DateTime PhoneStartDate = DateTime.newInstance(StartDate, Time.newInstance(0,0,0,0));
 DateTime PhoneEndDate = DateTime.newInstance(EndDate, Time.newInstance(23,59,59,59));
 
  
 ReportCardList = new List<AgentReportCard>();
 if(selectedUsers.size() > 10)
 {
     ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Too many agents selected.  The maximum is 10.'));  
 }
 else
 {
 for(string s : selectedUsers)
 {
 User u = [SELECT Id,Name,Extension FROM User WHERE Extension = :s];
 AvayaService2.QueryServiceSoap service = new AvayaService2.QueryServiceSoap();
 service.timeout_x = 90000;
 AvayaService2.ArrayOfCallDetail callRecords = new AvayaService2.ArrayOfCallDetail();
 try
 {
    system.debug('SEARCHING----EXT: ' + s + ' StartDate: ' + StartDate + ' EndDate:  ' + EndDate);
    system.debug('SEARCHING----EXT: ' + s + ' PhoneStartDate: ' + PhoneStartDate + ' PhoneEndDate:  ' + PhoneEndDate);
    callRecords = service.GetUniqueCallsCountByAgentExtensionAndDate(s, PhoneStartDate, PhoneEndDate);
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
   Calls.add(cr);
 }
 }
 
 Accounts = [SELECT Id FROM Account 
 			WHERE (CALENDAR_YEAR(CreatedDate) = :datetime.valueOf(StartDateString).date().year()
		   		  AND CALENDAR_MONTH(CreatedDate) = :datetime.valueOf(StartDateString).date().month()
 				  AND DAY_IN_MONTH(CreatedDate) >=  :datetime.valueOf(StartDateString).date().day()
 				  )
 				AND (CALENDAR_YEAR(CreatedDate) = :datetime.valueOf(EndDateString).date().year()
 				AND CALENDAR_MONTH(CreatedDate) =   :datetime.valueOf(EndDateString).date().month()
 				AND DAY_IN_MONTH(CreatedDate) <=  :datetime.valueOf(EndDateString).date().day()
 				)
 				AND IsPersonAccount = true AND CreatedById = :u.Id];
 				
 Cases = [SELECT Id,Status,Facility_Admission_Date__c,Pay_Commission_To__c, Pay_Commission_To__r.Id,
 					  Split_Commission_With__c, Split_Commission_With__r.Id 
 			FROM Case 
 			WHERE (CALENDAR_YEAR(CreatedDate) = :datetime.valueOf(StartDateString).date().year()
			   		AND CALENDAR_MONTH(CreatedDate) = :datetime.valueOf(StartDateString).date().month()
			  		AND DAY_IN_MONTH(CreatedDate) >=  :datetime.valueOf(StartDateString).date().day()
			  		)
					AND (CALENDAR_YEAR(CreatedDate) = :datetime.valueOf(EndDateString).date().year()
					AND CALENDAR_MONTH(CreatedDate) =   :datetime.valueOf(EndDateString).date().month()
					AND DAY_IN_MONTH(CreatedDate) <=  :datetime.valueOf(EndDateString).date().day()
					) 
 			AND CreatedById = :u.Id];
 			
 Payments = [SELECT Cash_Collected__c, CreatedById, CreatedDate, Payment_Arrangement__c, Payment_Date__c, Payment_Verified__c, Id, Name 
			 FROM Payments__c
			 WHERE (CALENDAR_YEAR(Payment_Date__c) = :datetime.valueOf(StartDateString).date().year()
			   		AND CALENDAR_MONTH(Payment_Date__c) = :datetime.valueOf(StartDateString).date().month()
			  		AND DAY_IN_MONTH(Payment_Date__c) >=  :datetime.valueOf(StartDateString).date().day()
			  		)
					AND (CALENDAR_YEAR(Payment_Date__c) = :datetime.valueOf(EndDateString).date().year()
					AND CALENDAR_MONTH(Payment_Date__c) =   :datetime.valueOf(EndDateString).date().month()
					AND DAY_IN_MONTH(Payment_Date__c) <=  :datetime.valueOf(EndDateString).date().day()
					) And (Payment_Arrangement__r.Case__r.Pay_Commission_To__r.Id = :u.Id 
					OR Payment_Arrangement__r.Case__r.Split_Commission_With__r.Id = :u.Id)];

 AdmitCases = [SELECT Id,Status,Facility_Admission_Date__c,Pay_Commission_To__c, Pay_Commission_To__r.Id,
 					  Split_Commission_With__c, Split_Commission_With__r.Id 
			   FROM Case 
 			   WHERE (CALENDAR_YEAR(Facility_Admission_Date__c) = :datetime.valueOf(StartDateString).date().year()
 						   AND CALENDAR_MONTH(Facility_Admission_Date__c) = :datetime.valueOf(StartDateString).date().month()
 						   AND DAY_IN_MONTH(Facility_Admission_Date__c) >=  :datetime.valueOf(StartDateString).date().day()
 						   )
 					AND (CALENDAR_YEAR(Facility_Admission_Date__c) = :datetime.valueOf(EndDateString).date().year()
 						AND CALENDAR_MONTH(Facility_Admission_Date__c) =   :datetime.valueOf(EndDateString).date().month()
 						AND DAY_IN_MONTH(Facility_Admission_Date__c) <=  :datetime.valueOf(EndDateString).date().day()
 						)
 			   		And (Pay_Commission_To__r.Id = :u.Id 
					OR Split_Commission_With__r.Id = :u.Id)];
 			   
 			   
 InsuranceForms = [SELECT Id 
 					FROM InsuranceVerificationForm__c 
 					WHERE (CALENDAR_YEAR(CreatedDate) = :datetime.valueOf(StartDateString).date().year()
			   		AND CALENDAR_MONTH(CreatedDate) = :datetime.valueOf(StartDateString).date().month()
			  		AND DAY_IN_MONTH(CreatedDate) >=  :datetime.valueOf(StartDateString).date().day()
			  		)
					AND (CALENDAR_YEAR(CreatedDate) = :datetime.valueOf(EndDateString).date().year()
					AND CALENDAR_MONTH(CreatedDate) =   :datetime.valueOf(EndDateString).date().month()
					AND DAY_IN_MONTH(CreatedDate) <=  :datetime.valueOf(EndDateString).date().day()
					) 
 					AND CreatedById = :u.Id];
 					
 Assessments = [SELECT Id 
 				FROM Assessment__c 
 				WHERE (CALENDAR_YEAR(CreatedDate) = :datetime.valueOf(StartDateString).date().year()
			   		AND CALENDAR_MONTH(CreatedDate) = :datetime.valueOf(StartDateString).date().month()
			  		AND DAY_IN_MONTH(CreatedDate) >=  :datetime.valueOf(StartDateString).date().day()
			  		)
					AND (CALENDAR_YEAR(CreatedDate) = :datetime.valueOf(EndDateString).date().year()
					AND CALENDAR_MONTH(CreatedDate) =   :datetime.valueOf(EndDateString).date().month()
					AND DAY_IN_MONTH(CreatedDate) <=  :datetime.valueOf(EndDateString).date().day()
					) 
 				AND CreatedById = :u.Id];
 
 AgentReportCard ReportCard = new AgentReportCard();
 ReportCard.AgentName = u.Name;
 if(Calls.size() > 0)
 {
    ReportCard.Calls = integer.valueOf(Calls[0].CallCount);
    ReportCard.TotalTalkTimeMinutes = integer.valueOf(Calls[0].TotalTalkTimeMinutes);
    if((ReportCard.Calls != null && ReportCard.Calls > 0) && (ReportCard.TotalTalkTimeMinutes != null && ReportCard.TotalTalkTimeMinutes > 0))
        ReportCard.AverageTalkTime = ReportCard.TotalTalkTimeMinutes / ReportCard.Calls;
    else
        ReportCard.AverageTalkTime = 0;
 }
 else
 {
    ReportCard.Calls = 0; 
    ReportCard.TotalTalkTimeMinutes = 0; 
    ReportCard.AverageTalkTime = 0;
 }

 ReportCard.Accounts = Accounts.size();
 ReportCard.Cases = Cases.size();
 
 decimal totalCash = 0;
 for(Payments__c p : Payments)
 {
 	totalCash += p.Cash_Collected__c;
 }
 
 ReportCard.TotalCashCollected = totalCash;
 
 ReportCard.InsuranceForms = InsuranceForms.size();
 ReportCard.Assessments = Assessments.size();
 
 double admits = 0;
 for(Case c : AdmitCases)
 {
 	if(c.Pay_Commission_To__r.Id == u.Id && c.Split_Commission_With__c == null)
 		admits += 1;
 	if(c.Pay_Commission_To__r.Id == u.Id && c.Split_Commission_With__c != null)
 		admits += 0.5;
 	if(c.Split_Commission_With__r.Id == u.Id)
 		admits += 0.5;
 }
 ReportCard.Admissions = admits;
 //ReportCard.Admissions = AdmitCases.size();
 if(ReportCard.Admissions > 0 && ReportCard.Calls > 0)
     ReportCard.ConversionRatio = (decimal.valueOf(ReportCard.Admissions) / decimal.valueOf(ReportCard.Calls)) * 100;
 else
     ReportCard.ConversionRatio = 0;

 ReportCard.ConversionRatio = ReportCard.ConversionRatio.setScale(2);
 ReportCardList.add(ReportCard);
 }
 ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Report Card Generated!'));
 }
  return null;
}




private static testMethod void TestReportCard()
{
Account a = new Account(FirstName = 'John', LastName = 'Doh', Phone='5555555555');
insert a;
Case c = new Case(AccountId = a.Id, Facility_Admission_Date__c = datetime.now().date());
insert c;
Assessment__c assessment = new Assessment__c(Case__c = c.Id);
insert assessment;
InsuranceVerificationForm__c insurance = new InsuranceVerificationForm__c(Case__c = c.Id, ClientName__c = 'John Doe');
insert insurance;
User u = new User();
u.Username = 'test2@us.xyz.com';
u.LastName = 'Last2TestName';
u.Email = 'test2@us.xyz.com';
u.alias = 'testA2';
u.TimeZoneSidKey = 'America/New_York';
u.LocaleSidKey = 'en_US';
u.EmailEncodingKey = 'ISO-8859-1';
u.ProfileId = [select id from Profile where Name='System Administrator'].Id;
u.LanguageLocaleKey = 'en_US';
u.Extension = '1200';
insert u;


AgentReportCardController controller = new AgentReportCardController();
Test.setMock(WebServiceMock.class, new AvayaService2.MyWebServiceMock6());
Test.startTest();
controller.selectedUsers = new String[]{ '1200' };
controller.StartDate = c.Facility_Admission_Date__c;
controller.EndDate = c.Facility_Admission_Date__c;
controller.GetAgentReportCard();
Test.stopTest();
}


public class CallRecord
{        
  public string PhoneNumber{get;set;}
  public string AgentName{get;set;}
  public string HuntGroup{ get; set; }
  public DateTime CallDate{ get; set; }
  public long CallLength{get; set; }
  public long CallId{ get; set; }
  public long CallCount {get;set;}
  public long TotalTalkTimeMinutes {get;set;}
  public CallRecord(){}
  
}

public class AgentReportCard
{
//Avaya, salesforce and calculate conversion ratio, VOB, Assessments, accounts open, cases opened
 public string AgentName {get;set;}
 public integer Calls {get;set;}
 public integer Accounts {get;set;}
 public integer Cases {get;set;}
 public integer InsuranceForms {get;set;}
 public integer Assessments {get;set;}
 public double Admissions {get;set;}
 public decimal ConversionRatio {get;set;}
 public decimal TotalCashCollected {get;set;}
 public integer TotalTalkTimeMinutes{get;set;}
 public decimal AverageTalkTime {get;set;}
 
 
 

 public AgentReportCard()
 {
 }
}

}