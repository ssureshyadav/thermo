trigger RSDNA_QuoteLineItemTrigger on RSD_Quote_Line_Item__c (after delete, after insert, after undelete, 
after update, before delete, before insert, before update){

    if (!RSD_TriggerSettings.getIsTriggerEnabled('RSDNA_QuoteLineItemTrigger')) {
        return;
    }
 
    new RSDNA_QuoteLineItemTriggerHandler().run();
}