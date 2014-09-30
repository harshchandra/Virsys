global class AgentReportCardGenerator implements Schedulable {
public static String CRON_EXP = '0 0 9 * * ? 2014';

global void execute(SchedulableContext ctx)
{
    //get the first day of the current month
    DateTime startDate = System.today().toStartOfMonth();
    //get the last day of the current month
    DateTime endDate = startDate.addDays(Date.daysInMonth(startDate.year(), startDate.month()) - 1);
    //First get all users that dont have an action plan created
    List<User> users = [SELECT Id,Name,Extension 
                                FROM User 
                                WHERE IsActive = true 
                                AND Extension != null 
                                AND Profile.Name IN('AAC-Inside Sales User','AAC-Intervention Specialists') 
                                AND Id NOT IN(SELECT Agent__c FROM Agent_Action_Plan__c)
                                ORDER BY NAME];

    List<Agent_Action_Plan__c> actionPlans = new List<Agent_Action_Plan__c>();
    
    for(User u : users)
    {
        Agent_Action_Plan__c ap = new Agent_Action_Plan__c();
        ap.Agent__c = u.Id;
        ap.Status__c = 'In Progress';
        ap.Due_Date__c = datetime.now().addDays(30).date();
        
        actionPlans.add(ap);
    }
    
    insert actionPlans;
    
    
    List<User> updateUsers = [SELECT Id,Name,Extension 
                                FROM User 
                                WHERE IsActive = true 
                                AND Extension != null 
                                AND Profile.Name IN('AAC-Inside Sales User','AAC-Intervention Specialists')
                                AND Id IN(SELECT Agent__c FROM Agent_Action_Plan__c WHERE Due_Date__c = :datetime.now().date())
                                ORDER BY NAME LIMIT 10];
                                
                                
    List<Attachment> attachments = new List<Attachment>();
    
    for(User u : updateUsers)
    {
        Agent_Action_Plan__c ap = [SELECT Id FROM Agent_Action_Plan__c WHERE Agent__c = :u.Id AND Due_Date__c = TODAY ORDER BY CreatedDate DESC LIMIT 1];
        //create the controller for the report card automatically
        AgentReportCardController controller = new AgentReportCardController();
        //populate the start date
        controller.TempCase.Facility_Admission_Date__c = startDate.date();
        //populate the end date
        controller.TempCase.Facility_Date_of_discharge__c = endDate.date();
        //set the selected user we are going to run this report card for
        controller.setSelectedUsers(new String[]{u.Extension});
        //generate the report card
        PageReference ref = controller.GetAgentReportCard();
        //artifically redirect the system to the pdf version
        PageReference pdf = controller.GeneratePDF();
    
        //create an attachment
        Attachment a = new Attachment();
        Blob body;
        try
        {
            //looks up the page, which is renderas pdf and stores it
            body = pdf.getContent();
        }
        catch(VisualforceException e)
        {
            body = Blob.valueOf('Error: ' + e);
        }
        a.Body = body;
        a.Name = datetime.now().addDays(1).month() + '/' +  datetime.now().addDays(1).year() + ' Action Plan For ' + u.Name;
        a.IsPrivate = false;
        a.ParentId = ap.Id;
        attachments.add(a);
    }
    
    insert attachments;
}

@isTest(seealldata=true)
public static void test()
{
    Test.startTest();
    Account a = new Account(FirstName='John',LastName='Doe');
    insert a;
    
    
    Case c = new Case();
    c.AccountId = a.Id;
    c.Treatment_Facility__c = 'Greenhouse';
    c.Funding_Type__c = 'Private Pay';
    c.Status = 'Admitted';
    insert c;
    
    String jobID = System.schedule('testSchedule',AgentReportCardGenerator.CRON_EXP, new AgentReportCardGenerator());
    CronTrigger ct = [SELECT Id,CronExpression,TimesTriggered,NextFireTime FROM CronTrigger WHERE id = :jobId];
    System.assertEquals(AgentReportCardGenerator.CRON_EXP, ct.CronExpression);
    System.assertEquals(0, ct.TimesTriggered);
    
    Test.stopTest();

}
}