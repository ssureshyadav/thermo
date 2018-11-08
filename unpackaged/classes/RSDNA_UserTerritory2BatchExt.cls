/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 22 May,2017
    Requirement : W-000091:T-00122: Dev 
                    This is an extension class to RSDNAUserTerritory2Batch
    Test Class  : 
    Last Updated By : Venkatesh Kumar Sakthivel
    
*/


global class RSDNA_UserTerritory2BatchExt implements Database.Batchable<sObject>, Database.Stateful{
    List<SObject> lstObject=new List<Sobject>();
    id getBatchID;
    global RSDNA_UserTerritory2BatchExt(List<Sobject> lstRecords,id batchID){
        this.lstObject =lstRecords;
        this.getBatchID = batchID;
    }
    
    public List<Sobject> Start(Database.BatchableContext BC){
        return lstObject;
    }
    
    global void execute(Database.BatchableContext BC, List<Sobject> scope){
        DataBase.Update(scope,false);
    }
    
    global void finish(Database.BatchableContext BC){
        
    if(getBatchID != Null){
    List<RSD_User_To_Territory__c> lstusrTrr = [Select Name,RSD_Action_Indicator__c,OwnerID,RSD_Error_Message__c,RSD_Extraction_Date__c,RSD_Invalid__c,RSD_Primary_External_Id__c,RSD_Processed_Date__c,RSD_Role__c,RSD_Source_System__c,RSD_Territory_Id__c,RSD_Territory_Number__c,RSD_Workday_Number__c from RSD_User_To_Territory__c where  RSD_Processed_Date__c = Null and RSD_Invalid__c = False order by RSD_Extraction_Date__c ASC,RSD_Action_Indicator__c ASC];
     
    List<AsyncApexJob> batchResult = [SELECT Id, Status,NumberOfErrors,JobItemsProcessed,TotalJobItems,ExtendedStatus FROM AsyncApexJob where Id = :getBatchID and ExtendedStatus = Null];
    
    System.debug('The value of--->'+batchResult);
    System.debug('The value of lstusrTrr--->'+lstusrTrr);
    
        if(!lstusrTrr.isEmpty() && !batchResult.isEmpty() ){
            system.debug('<--The Batch Is called-->');
                RSDNA_UserTerritory2Batch  b=new RSDNA_UserTerritory2Batch();
                Id batchId = Database.executeBatch(b,1);        
        }    
    }
    }
 
 }