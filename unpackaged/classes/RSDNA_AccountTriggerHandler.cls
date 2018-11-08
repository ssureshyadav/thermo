public class RSDNA_AccountTriggerHandler extends RSD_TriggerHandler{

private Map<Id, Account> accNewMap;
private Map<Id, Account> accOldMap;
private List<Account> accLst;

    public RSDNA_AccountTriggerHandler () {
    this.accNewMap = (Map<Id, Account>) Trigger.newMap;
    this.accOldMap = (Map<Id, Account>) Trigger.oldMap;
    this.accLst = (List<Account>) Trigger.new;
  }

    
public override void afterInsert(){   
    //RSDNA_IngtAdminUpdateAcc ingtUpdateAcc = new RSDNA_IngtAdminUpdateAcc();
    //ingtUpdateAcc.updateAcc(Trigger.new);
       
}
    
public override void beforeUpdate(){
   RSDNA_AccOwnerUpdOnInactive accInactive = new RSDNA_AccOwnerUpdOnInactive();
   accInactive.updateAccount(Trigger.new,accOldMap,accNewMap);
   
   //W-000087:T-00094:Data Integration - Vendor Accounts
   RSDNA_checkAccountSource chkSource = new RSDNA_checkAccountSource();
   chkSource.processingupdate(Trigger.new,accOldMap);
    
}

public override void afterUpdate(){
    RSDNA_AccInactiveConAssociation accConAssociation = new RSDNA_AccInactiveConAssociation();
     accConAssociation.associateContact(Trigger.new,accOldMap,accNewMap);
     
     
    //RSDNA_IngtAdminUpdateAcc ingtUpdateAcc = new RSDNA_IngtAdminUpdateAcc();
    //ingtUpdateAcc.updateAcc(Trigger.new);
       
}

}