trigger RSDNA_UserTerritoryrTrigger on UserTerritory2Association(after delete, after insert, after undelete, 
after update, before delete, before insert, before update){

    if (!RSD_TriggerSettings.getIsTriggerEnabled('RSDNA_UserTerritoryrTrigger')) {
        return;
    }
    
    new RSDNA_UserTerritoryrTriggerHandler().run();
}