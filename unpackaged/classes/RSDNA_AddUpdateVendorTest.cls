/*
    Created By  : Suresh Sanneboina
    Email ID    : 
    Company     : NTTDATA
    Date        : 5 June,2017
    Requirement : W-000027:T-00350: Dev - Create "Add/Update Vendor" button on Events
    Last Updated By : 
    
*/

@isTest
private class RSDNA_AddUpdateVendorTest
{
    @isTest
    private static void addVendor()
    {
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting();
        List<Account> lstAccount=data.insertAccount(1,Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').getRecordTypeId());
        
        List<Contact> lstContact=data.insertContact(1,Schema.SobjectType.Contact.getRecordTypeInfosByName().get('RSD NA Contact').getRecordTypeId(),lstAccount[0].Id);
         
         Event evt=new Event(Subject='test',WhoId=lstContact[0].Id,WhatId = lstAccount[0].Id,StartDateTime=DateTime.now().addMinutes(10),EndDateTime=DateTime.now().addMinutes(50),RSDNA_RefreshPage__c =false);
         insert evt;
         
         Apexpages.currentPage().getParameters().put('Id',evt.Id);
         
         
         RSDNA_AddUpdateVendor vendor=new RSDNA_AddUpdateVendor();
         vendor.accountId = lstAccount[0].Id;
         vendor.btncancel();
         vendor.getSearchAccounts();
         vendor.updateEvent();
        RSDNA_AddUpdateVendor.refreshPage(evt.Id);
        vendor.navigate();
    }
}