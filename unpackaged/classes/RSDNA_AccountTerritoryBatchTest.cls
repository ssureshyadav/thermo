@isTest
public class RSDNA_AccountTerritoryBatchTest {
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
    
    @isTest static void testOTT(){

       
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_US_Account_Number__c FROM Account WHERE RSD_US_Account_Number__c = 'CMF34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c = acc.RSD_US_Account_Number__c, RSD_Action_Indicator__c ='I',RSD_Source_System__c ='USMF',RSD_Territory_Number__c ='TEST1234');
        
        Insert accTrr;         
        
             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
             database.executebatch(new RSDNA_ParentAccTerritoryBatch());
         test.stoptest();
    }
    
        @isTest static void testOTT02(){

       
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_US_Account_Number__c FROM Account WHERE RSD_US_Account_Number__c = 'CMF34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c = acc.RSD_US_Account_Number__c, RSD_Action_Indicator__c ='I',RSD_Source_System__c ='USMF',RSD_Territory_Number__c = 'TestNo');
        
        Insert accTrr;         
  
             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
             database.executebatch(new RSDNA_ParentAccTerritoryBatch());
         test.stoptest();
    }
    
    @isTest static void testOTT03(){

       
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_US_Account_Number__c FROM Account WHERE RSD_US_Account_Number__c = 'CMF34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c = '1234556433', RSD_Action_Indicator__c ='I',RSD_Source_System__c ='USMF',RSD_Territory_Number__c ='TEST1234');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
       @isTest static void testOTT04(){

       
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_US_Account_Number__c FROM Account WHERE RSD_US_Account_Number__c = 'CMF34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c = '1234556433', RSD_Action_Indicator__c ='I',RSD_Source_System__c ='USMF',RSD_Territory_Number__c ='Test');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
           @isTest static void testOTT05(){

       
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_US_Account_Number__c FROM Account WHERE RSD_US_Account_Number__c = 'CMF34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c =  acc.RSD_US_Account_Number__c, RSD_Action_Indicator__c ='D',RSD_Source_System__c ='USMF',RSD_Territory_Number__c ='TEST1234');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
           @isTest static void testOTT06(){

        
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_US_Account_Number__c FROM Account WHERE RSD_US_Account_Number__c = 'CMF34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c =  'Not Found', RSD_Action_Indicator__c ='D',RSD_Source_System__c ='USMF',RSD_Territory_Number__c ='NotFound');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
       @isTest static void testOTT07(){

       
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_ABCD1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_CA_Account_Number__c FROM Account WHERE RSD_CA_Account_Number__c ='CA34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c =  acc.RSD_CA_Account_Number__c, RSD_Action_Indicator__c ='I',RSD_Source_System__c ='CMF',RSD_Territory_Number__c ='ABCD1234');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
           @isTest static void testOTT08(){

       
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_CA_Account_Number__c FROM Account WHERE RSD_CA_Account_Number__c ='CA34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c =  acc.RSD_CA_Account_Number__c, RSD_Action_Indicator__c ='I',RSD_Source_System__c ='CMF',RSD_Territory_Number__c ='ABCD1234');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
               @isTest static void testOTT09(){


        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_ABCD1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_CA_Account_Number__c FROM Account WHERE RSD_CA_Account_Number__c ='CA34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c =  acc.RSD_CA_Account_Number__c, RSD_Primary_Indicator__c =true,RSD_Action_Indicator__c ='D',RSD_Source_System__c ='CMF',RSD_Territory_Number__c ='ABCD1234');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
           @isTest static void testOTT10(){

        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_ABCD1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_CA_Account_Number__c FROM Account WHERE RSD_CA_Account_Number__c ='CA34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c =  acc.RSD_CA_Account_Number__c, RSD_Action_Indicator__c ='D',RSD_Source_System__c ='CMF',RSD_Territory_Number__c ='No Territory');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
                   @isTest static void testOTT11(){

     
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_CA_Account_Number__c FROM Account WHERE RSD_CA_Account_Number__c ='CA34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c =  'TestAccount', RSD_Action_Indicator__c ='D',RSD_Source_System__c ='CMF',RSD_Territory_Number__c ='ABCD1234');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
           @isTest static void testOTT12(){

    
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_XYZ1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_CA_Account_Number__c FROM Account WHERE RSD_CA_Account_Number__c ='CA34828'];
        
        test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c =  'CA34828', RSD_Primary_Indicator__c =true,RSD_Action_Indicator__c ='I',RSD_Source_System__c ='CMF',RSD_Territory_Number__c ='XYZ1234');
        
        Insert accTrr;         
         
             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
    
           @isTest static void testOTT13(){

     
        List<Territory2> terr = new List<Territory2>();
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_XYZ1234'];
        account acc =[SELECT Id, Name,RSD_MF_Account_Source__c,RSD_CA_Account_Number__c FROM Account WHERE RSD_CA_Account_Number__c ='CA34828'];
        
         test.starttest();
        RSD_Account_To_Territory__c  accTrr= new RSD_Account_To_Territory__c(RSD_Account_Number__c =  'CA34828', RSD_Action_Indicator__c ='D',RSD_Source_System__c ='CMF',RSD_Territory_Number__c ='XYZ1234');
        
        Insert accTrr;         

             Database.executeBatch(new RSDNA_AccountTerritoryBatch());
         test.stoptest();
    }
}