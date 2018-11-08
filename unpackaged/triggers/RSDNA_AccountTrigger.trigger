trigger RSDNA_AccountTrigger on Account(after delete, after insert, after undelete, 
after update, before delete, before insert, before update){

    if (!RSD_TriggerSettings.getIsTriggerEnabled('RSDNA_AccountTrigger')) {
        return;
    }

    new RSDNA_AccountTriggerHandler().run();
}