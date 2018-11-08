/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 24 May,2017
    Requirement :   Scheduler class for RSDNA_UserTerritory2Batch and  RSDNA_AccountTerritory2Batch
    Description : 
                --Scheduler class for RSDNA_UserTerritory2Batch and  RSDNA_AccountTerritory2Batch
    Test Class  : 
    Last Updated By :Venkatesh
    
*/

global class RSDNA_AccountUserTrrBatchSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      //database.executebatch(new RSDNA_UserTerritory2Batch ());
      database.executebatch(new RSDNA_AccountTerritoryBatch());
   }
}