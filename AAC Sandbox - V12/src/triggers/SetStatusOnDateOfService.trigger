trigger SetStatusOnDateOfService on Dates_of_Service__c (before insert) 
{
    for(Dates_of_Service__c d : Trigger.new)
    {
        if(d.Level_of_Care__c == 'H' || d.Level_of_Care__c == 'LOA' || d.Level_of_Care__c == 'NB' || d.Level_of_Care__c == 'NBT')
        {
            d.Status__c = 'Not Applicable';
        }
    }
}