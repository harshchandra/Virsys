public class InsuranceVerificationWorkflowController
{
  private final Case ParentCase;
  private final Account ParentAccount;
  private InsuranceVerificationForm__c PrimaryForm;
  //private InsuranceVerificationForm__c SecondaryForm;
  
  public InsuranceVerificationWorkflowController(ApexPages.StandardController controller)
  {
    ParentCase = [
      SELECT 
        Id,
        CaseNumber,
        Status,
        Insurance_Status__c,
        Contact_SSN__c,
        Contacts_DOB__c,
        Account.Name,
        Account.FirstName,
        Account.LastName,
        Account.BillingStreet,
        Account.BillingCity,
        Account.BillingState,
        Account.BillingPostalCode,
        Account.Phone
      FROM 
        Case 
      WHERE 
        Id = :controller.getRecord().Id
    ];
    ParentAccount = ParentCase.Account;
    
    try
    {
      PrimaryForm = [select Id,IsSecondaryInsurance__c FROM InsuranceVerificationForm__c WHERE Case__c = :ParentCase.Id AND IsSecondaryInsurance__c = false ORDER BY CREATEDDATE DESC LIMIT 1];
    }
    catch(Exception ex)
    {
      PrimaryForm = null;
    }
    
    //try
    //{
    //  SecondaryForm = [SELECT Id,IsSecondaryInsurance__c FROM InsuranceVerificationForm__c WHERE Case__c = :ParentCase.Id AND IsSecondaryInsurance__c = true];
    //}
    //catch(Exception ex)
    //{
    //  SecondaryForm = null;
    //}
  }

  public Boolean ShowSubmit
  {
    get
    {
      return PrimaryForm == null || (PrimaryForm != null && ParentCase.Insurance_Status__c == 'Returned to TC');
    }
  }

  public Boolean ShowView
  {
    get
    {
      return PrimaryForm != null && ParentCase.Insurance_Status__c != 'Returned to TC';
    }
  }

  public String PrimaryFormUrl
  {
    get
    {
      if(PrimaryForm != null)
        return '/apex/pages/InsuranceVerificationForm?id=' + PrimaryForm.Id;
      else
        return '';
    }
  }
  
  //public String SecondaryFormUrl
  //{
  //  get
  //  {
  //    if(SecondaryForm != null)
  //      return '/apex/pages/InsuranceVerificationForm?id=' + SecondaryForm.Id;
  //    else
  //      return '';
  //  }
  //}
  
  public String ButtonText
  {
    get
    {
      if(ParentCase.Insurance_Status__c == null)
        return 'Submit Insurance';
        
      if(PrimaryForm != null && ParentCase.Insurance_Status__c == 'Returned to TC')
        return 'Resubmit Insurance';
      else if(PrimaryForm != null)
        return 'View Insurance';
      else
        return 'Submit Insurance';
    }
  }

  private void UpdateInsurance(InsuranceVerificationForm__c form, boolean addToQueue)
  {
    form.ClientName__c = ParentAccount.Name;        
        
    form.ClientSocialSecurityNumber__c = ParentCase.Contact_SSN__c;
    form.ClientDateOfBirth__c = ParentCase.Contacts_DOB__c;
    form.ClientAddressCountry__c = 'United States';
    form.ClientAddressLine1__c = ParentAccount.BillingStreet;
    form.ClientAddressCity__c = ParentAccount.BillingCity;
    form.ClientAddressState__c = ParentAccount.BillingState;
    form.ClientAddressZipCode__c = ParentAccount.BillingPostalCode;
    form.ClientPhoneNumber__c = ParentAccount.Phone; 
        
    if(form.IsSecondaryInsurance__c == false)
    { // Update Primary Insurance
      form.InsuredName__c = ParentCase.X1st_Policy_Primary_Insured_Name__c;
      form.InsuredEmployer__c = ParentCase.X1st_Policy_Primary_Employer__c;
      form.InsuredDateOfBirth__c = ParentCase.X1st_Policy_Primary_Insured_Date_of_Birt__c;
      form.InsuredEmployerPhoneNumber__c = ParentCase.X1_Policy_Primary_Employer_Phone_Number__c;
      form.InsuredPhoneNumber__c = ParentCase.X1st_Policy_Primary_Insured_Phone_Number__c;
      form.InsuredRelationshipToClient__c = ParentCase.Primary_Insured_Relationship_to_Client__c;
      form.InsuranceCompany__c = ParentCase.X1st_Policy_Company__c;
      form.TypeOfPlan__c = ParentCase.X1st_Policy_Insurance_Type__c;
      form.InsuranceGroupNumber__c = ParentCase.X1st_Policy_Group__c;
      form.InsuranceID__c = ParentCase.X1st_Policy_ID__c;
      form.InsurancePhoneNumber__c = ParentCase.X1st_Policy_Customer_Service_Phone_Numbe__c;
      form.InsuredSocialSecurityNumber__c = ParentCase.X1_Policy_Primary_Insured_SS__c; 
    }
    //else 
    //{ // Update Secondary Insurance
    //  form.InsuredName__c = ParentCase.X2nd_Policy_Primary_Insured_Name__c;
    //  form.InsuredEmployer__c = ParentCase.X2nd_Policy_Primary_Employer__c;
    //  form.InsuredDateOfBirth__c = ParentCase.X2nd_Policy_Primary_Insured_Date_of_Birt__c;
    //  form.InsuredPhoneNumber__c = ParentCase.X2nd_Policy_Primary_Insured_Phone_Number__c;
    //  form.InsuredRelationshipToClient__c = ParentCase.X2_Primary_Insured_Relationship_to_Clien__c;
    //  form.InsuranceCompany__c = ParentCase.X2nd_Policy_Company__c;
    //  form.TypeOfPlan__c = ParentCase.X2nd_Policy_Insurance_Type__c;
    //  form.InsuranceGroupNumber__c = ParentCase.X2nd_Policy_Group__c;
    //  form.InsuranceID__c = ParentCase.X2nd_Policy_ID__c;
    //  form.PrecertificationCompanyPhoneNumber__c = ParentCase.X2nd_Policy_Customer_Service_Phone_Numbe__c;
    //}  
    
    if(addToQueue)
    {
      // Look up the current users state and assign it to the queue again for re-verification for that state/region       
      User currentUser = [SELECT Id,Name, State, Email FROM User WHERE Id = :UserInfo.getUserId()];
      Group queue = [SELECT Id, Name, Email, Type FROM Group WHERE Type = 'Queue' AND Name LIKE :('Insurance Verifications%' + currentUser.State)];
      form.OwnerId = queue.Id;
      upsert form;
      
      //moved to Email Templates to fix limit issues
      //SendCreatedEmail(currentUser, queue);
    }
    else       
      upsert form;    // Update the object
 
    
    
    //bind the object to the case
    If(form.IsSecondaryInsurance__c == false)
     ParentCase.Primary_Insurance_Form__c = form.Id;
    //else
    // ParentCase.Secondary_Insurance_Form__c = form.Id;
    
    update ParentCase;  
  }

/*
public void SendCreatedEmail(User u, Group g)
{
    Messaging.reserveSingleEmailCapacity(1);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    // Strings to hold the email addresses to which you are sending the email.
    String[] toAddresses = new String[] {g.Email}; 
    String[] ccAddresses = new String[] {'boverlund@contactaac.com','jgagnon@contactaac.com'};
    // Assign the addresses for the To and CC lists to the mail object.
    mail.setToAddresses(toAddresses);
    mail.setCcAddresses(ccAddresses);
    // Specify the address used when the recipients reply to the email. 
    mail.setReplyTo(u.Email);
    // Specify the name used as the display name.
    mail.setSenderDisplayName(u.Name);
    // Specify the subject line for your email address.
    mail.setSubject(ParentCase.CaseNumber + ' Insurance Verification - SUBMITTED');
    // Set to True if you want to BCC yourself on the email.
    mail.setBccSender(false);
    // Optionally append the salesforce.com email signature to the email.// The email address of the user executing the Apex Code will be used.
    mail.setUseSignature(true);
    // Specify the text content of the email.
    mail.setPlainTextBody('A new Insurance Verification Form has entered your queue: ' + ParentCase.CaseNumber +' has been updated.  The Insurance Status is now Submitted.\r\nTo view the case: https://na11.salesforce.com/' + ParentCase.Id + ' \r\nTo View the Insurance Form: https://na11.salesforce.com/apex/pages/InsuranceVerificationForm?Id=' + PrimaryForm.Id);
    mail.setHtmlBody('A new Insurance Verification Form has entered your queue:<b> ' + ParentCase.CaseNumber +' </b>has been updated.  The Insurance Status is now <b>SUBMITTED</b><p>'+
            'To view the case <a href=https://na11.salesforce.com/'+ ParentCase.Id + '>click here.</a><br/>To view the insurance form <a href=https://na11.salesforce.com/apex/pages/InsuranceVerificationForm?id=' + PrimaryForm.Id + '>click here</a>');
    // Send the email you have created.
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
*/
  public PageReference SubmitInsurance()
  {
    if(ParentCase.Insurance_Status__c == null || ParentCase.Insurance_Status__c == 'Submitted' || ParentCase.Insurance_Status__c == 'Returned to TC')
    {    
      if(PrimaryForm != null)
      {
        // We have a form already, so make sure we are not doing something we shouldnt be
        if(ParentCase.Insurance_Status__c == 'Returned to TC')
        {
        // used to be: (ParentCase.Status == '1- Pending Verification of Benefits' || ParentCase.Status == '2- Pending Completion of Assessment') && 
          // We are still waiting on benefits to be finalized.  Doing an update here because it was sent back
          ParentCase.Insurance_Status__c = 'Resubmitted';                
          update ParentCase;
         
          // They are using the update button so update the values from the case into the insurance form
          UpdateInsurance(PrimaryForm, true);
        }
      }
      else
      {
        // We dont have a form yet, so create one
        // Create the new Insurance form
        PrimaryForm = new InsuranceVerificationForm__c();
        PrimaryForm.Case__c = ParentCase.Id;

        ParentCase.Status = '1- Pending Verification of Benefits';
        ParentCase.Insurance_Status__c = 'Submitted';
        update ParentCase;
         
        // Update the form values from case
        UpdateInsurance(PrimaryForm, true);
      }     
    }
    
    return null;
  }
}