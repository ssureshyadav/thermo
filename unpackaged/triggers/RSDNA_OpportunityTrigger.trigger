trigger RSDNA_OpportunityTrigger on Opportunity (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    if (!RSD_TriggerSettings.getIsTriggerEnabled('RSDNA_OpportunityTrigger')) {
        return;
    }
        
    new RSDNA_OpportunityTriggerHandler().run();
}