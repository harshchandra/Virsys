public class PaymentArrangementViewItem {
	public string Id {get;set;}
	public string Name {get;set;}
	public string CaseId {get;set;}
	public string CaseNumber {get;set;}
	public string ClientName {get;set;}
	public string PaymentArrangementStatus {get;set;}
	public string OwnerName {get;set;}
	public Datetime CreatedDate {get;set;}
	public string CreatedDateString {get{ return CreatedDate.format('MM/dd/yyyy HH:mm:ss');}set;}
	
	public PaymentArrangementViewItem()
	{
		
	}
	public PaymentArrangementViewItem(string id, string name, string caseId, string caseNumber, string clientName, string paymentArrangementStatus, string ownerName, Datetime createdDate)
	{
		Id = id;
		Name = name;
		CaseId = caseId;
		CaseNumber = caseNumber;
		ClientName = clientName;
		PaymentArrangementStatus = paymentArrangementStatus;
		OwnerName = ownerName;
		CreatedDate = createdDate;
		
	}
	
	static testMethod void TestPaymentArrangementViewItem()
	{
		Test.startTest();
		PaymentArrangementViewItem x = new PaymentArrangementViewItem();
		PaymentArrangementViewItem y = new PaymentArrangementViewItem(
		'1','2','3','4','5','6','7',datetime.now()
		);
		
	}
}