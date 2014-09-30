public class TestData
{
public TestData()
{
}
public PageReference CreateData()
{
List<Account> BusinessAccounts = new List<Account>();
for(integer i = 1; i <= 10; i++)
{
    Account a = new Account();
    a.Name = 'Business Test ' + i;
    a.Phone = '1231231234';
    a.BillingCountry = 'United States';
    a.BillingState = 'California';
    BusinessAccounts.add(a);
}
insert BusinessAccounts;

List<Account> PersonAccounts = new List<Account>();
integer pcount = 1;
for(Account a : BusinessAccounts)
{
    Account p = new Account();
    p.FirstName = 'Test';
    p.LastName = 'Client ' + pcount;
    p.Phone = '5551231234';
    p.BillingCountry = 'United States';
    p.BillingState = 'California';
    p.Parent_Account__c = a.Id;
    PersonAccounts.add(p);
}
insert PersonAccounts;

return null;
    
}
    
public PageReference CreateData2()
{
List<Facility__c> Facilities = [SELECT Id,Name FROM Facility__c];
List<Account> PersonAccounts = [SELECT Id FROM Account WHERE FirstName = 'Test' AND IsPersonAccount = true AND CreatedDate = today AND CreatedById = :UserInfo.getUserId()];
List<Case> Cases = new List<Case>();
for(Facility__c f : Facilities)
{
    for(Account p : PersonAccounts)
    {
        Case c = new Case();
        c.AccountId = p.Id;
        c.Status = 'Admitted';
        c.Facility_Admission_Date__c = date.today();
        c.Treatment_Facility_Lookup__c = f.Id;
        c.Funding_Type__c = 'Insurance';
        Cases.add(c);
    }    
}
insert Cases;

List<InsuranceVerificationForm__c> InsuranceForms = new List<InsuranceVerificationForm__c>();
for(Case c : Cases)
{
    InsuranceVerificationForm__c f = new InsuranceVerificationForm__c();
    f.Case__c = c.Id;
    f.Benefit_Type__c = 'In Network';
    f.InsuranceCompany__c = 'Aetna';
    f.Insurance_Company_Emdeon__c = 'Aetna #AETNX';
    f.GoodForDTX__c = true;
    f.GoodForIP__c = true;
    f.GoodForRES__c = true;
    f.GoodForPHP__c = true;
    f.GoodForIOP__c = true;
    f.PrecertificationCompanyName__c = 'TestCo';
    InsuranceForms.add(f);
}
insert InsuranceForms;

    return null;
}

    

    public PageReference CreateDOS()
    {
        List<Case> Cases = [SELECT Id,AccountId FROM Case WHERE CreatedDate = today AND CreatedById = :UserInfo.getUserId() AND AccountId != null AND Account.FirstName = 'Test' LIMIT 20];
        List<InsuranceVerificationForm__c> InsuranceForms = [SELECT Id, Case__c FROM InsuranceVerificationForm__c WHERE CreatedDate = today AND CreatedById = :UserInfo.getUserId()];

        List<Utilization_Review__c> URForms = new List<Utilization_Review__c>();
        Map<Id, Id> CaseInsMap = new Map<Id, Id>();
        for(InsuranceVerificationForm__c f : InsuranceForms)
        {
            CaseInsMap.put(f.Case__c, f.Id);
        }
        Diagnosis_Code__c code = [SELECT Id FROM Diagnosis_Code__c LIMIT 1];
        List<Utilization_Review__c> badForms = [SELECT Id FROM Utilization_Review__c WHERE CreatedDate = today and CreatedById = :UserInfo.getUserId()];
        delete badForms;
        
        for(Case c : Cases)
        {
            Utilization_Review__c u = new Utilization_Review__c();
            u.Case__c = c.Id;
            u.VOB__c = CaseInsMap.get(c.Id);
            u.Completed_By__c = 'Test User';
            u.Completed_Date__c = date.today();
            u.Primary_Diagnosis_Code__c = code.Id;
            u.Account__c = c.AccountId;
            URForms.add(u);
        }
        insert URForms;
        
        URForms = [SELECT Id, Case__c, Case__r.AccountId FROM Utilization_Review__c WHERE CreatedDate = TODAY and CreatedById = :UserInfo.getUserId()];
        
        for(Utilization_Review__c f : URForms)
        {
         Dates_of_Service__c d = new Dates_of_Service__c();
         d.Utilization_Review_Form__c = f.Id;
         ApexPages.StandardController controller = new ApexPages.StandardController(d);
         DatesOfServiceController ext = new DatesOfServiceController(controller);
         d.Start_Date__c = date.today();
         d.End_Date__c = date.today().addDays(3);
         d.Level_of_Care__c = 'DTX';
         d.Status__c = 'Approved';
         d.Authorization_Number__c = 'TEST';
         d.CM__c = 'TEST';
         d.Date_of_Review__c = date.today();
         d.Days_Per_Week__c = '7';
         d.Total_Days_Authorized__c = 7;
         d.Account__c = f.Case__r.AccountId;
         d.Review_Assigned_To_Lookup__c = UserInfo.getUserId();
            ext.ShowTotalDays = false;
            ext.ShowAuthorizationNumber = false;
            ext.ShowCM = false;
            ext.ShowDateOfNextReview = false;
            ext.ShowReviewAssignedTo = false;
            ext.ShowQuestions = false;
            ext.ShowHasBeenBilled  = false;
            ext.ShowAdminDenialQuestion = false;
            ext.ShowClinicalDenialQuestions = false;
            ext.ShowPostServiceClaimQuestion = false;
         ext.Save();
        }
        return null;
    }
    
}