/*
    Created By  : Venkatesh
    Email ID    : 
    Company     : NTTDATA
    Date        : 11 July,2017
    Requirement : To delete the parent account territory association
    Test Class  :
    Last Updated By : 
    
*/

global class RSDNA_ParentAccTerritoryBatch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT 
                                            Id,Name,RSD_Account_Number__c,RSD_Action_Indicator__c,RSD_Error_Message__c,RSD_Extraction_Date__c,RSD_Invalid__c,
                                            RSD_Primary_External_Id__c,RSD_Primary_Indicator__c ,RSD_Processed_Date__c,RSD_Source_System__c,RSD_Territory_Id__c,RSD_Territory_Number__c,RSD_Parent_Account_Processed_Date__c FROM RSD_Account_To_Territory__c WHERE  RSD_Parent_Account_Processed_Date__c = NULL  AND
                                            RSD_Invalid__c =false and  RSD_Action_Indicator__c = 'D'   ORDER BY   RSD_Extraction_Date__c ASC]);
    }

    global void execute(Database.BatchableContext BC, List<RSD_Account_To_Territory__c> scope) {
        map<id,set<id>> mapParentAcc = new map<id,set<id>>();
        map<string,set<string>> mapAccLstTrr = new map<string,set<string>> ();
        Set<String> setTerr=new Set<String>();
        map<id,set<id>> mapPAccountChldAccountAll= new map<id,set<id>>();
        set<string> setUSMFAccNumber = new set<string>();
        set<string> setCMFAccNumber = new set<string>();
        set<ID> setParentID = new set<ID>();
        set<ID> SetTrrID = new set<ID>();
        set<ID> SetaccTrrID = new set<ID>();
        
        for(RSD_Account_To_Territory__c accTrr: scope){
            SetTrrID.add(accTrr.ID);
            if(accTrr.RSD_Source_System__c == 'USMF'){
                setUSMFAccNumber.add(accTrr.RSD_Account_Number__c);
            }else if(accTrr.RSD_Source_System__c == 'CMF'){
                setCMFAccNumber.add(accTrr.RSD_Account_Number__c);
            }
            
            if(accTrr.RSD_Territory_Number__c != null){
                    setTerr.add('RSD_NA_'+accTrr.RSD_Territory_Number__c);
            }

            if(mapAccLstTrr.containskey(accTrr.RSD_Account_Number__c)){
                mapAccLstTrr.get(accTrr.RSD_Account_Number__c).add('RSD_NA_'+accTrr.RSD_Territory_Number__c);             
            }else{
                mapAccLstTrr.put(accTrr.RSD_Account_Number__c, new set<String> {'RSD_NA_'+accTrr.RSD_Territory_Number__c});
            }
            
        }
        
        List<RSD_Account_To_Territory__c> lstUpdateTrrAccStg = new List<RSD_Account_To_Territory__c>();
        
        for(id accTrrID:SetTrrID){
            RSD_Account_To_Territory__c accTrr = new RSD_Account_To_Territory__c(id=accTrrID,RSD_Parent_Account_Processed_Date__c = system.today());
            lstUpdateTrrAccStg.add(accTrr);
        }
        
        map<id,set<id>> mapPAccountChldAccountUSMF = new map<id,set<id>>();
        map<id,set<id>> mapPAccountChldAccountCMF = new map<id,set<id>>();
        map<id,set<String>> mapParentAccTrr = new map<id,set<String>>();
        set<ID> setParentAccID = new set<ID>();
        
        for(Account acc: [select ID,ParentID,RSD_US_Account_Number__c from Account where RSD_US_Account_Number__c IN: setUSMFAccNumber]){           
            if(mapPAccountChldAccountUSMF.containskey(acc.ParentID)){
                mapPAccountChldAccountUSMF.get(acc.ParentID).add(acc.id);   
            }else{
                mapPAccountChldAccountUSMF.put(acc.ParentID, new set<id> {acc.id});
            }
            if(mapAccLstTrr.containskey(acc.RSD_US_Account_Number__c)){
                mapParentAccTrr.put(acc.ParentID, mapAccLstTrr.get(acc.RSD_US_Account_Number__c));
            }
            setParentAccID.add(acc.ParentID);           
        }
        
        for(Account acc: [select ID,ParentID,RSD_CA_Account_Number__c from Account where RSD_CA_Account_Number__c IN: setCMFAccNumber]){            
            if(mapPAccountChldAccountCMF.containskey(acc.ParentID)){
                mapPAccountChldAccountCMF.get(acc.ParentID).add(acc.id);    
            }else{
                mapPAccountChldAccountCMF.put(acc.ParentID, new set<id> {acc.id});
            }
            
            if(mapAccLstTrr.containskey(acc.RSD_CA_Account_Number__c)){
                mapParentAccTrr.put(acc.ParentID, mapAccLstTrr.get(acc.RSD_CA_Account_Number__c));
            }           
            setParentAccID.add(acc.ParentID);                       
        }
        
         for(Territory2 terr:[select Id,Name ,DeveloperName from territory2 where developerName IN : setTerr]){
            SetTrrID.add(terr.Id);
        }
 
        map<id,set<id>> mapPAccountChldAccountMapping = new map<id,set<id>>();
        set<id> setParentFinalID = new set<id>();
        set<id> setAllChild = new set<id>();
        map<ID,String> mapAccIdName = new map<ID,String>();
        
        for(Account acc: [select Name,ID,ParentID,RSD_US_Account_Number__c,RSD_CA_Account_Number__c,RSD_MF_Account_Source__c from Account where ParentID IN: setParentAccID ]){
            if(mapPAccountChldAccountAll.containskey(acc.ParentID)){
                   mapPAccountChldAccountAll.get(acc.ParentID).add(acc.id);                            
            }else{
                    mapPAccountChldAccountAll.put(acc.ParentID,new set<id> {acc.id});
            }
            setAllChild.add(acc.ID);
            if(acc.RSD_MF_Account_Source__c == 'USMF'){
                mapAccIdName.put(acc.ID,acc.RSD_US_Account_Number__c);
            }else if(acc.RSD_MF_Account_Source__c == 'CMF'){
                mapAccIdName.put(acc.ID,acc.RSD_CA_Account_Number__c);
            }
        }

        map<id,set<id>> mapObjTrr = new map<id,set<id>>();
        map<string,set<string>> mapObjTrrName = new map<string,set<string>>();
        
        if(!SetTrrID.isEmpty() && !setAllChild.isEmpty()){
           for(ObjectTerritory2Association objAss:[ SELECT AssociationCause,Id,Object.Name,Territory2.DeveloperName,IsDeleted,LastModifiedById,LastModifiedDate,ObjectId,SobjectType,SystemModstamp,Territory2Id FROM ObjectTerritory2Association WHERE ObjectId IN : setAllChild AND Territory2Id IN : SetTrrID ]){
                         if(mapObjTrr.containskey(objAss.ObjectId)){
                            mapObjTrr.get(objAss.ObjectId).add(objAss.Territory2Id);
                            mapObjTrrName.get(mapAccIdName.get(objAss.ObjectId)).add(objAss.Territory2.DeveloperName);                          
                        }else{
                            mapObjTrr.put(objAss.ObjectId,new set<id> {objAss.Territory2Id});
                            mapObjTrrName.put(mapAccIdName.get(objAss.ObjectId),new set<string> {objAss.Territory2.DeveloperName});                         
                        }         
            }
        }

            set<ID> setParentIDdelete = new set<ID>();
          for(id ParentID:mapPAccountChldAccountAll.keyset() ){
              boolean checkBol = False;
            for(id chldAccID : mapPAccountChldAccountAll.get(ParentID)){    
                if(!mapPAccountChldAccountUSMF.isEmpty() && mapPAccountChldAccountUSMF.get(ParentID) != Null){
                    if(!mapPAccountChldAccountUSMF.get(ParentID).contains(chldAccID) && mapParentAccTrr.get(ParentID) != Null){
                        for(string trrCheck: mapParentAccTrr.get(ParentID)){
                            if(mapObjTrrName.get(mapAccIdName.get(chldAccID)) != Null){             
                                if(mapObjTrrName.get(mapAccIdName.get(chldAccID)).contains(trrCheck) && checkBol == False){
                                    checkBol = True;
                                }
                            }
                        }
                    }
                }else if(!mapPAccountChldAccountCMF.isEmpty() && mapPAccountChldAccountCMF.get(ParentID) != Null){
                            if(!mapPAccountChldAccountCMF.get(ParentID).contains(chldAccID) && mapParentAccTrr.get(ParentID) != Null){
                                for(string trrCheck: mapParentAccTrr.get(ParentID)){
                                    if(mapObjTrrName.get(mapAccIdName.get(chldAccID)) != Null){ 
                                        if(mapObjTrrName.get(mapAccIdName.get(chldAccID)).contains(trrCheck) && checkBol == False){
                                            checkBol = True;
                                        }
                                    }                                   
                                }   
                            }
                    }
            }

            if(!checkBol ){
            setParentIDdelete.add(ParentID);
            }
          }
  
        if(!SetTrrID.isEmpty() && !setParentIDdelete.isEmpty()){
            Delete [SELECT AssociationCause,Id,IsDeleted,LastModifiedById,LastModifiedDate,ObjectId,SobjectType,SystemModstamp,Territory2Id FROM ObjectTerritory2Association WHERE ObjectId IN : setParentIDdelete AND Territory2Id IN : SetTrrID ];
        }
        
        if(!lstUpdateTrrAccStg.isEmpty()){
            update lstUpdateTrrAccStg;
        }

    }
    
        
    global void finish(Database.BatchableContext BC)  {
        
    }
}