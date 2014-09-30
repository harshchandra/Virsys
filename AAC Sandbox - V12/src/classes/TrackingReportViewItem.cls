public class TrackingReportViewItem {
	public string CaseId {get;set;}
	public string CaseNumber {get;set;}
	public string CaseStatus{get;set;}
	public Datetime CreatedDate {get;set;}
	public string CreatedDateString {get{ return CreatedDate.format('MM/dd/yyyy HH:mm:ss');}set;}
	public string BenefitType {get;set;}
	public string ContactId {get;set;}
	public string ContactName {get;set;}
	public string OwnerName{get;set;}
	public string InsuranceId {get;set;}
	public string FirstPolicyCompany {get;set;}
	public string FirstPolicyInsuranceType{get;set;}
	public string InsuranceStatus {get;set;}
	public string ParentAccountType{get;set;}
	public string ParentAccountId{get;set;}
	public string ParentAccountName{get;set;}
	public string DetoxFacility{get;set;}
	public string TreatmentFacility{get;set;}
	public string TransportationId {get;set;}
	public string TransportationStatus{get;set;}
	public DateTime DateTimeClientArrives{get;set;}
	public string DateTimeClientArrivesString {get{ return DateTimeClientArrives.format('MM/dd/yyyy HH:mm:ss');} set;}
	public boolean PaperworkSent{get;set;}
	public DateTime FacilityAdmissionDate{get;set;}
	public string FacilityAdmissionDateString{get{ return FacilityAdmissionDate.format('MM/dd/yyyy HH:mm:ss');} set;}
	public DateTime FacilityDischargeDate{get;set;}
	public string FacilityDischargeDateString{get{ return FacilityDischargeDate.format('MM/dd/yyyy HH:mm:ss');} set;}
	public string PayCommissionTo{get;set;}
	public string SplitCommissionWith{get;set;}
	
	
	public TrackingReportViewItem()
	{
		
	}
	
	public TrackingReportViewItem(
	string caseId, string caseNumber, string caseStatus, string benefitType, DateTime createdDate, string contactId, string contactName, string ownerName, string insuranceId,
	string policyCompany, string policyInsuranceType, string insuranceStatus, string parentAccountType,
	string parentAccountId, string parentAccountName, string detoxFacility, string treatmentFacility, string transportationId, string transportationStatus,
	DateTime dateTimeClientArrives, boolean paperworkSent, DateTime facilityAdmissionDate, DateTime facilityDischargeDate, string payCommissionTo, string splitCommissionWith 
	)
	{
		CaseId = caseId;
		CaseNumber = caseNumber;
		CaseStatus = caseStatus;
		CreatedDate = createdDate;
		ContactId = contactId;
		ContactName = contactName;
		OwnerName = ownerName;
		BenefitType = benefitType;
		InsuranceId = insuranceId;
		FirstPolicyCompany = firstPolicyCompany;
		FirstPolicyInsuranceType = firstPolicyInsuranceType;
		InsuranceStatus = insuranceStatus;
		ParentAccountType = parentAccountType;
		ParentAccountId = parentAccountId;
		ParentAccountName = parentAccountName;
		DetoxFacility = detoxFacility;
		TreatmentFacility = treatmentFacility;
		TransportationId = transportationId;
		TransportationStatus = transportationStatus;
		DateTimeClientArrives = dateTimeClientArrives;
		PaperworkSent = paperworkSent;
		FacilityAdmissionDate = facilityAdmissionDate;
		FacilityDischargeDate = facilityDischargeDate;
		PayCommissionTo	= payCommissionTo;
		SplitCommissionWith = splitCommissionWith;
	}
	
	static testMethod void TestTrackingReportViewItem()
	{
		Test.startTest();
		TrackingReportViewItem x = new TrackingReportViewItem();
		TrackingReportViewItem y = new TrackingReportViewItem(
		'1',
		'1',
		'1',
		'1',
		datetime.now(),
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
		datetime.now(),
		true,
		datetime.now(),
		datetime.now(),
		'1',
		'1'
		);
		
	}

}