public with sharing class PhoneSystemLoginController {
    
    public List<Wrapper> FilteredPSLs{get;set;}

    public PhoneSystemLogin__c SearchCriteria{get;set;}

    public Date DateFrom {get; set;}
    public Date DateTo {get; set;}
    
    public Integer LoginCount {get; set;}
    
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
     
    public PhoneSystemLoginController ()
    {
        SearchCriteria = new PhoneSystemLogin__c();
        LoginCount = 0;
        
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
    }
    
    public void filterPhoneSystemLogin()    
    {
        FilteredPSLs = new List<Wrapper>();
        List<PhoneSystemLogin__c> fpsl = new List<PhoneSystemLogin__c>();
        
        if (DateFrom != null && DateTo != null)
        fpsl = [SELECT User__c, Timestamp__c, TimestampEnd__c, Name, CallsKnown__c, CallsNew__c, CallsKnownLength__c, CallsNewLength__c FROM PhoneSystemLogin__c WHERE User__c =: SearchCriteria.User__c AND Timestamp__c >=: datetime.newInstance(DateFrom.year(), DateFrom.Month(), DateFrom.Day()) AND Timestamp__c <=: datetime.newInstance(DateTo.year(), DateTo.Month(), DateTo.Day()).addDays(1) ORDER BY Timestamp__c];
        else if (DateFrom != null)
        fpsl = [SELECT User__c, Timestamp__c, TimestampEnd__c, Name, CallsKnown__c, CallsNew__c, CallsKnownLength__c, CallsNewLength__c FROM PhoneSystemLogin__c WHERE User__c =: SearchCriteria.User__c AND Timestamp__c >=: datetime.newInstance(DateFrom.year(), DateFrom.Month(), DateFrom.Day()) ORDER BY Timestamp__c];
        else if (DateTo != null)
        fpsl = [SELECT User__c, Timestamp__c, TimestampEnd__c, Name, CallsKnown__c, CallsNew__c, CallsKnownLength__c, CallsNewLength__c FROM PhoneSystemLogin__c WHERE User__c =: SearchCriteria.User__c AND Timestamp__c <=: datetime.newInstance(DateTo.year(), DateTo.Month(), DateTo.Day()).addDays(1) ORDER BY Timestamp__c];
        else
        fpsl = [SELECT User__c, Timestamp__c, TimestampEnd__c, Name, CallsKnown__c, CallsNew__c, CallsKnownLength__c, CallsNewLength__c FROM PhoneSystemLogin__c WHERE User__c =: SearchCriteria.User__c ORDER BY Timestamp__c];
        
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
        
         if(fpsl.size() == 0)
         {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,''+'No records to display')); 
         } else {
                    
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
        
             Integer j = 0;
       
             for(PhoneSystemLogin__c o : fpsl) {
               FilteredPSLs.add(new Wrapper(o));
               
               long oCallsAllLength = o.CallsKnownLength__c.longValue() + o.CallsNewLength__c.longValue();
               allTotalSec += oCallsAllLength;
               
               long oCallsKnownLength = o.CallsKnownLength__c.longValue();
               knownTotalSec += oCallsKnownLength;
               
               long oCallsNewLength = o.CallsNewLength__c.longValue();
               newTotalSec += oCallsNewLength;
               
               if (j == 0) {
                   
                   allMinSec = oCallsAllLength;
                   allMaxSec = oCallsAllLength;
                   
                   knownMinSec = oCallsKnownLength;
                   knownMaxSec = oCallsKnownLength;
                   
                   newMinSec = oCallsNewLength;
                   newMaxSec = oCallsNewLength;
               } else {
                   
                   if (oCallsAllLength < allMinSec) allMinSec = oCallsAllLength;
                   if (oCallsAllLength > allMaxSec) allMaxSec = oCallsAllLength;
                   
                   if (oCallsKnownLength < knownMinSec) knownMinSec = oCallsKnownLength;
                   if (oCallsKnownLength > knownMaxSec) knownMaxSec = oCallsKnownLength;
                   
                   if (oCallsNewLength < newMinSec) newMinSec = oCallsNewLength;
                   if (oCallsNewLength > newMaxSec) newMaxSec = oCallsNewLength;
               }
               
               
               if (o.Timestamp__c != null && o.TimestampEnd__c != null) {
                   long dt1 = o.Timestamp__c.getTime() / 1000;
                   long dt2 = o.TimestampEnd__c.getTime() / 1000;
                   long diff = dt2 - dt1;
                   
                   totalSec += diff;
                   
                   if (j == 0) {
                       minSec = diff;
                       maxSec = diff;
                   } else {
                       if (diff < minSec) minSec = diff;
                       if (diff > maxSec) maxSec = diff;
                   }
               } else {
                   if (minSec > 0) minSec = 0;
               }
               
               j++;
             }
             
             LoginCount = FilteredPSLs.size();
             
             TimeTotal = getTimeDiffStr(totalSec);
             TimeAvg = getTimeDiffStr(totalSec / LoginCount);
             TimeMin = getTimeDiffStr(minSec);
             TimeMax = getTimeDiffStr(maxSec);
             
             AllTimeTotal = getTimeDiffStr(allTotalSec);
             AllTimeAvg = getTimeDiffStr(allTotalSec / LoginCount);
             AllTimeMin = getTimeDiffStr(allMinSec);
             AllTimeMax = getTimeDiffStr(allMaxSec);
             
             KnownTimeTotal = getTimeDiffStr(knownTotalSec);
             KnownTimeAvg = getTimeDiffStr(knownTotalSec / LoginCount);
             KnownTimeMin = getTimeDiffStr(knownMinSec);
             KnownTimeMax = getTimeDiffStr(knownMaxSec);
             
             NewTimeTotal = getTimeDiffStr(newTotalSec);
             NewTimeAvg = getTimeDiffStr(newTotalSec / LoginCount);
             NewTimeMin = getTimeDiffStr(newMinSec);
             NewTimeMax = getTimeDiffStr(newMaxSec);              
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
         
         
         LoginCount = FilteredPSLs.size();
         
         
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

         Integer i = 0;
         for (Wrapper w : FilteredPSLs) {
             
             SumCallsAll += w.callsAll;
             SumCallsKnown += w.callsKnown;
             SumCallsNew += w.callsNew;

             if (i == 0) {
                 
                 MinCallsAll = w.callsAll;
                 MaxCallsAll = w.callsAll;
                 MinCallsKnown = w.callsKnown;
                 MaxCallsKnown = w.callsKnown;
                 MinCallsNew = w.callsNew;
                 MaxCallsNew = w.callsNew;
                 
             } else {
             
                 if (w.callsAll < MinCallsAll) MinCallsAll = w.callsAll;
                 if (w.callsAll > MaxCallsAll) MaxCallsAll = w.callsAll;
                 if (w.callsKnown < MinCallsKnown) MinCallsKnown = w.callsKnown;
                 if (w.callsKnown > MaxCallsKnown) MaxCallsKnown = w.callsKnown;
                 if (w.callsNew < MinCallsNew) MinCallsNew = w.callsNew;
                 if (w.callsNew > MaxCallsNew) MaxCallsNew = w.callsNew;
             }
                          
             i++;
         }
         
         if (LoginCount > 0) {
             
             Double tempSumCallsAll = SumCallsAll;
             Double tempSumCallsKnown = SumCallsKnown;
             Double tempSumCallsNew = SumCallsNew;
             
             Double tempLoginCount = LoginCount;
         
             AvgCallsAll = tempSumCallsAll / tempLoginCount;
             AvgCallsAll = AvgCallsAll.setScale(2);
             
             AvgCallsKnown = tempSumCallsKnown / tempLoginCount;
             AvgCallsKnown = AvgCallsKnown.setScale(2);
             
             AvgCallsNew = tempSumCallsNew / tempLoginCount;
             AvgCallsNew = AvgCallsNew.setScale(2);
         }
         
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
    public Wrapper(PhoneSystemLogin__c o) {
      psl = o;
      
      if (o.TimestampEnd__c != null)
      diff = getDifferenceInSeconds(o.Timestamp__c, o.TimestampEnd__c);
      else
      diff = '';
      
      long tempCallsAllLength = 0;
      
      if (o.CallsKnownLength__c != null && o.CallsKnownLength__c > 0) {
          callsKnownLength = getTimeDiffStr(o.CallsKnownLength__c.longValue());
          tempCallsAllLength += o.CallsKnownLength__c.longValue();
      } else
      callsKnownLength = '0s';
            
      if (o.CallsNewLength__c != null && o.CallsNewLength__c > 0) {
          callsNewLength = getTimeDiffStr(o.CallsNewLength__c.longValue());
          tempCallsAllLength += o.CallsNewLength__c.longValue();
      } else
      callsNewLength = '0s';
      
      if (tempCallsAllLength > 0) {
          callsAllLength = getTimeDiffStr(tempCallsAllLength);
      } else
      callsAllLength = '0s';
      
      
      callsKnown = 0;
      callsNew = 0;
      
      /*
      AggregateResult[] aggResultsKnown = [SELECT COUNT(Timestamp__c) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__r.Name =: psl.Name AND NewClient__c =: false];
      callsKnown = Integer.valueOf(aggResultsKnown[0].get('cnt'));
     
      AggregateResult[] aggResultsNew = [SELECT COUNT(Timestamp__c) cnt FROM IncomingCall__c WHERE PhoneSystemLogin__r.Name =: psl.Name AND NewClient__c =: true];
      callsNew = Integer.valueOf(aggResultsNew[0].get('cnt'));
      */
      
      if (o.CallsKnown__c != null) callsKnown = o.CallsKnown__c.intValue();
      if (o.CallsNew__c != null) callsNew = o.CallsNew__c.intValue();
      
      
      callsAll = callsKnown + callsNew;
    }
    
    public PhoneSystemLogin__c psl { get; set; }
    
    public string diff { get; set; }
    
    public Integer callsAll { get; set; }
    public Integer callsKnown { get; set; }
    public Integer callsNew { get; set; }
    
    public string callsAllLength { get; set; }
    public string callsKnownLength { get; set; }
    public string callsNewLength { get; set; }
    
    private string getDifferenceInSeconds(datetime firstDT, datetime secondDT){  
       long dt1 = firstDT.getTime() / 1000;
       long dt2 = secondDT.getTime() / 1000;
       long d = dt2 - dt1;
       
       string txt = '';
       
       if (d >= 3600) {           
           txt += (d/3600) + 'h';
           d = math.mod(d, 3600);
       }
       
       if (d >= 60) {           
           txt += ' ' + (d/60) + 'm';
           d = math.mod(d, 60);
       }
       
       if (d > 0) {
           txt += ' ' + d + 's';
       }
       
       return txt;
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
    
}
    
    
}