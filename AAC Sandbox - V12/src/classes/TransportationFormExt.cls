public class TransportationFormExt {
        public Transportation__c Transportation {get;set;}
        public Case ParentCase {get;set;}
        public Account ParentAccount {get;set;}        
        public InsuranceVerificationForm__c PrimaryInsuranceForm {get;set;}
        public Assessment__c ParentAssessment {get;set;}        
        public string validationString {get;set;}
        public boolean PreAdmitValid {get;set;}

        public boolean CaseFieldsInvalid {get{ return (CaseFieldsInvalid == null) ? false : CaseFieldsInvalid; } set;}
        public boolean CaseFundingTypeValid {get { return (CaseFundingTypeValid == null) ? true : CaseFundingTypeValid; } set;}
        public boolean CaseGenderValid {get { return(CaseGenderValid == null) ? true : CaseGenderValid;} set;}
        
        
        public boolean AccountFieldsInvalid {get{ return (AccountFieldsInvalid == null) ? false : AccountFieldsInvalid; }set;}
        public boolean AccountNameValid {get { return (AccountNameValid == null) ? true :  AccountNameValid; } set;}
        public boolean AccountDOBValid {get { return (AccountDOBValid == null) ? true : AccountDOBValid;} set;}
        public boolean AccountParentAccountValid {get{ return(AccountParentAccountValid == null) ? true : AccountParentAccountValid;} set;}
        public boolean AccountDemographicsValid{get { return (AccountDemographicsValid == null) ? true : AccountDemographicsValid;} set;}
        public boolean AccountHowDidYouGetOurNumberValid{get { return(AccountHowDidyouGetOurNumberValid == null) ? true : AccountHowDidYouGetOurNumberValid;} set;}
        public boolean AccountHowDidYouHearAboutAACValid{get { return (AccountHowDidYouHearAboutAACValid == null) ? true : AccountHowDidYouHearAboutAACValid; } set;}
        public boolean AccountPhoneValid{get{ return (AccountPhoneValid == null) ? true : AccountPhoneValid;} set;}
        public boolean AccountAddressValid {get{ return (AccountAddressValid == null) ? true : AccountAddressValid; } set;}
        
        
        public boolean HasInsuranceRecord {get; set;}
        public boolean InsuranceVerificationComplete {get;set;}        
        public boolean InsuranceFieldsInvalid {get{ return (InsuranceFieldsInvalid == null) ? false : InsuranceFieldsInvalid;} set;}        
        public boolean InsInsuranceCompanyValid {get{ return (InsInsuranceCompanyValid == null) ? true : InsInsuranceCompanyValid;} set;}
        public boolean InsBenefitTypeValid{get{ return (InsBenefitTypeValid == null) ? true : InsBenefitTypeValid;} set;}
        public boolean InsInsuredRelationshipToClientValid{get { return (InsInsuredRelationshipToClientValid == null) ? true : InsInsuredRelationshiptoClientValid;} set;}
        public boolean InsInsuredNameValid{get{ return (InsInsuredNameValid == null) ? true : InsInsuredNameValid;} set;}
        public boolean InsInsuredEmployerValid{get{ return (InsInsuredEmployerValid == null) ? true : InsInsuredEmployerValid;} set;}
        public boolean InsInsuredDOBValid{get{ return (InsInsuredDOBValid == null) ? true : InsInsuredDOBValid;} set;}
        public boolean InsInsurancePhoneValid{get{ return (InsInsurancePhoneValid == null) ? true : InsInsurancePhoneValid;} set;}
        public boolean InsInsuranceIdValid{get{ return (InsInsuranceIdValid == null) ? true : InsInsuranceIdValid;} set;}
        
        public boolean HasAssessmentRecord{get;set;}
        public boolean AssessmentApproved {get;set;}
        public boolean AssessmentHeightValid {get {return(AssessmentHeightValid == null) ? true : AssessmentHeightValid;} set;}
        public boolean AssessmentWeightValid {get {return(AssessmentWeightValid == null) ? true : AssessmentWeightValid;} set;}               
        public boolean AssessmentAbuseHistoryValid {get {return(AssessmentAbuseHistoryValid == null) ? true : AssessmentAbuseHistoryValid;} set;}               


        public TransportationFormExt(ApexPages.StandardController controller)
        {
                Transportation = (Transportation__c)controller.getRecord();
                ParentCase = [SELECT Id,
                                      CaseNumber,
                                      AccountId,
                                      Funding_Type__c,
                                      Gender__c,
                                      Account.Id,
                                      Account.IsPersonAccount,                                      
                                      Account.FirstName,
                                      Account.LastName,
                                      Account.Date_of_birth__pc,
                                      Account.Demographics__c,
                                      Account.Phone,
                                      Account.BillingStreet,
                                      Account.BillingCity,
                                      Account.BillingState,
                                      Account.BillingPostalCode
                                      FROM Case WHERE Id = :Transportation.Case__c];
           
           														//Account.How_did_caller_get_our_phone_number__c,
                                      //Account.How_did_you_hear_about_ACC_Text__c,
                PreAdmitValid = ValidatePreAdmissionData();
        }
        public PageReference UpdateAccount()
        {
            update ParentAccount;
            PreAdmitValid = ValidatePreAdmissionData();            
            return null;       
        }
        public PageReference UpdateCase()
        {
            update ParentCase;
            PreAdmitValid = ValidatePreAdmissionData();            
            return null;        
        }   
        public PageReference UpdatePrimaryInsurance()
        {
            update PrimaryInsuranceForm;
            PreAdmitValid = ValidatePreAdmissionData();            
            return null;       
        } 
        public boolean ValidatePreAdmissionData()
        {
            boolean valid = true;
            Case myCase = [SELECT Id,
                              CaseNumber,
                              AccountId,
                              Funding_Type__c,
                              Gender__c,
                              Account.Id,
                              Account.IsPersonAccount,
                              Account.FirstName,
                              Account.LastName,
                              Account.Date_of_birth__pc,
                              Account.Demographics__c,
                              Account.How_Did_Caller_Get_Our_Number__c,
                              Account.How_Did_You_Hear_About_AAC__c,
                              Account.Phone,
                              Account.BillingStreet,
                              Account.BillingCity,
                              Account.BillingState,
                              Account.BillingPostalCode
                              FROM Case WHERE Id = :Transportation.Case__c];
    
                              
                        
                        if(myCase.AccountId == null)
                        {
                                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account is not specified.'));
                                valid = false;
                        }
                        if(myCase.AccountId != null)
                        {
                            ParentAccount = [SELECT Id, IsPersonAccount,
                              FirstName,
                              LastName,
                              Date_of_birth__pc,
                              Demographics__c,
                              Phone,
                              How_Did_Caller_Get_Our_Number__c,
                              How_Did_You_Hear_About_AAC__c,
                              How_Did_You_Hear_About_AAC_Description__c,
                              BillingStreet,
                              BillingCity,
                              BillingState,
                              BillingPostalCode FROM Account WHERE Id =:myCase.AccountId];

                      
                            if(ParentAccount.FirstName == null || ParentAccount.LastName == null)
                            {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Name (first and last) is required and needs corrected.'));
                                    AccountNameValid = false;                                    
                                    valid = false;  
                            }
                            if(ParentAccount.Date_of_birth__pc == null)
                            {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Date of Birth is required and needs corrected.'));
                                    AccountDOBValid = false;                                    
                                    valid = false;
                            }
                            if(myCase.Gender__c == null || myCase.Gender__c == '')
                            {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Case Gender is required and needs corrected.'));
                                    CaseGenderValid = false;                                
                                    valid = false;
                            }
                            /*
                            if(ParentAccount.Parent_Account__c == null)
                            {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account is not properly associated with a parent account. '));
                                    AccountParentAccountValid = false;                                    
                                    valid = false;
                            }
                            */
                            if(ParentAccount.Demographics__c == null || ParentAccount.Demographics__c == '')
                            {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Demographics are required and needs corrected.'));
                                    AccountDemographicsValid = false;                                    
                                    valid = false;
                            }
                            if(ParentAccount.How_Did_Caller_Get_Our_Number__c == null)
                            {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account \"How did you hear about us\" questions have not been answered.'));
                                    AccountHowDidYouGetOurNumberValid = false;                      
                                    valid = false;
                            }
                            
                            if(ParentAccount.Phone == null || ParentAccount.Phone == '')
                            {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account phone number is required and needs corrected.'));
                                    AccountPhoneValid = false;                                    
                                    valid = false;
                            }
                            if(ParentAccount.BillingStreet == null || ParentAccount.BillingCity == null || ParentAccount.BillingState == null || ParentAccount.BillingPostalCode == null)
                            {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account Billing Address is required and needs corrected.'));
                                    AccountAddressValid = false;                                    
                                    valid = false;
                            }
                            if(myCase.Funding_Type__c == null)
                            {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Case Funding Type is required and needs corrected.'));
                                    CaseFundingTypeValid = false;                                    
                                    valid = false;
                            }

                        }
                        if(myCase.Funding_Type__c == 'Insurance')
                        {
                                List<InsuranceVerificationForm__c> insForms = [SELECT Id, 
                                                                                    InsuranceCompany__c, 
                                                                                    Benefit_Type__c, 
                                                                                    InsuredRelationshipToClient__c, 
                                                                                    InsuredName__c, 
                                                                                    InsuredEmployer__c, 
                                                                                    InsuredDateOfBirth__c, 
                                                                                    InsurancePhoneNumber__c, 
                                                                                    InsuranceID__c, VerificationComplete__c, Weekend_Admit__c FROM InsuranceVerificationForm__c WHERE Case__r.Id = :Transportation.Case__c];
                                if(insForms.size() > 0)
                                {
                                    HasInsuranceRecord = true;                                
                                    InsuranceVerificationForm__c insForm = insForms[0];
                                    PrimaryInsuranceForm = insForms[0];
                                    if(PrimaryInsuranceForm.Weekend_Admit__c == false)
                                    {
                                            if(insForm.VerificationComplete__c == null || insForm.VerificationComplete__c != true)
                                            {
                                                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insurance Verification must be complete before proceeding.'));
                                                InsuranceVerificationComplete = false;                                            
                                                valid = false;
        
                                            }
                                    }                                  
                                    if(insForm.InsuranceCompany__c == null)
                                    {
                                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insurance Company Name is required and needs corrected.'));
                                            InsInsuranceCompanyValid = false;                                            
                                            valid = false;
                                    }
                                    if(insForm.Benefit_Type__c == null)
                                    {
                                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insurance Benefit Type is required and needs corrected.'));
                                            InsBenefitTypeValid = false;                                            
                                            valid = false;
                                    }
                                    if(insForm.InsuredRelationshipToClient__c == null)
                                    {
                                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insurance Relationship to Client is required and needs corrected. '));
                                            InsInsuredRelationshipToClientValid = false;                                            
                                            valid = false;
                                    }
                                    if(insForm.InsuredName__c == null)
                                    {
                                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insurance Primary Insureds Name is required and needs corrected.'));
                                            InsInsuredNameValid = false;                                            
                                            valid = false;
                                    }
                                    if(insForm.InsuredEmployer__c == null)
                                    {
                                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insurance Primary Insureds Employer Name is required and needs corrected.'));
                                            InsInsuredEmployerValid = false;                                            
                                            valid = false;
                                    }
                                    if(insform.InsuredDateOfBirth__c == null)
                                    {
                                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insurance Primary Insureds Date of Birth is required and needs corrected.'));
                                            InsInsuredDOBValid = false;                                            
                                            valid = false;
                                    }
                                    if(insForm.InsurancePhoneNumber__c == null)
                                    {
                                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insurance Primary Insureds Insurance Phone Number is required and needs corrected.'));
                                            InsInsurancePhoneValid = false;                                            
                                            valid = false;
                                    }
                                    if(insForm.InsuranceID__c == null)
                                    {
                                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insurance Primary Insureds Insurance ID is required and needs corrected.'));
                                            InsInsuranceIdValid = false;                                            
                                            valid = false;
                                    }
                                }
                                else
                                {
                                    ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Case is set to Insurance funding type but there are no matching insurance records.  Please complete one before proceeding. '));
                                    HasInsuranceRecord = false;
                                    valid = false;
                                }
                        }
                        
                        List<Assessment__c> assessments = [SELECT Id, 
                                                                    Assessment_Status__c, 
                                                                    sah_substance1__c, 
                                                                    fitrx_height__c, 
                                                                    fitrx_weight__c
                                                                    FROM Assessment__c WHERE Case__r.Id = :Transportation.Case__c];                                                                    

                        if(assessments.size() > 0)
                        {
                        
                            ParentAssessment = assessments[0];
                            HasAssessmentRecord = true;                            
                            if(ParentAssessment.Assessment_Status__c != 'Approved')
                            {
                                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Assessment must be approved before proceeding.'));
                                AssessmentApproved = false;
                                valid = false;                               
                            }
                            if(ParentAssessment.sah_substance1__c == null)
                            {
                                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Assessment Substance Abuse History must have at least 1 complete entry.'));
                                AssessmentAbuseHistoryValid = false;
                                valid = false;                                  
                            }
                            /*
                            if(ParentAssessment.fitrx_height__c == null || ParentAssessment.fitrx_height__c == '')
                            {
                                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Assessment Height is a required field and needs corrected.'));
                                AssessmentHeightValid = false;
                                valid = false;                                  
                            }                          
                            if(ParentAssessment.fitrx_weight__c == null || ParentAssessment.fitrx_weight__c == 0)
                            {
                                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Assessment Weight is a required field and needs corrected.'));
                                AssessmentWeightValid = false;
                                valid = false;                                  
                            }
                            */                                            
                        }
                        else
                        {
                            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Each Case requires an Assessment be created before proceeding.'));
                            HasAssessmentRecord = false;
                            valid = false;                
                        }                     
                        if(CaseFundingTypeValid == false || CaseGenderValid == false)
                            CaseFieldsInvalid = true;
                        if(AccountNameValid == false || AccountDOBValid == false || AccountDemographicsValid == false || AccountHowDidYouGetOurNumberValid == false || AccountPhoneValid == false || AccountAddressValid == false)
                            AccountFieldsInvalid = true;             
                        if(HasInsuranceRecord == true && (InsInsuranceCompanyValid == false || InsBenefitTypeValid == false || InsInsuredRelationshipToClientValid == false || InsInsuredNameValid == false || InsInsuredEmployerValid == false || InsInsuredDOBValid == false || InsInsurancePhoneValid == false || InsInsuranceIdValid == false))
                            InsuranceFieldsInvalid = true;
                                                        
                        return valid;
        }
}