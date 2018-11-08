/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 05 April,2017
    Requirement : W-000047 : T-00026
    Description : This class is called by the trigger handler class RSDNA_AccountTriggerHandler_CLS during the trigger execution
    Test Class  : RSDNA_AccInactiveConAccOwnerUpdTest
    Last Updated By :
    
*/

Public Class RSDNA_AccInactiveConAssociation{
    public set<id> conAccRelationID = new Set<id>();
    public set<id> accID = new Set<id>();
    public set<id> singleAccAssociationSET = new Set<id>();
    public set<id> multiAccAssociationSET = new Set<id>();
    public List<AccountContactRelation> multiAccAssocNotDirectLIST = new List<AccountContactRelation>();
    public List<AccountContactRelation> multiAccAssocDirectLIST = new List<AccountContactRelation>();
    public set<id> multiAccAssocDirectSET = new Set<id>();
    public List<AccountContactRelation> singleAccAssocLIST = new List<AccountContactRelation>();
    public List<Contact> conStatusUpdate = new List<Contact>();
    public  Integer count = 0;
    
    /*
   Parameters : Trigger.new, Trigger.oldMap, Trigger.newMap from RSDNA_AccountTriggerHandler_CLS 
    */     

   //Req : W-000047 : T-00026 : Dev - Create Apex Trigger to set Contact to Inactive
    Public void associateContact(List<Account> accLst,Map<Id, Account> oldAccMap,Map<Id, Account> newAccMap){
        
        for(account acc: accLst){
        if(oldAccMap.get(acc.id).RSD_Account_Status__c != newAccMap.get(acc.id).RSD_Account_Status__c && acc.RSD_Account_Status__c == 'InActive'){
        accID.add(acc.id);
        }
        }
        system.debug('The value of the accID------------>'+ accID);
        RSD_Organization_Specific_Settings__c oppAdminIdInstance = RSD_Organization_Specific_Settings__c.getOrgDefaults();
        
        for(AccountContactRelation accConLst :  [select contactid from AccountContactRelation where AccountId IN: accID]){
            conAccRelationID.add(accConLst.contactid);          
        }
        
        system.debug('The value of the conAccRelationID------------>'+ conAccRelationID);
         //Get the list of Accounts associated with each contact of the Account which is getting Inactivated and Get the total account count for each contact and put it in a MAP 
        List<AggregateResult> results = [select contactid ,count(AccountId) from AccountContactRelation where contactid IN : conAccRelationID group by contactid]; 
        for(AggregateResult accLstconget: results){
            if((integer)accLstconget.get('expr0') == 1){
                singleAccAssociationSET.add((Id)accLstconget.get('ContactId'));                     
            }else{
                multiAccAssociationSET.add((Id)accLstconget.get('ContactId'));
            }
        }

           system.debug('The value of singleAccAssociationSET----------->'+singleAccAssociationSET);    
           system.debug('The value of multiAccAssociationSET----------->'+multiAccAssociationSET); 
        
            /* if(!singleAccAssociationSET.isEmpty()){                
            singleAccAssocLIST = [select contactid,accountid from AccountContactRelation where contactid IN:singleAccAssociationSET];       
            } */

        if(!multiAccAssociationSET.isEmpty()){             
            for(AccountContactRelation congetAccount : [select contactid,accountid,IsDirect from AccountContactRelation where contactid IN:multiAccAssociationSET]){    
                    if(accID.contains(congetAccount.accountid)){
                        if(!congetAccount.IsDirect == True){
                                multiAccAssocNotDirectLIST.add(congetAccount); 
                    }else{
                                multiAccAssocDirectLIST.add(congetAccount);
                                multiAccAssocDirectSET.add(congetAccount.contactid);
                    }                                   
                }                   
            }           
        }
            
        system.debug('The value of multiAccAssocNotDirectLIST----------->'+multiAccAssocNotDirectLIST);    
        system.debug('The value of multiAccAssocDirectLIST----------->'+multiAccAssocDirectLIST);  

        //Change contact owner to a pre-defined Sales Operations Admin or Sys Admin user stored in a custom setting
        
        if(!singleAccAssociationSET.isEmpty()){
        for(contact conInactive : [select ID,RSD_Contact_Status__c from contact where ID IN: singleAccAssociationSET]){
        conInactive.RSD_Contact_Status__c = 'Inactive';     
        conInactive.OwnerId =  oppAdminIdInstance.RSD_NA_Sales_Operations_Admin_User_ID__c;
        conStatusUpdate.add(conInactive);       
        }
        }
        system.debug('The value of conStatusUpdate singleAccAssociationSET----------->'+conStatusUpdate);
        
        // remove contact association to current inactive account when the it is not Direct;        
        if(!multiAccAssocNotDirectLIST.isEmpty()){
        Delete multiAccAssocNotDirectLIST;
        }

        // Inactivate the contact related to when the it is Direct;     
         if(!multiAccAssocDirectSET.isEmpty()){
        for(contact conInactiveDirect : [select ID,RSD_Contact_Status__c from contact where ID IN: multiAccAssocDirectSET]){
        conInactiveDirect.RSD_Contact_Status__c = 'Inactive';     
        conInactiveDirect.OwnerId =  oppAdminIdInstance.RSD_NA_Sales_Operations_Admin_User_ID__c;
        conStatusUpdate.add(conInactiveDirect);       
        }
        }
        system.debug('The value of conStatusUpdate multiAccAssocDirectSET----------->'+conStatusUpdate);
                
        //Remove contact association to current one inactive account; 
        //Delete singleAccAssocLIST;       

        //Update the Contact with status and OwnerID when the contact and Single Account association and multi Account Direct Scenario
        Update conStatusUpdate;
        }
    }