@isTest
public class RSDNA_TerritoryPurgeBatchTest{

@testSetup static void setup(){
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting();   
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){
        Territory2Model terrModel = new Territory2Model();
                    terrModel .DeveloperName='ModelName';
                    terrModel.Name = 'Name';
                    insert terrModel;
                  //  List<Territory2Type> terrType   = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'RSD_Division' LIMIT 1]; 
           

         Territory2Type terriType   = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'RSD_Division' ];
         
         id getTrrTypeID = terriType.id;
           
        Test.startTest();   
        Territory2 newTer = new Territory2(Name = 'RSD NA TEST1234',
                                                DeveloperName = 'RSD_NA_TEST1234',
                                                Territory2TypeId = getTrrTypeID,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer;
     
         
            Territory2 newTer1 = new Territory2(Name = 'RSD NA ABCD1234',
                                                DeveloperName = 'RSD_NA_ABCD1234',
                                                Territory2TypeId =getTrrTypeID,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer1;
            
            Territory2 newTer2 = new Territory2(Name = 'RSD NA XYZ1234',
                                                DeveloperName = 'RSD_NA_XYZ1234',
                                                Territory2TypeId =getTrrTypeID,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer2;
            

            // Insert  Account
            Account acc = new Account(Name ='TestAccount',RSD_MF_Account_Source__c = 'USMF',RSD_US_Account_Number__c ='CMF34828',recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
            insert acc; 
            
            // Insert  Account
            Account accCA = new Account(Name ='TestAccountCA',RSD_MF_Account_Source__c = 'CMF',RSD_CA_Account_Number__c ='CA34828',recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
            insert accCA; 
            
            // Insert ObjectTerritory2Association
            ObjectTerritory2Association objAs = new ObjectTerritory2Association(ObjectId = acc.Id,Territory2Id = newTer.Id,AssociationCause  ='Territory2Manual');
            insert objAs;
            
            // Insert ObjectTerritory2Association
            ObjectTerritory2Association objCAAs = new ObjectTerritory2Association(ObjectId = accCA.Id,Territory2Id = newTer1.Id,AssociationCause  ='Territory2Manual');
            insert objCAAs;
        Test.stopTest();
        }
    }

    @isTest static void Test01(){
    
       
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_US_Account_Number__c FROM Account WHERE RSD_US_Account_Number__c = 'CMF34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c = acc.RSD_US_Account_Number__c, RSD_Action_Indicator__c ='I',RSD_Source_System__c ='USMF',RSD_Territory_Number__c ='TEST1234');
        
        Insert accTrr;         
        
             database.executeBatch(new RSDNA_AccountTerritoryPurgeBatch(),20);
             
         RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='I',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='TEST1234',RSD_Workday_Number__c ='TEST12');
        INSERT usrTrr;
        
            database.executeBatch(new RSDNA_UserTerritoryPurgeBatch(),20); 
            
         RSD_Org_To_Territory__c orgTrr2 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 5.0, RSD_Parent_Territory_Number__c = 'TEST1234',RSD_Source_System__c ='USMF',RSD_Territory_Number__c='ABCD1234');    
        insert orgTrr2;
        
           database.executeBatch(new RSDNA_OrgTerritoryPurgeBatch(),20);
           
         test.stoptest();  

         }
}