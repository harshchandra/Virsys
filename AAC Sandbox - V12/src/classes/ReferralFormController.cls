public class ReferralFormController {
	public string FirstName {get;set;}
	public string LastName {get;set;}
	public Case PersonCase {get;set;}
	public Account PersonAccount {get;set;}
	public InsuranceVerificationForm__c PersonVOB {get;set;}
	public Assessment__c PersonAssessment {get;set;}
	public CaseComment PersonComment {get;set;}
	public boolean ShowSections {get;set;}
	public Map<String, String> FieldLabels {get;set;}
	public Map<String, String> FieldHelpText {get;set;}
	public ReferralFormController()
	{
		
		PersonAccount = new Account(FirstName='',LastName='');
		
		PersonCase = new Case();
		PersonVOB = new InsuranceVerificationForm__c();
		PersonAssessment = new Assessment__c();
		
		FieldLabels = new Map<String, String>();
        FieldHelpText = new Map<String, String>();
            
        Map<String, Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();  
        Schema.sObjectType objType = globalDescription.get('Assessment__c');  
        
        Schema.DescribeSObjectResult objResult = objType.getDescribe();  
        Map<String, Schema.SObjectField> mapFields = objResult.fields.getMap();
        
        List<Profile> profiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
		String MyProfileName = profiles[0].Id;
		if(MyProfileName == '00eG00000017OcsIAE' || MyProfileName == '00eG00000017OcdIAE')
			ShowSections = false;
		else
			ShowSections = true;
        
        for(Schema.SObjectField field : mapFields.values())  
        {  
          Schema.DescribeFieldResult fieldResult = field.getDescribe();  
          if(fieldResult.isAccessible())
          { 
            String name = fieldResult.getName();           
            FieldLabels.put(name, fieldResult.getLabel());  
            FieldHelpText.put(name, fieldResult.getInlineHelpText());
          }
        }  
	}
	
	public PageReference SubmitReferral()
	{
		if(FirstName != null && LastName != null)
		{
			try
			{
				PersonAccount.FirstName = FirstName;
				PersonAccount.LastName = LastName;
				PersonAccount.RecordTypeId = '012G000000178SYIAY';
				insert PersonAccount;
				
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Clients Account Created.'));
				Contact PersonContact = [SELECT Id,FirstName,LastName FROM Contact WHERE FirstName= :PersonAccount.FirstName AND LastName = :PersonAccount.LastName];
				
				
				PersonCase.AccountId = PersonAccount.Id;
				PersonCase.ContactId = PersonContact.Id;
				PersonCase.Status = 'New Referral';
				PersonCase.Origin = 'Web';
				PersonCase.Contact_SSN__c = PersonAccount.SSN__pc;
				PersonCase.RecordTypeId = '012G00000017ABRIA2';
				insert PersonCase;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Clients Case Created.'));
				
				PersonComment = new CaseComment();
				PersonComment.ParentId = PersonCase.Id;
				PersonComment.CommentBody = PersonCase.Description;
				insert PersonComment;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Instructions/Description added as a Case Comment.'));
				
				
				PersonVOB.Case__c = PersonCase.Id;
				Group queue = [SELECT Id, Name, Email, Type FROM Group WHERE Type = 'Queue' AND Name = :'Insurance Verifications TN'];
      			PersonVOB.OwnerId = queue.Id;
				insert PersonVOB;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Clients VOB Created.'));
				
				
				PersonAssessment.Case__c = PersonCase.Id;
				insert PersonAssessment;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Clients Assessment Created.'));
				return new PageReference('/' + PersonCase.Id);
			}
			catch(Exception e)
			{
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'' + e));
				return null;	
			}			
		}
		else
		{
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Name fields are required.'));
			return null;
		}	
	}
	
	private static testMethod void TestSubmitReferral()
	{
		Test.startTest();
		ReferralFormController controller = new ReferralFormController();
		controller.PersonAccount.Phone = '1231231234';
		
		controller.SubmitReferral();
		Test.stopTest();
	} 
}