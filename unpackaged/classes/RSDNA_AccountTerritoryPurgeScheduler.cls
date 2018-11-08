/*
    @Author             : Venkatesh Kumar (NTT Data)
    @Date Created       : 02-June-2017
    @Description        : W-000142 :T-00348 : Schedulable class used to schedule RSDNA_AccountTerritoryPurgeBatch class 
*/

global class RSDNA_AccountTerritoryPurgeScheduler implements schedulable{
    global void execute(schedulablecontext sc){
        database.executebatch(new RSDNA_AccountTerritoryPurgeBatch());    
    }
}