public with sharing class VOBController {

    private final VOB__c vob = null;
    
    private string page_message = '';
    private string page_js_message = '';
    private string page_js_redirect_url = '';
    private integer exists = 0;
    public String PatientName {get;set;}
    private string prevOwnerId = '';
    
    public VOBController() {
    
        if (ApexPages.CurrentPage().getParameters().get('caseid')!=null)
        {   
            List<VOB__c> vob_lst = [SELECT Id, Name, Case__c,
                    cp_abuse_benefits_ded__c, cp_abuse_benefits_met__c, cp_abuse_benefits_oop__c, cp_abuse_benefits_oopmet__c, cp_active__c, cp_completed_by__c, cp_corba__c, cp_date__c,
                    cp_effective__c, cp_good_for_detox__c, cp_good_for_iop__c, cp_good_for_ip__c, cp_good_for_op__c, cp_good_for_php__c, cp_good_for_res__c, cp_mental_benefits_ded__c,
                    cp_mental_benefits_met__c, cp_mental_benefits_oop__c, cp_mental_benefits_oopmet__c, cp_pre_ex_terms__c, cp_pre_existing__c, cp_precert_detox__c, cp_precert_iop__c,
                    cp_precert_ip__c, cp_precert_op__c, cp_precert_penalty__c, cp_precert_php__c, cp_precert_res__c, cp_time__c, cp_verified_w1__c, cp_verified_w2__c, pc_bill_to_name__c,
                    pc_can_pt_go_out_of_state__c, pc_claims_address__c, pc_claims_address_city__c, pc_claims_address_state__c, pc_claims_address_zip__c, pc_free_standing_facility__c,
                    pc_license_req__c, pc_pharmacy_benefit__c, pc_pharmacy_benefit_rx__c, pc_pharmacy_benefit_rx_phone__c, pc_phone__c, pc_precert_company__c, pt_city_state_zip__c,
                    pt_dob__c, pt_doc__c, pt_employer_of_insured__c, pt_employer_of_insured_phone__c, pt_grp__c, pt_id__c, pt_ins_dob__c, pt_ins_phone2__c, pt_ins_phone__c, pt_ins_ss__c,
                    pt_insurance_co__c, pt_insured_name__c, pt_inured_phone__c, pt_mr__c, pt_patient_address__c, pt_patient_name__c, pt_phone__c, pt_ref__c, pt_rel_to_pt__c, pt_s_s__c,
                    pt_type_of_plan__c, sb_mh_sa_combined__c, sb_precert_iop__c, sb_precert_ip__c, sb_precert_op__c, sb_precert_penalty__c, sb_precert_php__c, sb_substance_combined__c,
                    t1_detox_v1__c, t1_detox_v2__c, t1_detox_v3__c, t1_detox_v4__c, t1_detox_v5__c, t1_detox_v6__c, t1_iopded_v1__c, t1_iopded_v2__c, t1_iopded_v3__c, t1_iopded_v4__c,
                    t1_iopded_v5__c, t1_iopded_v6__c, t1_ipded_v1__c, t1_ipded_v2__c, t1_ipded_v3__c, t1_ipded_v4__c, t1_ipded_v5__c, t1_ipded_v6__c, t1_outpt_v1__c, t1_outpt_v2__c,
                    t1_outpt_v3__c, t1_outpt_v4__c, t1_outpt_v5__c, t1_outpt_v6__c, t1_phpded_v1__c, t1_phpded_v2__c, t1_phpded_v3__c, t1_phpded_v4__c, t1_phpded_v5__c, t1_phpded_v6__c,
                    t1_resded_v1__c, t1_resded_v2__c, t1_resded_v3__c, t1_resded_v4__c, t1_resded_v5__c, t1_resded_v6__c, t2_ipded_v1__c, t2_ipded_v2__c, t2_ipded_v3__c, t2_ipded_v4__c,
                    t2_ipded_v5__c, t2_ipded_v6__c, t2_iqpded_v1__c, t2_iqpded_v2__c, t2_iqpded_v3__c, t2_iqpded_v4__c, t2_iqpded_v5__c, t2_iqpded_v6__c, t2_opded_v1__c, t2_opded_v2__c,
                    t2_opded_v3__c, t2_opded_v4__c, t2_opded_v5__c, t2_opded_v6__c, t2_phpded_v1__c, t2_phpded_v2__c, t2_phpded_v3__c, t2_phpded_v4__c, t2_phpded_v5__c, t2_phpded_v6__c,
                    summary_of_benefits__c, caseid__c, complete__c, OwnerId
              FROM VOB__c 
                   WHERE caseid__c = :ApexPages.currentPage().getParameters().get('caseid')];
                   
              if (vob_lst.size() > 0)
              {
                  vob = vob_lst[0];
                  setPatientName(vob.pt_patient_name__c);                  
                  return;
              }
              else
              {
                  vob = new VOB__c();
              
                  // auto populate fields from case object
                  
                  List<Case> cases_lst = [SELECT Id,
                        Account.Name,
                        Contact.Name,
                        Contact.MobilePhone,
                        Contact_Owner__c,
                        Contact_Address__c,
                        X1st_Policy_Company__c,
                        X1st_Policy_Customer_Service_Phone_Numbe__c,
                        X1st_Policy_ID__c,
                        Contacts_DOB__c,
                        X1st_Policy_Group__c,
                        Contact_SSN__c,
                        X1st_Policy_Primary_Insured_Date_of_Birt__c,
                        X1st_Policy_Primary_Insured_Name__c,
                        X1st_Policy_Primary_Insured_Phone_Number__c,
                        X1st_Policy_Primary_Employer__c,
                        Primary_Insured_Relationship_to_Client__c,
                        X1st_Policy_Insurance_Type__c,
                        X2nd_Policy_MH_SA_Phone_Number__c,
                        X1_Policy_Primary_Insured_SS__c,
                        Funding_Type__c
                        
                  FROM Case 
                       WHERE Id = :ApexPages.currentPage().getParameters().get('caseid')];

                  if (cases_lst.size() > 0)
                  {
                      Case ca = cases_lst[0];
                      checkCaseBeforePopulate(ca);
                      if(PatientName != null)
                      {
                        vob.pt_patient_name__c = getPatientName();                       
                      }
                      else if(ca.Account.Name != null)
                      {
                       setPatientName(ca.Account.Name);
                       vob.pt_patient_name__c = getPatientName();                                               
                      }
                      else if(ca.Contact.Name != null && getPatientName() == null)
                      {
                       setPatientName(ca.Contact.Name);
                       vob.pt_patient_name__c = getPatientName();
                                               
                      }                   

                      vob.caseid__c = ApexPages.currentPage().getParameters().get('caseid');
                      vob.Case__c = ApexPages.currentPage().getParameters().get('caseid');
                      vob.pt_mr__c = ca.Contact.Name;
                      vob.pt_patient_address__c = ca.Contact_Address__c;
                      vob.pt_insurance_co__c = ca.X1st_Policy_Company__c;
                      vob.pt_employer_of_insured_phone__c = ca.X1st_Policy_Customer_Service_Phone_Numbe__c;
                      vob.pt_id__c = ca.X1st_Policy_ID__c;
                      vob.pt_phone__c = ca.Contact.MobilePhone;
                      vob.pt_dob__c = ca.Contacts_DOB__c;
                      vob.pt_grp__c = ca.X1st_Policy_Group__c;
                      vob.pt_s_s__c = ca.Contact_SSN__c;
                      vob.pt_ins_dob__c = ca.X1st_Policy_Primary_Insured_Date_of_Birt__c;
                      vob.pt_insured_name__c = ca.X1st_Policy_Primary_Insured_Name__c;
                      vob.pt_inured_phone__c = ca.X1st_Policy_Primary_Insured_Phone_Number__c;
                      vob.pt_employer_of_insured__c = ca.X1st_Policy_Primary_Employer__c;
                      vob.pt_rel_to_pt__c = ca.Primary_Insured_Relationship_to_Client__c;
                      vob.pt_type_of_plan__c = ca.X1st_Policy_Insurance_Type__c;
                      vob.pt_ins_phone2__c = ca.X2nd_Policy_MH_SA_Phone_Number__c;
                      vob.pt_ins_ss__c = ca.X1_Policy_Primary_Insured_SS__c;
                      vob.OwnerId = getQueueId(UserInfo.getUserId());
                      
                      vob.pt_patient_address__c = vob.pt_patient_address__c.replace('<br>', '');
                      
                      vob.Name = '';
                      exists = 1;
                  }
                          
              }
            
            return;
        }
            
        if (ApexPages.CurrentPage().getParameters().get('id')!=null)
        {
            List<VOB__c> lst = [SELECT Id, Name, Case__c,
                    cp_abuse_benefits_ded__c, cp_abuse_benefits_met__c, cp_abuse_benefits_oop__c, cp_abuse_benefits_oopmet__c, cp_active__c, cp_completed_by__c, cp_corba__c, cp_date__c,
                    cp_effective__c, cp_good_for_detox__c, cp_good_for_iop__c, cp_good_for_ip__c, cp_good_for_op__c, cp_good_for_php__c, cp_good_for_res__c, cp_mental_benefits_ded__c,
                    cp_mental_benefits_met__c, cp_mental_benefits_oop__c, cp_mental_benefits_oopmet__c, cp_pre_ex_terms__c, cp_pre_existing__c, cp_precert_detox__c, cp_precert_iop__c,
                    cp_precert_ip__c, cp_precert_op__c, cp_precert_penalty__c, cp_precert_php__c, cp_precert_res__c, cp_time__c, cp_verified_w1__c, cp_verified_w2__c, pc_bill_to_name__c,
                    pc_can_pt_go_out_of_state__c, pc_claims_address__c, pc_claims_address_city__c, pc_claims_address_state__c, pc_claims_address_zip__c, pc_free_standing_facility__c,
                    pc_license_req__c, pc_pharmacy_benefit__c, pc_pharmacy_benefit_rx__c, pc_pharmacy_benefit_rx_phone__c, pc_phone__c, pc_precert_company__c, pt_city_state_zip__c,
                    pt_dob__c, pt_doc__c, pt_employer_of_insured__c, pt_employer_of_insured_phone__c, pt_grp__c, pt_id__c, pt_ins_dob__c, pt_ins_phone2__c, pt_ins_phone__c, pt_ins_ss__c,
                    pt_insurance_co__c, pt_insured_name__c, pt_inured_phone__c, pt_mr__c, pt_patient_address__c, pt_patient_name__c, pt_phone__c, pt_ref__c, pt_rel_to_pt__c, pt_s_s__c,
                    pt_type_of_plan__c, sb_mh_sa_combined__c, sb_precert_iop__c, sb_precert_ip__c, sb_precert_op__c, sb_precert_penalty__c, sb_precert_php__c, sb_substance_combined__c,
                    t1_detox_v1__c, t1_detox_v2__c, t1_detox_v3__c, t1_detox_v4__c, t1_detox_v5__c, t1_detox_v6__c, t1_iopded_v1__c, t1_iopded_v2__c, t1_iopded_v3__c, t1_iopded_v4__c,
                    t1_iopded_v5__c, t1_iopded_v6__c, t1_ipded_v1__c, t1_ipded_v2__c, t1_ipded_v3__c, t1_ipded_v4__c, t1_ipded_v5__c, t1_ipded_v6__c, t1_outpt_v1__c, t1_outpt_v2__c,
                    t1_outpt_v3__c, t1_outpt_v4__c, t1_outpt_v5__c, t1_outpt_v6__c, t1_phpded_v1__c, t1_phpded_v2__c, t1_phpded_v3__c, t1_phpded_v4__c, t1_phpded_v5__c, t1_phpded_v6__c,
                    t1_resded_v1__c, t1_resded_v2__c, t1_resded_v3__c, t1_resded_v4__c, t1_resded_v5__c, t1_resded_v6__c, t2_ipded_v1__c, t2_ipded_v2__c, t2_ipded_v3__c, t2_ipded_v4__c,
                    t2_ipded_v5__c, t2_ipded_v6__c, t2_iqpded_v1__c, t2_iqpded_v2__c, t2_iqpded_v3__c, t2_iqpded_v4__c, t2_iqpded_v5__c, t2_iqpded_v6__c, t2_opded_v1__c, t2_opded_v2__c,
                    t2_opded_v3__c, t2_opded_v4__c, t2_opded_v5__c, t2_opded_v6__c, t2_phpded_v1__c, t2_phpded_v2__c, t2_phpded_v3__c, t2_phpded_v4__c, t2_phpded_v5__c, t2_phpded_v6__c,
                    summary_of_benefits__c, caseid__c, complete__c, OwnerId
              FROM VOB__c 
                   WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
                   
              if (lst.size() > 0)
              {
                  vob = lst[0];
              }
              
              return;
        }
        
        vob = new VOB__c(Name='');

    }
    public string getPatientName()
    {
        return PatientName;
    }
    public void setPatientName(string patientName)
    {
     this.PatientName = patientName;   
    }   
    public VOB__c getVob() {
        return vob;
    }    

    public PageReference PreSave() {
    
        if(exists == 1)
        {
            return save();
        }
        else
        {
            return null;
        }
    }


    public PageReference save() {
    
        string prev_id = vob.Id;
        vob.Case__c = vob.caseid__c;       
        
        if (getMessageBoxStatus()!='update')
        {
            vob.OwnerId = getQueueId(UserInfo.getUserId());
        }
        
        vob.pt_patient_name__c = getPatientName();        
        updateCase();
        
        upsert vob;
        
        if (prev_id==null)
            page_message = 'Insurance Verification Form Created '+vob.Id;
        else
            page_message = 'Insurance Verification Form Saved '+vob.Id;
        
        return null;
    }
    
    public String getQueueId(string currentUserId){

        List<User> users_lst = [SELECT Id, State
            FROM User
            WHERE Id = :currentUserId];

        if (users_lst.size() > 0)
        {
            User u = users_lst[0];
            
            List<Group> queues_lst = [Select Id, Name, DeveloperName, Type from Group where Type = 'Queue' AND Name LIKE :('Insurance Verifications%'+u.State)];
            
            if (queues_lst.size() > 0)
            {
                Group q = queues_lst[0];
                
                System.debug('************ Queue: ************ ' + q.Id);
                
                return q.Id;
            }
        }
        
        return UserInfo.getUserId();  // OwnerId cannot be empty - exception will be thrown
    }
    
    public void updateCase()
    {
        List<Case> cases_lst = [SELECT Id, Status, Insurance_Status__c, Insurance_Summary_of_Benefits__c
            FROM Case 
            WHERE Id = :vob.caseid__c];
        
        if (cases_lst.size() > 0)
        {
            Case ca = cases_lst[0];

            ca.Status = '1- Pending Verification of Benefits';
       
            if (getMessageBoxStatus()=='update')
            {
                ca.Insurance_Status__c = 'Resubmitted';
            }
            else
            if (ca.Insurance_Status__c==null || ca.Insurance_Status__c=='—None—')
            {
                ca.Insurance_Status__c = 'In-progress';
            }
            else if (vob.complete__c==true)
            {
                ca.Insurance_Status__c = 'Verified';
                ca.Insurance_Summary_of_Benefits__c = vob.summary_of_benefits__c;
            }
            update ca;
            
        }    
    }
    
    public PageReference cancel() {
    
        PageReference pg=New PageReference('/a0B/o');
        return pg;
    }
    
    public PageReference gotocase() {
    
        if (vob==null) return null;

        PageReference pg=New PageReference('/'+vob.caseid__c);
        return pg;
    }    

    public void checkCaseBeforePopulate(Case ca){
        
        if (ca.Funding_Type__c=='Private Pay')
        {
            page_js_message = 'This is a private pay client and no insurance verification is necessary';
            page_js_redirect_url = '/'+ca.Id;
        }
    }
    
    public String getMessage() {
        return page_message;
    }    

    public String getJsMessage() {
        return page_js_message;
    }    

    public String getJsMessageURL() {
        return page_js_redirect_url;
    }    
    
    public String getMessageBoxStatus() {
        
        if (exists==1)
            return 'created';
        else
            return ApexPages.currentPage().getParameters().get('messgbox_result');
    }        
}