public class DatesOfServiceController
{
    public Dates_Of_Service__c Form {get;set;}
    public Utilization_Review__c ParentForm {get;set;}
    public List<Dates_Of_Service__c> ExistingDatesOfService {get;set;}
    public string LevelOfCare {get;set;}
    public boolean HasExistingDatesOfService {get;set;}
    public boolean ShowDaysOfWeek {get;set;}
    public boolean Monday {get;set;}
    public boolean Tuesday {get;set;}
    public boolean Wednesday {get;set;}
    public boolean Thursday {get;set;}
    public boolean Friday {get;set;}
    public boolean Saturday {get;set;}
    public boolean Sunday {get;set;}
    public boolean FormInvalid {get;set;}
    public boolean DTX {get;set;}
    public boolean IR {get;set;}
    public boolean RTC {get;set;}
    public boolean PHP {get;set;}
    public boolean IOP {get;set;}
    public boolean ShowLocLabel {get;set;}
    public string LocLabelText {get;set;}
    public boolean StartDateEnabled {get;set;}
    public string ValidationMessage {get;set;}
    public set<string> SelectedDayValues {get;set;}
    public integer NumberOfDays {get;set;}
    public boolean DisableDays {get;set;}
    public boolean ShowDaysPerWeek {get;set;}  
		public boolean ShowTotalDays {get;set;}
		public boolean ShowAuthorizationNumber {get;set;}
		public boolean ShowCM {get;set;}
		public boolean ShowDateOfNextReview {get;set;}
		public boolean ShowReviewAssignedTo {get;set;}
		public boolean ShowQuestions {get;set;}
		public boolean ShowHasBeenBilled {get;set;}
		public boolean ShowAdminDenialQuestion {get;set;}
		public boolean ShowClinicalDenialQuestions {get;set;}
		public boolean ShowPostServiceClaimQuestion {get;set;}
		public string Question1Text { get { return 'What LOCs do require authorization?';}}
		public string Question2Text { get { return 'What LOCs do not require authorization?';}}
		public string Question3Text { get { return 'Who is the employer group?';}}
		public string Question4Text { get { return 'Is this a specialty account?';}}
		public string Question5Text { get { return 'Is this member under Intensive Case Mgmt?';}}
		public string Question6Text { get { return 'Will the record be requested for review?';}}
		public string Question7Text { get { return 'Was claims note documented by CM?';}}
		public string Question8Text { get { return 'What is the call reference number?';}}
		public string QuestionAdminDenialText { get { return 'What was the stated reason by the Care Manager for why this LOC is being administratively denied?';}}
		public string QuestionClinicalDenialText1 { get { return 'What specific medical necessity criteria did the client not meet for this LOC?';}}
		public string QuestionClinicalDenialText2 { get { return 'Who was the staff who completed the Doc‐to‐Doc from the facility?';}}
		public string QuestionClinicalDenialText3 { get { return 'Who was the doctor who represented the managed care company?';}}
		public string QuestionPostServiceClaimText {get { return 'What is the reason for the retrospective review?';}}
		public string Question1 {get;set;}
		public string Question2 {get;set;}
		public string Question3 {get;set;}
		public string Question4 {get;set;}
		public string Question5 {get;set;}
		public string Question6 {get;set;}
		public string Question7 {get;set;}
		public string Question8 {get;set;}
		public string QuestionAdminDenial {get;set;}
		public string QuestionClinicalDenial1 {get;set;}
		public string QuestionClinicalDenial2 {get;set;}
		public string QuestionClinicalDenial3 {get;set;}
		public string QuestionPostServiceClaim {get;set;}
		public boolean DOSReady {get;set;}
		
    private static List<PageMessage> Messages 
    {
        get 
        { 
            if(Messages == null)
                Messages = new List<PageMessage>();
            
            return Messages;
        }
        private set;
    }
		
    public DatesOfServiceController(ApexPages.StandardController controller)
    {
        Form = (Dates_Of_Service__c)controller.getRecord();
        
        GetParentForm();       

        try
        {
            ExistingDatesOfService = [SELECT Id, Name, Start_Date__c, End_Date__c, Level_Of_Care__c, Status__c FROM Dates_Of_Service__c WHERE Utilization_Review_Form__c = :ParentForm.Id ORDER BY End_Date__c DESC];
        }
        catch(Exception e)
        {
            ExistingDatesOfService = new List<Dates_Of_Service__c>();
        }
        
        if(ExistingDatesOfService.size() > 0)
        {
                HasExistingDatesOfService = true;
                StartDateEnabled = true;
                Form.Start_Date__c = ExistingDatesOfService[0].End_Date__c.addDays(1);
        }
        else
        {
                HasExistingDatesOfService = false;
                Form.Start_Date__c = ParentForm.Admission_Date__c;
                StartDateEnabled = false;
        }
        if(ParentForm.Therapist_Name__c == null || ParentForm.Therapist_Phone_Number__c == null || ParentForm.Primary_Diagnosis_Code__c == null)
        {
        	DOSReady = false;
        }
        else
    		{
    			DOSReady = true;
    		}
        
    }
    public void GetParentForm()
    {
    	ParentForm = [SELECT Id, Name,
                            Case__c,
                            Case__r.Id,
                            Case__r.CaseNumber, 
                            Admission_Date__c, 
                            EDOD_Treatment_Facility__c,
                            Discharge_Date__c,
                            Case_Funding_Type__c,
                            Client_DOB__c,
                            Client_Name__c,
                            COB_Confirmation_Number__c,
                            Comments__c,
                            Completed_By__c,
                            Completed_Date__c,
                            Date_COB_Updated__c,
                            Dates_Of_Service_Count__c,
                            Diagnosis__c,
                            Insurance_Company__c,
                            Insurance_ID__c,
                            PreCert_Company__c,
                            PreCert_Company_Phone__c,
                            Primary_Diagnosis_Code__c,
                            Primary_Diagnosis_Description__c,
                            Primary_Insurance_UR__c,
                            Reviewer_Name__c,
                            Reviewer_Phone__c,
                            Therapist_Name__c,
                            Therapist_Phone_Number__c,
                            TreatmentFacility__c,
                            TreatmentFacilityName__c,
                            VOB__c,
                            VOB__r.Id,
                            VOB__r.Name,
                            ClientPolicy_DTX__c,
                            ClientPolicy_IOP__c,
                            ClientPolicy_IR__c,
                            ClientPolicy_PHP__c,
                            ClientPolicy_RTC__c,                                                    
                            PreCert_DTX__c,
                            PreCert_IOP__c,
                            PreCert_IR__c,
                            PreCert_PHP__c,
                            PreCert_RTC__c,
                            Email_Trigger_Time__c
                            FROM Utilization_Review__c WHERE Id = :Form.Utilization_Review_Form__c];
    }
    public void SetReviewDateToEndDate()
    {
    	try
    	{
    		Form.Date_of_Review__c = Form.End_Date__c;
    	}
    	catch(Exception e)
    	{
    		
    	}
    }
    public void CalculateCalendarDays()
    {
    	try
    	{
    		integer diffDays = Form.Start_Date__c.daysBetween(Form.End_Date__c);
    			
    		if(diffDays > 0)
    			diffDays = diffDays + 1;

    		if(Form.Start_Date__c == Form.End_Date__c)
    			diffDays = 1;
				    			
    		NumberOfDays = diffDays;
    		
    		SetReviewDateToEndDate();
    	}
    	catch(Exception e)
    	{
    		
    	}
    }
    public void SetDaysOfWeekVisibility()
    {
        if(Form.Days_Per_Week__c != '7' && Form.Days_Per_Week__c != null && Form.Days_Per_Week__c != '')
        {
         DisableDays = false;
         ShowDaysOfWeek = true;
        }
        else
        {
         if(Form.Days_Per_Week__c == '7')
         {
		    		Monday = true;
		    		Tuesday = true;
		    		Wednesday = true;
		    		Thursday = true;
		    		Friday = true;
		    		Saturday = true;
		    		Sunday = true;
         }
         DisableDays = true;
         ShowDaysOfWeek = false;
        }
    }
    public string DayOfWeek(Date d)
    {
      datetime myDate = datetime.newInstance(d.year(), d.month(), d.day());
      return myDate.format('EEEE');
    }
    public PageReference SaveParent()
    {
    	if(ParentForm != null)
    		update ParentForm;
    		
    	GetParentForm();
    	
    	PageReference pageRef = ApexPages.currentPage();
    	pageRef.setRedirect(true);
    	return pageRef;
    }
    public PageReference Save()
    {
         if(!ValidateForm())
         {
         	Date originalStartDate = Form.Start_Date__c;
         	system.debug('****** STORING ORIGINAL START_DATE ****** '  + originalStartDate);
         	Date originalEndDate = Form.End_Date__c;
         	Form.End_Date__c = Form.Start_Date__c;
         	Form.Day_of_Week__c = DayOfWeek(Form.Start_Date__c);
         	if(!SelectedDayValues.isEmpty())
         	{
         		if(SelectedDayValues.contains(Form.Day_of_Week__c))
         		{
         			Form.Billable_Day__c = true;
         		}
         		else
         		{
         			Form.Billable_Day__c = false;
         		}
         	}
         	if(Form.Status__c == 'Admin Denial' || Form.Status__c == 'Clinical Denial')
         	{
         		Form.Billable_Day__c = false;
         	}
					if(Form.Status__c == 'Post-Service Claim')
					{
						Form.Billable_Day__c = true;
					}         	
         	string originalNotes = Form.Notes__c == '' || Form.Notes__c == null ? '' : Form.Notes__c;
					string selectedLevelsOfCare = '';
					string adminDenialQuestionText = '';
					string clinicalDenialQuestionsText = '';
					string postServiceClaimQuestionText = '';
					string notes = '';
					
					if(ShowAdminDenialQuestion)
					{
						adminDenialQuestionText = QuestionAdminDenialText + '\n\n' + QuestionAdminDenial;
						notes += adminDenialQuestionText + '\n\n';
					}
					if(ShowClinicalDenialQuestions)
					{
						clinicalDenialQuestionsText += + '\n\n' + QuestionClinicalDenialText1 + '\n\n' + QuestionClinicalDenial1;
						clinicalDenialQuestionsText += + '\n\n' + QuestionClinicalDenialText2 + '\n\n' + QuestionClinicalDenial2;
						clinicalDenialQuestionsText += + '\n\n' + QuestionClinicalDenialText3 + '\n\n' + QuestionClinicalDenial3;
						
						notes += clinicalDenialQuestionsText;
					}
					if(ShowPostServiceClaimQuestion)
					{
						postServiceClaimQuestionText += '\n\n' + QuestionPostServiceClaimText + '\n\n' + QuestionPostServiceClaim;
						
						notes += postServiceClaimQuestionText;
						
					}
         	if(ShowQuestions)
         	{
         		
         		if(DTX)
         			selectedLevelsOfCare += 'DTX,';
         		if(IR)
         			selectedLevelsOfCare += 'IR,';
         		if(RTC)
         			selectedLevelsOfCare += 'RTC,';
         		if(PHP)
         			selectedLevelsOfCare += 'PHP,';
         		if(IOP)
         			selectedLevelsOfCare += 'IOP,';

       			if(selectedLevelsOfCare.endsWith(','))
							selectedLevelsOfCare = selectedLevelsOfCare.removeEnd(',');
							
						notes += '\n\n' + Question1Text + '\n' + selectedLevelsOfCare + '\n\n' + Question3Text + '\n' + Question3 + '\n\n' + Question4Text + '\n' + Question4 + '\n\n' + Question5Text + '\n' + Question5 + '\n\n' + Question6Text + '\n' + Question6 + '\n\n' + Question7Text + '\n' + Question7; 
         	}
         	
         	Form.Notes__c = Form.Notes__c + '\n\n' + notes; 	
          upsert Form;
          
          List<Dates_of_Service__c> dosRecords = new List<Dates_of_Service__c>();
          originalStartDate = originalStartDate.addDays(1);
          system.debug('****** STARTING  WITH****** '  + originalStartDate + ' should be 1 day higher');
          while(originalStartDate <= originalEndDate)
          {
          	system.debug('****** TRYING TO CREATE DOS ****** '  + originalStartDate);
          	Dates_of_Service__c dos = new Dates_of_Service__c();
          	dos.Start_Date__c = originalStartDate;
          	dos.End_Date__c = originalStartDate;
          	dos.Day_of_Week__c = DayOfWeek(originalStartDate);
          	dos.Level_of_Care__c = Form.Level_of_Care__c;
          	dos.Has_Been_Billed__c = Form.Has_Been_Billed__c;
          	dos.Status__c = Form.Status__c;
          	dos.Authorization_Number__c = Form.Authorization_Number__c;
          	dos.Date_of_Review__c = Form.Date_of_Review__c;
          	dos.Days_Per_Week__c = Form.Days_Per_Week__c;
          	dos.Notes__c = originalNotes;
          	dos.Review_Assigned_To_Lookup__c = Form.Review_Assigned_To_Lookup__c;
          	dos.Total_Days_Authorized__c = Form.Total_Days_Authorized__c;
          	dos.Utilization_Review_Form__c = Form.Utilization_Review_Form__c;
          	dos.CM__c = Form.CM__c;
          	dos.Account__c = Form.Account__c;
          	if(!SelectedDayValues.isEmpty())
         		{
	         		if(SelectedDayValues.contains(dos.Day_of_Week__c))
	         		{
	         			dos.Billable_Day__c = true;
	         		}
	         		else
	         		{
	         			dos.Billable_Day__c = false;        			
	         		}
         		}
         		if(Form.Status__c == 'Admin Denial' || Form.Status__c == 'Clinical Denial')
          	{
          		dos.Billable_Day__c = false;
          	}
          	if(Form.Status__c == 'Post-Service Claim')
          	{
          		dos.Billable_Day__c = true;
          	}
         		dosRecords.add(dos);
          	
          	originalStartDate = originalStartDate.addDays(1);
          }
          
          insert dosRecords;
          
          Task task = new Task();
          task.WhatId = ParentForm.Id;
          //task.WhoId = Form.Review_Assigned_To_Lookup__c;
          task.OwnerId = Form.Review_Assigned_To_Lookup__c;
          task.Subject = 'Review: ' + ParentForm.Name;
          task.Status = 'Not Started';
          task.Description = 'This is an automatically generated task from the Dates of Service application.  You have been selected to review the Dates of Service records on ' + Form.Date_of_Review__c;
          task.ActivityDate = Form.Date_of_Review__c;
          task.Priority = 'High';
          task.Type = 'DOS Review';
          task.IsReminderSet = true;
          task.ReminderDateTime = Form.Date_of_Review__c.addDays(-1);
          insert task;
          
          
          ParentForm.Email_Trigger_Time__c = datetime.now().addMinutes(2);
          update ParentForm;
          
          GetParentForm();
          
          PageReference ref = new PageReference('/' + ParentForm.Id);
          ref.setRedirect(true);
          return ref;
         }
         else
         {

            return null;
         }
            
    }
    public void StatusRules()
    {
    	ShowQuestions = false;
    	ShowAdminDenialQuestion = false;
    	ShowClinicalDenialQuestions = false;
    	ShowPostServiceClaimQuestion = false;
    	string status = Form.Status__c;
    	if(status == 'No Auth Policy' || status == 'Clinical Denial' || status == 'Admin Denial' || status == 'Post-Service Claim')
    	{
    		ShowAuthorizationNumber = false;
    	}
    	if(status == 'No Auth Policy')
    	{
    		ShowQuestions = true;
    	}
    	if(status == 'Admin Denial')
    	{
    		ShowAdminDenialQuestion = true;
    	}
    	if(status == 'Clinical Denial')
    	{
    		ShowClinicalDenialQuestions = true;
    	}
    	if(status == 'Post-Service Claim')
    	{
    		ShowPostServiceClaimQuestion = true;
    	}
    }
    public void LevelOfCareRules()
    {
   		ShowTotalDays = true;
   		ShowAuthorizationNumber = true;
   		ShowCM = true;
   		ShowDateOfNextReview = true;
   		ShowReviewAssignedTo = true;
   		ShowHasBeenBilled = true;
   		ShowQuestions = false;
   		ShowLocLabel = false;
   		LocLabelText = '';
   		
    	if(Form.Level_of_Care__c == 'DTX' || Form.Level_of_Care__c == 'IR' || Form.Level_of_Care__c == 'RTC' || Form.Level_Of_Care__c == 'LOA')
    	{
    		Form.Days_Per_Week__c = '7';
    		Monday = true;
    		Tuesday = true;
    		Wednesday = true;
    		Thursday = true;
    		Friday = true;
    		Saturday = true;
    		Sunday = true;
    		DisableDays = true;
    		ShowDaysOfWeek = true;
    		ShowDaysPerWeek = false;
    	}
    	else
    	{
    		Form.Days_Per_Week__c = '';
    		DisableDays = false;
    		Monday = false;
    		Tuesday = false;
    		Wednesday = false;
    		Thursday = false;
    		Friday = false;
    		Saturday = false;
    		Sunday = false;
    		DisableDays = false;
    		ShowDaysOfWeek = false;
    		ShowDaysPerWeek = true;
    	}
    	
    	string loc = Form.Level_of_Care__c;
    	if(loc == 'H' || loc == 'LOA' || loc == 'NB' || loc == 'NBT' || loc == 'PVT PAY' || loc == 'SCH')
    	{
    		ShowTotalDays = false;
    		ShowAuthorizationNumber = false;
    		ShowCM = false;
    		ShowDateOfNextReview = false;
    		ShowReviewAssignedTo = false;
    	}
    	if(loc == 'EAP' || loc == 'PVT PAY' || loc == 'SCH')
    	{
    		Form.Status__c = 'Approved';
    	}
    	if(loc == 'H' || loc == 'LOA' || loc == 'NB' || loc == 'NBT')
    	{
    		Form.Status__c = 'Not Applicable';
    	}
    	if(loc == 'NBT')
    	{
    		ShowLocLabel = true;
    		LocLabelText = 'This is only to be used when the admit date is not billable because the initial authorization for an outpatient level of care begins on the following date, and the client did not receive services on the admit date.';
    	}
    	else
    	{
    		ShowLocLabel = false;
    		LocLabelText = '';
    	}
    	if(loc == 'Post-Service Claim')
    	{
    		ShowAuthorizationNumber = false;
    		
    	}
    }
    public boolean ValidateForm()
    {
        this.FormInvalid = false;
        ValidationMessage = '';
        Messages = new List<PageMessage>();
       
        
        List<Dates_of_Service__c> sortedDOS = ExistingDatesOfService;
        if(sortedDOS.size() > 0)
        {
                ShowMessage('confirm','This Utilization Review Form has existing Dates of Service records.  Validating...');
                sortList(sortedDOS, 'End_Date__c', 'desc');
                Dates_of_Service__c mostRecentDOS = sortedDOS[0];
                ShowMessage('confirm','The most recent Dates of Service End Date is: ' + mostRecentDOS.End_Date__c.format());
                if(mostRecentDOS != null)
                {
                    if(Form.Start_Date__c > mostRecentDOS.End_Date__c.addDays(1))
                    {
                            ShowMessage('fatal','You cannot skip Dates of Service.  The Start Date must happen immediately after the most recent End Date.');
                            //ValidationMessages.add('You cannot skip Dates of Service.  The Start Date must happen immediately after the most recent End Date.');
                            this.FormInvalid = true;
                    }
                }
        }
        
        for(Dates_of_Service__c d : ExistingDatesOfService)
        {
                if(d.Start_Date__c >= Form.Start_Date__c || d.End_Date__c >= Form.Start_Date__c)
                {
                        ShowMessage('fatal','The Start Date cannot be less than an existing Start Date and it cannot be less than or equal to an existing End Date.');
                        //ValidationMessages.add('The Start Date cannot be less than an existing Start Date and it cannot be less than or equal to an existing End Date.');
                        this.FormInvalid = true;
                }               
        }
        
        SelectedDayValues = new set<string>();
        List<string> selectedDays = new List<string>();
        if(Form.Days_Per_Week__c != '' && Form.Days_Per_Week__c != '7')
        {
                if(Monday)
                        selectedDays.add('Monday');
                if(Tuesday)
                        selectedDays.add('Tuesday');
                if(Wednesday)
                        selectedDays.add('Wednesday');
                if(Thursday)
                        selectedDays.add('Thursday');
                if(Friday)
                        selectedDays.add('Friday');
                if(Saturday)
                        selectedDays.add('Saturday');
                if(Sunday)
                        selectedDays.add('Sunday');

                
                
                //didnt select any days        
                if(selectedDays.size() <= 0)
                {
                        this.FormInvalid = true;
                        ShowMessage('fatal','If you are not specifying 7 Days Per Week you must specify which days will be utilized.');
                        //ValidationMessages.add('If you are not specifying 7 Days Per Week you must specify which days will be utilized.');
                }
                
                //days selected are less than the days per week, or greater than the days per week
                if(selectedDays.size() < Integer.valueOf(Form.Days_Per_Week__c) || selectedDays.size() > Integer.valueOf(Form.Days_Per_Week__c))
                {
                        this.FormInvalid = true;
                        ShowMessage('fatal','You have selected ' + Form.Days_Per_Week__c + ' Days Per Week; You must select that number of days of the week.');
                        //ValidationMessages.add('You have selected ' + Form.Days_Per_Week__c + ' Days Per Week; You must select that number of days of the week.');
                }                                                                                 
        }
        
        if(Form.Days_Per_Week__c == '7')
        {
        	selectedDays.add('Monday');
          selectedDays.add('Tuesday');
          selectedDays.add('Wednesday');
          selectedDays.add('Thursday');
          selectedDays.add('Friday');
          selectedDays.add('Saturday');
          selectedDays.add('Sunday');
        }
        else
        {
        	if(integer.valueOf(Form.Total_Days_Authorized__c) >= integer.valueOf(Form.Total_Calendar_Days__c))
        	{
        		this.FormInvalid = true;
            ShowMessage('fatal','Total Days Authorized must be less than Total Calendar Days when Days Per Week is less than 7.');
        	}
        }
        
        
        SelectedDayValues.addAll(selectedDays);
        
        DateTime startDate = Form.Start_Date__c;
        DateTime endDate = Form.End_Date__c;
        integer daysDifference = startDate.Date().daysBetween(endDate.Date()) + 1;
        if(startDate.Date() == endDate.Date())
        	daysDifference = 1;

        if(Form.Days_Per_Week__c != '7' && Form.Total_Days_Authorized__c > daysDifference)
        {
            this.FormInvalid = true;
            ShowMessage('fatal','The days between Start Date and End Date (' + string.valueOf(daysDifference) + '): Total Days Authorized must be less than Total Calendar Days when Days Per Week is less than 7.');
            //ValidationMessages.add('The days between Start Date and End Date must match the Total Days Authorized.');
        }

        return this.FormInvalid;
    }
   
    public static void ShowMessage(String severity, String messageText)
    {
        if(severity == 'confirm')
            addMessage(new PageMessage(severity, messageText));
        else if(severity == 'warn')
            addMessage(new PageMessage(severity, messageText));
        else if(severity == 'fatal')
            addMessage(new PageMessage(severity, messageText));
        else
            addMessage(new PageMessage(severity, messageText));
    }
    public class PageMessage
    {
        public string Severity{get;set;}
        public string Message {get;set;}
        public PageMessage(string sev, string message)
        {
            this.Severity = sev;
            this.Message = message;
        }
    }
    public static void addMessage(PageMessage message)
    {
        Messages.add(message);
    }
    public static List<PageMessage> getMessages()
    {
        return Messages;
    }
    public static void sortList(List<Sobject> items, String sortField, String order)
    {
       List<Sobject> resultList = new List<Sobject>(); 
        //Create a map that can be used for sorting 
       Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
       for(Sobject ob : items)
       {
            if(objectMap.get(ob.get(sortField)) == null)
            {  // For non Sobject use obj.ProperyName
                objectMap.put(ob.get(sortField), new List<Sobject>()); 
            }
            objectMap.get(ob.get(sortField)).add(ob);
        }       
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
     
        for(object key : keys)
        { 
            resultList.addAll(objectMap.get(key)); 
        }

        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc')
        {
            for(Sobject ob : resultList)
            {
                items.add(ob); 
            }
        }
        else if(order.toLowerCase() == 'desc')
        {
            for(integer i = resultList.size()-1; i >= 0; i--)
            {
                items.add(resultList[i]);  
            }
        }
    }
}