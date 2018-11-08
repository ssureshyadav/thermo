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


global class RSDNA_InsertTerritory2BatchExt2 implements Database.Batchable<sObject>, Database.Stateful{

    List<SObject> lstObject=new List<Sobject>();

    global RSDNA_InsertTerritory2BatchExt2(List<Sobject> lstRecords){
        this.lstObject =lstRecords;

    }
    
    public List<Sobject> Start(Database.BatchableContext BC){
        return lstObject;
    }
    
    global void execute(Database.BatchableContext BC, List<Sobject> scope){
        system.debug('scope--->'+scope);
        //DataBase.Update(scope,false);
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){
     
    }
 
 }