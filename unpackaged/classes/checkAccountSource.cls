public class checkAccountSource{
    public void processingupdate(List<Account> lstAcc, Map<Id,Account> oldMap){
        List<Account> lstaccUpdate =  new List<Account>();
        Set<ID> getAllAccount = new Set<ID>();
            for(Account acc: lstAcc){
                if(oldMap.get(acc.Id).RSD_MF_Account_Source__c != acc.RSD_MF_Account_Source__c && acc.recordtypeID == Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').getRecordTypeId() ){
                    getAllAccount.add(acc.Id);
                }
                if(!getAllAccount.isEmpty()){   
                    for(Account accUpdate: [select ID,RSD_US_Account_External_Id__c,RSD_CA_Account_External_Id__c,RSD_MF_Account_Source__c FROM Account where ID IN: getAllAccount]){
                        accUpdate.RSD_US_Account_External_Id__c = oldMap.get(accUpdate.id).RSD_US_Account_External_Id__c;
                        accUpdate.RSD_CA_Account_External_Id__c = oldMap.get(accUpdate.id).RSD_CA_Account_External_Id__c;
                        lstaccUpdate.add(accUpdate);
                    }   
                }
                if(!lstaccUpdate.isEmpty()){
                    try{
                        database.update(lstaccUpdate,false);
                    }catch(exception e){
                        system.debug('The following exception has occured------>'+e);
                    }
                }
            }
    }
}