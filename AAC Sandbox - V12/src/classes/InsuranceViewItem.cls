public class InsuranceViewItem {
	public string Id {get;set;}
	public string Name {get;set;}
	public string CaseId {get;set;}
	public string CaseNumber {get;set;}
	public string ClientName {get;set;}
	public string InsuranceStatus {get;set;}
	public string OwnerName {get;set;}
	public Datetime CreatedDate {get;set;}
	public string CreatedDateString {get{ return CreatedDate.format('MM/dd/yyyy HH:mm:ss');}set;}
	
	public InsuranceViewItem()
	{
		
	}
	public InsuranceViewItem(string id, string name, string caseId, string caseNumber, string clientName, string insuranceStatus, string ownerName, Datetime createdDate)
	{
		Id = id;
		Name = name;
		CaseId = caseId;
		CaseNumber = caseNumber;
		ClientName = clientName;
		InsuranceStatus = insuranceStatus;
		OwnerName = ownerName;
		CreatedDate = createdDate;
		
	}
	
	static testMethod void TestInsuranceViewItem()
	{
		Test.startTest();
		InsuranceViewItem x = new InsuranceViewItem();
		InsuranceViewItem y = new InsuranceViewItem(
		'1','2','3','4','5','6','7',datetime.now()
		);
		
	}
}