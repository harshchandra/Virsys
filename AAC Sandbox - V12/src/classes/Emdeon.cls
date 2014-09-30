public class Emdeon 
{
    public Case ParentCase {get;set;}
    public Account ParentAccount {get;set;}
    public InsuranceVerificationForm__c ParentVOB {get;set;}
    public string Request {get;set;}
    public string Response {get;set;}
    public boolean IsPayerNamePopulated {get;set;}
    public EmdeonResponse FinalResponse {get;set;}
    public boolean DisplayEmdeonBlock {get;set;}
    public boolean DisplayResponse {get; set;}
    public boolean DisplaySaveButton {get;set;}
    public Emdeon(ApexPages.StandardController controller)
    {
    	
    	User u = [SELECT Id,Alias,Name,ProfileId,State from User WHERE Id = :UserInfo.getUserId()];
    	if(u.ProfileId == '00eG00000017OdCIAU' || u.ProfileId == '00eG00000014xAKIAY' || u.ProfileId == '00eG00000017Oh3IAE' || u.ProfileId == '00eG00000017OcdIAE')
    	{
    		DisplayEmdeonBlock = true;	
    	}
    	else
    	{
    		DisplayEmdeonBlock = false;
    	}
    	IsPayerNamePopulated = false;
    	DisplayResponse = false;
    	DisplaySaveButton = false;
    	Id recordId = controller.getId();
    	if(recordId != null && DisplayEmdeonBlock == true)
    	{
        ParentVOB = (InsuranceVerificationForm__c)controller.getRecord();
        
        ParentVOB = [SELECT Id, 
        					Case__c, 
        					Case__r.Id, 
        					InsuranceCompany__c,
        					Insurance_Company_Emdeon__c,
        					InsuredName__c,
        					InsuredDateOfBirth__c,
        					InsuredSocialSecurityNumber__c,
        					InsuredRelationshipToClient__c,
        					InsuranceID__c,
        					Verified_Through_Emdeon__c,
        					Verified_Through_Emdeon_User__c,
        					Verified_Through_Emdeon_Date__c,
        					InsuranceGroupNumber__c
        					FROM InsuranceVerificationForm__c 
        					WHERE Id = :ParentVOB.Id];
        if(ParentVOB.Verified_Through_Emdeon__c == true)
        	DisplayEmdeonBlock = false;
        	
        	
        ParentCase = [SELECT Id,CaseNumber, AccountId, Contact_SSN__c, Gender__c FROM Case WHERE Id = :ParentVOB.Case__r.Id];
        //ParentAccount = [SELECT Id,FirstName,LastName,Date_of_Birth__pc,SSN__pc,BillingState FROM Account WHERE Id = :ParentCase.AccountId];
        List<Account> lstAccount = [SELECT Id,FirstName,LastName,Date_of_Birth__pc,SSN__pc,BillingState FROM Account WHERE Id = :ParentCase.AccountId]; 
        if(lstAccount != null && lstAccount.size() > 0)
        ParentAccount = lstAccount[0];
		
        
        //delimit with semicolon or pipe
        string facilityTPG = '00489976';
        string facilityName = 'American Addiction Centers';
        string facilityNPI = '1063786069';
        string payerName = ParentVOB.Insurance_Company_Emdeon__c; //insurance provider name, optional
        string payerID = ''; //based on payer cross walk, eg UHC
        
        if(payerName == null)
            payerName = '';
        
        if(payerName == null || payerName.length() == 0 || payerName == '')
        	IsPayerNamePopulated = false;
        else
        {
        	IsPayerNamePopulated = true;
        	if(payerName.contains('#'))
        	{
        		payerID = payerName.substring(payerName.indexOf('#') + 1);
	        	payerName = payerName.substring(0, payerName.lastIndexOf(' '));
        	}
        }
        
        string patientFirstName = ParentAccount.FirstName != null ? ParentAccount.FirstName : '';
        string patientMiddleName = ''; //or middle initial
        string patientLastName = ParentAccount.LastName != null ? ParentAccount.LastName : '';
        
        
        Date patientDOBDate = ParentAccount.Date_of_birth__pc;
        string patientDOB = patientDOBDate != null ? patientDOBDate.format() : '';           
        string patientSSN = ParentCase.Contact_SSN__c != null ? ParentCase.Contact_SSN__c.Replace('-','') : ''; //9 byte 123456789
        
        string patientGender = ParentCase.Gender__c; //M/F
            if(patientGender =='Male')
                patientGender = 'M';
            else if(patientGender == 'Female')
                patientGender = 'F';
            else
                patientGender = '';
                
        string patientState = ParentAccount.BillingState != null ? ParentAccount.BillingState : ''; //2 byte, OR, CA, TN
        if(patientState.length() > 2)
        	patientState = patientState.substring(0,2);
            
        string policyHolderFirstName = ParentVOB.InsuredName__c != null ? ParentVOB.InsuredName__c : '';
        if(policyHolderFirstName.contains(' '))
        	policyHolderFirstName = policyHolderFirstName.substring(0, policyHolderFirstName.indexOf(' '));
            
        string policyHolderMiddleName = '';
        string policyHolderLastName = ParentVOB.InsuredName__c != null ? ParentVOB.InsuredName__c : '';
        if(policyHolderLastName.contains(' '))
        	policyHolderLastName = policyHolderLastName.substring(policyHolderLastName.lastIndexOf(' ') + 1);
       
        
        string policyHolderDOB = '';
        string insuredDOB = ParentVOB.InsuredDateOfBirth__c != null ? ParentVOB.InsuredDateOfBirth__c.format() : '';
            
        string policyHolderSSN = ParentVOB.InsuredSocialSecurityNumber__c != null ? ParentVOB.InsuredSocialSecurityNumber__c : '';
            
        string policyHolderGender = '';
        string policyHolderRelationship = ParentVOB.InsuredRelationshipToClient__c; 
        //18=self, 01=spouse, 19=child, 34=Other Adult
        if(policyHolderRelationship == 'Self')
            policyHolderRelationship = '18';
        else if(policyHolderRelationship == 'Spouse')
            policyHolderRelationship = '01';
        else if(policyHolderRelationship == 'Child')
            policyHolderRelationship = '19';
        else
            policyHolderRelationship = '34';
                
        string admitDate = ''; //mm/dd/yyyy
        string dischargeDate = '';//mm/dd/yyyy
        string policyID = ParentVOB.InsuranceID__c != null ? ParentVOB.InsuranceID__c : ''; //12345678901
        string groupID = ParentVOB.InsuranceGroupNumber__c != null ? ParentVOB.InsuranceGroupNumber__c : ''; //optional
        string amount = ''; //ddddd.dd  123.25
        string accountID = ParentVOB.Id != null ? ParentVOB.Id : ''; //customer assigned ID for tie back, VOB ID in SFDC?
        string passThrough = ParentCase.CaseNumber != null ? ParentCase.CaseNumber : ''; //optional, extra passthrough data here
        string sep = ';';
                       
        Request =  facilityTPG + sep + facilityName + sep + facilityNPI + sep + payerName + sep + payerID + sep + patientFirstName + sep + patientMiddleName + sep + patientLastName + sep +
                    patientDOB + sep + patientSSN + sep + patientGender + sep + patientState + sep + policyHolderFirstName + sep + policyHolderMiddleName
                    + sep + policyHolderLastName + sep + policyHolderDOB + sep + policyHolderSSN + sep + policyHolderGender + sep + policyHolderRelationship + sep
                    + admitDate + sep + dischargeDate + sep + policyID + sep + groupID + sep + accountID + sep + passThrough;
    	} 

    }
    public PageReference SaveEmdeonData()
    {
    	if(FinalResponse != null)
    	{
    		
    		
    		decimal dpy = FinalResponse.DeductiblePerYear == '' || FinalResponse.DeductiblePerYear == null ? 0 : decimal.valueOf(FinalResponse.DeductiblePerYear.trim());
    		decimal drm = FinalResponse.DeductibleRemain == '' || FinalResponse.DeductibleRemain == null ? 0 : decimal.valueOf(FinalResponse.DeductibleRemain.trim());
    		ParentVOB.SubstanceAbuseBenefitsCopay__c = dpy;
    		
    		decimal remaining = dpy - drm;
    		ParentVOB.SubstanceAbuseBenefitsCopayMet__c = remaining;
    		ParentVOB.SubstanceAbuseBenefitsOutOfPocket__c = FinalResponse.AnnualOOPMax == null || FinalResponse.AnnualOOPMax == '' ? 0 : decimal.valueOf(FinalResponse.AnnualOOPMax.trim());
    		decimal aoopmax = FinalResponse.AnnualOOPMax == null || FinalResponse.AnnualOOPMax == '' ? 0 : decimal.valueOf(FinalResponse.AnnualOOPMax.trim());
    		decimal aooprem = FinalResponse.AnnualOOPRem == null || FinalResponse.AnnualOOPRem == '' ? 0 : decimal.valueOf(FinalResponse.AnnualOOPRem.trim());
    		decimal remainingOOP = aoopmax - aooprem;
    		
    		
    		ParentVOB.SubstanceAbuseBenefitsOutOfPocketMet__c = remainingOOP;
    		string coIns = FinalResponse.CoIns == null || FinalResponse.CoIns == '' ? '0' : FinalResponse.CoIns.replace('%','').replace(' ','').replace('.','').trim();
    		decimal coInsDec = decimal.valueOf(coIns);
    		ParentVOB.SubstanceAbuseDTXPercentage__c = 100 - coInsDec;
    		ParentVOB.InsuredName__c = FinalResponse.SubFName + ' ' + FinalResponse.SubLName;
    		ParentVOB.InsuredEmployer__c = FinalResponse.GroupNum;
    		ParentVOB.InsuranceCompany__c = FinalResponse.PayerName;
    		ParentVOB.TypeOfPlan__c = FinalResponse.PlanCvg;
    		ParentVOB.InsuranceID__c = FinalResponse.SubID;
    		ParentVOB.InsuranceGroupNumber__c = FinalResponse.GroupNum;
    		string planBeginDate = FinalResponse.PlanBegin == null || FinalResponse.PlanBegin == '' ? '' : FinalResponse.PlanBegin.trim();
    		if(planBeginDate != null && planBeginDate != '')
    		{
    			string[] dateParts = planBeginDate.split('/');
    			string newDateFormat = dateParts[2] + '-' + dateParts[1] + '-' + dateParts[0];
    			ParentVOB.PolicyEffectiveDate__c = date.valueOf(newDateFormat);
    		}
    			
    		
    		if(FinalResponse.Coverage == 'Active')
    			ParentVOB.PolicyIsActive__c = true;
    		else
    			ParentVOB.PolicyIsActive__c = false;
    		
    		ParentVOB.Verified_Through_Emdeon__c = true;
    		ParentVOB.Verified_Through_Emdeon_Date__c = datetime.now();
    		ParentVOB.Verified_Through_Emdeon_User__c = UserInfo.getName();
    		DisplayEmdeonBlock = false;
    		update ParentVOB;
    		
    	}
    	
    	PageReference page = new PageReference('/' + ParentVOB.Id);            
    	page.setRedirect(true);     
    	return page;  
    }
    
    public PageReference GetEmdeonData()
    {
    	if(IsPayerNamePopulated == true)
    	{
	        try
	        {   
	            EmdeonWebService.AWSSoap service = new EmdeonWebService.AWSSoap();
	            service.timeout_x = 90000;
	            //Username: RATNAACGH
	            //Password: nG98Zxy4
	            
	            string encodedRequest = EncodingUtil.base64Encode(Blob.valueOf(Request));
	            Response = service.RunTransaction('RATNAACGH','nG98Zxy4',encodedRequest);
	            Blob respBlob = EncodingUtil.base64Decode(Response);
	            Response = respBlob.toString();
	            
	            List<string> responseSplit = Response.split(';');
	            if(responseSplit.size() == 0)
	            {
	            	for(integer i = 0; i < 105; i++)
	            	{
	            		responseSplit.add(string.valueOf(i));
	            	}
	            }
					
	            EmdeonResponse emdeonResponse = new EmdeonResponse();
	            emdeonResponse.DataSource = responseSplit[0];
	            emdeonResponse.AcctNum = responseSplit[1];
				emdeonResponse.Remarks = responseSplit[2];
				emdeonResponse.Status = responseSplit[3];
				emdeonResponse.PayerID = responseSplit[4];
				emdeonResponse.PayerName = responseSplit[5];
				emdeonResponse.ErrorCode = responseSplit[6];
				emdeonResponse.ErrorMsg = responseSplit[7];
				emdeonResponse.BeneFlag = responseSplit[8];
				emdeonResponse.MEDXFlag = responseSplit[9];
				emdeonResponse.TPLFlag = responseSplit[10];
				emdeonResponse.SubID = responseSplit[11];
				emdeonResponse.SubLName = responseSplit[12];
				emdeonResponse.SubFName = responseSplit[13];
				emdeonResponse.SubMName = responseSplit[14];
				emdeonResponse.SubSSN = responseSplit[15];
				emdeonResponse.SubDOB = responseSplit[16];
				emdeonResponse.SubGender = responseSplit[17];
				emdeonResponse.DepLName = responseSplit[18];
				emdeonResponse.DepFName = responseSplit[19];
				emdeonResponse.DepMName = responseSplit[20];
				emdeonResponse.DepSSN = responseSplit[21];
				emdeonResponse.DepDOB = responseSplit[22];
				emdeonResponse.DepGender = responseSplit[23];
				emdeonResponse.Address1 = responseSplit[24];
				emdeonResponse.Address2 = responseSplit[25];
				emdeonResponse.AddressCity = responseSplit[26];
				emdeonResponse.AddressState = responseSplit[27];
				emdeonResponse.AddressZip = responseSplit[28];
				emdeonResponse.Admit = responseSplit[29];
				emdeonResponse.Discharge = responseSplit[30];
				emdeonResponse.EffDate = responseSplit[31];
				emdeonResponse.ExpDate = responseSplit[32];
				emdeonResponse.EligBegin = responseSplit[33];
				emdeonResponse.EligEnd = responseSplit[34];
				emdeonResponse.Coverage = responseSplit[35];
				emdeonResponse.InsType = responseSplit[36];
				emdeonResponse.PlanCvg = responseSplit[37];
				emdeonResponse.PlanBegin = responseSplit[38];
				emdeonResponse.PlanEnd = responseSplit[39];
				emdeonResponse.Message1 = responseSplit[40];
				emdeonResponse.Message2 = responseSplit[41];
				emdeonResponse.PlanCvg2 = responseSplit[42];
				emdeonResponse.Plan2Begin = responseSplit[43];
				emdeonResponse.Plan2End = responseSplit[44];
				emdeonResponse.Plan2Msg1 = responseSplit[45];
				emdeonResponse.Plan2Msg2 = responseSplit[46];
				emdeonResponse.GroupNum = responseSplit[47];
				emdeonResponse.GroupName = responseSplit[48];
				emdeonResponse.HIC = responseSplit[49];
				emdeonResponse.MEDXMSG = responseSplit[50];
				emdeonResponse.MCOType = responseSplit[51];
				emdeonResponse.MCOName = responseSplit[52];
				emdeonResponse.MCOID = responseSplit[53];
				emdeonResponse.PCPName = responseSplit[54];
				emdeonResponse.PCPPhone = responseSplit[55];
				emdeonResponse.SvcsRestricted = responseSplit[56];
				emdeonResponse.SvcsRestrictedSvcType = responseSplit[57];
				emdeonResponse.SvcsRestrictedProvName = responseSplit[58];
				emdeonResponse.PlanSponsorName = responseSplit[59];
				emdeonResponse.PlanSponsorPhone = responseSplit[60];
				emdeonResponse.SpendDown = responseSplit[61];
				emdeonResponse.DeductiblePerYear = responseSplit[62];
				emdeonResponse.DeductibleRemain = responseSplit[63];
				emdeonResponse.AnnualOOPMax = responseSplit[64];
				emdeonResponse.AnnualOOPRem = responseSplit[65];
				emdeonResponse.LifetimeMax = responseSplit[66];
				emdeonResponse.LifetimeRem = responseSplit[67];
				emdeonResponse.HomeHealthVisits = responseSplit[68];
				emdeonResponse.OutpatientDollars = responseSplit[69];
				emdeonResponse.InpatientDays = responseSplit[70];
				emdeonResponse.OP1CvgType = responseSplit[71];
				emdeonResponse.OP1CvgDesc = responseSplit[72];
				emdeonResponse.OP1PolicyPlanID = responseSplit[73];
				emdeonResponse.OP1COBDate = responseSplit[74];
				emdeonResponse.OP1Type = responseSplit[75];
				emdeonResponse.OP1LName = responseSplit[76];
				emdeonResponse.OP1FName = responseSplit[77];
				emdeonResponse.OP1Contact = responseSplit[78];
				emdeonResponse.OP1Phone = responseSplit[79];
				emdeonResponse.OP1Add1 = responseSplit[80];
				emdeonResponse.OP1Add2 = responseSplit[81];
				emdeonResponse.OP1AddC = responseSplit[82];
				emdeonResponse.OP1AddS = responseSplit[83];
				emdeonResponse.OP1AddZ = responseSplit[84];
				emdeonResponse.OP2CvgType = responseSplit[85];
				emdeonResponse.OP2CvgDesc = responseSplit[86];
				emdeonResponse.OP2PolicyPlanID = responseSplit[87];
				emdeonResponse.OP2COBDate = responseSplit[88];
				emdeonResponse.OP2Type = responseSplit[89];
				emdeonResponse.OP2LName = responseSplit[90];
				emdeonResponse.OP2FName = responseSplit[91];
				emdeonResponse.OP2Contact = responseSplit[92];
				emdeonResponse.OP2Phone = responseSplit[93];
				emdeonResponse.OP2Add1 = responseSplit[94];
				emdeonResponse.OP2Add2 = responseSplit[95];
				emdeonResponse.OP2AddC = responseSplit[96];
				emdeonResponse.OP2AddS = responseSplit[97];
				emdeonResponse.OP2AddZ = responseSplit[98];
				emdeonResponse.COIns = responseSplit[99];
				emdeonResponse.TraceNum = responseSplit[100];
				emdeonResponse.InputTRN = responseSplit[101];
				emdeonResponse.ProcessDate = responseSplit[102];
				emdeonResponse.ProcessTime = responseSplit[103];
				//emdeonResponse.OriginalPayer271 = responseSplit[103];
				FinalResponse = emdeonResponse;
				DisplayResponse = true;
				if(ParentVOB.Verified_Through_Emdeon__c == false)
					DisplaySaveButton = true;
	            return null;
	        }
	        catch(Exception e)
	        {
	            Response = e + '';
	            return null;
	        }
    	}
    	else
    	{
    		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Insurance Company must be selected before you can trigger an Insurance Lookup.'));
    		return null;
    	}
    }
    private static testMethod void TestEdmeonRequest()
    {
        Account a = new Account();
        a.FirstName = 'Test';
        a.LastName = 'Test';
        a.SSN__pc = '111111111';
        a.Date_of_Birth__pc = date.valueOf('1980-01-01');
        a.BillingState = 'CA';
        a.Phone = '1231231234';
        insert a;
        
        Case c = new Case();
        c.AccountId = a.Id;
        c.Gender__c = 'Male';
        insert c;
        
        InsuranceVerificationForm__c i = new InsuranceVerificationForm__c();
        i.Case__c = c.Id;
        i.InsuranceCompany__c = 'Cigna';
        i.InsuredName__c = 'John Smith';
        i.InsuredDateOfBirth__c = date.valueOf('1980-01-01');
        i.InsuredSocialSecurityNumber__c = '111111111';
        i.InsuredRelationshipToClient__c = 'Spouse';
        i.InsuranceID__c = '1231231234';
        i.InsuranceGroupNumber__c = '225576';
        insert i;
        
        
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EmdeonWebService.MyWebServiceMock());
        ApexPages.standardController controller = new ApexPages.standardController(i);
        Emdeon service = new Emdeon(controller);
        service.GetEmdeonData();
        
        i.InsuredRelationshipToClient__c = 'Self';
        update i;
        service = new Emdeon(controller);
        service.GetEmdeonData();
        
        i.InsuredRelationshipToClient__c = 'Child';
        update i;
        service = new Emdeon(controller);
        service.GetEmdeonData();
                
        i.InsuredRelationshipToClient__c = 'Other';
        update i;
        service = new Emdeon(controller);
        service.GetEmdeonData();
       
       	i.Insurance_Company_Emdeon__c = 'Optima Health #OPTMA';
       	update i;
		service = new Emdeon(controller);
        service.GetEmdeonData();

        string[] responseSplit = new string[105];
        	
        EmdeonResponse emdeonResponse = new EmdeonResponse();
        emdeonResponse.DataSource = responseSplit[0];
        emdeonResponse.AcctNum = responseSplit[1];
		emdeonResponse.Remarks = responseSplit[2];
		emdeonResponse.Status = responseSplit[3];
		emdeonResponse.PayerID = responseSplit[4];
		emdeonResponse.PayerName = responseSplit[5];
		emdeonResponse.ErrorCode = responseSplit[6];
		emdeonResponse.ErrorMsg = responseSplit[7];
		emdeonResponse.BeneFlag = responseSplit[8];
		emdeonResponse.MEDXFlag = responseSplit[9];
		emdeonResponse.TPLFlag = responseSplit[10];
		emdeonResponse.SubID = responseSplit[11];
		emdeonResponse.SubLName = responseSplit[12];
		emdeonResponse.SubFName = responseSplit[13];
		emdeonResponse.SubMName = responseSplit[14];
		emdeonResponse.SubSSN = responseSplit[15];
		emdeonResponse.SubDOB = responseSplit[16];
		emdeonResponse.SubGender = responseSplit[17];
		emdeonResponse.DepLName = responseSplit[18];
		emdeonResponse.DepFName = responseSplit[19];
		emdeonResponse.DepMName = responseSplit[20];
		emdeonResponse.DepSSN = responseSplit[21];
		emdeonResponse.DepDOB = responseSplit[22];
		emdeonResponse.DepGender = responseSplit[23];
		emdeonResponse.Address1 = responseSplit[24];
		emdeonResponse.Address2 = responseSplit[25];
		emdeonResponse.AddressCity = responseSplit[26];
		emdeonResponse.AddressState = responseSplit[27];
		emdeonResponse.AddressZip = responseSplit[28];
		emdeonResponse.Admit = responseSplit[29];
		emdeonResponse.Discharge = responseSplit[30];
		emdeonResponse.EffDate = responseSplit[31];
		emdeonResponse.ExpDate = responseSplit[32];
		emdeonResponse.EligBegin = responseSplit[33];
		emdeonResponse.EligEnd = responseSplit[34];
		emdeonResponse.Coverage = responseSplit[35];
		emdeonResponse.InsType = responseSplit[36];
		emdeonResponse.PlanCvg = responseSplit[37];
		emdeonResponse.PlanBegin = responseSplit[38];
		emdeonResponse.PlanEnd = responseSplit[39];
		emdeonResponse.Message1 = responseSplit[40];
		emdeonResponse.Message2 = responseSplit[41];
		emdeonResponse.PlanCvg2 = responseSplit[42];
		emdeonResponse.Plan2Begin = responseSplit[43];
		emdeonResponse.Plan2End = responseSplit[44];
		emdeonResponse.Plan2Msg1 = responseSplit[45];
		emdeonResponse.Plan2Msg2 = responseSplit[46];
		emdeonResponse.GroupNum = responseSplit[47];
		emdeonResponse.GroupName = responseSplit[48];
		emdeonResponse.HIC = responseSplit[49];
		emdeonResponse.MEDXMSG = responseSplit[50];
		emdeonResponse.MCOType = responseSplit[51];
		emdeonResponse.MCOName = responseSplit[52];
		emdeonResponse.MCOID = responseSplit[53];
		emdeonResponse.PCPName = responseSplit[54];
		emdeonResponse.PCPPhone = responseSplit[55];
		emdeonResponse.SvcsRestricted = responseSplit[56];
		emdeonResponse.SvcsRestrictedSvcType = responseSplit[57];
		emdeonResponse.SvcsRestrictedProvName = responseSplit[58];
		emdeonResponse.PlanSponsorName = responseSplit[59];
		emdeonResponse.PlanSponsorPhone = responseSplit[60];
		emdeonResponse.SpendDown = responseSplit[61];
		emdeonResponse.DeductiblePerYear = responseSplit[62];
		emdeonResponse.DeductibleRemain = responseSplit[63];
		emdeonResponse.AnnualOOPMax = responseSplit[64];
		emdeonResponse.AnnualOOPRem = responseSplit[65];
		emdeonResponse.LifetimeMax = responseSplit[66];
		emdeonResponse.LifetimeRem = responseSplit[67];
		emdeonResponse.HomeHealthVisits = responseSplit[68];
		emdeonResponse.OutpatientDollars = responseSplit[69];
		emdeonResponse.InpatientDays = responseSplit[70];
		emdeonResponse.OP1CvgType = responseSplit[71];
		emdeonResponse.OP1CvgDesc = responseSplit[72];
		emdeonResponse.OP1PolicyPlanID = responseSplit[73];
		emdeonResponse.OP1COBDate = responseSplit[74];
		emdeonResponse.OP1Type = responseSplit[75];
		emdeonResponse.OP1LName = responseSplit[76];
		emdeonResponse.OP1FName = responseSplit[77];
		emdeonResponse.OP1Contact = responseSplit[78];
		emdeonResponse.OP1Phone = responseSplit[79];
		emdeonResponse.OP1Add1 = responseSplit[80];
		emdeonResponse.OP1Add2 = responseSplit[81];
		emdeonResponse.OP1AddC = responseSplit[82];
		emdeonResponse.OP1AddS = responseSplit[83];
		emdeonResponse.OP1AddZ = responseSplit[84];
		emdeonResponse.OP2CvgType = responseSplit[85];
		emdeonResponse.OP2CvgDesc = responseSplit[86];
		emdeonResponse.OP2PolicyPlanID = responseSplit[87];
		emdeonResponse.OP2COBDate = responseSplit[88];
		emdeonResponse.OP2Type = responseSplit[89];
		emdeonResponse.OP2LName = responseSplit[90];
		emdeonResponse.OP2FName = responseSplit[91];
		emdeonResponse.OP2Contact = responseSplit[92];
		emdeonResponse.OP2Phone = responseSplit[93];
		emdeonResponse.OP2Add1 = responseSplit[94];
		emdeonResponse.OP2Add2 = responseSplit[95];
		emdeonResponse.OP2AddC = responseSplit[96];
		emdeonResponse.OP2AddS = responseSplit[97];
		emdeonResponse.OP2AddZ = responseSplit[98];
		emdeonResponse.CoIns = responseSplit[99];
		emdeonResponse.TraceNum = responseSplit[100];
		emdeonResponse.InputTRN = responseSplit[101];
		emdeonResponse.ProcessDate = responseSplit[102];
		emdeonResponse.ProcessTime = responseSplit[103];
		emdeonResponse.OriginalPayer271 = responseSplit[104];

		service.SaveEmdeonData();

        Test.stopTest();
    }
    public class EmdeonResponse
    {
    	public string DataSource{ get;set; } //Responding Entity Indicator
		public string AcctNum{ get;set; } //Submitted transaction/account ID
		public string Remarks{ get;set; } //Submitted Pass-through value
		public string Status{ get;set; } //System Generated Workflow indicator. (CVD = Active benefits, ERR = System/payer error returned or inactive benefits, LIM = Benefit Limitations Returned, OPP = Other Primary Payer Returned)
		public string PayerID{ get;set; } //Responding Payer ID
		public string PayerName{ get;set; } //Responding Payer Name
		public string ErrorCode{ get;set; } //Emdeon Assigned Error code representing ErrorMsg
		public string ErrorMsg{ get;set; } //"Code - Description" of Error Message Returned by Payer
		public string BeneFlag{ get;set; } //Benefit Flag  (Y = Active Benefits , N= Inactive Benefits, Q= QMB,  S= Spenddown)
		public string MEDXFlag{ get;set; } //Medicare Benefit Flag (A/B/AB/NA)
		public string TPLFlag{ get;set; } //Other Payer Flag  (Y/N/NA/Null)
		public string SubID{ get;set; } //Subscriber/Insured ID
		public string SubLName{ get;set; } //Subscriber/Insured Last Name
		public string SubFName{ get;set; } //Subscriber/Insured First Name
		public string SubMName{ get;set; } //Subscriber/Insured Middle Name
		public string SubSSN{ get;set; } //Subscriber/Insured Social Security Number
		public string SubDOB{ get;set; } //Subscriber/Insured Date of Birth
		public string SubGender{ get;set; } //Subscriber/Insured Gender (M/F/U/Blank)
		public string DepLName{ get;set; } //Dependent Last Name
		public string DepFName{ get;set; } //Dependent First Name
		public string DepMName{ get;set; } //Dependent Middle Name
		public string DepSSN{ get;set; } //Dependent Social Security Number
		public string DepDOB{ get;set; } //Dependent Date of Birth
		public string DepGender{ get;set; } //Dependent Gender (M/F/U/Blank)
		public string Address1{ get;set; } //Subscriber/Insured Street Address 1
		public string Address2{ get;set; } //Subscriber/Insured Street Address 2
		public string AddressCity{ get;set; } //Subscriber/Insured City
		public string AddressState{ get;set; } //Subscriber/Insured State
		public string AddressZip{ get;set; } //Subscriber/Insured Zipcode (5 or 9 byte)
		public string Admit{ get;set; } //Beginning Date of Service/Date of Inquiry
		public string Discharge{ get;set; } //Ending Date of Service
		public string EffDate{ get;set; } //Policy Start Date
		public string ExpDate{ get;set; } //Policy End Date
		public string EligBegin{ get;set; } //Eligibility Begin Date or Date of Service
		public string EligEnd{ get;set; } //Eligibility End Date or Date of Service
		public string Coverage{ get;set; } //Coverage Status
		public string InsType{ get;set; } //Insurance Plan Type
		public string PlanCvg{ get;set; } //Covered Plan Name
		public string PlanBegin{ get;set; } //Program Start Date
		public string PlanEnd{ get;set; } //Program End Date
		public string Message1{ get;set; } //Payer provided Message 1 (Text)
		public string Message2{ get;set; } //Payer provided Message 2 (Text)
		public string PlanCvg2{ get;set; } //Covered Plan Name 2
		public string Plan2Begin{ get;set; } //Program Start Date 2
		public string Plan2End{ get;set; } //Program End Date 2
		public string Plan2Msg1{ get;set; } //Payer provided Message 1 (Text) 2
		public string Plan2Msg2{ get;set; } //Payer provided Message 2 (Text) 2
		public string GroupNum{ get;set; } //Plan/Group Number
		public string GroupName{ get;set; } //Plan/Group Name
		public string HIC{ get;set; } //Medicare HIC Number
		public string MEDXMSG{ get;set; } //Medicare Benefit Type/Message
		public string MCOType{ get;set; } //Managed Care Organization Type
		public string MCOName{ get;set; } //Managed Care Organization Name
		public string MCOID{ get;set; } //Managed Care Organization Policy or Plan ID
		public string PCPName{ get;set; } //Primary Care Provider Name
		public string PCPPhone{ get;set; } //Primary Care Provider Phone Number
		public string SvcsRestricted{ get;set; } //Service Restriction Indicator
		public string SvcsRestrictedSvcType{ get;set; } //Restrict Service Type
		public string SvcsRestrictedProvName{ get;set; } //Restricted Provider Name
		public string PlanSponsorName{ get;set; } //Plan Sponsor Name
		public string PlanSponsorPhone{ get;set; } //Plan Sponsor Phone
		public string SpendDown{ get;set; } //Spend Down (Medicaid)
		public string DeductiblePerYear{ get;set; } //Deductible Per Year
		public string DeductibleRemain{ get;set; } //Deductible Remaining
		public string AnnualOOPMax{ get;set; } //Annual Out of Pocket Max
		public string AnnualOOPRem{ get;set; } //Annual Out of Pocket Remaining
		public string LifetimeMax{ get;set; } //Lifetime Out of Pocket Max
		public string LifetimeRem{ get;set; } //Lifetime Out of Pocket Remaining
		public string HomeHealthVisits{ get;set; } //Home Health Visits Remaining
		public string OutpatientDollars{ get;set; } //Out Patient Dollars Remaining
		public string InpatientDays{ get;set; } //In Patient Days Remaining
		public string OP1CvgType{ get;set; } //Other Payer Coverage Type
		public string OP1CvgDesc{ get;set; } //Other Payer Coverage Description
		public string OP1PolicyPlanID{ get;set; } //Other Payer Policy\Plan ID
		public string OP1COBDate{ get;set; } //Other Payer COB Date
		public string OP1Type{ get;set; } //Other Payer Enity Type
		public string OP1LName{ get;set; } //Other Payer Enity Name or Last Name
		public string OP1FName{ get;set; } //Other Payer Enity First Name
		public string OP1Contact{ get;set; } //Other Payer Contact Name
		public string OP1Phone{ get;set; } //Other Payer Phone Number
		public string OP1Add1{ get;set; } //Other Payer Street Address 1
		public string OP1Add2{ get;set; } //Other Payer Street Address 2
		public string OP1AddC{ get;set; } //Other Payer City
		public string OP1AddS{ get;set; } //Other Payer State
		public string OP1AddZ{ get;set; } //Other Payer Zipcode (5 or 9 byte)
		public string OP2CvgType{ get;set; } //Other Payer 2 Coverage Type
		public string OP2CvgDesc{ get;set; } //Other Payer 2 Coverage Description
		public string OP2PolicyPlanID{ get;set; } //Other Payer 2 Policy\Plan ID
		public string OP2COBDate{ get;set; } //Other Payer 2 COB Date
		public string OP2Type{ get;set; } //Other Payer 2 Enity Type
		public string OP2LName{ get;set; } //Other Payer 2 Enity Name or Last Name
		public string OP2FName{ get;set; } //Other Payer 2 Enity First Name
		public string OP2Contact{ get;set; } //Other Payer 2 Contact Name
		public string OP2Phone{ get;set; } //Other Payer 2 Phone Number
		public string OP2Add1{ get;set; } //Other Payer 2 Street Address 1
		public string OP2Add2{ get;set; } //Other Payer 2 Street Address 2
		public string OP2AddC{ get;set; } //Other Payer 2 City
		public string OP2AddS{ get;set; } //Other Payer 2 State
		public string OP2AddZ{ get;set; } //Other Payer 2 Zipcode (5 or 9 byte)
		public string CoIns {get;set;} //Co-INS
		public string TraceNum{ get;set; } //Emdeon Generated Transaction ID
		
		public string InputTRN{ get;set; } //Submitter Transaction ID
		public string ProcessDate{ get;set; } //Process Date
		public string ProcessTime{ get;set; } //Process Time
		public string OriginalPayer271{ get;set; } //<X12 271>
		
		public EmdeonResponse()
		{
			this.DataSource = '0';
	        this.AcctNum = '1';
			this.Remarks = '2';
			this.Status = '3';
			this.PayerID = '4';
			this.PayerName = '5';
			this.ErrorCode = '6';
			this.ErrorMsg = '7';
			this.BeneFlag = '8';
			this.MEDXFlag = '9';
			this.TPLFlag = '10';
			this.SubID = '11';
			this.SubLName = '12';
			this.SubFName = '13';
			this.SubMName = '14';
			this.SubSSN = '15';
			this.SubDOB = '16';
			this.SubGender = '17';
			this.DepLName = '18';
			this.DepFName = '19';
			this.DepMName = '20';
			this.DepSSN = '21';
			this.DepDOB = '22';
			this.DepGender = '23';
			this.Address1 = '24';
			this.Address2 = '25';
			this.AddressCity = '26';
			this.AddressState = '27';
			this.AddressZip = '28';
			this.Admit = '29';
			this.Discharge = '30';
			this.EffDate = '31';
			this.ExpDate = '32';
			this.EligBegin = '33';
			this.EligEnd = '34';
			this.Coverage = '35';
			this.InsType = '36';
			this.PlanCvg = '37';
			this.PlanBegin = '38';
			this.PlanEnd = '39';
			this.Message1 = '40';
			this.Message2 = '41';
			this.PlanCvg2 = '42';
			this.Plan2Begin = '43';
			this.Plan2End = '44';
			this.Plan2Msg1 = '45';
			this.Plan2Msg2 = '46';
			this.GroupNum = '47';
			this.GroupName = '48';
			this.HIC = '49';
			this.MEDXMSG = '50';
			this.MCOType = '51';
			this.MCOName = '52';
			this.MCOID = '53';
			this.PCPName = '54';
			this.PCPPhone = '55';
			this.SvcsRestricted = '56';
			this.SvcsRestrictedSvcType = '57';
			this.SvcsRestrictedProvName = '58';
			this.PlanSponsorName = '59';
			this.PlanSponsorPhone = '60';
			this.SpendDown = '61';
			this.DeductiblePerYear = '62';
			this.DeductibleRemain = '63';
			this.AnnualOOPMax = '64';
			this.AnnualOOPRem = '65';
			this.LifetimeMax = '66';
			this.LifetimeRem = '67';
			this.HomeHealthVisits = '68';
			this.OutpatientDollars = '69';
			this.InpatientDays = '70';
			this.OP1CvgType = '71';
			this.OP1CvgDesc = '72';
			this.OP1PolicyPlanID = '73';
			this.OP1COBDate = '74';
			this.OP1Type = '75';
			this.OP1LName = '76';
			this.OP1FName = '77';
			this.OP1Contact = '78';
			this.OP1Phone = '79';
			this.OP1Add1 = '80';
			this.OP1Add2 = '81';
			this.OP1AddC = '82';
			this.OP1AddS = '83';
			this.OP1AddZ = '84';
			this.OP2CvgType = '85';
			this.OP2CvgDesc = '86';
			this.OP2PolicyPlanID = '87';
			this.OP2COBDate = '88';
			this.OP2Type = '89';
			this.OP2LName = '90';
			this.OP2FName = '91';
			this.OP2Contact = '92';
			this.OP2Phone = '93';
			this.OP2Add1 = '94';
			this.OP2Add2 = '95';
			this.OP2AddC = '96';
			this.OP2AddS = '97';
			this.OP2AddZ = '98';
			this.CoIns = '99';
			this.TraceNum = '100';
			this.InputTRN = '101';
			this.ProcessDate = '102';
			this.ProcessTime = '103';
			this.OriginalPayer271 = '104';
		}
    	
    }
}