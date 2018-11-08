/*
    Created By  : Venkatesh Kumar
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 27 May,2017
    Description : 
    Test Class for: RSDNA_InsertTerritory2BatchSchedule
*/
@isTest
private class RSDNA_InsertTerritory2BatchScheduleTest{
    public static testMethod void testschedule() {
        Test.StartTest();
        RSDNA_InsertTerritory2BatchSchedule sh1 = new RSDNA_InsertTerritory2BatchSchedule ();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();                
        }
    }