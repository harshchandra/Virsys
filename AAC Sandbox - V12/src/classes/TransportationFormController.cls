public class TransportationFormController {
  public Case ParentCase{get;set;}
  public Transportation__c Form{get;set;}
  public Map<String, String> FieldLabels{get;set;}
  public Map<String, String> FieldHelpText{get;set;}
  public Boolean ShowRequestTransportation
        {
                get
                {
                        if(Form.Transportation_Status__c == null)
                                return true;
                        else
                                return false;
                }
                set;
        }
  public Boolean ShowConfirmTransportation
  {
        get
        {
                if(Form.Transportation_Status__c == 'Requested' || Form.Transportation_Status__c == 'Updated')
                        return true;
                else
                        return false;   
        }
        set;
  }
  public Boolean ShowUpdateTransportation
  {
        get
        {
                if(Form.Transportation_Status__c == 'Requested' || Form.Transportation_Status__c == 'Updated')
                        return true;
                else
                        return false;
        }
        set;
  }
        public TransportationFormController(ApexPages.StandardController controller)
        {
                Form = (Transportation__c)controller.getRecord();
            ParentCase = [SELECT Id,Status,CreatedByid,Funding_Type__c,CaseNumber,Insurance_Status__c,OwnerId FROM Case WHERE Id = :Form.Case__c];
            
            FieldLabels = new Map<String, String>();
            FieldHelpText = new Map<String, String>();
            
            Map<String, Schema.SObjectType> globalDescription = Schema.getGlobalDescribe();  
            Schema.sObjectType objType = globalDescription.get('Transportation__c');  
        
            Schema.DescribeSObjectResult objResult = objType.getDescribe();  
            Map<String, Schema.SObjectField> mapFields = objResult.fields.getMap();  
            for(Schema.SObjectField field : mapFields.values())  
            {  
              Schema.DescribeFieldResult fieldResult = field.getDescribe();  
              if(fieldResult.isAccessible())
              { 
                String name = fieldResult.getName();           
                FieldLabels.put(name, fieldResult.getLabel());  
                FieldHelpText.put(name, fieldResult.getInlineHelpText());
              }
            }  
        }
        
        public PageReference RequestTransportation()
        {
                Form.Transportation_Status__c = 'Requested';
                upsert Form;
                
                return null;
        }
        public PageReference UpdateTransportation()
        {
                Form.Transportation_Status__c = 'Updated';
                upsert Form;
                
                return null;
        }
        public PageReference ConfirmTransportation()
        {
                Form.Transportation_Status__c = 'Confirmed';
                update Form;
                
                return null;
        }
}