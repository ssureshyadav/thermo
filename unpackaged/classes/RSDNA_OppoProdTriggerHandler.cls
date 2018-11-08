public class RSDNA_OppoProdTriggerHandler extends RSD_TriggerHandler{
    
    private Map<Id, OpportunityLineItem> oppProductOldMap;
    
    public RSDNA_OppoProdTriggerHandler (){
    this.oppProductOldMap = (Map<Id, OpportunityLineItem>) Trigger.oldMap;      
    }   
    
    
    
    /*private Map<Id, Opportunity> optyNewMap;
    private Map<Id, Opportunity> optyOldMap;
    private List<Opportunity> optyLst;
    
    public RSDNA_OpportunityTriggerHandler_CLS(){
        this.optyNewMap = (Map<Id, Opportunity>) Trigger.newMap;
        this.optyOldMap = (Map<Id, Opportunity>) Trigger.oldMap;
        this.optyLst = (List<Opportunity>) Trigger.new;
        
    }
*/    
    public override void beforeInsert(){
        //W-000077:T-00289: RSDNA-0043: Opportunity Gross Margin based on Opportunity Products
        RSDNA_OppLineItemStatusChange OppLineItemStatChngBeforeInsert = new RSDNA_OppLineItemStatusChange();
        OppLineItemStatChngBeforeInsert.onStatusChange(Trigger.New,oppProductOldMap);
        
    }
    
    public override void afterInsert(){
    
        //W-000063 : RSDNA-0029: Select Opportunity Line Items as Active
        RSDNA_UpdateGrossAmount oppGrossAmountAfterInsert = new RSDNA_UpdateGrossAmount();
        oppGrossAmountAfterInsert.OppGrossAmountUpdate(Trigger.New,oppProductOldMap);
    }
    
    public override void beforeUpdate(){
        //W-000077:T-00289: RSDNA-0043: Opportunity Gross Margin based on Opportunity Products
        RSDNA_OppLineItemStatusChange OppLineItemStatChngAfterInsert = new RSDNA_OppLineItemStatusChange();
        OppLineItemStatChngAfterInsert.onStatusChange(Trigger.New,oppProductOldMap);
        
    }
    
    public override void afterUpdate(){   
    system.debug('The value of TriggeroldMap------------------>'+Trigger.oldMap); 
       
       //W-000063 : RSDNA-0029: Select Opportunity Line Items as Active
        RSDNA_UpdateGrossAmount oppGrossAmountAfterUpdate = new RSDNA_UpdateGrossAmount();
        oppGrossAmountAfterUpdate.OppGrossAmountUpdate(Trigger.New,oppProductOldMap);
    }
    
    
    public override void afterDelete(){   
    system.debug('The value of TriggeroldMap------------------>'+Trigger.oldMap); 
       
       //W-000063 : RSDNA-0029: Select Opportunity Line Items as Active
        RSDNA_UpdateGrossAmount oppGrossAmountAfterDel = new RSDNA_UpdateGrossAmount();
        oppGrossAmountAfterDel.OppGrossAmountUpdate(Trigger.old,oppProductOldMap);
    }
    

}