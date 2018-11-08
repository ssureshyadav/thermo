@isTest
public class RSDNA_UserTerritory2BatchTest{
    
     @testSetup static void setup(){
    //static testmethod void  setup(){
              
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){
        Territory2Model terrModel = new Territory2Model();
                    terrModel .DeveloperName='ModelName';
                    terrModel.Name = 'Name';
                    insert terrModel;
                    List<Territory2Type> terrType   = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'RSD_Division' LIMIT 1]; 
                    
        Territory2 newTer = new Territory2(Name = 'RSD NA TEST1234',
                                                DeveloperName = 'RSD_NA_TEST1234',
                                                Territory2TypeId = terrType[0].Id,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer;
            
            Territory2 newTer1 = new Territory2(Name = 'RSD NA ABCD1234',
                                                DeveloperName = 'RSD_NA_ABCD1234',
                                                Territory2TypeId = terrType[0].Id,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer1;
            
            Territory2 newTer2 = new Territory2(Name = 'RSD NA XYZ1234',
                                                DeveloperName = 'RSD_NA_XYZ1234',
                                                Territory2TypeId = terrType[0].Id,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer2;
            
            Territory2 newTer3 = new Territory2(Name = 'RSD NA GENL9773',
                                                DeveloperName = 'RSD_NA_GENL9773',
                                                Territory2TypeId = terrType[0].Id,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer3;
            
            Territory2 newTer4 = new Territory2(Name = 'RSD NA GENL97789',
                                                DeveloperName = 'RSD_NA_GENL97789',
                                                Territory2TypeId = terrType[0].Id,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer4;
            
            Territory2 newTer5 = new Territory2(Name = 'RSD NA GENL77777',
                                                DeveloperName = 'RSD_NA_GENL77777',
                                                Territory2TypeId = terrType[0].Id,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer5;
            
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
            User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,RSD_Workday_Number__c = 'TEST12',
            TimeZoneSidKey='America/Los_Angeles', UserName='newuserForTFS@testorg.com',Users_Division__c = 'RSD NA');
            insert u2;
            User u4 = new User(Alias = 'newUser', Email='newuser01@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,RSD_Workday_Number__c = 'TEST123',
            TimeZoneSidKey='America/Los_Angeles', UserName='newuser01ForTFS@testorg.com',Users_Division__c = 'RSD NA',RSD_Territory_number__c ='testWorkdAY');
            insert u4;
            User u5 = new User(Alias = 'newUser1', Email='newuser02@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,RSD_Workday_Number__c = '00000000',
            TimeZoneSidKey='America/Los_Angeles', UserName='newuser02ForTFS@testorg.com',Users_Division__c = 'RSD NA');
            insert u5;

            // User Territory2 Association 
            UserTerritory2Association u2ts = new UserTerritory2Association(UserId = u2.Id, Territory2Id =newTer.Id );
            insert u2ts;
            
                // User Territory2 Association 
            UserTerritory2Association u2ts2= new UserTerritory2Association(UserId = u2.Id, Territory2Id =newTer1.Id );
            insert u2ts2;   

            UserTerritory2Association u2ts3= new UserTerritory2Association(UserId = u4.Id, Territory2Id =newTer5.Id );
            insert u2ts3;               
            
            UserTerritory2Association u2ts4= new UserTerritory2Association(UserId = u5.Id, Territory2Id =newTer5.Id );
            insert u2ts4;    

            // Insert  Account
            Account acc = new Account(Name ='TestAccount',RSD_MF_Account_Source__c = 'USMF',RSD_US_Account_Number__c ='CMF34828',recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
            insert acc; 
            
            // Insert  Account
            Account accCA = new Account(Name ='TestAccountCA',RSD_MF_Account_Source__c = 'CMF',RSD_CA_Account_Number__c ='CA34828',recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
            insert accCA; 
            
            Contact con=new Contact(LastName ='Test',AccountId = accCA.ID,RSD_Archive__c =true,Reason_for_Archive__c ='Test');
            insert con;
            
            // Insert ObjectTerritory2Association
            ObjectTerritory2Association objAs = new ObjectTerritory2Association(ObjectId = acc.Id,Territory2Id = newTer5.Id,AssociationCause  ='Territory2Manual');
            insert objAs;
            
            // Insert ObjectTerritory2Association
            ObjectTerritory2Association objCAAs = new ObjectTerritory2Association(ObjectId = accCA.Id,Territory2Id = newTer5.Id,AssociationCause  ='Territory2Manual');
            insert objCAAs;
            
            insert new RSD_Organization_Specific_Settings__c(RSD_NA_Default_Record_Owner_User_ID__c = u5.id);
            
        }
    }
    
      @isTest static void testOTTInsert(){
          
        List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
        
        test.starttest();   
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='I',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='GENL97789',RSD_Workday_Number__c ='TEST12');
        INSERT usrTrr;
        
        Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    
    
    
    @isTest static void testOTTInsert002(){  
 
         List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
         
         test.starttest(); 
         
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='I',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='GENL77777',RSD_Workday_Number__c ='TEST123');
        INSERT usrTrr;       
      
             Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    
    @isTest static void testOTT(){        
          List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
         
         test.starttest(); 
         
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='I',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='GENL9773',RSD_Workday_Number__c ='TEST12');
        INSERT usrTrr;       

             Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    
     
    
    @isTest static void testOTT01(){
        List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
         
         test.starttest(); 
        
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='I',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='NoTerritory',RSD_Workday_Number__c ='TEST12');
        INSERT usrTrr;
 
             Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    
        @isTest static void testOTT02(){
         List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
         
         test.starttest(); 
        
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='I',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='TEST1234',RSD_Workday_Number__c ='NoUser');
        INSERT usrTrr;

             Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    
    
        @isTest static void testOTT03(){
         List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
         
         test.starttest(); 
        
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='D',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='TEST1234',RSD_Workday_Number__c ='NoUser');
        INSERT usrTrr;

             Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    
    @isTest static void testOTT04(){
        
         List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
         
         test.starttest(); 
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='D',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='NoTerritory',RSD_Workday_Number__c ='TEST12');
        INSERT usrTrr;

             Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    
        @isTest static void testOTT05(){
         List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
         
         test.starttest(); 
        
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='D',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='TEST1234',RSD_Workday_Number__c ='TEST12');
        INSERT usrTrr;

             Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    
    @isTest static void testOTT06(){
         List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
         
         test.starttest(); 
        
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='I',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='ABCD1234',RSD_Workday_Number__c ='TEST123');
        INSERT usrTrr;

             Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    @isTest static void testOTT07(){
         List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
         
         test.starttest(); 
        
        RSD_User_To_Territory__c usrTrr = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='D',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='ABCD1234',RSD_Workday_Number__c ='TEST123');
        INSERT usrTrr;
        
        RSD_User_To_Territory__c usrTrr1 = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='D',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='TEST1234',RSD_Workday_Number__c ='TEST123');
        INSERT usrTrr1;

             Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
    
    @isTest static void testOTT001(){
        List<Territory2> terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN( 'RSD_NA_GENL97789','RSD_NA_GENL77777','RSD_NA_GENL9773','RSD_NA_XYZ1234','RSD_NA_ABCD1234','RSD_NA_TEST1234')];
        List<User> usr = [select id,RSD_Workday_Number__c from User where RSD_Workday_Number__c IN ('TEST12','TEST123','00000000')];
        List<Account> acc =[select ID from Account where Name IN ('TestAccountCA','TestAccount') ];
        List<Contact> con =[select ID from contact where LastName IN ('Test') ];
        List<ObjectTerritory2Association> objA =[select ID from ObjectTerritory2Association where AssociationCause IN ('Territory2Manual') ];
        List<UserTerritory2Association> usrA =[select ID from UserTerritory2Association];
        RSD_Organization_Specific_Settings__c orgSp =[select RSD_NA_Default_Record_Owner_User_ID__c from RSD_Organization_Specific_Settings__c];
        
         test.starttest();        

        RSD_User_To_Territory__c usrTrr2 = new RSD_User_To_Territory__c(RSD_Action_Indicator__c ='I',RSD_Source_System__c='USMF',RSD_Territory_Number__c ='TEST1234',RSD_Workday_Number__c ='00000000');
        INSERT usrTrr2;
      
            Database.executeBatch(new RSDNA_UserTerritory2Batch());
         test.stoptest();
        
    }
}