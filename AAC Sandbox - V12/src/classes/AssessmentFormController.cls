public class AssessmentFormController {
  public Case ParentCase{get;set;}
  public Assessment__c Form{get;set;}
  public List<InsuranceVerificationForm__c> InsuranceForms {get;set;}
  public InsuranceVerificationForm__c InsuranceForm {get;set;}

  public Boolean ShowTakeButton
  {
  	get 
  	{
  		if(VerifyUser() && Form.Reviewer__c != UserInfo.getUserId())
  			return true;
  		else
  			return false;
  	}
  	set;
  }
  public Boolean ShowApproveButton
  {
        get
        {               
                if(Form.Assessment_Status__c == 'Pending Approval' && VerifyUser())
                        return true;
                else
                        return false;
        }
        set;
  }
  
  public Boolean ShowRejectButton
  {
            get
        {
                if(Form.Assessment_Status__c == 'Pending Approval' || (Form.Assessment_Status__c == 'Approved' && VerifyUser()))
                        return true;
                else    
                        return false;
        }
        set;
  }
  
  public Boolean ShowSubmitButton{
        get
        {
                if(Form.Assessment_Status__c == 'New' || Form.Assessment_Status__c == 'Rejected')
                        return true;
                else    
                        return false;
        }
        set;
  }
  
  public Boolean ShowSaveButton
  {
        //this turns the SAVE button off so they cant save anything if its already approved.
        get
        {
                if(Form.Assessment_Status__c == 'Approved')
                        return false;
                else
                        return true;
        }
        set;
  }
  
  public Map<String, String> FieldLabels{get;set;}
  public Map<String, String> FieldHelpText{get;set;}
  public decimal ifnull(decimal num)
  {
    if (num == null) num = 0;
    
    return num;
  }

  public Boolean VerifyUser()
  {
        //look up the current user
        //check their profile against our allowed list
        //if they match, show the button, otherwise dont.
        User u = [select Id,ProfileId from User WHERE Id = :UserInfo.getUserId()];
        Profile p = [select Id,Name from Profile WHERE Id = :u.ProfileId];

                //public group for TN team, if you are a member you are verified
        List<GroupMember> g = [SELECT GroupId, Id, UserOrGroupId FROM GroupMember WHERE GroupId = '00GG0000002tflLMAQ' AND UserOrGroupId = :UserInfo.getUserId()];
                
                
                
        if(p.Name == 'AAC-Inside Sales Manager' || p.Name == 'AAC-Executive User' || p.Name == 'System Administrator' || g.size() > 0)
                return true;
        else
            return false;
  	}
        
    public AssessmentFormController(ApexPages.StandardController controller)
    {
        Form = (Assessment__c)controller.getRecord();
        ParentCase = [SELECT Id,Status,Account.Name,CreatedByid,Funding_Type__c,CaseNumber,Insurance_Status__c,OwnerId FROM Case WHERE Id = :Form.Case__c];
        
        if(ParentCase.Funding_Type__c != 'Private Pay')
        {
            try
            {
                    InsuranceForms = [Select Id,Name FROM InsuranceVerificationForm__c WHERE Case__c = :Form.Case__r.Id];
            }
            catch(Exception e)
            {
                    InsuranceForms = new List<InsuranceVerificationForm__c>();
            }
            
            if(InsuranceForms.size() > 0)
            {
                    InsuranceForm = (InsuranceVerificationForm__c)InsuranceForms[0];
            }
        }
        
        FieldLabels = new Map<String, String>();
        FieldHelpText = new Map<String, String>();
        
        Map<String, Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();  
        Schema.sObjectType objType = globalDescription.get('Assessment__c');  
    
        Schema.DescribeSObjectResult objResult = objType.getDescribe();  
        Map<String, Schema.SObjectField> mapFields = objResult.fields.getMap();  
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
        
        
        public PageReference ApproveAssessment()
        {
                
                Form.Assessment_Approved_By__c = UserInfo.getUserId();
                Form.Assessment_Status__c = 'Approved';
                Form.Client_Name__c = ParentCase.Account.Name;
                update Form;
                
                if(ParentCase != null)
                {
                        ParentCase.Status = '4- Pending Flight Travel Booking';
                        update ParentCase;
                }
                
                GeneratePDF();
                    
                PageReference ref = new PageReference('/' + ParentCase.Id);
                ref.setRedirect(true);
                return ref;
        }
        
        public void GeneratePDF()
        {
                PageReference pdf = Page.AssessmentViewer;
                pdf.getParameters().put('id', Form.Id);
                Attachment a = new Attachment();
                Blob body;
                try
                {
                        //looks up the page, which is renderas pdf and stores it
                        body = pdf.getContent();
                }
                catch(VisualforceException e)
                {
                        body = Blob.valueOf('Error: ' + e);
                }
                
                a.Body = body;
                a.Name = Form.Id;
                a.IsPrivate = false;
                a.ParentId = Form.Id;
                insert a;
                
        }
        public PageReference TakeAssessment()
        {
        	Form.Reviewer__c = UserInfo.getUserId();
        	update Form;
        	
        	PageReference ref = new PageReference('/' + Form.Id);
        	ref.setRedirect(true);
        	return ref; 
        }
        public PageReference RejectAssessment()
        {
            if(ParentCase != null)
            {
                //since you can reject an approved assessment dont change the case back in case it went past 3 already.
                if(Form.Assessment_Status__c != 'Approved')
                {
                  ParentCase.Status = '3- Pending Assessment Review & Approval';
                  update ParentCase;
                }
            }
            //Per JG we need to clear the reviewer so the views update
            //this may be a problem later if we arent tracking the reviewer over multiple instances
						Form.Reviewer__c = null;
            Form.Assessment_Approved_By__c = null;
            Form.Assessment_Status__c = 'Rejected';
            Form.Client_Name__c = ParentCase.Account.Name;
            update Form;
            
            PageReference ref = new PageReference('/' + ParentCase.Id);
            ref.setRedirect(true);
            return ref;
        }
        public PageReference Save()
        {
            try
            {
	            if(ParentCase != null)
	            {
	                Form.Client_Name__c = ParentCase.Account.Name;
	                upsert Form;
	                Form = [SELECT Id FROM Assessment__c WHERE Id = :Form.Id];
	                PageReference ref = new PageReference('/' + Form.Id);
	                ref.setRedirect(true);
	                return ref;
	            }
	            else
	            {
	                upsert Form;
	                return null;
	            }
            }
            catch(DMLException excp)
            {
                ApexPages.Message msg = new ApexPages.Message(Apexpages.Severity.ERROR, excp.getdmlMessage(0));
                ApexPages.addMessage(msg);
                return null;                    
            }
        }
        public PageReference Cancel()
        {
            if(ParentCase != null)
            {
                PageReference ref = new PageReference('/' + ParentCase.Id);
                ref.setRedirect(true);
                return ref;
            }
            else
                return null;
        }
        public PageReference SubmitAssessment()
        {
            //Assessments are now master/detail objects meaning nobody owns them.  
            //We use views to track the status changes, the status field is hidden
            //Only code can change status
                Form.Assessment_Status__c = 'Pending Approval';
                Form.Person_Completing_Assessment__c = UserInfo.getUserId();
                Form.assessment_datetime__c = datetime.now();
                Form.Client_Name__c = ParentCase.Account.Name;
                update Form;
                
                if(ParentCase != null)
                {
                        ParentCase.Status = '3- Pending Assessment Review & Approval';
                        update ParentCase;
                }
        
            PageReference ref = new PageReference('/' + ParentCase.Id);
            ref.setRedirect(true);
            return ref;
        } 
}