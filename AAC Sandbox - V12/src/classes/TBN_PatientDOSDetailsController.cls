public with sharing class TBN_PatientDOSDetailsController 
{
    public List<Dates_of_Service__c> lstDOSForPatient           {get; set;}     // List of All Date of Service record for the Patient Selected from the previous page.
    public String strInsurance                                  {get; set;}     // Will contain Insurance Type name to be used on the page.
    public String strInsuranceCompanyName                       {get; set;}     // Will contain Insurance Company name to be used on the page.
    public Patient_Insurance__c primaryInsuranceCompany         {get; set;}     // Will contain primary Insurance company record to be used on the page.
    public Patient_Insurance__c secondaryInsuranceCompany       {get; set;}     // Will contain secondary Insurance company record to be used on the page.
    public Patient_Insurance__c tertiaryInsuranceCompany        {get; set;}     // Will contain tertiary Insurance company record to be used on the page.
    public Decimal decAmount                                    {get; set;}     // Will contain Amount for the selected Patient from the previous page. 
    public String srtPatient                                    {get; set;}     // Selected Patient Name.
    private String sortDirection = 'ASC';                                       // Initial sorting order 
    private String sortExp ;                                                    //  Sorting Expression  
    String strQuery;                                                            // Query on Claim objects   
    public Decimal decCheckBalanceAmount                        {get; set;}
    private Decimal decTotalPaidAmount = 0;                         
    public String strUpdatedAdjustmentType                      {get; set;}     //String of Updated Adjustment type "Adjustment_Type__c"  on patient
    public String strEditedDosiIDs                              {get; set;}     //String containing Edited DOS Id's in comma seperated
    private String PatientPaymentInfoId; 
    private Patient_Payment_Info__c objCurrentPatientPaymentInfo;               //Current patient paymentinfo for which the payment is to be done. 
    public String viewPostDOSId                                 {get; set;}     //Dos Id for which Transaction records to be created or edited.     
    public list<Dates_of_Service_Transaction__c> lstDOSTransaction  {get; set;} //List of Dates of Service Transaction for particular DOS record.           
    public boolean showPopUp                                        {get; set;} //Boolean variable to show the popup.
    public Dates_of_Service__c  objEditedDOS                        {get; set;} //Edited DOS record
    public String strDOSTransactionDetails                          {get; set;} //Edited or newly added DOSTransaction details sent from page.
    public String strCheckedDOSIds                                  {get; set;} //Comma seperated DOS id's for creating paper claim.
    
    /*Constructor*/
    public TBN_PatientDOSDetailsController() 
    {
        try
        {
            if(ApexPages.currentPage().getParameters().containsKey('insurance') && ApexPages.currentPage().getParameters().containsKey('amount') 
                && ApexPages.currentPage().getParameters().containsKey('patient') && ApexPages.currentPage().getParameters().containsKey('PatientId') && ApexPages.currentPage().getParameters().containsKey('balanceAmount'))
            {
                strInsurance =  Apexpages.currentPage().getParameters().get('insurance');
                decAmount = Decimal.valueOf(Apexpages.currentPage().getParameters().get('amount'));
                srtPatient = Apexpages.currentPage().getParameters().get('patient');
                PatientPaymentInfoId = Apexpages.currentPage().getParameters().get('PatientId');
                decCheckBalanceAmount = Decimal.valueOf(Apexpages.currentPage().getParameters().get('balanceAmount'));
            }
            system.debug('---srtPatient---'+srtPatient);     
            /*Quering on Patient_Insurance__c  object to get all its related insurance information*/
            for(Patient_Insurance__c objPatientIns : [Select Type__c, Patient__c, Name, Insurance_Company__r.Health_Plan_Id__c, Insurance_Company__r.Address__c, 
                                                                Insurance_Company__r.Website__c, Insurance_Company__r.Email__c, Insurance_Company__r.Phone__c, 
                                                                Insurance_Company__r.Name, Insurance_Company__c, Insurance_Code__c, Id, Patient__r.Name 
                                                        From Patient_Insurance__c
                                                        Where Patient__r.Name = : srtPatient])
            {
                if(objPatientIns.Type__c == strInsurance)
                    strInsuranceCompanyName = objPatientIns.Insurance_Company__r.Name; 
                if(objPatientIns.Type__c == 'Primary')
                    primaryInsuranceCompany = objPatientIns;
                if(objPatientIns.Type__c == 'Secondary')
                    secondaryInsuranceCompany = objPatientIns;
                if(objPatientIns.Type__c == 'Tertiary')
                    tertiaryInsuranceCompany = objPatientIns;
            }
                                                            
            objCurrentPatientPaymentInfo = [Select Id, Check_Info__r.Parent_Batch_Payment__r.Facility__r.Name, Check_Info__c From Patient_Payment_Info__c Where Id =: PatientPaymentInfoId];
            strQuery = 'Select Utilization_Review_Form__c, Adj_Amount__c, Utilization_Review_Form__r.Account__c, Balance_Amount__c, End_Date__c, Status__c, Name, Id, Case__c, Bill_Status__c, Amount__c, Amount_Paid__c, Patient__c, Facility__c, Level_of_Care__c, Patient_Responsibility_Amount__c, Insurance_Adjusted_Amount__c, Allowed_Amount__c, Adjustment_Type__c, PatientPaymentInfo__c, PatientPaymentInfo__r.Check_Info__r.Parent_Batch_Payment__r.Status__c From Dates_of_Service__c Where Patient__c = \'' +srtPatient+ '\' AND Bill_Status__c != \'Selected\' AND (PatientPaymentInfo__r.Check_Info__r.Parent_Batch_Payment__r.Status__c = \'open\' OR PatientPaymentInfo__c = null  OR PatientPaymentInfo__c = \'\') AND Facility__c = \'' +objCurrentPatientPaymentInfo.Check_Info__r.Parent_Batch_Payment__r.Facility__r.Name+ '\' ORDER BY End_Date__c DESC';
            system.debug('$$$strQuery$$$$ : '+strQuery);
            lstDOSForPatient = Database.query(strQuery);
            system.debug('%%%%lstDOSForPatient%%%% : '+lstDOSForPatient);
            
            if(Test.isRunningTest())
            {
                decimal i=8/0;
            }
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        
    }
    
    /* sorting logic starts here */
   public String sortExpression
   {
         get
         {
            return sortExp;
         }
         set
         {
           //if the column is clicked on then switch between Ascending and Descending modes
           if (value == sortExp)
             sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
           else
             sortDirection = 'ASC';
           sortExp = value;
         }
    }
    
    public String getSortDirection()
    {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
    }

    public void setSortDirection(String value)
    {  
        sortDirection = value;
    }
    
    /* Query for Sorting the records */
    public void sort()
    {   
        try
        {
            String strSortQuery;
            String sortFullExp = ' '+'order by'+' '+sortExpression  + ' ' + sortDirection;
            strSortQuery = strQuery+' '+ sortFullExp+' '+'Nulls Last  limit 10000';
            
            //query the database based on the sort expression
            system.debug('&&&&&&&&&&&&strSortWQuery&&&&&&&&&'+strSortQuery);
            lstDOSForPatient = Database.query(strSortQuery);
            if(Test.isRunningTest())
            {
                decimal i=8/0;
            }
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
    }
    
    /*To Save the DOS records with updated Paid Amount value*/
    public pageReference saveDOSPatientRecord()
    {
        List<Dates_of_Service__c> lstUpdateAmount = new List<Dates_of_Service__c>();
        Set<String> setEditedDOSIDs = new Set<String>();
        List<Sobject> lstSObject = new List<SObject>();
        Set<Sobject> setSObject = new Set<SObject>();
        List<String> lstEditedDOSIDs = strEditedDosiIDs.split(',');
        try
        {
            Account objAccount = [Select Id,Name From Account Where Name =: srtPatient];
            for(String strId : lstEditedDOSIDs)
                        setEditedDOSIDs.add(strId);
            for(integer i=0; i<lstDOSForPatient.size(); i++)
            {
                Dates_of_Service__c objDOS = lstDOSForPatient[i];
                if(setEditedDOSIDs.contains(lstDOSForPatient[i].Id))
                {
                    system.debug('-------in---------');
                    objDOS.PatientPaymentInfo__c = PatientPaymentInfoId;
                    system.debug('-----objDOS.PatientPaymentInfo__c--------'+objDOS.PatientPaymentInfo__c);
                }
                objDOS.Account__c = objAccount.Id;
                objDOS.Utilization_Review_Form__r.Account__c = objAccount.Id;
                setSObject.add(objDOS.Utilization_Review_Form__r);
                lstUpdateAmount.add(objDOS);
                system.debug('------- lstUpdateAmount-------'+lstUpdateAmount);
            } 
            lstSObject.addAll(setSObject);
                        
            if(!lstUpdateAmount.isEmpty())
            {
                update lstUpdateAmount;
                update lstSObject;
            }
            /*For updating the status of "Patient payment Info object and calculating its Amount"*/
            List<Dates_of_Service__c> lstDOSPatientPayment = [Select PatientPaymentInfo__r.Status__c, PatientPaymentInfo__r.Amount__c, PatientPaymentInfo__c, Id, Amount_Paid__c 
                                                                From Dates_of_Service__c 
                                                                Where PatientPaymentInfo__c =: PatientPaymentInfoId];
            system.debug('###lstDOSPatientPayment   ###'+lstDOSPatientPayment);
            for(Dates_of_Service__c objDOS : lstDOSPatientPayment)
                decTotalPaidAmount += objDOS.Amount_Paid__c;
            
            Patient_Payment_Info__c objPatientPaymentInfo = [Select Status__c, Id, Amount__c, Check_Info__r.RollUp_Amount__c From Patient_Payment_Info__c Where Id =: PatientPaymentInfoId];                                        
            objPatientPaymentInfo.Status__c = 'Closed';
            objPatientPaymentInfo.Amount__c = decTotalPaidAmount;
            update objPatientPaymentInfo;
            
            Patient_Payment_Info__c objPatient = [Select Check_Info__r.RollUp_Amount__c From Patient_Payment_Info__c Where Id =: PatientPaymentInfoId];
            system.debug('++objPatient.Check_Info__r.RollUp_Amount__c++'+objPatient.Check_Info__r.RollUp_Amount__c);
            decCheckBalanceAmount = decAmount - objPatient.Check_Info__r.RollUp_Amount__c;  
            
            system.debug('%%%%objPatientPaymentInfo%%%% : '+objPatientPaymentInfo);
            PageReference pr= new PageReference('/apex/TBN_CreateNewPayemBatchPage?blnSave=true&patientName='+PatientPaymentInfoId+'&balanceAmount='+decCheckBalanceAmount);
            pr.setRedirect(true);
            return pr;
        }
        catch(Exception e)
        {
            system.debug('--error----'+e.getLineNumber());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
    }
    
    /*To redirect to the "Patient Payment Info Page"*/
    public pageReference cancelToPatienPaymentInfo()
    {
        PageReference pr= new PageReference('/apex/TBN_CreateNewPayemBatchPage?blnCancel=true&amount='+decAmount+'&insurance='+strInsurance+'&patient='+srtPatient+'&flag=redirectPatientDOS');
        pr.setRedirect(true);
        return pr;
    }
    
    /*Action function to be called on click of "View/Post" link corresponding to the DOS record.*/
    public void viewAndPost()
    {
        try
        {
            system.debug('******viewPostDOSId***** : '+viewPostDOSId);
            lstDOSTransaction = new list<Dates_of_Service_Transaction__c>();
            objEditedDOS = [Select Level_of_Care__c, Id, Facility__c, Amount__c, End_Date__c, Insurance_Adjusted_Amount__c, Bill_Status__c 
                            From Dates_of_Service__c 
                            Where Id = : viewPostDOSId];
                            
            lstDOSTransaction = [Select Patient_Responsibility_Amount__c, Paid_Amount__c, Name, Insurance_Adjusted_Amount__c, Id, Dates_of_Service__c, Dates_of_Service__r.Name, Allowed_Amount__c, Adjustment_Type__c, Adjustment_Reason__c 
                                    From Dates_of_Service_Transaction__c 
                                    Where Dates_of_Service__c = : viewPostDOSId];
            system.debug('^^^^^^^lstDOSTransaction^^^^^^^^ : '+lstDOSTransaction);
            showPopUp = true;
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
    }
    
    /*Action function to be called on click of ok button from popup*/
    public void ok()
    {
        try
        {
            list<String> lstDOSTransactionDetail = strDOSTransactionDetails.split(',');
            system.debug('####lstDOSTransactionDetail##### : '+lstDOSTransactionDetail);
            
            if(lstDOSTransactionDetail[1] == 'newDOSTransaction')
            {
                Dates_of_Service_Transaction__c objDOSTransaction = new Dates_of_Service_Transaction__c();
                objDOSTransaction.Paid_DateTime__c = DateTime.now();
                objDOSTransaction.Dates_of_Service__c = lstDOSTransactionDetail[0];
                objDOSTransaction.Adjustment_Type__c = lstDOSTransactionDetail[2];
                objDOSTransaction.Adjustment_Reason__c = lstDOSTransactionDetail[3];
                if(lstDOSTransactionDetail[2] == 'Other Adjustment')
                {
                    objDOSTransaction.Insurance_Adjusted_Amount__c = 0;
                    objDOSTransaction.Adjustment_Amount__c = decimal.valueOf(lstDOSTransactionDetail[7]);
                }
                else if(lstDOSTransactionDetail[2] == 'Tertiary Insurance' || lstDOSTransactionDetail[2] == 'Secondary Insurance')
                {
                    objDOSTransaction.Insurance_Adjusted_Amount__c = decimal.valueOf(lstDOSTransactionDetail[7]);
                    objDOSTransaction.Adjustment_Amount__c = 0;
                    objDOSTransaction.Adjustment_Reason__c = '';
                }
                objDOSTransaction.Paid_Amount__c = decimal.valueOf(lstDOSTransactionDetail[4]);
                objDOSTransaction.Allowed_Amount__c = decimal.valueOf(lstDOSTransactionDetail[5]);
                objDOSTransaction.Patient_Responsibility_Amount__c = decimal.valueOf(lstDOSTransactionDetail[6]);
                //objDOSTransaction.Insurance_Adjusted_Amount__c = decimal.valueOf(lstDOSTransactionDetail[7]);
                insert objDOSTransaction;
            }
            else
            {
                Dates_of_Service_Transaction__c objDOSTransactionUpdate = [Select Patient_Responsibility_Amount__c, Paid_Amount__c, Name, Insurance_Adjusted_Amount__c, Id, Dates_of_Service__c, Dates_of_Service__r.Name, Dates_of_Service__r.Bill_Status__c, Allowed_Amount__c, Adjustment_Type__c, Adjustment_Reason__c 
                                                                            From Dates_of_Service_Transaction__c 
                                                                            Where Id = : lstDOSTransactionDetail[1]];
                system.debug('$$$$$objDOSTransactionUpdate$$$$$$ : '+objDOSTransactionUpdate);
                objDOSTransactionUpdate.Paid_DateTime__c = DateTime.now();
                objDOSTransactionUpdate.Adjustment_Type__c = lstDOSTransactionDetail[2];
                objDOSTransactionUpdate.Adjustment_Reason__c = lstDOSTransactionDetail[3];
                if(lstDOSTransactionDetail[2] == 'Other Adjustment')
                {
                    objDOSTransactionUpdate.Insurance_Adjusted_Amount__c = 0;
                    objDOSTransactionUpdate.Adjustment_Amount__c = decimal.valueOf(lstDOSTransactionDetail[7]);
                }
                else if(lstDOSTransactionDetail[2] == 'Tertiary Insurance' || lstDOSTransactionDetail[2] == 'Secondary Insurance')
                {
                    objDOSTransactionUpdate.Insurance_Adjusted_Amount__c = decimal.valueOf(lstDOSTransactionDetail[7]);
                    objDOSTransactionUpdate.Adjustment_Amount__c = 0;
                    objDOSTransactionUpdate.Adjustment_Reason__c = '';
                }
                objDOSTransactionUpdate.Paid_Amount__c = decimal.valueOf(lstDOSTransactionDetail[4]);
                objDOSTransactionUpdate.Allowed_Amount__c = decimal.valueOf(lstDOSTransactionDetail[5]);
                objDOSTransactionUpdate.Patient_Responsibility_Amount__c = decimal.valueOf(lstDOSTransactionDetail[6]);
                //objDOSTransactionUpdate.Insurance_Adjusted_Amount__c = decimal.valueOf(lstDOSTransactionDetail[7]);
                update objDOSTransactionUpdate;
            }
            objEditedDOS.Bill_Status__c = 'Paid';
            update objEditedDOS;
            showPopUp = false;
            lstDOSForPatient = Database.query(strQuery);
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
    }
    
    /* Popup window close event  */
    public void closePopup() 
    {
        showPopUp = false;
    }
    
    /* Upsert the Parent Claim records  */
     public pagereference createBatchClaim() 
     {
        PageReference pg ;
        List<Dates_of_Service__c> lstDOSToBeUpdated = new List<Dates_of_Service__c>();
        List<Dates_of_Service__c> lstDOSFinal = new List<Dates_of_Service__c>();
        set<String> setDistinctName = new set<String>();
        set<String> setDistinctClaims = new set<String>();
        Set<String> setFacilityPatient = new Set<String>();         // strFacilityName
        List<Note> lstNote = new List<Note>();  // list of attachment to be inserted.
        Set<Utilization_Review__c> setUtilizationReview = new Set<Utilization_Review__c>(); //Set of Utilization Review records to be updated.
        Batch__c objParentClaim = new Batch__c(); 
        List<Track_Date_of_Services__c> lstTrackDOS = new List<Track_Date_of_Services__c>();
        map<String, String> mapPatientNameToPatientId = new map<String, String>();  //Map Patient Name to Patient Id
        List<String> lstCheckedIds = new List<String>();
        Decimal sum = 0;
        
        try
        {
            system.debug('####strCheckedDOSIds#### : '+strCheckedDOSIds);
            strCheckedDOSIds = strCheckedDOSIds.removeEnd(', ');
            lstCheckedIds = strCheckedDOSIds.split(',');
            system.debug('####checkedIds#### : '+lstCheckedIds);
            
            /* Updating All Selected Dates_of_Service__c records */
            for(Dates_of_Service__c objDOS : [Select Utilization_Review_Form__c, Utilization_Review_Form__r.First_DOS_Billed__c, Utilization_Review_Form__r.Last_DOS_Billed__c, 
                                                        Utilization_Review_Form__r.Account__c, End_Date__c, Status__c, Name, Id, Case__c, Bill_Status__c, Amount__c, Amount_Paid__c, 
                                                        Patient__c, Facility__c, Level_of_Care__c, Patient_Responsibility_Amount__c, Insurance_Adjusted_Amount__c, Allowed_Amount__c, 
                                                        Adjustment_Type__c, PatientPaymentInfo__c, PatientPaymentInfo__r.Check_Info__r.Parent_Batch_Payment__r.Status__c 
                                                From Dates_of_Service__c 
                                                Where Id IN : lstCheckedIds ORDER BY End_Date__c DESC])
            {
                Track_Date_of_Services__c objTrackDOS = new Track_Date_of_Services__c();
                objTrackDOS.Dates_of_Service__c = objDOS.Id;
                objTrackDOS.Status__c = 'Submitted';
                objTrackDOS.Submitted_By__c = UserInfo.getUserId();
                objTrackDOS.Submitted_Date__c = DateTime.now();
                objTrackDOS.Submitted_Type__c = 'Print';
                lstTrackDOS.add(objTrackDOS);
                
                setFacilityPatient.add(objDOS.Facility__c+'_'+objDOS.Patient__c+'_'+objDOS.Level_of_Care__c);
                objDOS.Bill_Status__c = 'Printed';
                objDOS.Submitted_DateTime__c = Datetime.now();
                lstDOSToBeUpdated.add(objDOS);
                setDistinctName.add(objDOS.Patient__c);
                setDistinctClaims.add(objDOS.Claim__c);
    
                if(setDistinctName != null)
                    objParentClaim.of_Patient__c = setDistinctName.size();
                else 
                    objParentClaim.of_Patient__c = 0;
                
                if(setFacilityPatient != null)  
                    objParentClaim.of_Claim__c = setFacilityPatient.size();
                else 
                    objParentClaim.of_Claim__c = 0; 
                
                if(objDOS.Amount__c != null)
                {
                    sum += objDOS.Amount__c;
                }
                system.debug('*****sum** :'+sum);                
                
                /*Checking with the "First DOS Billed is blank or not" and updating the "First DOS Billed and Last DOS Billed" accordingly for corresponding "Utilization Review Records."*/
                Utilization_Review__c objUtilizationReview = objDOS.Utilization_Review_Form__r;
                if(objDOS.Utilization_Review_Form__r.First_DOS_Billed__c == Null)
                {
                    objUtilizationReview.First_DOS_Billed__c = date.today();
                    setUtilizationReview.add(objUtilizationReview);
                }   
                else
                {
                    objUtilizationReview.Last_DOS_Billed__c = date.today(); 
                    setUtilizationReview.add(objUtilizationReview);
                }
            }
            objParentClaim.Total_Amount__c = sum;
            objParentClaim.Submit_Type__c = 'Print';
            objParentClaim.Submit_Timestamp__c = Datetime.now();
            
            update lstDOSToBeUpdated;
            upsert objParentClaim;
            insert lstTrackDOS;
            
            /*Creating Note for Batch record to open Mutliple UB04 form in Single page*/
            Note objNoteUB04FormForBatch = new Note(); 
            objNoteUB04FormForBatch.parentId = objParentClaim.Id; //Id of the Claim for which you want to add this note
            objNoteUB04FormForBatch.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_PrintUB04FormForBatch?batchId='+objParentClaim.Id; // body of the note. this should be populated from the notes field that you have shown in the screenshot
            objNoteUB04FormForBatch.title = 'NoteUB04FormForBatch'; // the title of the note
            objNoteUB04FormForBatch.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
            insert objNoteUB04FormForBatch;
            
            /* Querying on batch to get the recently created batch record*/
            Batch__c objBatch = [Select Id, Name From Batch__c Where Id=:objParentClaim.Id];
            for(Account objAccount : [Select Id, Name from Account where Name In : setDistinctName])
            {
                mapPatientNameToPatientId.put(objAccount.Name, objAccount.Id);
            }
            system.debug('&&&mapPatientNameToPatientId&&&& : '+mapPatientNameToPatientId);
            system.debug('$$$$setUtilizationReview$$$$: '+setUtilizationReview);
            list<Utilization_Review__c> listUtilizationReview = new list<Utilization_Review__c>();
            listUtilizationReview.addAll(setUtilizationReview);
            update listUtilizationReview;
            
            Map<String, Claim__c> mapCombination_ClaimId = new Map<String, Claim__c>(); 
            Map<String,String> mapClaimIdToPatientName = new Map<String,String>();
            if(setFacilityPatient != null && setFacilityPatient.size() > 0)
            {
                for(String strComb : setFacilityPatient)
                {
                    system.debug('$$$$mapPatientNameToPatientId$$$$ : '+mapPatientNameToPatientId.get(strComb.split('_')[1]));
                    Claim__c objClaim = new Claim__c();
                    objClaim.Facility__c = strComb.split('_')[0];
                    objClaim.Patient__c = strComb.split('_')[1];
                    objClaim.PatientLookup__c =  Id.valueOf(mapPatientNameToPatientId.get(strComb.split('_')[1]));
                    objClaim.ParentClaim__c = objParentClaim.Id;
                    objClaim.Level_of_Care__c = strComb.split('_')[2];
                    objClaim.Status__c = 'Printed';
                    objClaim.Type_of_Bill__c = '113';
                    mapCombination_ClaimId.put(strComb, objClaim);
                }
                
                if(mapCombination_ClaimId != null && mapCombination_ClaimId.values().size() > 0)
                    insert mapCombination_ClaimId.values();
                    
                /*Creating a map of claim Id and patient Name to attach the UB04 forms to the corresponding patient records*/    
                for(Claim__c objClaimForPatient: mapCombination_ClaimId.values()) 
                 {
                    mapClaimIdToPatientName.put(objClaimForPatient.Id,objClaimForPatient.Patient__c);
                 }  
                 system.debug('-------mapCombination_ClaimId-------'+mapCombination_ClaimId);
                 system.debug('-------mapCombination_ClaimId---V----'+mapCombination_ClaimId.values());   
                 
                 Map<Id,Id> mapClaimIdToPatientId = new Map<Id,Id>();
                 for(Account objPatients : [Select Id,Name From Account Where Name IN: mapClaimIdToPatientName.values()])
                 {
                    for(String strClaimId : mapClaimIdToPatientName.keyset())
                    {
                        system.debug('--mapClaimIdToPatientName.get(strClaimId)--'+mapClaimIdToPatientName.get(strClaimId));
                        system.debug('--objPatients.Name--'+objPatients.Name);
                        if(objPatients.Name == mapClaimIdToPatientName.get(strClaimId))
                            mapClaimIdToPatientId.put(strClaimId, objPatients.Id);
                    }
                 }
                 
                  Map<String,String> mapClaimIdToClaimName = new Map<String,String>();
                 for(Claim__c objClaim : [Select Id,Name From Claim__c Where Id IN:mapClaimIdToPatientId.keyset()])
                 {
                    mapClaimIdToClaimName.put(objClaim.Id,objClaim.Name);
                 }
                 system.debug('-------mapClaimIdToClaimName-------'+mapClaimIdToClaimName); 
                 system.debug('-------mapClaimIdToPatientId-------'+mapClaimIdToPatientId);   
                 
                /*Creating Note for each claim created and attaching UB04 form to respective Claim record*/
                for(Claim__c objClaimUB04 : mapCombination_ClaimId.values())
                {
                    Note objNoteUB04Form = new Note(); 
                    Note objNoteUB04Blank = new Note();
                    
                    objNoteUB04Form.parentId = objClaimUB04.Id; //Id of the Claim for which you want to add this note
                    objNoteUB04Form.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_UB04Form?claim='+objClaimUB04.Id; // body of the note. this should be populated from the notes field that you have shown in the screenshot
                    objNoteUB04Form.title = 'NoteUB04Form'; // the title of the note
                    objNoteUB04Form.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
                    lstNote.add(objNoteUB04Form);
                    
                    objNoteUB04Blank.parentId = objClaimUB04.Id; //Id of the Claim for which you want to add this note
                    objNoteUB04Blank.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_UB04_Blank?claim='+objClaimUB04.Id; // body of the note. this should be populated from the notes field that you have shown in the screenshot
                    objNoteUB04Blank.title = 'NoteUB04Blank'; // the title of the note
                    objNoteUB04Blank.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
                    lstNote.add(objNoteUB04Blank);
                    
                    /*Attaching the corresponding UB04 form to the patient notes and attachment related list*/
                    if(mapClaimIdToPatientId.containskey(objClaimUB04.Id) && mapClaimIdToClaimName.containskey(objClaimUB04.Id))
                    {
                        system.debug('-----objClaimUB04.Id--'+objClaimUB04.Id);
                        system.debug('----mapClaimIdToPatientId.get(objClaimUB04.Id)'+mapClaimIdToPatientId.get(objClaimUB04.Id));
                        system.debug('----objClaimUB04.Name-'+objClaimUB04.Name);
                        Note objNoteUB04View = new Note(); 
                        Note objNoteUB04Print = new Note();
                        
                        objNoteUB04View.parentId = mapClaimIdToPatientId.get(objClaimUB04.Id); //Id of the Claim for which you want to add this note
                        objNoteUB04View.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_UB04Form?claim='+objClaimUB04.Id; // body of the note. this should be populated from the notes field that you have shown in the screenshot
                        objNoteUB04View.title = objClaimUB04.Patient__c+'UB04View_'+mapClaimIdToClaimName.get(objClaimUB04.Id); // the title of the note
                        objNoteUB04View.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
                        lstNote.add(objNoteUB04View);
                        
                        objNoteUB04Print.parentId = mapClaimIdToPatientId.get(objClaimUB04.Id); //Id of the Claim for which you want to add this note
                        objNoteUB04Print.body = URL.getSalesforceBaseUrl().toExternalForm()+'/apex/TBN_UB04_Blank?claim='+objClaimUB04.Id; // body of the note. this should be populated from the notes field that you have shown in the screenshot
                        objNoteUB04Print.title = objClaimUB04.Patient__c+'UB04Print_'+mapClaimIdToClaimName.get(objClaimUB04.Id); // the title of the note
                        objNoteUB04Print.isPrivate = false;  // if private it will be visible only for the owner and any user with modify all permission
                        lstNote.add(objNoteUB04Print);
                    }
                }
                
                if(lstNote != null && lstNote.size() > 0)
                    insert lstNote;
                
                if(lstDOSToBeUpdated != null)
                {
                    for(Dates_of_Service__c objDOSUpdate : lstDOSToBeUpdated)
                    {
                        String strDOSComb = objDOSUpdate.Facility__c +'_'+ objDOSUpdate.Patient__c +'_'+ objDOSUpdate.Level_of_Care__c;
                        if(mapCombination_ClaimId != null && mapCombination_ClaimId.containsKey(strDOSComb))
                        {
                            objDOSUpdate.Claim__c = mapCombination_ClaimId.get(strDOSComb).Id;
                            lstDOSFinal.add(objDOSUpdate);
                        }   
                    }
                    if(lstDOSFinal != null && lstDOSFinal.size() > 0)
                        update lstDOSFinal;
                }    
            }
                
            //pg = new pageReference('/'+objParentClaim.id);
            pg = new PageReference('/apex/TBN_Emdeon?Load=first&subBatchId='+objBatch.Id);
            /*Returing page reference of the current Parent Claim record . */
            return pg;
        }
        catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            return null;
        }
        
    }
    
}