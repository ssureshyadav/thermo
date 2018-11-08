/*
    Created By  : Venkatesh Kumar
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 16 June,2017
    Description : 
    Test Class for: RSDNA_InsertTerritory2BatchSchedule
*/
@isTest
private class RSDNA_SchedulerTestClasses{
    public static testMethod void testschedule() {
        Test.StartTest();
        RSDNA_AccountTerritoryPurgeScheduler sh1 = new RSDNA_AccountTerritoryPurgeScheduler ();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test01', sch, sh1); 
        Test.stopTest();                
        }
        
        public static testMethod void testschedule01() {
        Test.StartTest();
        RSDNA_AccountUserTrrBatchSchedule sh1 = new RSDNA_AccountUserTrrBatchSchedule ();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test01', sch, sh1); 
        Test.stopTest();                
        }
        
        public static testMethod void testschedule02() {
        Test.StartTest();
        RSDNA_OrgTerritoryPurgeBatchScheduler sh1 = new RSDNA_OrgTerritoryPurgeBatchScheduler ();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test01', sch, sh1); 
        Test.stopTest();                
        }
        
        public static testMethod void testschedule03() {
        Test.StartTest();
        RSDNA_UserTerritoryPurgeScheduler sh1 = new RSDNA_UserTerritoryPurgeScheduler ();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test01', sch, sh1); 
        Test.stopTest();                
        }
        
    }