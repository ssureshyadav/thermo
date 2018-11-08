trigger RSDNA_QuoteHeaderTrigger on RSD_Quote_Header__c(after delete, after insert, after undelete, 
after update, before delete, before insert, before update){

    if (!RSD_TriggerSettings.getIsTriggerEnabled('RSDNA_QuoteHeaderTrigger')) {
        return;
    }
    
    new RSDNA_QuoteHeaderTriggerHandler().run();
}