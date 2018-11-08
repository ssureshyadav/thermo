public class RSDNA_AcctConRelationTriggerHandler extends RSD_TriggerHandler{
    
 
    public override void beforeUpdate(){   
        
       RSDNA_ActConRelVerifyPrimaryContact verifyAccount = new RSDNA_ActConRelVerifyPrimaryContact();
       verifyAccount.verifyPrimaryContact(Trigger.New,(Map<Id,AccountContactRelation>)Trigger.oldMap);
       
   }
   
}