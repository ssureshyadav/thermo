/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 24 May,2017
    Requirement :   Scheduler class for RSDNA_InsertTerritory2Batch
    Description : 
                -- Helps the schedule the batch job of RSDNA_InsertTerritory2Batch
    Test Class  : 
    Last Updated By :Venkatesh
    
*/

global class RSDNA_InsertTerritory2BatchSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      database.executebatch(new RSDNA_InsertTerritory2Batch ());
   }
}