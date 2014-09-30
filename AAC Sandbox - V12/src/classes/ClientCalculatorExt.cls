public class ClientCalculatorExt {
public Client_Calculator__c Calc {get;set;}
public InsuranceVerificationForm__c InsuranceForm {get;set;}
public Facility__c SelectedFacility {get;set;}
public string CaseNumber {get; set;}
public string CaseId {get; set;}
public string SelectedFacilityName {get;set;}
public decimal FacilityDayRate {get;set;}
public decimal ClientPortionNeededForTreatment{get;set;}



public ClientCalculatorExt(ApexPages.StandardController controller)
{
    try
    {
        if(ApexPages.currentPage().getParameters().get('insuranceid') != null)
         {       
            Calc = getCalculator('insuranceid',ApexPages.currentPage().getParameters().get('insuranceid'));
            CaseNumber = Calc.Case__r.CaseNumber;
            CaseId = Calc.Case__r.Id;             
         }            
        else if(ApexPages.currentPage().getParameters().get('caseid') != null)
         {       
            Calc = getCalculator('caseid',ApexPages.currentPage().getParameters().get('caseid'));          
            CaseNumber = Calc.Case__r.CaseNumber;
            CaseId = Calc.Case__r.Id;                         
         }            
        else if(ApexPages.currentPage().getParameters().get('id') != null)
        {        
            Calc = getCalculator('id',ApexPages.currentPage().getParameters().get('id'));
            CaseNumber = Calc.Case__r.CaseNumber;
            CaseId = Calc.Case__r.Id;            
        }            
        else        
            Calc = new Client_Calculator__c();        
    }   
    catch(Exception e)
    {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Loading error: ' + e + '\r\nCalc Id: ' + ApexPages.currentPage().getParameters().get('id') + '\r\n InsuranceId: ' + ApexPages.currentPage().getParameters().get('insuranceid') + '\r\n CaseId: ' + ApexPages.currentPage().getParameters().get('caseid')));
    }  
}

public Client_Calculator__c getCalculator(string searchType, string searchValue)
{
    if(searchType == 'id')
    {
      return [SELECT Name, Case__c,Case__r.Id,Case__r.CaseNumber,Plan_Maximum__c,  Client_Deductible__c, CoPays__c, CreatedById, CreatedDate, DTX_Client_Portion__c, DTX_Co_Ins__c, DTX_Days__c, DTX_Rate__c, DTX_Subtotal__c, Daily_Net_Revenue__c, Deductible_Met__c, IsDeleted, Estimated_Insurance_Dollars_Received__c, Grand_Total__c, IOP_Client_Portion__c, IOP_Co_Ins__c, IOP_Days__c, IOP_Rate__c, IOP_Subtotal__c, IP_RTC_Client_Portion__c, IP_RTC_Co_Ins__c, IP_RTC_Days__c, IP_RTC_Rate__c, IP_RTC_Subtotal__c, Insurance_Verification_Form__c, LastModifiedById, LastModifiedDate, Lifetime_Maximum__c, Non_covered_Ancillary__c, OP_Client_Portion__c, OP_Co_Ins__c, OP_Days__c, OP_Rate__c, OP_Subtotal__c, Out_of_Pocket_Maximum__c, Out_of_Pocket_Met__c, OwnerId, PHP_Client_Portion__c, PHP_Co_Ins__c, PHP_Days__c, PHP_Rate__c, PHP_Subtotal__c, RES_Client_Portion__c, RES_Co_Ins__c, RES_Days__c, RES_Rate__c, RES_Subtotal__c, Id, SystemModstamp, Total_Client_Contribution__c, Total_Client_Portion__c, Total_Days__c FROM Client_Calculator__c WHERE Id = :searchValue];     
    }
    else if(searchType == 'insuranceid')
    {
      return [SELECT Name, Case__c,Case__r.Id,Case__r.CaseNumber,Plan_Maximum__c,  Client_Deductible__c, CoPays__c, CreatedById, CreatedDate, DTX_Client_Portion__c, DTX_Co_Ins__c, DTX_Days__c, DTX_Rate__c, DTX_Subtotal__c, Daily_Net_Revenue__c, Deductible_Met__c, IsDeleted, Estimated_Insurance_Dollars_Received__c, Grand_Total__c, IOP_Client_Portion__c, IOP_Co_Ins__c, IOP_Days__c, IOP_Rate__c, IOP_Subtotal__c, IP_RTC_Client_Portion__c, IP_RTC_Co_Ins__c, IP_RTC_Days__c, IP_RTC_Rate__c, IP_RTC_Subtotal__c, Insurance_Verification_Form__c, LastModifiedById, LastModifiedDate, Lifetime_Maximum__c, Non_covered_Ancillary__c, OP_Client_Portion__c, OP_Co_Ins__c, OP_Days__c, OP_Rate__c, OP_Subtotal__c, Out_of_Pocket_Maximum__c, Out_of_Pocket_Met__c, OwnerId, PHP_Client_Portion__c, PHP_Co_Ins__c, PHP_Days__c, PHP_Rate__c, PHP_Subtotal__c, RES_Client_Portion__c, RES_Co_Ins__c, RES_Days__c, RES_Rate__c, RES_Subtotal__c, Id, SystemModstamp, Total_Client_Contribution__c, Total_Client_Portion__c, Total_Days__c FROM Client_Calculator__c WHERE Insurance_Verification_Form__c = :searchValue];                 
    }
    else if(searchType == 'caseid')
    {
      return [SELECT Name, Case__c,Case__r.Id,Case__r.CaseNumber,Plan_Maximum__c,  Client_Deductible__c, CoPays__c, CreatedById, CreatedDate, DTX_Client_Portion__c, DTX_Co_Ins__c, DTX_Days__c, DTX_Rate__c, DTX_Subtotal__c, Daily_Net_Revenue__c, Deductible_Met__c, IsDeleted, Estimated_Insurance_Dollars_Received__c, Grand_Total__c, IOP_Client_Portion__c, IOP_Co_Ins__c, IOP_Days__c, IOP_Rate__c, IOP_Subtotal__c, IP_RTC_Client_Portion__c, IP_RTC_Co_Ins__c, IP_RTC_Days__c, IP_RTC_Rate__c, IP_RTC_Subtotal__c, Insurance_Verification_Form__c, LastModifiedById, LastModifiedDate, Lifetime_Maximum__c, Non_covered_Ancillary__c, OP_Client_Portion__c, OP_Co_Ins__c, OP_Days__c, OP_Rate__c, OP_Subtotal__c, Out_of_Pocket_Maximum__c, Out_of_Pocket_Met__c, OwnerId, PHP_Client_Portion__c, PHP_Co_Ins__c, PHP_Days__c, PHP_Rate__c, PHP_Subtotal__c, RES_Client_Portion__c, RES_Co_Ins__c, RES_Days__c, RES_Rate__c, RES_Subtotal__c, Id, SystemModstamp, Total_Client_Contribution__c, Total_Client_Portion__c, Total_Days__c FROM Client_Calculator__c WHERE Case__c = :searchValue];         
    }
    else
    {
     return null;    
    }    
}

public InsuranceVerificationForm__c getInsuranceForm()
{
    try{
        InsuranceForm = [select Id, 
                        Name,
                        Case__c,
                        Case__r.Id, Case__r.CaseNumber,
                        SubstanceAbuseDTXCopay__c,
                        SubstanceAbuseDTXPercentage__c,
                        SubstanceAbuseDTXDaysUsed__c,
                        SubstanceAbuseDTXLifetimeMax__c,
                        SubstanceAbuseDTXLifeTimeUsed__c,
                        Plan_Maximum__c,
                        SubstanceAbuseIOPCopay__c,
                        SubstanceAbuseIOPPercentage__c,
                        SubstanceAbuseIOPDaysUsed__c,
                        SubstanceAbuseIOPLifetimeMax__c,
                        SubstanceAbuseIOPLifeTimeUsed__c,
                        
                        SubstanceAbuseIPCopay__c,
                        SubstanceAbuseIPPercentage__c,
                        SubstanceAbuseIPDaysUsed__c,
                        SubstanceAbuseIPLifetimeMax__c,
                        SubstanceAbuseIPLifeTimeUsed__c,
                        
                        SubstanceAbuseOPCopay__c,
                        SubstanceAbuseOPPercentage__c,
                        SubstanceAbuseOPDaysUsed__c,
                        SubstanceAbuseOPLifetimeMax__c,
                        SubstanceAbuseOPLifeTimeUsed__c,
                        
                        SubstanceAbusePHPCopay__c,
                        SubstanceAbusePHPPercentage__c,
                        SubstanceAbusePHPDaysUsed__c,
                        SubstanceAbusePHPLifetimeMax__c,
                        SubstanceAbusePHPLifeTimeUsed__c,
                        
                        SubstanceAbuseRESCopay__c,
                        SubstanceAbuseRESPercentage__c,
                        SubstanceAbuseRESDaysUsed__c,
                        SubstanceAbuseRESLifetimeMax__c,
                        SubstanceAbuseRESLifeTimeUsed__c,
                        
                        SubstanceAbuseBenefitsCopay__c,
                        SubstanceAbuseBenefitsCopayMet__c,
                        SubstanceAbuseBenefitsOutOfPocket__c,
                        SubstanceAbuseBenefitsOutOfPocketMet__c
                        FROM InsuranceVerificationForm__c
                        WHERE Id = :Calc.Insurance_Verification_Form__c];
                                
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Insurance Form Id: ' + InsuranceForm.Id));
        return InsuranceForm;
        
    }
    catch(Exception e)
    {
        return null;
    }
}


public void DoCalculations()
{
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Doing Calculations...'));
    try
    {
    	decimal dtxCoIns = 0;
    	decimal rtcCoIns = 0;
    	decimal phpCoIns = 0;
    	decimal iopCoIns = 0;
    	decimal resCoIns = 0;
    	decimal opCoIns = 0;
    	
	  	if(ifnull(Calc.Out_of_Pocket_Met__c) >= ifnull(Calc.Out_of_Pocket_Maximum__c))
		{
			if(ifnull(Calc.Out_of_Pocket_Met__c) == 0 && ifnull(Calc.Out_of_Pocket_Maximum__c) == 0)
			{
				dtxCoIns = ifnull(Calc.DTX_Co_Ins__c);
    			rtcCoIns = ifnull(Calc.IP_RTC_Co_Ins__c);
    			phpCoIns = ifnull(Calc.PHP_Co_Ins__c);
    			iopCoIns = ifnull(Calc.IOP_Co_Ins__c);
    			resCoIns = ifnull(Calc.RES_Co_Ins__c);
    			opCoIns = ifnull(Calc.OP_Co_Ins__c);
			}
			else
			{	
				dtxCoIns = 100;
				rtcCoIns = 100;
				phpCoIns = 100;
				iopCoIns = 100;
				resCoIns = 100;
				opCoIns = 100;
			}
		}
    	else
    	{
    		dtxCoIns = ifnull(Calc.DTX_Co_Ins__c);
    		rtcCoIns = ifnull(Calc.IP_RTC_Co_Ins__c);
    		phpCoIns = ifnull(Calc.PHP_Co_Ins__c);
    		iopCoIns = ifnull(Calc.IOP_Co_Ins__c);
    		resCoIns = ifnull(Calc.RES_Co_Ins__c);
    		opCoIns = ifnull(Calc.OP_Co_Ins__c);
    	}
    	
    	
        decimal dtxCopay = ifnull(Calc.DTX_Rate__c);
        decimal dtxDays = ifnull(Calc.DTX_Days__c);
        decimal dtxSubTotal = ifnull(Calc.DTX_Subtotal__c);
        decimal dtxClientPortion = ifnull(Calc.DTX_Client_Portion__c);
        
        dtxSubTotal = (dtxCopay * dtxDays) * (dtxCoIns / 100);
        Calc.DTX_Subtotal__c = dtxSubTotal;
        dtxClientPortion = (dtxCopay * dtxDays) * ((100 - dtxCoIns) / 100);
        Calc.DTX_Client_Portion__c = dtxClientPortion;
         
        decimal rtcCopay = ifnull(Calc.IP_RTC_Rate__c);
        decimal rtcDays = ifnull(Calc.IP_RTC_Days__c);
        decimal rtcSubTotal = ifnull(Calc.IP_RTC_Subtotal__c);
        decimal rtcClientPortion = ifnull(Calc.IP_RTC_Client_Portion__c);
        
        rtcSubTotal = (rtcCopay * rtcDays) * (rtcCoIns / 100);
        Calc.IP_RTC_Subtotal__c = rtcSubTotal;
        rtcClientPortion = (rtcCopay * rtcDays) * ((100 - rtcCoIns) / 100);
        Calc.IP_RTC_Client_Portion__c = rtcClientPortion;
        
        decimal phpCopay = ifnull(Calc.PHP_Rate__c);
        decimal phpDays = ifnull(Calc.PHP_Days__c);
        decimal phpSubTotal = ifnull(Calc.PHP_Subtotal__c);
        decimal phpClientPortion = ifnull(Calc.PHP_Client_Portion__c);
        
        phpSubTotal = (phpCopay * phpDays) * (phpCoIns / 100);
        Calc.PHP_Subtotal__c = phpSubTotal;
        phpClientPortion = (phpCopay * phpDays) * ((100 - phpCoIns) / 100);
        Calc.PHP_Client_Portion__c = phpClientPortion;
        
        decimal iopCopay = ifnull(Calc.IOP_Rate__c);
        decimal iopDays = ifnull(Calc.IOP_Days__c);
        decimal iopSubTotal = ifnull(Calc.IOP_Subtotal__c);
        decimal iopClientPortion = ifnull(Calc.IOP_Client_Portion__c);
        
        iopSubTotal = (iopCopay * iopDays) * (iopCoIns / 100);
        Calc.IOP_Subtotal__c = iopSubTotal;
        iopClientPortion = (iopCopay * iopDays) * ((100 - iopCoIns) / 100);
        Calc.IOP_Client_Portion__c = iopClientPortion;
        
        decimal resCopay = ifnull(Calc.RES_Rate__c);
        decimal resDays = ifnull(Calc.RES_Days__c);       
        decimal resSubTotal = ifnull(Calc.RES_Subtotal__c);
        decimal resClientPortion = ifnull(Calc.RES_Client_Portion__c);
        
        resSubTotal = (resCopay * resDays) * (resCoIns / 100);
        Calc.RES_Subtotal__c = resSubTotal;
        resClientPortion = (resCopay * resDays) * ((100 - resCoIns) / 100);
        Calc.RES_Client_Portion__c = resClientPortion;
        
        decimal opCopay = ifnull(Calc.OP_Rate__c);
        decimal opDays = ifnull(Calc.OP_Days__c);
        decimal opSubTotal = ifnull(Calc.OP_Subtotal__c);
        decimal opClientPortion = ifnull(Calc.OP_Client_Portion__c);
        
        opSubTotal = (opCopay * opDays) * (opCoIns / 100);
        Calc.OP_Subtotal__c = opSubTotal;
        opClientPortion = (opCopay * opDays) * ((100 - opCoIns) / 100);
        Calc.OP_Client_Portion__c = opClientPortion;
         
        decimal totalDays =  dtxDays + rtcDays + phpDays + iopDays + resDays + opDays;
        Calc.Total_Days__c = totalDays;
    
        decimal totalClientPortion = dtxClientPortion + rtcClientPortion + phpClientPortion + iopClientPortion + resClientPortion + opClientPortion;
        Calc.Total_Client_Portion__c = totalClientPortion;
        
        
        decimal grandTotal = dtxSubTotal + rtcSubTotal + phpSubTotal + iopSubTotal + resSubTotal + opSubTotal;
        Calc.Grand_Total__c = grandTotal;
        
        decimal totalClientContribution = (ifnull(Calc.Client_Deductible__c) - ifnull(Calc.Deductible_Met__c)) + ifnull(Calc.CoPays__c) + ifnull(Calc.Non_covered_Ancillary__c);
        Calc.Total_Client_Contribution__c = totalClientContribution;
        
        
        decimal estimatedInsuranceDollarsReceived = 0;
        if(ifnull(Calc.Plan_Maximum__c) > 0 && ifnull(Calc.Plan_Maximum__c) <= ifnull(grandTotal))
        	estimatedInsuranceDollarsReceived = Calc.Plan_Maximum__c + totalClientContribution;
        else
        	estimatedInsuranceDollarsReceived = grandTotal + totalClientContribution;
        	
        	
        Calc.Estimated_Insurance_Dollars_Received__c = estimatedInsuranceDollarsReceived;
        
        decimal dailyNetRevenue = estimatedInsuranceDollarsReceived / totalDays;
        Calc.Daily_Net_Revenue__c = dailyNetRevenue;
        
         
        if(FacilityDayRate != null)
        {
            if(dailyNetRevenue < FacilityDayRate)
            {
                ClientPortionNeededForTreatment = FacilityDayRate - dailyNetRevenue;
            }
        }   
    }
    catch(Exception e)
    {
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Calculation Error: ' + e));   
    }
}


public PageReference save()
{
    upsert Calc;
    
    Calc = getCalculator('id',ApexPages.currentPage().getParameters().get('id'));
    try{
	    List<Payment_Arrangement__c> payments = [SELECT Id FROM Payment_Arrangement__c WHERE Case__r.Id = :Calc.Case__r.Id];
	    if(payments == null | payments.size() <= 0)
	    {
	    	
	    	Payment_Arrangement__c p = new Payment_Arrangement__c();
		    //client contribution
		    p.Case__c = Calc.Case__r.Id;
		    p.Total_Copay__c = Calc.CoPays__c;
		    p.Total_Deductible__c = Calc.Client_Deductible__c - Calc.Deductible_Met__c;
		    p.Total_Rx_Deposit__c = 250;
		    p.Total_Non_Covered_Expense__c = Calc.Non_covered_Ancillary__c;
		    //p.Total_owed_prior_to_admission__c = Calc.CoPays__c + (Calc.Client_Deductible__c - Calc.Deductible_Met__c) + 250 + Calc.Non_covered_Ancillary__c;
		    upsert p;
		    
		    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'A payment arrangement has been created for this case.'));   
	    }
	    else
	    {
	    	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'A payment arrangement already exists for this case.'));
	    }
    }
    catch(Exception ex)
    {
    	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Error: ' + ex));
    }
   
    return null;
}

public PageReference cancel()
{
    PageReference pageCancel = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
    return pageCancel.setRedirect(true);
}

public List<SelectOption> getFacilities()
{
    List<SelectOption> options = new List<SelectOption>();
    List<Facility__c> facilities = new List<Facility__c>();
    facilities = [select Id,Name FROM Facility__c order by Name];
    options.add(new SelectOption('--None--','--None--'));
    for(integer i=0; i<facilities.size(); i++)
     {
       options.add(new SelectOption(facilities[i].Name,facilities[i].Name));
     } 
    return options;          
}
public void setSelectedFacility(string facilityName)
{
    this.SelectedFacility = [SELECT DTX_Rate__c, Day_Rate__c, Estimated_Insurance_Valuation__c, Name, Female_Beds__c, IOP_Rate__c, IP_RTC_Rate__c, Male_Beds__c, Notes__c, OP_Rate__c, OwnerId, PHP_Rate__c, Id, Total_Beds__c FROM Facility__c WHERE Name = :SelectedFacilityName];
    Calc.DTX_Rate__c = ifnull(SelectedFacility.DTX_Rate__c);
    Calc.IOP_Rate__c = ifnull(SelectedFacility.IOP_Rate__c);
    Calc.IP_RTC_Rate__c = ifnull(SelectedFacility.IP_RTC_Rate__c);
    Calc.OP_Rate__c = ifnull(SelectedFacility.OP_Rate__c);
    Calc.PHP_Rate__c = ifnull(SelectedFacility.PHP_Rate__c);
    DoCalculations();
    this.FacilityDayRate = SelectedFacility.Day_Rate__c;  
}
public Facility__c getSelectedFacility()
{
    Facility__c facility = [select Id, Name, Day_Rate__c FROM Facility__c WHERE Name = :SelectedFacilityName];
    this.FacilityDayRate = facility.Day_Rate__c;
    return facility;    
}
public void UpdateDayRate()
{
    setSelectedFacility(SelectedFacilityName);    
}

public decimal ifnull(decimal num)
{
    if (num == null) num = 0;
    return num;
}


}