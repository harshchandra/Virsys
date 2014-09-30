@isTest
private class ClientCalculatorExtTest {
private static Account PersonAccount;
private static Case TestCase;
private static InsuranceVerificationForm__c InsuranceForm;
private static Client_Calculator__c Calc;
private static Client_Calculator__c NewCalc;

private static void InitializeTestEntities()
  {
    PersonAccount = new Account(FirstName='John',LastName='Doe');
    insert PersonAccount;
    
    TestCase = new Case(Status='Case Opened', Origin='Phone',AccountId=PersonAccount.Id);
    insert TestCase;
    
    InsuranceForm = new InsuranceVerificationForm__c();
    InsuranceForm.Case__c = TestCase.Id;
    InsuranceForm.SubstanceAbuseDTXCopay__c = 50;
    InsuranceForm.SubstanceAbuseDTXPercentage__c = 0;
    InsuranceForm.SubstanceAbuseIOPCopay__c = 0;
    InsuranceForm.SubstanceAbuseIOPPercentage__c = 0;
    InsuranceForm.SubstanceAbuseIPCopay__c = 0;
    InsuranceForm.SubstanceAbuseIPPercentage__c = 0;
    InsuranceForm.SubstanceAbuseOPCopay__c = 0;
    InsuranceForm.SubstanceAbuseOPPercentage__c = 0;
    InsuranceForm.SubstanceAbusePHPCopay__c = 0;
    InsuranceForm.SubstanceAbusePHPPercentage__c = 0;
    InsuranceForm.SubstanceAbuseRESCopay__c = 0;
    InsuranceForm.SubstanceAbuseRESPercentage__c = 0;
    InsuranceForm.SubstanceAbuseBenefitsCopay__c = 0;
    InsuranceForm.SubstanceAbuseBenefitsCopayMet__c = 0;
    InsuranceForm.SubstanceAbuseDTXLifetimeMax__c = 0;
    InsuranceForm.SubstanceAbuseBenefitsOutOfPocket__c = 0;
    InsuranceForm.SubstanceAbuseBenefitsOutOfPocketMet__c = 0;
    InsuranceForm.SubstanceAbuseDTXLifetimeMax__c = 0;
    InsuranceForm.ClientName__c = 'John Doe';   
    insert InsuranceForm;
    
    Calc = new Client_Calculator__c();
    Calc.Insurance_Verification_Form__c = InsuranceForm.Id;
    Calc.Case__c = TestCase.Id;
    insert Calc;   
    
    
    
    Facility__c Facility = new Facility__c();
    Facility.Name = 'Greenhouse';
    Facility.Day_Rate__c = 800;
    insert Facility;
  }

public static testMethod void GenericTest() 
{
    InitializeTestEntities();
    Account a= new Account(FirstName = 'John',LastName = 'Doe',Phone='5555555555');
    insert a;
    
	Case c = new Case(AccountId = a.Id);
	insert c;
	
	InsuranceVerificationForm__c i = new InsuranceVerificationForm__c(Case__c = c.Id);
	insert i;
	
	NewCalc = new Client_Calculator__c(Insurance_Verification_Form__c = i.Id, Case__c = c.Id);
	insert NewCalc;
	
	
	
    Test.setCurrentPage(new PageReference('/apex/pages/ClientCalculator?id=' + NewCalc.Id + '&retURL=/Test'));       
    ApexPages.StandardController controller = new ApexPages.StandardController(TestCase);
    ClientCalculatorExt ext = new ClientCalculatorExt(controller);    
    Test.startTest();
    ext.getFacilities();
    ext.SelectedFacilityName = 'Greenhouse';
    ext.getSelectedFacility();
    ext.setSelectedFacility('Greenhouse');
    ext.UpdateDayRate();
    //ext.Cancel();
    ext.getInsuranceForm();
    ext.getCalculator('id',Calc.Id);
    ext.save();
    Test.setCurrentPage(new PageReference('/apex/pages/ClientCalculator?insuranceid=' + InsuranceForm.Id + '&retURL=/Test'));
    ext = new ClientCalculatorExt(controller);    
    ext.getCalculator('insuranceid',InsuranceForm.Id);    
    
    Test.setCurrentPage(new PageReference('/apex/pages/ClientCalculator?caseid=' + TestCase.Id + '&retURL=/Test'));
    ext = new ClientCalculatorExt(controller);
    ext.getCalculator('caseid',TestCase.Id);   
    ext.DoCalculations(); 
    Test.stopTest();
}
}