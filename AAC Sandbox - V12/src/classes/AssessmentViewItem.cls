public class AssessmentViewItem {
	public string Id {get;set;}
	public string Name {get;set;}
	public string CaseId {get;set;}
	public string CaseNumber {get;set;}
	public string ClientName {get;set;}
	public string AssessmentStatus {get;set;}
	public string OwnerName {get;set;}
	public Datetime CreatedDate {get;set;}
	public string CreatedDateString {get{ return CreatedDate.format('MM/dd/yyyy HH:mm:ss');}set;}
	
	public AssessmentViewItem()
	{
		
	}
	public AssessmentViewItem(string id, string name, string caseId, string caseNumber, string clientName, string assessmentStatus, string ownerName, Datetime createdDate)
	{
		Id = id;
		Name = name;
		CaseId = caseId;
		CaseNumber = caseNumber;
		ClientName = clientName;
		AssessmentStatus = assessmentStatus;
		OwnerName = ownerName;
		CreatedDate = createdDate;
		
	}
	
	static testMethod void TestAssessmentViewItem()
	{
		Test.startTest();
		AssessmentViewItem x = new AssessmentViewItem();
		AssessmentViewItem y = new AssessmentViewItem(
		'1','2','3','4','5','6','7',datetime.now()
		);
		
	}
}