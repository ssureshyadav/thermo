trigger RSDNA_AccountContactRelationTrigger on AccountContactRelation (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {

    if (!RSD_TriggerSettings.getIsTriggerEnabled('RSDNA_AccountContactRelationTrigger')) {
        return;
    }
    
    new RSDNA_AcctConRelationTriggerHandler().run();
}