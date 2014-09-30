public class PhoneSystemLogin {

    public static void callTriggerInsert(IncomingCall__c ic) {
    
        PhoneSystemLogin__c psl = [SELECT Id, CallsNewTemp__c, CallsKnownTemp__c, CallsNewLengthTemp__c, CallsKnownLengthTemp__c FROM PhoneSystemLogin__c WHERE Id = :ic.PhoneSystemLogin__c];
        
        if (ic.NewClient__c) {
            if (psl.CallsNewTemp__c == null) psl.CallsNewTemp__c = 0;        
            psl.CallsNewTemp__c = psl.CallsNewTemp__c + 1;
            
            if (psl.CallsNewLengthTemp__c == null) psl.CallsNewLengthTemp__c = 0;        
            psl.CallsNewLengthTemp__c = psl.CallsNewLengthTemp__c + ic.Length__c;
            
        } else {
            if (psl.CallsKnownTemp__c == null) psl.CallsKnownTemp__c = 0;        
            psl.CallsKnownTemp__c = psl.CallsKnownTemp__c + 1;
            
            if (psl.CallsKnownLengthTemp__c == null) psl.CallsKnownLengthTemp__c = 0;        
            psl.CallsKnownLengthTemp__c = psl.CallsKnownLengthTemp__c + ic.Length__c;
        }

        try {
            update psl;
        } catch (DmlException e) {

        }
    }

    public static void callTriggerUpdate(IncomingCall__c ic, IncomingCall__c icNew) {
    
        PhoneSystemLogin__c psl = [SELECT Id, CallsNewTemp__c, CallsKnownTemp__c, CallsNewLengthTemp__c, CallsKnownLengthTemp__c FROM PhoneSystemLogin__c WHERE Id = :ic.PhoneSystemLogin__c];
        
        if (ic.Length__c != null) {        
            if (ic.NewClient__c) {                
                psl.CallsNewLengthTemp__c = psl.CallsNewLengthTemp__c - ic.Length__c;                
            } else {
                psl.CallsKnownLengthTemp__c = psl.CallsKnownLengthTemp__c - ic.Length__c;
            }
        }
        
        if (icNew.NewClient__c) {                
            psl.CallsNewLengthTemp__c = psl.CallsNewLengthTemp__c + icNew.Length__c;                
        } else {
            psl.CallsKnownLengthTemp__c = psl.CallsKnownLengthTemp__c + icNew.Length__c;
        }
        
        try {
            update psl;
        } catch (DmlException e) {

        }
    }
}