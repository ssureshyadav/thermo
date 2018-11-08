public class RSDNA_QuoteHeaderTriggerHandler extends RSD_TriggerHandler{
    
    private Map<Id, RSD_Quote_Header__c> quoteHeaderOldMap;
    
    public RSDNA_QuoteHeaderTriggerHandler(){
    this.quoteHeaderOldMap = (Map<Id, RSD_Quote_Header__c>) Trigger.oldMap;      
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
    public override void afterUpdate()
    {    
        new RSDNA_UpdateQuoteCountonOppty().updQuoteCount(Trigger.new,(Map<Id,RSD_Quote_Header__c>)Trigger.OldMap);
    }
     
    public override void afterDelete()
    {    
        new RSDNA_UpdateQuoteCountonOppty().updQuoteCount(null,(Map<Id,RSD_Quote_Header__c>)Trigger.OldMap);
    }

}