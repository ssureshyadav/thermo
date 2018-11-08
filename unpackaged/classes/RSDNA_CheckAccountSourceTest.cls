/*
    Created By  : Venkatesh Kumar
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 24 April,2017
    Description : --Create a Opportunity Line Item and check for the Opportunity Amount field.
                  --Inactive a Opportunity Line item and then check whether the Opportunity amount has excluded this inactive product line item
    Test Class for: RSDNA_UpdateOppAmountonInactive_CLS
*/
@isTest(SeeAlldata=true)
private class RSDNA_CheckAccountSourceTest{
    static TestMethod void runCheckSource(){
     Account acc = new Account(Name ='TestAccount',RSD_MF_Account_Source__c = 'CMF',RSD_CA_Account_External_Id__c ='CMF34828',recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
     insert acc;

     acc.RSD_MF_Account_Source__c = 'USMF';
     update acc;
    
    }
}