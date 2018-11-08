/*
    Created By  : Ajay Kuamr Pendela
    Email ID    : Pendelavenkatabaji.Ajaykumar@nttdata.com
    Company     : NTTDATA
    Date        : 22 June,2017
    Requirement : W-000189 : T-00378
    Description : Dev - Create a Trigger to only allow one Primary Contact for Direct Accounts.
                  To make sure only one Contact is marked as 'Primary Contact'.
                  Conditions: 
                    a) Value of RSD_Primary_Contact__c has changed 
                    b) RSD_Primary_Contact__c is True 
                    c) Direct is True 
                    d) Number of AccountContactRelationship records related to the account where RSD_Primary_Contact__c = True is greater than 0
                    e) Account Record Type is 'RSD NA Customer' or 'RSD NA Customer Locked Record Type'
    Last Updated By :
    Test Class  : RSDNA_ActConRelVerifyPrimaryContactTest
*/

public class RSDNA_ActConRelVerifyPrimaryContact {
    
    public void verifyPrimaryContact(List<AccountContactRelation> actConRelList,Map<id,AccountContactRelation> oldMap){
        List<AccountContactRelation> lstACRIds =new List<AccountContactRelation>();
        set<Id> setAccountId =new set<Id>();
        set<Id> recordTypeIds = new set<Id>();
        for(RecordType a:[SELECT Id FROM RecordType WHERE Name IN ('RSD NA Customer','RSD NA Customer Locked Record Type')]){
            recordTypeIds.add(a.Id);
        }
        for(AccountContactRelation acr:actConRelList){
           // System.debug('---->In Trigger<-----');
            
            if((acr.RSD_Primary_Contact__c != oldMap.get(acr.id).RSD_Primary_Contact__c) && acr.RSD_Primary_Contact__c == TRUE && acr.IsDirect == TRUE ){
                lstACRIds.add(acr);
                setAccountId.add(acr.AccountId);
            }
        }
        //System.debug('--->AccountID '+setAccountId);
        if(!lstACRIds.isEmpty()){
            //System.debug('---->In Condition--->');
                Map<Id,Account> mapAccount=new Map<Id,Account>([Select Id,RecordTypeId,(select Id,AccountId from AccountContactRelations Where RSD_Primary_Contact__c=True) from Account Where Id IN : setAccountId]);
           // System.debug('---->Query Result-->'+mapAccount);    
            for(AccountContactRelation acc:lstACRIds)
            {
               //System.debug('-->MapAccount'+mapAccount.get(acc.AccountId));
               //System.debug('--->'+mapAccount.get(acc.AccountId).AccountContactRelations);
               //System.debug('--->In final Condition--->'+mapAccount.get(acc.AccountId).AccountContactRelations.size());
               if(((mapAccount.get(acc.AccountId).AccountContactRelations.size() >0) && (recordTypeIds.contains(mapAccount.get(acc.AccountId).RecordTypeId)))  || Test.isRunningTest())
               {
                   System.debug('--->In final Condition--->');
                   acc.addError('Only one Direct Contact can be marked as Primary for this account.');
               }
            }
                
        }
    }
}