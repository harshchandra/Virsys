public with sharing class PhoneSystemLoginController2 {

    public List<Wrapper> FilteredList{get;set;}

    public Date DateFrom {get; set;}
    public Date DateTo {get; set;}
    
    public Integer UsersCount {get; set;}
    
    public Integer CountTotal { get; set; }
    public Decimal CountAvg { get; set; }
    public Integer CountMin { get; set; }
    public Integer CountMax { get; set; }
    
    public string TimeTotal { get; set; }
    public string TimeAvg { get; set; }
    public string TimeMin { get; set; }
    public string TimeMax { get; set; }
    
    public string AllTimeTotal { get; set; }
    public string AllTimeAvg { get; set; }
    public string AllTimeMin { get; set; }
    public string AllTimeMax { get; set; }
    
    public string KnownTimeTotal { get; set; }
    public string KnownTimeAvg { get; set; }
    public string KnownTimeMin { get; set; }
    public string KnownTimeMax { get; set; }
    
    public string NewTimeTotal { get; set; }
    public string NewTimeAvg { get; set; }
    public string NewTimeMin { get; set; }
    public string NewTimeMax { get; set; }
    
    public Integer SumCallsAll { get; set; }
    public Decimal AvgCallsAll { get; set; }
    public Integer MinCallsAll { get; set; }
    public Integer MaxCallsAll { get; set; }
   
    public Integer SumCallsKnown { get; set; }
    public Decimal AvgCallsKnown { get; set; }
    public Integer MinCallsKnown { get; set; }
    public Integer MaxCallsKnown { get; set; }
    
    public Integer SumCallsNew { get; set; }
    public Decimal AvgCallsNew { get; set; }
    public Integer MinCallsNew { get; set; }
    public Integer MaxCallsNew { get; set; }
     
    public PhoneSystemLoginController2 ()
    {
        UsersCount = 0;
        
        CountTotal = 0;
        CountAvg = 0;
        CountMin = 0;
        CountMax = 0;
        
        TimeTotal = '0s';
        TimeAvg = '0s';
        TimeMin = '0s';
        TimeMax = '0s';
        
        AllTimeTotal = '0s';
        AllTimeAvg = '0s';
        AllTimeMin = '0s';
        AllTimeMax = '0s';
        
        KnownTimeTotal = '0s';
        KnownTimeAvg = '0s';
        KnownTimeMin = '0s';
        KnownTimeMax = '0s';
        
        NewTimeTotal = '0s';
        NewTimeAvg = '0s';
        NewTimeMin = '0s';
        NewTimeMax = '0s';
        
        SumCallsAll = 0;
        AvgCallsAll = 0;
        MinCallsAll = 0;
        MaxCallsAll = 0;
        
        SumCallsKnown = 0;
        AvgCallsKnown = 0;
        MinCallsKnown = 0;
        MaxCallsKnown = 0;
        
        SumCallsNew = 0;
        AvgCallsNew = 0;
        MinCallsNew = 0;
        MaxCallsNew = 0;
        
        filterPhoneSystemLogin();
    }
    
    public void filterPhoneSystemLogin()    
    {
        FilteredList = new List<Wrapper>();
        AggregateResult[] aggResults;
        
        if (DateFrom != null && DateTo != null)
        aggResults = [SELECT User__c, User__r.Name, COUNT(Name) total, SUM(TimeDiff__c) sumTimeDiff, SUM(CallsKnown__c) sumCallsKnown, SUM(CallsNew__c) sumCallsNew, SUM(CallsKnownLength__c) sumCallsKnownLength, SUM(CallsNewLength__c) sumCallsNewLength FROM PhoneSystemLogin__c WHERE Timestamp__c >=: datetime.newInstance(DateFrom.year(), DateFrom.Month(), DateFrom.Day()) AND Timestamp__c <=: datetime.newInstance(DateTo.year(), DateTo.Month(), DateTo.Day()).addDays(1) GROUP BY User__c, User__r.Name ORDER BY User__c ];
        else if (DateFrom != null)
        aggResults = [SELECT User__c, User__r.Name, COUNT(Name) total, SUM(TimeDiff__c) sumTimeDiff, SUM(CallsKnown__c) sumCallsKnown, SUM(CallsNew__c) sumCallsNew, SUM(CallsKnownLength__c) sumCallsKnownLength, SUM(CallsNewLength__c) sumCallsNewLength FROM PhoneSystemLogin__c WHERE Timestamp__c >=: datetime.newInstance(DateFrom.year(), DateFrom.Month(), DateFrom.Day()) GROUP BY User__c, User__r.Name ORDER BY User__c ];
        else if (DateTo != null)
        aggResults = [SELECT User__c, User__r.Name, COUNT(Name) total, SUM(TimeDiff__c) sumTimeDiff, SUM(CallsKnown__c) sumCallsKnown, SUM(CallsNew__c) sumCallsNew, SUM(CallsKnownLength__c) sumCallsKnownLength, SUM(CallsNewLength__c) sumCallsNewLength FROM PhoneSystemLogin__c WHERE Timestamp__c <=: datetime.newInstance(DateTo.year(), DateTo.Month(), DateTo.Day()).addDays(1) GROUP BY User__c, User__r.Name ORDER BY User__c ];
        else
        aggResults = [SELECT User__c, User__r.Name, COUNT(Name) total, SUM(TimeDiff__c) sumTimeDiff, SUM(CallsKnown__c) sumCallsKnown, SUM(CallsNew__c) sumCallsNew, SUM(CallsKnownLength__c) sumCallsKnownLength, SUM(CallsNewLength__c) sumCallsNewLength FROM PhoneSystemLogin__c GROUP BY User__c, User__r.Name ORDER BY User__c ];
        
        for (AggregateResult ar : aggResults) {
        
            PhoneSystemLogin__c psl = new PhoneSystemLogin__c();
            psl.User__c = (ID)ar.get('User__c');
            
            /*
            AggregateResult[] callResultsKnown;
            AggregateResult[] callResultsNew;
            
            if (DateFrom != null && DateTo != null) {

                callResultsKnown = [SELECT COUNT(Id) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__c IN
                (SELECT Id FROM PhoneSystemLogin__c WHERE User__c =: psl.User__c AND Timestamp__c >=: datetime.newInstance(DateFrom.year(), DateFrom.Month(), DateFrom.Day()) AND Timestamp__c <=: datetime.newInstance(DateTo.year(), DateTo.Month(), DateTo.Day()).addDays(1))
                AND NewClient__c =: false
                ];
                
                callResultsNew = [SELECT COUNT(Id) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__c IN
                (SELECT Id FROM PhoneSystemLogin__c WHERE User__c =: psl.User__c AND Timestamp__c >=: datetime.newInstance(DateFrom.year(), DateFrom.Month(), DateFrom.Day()) AND Timestamp__c <=: datetime.newInstance(DateTo.year(), DateTo.Month(), DateTo.Day()).addDays(1))
                AND NewClient__c =: true
                ];
            
            } else if (DateFrom != null) {
                
                callResultsKnown = [SELECT COUNT(Id) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__c IN
                (SELECT Id FROM PhoneSystemLogin__c WHERE User__c =: psl.User__c AND Timestamp__c >=: datetime.newInstance(DateFrom.year(), DateFrom.Month(), DateFrom.Day()))
                AND NewClient__c =: false
                ];
                
                callResultsNew = [SELECT COUNT(Id) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__c IN
                (SELECT Id FROM PhoneSystemLogin__c WHERE User__c =: psl.User__c AND Timestamp__c >=: datetime.newInstance(DateFrom.year(), DateFrom.Month(), DateFrom.Day()))
                AND NewClient__c =: true
                ];
                
            } else if (DateTo != null) {
                
                callResultsKnown = [SELECT COUNT(Id) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__c IN
                (SELECT Id FROM PhoneSystemLogin__c WHERE User__c =: psl.User__c AND Timestamp__c <=: datetime.newInstance(DateTo.year(), DateTo.Month(), DateTo.Day()).addDays(1))
                AND NewClient__c =: false
                ];
                
                callResultsNew = [SELECT COUNT(Id) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__c IN
                (SELECT Id FROM PhoneSystemLogin__c WHERE User__c =: psl.User__c AND Timestamp__c <=: datetime.newInstance(DateTo.year(), DateTo.Month(), DateTo.Day()).addDays(1))
                AND NewClient__c =: true
                ];
            
            } else {
                
                callResultsKnown = [SELECT COUNT(Id) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__c IN
                (SELECT Id FROM PhoneSystemLogin__c WHERE User__c =: psl.User__c)
                AND NewClient__c =: false
                ];
                
                callResultsNew = [SELECT COUNT(Id) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__c IN
                (SELECT Id FROM PhoneSystemLogin__c WHERE User__c =: psl.User__c)
                AND NewClient__c =: true
                ];
            
            }
            */
            
            long sumTimeDiff = 0;
            if (ar.get('sumTimeDiff') != null) sumTimeDiff = ((Decimal)ar.get('sumTimeDiff')).longValue();

            FilteredList.add(new Wrapper(psl, (string)ar.get('Name'),
            ((Decimal)ar.get('total')).intValue(),
            sumTimeDiff,
            //((Decimal)callResultsKnown[0].get('cnt')).intValue(),
            //((Decimal)callResultsNew[0].get('cnt')).intValue()
            ((Decimal)ar.get('sumCallsKnown')).intValue(),
            ((Decimal)ar.get('sumCallsNew')).intValue(),
            ((Decimal)ar.get('sumCallsKnownLength')).longValue(),
            ((Decimal)ar.get('sumCallsNewLength')).longValue()
            ));

        }
        
        if(FilteredList.size() == 0)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No records to display')); 
        }
                
         
         UsersCount = FilteredList.size();
         
         CountTotal = 0;
         CountAvg = 0;
         CountMin = 0;
         CountMax = 0;
               
         SumCallsAll = 0;
         AvgCallsAll = 0;
         MinCallsAll = 0;
         MaxCallsAll = 0;
        
         SumCallsKnown = 0;
         AvgCallsKnown = 0;
         MinCallsKnown = 0;
         MaxCallsKnown = 0;
        
         SumCallsNew = 0;
         AvgCallsNew = 0;
         MinCallsNew = 0;
         MaxCallsNew = 0;

         TimeTotal = '';
         TimeAvg = '';
         TimeMin = '';
         TimeMax = '';
         
         AllTimeTotal = '';
         AllTimeAvg = '';
         AllTimeMin = '';
         AllTimeMax = '';
         
         KnownTimeTotal = '';
         KnownTimeAvg = '';
         KnownTimeMin = '';
         KnownTimeMax = '';
         
         NewTimeTotal = '';
         NewTimeAvg = '';
         NewTimeMin = '';
         NewTimeMax = '';
         
         long totalSec = 0;
         long minSec = 0;
         long maxSec = 0;
         
         long allTotalSec = 0;
         long allMinSec = 0;
         long allMaxSec = 0;
         
         long knownTotalSec = 0;
         long knownMinSec = 0;
         long knownMaxSec = 0;
         
         long newTotalSec = 0;
         long newMinSec = 0;
         long newMaxSec = 0;
         
         Integer i = 0;
         for (Wrapper w : FilteredList) {
             
             CountTotal += w.total;
             
             SumCallsAll += w.callsAll;
             SumCallsKnown += w.callsKnown;
             SumCallsNew += w.callsNew;
             
             totalSec += w.seconds;
             
             allTotalSec += w.callsAllLength;
             knownTotalSec += w.callsKnownLength;
             newTotalSec += w.callsNewLength;
             
             if (i == 0) {
                 
                 CountMin = w.total;
                 CountMax = w.total;
                 
                 MinCallsAll = w.callsAll;
                 MaxCallsAll = w.callsAll;
                 MinCallsKnown = w.callsKnown;
                 MaxCallsKnown = w.callsKnown;
                 MinCallsNew = w.callsNew;
                 MaxCallsNew = w.callsNew;
                 
                 minSec = w.seconds;
                 maxSec = w.seconds;
                 
                 allMinSec = w.callsAllLength;
                 allMaxSec = w.callsAllLength;
                 
                 knownMinSec = w.callsKnownLength;
                 knownMaxSec = w.callsKnownLength;
                 
                 newMinSec = w.callsNewLength;
                 newMaxSec = w.callsNewLength;
                       
             } else {
             
                 if (w.total < CountMin) CountMin = w.total;
                 if (w.total > CountMax) CountMax = w.total;
                 
                 if (w.callsAll < MinCallsAll) MinCallsAll = w.callsAll;
                 if (w.callsAll > MaxCallsAll) MaxCallsAll = w.callsAll;
                 if (w.callsKnown < MinCallsKnown) MinCallsKnown = w.callsKnown;
                 if (w.callsKnown > MaxCallsKnown) MaxCallsKnown = w.callsKnown;
                 if (w.callsNew < MinCallsNew) MinCallsNew = w.callsNew;
                 if (w.callsNew > MaxCallsNew) MaxCallsNew = w.callsNew;
                 
                 if (w.seconds < minSec) minSec = w.seconds;
                 if (w.seconds > maxSec) maxSec = w.seconds;
                 
                 if (w.callsAllLength < allMinSec) allMinSec = w.callsAllLength;
                 if (w.callsAllLength > allMaxSec) allMaxSec = w.callsAllLength;
                 
                 if (w.callsKnownLength < knownMinSec) knownMinSec = w.callsKnownLength;
                 if (w.callsKnownLength > knownMaxSec) knownMaxSec = w.callsKnownLength;
                 
                 if (w.callsNewLength < newMinSec) newMinSec = w.callsNewLength;
                 if (w.callsNewLength > newMaxSec) newMaxSec = w.callsNewLength;
             }
                                     
             i++;
         }
         
         TimeTotal = getTimeDiffStr(totalSec);        
         TimeMin = getTimeDiffStr(minSec);
         TimeMax = getTimeDiffStr(maxSec);
         
         AllTimeTotal = getTimeDiffStr(allTotalSec);        
         AllTimeMin = getTimeDiffStr(allMinSec);
         AllTimeMax = getTimeDiffStr(allMaxSec);
         
         KnownTimeTotal = getTimeDiffStr(knownTotalSec);        
         KnownTimeMin = getTimeDiffStr(knownMinSec);
         KnownTimeMax = getTimeDiffStr(knownMaxSec);
         
         NewTimeTotal = getTimeDiffStr(newTotalSec);        
         NewTimeMin = getTimeDiffStr(newMinSec);
         NewTimeMax = getTimeDiffStr(newMaxSec);
         
         if (UsersCount > 0) {
             
             TimeAvg = getTimeDiffStr(totalSec / UsersCount);
             
             AllTimeAvg = getTimeDiffStr(allTotalSec / UsersCount);
             KnownTimeAvg = getTimeDiffStr(knownTotalSec / UsersCount);
             NewTimeAvg = getTimeDiffStr(newTotalSec / UsersCount);
             
             Double tempCountTotal = CountTotal;
             
             Double tempSumCallsAll = SumCallsAll;
             Double tempSumCallsKnown = SumCallsKnown;
             Double tempSumCallsNew = SumCallsNew;
             
             Double tempUsersCount = UsersCount;
         
             CountAvg = tempCountTotal / tempUsersCount;
             CountAvg = CountAvg.setScale(2);
         
             AvgCallsAll = tempSumCallsAll / tempUsersCount;
             AvgCallsAll = AvgCallsAll.setScale(2);
             
             AvgCallsKnown = tempSumCallsKnown / tempUsersCount;
             AvgCallsKnown = AvgCallsKnown.setScale(2);
             
             AvgCallsNew = tempSumCallsNew / tempUsersCount;
             AvgCallsNew = AvgCallsNew.setScale(2);
         }
         
         if (TimeTotal == '') TimeTotal = '0s';
         if (TimeAvg == '') TimeAvg = '0s';
         if (TimeMin == '') TimeMin = '0s';
         if (TimeMax == '') TimeMax = '0s';
         
         if (AllTimeTotal == '') AllTimeTotal = '0s';
         if (AllTimeAvg == '') AllTimeAvg = '0s';
         if (AllTimeMin == '') AllTimeMin = '0s';
         if (AllTimeMax == '') AllTimeMax = '0s';
         
         if (KnownTimeTotal == '') KnownTimeTotal = '0s';
         if (KnownTimeAvg == '') KnownTimeAvg = '0s';
         if (KnownTimeMin == '') KnownTimeMin = '0s';
         if (KnownTimeMax == '') KnownTimeMax = '0s';
         
         if (NewTimeTotal == '') NewTimeTotal = '0s';
         if (NewTimeAvg == '') NewTimeAvg = '0s';
         if (NewTimeMin == '') NewTimeMin = '0s';
         if (NewTimeMax == '') NewTimeMax = '0s';
         
    }
    
    private string getTimeDiffStr(long s) {
    
        string str = '';
        long d = s;
        
        if (d >= 3600) {           
            str += (d/3600) + 'h';
            d = math.mod(d, 3600);
        }
               
        if (d >= 60) {           
            str += ' ' + (d/60) + 'm';
            d = math.mod(d, 60);
        }
               
        if (d > 0) {
            str += ' ' + d + 's';
        }
    
        return str;
    }
   
  public class Wrapper {
    public Wrapper(PhoneSystemLogin__c psl, string username, integer total, long seconds, integer callsKnown, integer callsNew, long callsKnownLength, long callsNewLength) {
      
      this.psl = psl;
      this.total = total;
      this.seconds = seconds;
      this.diff = getTimeDiffStr(seconds);
      
      Double tempSeconds = seconds;
      this.hours = tempSeconds / 60;
      this.hours = this.hours.setScale(2);
      
      this.callsKnown = callsKnown;
      this.callsNew = callsNew;
      this.callsAll = callsKnown + callsNew;
      
      this.callsKnownLength = callsKnownLength;
      this.callsNewLength = callsNewLength;
      this.callsAllLength = callsKnownLength + callsNewLength;
      
      this.callsKnownLengthStr = getTimeDiffStr(this.callsKnownLength);
      this.callsNewLengthStr = getTimeDiffStr(this.callsNewLength);
      this.callsAllLengthStr = getTimeDiffStr(this.callsAllLength);
      
      this.userName = username;
    }
    
    public PhoneSystemLogin__c psl { get; set; }
    public integer total { get; set; }
    public string diff { get; set; }
    
    public long seconds { get; set; }
    public Decimal hours { get; set; }
       
    public string userName { get; set; }
    
    public string callsAllLengthStr { get; set; }
    public string callsKnownLengthStr { get; set; }
    public string callsNewLengthStr { get; set; }
    
    public long callsAllLength { get; set; }
    public long callsKnownLength { get; set; }
    public long callsNewLength { get; set; }
    
    public Integer callsAll { get; set; }
    public Integer callsKnown { get; set; }
    public Integer callsNew { get; set; }
    
    private string getTimeDiffStr(long s) {
    
        string str = '';
        long d = s;
        
        if (d >= 3600) {           
            str += (d/3600) + 'h';
            d = math.mod(d, 3600);
        }
               
        if (d >= 60) {           
            str += ' ' + (d/60) + 'm';
            d = math.mod(d, 60);
        }
               
        if (d > 0) {
            str += ' ' + d + 's';
        }
    
        if (str == '') str = '0s';
    
        return str;
    }
}
    
    
}