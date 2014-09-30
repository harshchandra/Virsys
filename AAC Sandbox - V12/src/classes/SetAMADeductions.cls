public class SetAMADeductions {
	
	public SetAMADeductions()
	{
		
	}
	
	public PageReference UpdatePayments()
	{
		List<Payment_Arrangement__c> payments = [SELECT Id, Hidden_Modifier__c, AMA_Deductions__c FROM Payment_Arrangement__c];
		List<Payment_Arrangement__c> finalPayments = new List<Payment_Arrangement__c>();
		for(Payment_Arrangement__c p : payments)
		{
			p.Hidden_Modifier__c = 0;
			finalPayments.add(p);
		}
		
		update finalPayments;
		
		return null;
	}
	
	public static testMethod void testAMADeductions()
	{
		Account a = new Account(FirstName='John',LastName='Doe');
		insert a;
		Facility__c f = new Facility__c();
		f.Name = 'Greenhouse';
		insert f;
		Case c = new Case();
		c.AccountId = a.Id;
		c.Treatment_Facility__c = 'Greenhouse';
		c.Treatment_Facility_Lookup__c = f.Id;
		c.Funding_Type__c = 'Private Pay';
		c.Status = 'Admitted';
		insert c;
		Payment_Arrangement__c pa = new Payment_Arrangement__c();
		pa.Case__c = c.Id;
		
		Test.StartTest();
		SetAMADeductions testAMA = new SetAMADeductions();
		PageReference ref = testAMA.UpdatePayments();
		Test.StopTest();
	} 

}