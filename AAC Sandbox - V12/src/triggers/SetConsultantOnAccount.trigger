trigger SetConsultantOnAccount on Account (before insert, before update) {
    Map<string, Id> userMap = new Map<string, Id>();
    List<User> userList = [SELECT Id, Name FROM User];
    for(User u : userList)
    {
        userMap.put(u.Name, u.Id);
    }
     
    for(Account a : trigger.new)
    {
        if(a.Consultant2__c != null && a.Consultant2__c != '' && a.Consultant2__c != ' ')
        {
            if(userMap.containskey(a.Consultant2__c))
            {
                a.Consultant__c = userMap.get(a.Consultant2__c);
                a.Consultant_Lookup__c = userMap.get(a.Consultant2__c);
            }
        }
    }
}