public class RSDNA_QuoteLineItemTriggerHandler extends RSD_TriggerHandler{
    
    private Map<Id, RSD_Quote_Line_Item__c> quoteLineItemOldMap;
    
    public RSDNA_QuoteLineItemTriggerHandler(){
    this.quoteLineItemOldMap= (Map<Id, RSD_Quote_Line_Item__c>) Trigger.oldMap;      
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

    public override void beforeInsert (){ 
    RSDNA_VendordtlsfetchQuoteLI vendordetailsBInsert = new RSDNA_VendordtlsfetchQuoteLI();
    vendordetailsBInsert.updatevendorinfo(trigger.new,quoteLineItemOldMap);
    } 

    public override void beforeUpdate(){ 
    RSDNA_VendordtlsfetchQuoteLI vendordetailsBUpdate = new RSDNA_VendordtlsfetchQuoteLI();
    vendordetailsBUpdate.updatevendorinfo(trigger.new,quoteLineItemOldMap);
    }
    
    public override void afterInsert (){ 
        new RSDNA_QuoteLineItemService().afterInsert((List<RSD_Quote_Line_Item__c>)Trigger.new);
    } 

    public override void afterUpdate(){ 
        new RSDNA_QuoteLineItemService().afterUpdate((List<RSD_Quote_Line_Item__c>)Trigger.new,(Map<Id,RSD_Quote_Line_Item__c>)Trigger.oldMap);
    }
    
    

}