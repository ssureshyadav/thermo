/*
    @Author             : Venkatesh Kumar (NTT Data)
    @Date Created       : 02-June-2017
    @Description        : W-000141 :T-00348 : Schedulable class used to schedule RSDNA_OrgTerritoryPurgeBatch class 
*/

global class RSDNA_OrgTerritoryPurgeBatchScheduler implements schedulable{
    global void execute(schedulablecontext sc){
        database.executebatch(new RSDNA_OrgTerritoryPurgeBatch());    
    }
}