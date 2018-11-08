/*
    @Author             : Venkatesh Kumar (NTT Data)
    @Date Created       : 06-June-2017
    @Description        : W-000142 :T-00348 : Schedulable class used to schedule RSDNA_UserTerritoryPurgeBatch class 
*/

global class RSDNA_UserTerritoryPurgeScheduler implements schedulable{
    global void execute(schedulablecontext sc){
        database.executebatch(new RSDNA_UserTerritoryPurgeBatch());    
    }
}