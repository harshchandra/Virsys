public with sharing class TBN_DOSAmountRollUpHandler 
{
    public TBN_DOSAmountRollUpHandler()
    {
        
    }
    
    /*Method to be called before insert of DOS records*/
    public void onBeforeInsert(List<Dates_of_Service__c>lstnew)
    {
        for(Dates_of_Service__c objDos : lstnew)
        {
            if(objDos.Patient_Id__c != null)
                objDos.Account__c = Id.valueof(objDos.Patient_Id__c);
            system.debug('----objDos.Account__c---'+objDos.Account__c);
        }
    }
    /*Method to be called after insert of DOS records*/
    public void onAfterInsert(Map<Id,Dates_of_Service__c> oldMap, Map<Id,Dates_of_Service__c> newMap)
    {
        Set<Id> setClaimId = new Set<Id>();
        for(Dates_of_Service__c objNewDOS : newMap.values())
        {
            if(objNewDOS.Claim__c != null)
                setClaimId.add(objNewDOS.Claim__c);
        }
        calculateTotalAmount(newMap);
        if(setClaimId != null && setClaimId.size() > 0)
            updateClaimValues(setClaimId);
    }
    
    /*Method to be called after Update of DOS records*/
    public void onAfterUpdate(Map<Id,Dates_of_Service__c> oldMap, Map<Id,Dates_of_Service__c> newMap)
    {
        Set<Id> setClaimIdUpdate = new Set<Id>();
        for(Dates_of_Service__c objNewDOS : newMap.values())
        {
            if(objNewDOS.Claim__c != null)
                setClaimIdUpdate.add(objNewDOS.Claim__c);
            if(objNewDOS.Claim__c != oldMap.get(objNewDOS.Id).Claim__c && oldMap.get(objNewDOS.Id).Claim__c != null)    
                setClaimIdUpdate.add(oldMap.get(objNewDOS.Id).Claim__c);
        }
        system.debug('+++++++++setClaimIdUpdate+++++1+++++++'+setClaimIdUpdate);
        calculateTotalAmount(newMap);
        system.debug('+++++++++setClaimIdUpdate+++++2+++++++'+setClaimIdUpdate);
        if(setClaimIdUpdate != null && setClaimIdUpdate.size() > 0)
            updateClaimValues(setClaimIdUpdate);
    }
    
    /*Method to be called after Delete of DOS records*/
    public void onAfterDelete(Map<Id,Dates_of_Service__c> oldMap, Map<Id,Dates_of_Service__c> newMap)
    {
        calculateTotalAmount(oldMap);
    }
    public void onBeforeUpdate(Map<Id,Dates_of_Service__c> oldMap, Map<Id,Dates_of_Service__c> newMap)
    {
        for(Dates_of_Service__c objDos : newMap.values())
        {
            if(objDos.Patient_Id__c != null)
                objDos.Account__c = Id.valueof(objDos.Patient_Id__c);
            system.debug('----objDos.Account__c---'+objDos.Account__c);
        }
    
    }
    /*Common Method for calculating the TotalPaidAmount and TotalPatientResponsiblityAmount*/
    private void calculateTotalAmount(Map<Id,Dates_of_Service__c> mapDOS)
    {
        Set<String> setAccountId = new Set<String>();
        Map<Id, List<Dates_of_Service__c>> mapAccountIdToLstDOS = new Map<Id, List<Dates_of_Service__c>>();
        Map<Id, Decimal> mapAcccountIdTOTotalPaidAmount = new Map<Id, Decimal>();
        Map<Id, Decimal> mapAccountIdTOTotalPatientResponsiblityAmount = new Map<Id, Decimal>();
        Map<Id, Decimal> mapAccountIdTOTotalInsuranceAdjustedAmount = new Map<Id, Decimal>();
        Map<Id, Decimal> mapAccountIdTOTotalP2PAmount = new Map<Id, Decimal>();
        Map<Id, Decimal> mapAccountIdTOTotalAmount = new Map<Id, Decimal>();
        List<Account> lstAccountToUpdate = new List<Account>();
        List<Dates_of_Service__c> lstDatesOfService = new List<Dates_of_Service__c>();
        
        try
        {
            for(Dates_of_Service__c objDOS : mapDOS.values())
            {
                if(objDOS.Patient_Id__c != null)
                    setAccountId.add(objDOS.Patient_Id__c);
            }
            system.debug('****setAccountId****** : '+setAccountId);
            
            for(Dates_of_Service__c objDOS : [Select Patient_Responsibility_Amount__c, Total_P2P_Balance__c, Id, Case_Id__c, Amount_Paid__c,Insurance_Adjusted_Amount__c,Amount__c,Account__c,Patient_Id__c 
                                                From Dates_of_Service__c 
                                                Where Patient_Id__c IN: setAccountId])
            {
                system.debug('-objDOS---'+objDOS.Patient_Id__c);
                system.debug('-objDOS---'+objDOS.Account__c);
                if(objDOS.Patient_Id__c != null)
                {
                    if(mapAccountIdToLstDOS.containsKey(objDOS.Patient_Id__c))
                        mapAccountIdToLstDOS.get(objDOS.Patient_Id__c).add(objDOS);
                    else
                        mapAccountIdToLstDOS.put(objDOS.Patient_Id__c, new List<Dates_of_Service__c>{objDOS});
                }
            }
            system.debug('^^^^mapAccountIdToLstDOS^^^^^ : '+mapAccountIdToLstDOS);
            
            for (Id key : mapAccountIdToLstDOS.keySet())
            {
                Decimal totalPaidAmount = 0;
                Decimal totalPatientResponsiblityAmount = 0;
                Decimal totalInsuranceAdjustedAmount = 0;
                Decimal totalAmount =  0;
                Decimal totalP2PAmount =  0;
                
                for(Dates_of_Service__c objDOS : mapAccountIdToLstDOS.get(key))
                {
                    system.debug('######objDOS#### : '+objDOS);
                    if(objDOS.Amount_Paid__c != null)
                        totalPaidAmount += objDOS.Amount_Paid__c;
                    if(objDOS.Patient_Responsibility_Amount__c != null)
                        totalPatientResponsiblityAmount += objDOS.Patient_Responsibility_Amount__c;
                    if(objDOS.Insurance_Adjusted_Amount__c != null)
                        totalInsuranceAdjustedAmount += objDOS.Insurance_Adjusted_Amount__c;
                    if(objDOS.Amount__c != null)
                        totalAmount += objDOS.Amount__c;
                    if(objDOS.Total_P2P_Balance__c != null)
                        totalP2PAmount += objDOS.Total_P2P_Balance__c;
                }
                system.debug('$$$$totalPaidAmount$$$$$ : '+totalPaidAmount);
                system.debug('-------mapAccountIdTOTotalP2PAmount : '+totalPaidAmount);
                mapAcccountIdTOTotalPaidAmount.put(key, totalPaidAmount); 
                mapAccountIdTOTotalPatientResponsiblityAmount.put(key, totalPatientResponsiblityAmount);
                mapAccountIdTOTotalInsuranceAdjustedAmount.put(key,totalInsuranceAdjustedAmount);
                mapAccountIdTOTotalAmount.put(key,totalAmount);
                mapAccountIdTOTotalP2PAmount.put(key,totalP2PAmount);
            }
         
            for(Id objAccountID : mapAcccountIdTOTotalPaidAmount.keySet())   
            {
                Account objAccount =  new Account(Id = objAccountID);
                if(mapAcccountIdTOTotalPaidAmount.containsKey(objAccount.Id) && mapAcccountIdTOTotalPaidAmount.get(objAccount.Id) != null)
                    objAccount.Total_Paid__c = mapAcccountIdTOTotalPaidAmount.get(objAccount.Id);
                /*if(mapAccountIdTOTotalPatientResponsiblityAmount.containsKey(objAccount.Id) && mapAccountIdTOTotalPatientResponsiblityAmount.get(objAccount.Id) != null)  
                    objAccount.Total_Patient_Responsibility_Amount__c = mapAccountIdTOTotalPatientResponsiblityAmount.get(objAccount.Id);*/
                if(mapAccountIdTOTotalInsuranceAdjustedAmount.containsKey(objAccount.Id) && mapAccountIdTOTotalInsuranceAdjustedAmount.get(objAccount.Id) != null)
                    objAccount.Total_Adjustment__c = mapAccountIdTOTotalInsuranceAdjustedAmount.get(objAccount.Id);
                if(mapAccountIdTOTotalP2PAmount.containsKey(objAccount.Id) && mapAccountIdTOTotalP2PAmount.get(objAccount.Id) != null)
                    objAccount.Total_P2P_Balance__c = mapAccountIdTOTotalP2PAmount.get(objAccount.Id);
                if(mapAccountIdTOTotalAmount.containsKey(objAccount.Id) && mapAccountIdTOTotalAmount.get(objAccount.Id) != null)
                {
                    objAccount.Total_Balance__c = mapAccountIdTOTotalAmount.get(objAccount.Id);
                    if(objAccount.Total_Balance__c != null && objAccount.Total_Paid__c != null && objAccount.Total_Paid__c == 0)    
                        objAccount.Total_Adjustment__c = objAccount.Total_Balance__c;
                }
                lstAccountToUpdate.add(objAccount);
            }
            system.debug('---lstAccountToUpdate----'+lstAccountToUpdate);
            update lstAccountToUpdate;
        }
        catch(Exception e)
        {
            //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,e.getMessage()));
            system.debug('%%%%%%%%Exception%%%%%%% : '+e);
        }
    }
    
    public void updateClaimValues(Set<Id> setClaimIds)
    {
        Map<Id, Decimal> mapClaim_Amount = new Map<Id, Decimal>();
        Map<Id, Decimal> mapClaim_PaidAmount = new Map<Id, Decimal>();
        Map<Id, Date> mapClaim_StDate = new Map<Id, Date>();
        Map<Id, Date> mapClaim_EndDate = new Map<Id, Date>();
        for(Dates_of_Service__c objDOSAdded : [Select Id, Claim__c, Amount__c, End_Date__c, Start_Date__c, Amount_Paid__c
                                                from Dates_of_Service__c 
                                                where Claim__c IN: setClaimIds])
        {
            if(objDOSAdded.Amount__c != null)
            {
                if(!mapClaim_Amount.containsKey(objDOSAdded.Claim__c))
                    mapClaim_Amount.put(objDOSAdded.Claim__c, objDOSAdded.Amount__c);
                else
                {
                    Decimal decTemp = mapClaim_Amount.get(objDOSAdded.Claim__c) + objDOSAdded.Amount__c;
                    mapClaim_Amount.put(objDOSAdded.Claim__c, decTemp);
                }       
            }
            if(objDOSAdded.Amount_Paid__c != null)
            {
                if(!mapClaim_PaidAmount.containsKey(objDOSAdded.Claim__c))
                    mapClaim_PaidAmount.put(objDOSAdded.Claim__c, objDOSAdded.Amount_Paid__c);
                else
                {
                    Decimal decTemp = mapClaim_PaidAmount.get(objDOSAdded.Claim__c) + objDOSAdded.Amount_Paid__c;
                    mapClaim_PaidAmount.put(objDOSAdded.Claim__c, decTemp);
                }       
            }
            if(objDOSAdded.End_Date__c != null)
            {
                if(!mapClaim_EndDate.containsKey(objDOSAdded.Claim__c))
                    mapClaim_EndDate.put(objDOSAdded.Claim__c, objDOSAdded.End_Date__c);
                else
                {
                    Date dtEndTemp = mapClaim_EndDate.get(objDOSAdded.Claim__c);
                    if(objDOSAdded.End_Date__c > dtEndTemp)
                        mapClaim_EndDate.put(objDOSAdded.Claim__c, objDOSAdded.End_Date__c);
                }       
            }
            if(objDOSAdded.Start_Date__c != null)
            {
                if(!mapClaim_StDate.containsKey(objDOSAdded.Claim__c))
                    mapClaim_StDate.put(objDOSAdded.Claim__c, objDOSAdded.Start_Date__c);
                else
                {
                    Date dtEndTemp = mapClaim_StDate.get(objDOSAdded.Claim__c);
                    if(objDOSAdded.Start_Date__c < dtEndTemp)
                        mapClaim_StDate.put(objDOSAdded.Claim__c, objDOSAdded.Start_Date__c);
                }       
            }
        }
        List<Claim__c> lstClaimToUpdate = new List<Claim__c>();
        system.debug('+++++++++setClaimIds+++++2+++++++'+setClaimIds);
        for(Id objClaimId : setClaimIds)
        {
            Claim__c objClaimUpdated = new Claim__c(Id=objClaimId);
            if(mapClaim_Amount != null && mapClaim_Amount.containsKey(objClaimId))
                objClaimUpdated.Total_Bill_Amount__c = mapClaim_Amount.get(objClaimId);
            else
                objClaimUpdated.Total_Bill_Amount__c = 0;   
            if(mapClaim_PaidAmount != null && mapClaim_PaidAmount.containsKey(objClaimId))
                objClaimUpdated.Total_Paid_Amount__c = mapClaim_PaidAmount.get(objClaimId);
            else
                objClaimUpdated.Total_Paid_Amount__c = 0; 
            if(mapClaim_EndDate != null && mapClaim_EndDate.containsKey(objClaimId))
                objClaimUpdated.End_Date__c = mapClaim_EndDate.get(objClaimId); 
            if(mapClaim_StDate != null && mapClaim_StDate.containsKey(objClaimId))
                objClaimUpdated.Start_Date__c = mapClaim_StDate.get(objClaimId);    
            lstClaimToUpdate.add(objClaimUpdated);      
        }
        if(lstClaimToUpdate != null && lstClaimToUpdate.size() > 0)
            update lstClaimToUpdate;
    }
}