public class AssessmentWorkflowController {
public Case ParentCase{get;set;}
public string ButtonClass{get;set;}
public string ButtonText{get;set;}
//Button text on supervisor only button
public string SupervisorButtonText{get;set;}
public boolean ButtonEnabled{get;set;}

//panel showing "Assessment Approved" with no options
public boolean ShowAssessmentApprovedPanel
{
get
{
    if(ParentCase.Assessment_Approved_By__c != null)
    {
        return true;
    }
    else
    {
        return false;
    }
}
set;
}
public boolean ShowSupervisorPanel
{
    get
    {   
    User u = [select Id,Name,ProfileId from User where Id = :UserInfo.getUserId()];
    boolean valid = false;    
    List<Profile> p = [select Id,Name FROM Profile WHERE Name IN ('AAC-Inside Sales Manager','System Administrator')];    
    if(p.size() > 0)
    {
     for(integer i = 0; i<p.size(); i++)
      {
       if(p[i].Id == u.ProfileId)
           valid = true;         
      }      
    }
    //see if they are in the verifier TN group
	List<GroupMember> gm = [select groupid, id, userorgroupid from groupmember where groupid = '00GG0000002tflLMAQ'];
	{
		if(gm.size() >0)
		{
			for(integer i =0; i < gm.size(); i++)
			{
				if(gm[i].UserOrGroupId == u.Id)
				{
					valid = true;
				}
			}
		}
	}
	
    return valid;
     
    }
}
public boolean ShowApprovalOptions
{
get
{
     if(ParentCase.Status == '3- Pending Assessment Review & Approval')
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
    if(ParentCase.Status == '3- Pending Assessment Review & Approval')
        return true;
    else
        return false;
    }
}

public boolean FormValidated
{
get
{

//start out false
boolean valid = false;

//if they are private pay, we dont have to check insurance
if(ParentCase.Funding_Type__c == 'Private Pay')
{
    valid = true;
}
else
{
    //client is not private pay, see if insurance is filled out
    if(ParentCase.X1st_Policy_Company__c != null)
        valid = true; 
}

//check Employment Data
if(ParentCase.Employment_Status__c == 'Employed')
{
    //client is employed, make sure reps received employer name
    if(ParentCase.Employer_Name__c != null)
        valid = true;   
}

//Check on FitRx status, they dont use substances, but if its
//not a FitRx client then we need to capture at least one of these substance blocks
if((ParentCase.FitRx_Candidate__c == 'No' || ParentCase.FitRx_Candidate__c == null) && ParentCase.Substance_1__c != null)
{
    valid = true;
}
else if(ParentCase.FitRx_Candidate__c == 'Yes')
{
    if(ParentCase.Funding_Type__c =='Private Pay')
    {
        valid = true; 
    }   
    else
    {
        if(ParentCase.X1st_Policy_Company__c != null)
             valid = true;   
    }  
}
return valid;
}
}


public AssessmentWorkflowController(ApexPages.StandardController controller) 
{
    this.ParentCase = [SELECT Id,CaseNumber,Account.Name,Account.Id,Status,Funding_Type__c,Employment_Status__c,Employer_Name__c,Substance_1__c,X1st_Policy_Company__c,FitRx_Candidate__c,Transportation_Approved__c,Payment_Arrangements_Approved__c,Assessment_Approved_By__c,CreatedById, OwnerId FROM Case WHERE Id = :controller.getRecord().Id];
    this.ButtonEnabled = false;
    this.ButtonText = 'Required Fields Missing';
    this.ButtonClass = 'invalid';
    
    if(FormValidated && (ParentCase.Status == 'Case Opened' || ParentCase.Status == '1- Pending Verification of Benefits' || ParentCase.Status == '2- Pending Completion of Assessment'))
     {
        this.ButtonText = 'Submit Assessment';
        this.SupervisorButtonText = 'Approve Assessment';        
        this.ButtonClass = 'valid';
        this.ButtonEnabled = true;    
     }
    else if(FormValidated)
      {
        //should only get here if its valid, but not in one of 3 accepted status types      
        this.ButtonText = 'Assessment Submitted';
        this.ButtonEnabled = false;             
        this.ButtonClass = 'invalid';        
        this.SupervisorButtonText = 'Approve Assessment';        
      }
     else
     {
     	this.ButtonText = 'Required Fields Missing';
     	this.ButtonEnabled = false;
     }           
}

public PageReference SupervisorButtonAction()
{
if(ParentCase.Status == '3- Pending Assessment Review & Approval')
{
    ParentCase.Status = '4- Pending Flight Travel Booking';
    ParentCase.OwnerId = ParentCase.CreatedById;
    ParentCase.Assessment_Approved_By__c = UserInfo.getUserId();
    update ParentCase;
	
	//We are now managing these through workflow rules to help with limits
	//SendApprovedEmail();
    
    return null; 
}
else
    return null;
}
public void SendApprovedEmail()
{
	//User newUser = [SELECT Id,Name,Email FROM User WHERE Id=:ParentCase.OwnerId];
	//#TODO: Upgrade this to be a task in 2014
	Map<Id, Group> groups = new Map<Id, Group>([SELECT Id, Name FROM Group]);
	if(!groups.containsKey(ParentCase.OwnerId))
	{
		Task task = new Task();
	  task.WhatId = ParentCase.Id;
	  task.OwnerId = ParentCase.OwnerId;
	  task.Subject = 'Assessment Approved For Case: ' + ParentCase.CaseNumber;
	  task.Status = 'Not Started';
	  task.Description = 'This is an automatically generated task created in place of an email notification.';
	  task.ActivityDate = datetime.now().date();
	  task.Priority = 'Low';
	  task.Type = 'Assessment';
	  task.IsReminderSet = false;
	  insert task;
	}
	/*
	User currentUser = [SELECT Id,Name,Email FROM User WHERE Id = :UserInfo.getUserId()];
  
    
    
	Messaging.reserveSingleEmailCapacity(1);               
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();        
	mail.setToAddresses(new String[] { newUser.Email });
	mail.setCcAddresses(new String[] {'boverlund@contactaac.com','jgagnon@contactaac.com'});        
	mail.setReplyTo(currentUser.Email);        
	mail.setSenderDisplayName(currentUser.Name);        
	mail.setSubject('Notification of Assessment Approved - ' + ParentCase.CaseNumber);        
	mail.setPlainTextBody('Case #' + ParentCase.CaseNumber + ':\r\n Assessment Approved set by ' + currentUser.Name + ' for <a href="https://na11.salesforce.com/' + ParentCase.Id + '">' + ParentCase.Account.Name + '.\r\n It has been placed back in your queue.');
	mail.setHtmlBody('Case #'  + ParentCase.CaseNumber + ':<br/>Assessment Approved set by ' + currentUser.Name + ' for <a href="https://na11.salesforce.com/' + ParentCase.Id + '">' + ParentCase.Account.Name + '</a>. It has been placed back in your queue. <br />');        
	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	*/            
	
}
public void SendSubmittedEmail(User u, Id newID)
{
	//#TODO: Upgrade this to be a task in 2014
	Map<Id, Group> groups = new Map<Id, Group>([SELECT Id, Name FROM Group]);
	if(!groups.containsKey(ParentCase.OwnerId))
	{
			Task task = new Task();
		  task.WhatId = ParentCase.Id;
		  task.OwnerId = ParentCase.OwnerId;
		  task.Subject = 'Assessment Submitted For Case: ' + ParentCase.CaseNumber;
		  task.Status = 'Not Started';
		  task.Description = 'This is an automatically generated task created in place of an email notification.';
		  task.ActivityDate = datetime.now().date();
		  task.Priority = 'Low';
		  task.Type = 'Assessment';
		  task.IsReminderSet = false;
		  insert task;
	}
	/*
	Group g = [SELECT Id,Name,Email FROM Group WHERE Id = :newID];
	
	Messaging.reserveSingleEmailCapacity(1);               
	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	string toAddress = g.Email;
	if(toAddress == null)
		toAddress = 'boverlund@contactaac.com';        
	mail.setToAddresses(new String[] { toAddress });
	mail.setCcAddresses(new String[] {'boverlund@contactaac.com','jgagnon@contactaac.com'});        
	mail.setReplyTo(u.Email);        
	mail.setSenderDisplayName(u.Name);        
	mail.setSubject('Notification of Assessment Submitted - ' + ParentCase.CaseNumber);        
	mail.setPlainTextBody('Case #' + ParentCase.CaseNumber + ':\r\n Assessment Submitted for review by ' + u.Name + ' for https://na11.salesforce.com/' + ParentCase.Id + ' (' + ParentCase.Account.Name + ').\r\n It has been placed in the ' + g.Name + ' queue.');
	mail.setHtmlBody('Case #'  + ParentCase.CaseNumber + ':<br/>Assessment Submitted for review by ' + u.Name + ' for <a href="https://na11.salesforce.com/' + ParentCase.Id + '">' + ParentCase.Account.Name + '</a>. It has been placed in the ' + g.Name + ' queue.');        
	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	*/                     
}
public PageReference ButtonAction()
{
    if(FormValidated && (ParentCase.Status == 'Case Opened' || ParentCase.Status == '1- Pending Verification of Benefits' || ParentCase.Status == '2- Pending Completion of Assessment'))  
    {
        ParentCase.Status = '3- Pending Assessment Review & Approval';
        User u = [select Id,Name,Email,State FROM User WHERE Id = :UserInfo.getUserId()];
        if(u.State != null)
        {
	       	Id newID = QueueID(u.State);
	        if(newID != null)
	        {       
	            ParentCase.OwnerId = newID;
	            update ParentCase;
	            
	            //Disabled to help with limitations
	            //SendSubmittedEmail(u, newID);
	            
	            return null;            
	        }
	        else
	        {
	            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Unable to reassign case because a queue match was not found.'));
	            return null;            
	        }         
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


public Id QueueId(string userState)
{
    List<Group> groups = [SELECT Id,Name,Email,Type FROM Group WHERE Type = 'Queue' AND Name LIKE :('A&P Placement Decision Queue%' + userState)];
    if(groups.size()>0)
    {
      return groups[0].Id;    
    }
    else
     return null;   
}

}