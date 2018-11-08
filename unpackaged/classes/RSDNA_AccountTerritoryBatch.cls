/*
    Created By  : Suresh
    Email ID    : 
    Company     : NTTDATA
    Date        : 22 May,2017
    Requirement : W-000090:T-00119: Dev 
    Test Class  : RSDNA_AccountTerritoryBatchTest
    Last Updated By : 
    
*/

global class RSDNA_AccountTerritoryBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT 
                                            Id,Name,RSD_Account_Number__c,RSD_Action_Indicator__c,RSD_Error_Message__c,RSD_Extraction_Date__c,RSD_Invalid__c,
                                            RSD_Primary_External_Id__c,RSD_Primary_Indicator__c ,RSD_Processed_Date__c,RSD_Source_System__c,RSD_Territory_Id__c,RSD_Territory_Number__c 
                                        FROM 
                                            RSD_Account_To_Territory__c
                                        WHERE
                                            RSD_Processed_Date__c = NULL
                                        AND
                                            RSD_Invalid__c =false
                                        ORDER BY 
                                            RSD_Action_Indicator__c DESC,
                                            RSD_Extraction_Date__c ASC]);
    }

    global void execute(Database.BatchableContext BC, List<RSD_Account_To_Territory__c> scope) {
        
        Map<String,List<RSD_Account_To_Territory__c>> mapAcctNumUSMFTerr=new Map<String,List<RSD_Account_To_Territory__c>>();
        Map<String,List<RSD_Account_To_Territory__c>> mapAcctNumCMFTerr=new Map<String,List<RSD_Account_To_Territory__c>>();
        Map<String,List<RSD_Account_To_Territory__c>> mapTerr=new Map<String,List<RSD_Account_To_Territory__c>>();
        for (RSD_Account_To_Territory__c accTerr : scope) 
        {
            if(accTerr.RSD_Territory_Number__c != null)
            {
                if(mapTerr.containsKey(accTerr.RSD_Territory_Number__c))
                {
                    mapTerr.get('RSD_NA_'+accTerr.RSD_Territory_Number__c).add(accTerr);
                }else{
                    mapTerr.put('RSD_NA_'+accTerr.RSD_Territory_Number__c,new List<RSD_Account_To_Territory__c>{accTerr});
                }
            }
            if(accTerr.RSD_Source_System__c == 'USMF')
            {
                if(mapAcctNumUSMFTerr.containsKey(accTerr.RSD_Account_Number__c))
                {
                    mapAcctNumUSMFTerr.get(accTerr.RSD_Account_Number__c).add(accTerr);
                }else{
                    mapAcctNumUSMFTerr.put(accTerr.RSD_Account_Number__c,new List<RSD_Account_To_Territory__c>{accTerr});
                }
            }else if(accTerr.RSD_Source_System__c == 'CMF')
            {
                if(mapAcctNumCMFTerr.containsKey(accTerr.RSD_Account_Number__c))
                {
                    mapAcctNumCMFTerr.get(accTerr.RSD_Account_Number__c).add(accTerr);
                }else{
                    mapAcctNumCMFTerr.put(accTerr.RSD_Account_Number__c,new List<RSD_Account_To_Territory__c>{accTerr});
                }
            }
        }
        
        Map<String,Account> mapAccount =new Map<String,Account>();
        map<id,set<id>> mapParentAcc = new map<id,set<id>>();
        List<Account> lstAccount=[Select 
                                Id,Name,RSD_CA_Account_Number__c,RSD_US_Account_Number__c,ParentID,Parent.RSD_CA_Account_Number__c,Parent.RSD_US_Account_Number__c
                            FROM 
                                Account 
                            WHERE 
                                (RSD_CA_Account_Number__c IN : mapAcctNumCMFTerr.keySet() 
                            OR RSD_US_Account_Number__c IN : mapAcctNumUSMFTerr.keySet())];
                            
        for(Account acct:lstAccount)
        {
            if(acct.RSD_CA_Account_Number__c != null)
            {
                mapAccount.put(acct.RSD_CA_Account_Number__c,acct);
            }
            
            if(acct.RSD_US_Account_Number__c != null)
            {
                mapAccount.put(acct.RSD_US_Account_Number__c,acct);
            }
            // To the Parent Account with the child Territory
            if(!mapParentAcc.containskey(acct.ParentID)){
                Set<id> setAcc = new Set<id>();
                setAcc.add(acct.id);
                mapParentAcc.put(acct.ParentID,setAcc);         
            }else{
                Set<id> setAccAll = new Set<id>();
                setAccAll.addall(mapParentAcc.get(acct.ParentID));
                setAccAll.add(acct.id);
                mapParentAcc.put(acct.ParentID,setAccAll);
            }
        }
                                                        

        Map<String,Territory2> mapTerritory=new Map<String,Territory2>();
        List<Territory2> lstTerritory=[Select 
                                    Id,Name ,DeveloperName
                                FROM 
                                    Territory2 
                                Where 
                                    DeveloperName IN : mapTerr.keySet()];
        for(Territory2 terr:lstTerritory)
        {
            mapTerritory.put(terr.DeveloperName,terr);
        }

        Map<String,ObjectTerritory2Association> mapAccTerrAssoc=new Map<String,ObjectTerritory2Association>();
        Map<String,ObjectTerritory2Association> mapParntAccTerrAssoc=new Map<String,ObjectTerritory2Association>();
        
        for(ObjectTerritory2Association objTerr2Assoc:[SELECT 
                                                    AssociationCause,Id,IsDeleted,LastModifiedById,LastModifiedDate,ObjectId,SobjectType,SystemModstamp,
                                                    Territory2Id 
                                                FROM 
                                                    ObjectTerritory2Association 
                                                WHERE 
                                                    ObjectId IN : lstAccount 
                                                AND 
                                                    Territory2Id IN : lstTerritory
                                                ])
        {
            mapAccTerrAssoc.put(objTerr2Assoc.ObjectId+'-'+objTerr2Assoc.Territory2Id,objTerr2Assoc);
        }
        
        for(ObjectTerritory2Association objTerr2Assoc:[SELECT 
                                                    AssociationCause,Id,IsDeleted,LastModifiedById,LastModifiedDate,ObjectId,SobjectType,SystemModstamp,
                                                    Territory2Id 
                                                FROM 
                                                    ObjectTerritory2Association 
                                                WHERE 
                                                    ObjectId IN : mapParentAcc.KeySet() 
                                                AND 
                                                    Territory2Id IN : lstTerritory
                                                ])
        {
            mapParntAccTerrAssoc.put(objTerr2Assoc.ObjectId+'-'+objTerr2Assoc.Territory2Id,objTerr2Assoc);
        }
        
                
        Map<String,ObjectTerritory2Association> mapObjTerr2Assoc=new Map<String,ObjectTerritory2Association>();
         Map<String,ObjectTerritory2Association> mapObjTerr2AssocI=new Map<String,ObjectTerritory2Association>();
        Map<Id,String> mapcustomObj=new Map<Id,String>();
        List<RSD_Account_To_Territory__c> lstUpdAccTerr=new List<RSD_Account_To_Territory__c>();
        Set<Id> setDeleteTerrAssoc=new Set<Id>();
        Set<Id> setDeleteTerrAssocD =new Set<Id>();
        
        for (RSD_Account_To_Territory__c accTerr : scope) 
        {
            if(!mapTerritory.containsKey('RSD_NA_'+accTerr.RSD_Territory_Number__c))
            {
                accTerr.RSD_Error_Message__c ='Territory Not Found';
                accTerr.RSD_Invalid__c =false;
                accTerr.RSD_Processed_Date__c = DateTime.now();
                lstUpdAccTerr.add(accTerr);
            }else if(!mapAccount.containsKey(accTerr.RSD_Account_Number__c))
            {
                accTerr.RSD_Error_Message__c ='Account Not Found';
                accTerr.RSD_Invalid__c =false;
                accTerr.RSD_Processed_Date__c = DateTime.now();
                lstUpdAccTerr.add(accTerr);
            }else if(mapAccTerrAssoc.containsKey(mapAccount.get(accTerr.RSD_Account_Number__c).Id+'-'+mapTerritory.get('RSD_NA_'+accTerr.RSD_Territory_Number__c).Id)){
                accTerr.RSD_Invalid__c =false;
                accTerr.RSD_Processed_Date__c = DateTime.now();
                if(accTerr.RSD_Action_Indicator__c =='D')
                {
                    if(accTerr.RSD_Primary_Indicator__c == True ){
                        setDeleteTerrAssocD.add(mapAccTerrAssoc.get(mapAccount.get(accTerr.RSD_Account_Number__c).Id+'-'+mapTerritory.get('RSD_NA_'+accTerr.RSD_Territory_Number__c).Id).Id);
                    }
                    setDeleteTerrAssoc.add(mapAccTerrAssoc.get(mapAccount.get(accTerr.RSD_Account_Number__c).Id+'-'+mapTerritory.get('RSD_NA_'+accTerr.RSD_Territory_Number__c).Id).Id);
                    accTerr.RSD_Error_Message__c =null;
                }else{
                accTerr.RSD_Error_Message__c ='Account already assigned to territory';
                accTerr.RSD_Territory_Id__c = mapAccTerrAssoc.get(mapAccount.get(accTerr.RSD_Account_Number__c).Id+'-'+mapTerritory.get('RSD_NA_'+accTerr.RSD_Territory_Number__c).Id).Id;
                }
                lstUpdAccTerr.add(accTerr);
            }else 
            {
                if(accTerr.RSD_Action_Indicator__c =='D')
                {
                    accTerr.RSD_Error_Message__c ='Account is not assigned to territory';
                    accTerr.RSD_Invalid__c =false;
                    accTerr.RSD_Processed_Date__c = DateTime.now();
                    accTerr.RSD_Territory_Id__c = null;
                    lstUpdAccTerr.add(accTerr);
                }else{
                    ObjectTerritory2Association assoc=new ObjectTerritory2Association();
                    assoc.ObjectId = mapAccount.get(accTerr.RSD_Account_Number__c).Id; 
                    assoc.Territory2Id =mapTerritory.get('RSD_NA_'+accTerr.RSD_Territory_Number__c).Id;
                    //assoc.SobjectType = 'Account';
                    assoc.AssociationCause = 'Territory2Manual';
                    mapObjTerr2Assoc.put(accTerr.RSD_Account_Number__c+accTerr.RSD_Territory_Number__c,assoc);
                    mapcustomObj.put(accTerr.Id,accTerr.RSD_Account_Number__c+accTerr.RSD_Territory_Number__c);
                    if(accTerr.RSD_Primary_Indicator__c == True ){
                        mapObjTerr2AssocI.put(accTerr.RSD_Account_Number__c+accTerr.RSD_Territory_Number__c,assoc);
                    }
                // To create Parent Account and Child account territory association
                
                String str = (accTerr.RSD_Source_System__c == 'USMF' ? mapAccount.get(accTerr.RSD_Account_Number__c).parent.RSD_US_Account_Number__c +accTerr.RSD_Territory_Number__c : mapAccount.get(accTerr.RSD_Account_Number__c).parent.RSD_CA_Account_Number__c+accTerr.RSD_Territory_Number__c);
                    
                    if(mapParentAcc.get(mapAccount.get(accTerr.RSD_Account_Number__c).parentid).contains(mapAccount.get(accTerr.RSD_Account_Number__c).Id) &&
                    !mapObjTerr2Assoc.containskey(str) && !mapParntAccTerrAssoc.containsKey(mapAccount.get(accTerr.RSD_Account_Number__c).ParentId+'-'+mapTerritory.get('RSD_NA_'+accTerr.RSD_Territory_Number__c).Id) && mapAccount.get(accTerr.RSD_Account_Number__c).parentid != Null){
                        ObjectTerritory2Association assocParent=new ObjectTerritory2Association();
                        assocParent.ObjectId = mapAccount.get(accTerr.RSD_Account_Number__c).parentid; 
                        assocParent.Territory2Id =mapTerritory.get('RSD_NA_'+accTerr.RSD_Territory_Number__c).Id;
                        //assoc.SobjectType = 'Account';
                        assocParent.AssociationCause = 'Territory2Manual';
                        if(accTerr.RSD_Source_System__c == 'USMF'){
                            mapObjTerr2Assoc.put(mapAccount.get(accTerr.RSD_Account_Number__c).parent.RSD_US_Account_Number__c +accTerr.RSD_Territory_Number__c,assocParent);
                        }else{
                            mapObjTerr2Assoc.put(mapAccount.get(accTerr.RSD_Account_Number__c).parent.RSD_CA_Account_Number__c +accTerr.RSD_Territory_Number__c,assocParent);
                        }                   
                    }           
                }
            }
        }
        
        if(!lstUpdAccTerr.isEmpty())
        {
            update lstUpdAccTerr;
        }
        
        if(!setDeleteTerrAssocD.isEmpty())
        {
            Map<Id,Set<String>> mapAccountTerrId=new Map<Id,Set<String>>();
            for(ObjectTerritory2Association assoc:[SELECT Id,ObjectId,Territory2.Name FROM ObjectTerritory2Association Where Id IN : setDeleteTerrAssocD])
            {
                if(mapAccountTerrId.containsKey(assoc.ObjectId))
                {
                    mapAccountTerrId.get(assoc.ObjectId).add(assoc.Territory2.Name);
                }else{
                    mapAccountTerrId.put(assoc.ObjectId,new Set<String>{assoc.Territory2.Name});
                }
            }
            if(!mapAccountTerrId.isEmpty())
            {
                List<Account> lstUpdateAcct=new List<Account>();
                for(Account acct:[Select Id, RSD_Territories__c from Account Where Id IN : mapAccountTerrId.keySet()])
                {
                    if(acct.RSD_Territories__c != null)
                    {
                        String territories='';
                        for(String str:acct.RSD_Territories__c.split(','))
                        {
                            if(!mapAccountTerrId.get(acct.Id).contains(str))
                            {
                                territories +=str+',';
                            }
                        }
                        territories = territories.removeEnd(',');
                        Account acc=new Account(Id= acct.Id,RSD_Territories__c =territories);
                        lstUpdateAcct.add(acc);
                    }
                }
                if(!lstUpdateAcct.isEmpty()){
                    update lstUpdateAcct;
                }
            }
        }
        if(!setDeleteTerrAssoc.isEmpty()){
            Delete [Select Id from ObjectTerritory2Association Where Id IN : setDeleteTerrAssoc];
            List<Id> lstDelete=new List<Id>();
            lstDelete.addAll(setDeleteTerrAssoc);
            Database.emptyRecycleBin(lstDelete); 
        }
        
        List<RSD_Account_To_Territory__c> lstAccTerrUpdate=new List<RSD_Account_To_Territory__c>();
        
        if(!mapObjTerr2Assoc.isEmpty())
        {
            insert mapObjTerr2Assoc.values();
            
            for(Id accTerr:mapcustomObj.keySet())
            {
                RSD_Account_To_Territory__c aTerr=new RSD_Account_To_Territory__c(Id= accTerr);
                aTerr.RSD_Error_Message__c ='';
                aTerr.RSD_Invalid__c =false;
                aTerr.RSD_Processed_Date__c = DateTime.now();
                aTerr.RSD_Territory_Id__c =mapObjTerr2Assoc.get(mapcustomObj.get(accTerr)).Id;
                lstAccTerrUpdate.add(aTerr);
        }
        }
        
        if(!mapObjTerr2AssocI.isEmpty()){
            Map<Id,List<String>> mapAcctTerrId=new Map<Id,List<String>>();
            for(ObjectTerritory2Association assoc:[SELECT Id,ObjectId,Territory2.Name FROM ObjectTerritory2Association Where Id IN: mapObjTerr2AssocI.values()])
            {
                if(mapAcctTerrId.containsKey(assoc.ObjectId))
                {
                    mapAcctTerrId.get(assoc.ObjectId).add(assoc.Territory2.Name);
                }else{
                    mapAcctTerrId.put(assoc.ObjectId,new List<String>{assoc.Territory2.Name});
                }
            }
            
            if(!mapAcctTerrId.isEmpty())
            {
                List<Account> lstUpdateAcct=new List<Account>();
                for(Account acct:[Select Id, RSD_Territories__c from Account Where Id IN : mapAcctTerrId.keySet()])
                {
                    Set<String> setTerrNames=new Set<String>();
                    setTerrNames.addAll(mapAcctTerrId.get(acct.Id));                                     
                    if(acct.RSD_Territories__c != null)
                    {
                        for(String str:acct.RSD_Territories__c.split(','))
                        {
                            if(setTerrNames.contains(str))
                            {
                                setTerrNames.remove(str);
                            } 
                        }
                    }
                    List<String> lst=new List<String>();
                    lst.addAll(setTerrNames);
                    Account acc=new Account(Id= acct.Id,RSD_Territories__c =(acct.RSD_Territories__c != null? acct.RSD_Territories__c +',':'') +String.join(lst,','));
                    lstUpdateAcct.add(acc);
                }
                update lstUpdateAcct;
            }
        }
        
        if(!lstAccTerrUpdate.isEmpty())
        {
            update lstAccTerrUpdate;
        }
    }

    global void finish(Database.BatchableContext BC)
    {
    RSDNA_ParentAccTerritoryBatch b=new RSDNA_ParentAccTerritoryBatch();
    Id batchId = Database.executeBatch(b,200);
    }
}