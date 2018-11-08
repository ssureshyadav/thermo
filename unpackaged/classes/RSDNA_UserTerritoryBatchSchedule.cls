/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 17 July,2017
    Requirement :   Scheduler class for RSDNA_UserTerritory2Batch 
    Description : 
                --Scheduler class for RSDNA_UserTerritory2Batch 
    Test Class  : 
    Last Updated By :Venkatesh
    
*/

global class RSDNA_UserTerritoryBatchSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      database.executebatch(new RSDNA_UserTerritory2Batch (),1);      
   }
}