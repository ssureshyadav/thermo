/*
    Created By  : Ajay Kumar
    Email ID    : pendelavenkatabaji.ajaykumar@nttdata.com    
    Company     : NTTDATA
    Date        : 27 June,2017
    Requirement : W-000193:T-00386: Dev 
                  Create an apex batch job to validate Quote Line Item 'Vendor Number' field and update Quote Line Item and OpportunityProduct records.
                  Conditions: 
                    -Created the Last N Days
                    -RSD_Quote_Line_Item__c.Vendor__c IS NULL 
                    -RSD_Quote_Line_Item__c.RSD_Vendor_Number__c IS NOT NULL
    Schedule Class for : RSDNA_UpdateVenNumOnQuoteLIOppProdBatch 
    Last Updated By : 
    
*/
global class RSDNA_UpdtVenNumOnQLIOppPrdBatchSchedule implements Schedulable {
  
     global void execute(SchedulableContext sc) {
       
      database.executebatch(new RSDNA_UpdateVenNumOnQuoteLIOppProdBatch());
      
   }


}