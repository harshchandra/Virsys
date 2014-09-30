global class HistoricalReportData implements Schedulable {

public static String CRON_EXP = '0 0 9 * * ? 2014';

global void execute(SchedulableContext ctx)
{
    //get Census Cases
    //have to use aggregate result objects because we are grouping  
    AggregateResult[] results = 
                       [SELECT Treatment_Facility__c, Funding_Type__c, Count(CaseNumber) Total
                        FROM Case where status = 'Admitted'
                        group by Treatment_Facility__c, Funding_Type__c];

    List<Historical_Data_Point__c> dataPoints = new List<Historical_Data_Point__c>();
    for(AggregateResult c : results)
    {
        ReportDataItem rd = new ReportDataItem(c);
        Historical_Data_Point__c hdp = new Historical_Data_Point__c();
        hdp.Report_Type__c = 'Census';
        hdp.Data_Item__c = rd.Facility;
        hdp.Data_Classification__c = rd.FundingType;
        hdp.Data_Value__c = rd.Total;
        dataPoints.add(hdp);
    }
    
    
    results = [SELECT Treatment_Facility_Lookup__r.Name Treatment_Facility__c,Funding_Type__c, Count(CaseNumber) Total
                FROM Case where status = 'Admitted'
                and Treatment_Facility_Lookup__r.Name != null
                and Treatment_Facility__c = null
                group by Treatment_Facility_Lookup__r.Name, Funding_Type__c];
               
    for(AggregateResult c : results)
    {
        ReportDataItem rd = new ReportDataItem(c);
        Historical_Data_Point__c hdp = new Historical_Data_Point__c();
        hdp.Report_Type__c = 'Census';
        hdp.Data_Item__c = rd.Facility;
        hdp.Data_Classification__c = rd.FundingType;
        hdp.Data_Value__c = rd.Total;

        dataPoints.add(hdp);        
    }
    
    insert dataPoints;
}

//wrapper for holding results
public class ReportDataItem
{
    public String Facility {get;set;}
    public Integer Total {get;set;}
    public String FundingType {get;set;}
    
    public ReportDataItem(AggregateResult c)
    {       
        Facility = (String)c.get('Treatment_Facility__c');
        Total = (Integer)c.get('Total');
        FundingType = (String)c.get('Funding_Type__c');
    }
}
}