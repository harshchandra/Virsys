public class MasterViewItem {

//CASE 
public string CaseId {get; set;}
public string CaseNumber {get; set;}
public DateTime CreatedDate {get; set;}
public string CreatedDateString {get{return CreatedDate.format('MM/dd/yyyy HH:mm:ss');}}
public string OwnerId {get;set;}
public string OwnerName {get;set;}
public string Status {get;set;}
public string PolicyType {get; set;}

//INSURANCE FIELDS
public string InsuranceId {get;set;}
public string InsuranceName {get;set;}
public string InsuranceStatus {get; set;}

//ACCOUNT FIELDS
public string AccountId {get; set;}
public string AccountName {get; set;}
public string ParentAccountType {get; set;}
//ASSESSMENT FIELDS
public string AssessmentId {get; set;}
public string AssessmentName {get; set;}
public string AssessmentStatus {get; set;}
//TRANSPORTATION FIELDS
public string TransportationId {get; set;}
public string TransportationName {get; set;}
public string TransportationStatus {get; set;}
//PAYMENT ARRANGEMENT FIELDS
public string PaymentArrangementId {get; set;}
public string PaymentArrangementName {get; set;}
public string PaymentArrangementStatus {get; set;}

public MasterViewItem()
{
	
}

public MasterViewItem(string caseId,
string caseNumber,
Datetime createdDate,
string ownerId,
string ownerName,
string status,
string policyType,
string insuranceId,
string insuranceName,
string insuranceStatus,
string accountId,
string accountName,
string parentAccountType,
string assessmentId,
string assessmentName,
string assessmentStatus,
string transportationId,
string transportationName,
string transportationStatus,
string paymentArrangementId,
string paymentArrangementName,
string paymentArrangementStatus)
{
	CaseNumber = caseNumber;
	CreatedDate = createdDate;
	OwnerId = ownerId;
	OwnerName = ownerName;
	Status = status;
	PolicyType = policyType;
	InsuranceId = insuranceId;
	InsuranceName = insuranceName;
	InsuranceStatus = insuranceStatus;
	AccountId = accountId;
	AccountName = accountName;
	ParentAccountType = parentAccountType;
	AssessmentId = assessmentId;
	AssessmentName = assessmentName;
	AssessmentStatus = assessmentStatus;
	TransportationId = transportationId;
	TransportationName = transportationName;
	TransportationStatus = transportationStatus;
	PaymentArrangementId = paymentArrangementId;
	PaymentArrangementName = paymentArrangementName;
	PaymentArrangementStatus = paymentArrangementStatus;
	
}

static testMethod void MasterViewItemTest()
{
	MasterViewItem x = new MasterViewItem();
	MasterViewItem y = new MasterViewItem(
	'1',
	'1',
	Datetime.now(),
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1',
	'1');
}		
}