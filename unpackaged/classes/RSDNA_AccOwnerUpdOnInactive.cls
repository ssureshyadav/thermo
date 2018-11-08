/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 03 April,2017
    Requirement : W-000021 : T-00022
    Description : This class is called by the trigger handler class RSDNA_AccountTriggerHandler_CLS during the trigger execution
    Test Class  : RSDNA_AccInactiveConAccOwnerUpdTest
    Last Updated By :
    
*/

Public Class RSDNA_AccOwnerUpdOnInactive{    
    public id RecID;
    public id RecLockedID;
    public id RecVendorID;
    public id RecTOG;
    public set<id> accSetID = new set<id>();
    public set<id> accErrorID = new set<id>();
    public set<id> accErrorInactiveID = new set<id>();
    public List<Account> accChildLst = new List<Account>(); 

    Public void updateAccount(List<Account> accLst,Map<Id, Account> oldAccMap,Map<Id, Account> newAccMap){
        RecID = Schema.SObjectType.account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId();
        RecLockedID = Schema.SObjectType.account.getRecordTypeInfosByName().get('RSD NA Customer Locked Record Type').getRecordTypeId();
        RecVendorID = Schema.SObjectType.account.getRecordTypeInfosByName().get('RSD Vendor').getRecordTypeId();
        RecTOG = Schema.SObjectType.account.getRecordTypeInfosByName().get('RSD NA Top of Group').getRecordTypeId();
        
        set<id> recTypeSet =  new set<id>{RecID,RecLockedID,RecVendorID};   
        RSD_Organization_Specific_Settings__c oppAdminIdInstance = RSD_Organization_Specific_Settings__c.getOrgDefaults();  
        Set<id> getAllRecordType = new Set<id>{RecID,RecLockedID,RecTOG};

        for(Account acc: accLst){        
        //W-000021 : T-00022 : Use the setting above to change the owner of the Account record when the Account Status changes to 'Inactive'    
            if(oldAccMap.get(acc.id).RSD_Account_Status__c != newAccMap.get(acc.id).RSD_Account_Status__c && acc.RSD_Account_Status__c == 'Inactive'){
            // W-000021 : T-00023 : Created a back end field called RSD_Display_Alert__c inorder to display a message on UI
                acc.RSD_Display_Alert__c = True;
                if(recTypeSet.contains(acc.recordtypeID)){          
                    acc.OwnerId =  oppAdminIdInstance.RSD_NA_Sales_Operations_Admin_User_ID__c;
                } 
                
                if(acc.recordtypeID == RecTOG){
                accSetID.add(acc.Id);               
                }           
            }
            // W-000021 : T-00023 : Created a back end field called RSD_Display_Alert__c inorder to display a message on UI
            if(oldAccMap.get(acc.id).RSD_Account_Status__c != newAccMap.get(acc.id).RSD_Account_Status__c && acc.RSD_Account_Status__c == 'Active'){
                acc.RSD_Display_Alert__c = False;
            }
        }
        
     if(accSetID != Null){
        for(Account accMap:[select parentid,id,RSD_Account_Status__c from Account where ParentID IN: accSetID and RSD_Account_Status__c = 'active']){
                accErrorID.add(accMap.parentid);       
        }   
        
     for(Account accMapInactive:[select parentid,id,RSD_Account_Status__c from Account where ParentID IN: accSetID and RSD_Account_Status__c = 'Inactive']){
        if(!accErrorID.contains(accMapInactive.parentid)){
        accErrorInactiveID.add(accMapInactive.parentid); 
            }   
        }
     }
     
        //W-000021 : T-00022 : For 'RSD NA Top of Group' record type, only allow the Account Status to change to 'Inactive' if there are no Active child accounts. Display the error message 'Parent Account with active child accounts cannot be set to 'Inactive'.    
        for(Account acc: accLst){
            if(oldAccMap.get(acc.id).RSD_Account_Status__c != newAccMap.get(acc.id).RSD_Account_Status__c && acc.RSD_Account_Status__c == 'Inactive'){
            if(accErrorID.contains(acc.Id)){
                acc.addError('Parent Account with active child accounts cannot be set to Inactive');
            }else{
            //if(accErrorInactiveID.contains(acc.Id)){
                 acc.OwnerId = oppAdminIdInstance.RSD_NA_Sales_Operations_Admin_User_ID__c;       
            } 
        }           
        }
    }
}