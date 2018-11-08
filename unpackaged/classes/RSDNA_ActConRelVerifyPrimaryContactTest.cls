/*
    Created By  : Ajay Kumar Pendela
    Email ID    : Pendelavenkatabaji.Ajaykumar@nttdata.com
    Company     : NTTDATA
    Date        : 22 June,2017
    Description : Testing the apex class written for W-000189 : T-00378
    Test Class for: RSDNA_ActConRelVerifyPrimaryContact
*/

@isTest
private class RSDNA_ActConRelVerifyPrimaryContactTest {
    
    @isTest
    private static void verifyContact(){
               
        RSD_TriggerSettings.getIsTriggerEnabled('RSDNA_AccountContactRelationTrigger');
         RSDNA_DataFactory data=new RSDNA_DataFactory(); 
         data.orgSpecificSetting();
         data.orgRecordTypes();
         List<Account> acc=data.insertAccount(2, Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
        //System.debug('--->Account->'+acc); 
        List<Contact> con= data.insertContact(1, Schema.SObjectType.Contact.getRecordTypeInfosByName().get('RSD NA Contact').getRecordTypeId(), acc[0].Id);
        //System.debug('--->Account->'+con); 
        
        
        List<AccountContactRelation> acr1 = [SELECT ID,RSD_Primary_Contact__c,ISDirect FROM AccountContactRelation WHERE AccountID=:acc[0].id AND ContactID =: con[0].ID];
        //System.debug('ACR ID--->'+acr1);
        
              
        AccountContactRelation acrUpdate1 = new AccountContactRelation(ID=acr1[0].ID,RSD_Primary_Contact__c=TRUE);
        //Update acrUpdate1;
        
        try{
           Update acrUpdate1; 
        }catch(Exception e){
          //  System.assertEquals(e, 'Only one Direct Contact can be marked as Primary for this account.');
          
        }
        
        AccountContactRelation acrUpdate2 = new AccountContactRelation(ID=acr1[0].ID,RSD_Primary_Contact__c=TRUE);
       // Update acrUpdate2;
        
        /*List<Contact> con2= data.insertContact(1, Schema.SObjectType.Contact.getRecordTypeInfosByName().get('RSD NA Contact').getRecordTypeId(), acc[0].Id);
        AccountContactRelation acr2 = new AccountContactRelation(AccountID=acc[0].id,ContactID=con2[0].id,RSD_Primary_Contact__c=TRUE);
        insert acr2;*/
    }

}