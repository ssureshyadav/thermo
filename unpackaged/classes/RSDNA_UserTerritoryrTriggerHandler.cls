public class RSDNA_UserTerritoryrTriggerHandler extends RSD_TriggerHandler{
    
    private Map<Id, UserTerritory2Association> mapUserTrr;
    List<UserTerritory2Association> lstUserTrr ;
    private List<Id> lstTrrID = new List<Id>();
    
    public RSDNA_UserTerritoryrTriggerHandler(){
    this.mapUserTrr = (Map<Id, UserTerritory2Association>) Trigger.oldMap;
    this.lstUserTrr = (List<UserTerritory2Association>) Trigger.New;
    
    if(Trigger.new != Null){
    for(UserTerritory2Association usrTrr : (List<UserTerritory2Association>)Trigger.new){        
    lstTrrID.add(usrTrr.Territory2Id);
    }     
    }   
    }
    
    public override void afterInsert(){             
    }
    
    public override void afterUpdate(){  
            
    }
    
    public override void afterDelete(){ 
    RSDNA_ClearTrrAssignedUser clrTrr = new RSDNA_ClearTrrAssignedUser();
    clrTrr.clearAssignedUserTrr(mapUserTrr);        
    }
    
    

}