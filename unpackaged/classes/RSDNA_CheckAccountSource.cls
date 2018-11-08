/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 02 May,2017
    Requirement : W-000087:T-00094: Data Integration - Vendor Accounts
    Description : If the MF Account Source in Account changes on Update, we are not throwng any error , instead we are replacing the old values of the MF Source and External ID's. 
    Test Class  : 
    Last Updated By : Venkatesh Kumar Sakthivel
    
*/


public class RSDNA_CheckAccountSource{
    public void processingupdate(List<Account> lstAcc, Map<Id,Account> oldMap){
        List<Account> lstaccUpdate =  new List<Account>();
        Set<ID> getAllAccount = new Set<ID>();
        Set<ID> checkRecordType = new Set<ID>{Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').getRecordTypeId(),Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId(),Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer Locked Record Type').getRecordTypeId()};
            for(Account acc: lstAcc){
                if(oldMap != Null){
                if(oldMap.get(acc.Id).RSD_MF_Account_Source__c !=Null && oldMap.get(acc.Id).RSD_MF_Account_Source__c != acc.RSD_MF_Account_Source__c && checkRecordType.contains(acc.recordtypeID)){
                    acc.RSD_MF_Account_Source__c = oldMap.get(acc.Id).RSD_MF_Account_Source__c ;                    
                    //acc.RSD_US_Account_External_Id__c = oldMap.get(acc.id).RSD_US_Account_External_Id__c;
                    //acc.RSD_CA_Account_External_Id__c = oldMap.get(acc.id).RSD_CA_Account_External_Id__c;
                }
            }
            }
    }
}