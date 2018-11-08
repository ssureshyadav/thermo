/*
    Created By  : Ajay Kumar
    Email ID    : pendelavenkatabaji.ajaykumar@nttdata.com    
    Company     : NTTDATA
    Date        : 20 June,2017
    Requirement : W-000183:T-00370: Dev 
    Test Class  : RSDNA_UpdateLeadEscDateScheduleTest
    Last Updated By : 
    
*/
global class RSDNA_UpdateLeadEscalationDateSchedule implements Schedulable {
   global void execute(SchedulableContext sc) {
       
      database.executebatch(new RSDNA_UpdateLeadEscalationDate1());
      
   }
}