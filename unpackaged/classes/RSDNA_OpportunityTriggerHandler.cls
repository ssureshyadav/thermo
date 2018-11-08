public class RSDNA_OpportunityTriggerHandler extends RSD_TriggerHandler{
    
    /*private Map<Id, Opportunity> optyNewMap;
    private Map<Id, Opportunity> optyOldMap;
    private List<Opportunity> optyLst;
    
    public RSDNA_OpportunityTriggerHandler_CLS(){
        this.optyNewMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.optyOldMap = (Map<Id, Opportunity>) Trigger.oldMap;
        this.optyLst = (List<Opportunity>) Trigger.new;
        
    }
*/    
    public override void beforeUpdate(){        
       //RSDNA_OpportunityTriggerHelper.updOppAmount(Trigger.New,(Map<Id,Opportunity>)Trigger.oldMap);
       
       //RSDNA_OptyUpdateStageName optyUpdate = new RSDNA_OptyUpdateStageName ();
       RSDNA_OptyUpdateStageName optyUpdate = new RSDNA_OptyUpdateStageName();
       optyUpdate.OptyStageNameUpdate(Trigger.New,(Map<Id,Opportunity>)Trigger.oldMap);
       
       RSDNA_updateActualGrossMargin grossMarginInsert = new RSDNA_updateActualGrossMargin();
       grossMarginInsert.grossMarginUpdate(Trigger.New,(Map<Id,Opportunity>)Trigger.oldMap);
   }
   
    public override void beforeInsert(){        
       //RSDNA_OpportunityTriggerHelper.updOppAmount(Trigger.New,(Map<Id,Opportunity>)Trigger.oldMap);
       RSDNA_updateActualGrossMargin grossMarginUppadetrigger = new RSDNA_updateActualGrossMargin();
       grossMarginUppadetrigger.grossMarginUpdate(Trigger.New,(Map<Id,Opportunity>)Trigger.oldMap);
   }
}