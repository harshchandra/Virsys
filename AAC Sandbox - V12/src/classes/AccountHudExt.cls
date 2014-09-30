public class AccountHudExt 
{
        public Account MasterAccount {get;set;}
        public List<Support_Group_Member__c> SupportGroupMembers {get;set;}
        public boolean ShowSupportGroupMemberPanel {get;set;}
         
        public AccountHudExt(ApexPages.StandardController controller)
        {
                MasterAccount = (Account)controller.getRecord();
                SupportGroupMembers = [SELECT Id,Name,Home_Phone__c,Mobile_Phone__c,Work_Phone__c,Relationship_To_Client__c,Authorized_on_Release_Form__c FROM Support_Group_Member__c WHERE Person_Account__c != '' AND Person_Account__c = :MasterAccount.Id];
                if(SupportGroupMembers.size() > 0)
                        ShowSupportGroupMemberPanel = true;
                else
                        ShowSupportGroupMemberPanel = false;
        }
        
}