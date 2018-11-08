/*
    Created By  : VenkatesH Kumar Sakthivel
    Email ID    : Venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 03 April,2017
    Description : Testing the apex class written for W-000021,W-000047
    Test Class for: RSDNA_AccInactiveConAssociation and RSDNA_AccOwnerUpdOnInactive
*/
@isTest(seeAllData = True)
private class RSDNA_AccInactiveConAccOwnerUpdTest{
    
    static TestMethod void InsertUpdateAccount(){
        
        List<Account> lstAccountUpdate = new List<Account> ();
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting();
        List<Account> lstAccount=data.insertAccount(2,Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
        data.insertContact(1,Schema.SobjectType.Contact.getRecordTypeInfosByName().get('RSD NA Contact').getRecordTypeId(),lstAccount[0].Id);
                
        for(Account acc: lstAccount){
            acc.RSD_Account_Status__c = 'InActive'; 
            lstAccountUpdate.add(acc);          
        }
        
        Test.startTest();
        Update lstAccountUpdate;
        Test.stopTest();
          
    }
    
       static TestMethod void InsertUpdateAccountTOGRec(){
        
        List<Account> lstAccountUpdate = new List<Account> ();
        List<Account> lstAccountUpdaterec = new List<Account> ();
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting();
        List<Account> lstAccount=data.insertAccount(2,Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Top of Group').getRecordTypeId());
        data.insertContact(1,Schema.SobjectType.Contact.getRecordTypeInfosByName().get('RSD NA Contact').getRecordTypeId(),lstAccount[0].Id);
                
        for(Account acc: lstAccount){
            acc.RSD_Account_Status__c = 'InActive';             
            lstAccountUpdate.add(acc);          
        } 
        Test.startTest();       
        Update lstAccountUpdate;
        Test.stopTest();
    }
    
        static TestMethod void InsertUpdateAccountParent(){
       
        List<Account> lstAccountUpdate = new List<Account> ();
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting();
        List<Account> lstAccount=data.insertAccount(1,Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Top of Group').getRecordTypeId());
        List<contact> con =  data.insertContact(1,Schema.SobjectType.Contact.getRecordTypeInfosByName().get('RSD NA Contact').getRecordTypeId(),lstAccount[0].Id);
                
        Account acc = new Account (Name = 'Test01',RecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId(),ParentID = lstAccount[0].id);
        insert acc;
        
        //AccountContactRelation accConRel = new AccountContactRelation (ContactId = con[0].Id,AccountId = lstAccount[0].Id,Roles=null);
        //insert accConRel;
        
        AccountContactRelation accConRel1 = new AccountContactRelation (ContactId = con[0].Id,AccountId = acc.Id,Roles=null);
        insert accConRel1;
        
        for(Account acc1: lstAccount){
            acc1.RSD_Account_Status__c = 'InActive';             
            lstAccountUpdate.add(acc1);          
        }
        
        Test.startTest();
        Update lstAccountUpdate;
        Update acc;

        Test.stopTest();
    }
}