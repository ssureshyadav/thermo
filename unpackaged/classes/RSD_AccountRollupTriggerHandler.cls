/*
Created By :Mohammed Abdul Qadeer
Company : Deloitte
Date : 19/10/2015
Description: This handler calss seves the AccountTrigger and its main purpose is to set few rollup fields on parent accounts.
Test Class : RSD_AccountRollupTriggerHandlerTest 
---------
Audit Log
---------
Date(DD/MM/YYYY)    Modified By     Reason
----------------------------------------------------------------------
19/09/2014          Mohammed        Handler class for AccountTrigger.
13/11/2015          Paul Maguire    Adding in PY Revenue

*/
public without sharing class RSD_AccountRollupTriggerHandler {
    
    public static String CHILD_ACC_PREFIX = 'RSD CBP%';

    //RSD_Sum_Of_Child_Account_Opportunities(On Parent Account) = SUM(RSD_Opportunity_Amount_Rollup__c) of Child Account
    //RSD_Actual_Spend__c (On Parent Account)                   = SUM(RSD_Actual_Spend__c) of Child Accounts
    //RSD_PY_Revenue__c (On Parent Account)                     = Sum(RSD_PY_Revenue__c) of Child Accounts

    //Static boolean to prevent trigger recursion
    public static Boolean disableAccountTrigger = false;
    
    //Static constant to return the Locked & Unlocked Child Account record type Ids
    public static Set<Id> childAccRecordTypeIds{get{
            if(childAccRecordTypeIds == null){
                childAccRecordTypeIds = (new Map <Id, RecordType>([Select Id from RecordType where SobjectType = 'Account' and Name Like :CHILD_ACC_PREFIX])).keySet();
                return childAccRecordTypeIds;
            }else
                return childAccRecordTypeIds;
        }
        private set;
    }
    
    //No Construtor Logic needed since we are using static handler methods
    public RSD_AccountRollupTriggerHandler() {}

    /*
    Method Name: handleAfterUpdate
    Method Purpose: This method is called upon the After Update context of the trigger, i.e when any 
        account records are updated and once they've been comitted to database. This method checks if 
        there is any change in RSD_Opportunity_Amount_Rollup__c or RSD_Actual_Spend__c or RSD_PY_Revenue__c field of the child 
        accounts being updated and it founds the change then it will prepare a set of parent account Ids and 
        delegates the task of re-calculating roll'up on parent accounts to updateOppAmountAndActualSpendOnParentAccount() method.
    Parameters: 
        newMap => is the map of new version of account records after comitted to database.
        oldMap => is the map of old version of account records before being comitted to database.   
    */
    public static void handleAfterUpdate(Map<Id, Account> newMap, Map<Id, Account> oldMap){
        Set<Id> oppAmountChangedParentIds = new Set<Id>();
        Set<Id> actualSpendChangedParentIds = new Set<Id>();     
        
// PM 13/11/2015 add in PY Revenue set
        Set<Id> pyRevenueChangedParentIds = new Set<Id>();        
        
        System.debug('*** Handle After Update Method');
        for(Account acc : newMap.values()){
            if(childAccRecordTypeIds.contains(acc.RecordTypeId) && acc.ParentId != null){
                if(acc.RSD_Opportunity_Amount_Rollup__c != null && acc.RSD_Opportunity_Amount_Rollup__c > 0 && acc.RSD_Opportunity_Amount_Rollup__c != oldMap.get(acc.Id).RSD_Opportunity_Amount_Rollup__c)
                    oppAmountChangedParentIds.add(acc.ParentId);
                if(acc.RSD_Actual_Spend__c != null && acc.RSD_Actual_Spend__c > 0 && acc.RSD_Actual_Spend__c != oldMap.get(acc.Id).RSD_Actual_Spend__c)
                    actualSpendChangedParentIds.add(acc.ParentId);
                    
// PM 13/11/2015 added in RSD_PY_Revenue__c                   
                if(acc.RSD_PY_Revenue__c !=null && acc.RSD_PY_Revenue__c > 0 && acc.RSD_PY_Revenue__c != oldMap.get(acc.Id).RSD_PY_Revenue__c)
                    pyRevenueChangedParentIds.add(acc.ParentId);                      
            }   
        }
        if(!oppAmountChangedParentIds.isEmpty() || !actualSpendChangedParentIds.isEmpty() || !pyRevenueChangedParentIds.isEmpty() ) // PM 13/11/2015 updated with pyRevenueChangedParentIds
            updateOppAmountAndActualSpendOnParentAccount(oppAmountChangedParentIds, actualSpendChangedParentIds, pyRevenueChangedParentIds);
    }
    
    /*
    Method Name: updateOppAmountAndActualSpendAndPyRevenueOnParentAccount
    Method Purpose: This method queries all the child accounts of all the parent account provided in parameters and calculates the sum of opportunity totals 
            which is stored in RSD_Sum_Of_Child_Account_Opportunities__c field on parent object. It also calculates the actual spend and stores 
            in RSD_Actual_Spend__c field on parent account.
    Parameters:
        oppAmountChangedParentIds => This is the set of parent account ids of whose child accounts had a chnage in Opportunity amount.
        actualSpendChangedParentIds => This is the set of parent account ids of whose child accounts had a change in Actual Spend amount.
    */
    public static void updateOppAmountAndActualSpendOnParentAccount(Set<Id> oppAmountChangedParentIds, Set<Id> actualSpendChangedParentIds, Set<Id> pyRevenueChangedParentIds ){
        Map<Id, List<Account>> parentToChildAccountsMap = new Map<Id, List<Account>>();
        List<Account> accountsToUpdate = new List<Account>();
        List<Account> childAccounts = [Select Id, ParentId, RSD_Opportunity_Amount_Rollup__c, RSD_Actual_Spend__c, RSD_PY_Revenue__c from Account 
 /* PM 13/11/2015 modified  */   where ParentId IN :oppAmountChangedParentIds OR ParentId IN :actualSpendChangedParentIds OR ParentId IN :pyRevenueChangedParentIds];
        
        for(Account acc : childAccounts){
            if(parentToChildAccountsMap.containsKey(acc.ParentId))
                parentToChildAccountsMap.get(acc.ParentId).add(acc);
            else
                parentToChildAccountsMap.put(acc.ParentId, new List<Account>{acc});
        }
        for(Id parentAccountId : parentToChildAccountsMap.keySet()){
            Decimal oppAmountTotals = 0.0;
            Decimal actualSpendTotals = 0.0;
            Decimal pyRevenueTotals = 0.0; //PM 13/11/2015 added
            Account parentAccountToUpdate = new Account(Id = parentAccountId);

            if(oppAmountChangedParentIds.contains(parentAccountId))
                for(Account acc : parentToChildAccountsMap.get(parentAccountId))
                    if(acc.RSD_Opportunity_Amount_Rollup__c != null && acc.RSD_Opportunity_Amount_Rollup__c > 0)
                        oppAmountTotals += acc.RSD_Opportunity_Amount_Rollup__c;

            if(actualSpendChangedParentIds.contains(parentAccountId))
                for(Account acc : parentToChildAccountsMap.get(parentAccountId))
                    if(acc.RSD_Actual_Spend__c != null && acc.RSD_Actual_Spend__c > 0)
                        actualSpendTotals += acc.RSD_Actual_Spend__c;

//PM 13/11/2015 added
             
            if(pyRevenueChangedParentIds.contains(parentAccountId))
                for(Account acc : parentToChildAccountsMap.get(parentAccountId))
                    if(acc.RSD_PY_Revenue__c != null && acc.RSD_PY_Revenue__c > 0)
                        pyRevenueTotals += acc.RSD_PY_Revenue__c;            
                        
                        

            if(oppAmountTotals > 0)
                parentAccountToUpdate.RSD_Sum_Of_Child_Account_Opportunities__c = oppAmountTotals;

            if(actualSpendTotals > 0)
                parentAccountToUpdate.RSD_Actual_Spend__c = actualSpendTotals;
                
            
            if(pyRevenueTotals > 0)
                parentAccountToUpdate.RSD_PY_Revenue__c = pyRevenueTotals;

            accountsToUpdate.add(parentAccountToUpdate);
        }
        if(!accountsToUpdate.isEmpty()) update accountsToUpdate;
    }
}