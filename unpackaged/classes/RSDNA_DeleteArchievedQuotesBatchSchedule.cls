/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 27 April,2017
    Requirement : W-000079 : RSDNA-0046: Delete Quotes marked as 'PURGED' from mainframe
    Description : 
                -- Helps the schedule the batch job of RSDNA_DeleteArchievedQuotesBatch
    Test Class  : 
    Last Updated By :Venkatesh
    
*/

global class RSDNA_DeleteArchievedQuotesBatchSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      RSDNA_DeleteArchievedQuotesBatch deleteQuoteBatch = new RSDNA_DeleteArchievedQuotesBatch(); 
      database.executebatch(deleteQuoteBatch);
   }
}