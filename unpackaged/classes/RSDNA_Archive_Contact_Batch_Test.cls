/*
    Created By  : Suresh Sanneboina
    Email ID    : sanneboinasuresh.yadav@nttdata.com    
    Company     : NTTDATA
    Date        : 03 April,2017
    Description : Class for updating the contacts where RSD_Archive__c is true and account is not null owner not existing in custom settings.
    Test Class for: RSD_Archive_Contact_Batch
*/
@isTest(SeeAlldata=true)
private class RSDNA_Archive_Contact_Batch_Test
{
    static TestMethod void runBatchToUpdateContact()
    {
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting();
        List<Account> lstAccount=data.insertAccount(1,Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
        
        data.insertContact(1,Schema.SobjectType.Contact.getRecordTypeInfosByName().get('RSD NA Contact').getRecordTypeId(),lstAccount[0].Id);
        
        Test.startTest();
        Database.executeBatch(new RSDNA_Archive_Contact_Batch());
        Test.stopTest();
        
    }
}