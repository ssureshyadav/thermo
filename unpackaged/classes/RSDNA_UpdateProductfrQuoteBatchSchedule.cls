/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 27 April,2017
    Requirement : W-000070 : RSDNA-0036: Order Number added to Opportunity Line Items
    Description : 
                -- Helps the schedule the batch job of RSDNA_UpdateProductfrQuoteBatch
    Test Class  : RSDNA_UpdateProductfrQuoteBatchTest
    Last Updated By :Venkatesh
    
*/

global class RSDNA_UpdateProductfrQuoteBatchSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
      RSDNA_UpdateProductfrQuoteBatch updateOrderNo = new RSDNA_UpdateProductfrQuoteBatch(); 
      database.executebatch(updateOrderNo);
   }
}