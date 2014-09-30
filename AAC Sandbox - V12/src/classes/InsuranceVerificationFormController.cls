public class InsuranceVerificationFormController
{
  public Case ParentCase
  {
    get;
    set;
  }
  
  public InsuranceVerificationForm__c Form
  {
    get;
    set;
  }
  
  public Map<String, String> FieldLabels
  {
    get;
    set;
  }
  
  public Map<String, String> FieldHelpText
  {
    get;
    set;
  }

  public decimal ifnull(decimal num)
  {
    if (num == null) num = 0;
        return num;
  }
  
  public boolean ShowTakeButton
  {
    get
    {
      if(Form != null)
      {
        if(Form.OwnerId != UserInfo.getUserId())
          return true;
        else
          return false;
      }
      else
       return false;
    }   
  }
  public boolean ShowSubmitForApprovalButton
  {
        get
        {
                if(Form.Insurance_Status__c != 'Submitted for Approval')
                        return true;
                else
                        return false;
        }
  }
  public boolean ShowResubmitButton
  {
    get
    {
        if(Form.Insurance_Status__c == 'Returned to TC')
            return true;
        else
            return false;
    }
  }
  public boolean Over65 {get;set;}
  public boolean Over26 {get;set;}
  
  public InsuranceVerificationFormController(ApexPages.StandardController controller)
  {
    Form = (InsuranceVerificationForm__c)controller.getRecord();
    List<Case> lstCase = [SELECT Id,
                        Status,
                        Account.Name,
                        Account.FirstName,
                        Account.LastName,
                        Account.IsPersonAccount,
                        Contact_SSN__c,
                        Contacts_DOB__c,
                        Contact_Address__c,
                        Contact.Phone,
                        Benefit_Type__c,
                        CreatedByid,
                        CaseNumber,
                        Insurance_Status__c,
                        X2nd_Insurance_Status__c,
                        Age__c,
                        OwnerId
                        FROM Case WHERE Id = :Form.Case__c];
    if(lstCase != null && lstCase.size() > 0)
    	ParentCase = lstCase[0]; 
            
    if(ParentCase == null)
    {
        try
        {
                string caseNumber = ApexPages.currentPage().getParameters().get('CF00NG0000009XXbK');
                ParentCase = [SELECT Id,
                                    Status,
                                    Account.Name, 
                                    Account.FirstName,
                                    Account.LastName,
                                    Account.IsPersonAccount,
                                    Contact_SSN__c,
                                    Contacts_DOB__c,
                                    Contact_Address__c,
                                    Contact.Phone,
                                    Benefit_Type__c,
                                    CreatedByid,
                                    CaseNumber,
                                    Insurance_Status__c,
                                    X2nd_Insurance_Status__c,
                                    Age__c, 
                                    OwnerId
                                    FROM Case WHERE CaseNumber = :caseNumber];
        }
        catch(Exception e)
        {
                ParentCase = null;
        }
    }
    FieldLabels = new Map<String, String>();
    FieldHelpText = new Map<String, String>();
    
    Map<String, Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();  
    Schema.sObjectType objType = globalDescription.get('InsuranceVerificationForm__c');  

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
    
    if(ParentCase != null && ParentCase.Age__c != null && ParentCase.Age__c != '')
    { 
        decimal age = decimal.valueOf(ParentCase.Age__c);
        if(age != null && age > 0)
        { 
                if(age >= 65)
                { 
                        Over65 = true;
                }
                else
                {
                        Over65 = false;
                }
                if(age >= 26 && age <= 64)
                {
                        if(Form.InsuredRelationshipToClient__c == 'Child')
                                Over26 = true;
                        else
                                Over26 = false;
                }
                else
                {
                        Over26 = false;
                }
        }
    }
    
      
  }
  
  private void UpdateInsurance(InsuranceVerificationForm__c form, boolean addToQueue)
  {
    //make sure we have the latest version of a clients name every save
    form.ClientName__c = ParentCase.Account.Name;        
    form.Insurance_Status__c = 'Resubmitted';
    if(addToQueue)
    {
      // Look up the current users state and assign it to the queue again for re-verification for that state/region       
      User currentUser = [SELECT Id,Name, State, Email FROM User WHERE Id = :UserInfo.getUserId()];
      Group queue = [SELECT Id, Name, Email, Type FROM Group WHERE Type = 'Queue' AND Name LIKE :('Insurance Verifications%' + currentUser.State)];
      form.OwnerId = queue.Id;
      upsert form;     
    }
    else       
      upsert form;    // Update the object
    
    //bind the object to the case
    If(form.IsSecondaryInsurance__c == false)
    {
     ParentCase.Primary_Insurance_Form__c = form.Id;
     ParentCase.Benefit_Type__c = form.Benefit_Type__c;
    }
    else
    {
     ParentCase.Secondary_Insurance_Form__c = form.Id;
     ParentCase.Benefit_Type__c = form.Benefit_Type__c;
    }
    
    update ParentCase;  
  }
  public PageReference Take()  
  {
    if(Form != null)
    {
      Form.OwnerId = UserInfo.getUserId();
      Form.Insurance_Status__c = 'In-progress';
      upsert form;
    
      if(ParentCase != null)
      {
        if(Form.IsSecondaryInsurance__c == false)
            ParentCase.Insurance_Status__c = 'In-progress';
        else
            ParentCase.X2nd_Insurance_Status__c = 'In-Progress';
            
        ParentCase.Benefit_Type__c = Form.Benefit_Type__c;    
        update ParentCase;       
      }      
    }
    
    return null;
  }
  
  
  
  public PageReference Resubmit()
  {
        if(Form.IsSecondaryInsurance__c == true)
        {
            if(ParentCase.X2nd_Insurance_Status__c == 'Returned to TC')
            {
                ParentCase.X2nd_Insurance_Status__c = 'Resubmitted';
                UpdateInsurance(Form,true); 
            }
        }
        else
        {
            if(ParentCase.Insurance_Status__c == 'Returned to TC')
            {
                ParentCase.Insurance_Status__c = 'Resubmitted';
                UpdateInsurance(Form,true);
            }
        }
        
        
        
        return Redirect();
  }
  
  public PageReference Save() 
  {
  	try{
    //Per Meeting 3/19/13 SAVE only saves and activates workflow if Verified.  
    //If you want to submit for approval you use the Submit for Approval button
    system.debug('=================IN==========');
    if(Form.VerificationComplete__c)
    {
      Form.Insurance_Status__c = 'Verified';
      //dont want to overwrite the original date of verification every time, make them do it manually after first time    
      if(Form.VerificationCompleted__c == null)    
        Form.VerificationCompleted__c = datetime.now();
      
      //only change the overall case status, per jessica g., if it is less than 2.
      if(ParentCase.Status == 'Case Opened' | Parentcase.Status == '1- Pending Verification of Benefits')    
        ParentCase.Status = '2- Pending Completion of Assessment';

      if(Form.IsSecondaryInsurance__c == true)
      {
        ParentCase.X2nd_Summary_of_Benefits__c = Form.SummaryOfBenefits__c;
        ParentCase.X2nd_Insurance_Status__c = 'Verified';
        ParentCase.Secondary_Insurance_Form__c = Form.Id;
      }
      else
      {
          ParentCase.Insurance_Summary_of_Benefits__c = Form.SummaryOfBenefits__c;
          ParentCase.Insurance_Status__c = 'Verified';
          ParentCase.Primary_Insurance_Form__c = Form.Id;               
      }
      
      ParentCase.Benefit_Type__c = Form.Benefit_Type__c;
      GeneratePDF();
      system.debug('=================ParentCase=========='+ParentCase);
      update ParentCase;      
    }
    else
    {
        //Per Kris Munro 9/3 if the status is Submitted for Approval it has to stay that way until it is approved or rejected.
        if(Form.Insurance_Status__c != 'Submitted for Approval' && Form.Insurance_Status__c != 'Verified' && Form.Online_Verification__c != true)
                Form.Insurance_Status__c = 'Pending Submit';
    }
    system.debug('=================Form=========='+Form);
    upsert Form;
    
    if(ParentCase != null)
    {
        Form.ClientName__c = ParentCase.Account.Name;
        if(Form.IsSecondaryInsurance__c == false)
            ParentCase.Primary_Insurance_Form__c = Form.Id;
        else
            ParentCase.Secondary_Insurance_Form__c = Form.Id;
                
        update ParentCase;
    }
        
   
    return Redirect();
  	}
  	catch(Exception e)
  	{
  		system.debug('=================e=========='+e);
  		return null;
  	}
  }
  public void GeneratePDF()
  {
    PageReference pdf = Page.InsuranceViewer;
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
  public PageReference SubmitForApproval()
  {
        if(ParentCase != null)
        {
        Form.ClientName__c = ParentCase.Account.Name;
        if(Form.IsSecondaryInsurance__c == false)
                ParentCase.Primary_Insurance_Form__c = Form.Id;
        else
                ParentCase.Secondary_Insurance_Form__c = Form.Id;
                
        update ParentCase;
        }
        
        //Look up the current users state and assign it to the queue verification for that state/region       
        User currentUser = [SELECT Id,Name, State, Email FROM User WHERE Id = :UserInfo.getUserId()];
        Group queue = [SELECT Id, Name, Email, Type FROM Group WHERE Type = 'Queue' AND Name LIKE :('Insurance Verifications%' + currentUser.State)];
        Form.OwnerId = queue.Id;
        
        Form.Insurance_Status__c = 'Submitted for Approval';
        
        upsert Form;
        
        return Redirect();
  }
  public PageReference Cancel() 
  {
    return Redirect();
  }
  
  public PageReference ReturnToTC()
  {
    Form.VerificationCompleted__c = null;
    Form.VerificationComplete__c = false;
    Form.Insurance_Status__c = 'Returned to TC';
    Form.Returned_To_TC__c = true;
    Form.Rejected_To__c = Form.CreatedById;
    update Form;
    
    if(Form.IsSecondaryInsurance__c == false)
        ParentCase.Insurance_Status__c = 'Returned to TC';
    else
        ParentCase.X2nd_Insurance_Status__c = 'Returned to TC';

        ParentCase.Benefit_Type__c = Form.Benefit_Type__c;        
    update ParentCase;
    
    return Redirect();
  }
  
  private PageReference Redirect()
  {
    PageReference page = null;     
    if(ApexPages.currentPage().getParameters().get('fromQueue') == '1' || ParentCase == null)       
      page = new PageReference('/a0K/o');     
    else       
      page = new PageReference('/' + ParentCase.Id);            
      
    page.setRedirect(true);     
    return page;   
  }
  
    
  public PageReference ViewCalculator()
  {
    if(Form != null)
    {
        Client_Calculator__c Calc = null;
        try
        {
            //go to it if we find one
            Calc = [select Id from Client_Calculator__c WHERE Insurance_Verification_Form__c = :Form.Id];
        }
        catch(Exception e)
        {
            //create one if we dont find one
            Calc = new Client_Calculator__c();
            Calc.Insurance_Verification_Form__c = Form.id;
            Calc.Case__c = Form.Case__c;
            
            Calc.Plan_Maximum__c = ifnull(Form.Plan_Maximum__c);
            
            Calc.DTX_Rate__c = 0; //ifnull(Form.SubstanceAbuseDTXCopay__c);
            //Calc.DTX_Days__c = 0;
            Calc.DTX_Co_Ins__c = ifnull(Form.SubstanceAbuseDTXPercentage__c);
            Calc.DTX_Subtotal__c = 0;
            Calc.DTX_Client_Portion__c = 0;
            
            Calc.IOP_Rate__c = 0;// ifnull(Form.SubstanceAbuseIOPCopay__c);
            Calc.IOP_Days__c = 0;
            Calc.IOP_Co_Ins__c = ifnull(Form.SubstanceAbuseIOPPercentage__c);
            Calc.IOP_Subtotal__c = 0;
            Calc.IOP_Client_Portion__c = 0;
            
            Calc.IP_RTC_Rate__c = 0;//ifnull(Form.SubstanceAbuseIPCopay__c);
            Calc.IP_RTC_Days__c = 0;
            Calc.IP_RTC_Co_Ins__c = ifnull(Form.SubstanceAbuseIPPercentage__c);
            Calc.IP_RTC_Subtotal__c = 0;
            Calc.IP_RTC_Client_Portion__c = 0;
            
            Calc.OP_Rate__c = 0;//ifnull(Form.SubstanceAbuseOPCopay__c);
            Calc.OP_Days__c = 0;
            Calc.OP_Co_Ins__c = ifnull(Form.SubstanceAbuseOPPercentage__c);
            Calc.OP_Subtotal__c = 0;
            Calc.OP_Client_Portion__c = 0;
            
            Calc.PHP_Rate__c = 0;//ifnull(Form.SubstanceAbusePHPCopay__c);
            Calc.PHP_Days__c = 0;
            Calc.PHP_Co_Ins__c = ifnull(Form.SubstanceAbusePHPPercentage__c);
            Calc.PHP_Subtotal__c = 0;
            Calc.PHP_Client_Portion__c = 0;
            
            Calc.RES_Rate__c = 0;// ifnull(Form.SubstanceAbuseRESCopay__c);
            Calc.RES_Days__c = 0;
            Calc.RES_Co_Ins__c = ifnull(Form.SubstanceAbuseRESPercentage__c);
            Calc.RES_Subtotal__c = 0;
            Calc.RES_Client_Portion__c = 0;
            
            Calc.Total_Client_Contribution__c = 0;
            Calc.Grand_Total__c = 0;
            
            Calc.Client_Deductible__c = ifnull(Form.SubstanceAbuseBenefitsCopay__c);
            Calc.Deductible_Met__c = ifnull(Form.SubstanceAbuseBenefitsCopayMet__c);
            Calc.Lifetime_Maximum__c = ifnull(Form.SubstanceAbuseDTXLifetimeMax__c);
            Calc.Out_of_Pocket_Maximum__c = ifnull(Form.SubstanceAbuseBenefitsOutOfPocket__c);
            Calc.Out_of_Pocket_Met__c = ifnull(Form.SubstanceAbuseBenefitsOutOfPocketMet__c);
            //per Johana we use the DTX Max for all
            Calc.Lifetime_Maximum__c = ifnull(Form.SubstanceAbuseDTXLifetimeMax__c);
            
            Calc.Non_covered_Ancillary__c = 0;
            Calc.Total_Client_Contribution__c = 0;
            Calc.Estimated_Insurance_Dollars_Received__c = 0;
            Calc.Daily_Net_Revenue__c = 0;
            Calc.Total_Client_Portion__c = 0;
            Calc.CoPays__c = ifnull(Form.SubstanceAbuseIPCopay__c);
            insert calc;
        }
        PageReference pRef = new PageReference('/apex/pages/ClientCalculator?id=' + calc.Id + '&retURL=/apex/pages/InsuranceVerificationForm?id=' + Form.Id);
        return pRef.setRedirect(true);
    }
    else
    {
        return null;
    }
  }
  
  
}