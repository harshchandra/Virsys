public class LevelOfCareCalendarController 
{
        public static Utilization_Review__c Form {get;set;}
        public static List<Dates_of_Service__c> DatesOfService {get;set;}

        public LevelOfCareCalendarController(ApexPages.StandardController controller)
        {
            Form = (Utilization_Review__c)controller.getRecord();
        }
        
        @RemoteAction
        public static CalendarEvent[] ProcessDatesOfService(string formId)
        {   
            List<Dates_of_Service__c> dos = [SELECT Id, Start_Date__c, End_Date__c, Level_of_Care__c FROM Dates_of_Service__c WHERE Utilization_Review_Form__c = :formId];
            List<CalendarEvent> events = new List<CalendarEvent>();             
            for(Dates_of_Service__c d : dos)
            {
                Date s = d.Start_Date__c;
                Date e = d.End_Date__c;
                CalendarEvent c = new CalendarEvent();
                c.Title = d.Level_of_Care__c;
                c.StartDate = s.format();
                c.EndDate = e.format();
                events.add(c);
            }                  
            return events;
        }
        public class CalendarEvent
        {
            public string Title {get;set;}
            public string StartDate {get;set;}
            public string EndDate {get;set;}
            
            public CalendarEvent()
            {
                    
            }
        }
}