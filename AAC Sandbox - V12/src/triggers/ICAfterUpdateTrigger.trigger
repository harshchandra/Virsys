trigger ICAfterUpdateTrigger on IncomingCall__c (after update) {

    IncomingCall__c[] calls = Trigger.new;
    
    for ( IncomingCall__c call : calls) {
    
        PhoneSystemLogin.callTriggerUpdate(Trigger.oldMap.get(call.Id), call);
    }
}