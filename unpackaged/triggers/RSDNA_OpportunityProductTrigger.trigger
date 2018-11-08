trigger RSDNA_OpportunityProductTrigger on OpportunityLineItem(after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
   
    if (!RSD_TriggerSettings.getIsTriggerEnabled('RSDNA_OpportunityProductTrigger')) {
        return;
    }

    new RSDNA_OppoProdTriggerHandler().run();
}