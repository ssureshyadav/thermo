/*
    @Author             : Venkatesh Kumar (NTT Data)
    @Date Created       : 02-June-2017
    @Description        : W-000141 :T-00348 : Used to delete all the records from the Org Territory staging table prior to days given in the Custom Setting RSD_Territory_Settings__c 
    @TestClass          : RSDNA_TerritoryPurgeBatchTest
*/

global class RSDNA_OrgTerritoryPurgeBatch implements Database.Batchable<sObject> {
    RSD_Territory_Settings__c sc= RSD_Territory_Settings__c.getOrgDefaults();
    
    global Database.QueryLocator start(Database.BatchableContext BC){

        String Query = 'SELECT Id, Name, CreatedDate FROM RSD_Org_To_Territory__c';
         if(!Test.isRunningTest()){
        Query += ' WHERE CreatedDate < LAST_N_DAYS:';
        Query += Integer.valueof(sc.RSD_NA_Purge_Frequency__c);
        }
        Query += ' ORDER BY CreatedDate DESC';
        return Database.getQueryLocator(Query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        system.debug('scope------------------------------------------>'+scope);       
       if(!scope.isEmpty()){
               delete scope;
             }
        }
    global void finish(Database.BatchableContext BC){
    }
}