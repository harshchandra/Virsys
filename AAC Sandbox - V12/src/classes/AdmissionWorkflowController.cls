public class AdmissionWorkflowController {
public Case ParentCase{get;set;}
public Assessment__c MostRecentAssessment {get;set;}
public InsuranceVerificationForm__c MostRecentInsurance {get;set;}
public boolean ButtonEnabled{get;set;}
public string ButtonText{get;set;}
public string ButtonClass{get;set;}
public string SupervisorButtonText{get;set;}
public boolean TransportationChecked{get;set;}
public boolean PaymentChecked{get;set;}
public string AssessmentValidationError {get;set;}
public string InsuranceValidationError {get;set;}
public boolean NeedsOverride {get;set;}
public boolean DisplayPopup {get;set;}

public void closePopup()
{
	DisplayPopup = false;
}
public void showPopup()
{
	DisplayPopup = true;
}

public boolean ShowAdmissionApprovedPanel
{
    get
    {
     if(ParentCase.Transportation_Approved__c == true
         && ParentCase.Payment_Arrangements_Approved__c == true
         && ParentCase.Status != '4- Pending Flight Travel Booking')
          {
            return true;          
          }
     else
      {
       return false;
      }             
    }  
}
public boolean ShowAdmissionOverridePanel
{
	get
	{
		if(NeedsOverride && ShowApprovalButton)
		{
			User u = [select Id,Name,ProfileId from User where Id = :UserInfo.getUserId()];
	    	boolean valid = false;    
	    	List<Profile> p = [select Id,Name FROM Profile WHERE Name IN ('AAC-Inside Sales Manager','AAC-Verification User','AAC-Verification Manager','System Administrator')];    
	    	if(p.size() > 0)
	    	{
	     		for(integer i = 0; i<p.size(); i++)
	      		{
	       			if(p[i].Id == u.ProfileId)
	           		valid = true;         
	      		}      
	    	}
	    	return valid;  
		}
		else
			return false;
	}
}
//every time you check a supervisor checkbox, save the value into the case
public void UpdatePaymentSetting()
{
   if(PaymentChecked)
    PaymentChecked = false;
   else
    PaymentChecked = true;
     
   ParentCase.Payment_Arrangements_Approved__c = PaymentChecked;    
   update ParentCase;
}
public void UpdateTransportationSetting()
{
    if(TransportationChecked)
        TransportationChecked = false;
    else
        TransportationChecked = true;  
    
    ParentCase.Transportation_Approved__c = TransportationChecked;    
    update ParentCase;
}


public boolean ShowSupervisorPanel
{
    get
    {   
	    User u = [select Id,Name,ProfileId from User where Id = :UserInfo.getUserId()];
	    boolean valid = false;    
	    List<Profile> p = [select Id,Name FROM Profile WHERE Name IN ('AAC-Inside Sales Manager','AAC-Verification User','AAC-Verification Manager','System Administrator')];    
	    if(p.size() > 0)
	    {
	     for(integer i = 0; i<p.size(); i++)
	      {
	       if(p[i].Id == u.ProfileId)
	           valid = true;         
	      }      
	    }
	
	    return valid;    
    }
}


public boolean ShowApprovalOptions
{
    get
    {
	 if((ParentCase.Transportation_Approved__c != true || ParentCase.Payment_Arrangements_Approved__c != true)  && (ParentCase.Status == '3- Pending Assessment Review & Approval' || ParentCase.Status == '4- Pending Flight Travel Booking'))
	    {
	     return true;        
	     }
	  else
	   {
	    return false;       
	    } 
    }
}

public boolean ShowApprovalButton
{
get
{
    if(ParentCase.Transportation_Approved__c == true && ParentCase.Payment_Arrangements_Approved__c == true && (ParentCase.Status == '3- Pending Assessment Review & Approval' || ParentCase.Status == '4- Pending Flight Travel Booking'))
        return true;
    else
        return false;
}
}

public PageReference SupervisorButtonAction()
{
if(NeedsOverride)
{
	ParentCase.Admission_Guidelines_Override__c = true;
	ParentCase.Admission_Guidelines_Overridden_By__c = UserInfo.getUserId();
	ParentCase.Admission_Guidelines_Overridden_On__c = datetime.now();
}
if(ParentCase.Status == '3- Pending Assessment Review & Approval' || ParentCase.Status == '4- Pending Flight Travel Booking')
{
if(ParentCase.Detox_Location__c == 'Client does not need detox'
    || ParentCase.Detox_Location__c == 'Greenhouse'
    || ParentCase.Detox_Location__c == 'Desert Hope'
    || ParentCase.Detox_Location__c == 'Forterus'    
    || ParentCase.Detox_Location__c == 'San Diego'
    || ParentCase.Detox_Location__c == 'Anaheim')
    {    
    	//per jessica always set to 5
    	ParentCase.Status = '5- Pending Confirmation of Admission';    
    }
    else
    {
        ParentCase.Status = '5- Pending Confirmation of Admission';
    }    
	
	List<Group> groups = new List<Group>();
	string facility = null;
	if(ParentCase.Treatment_Facility__c != null)
	{
    	groups = [select Id,Name,Email FROM Group WHERE Type='Queue' AND Name like :('Admissions%' + ParentCase.Treatment_Facility__c)];
    	facility = ParentCase.Treatment_Facility__c;
	}
    if(ParentCase.Treatment_Facility_Lookup__r.Name != null)
    {
    	groups = [select Id,Name,Email FROM Group WHERE Type='Queue' AND Name like :('Admissions%' + ParentCase.Treatment_Facility_Lookup__r.Name)];
    	facility = ParentCase.Treatment_Facility_Lookup__r.Name;
    }
    
    if(groups.size() > 0)
    {
        ParentCase.OwnerId = groups[0].Id;
        update ParentCase;
        
        User currentUser = [SELECT Id,Name,Email FROM User WHERE Id = :UserInfo.getUserId()];
        Messaging.reserveSingleEmailCapacity(1);               
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
        mail.setToAddresses(new String[] { groups[0].Email });
        mail.setCcAddresses(new String[] {'boverlund@contactaac.com','jgagnon@contactaac.com'});        
        mail.setReplyTo(currentUser.Email);        
        mail.setSenderDisplayName(currentUser.Name);        
        mail.setSubject('Notification of Admission - ' + facility);        
        mail.setPlainTextBody('Case #' + ParentCase.CaseNumber + ':\r\n The pre-admission status of this case has been completed and is pending admission to your facility.');
        mail.setHtmlBody('Case #'  + ParentCase.CaseNumber + ':<br/>The pre-admission status of <a href="https://na11.salesforce.com/' + ParentCase.Id + '">' + ParentCase.Account.Name + '</a> has been completed and is pending admission to your facility. <br />');        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                    
    }
    return null; 
}
else
    return null;
}

public Id QueueId(string userState)
{
	List<Group> groups = new List<Group>();
	
	if(userState == 'TN')
	{
		return Id.valueOf('00GG0000002teYtMAI');
	}
	else
	{
    	groups = [SELECT Id,Name,Type FROM Group WHERE Type = 'Queue' AND Name LIKE :('A&P Placement Decision Queue%' + userState)];
	}
	
    if(groups.size()>0)
    {
      return groups[0].Id;    
    }
    else
     return null;
}


public PageReference ButtonAction()
{
    if(ParentCase.Status == '4- Pending Flight Travel Booking' || ParentCase.Status == '5- Pending Confirmation of Admission')  
    {
        User u = [select Id,Name,State FROM User WHERE Id = :UserInfo.getUserId()];
        if(u.State != null)
        {
        	Id newID = QueueID(u.State);      
            ParentCase.OwnerId = newID;
            update ParentCase;
            this.ButtonText ='Admission Processed';
            
            
            //look up which facility it will go to but dont assign it yet
            List<Group> groups = new List<Group>();
            string facility = null;
            if(ParentCase.Treatment_Facility__c != null)
            {
            	groups = [select Id,Name,Email FROM Group WHERE Type='Queue' AND Name like :('Admissions%' + ParentCase.Treatment_Facility__c)];
            	facility = ParentCase.Treatment_Facility__c;
            }
            if(ParentCase.Treatment_Facility_Lookup__r.Name != null)
            {
            	groups = [select Id,Name,Email FROM Group WHERE Type='Queue' AND Name like :('Admissions%' + ParentCase.Treatment_Facility_Lookup__r.Name)];
            	facility = ParentCase.Treatment_Facility_Lookup__r.Name;	
            }
            
		    if(groups.size() > 0)
		    {
		    	//DONT REASSIGN THE CASE TO THE QUEUE HERE, IT should be reviewed by AP first, they send it to the treamtent facility queue
		        //ParentCase.OwnerId = groups[0].Id;
		        //update ParentCase;
		        
		        User currentUser = [SELECT Id,Name,Email FROM User WHERE Id = :UserInfo.getUserId()];
		        Group apGroup = new Group();
		        
		        if(u.State == 'TN')
		            apGroup = [SELECT Id,Name,Email FROM Group WHERE Type = 'Queue' AND Name ='Manager Queue'];
		        else
		        	apGroup = [SELECT Id,Name,Email FROM Group WHERE Type = 'Queue' AND Name LIKE :('A&P Placement Decision Queue%' + u.State)];
		        
		        Messaging.reserveSingleEmailCapacity(1);               
		        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
		        mail.setToAddresses(new String[] { groups[0].Email, apGroup.Email });
		        mail.setCcAddresses(new String[] {'boverlund@contactaac.com','jgagnon@contactaac.com'});          
		        mail.setReplyTo(currentUser.Email);        
		        mail.setSenderDisplayName(currentUser.Name);        
		        mail.setSubject('Notification of Pending Admission - ' + facility);        
		        mail.setPlainTextBody('Case #' + ParentCase.CaseNumber + ':\r\n This case has entered the pre-admission status and has been assigned to the A&P Placement Queue ' + u.State + ' for review.');
		        mail.setHtmlBody('Case #'  + ParentCase.CaseNumber + ':<br/>The pre-admission phase of <a href="https://na11.salesforce.com/' + ParentCase.Id + '">' + ParentCase.Account.Name + '</a> has started. <br />');        
		        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		                 
		    }
		    
            return null;            
        }
        else
        	return null;
    }
    else
    {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Client Information failed validation or already submitted. Please review data and try again.'));
        return null;        
    }        
}



public AdmissionWorkflowController(ApexPages.StandardController controller) {
    this.ParentCase = [SELECT Id,CaseNumber,Admission_Guidelines_Override__c,Admission_Guidelines_Overridden_By__c,Admission_Guidelines_Overridden_On__c,Account.Name,Account.Id,Detox_Location__c,Status,Funding_Type__c,Employment_Status__c,Treatment_Facility_Lookup__r.Name,Treatment_Facility__c,Employer_Name__c,Substance_1__c,X1st_Policy_Company__c,FitRx_Candidate__c,Transportation_Approved__c,Payment_Arrangements_Approved__c,Assessment_Approved_By__c,CreatedById, OwnerId FROM Case WHERE Id = :controller.getRecord().Id];
    this.AssessmentValidationError = '';
    this.InsuranceValidationError = '';
    this.NeedsOverride = false;
    
    try
    {
    	List<Assessment__c> assessments = [SELECT Id, assessment_datetime__c, Assessment_Status__c, CreatedDate FROM Assessment__c WHERE Case__c = :controller.getRecord().Id ORDER BY assessment_datetime__c desc]; 
    	if(assessments.size() > 0)
    	{
    		this.MostRecentAssessment = assessments[0];	
    	}
    	if(this.MostRecentAssessment == null)
    	{
    		this.AssessmentValidationError += 'There are no completed assessments with a populated Assessment Date/Time value for this Case. <br/>';
    		this.NeedsOverride = true; 
    	}
    	else
    	{
	    	if(this.MostRecentAssessment.assessment_datetime__c < datetime.now().addDays(-3))
	    	{
	    		this.AssessmentValidationError += 'Assessment Date/Time is greater than 3 days old. <br/>';
	    		this.NeedsOverride = true;
	    	}
	    	else
	    	{
	    		//this.AssessmentValidationError += 'No warnings.  Assessment appears to be valid. <br/>';
	    	}
    	}
    }
    catch(Exception e)
    {
    	this.AssessmentValidationError += 'Something is wrong with the Assessment for this case. It does not exist or is invalid. <br/>';
    }
    try
    {
    	List<InsuranceVerificationForm__c> insurances = [SELECT Id, Insurance_Status__c, Case__c, VerificationCompleted__c FROM InsuranceVerificationForm__c WHERE Case__c = :controller.getRecord().Id ORDER BY VerificationCompleted__c desc];
    	if(insurances.size() > 0)
    	{
    		this.MostRecentInsurance = insurances[0];
    	}
    	if(this.MostRecentInsurance == null)
    	{
    		if(ParentCase.Funding_Type__c != 'Private Pay' && ParentCase.Funding_Type__c != 'Scholarship')
    		{
	    		this.InsuranceValidationError += 'There are no completed Insurance Verification Forms with a populated Verification Completed Date/Time value for this case. <br/>';
	    		this.NeedsOverride = true;
    		}
    	}
    	else
    	{
    		if(this.MostRecentInsurance.VerificationCompleted__c < datetime.now().addDays(-30))
    		{
    			this.InsuranceValidationError += 'Insurance Verification Form Verification Completed Date/Time is greater than 30 days old. <br/>';
    			this.NeedsOverride = true;
    		}
    		else
    		{
    			//this.InsuranceValidationError += 'No warnings.  Insurance Verification Form appears to be valid. <br/>';
    		}
    	}   	
    }
    catch(Exception e)
    {
    	this.InsuranceValidationError += 'Something is wrong with the Insurance Verification Form.  It does not exist or is invalid. <br/>';	
    }
   
    this.ButtonEnabled = false;
    this.ButtonText = 'Required Fields Missing';
    this.ButtonClass = 'invalid';
    if(ParentCase != null)
    {
        this.TransportationChecked = ParentCase.Transportation_Approved__c;
        this.PaymentChecked = ParentCase.Payment_Arrangements_Approved__c;  
        if(ParentCase.Status == '4- Pending Flight Travel Booking')
        {
            this.ButtonText = 'Complete Admission';
            this.SupervisorButtonText = 'Approve Admission';        
            this.ButtonClass = 'valid';
            this.ButtonEnabled = true;    
        }
        else
        {
            this.ButtonText = 'Disabled';        
            this.ButtonEnabled = false;            
        }
    }
}

}