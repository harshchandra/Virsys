public class TransportationWorkflowController
{
public Case ParentCase{get;set;}
  
  public TransportationWorkflowController(ApexPages.StandardController controller)
  {
    ParentCase = [SELECT Id,Account.Name,Account.Id,Detox_Location__c,CaseNumber,Treatment_Facility__c,Transportation_Status__c,Type_of_Travel__c,Date_and_Time_of_client_s_arrival__c FROM Case WHERE Id = :controller.getRecord().Id];
    try
    {
      TransportationRecord = [SELECT Id FROM Transportation__c WHERE Case__c = :controller.getRecord().Id];
    }
    catch(Exception ex)
    {
      TransportationRecord = null;
    }
  }

public Transportation__c TransportationRecord
  {
    get;
    set;
  }

  public String ButtonText
  {
    get
    {
      if(ParentCase != null && ParentCase.Transportation_Status__c == null && TransportationRecord == null)
        return 'Request Transportation';
      else if(ParentCase != null && ParentCase.Transportation_Status__c != null && ParentCase.Type_of_Travel__c != 'Drive in' && TransportationRecord != null)
        return 'Update Transportation';
      else if(ParentCase.Type_of_Travel__c == 'Drive in')
        return 'Transportation Unavailable';
      else     
        return 'Request Transportation';       
    }
    set;
  }
  
  public PageReference ButtonAction()
  {
    if(ParentCase != null)
    {
        try
        {
          TransportationRecord = [SELECT Id,Case__c FROM Transportation__c WHERE Case__c = :ParentCase.Id];
          
        }
        catch(Exception ex)
        {
          TransportationRecord = null;
        }
        
        
        //Group queue = null;
        if(TransportationRecord == null)
        {
          ParentCase.Transportation_Status__c = 'Requested';
          update ParentCase;
          
          TransportationRecord = new Transportation__c();   
          TransportationRecord.Case__c = ParentCase.Id;
       
          TransportationRecord.Transportation_Status__c = 'Requested';      
          insert TransportationRecord;
          
          TransportationRecord = [select Id,Case__c,Date_Time_of_Client_s_Arrival__c FROM Transportation__c WHERE Id = :TransportationRecord.Id];
          string destination = ParentCase.Treatment_Facility__c;
          
          if(destination == 'Anaheim (contracted)')
            destination = 'Forterus';
          else if(destination == null)
            destination = 'All Facilities';
          
          
           //queue = [SELECT Id,Name,Type,Email FROM Group WHERE Type = 'Queue' AND Name LIKE :('Transportation%' + destination)];      
           //User currentUser = [select Id, Name, Email from User where Id=:UserInfo.getUserId()];
           
           //disabled and converted into templates
           //SendNewTransportationEmail(queue, currentUser, destination);
         
        }
        else
        {  
         //queue = [SELECT Id,Name,Type,Email FROM Group WHERE Type = 'Queue' AND Name LIKE :('Transportation%' + ParentCase.Treatment_Facility__c)];
         TransportationRecord.Transportation_Status__c = 'Updated';      
        }
        //TransportationRecord.OwnerId = queue.Id;
        update TransportationRecord;
    }
    return null;
  }
  
  public void SendNewTransportationEmail(Group queue, User currentUser, String destination)
  {

        
        Messaging.reserveSingleEmailCapacity(1);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] { queue.Email });
        mail.setCCAddresses(new String[] {'boverlund@contactaac.com','jgagnon@contactaac.com'});
        mail.setReplyTo(currentUser.Email);
        mail.setSenderDisplayName(currentUser.Name);
        mail.setSubject('New Transportation Request-' + destination);
        mail.setPlainTextBody('A new request for ground transportation has been requested for https://na11.salesorce.com/' + TransportationRecord.Id + ' (' + ParentCase.Account.Name + '). \r\nDate and Time of Client\'s pick up is: ' + TransportationRecord.Date_Time_of_Client_s_Arrival__c);
        mail.setHtmlBody(
            'A new request for ground transportation has been requested for <a href="https://na11.salesforce.com/' + TransportationRecord.Id + '">' + ParentCase.Account.Name + '</a><br />' +
            'Date and Time of client\'s pick-up is: ' + TransportationRecord.Date_Time_of_Client_s_Arrival__c
          );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });    
  }
}