trigger ICAfterInsertTrigger on IncomingCall__c (after insert) {

    IncomingCall__c[] calls = Trigger.new;
    
    for ( IncomingCall__c call : calls) {

        PhoneSystemLogin.callTriggerInsert(call);
    }
}