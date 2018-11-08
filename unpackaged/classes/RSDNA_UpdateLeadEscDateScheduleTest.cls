/*
    Created By  : Ajay Kumar
    Email ID    : pendelavenkatabaji.ajaykumar@nttdata.com    
    Company     : NTTDATA
    Date        : 20 June,2017
    Requirement : W-000183:T-00370: Dev 
    Test Class for : RSDNA_UpdateLeadEscalationDateSchedule
    Last Updated By : 
    
*/
@isTest
private class RSDNA_UpdateLeadEscDateScheduleTest{
    public static testMethod void testschedule() {
        Test.StartTest();
        RSDNA_UpdateLeadEscalationDateSchedule insEscdate = new RSDNA_UpdateLeadEscalationDateSchedule();
        String sch = '0 0 1 * * ?'; 
        system.schedule('Test Escalation Date Insertion', sch, insEscdate); 
        Test.stopTest();                
        }
    }