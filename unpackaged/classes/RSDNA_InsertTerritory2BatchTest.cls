/*
    Created By  : Venkatesh Kumar
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 24 May,2017
    Description : 
    Test Class for: RSDNA_InsertTerritory2Batch 
*/
@isTest()
public class RSDNA_InsertTerritory2BatchTest{

    @istest static void setup(){
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting();  
        
         Territory2Type type=[SELECT Description,DeveloperName,Id,Language,MasterLabel,Priority FROM Territory2Type];
          
          Territory2Model model=[SELECT ActivatedDate,CurrencyIsoCode,DeveloperName,Id,LastOppTerrAssignEndDate,Name,State FROM Territory2Model WHERE DeveloperName = 'ThermoFisher_RSD_Territory'];
          
          List<Territory2> terr=[SELECT DeveloperName,Id,Name,ParentTerritory2Id,Territory2ModelId,Territory2TypeId FROM Territory2 WHERE DeveloperName = 'RSD_NA_Division'];
          
          RSD_Territory_Settings__c tSettings=new RSD_Territory_Settings__c();
          tSettings.RSD_Territory_Type__c = type.Id;
          tSettings.RSD_Territory_Model__c =model.Id;
          tSettings.RSD_NA_Top_Level_Territory__c =terr[0].Id;
          tSettings.RSD_NA_Delete_Inactive_Territories__c = true;
        insert tSettings;
          
           
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ){
                   Territory2Model terrModel = new Territory2Model();
                    terrModel .DeveloperName='ModelName';
                    terrModel.Name = 'Name';
                    insert terrModel;
            
            List<Territory2Type> terrType   = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'RSD_Division' LIMIT 1]; 
            
            Territory2 newTer = new Territory2();
            Territory2 newTer1 = new Territory2();       
            newTer.Name = 'RSD NA TEST1234';
            newTer.DeveloperName = 'RSD_NA_TEST1234';
            newTer.Territory2TypeId = terrType[0].Id;
            newTer.Territory2ModelId = terrModel.Id;
            Insert newTer;
            
            newTer1.Name = 'RSD NA ABCD1234';
            newTer1.DeveloperName = 'RSD_NA_ABCD1234';
            newTer1.Territory2TypeId = terrType[0].Id;
            newTer1.Territory2ModelId = terrModel.Id;
            Insert newTer1;
            
            Territory2 newTer2 = new Territory2(Name = 'RSD NA XYZ1234',
                                                DeveloperName = 'RSD_NA_XYZ1234',
                                                Territory2TypeId = terrType[0].Id,
                                                Territory2ModelId = terrModel.Id);
            Insert newTer2;         
        }
    } 
    
    @isTest static Void TestTrr01(){
        List<Territory2> terr = new List<Territory2>();
        List<String> lstTrrName = new List<String>{'RSD_NA_TEST1234','RSD_NA_ABCD1234'};
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN: lstTrrName];
        
        RSD_Org_To_Territory__c orgTrr2 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 5.0, RSD_Parent_Territory_Number__c = 'Child01',RSD_Source_System__c ='CMF',RSD_Territory_Number__c='Child02');    
        insert orgTrr2;
        RSD_Org_To_Territory__c orgTrr3 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 4.0, RSD_Parent_Territory_Number__c = 'Child02',RSD_Source_System__c ='CMF',RSD_Territory_Number__c='Child03');    
        insert orgTrr3;
        RSD_Org_To_Territory__c orgTrr4 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 3.0, RSD_Parent_Territory_Number__c = 'Child03',RSD_Source_System__c ='CMF',RSD_Territory_Number__c='Child04');    
        insert orgTrr4;
        RSD_Org_To_Territory__c orgTrr5 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 2.0, RSD_Parent_Territory_Number__c = 'Child04',RSD_Source_System__c ='CMF',RSD_Territory_Number__c='Child05');    
        insert orgTrr5;
        RSD_Org_To_Territory__c orgTrr6 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 1.0, RSD_Parent_Territory_Number__c = 'Child05',RSD_Source_System__c ='CMF',RSD_Territory_Number__c='Child06');    
        insert orgTrr6;
        
        test.starttest();
             Database.executeBatch(new RSDNA_InsertTerritory2Batch(),20);   
         test.stoptest();

        }
    
    @isTest static Void TestTRR02(){
        List<Territory2> terr = new List<Territory2>();
        List<String> lstTrrName = new List<String>{'RSD_NA_TEST1234','RSD_NA_ABCD1234'};
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName = 'RSD_NA_TEST1234'];
        
        RSD_Org_To_Territory__c orgTrr2 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 5.0, RSD_Parent_Territory_Number__c = 'TEST1234',RSD_Source_System__c ='USMF',RSD_Territory_Number__c='ABCD1234');    
        insert orgTrr2;   
        
        test.starttest();
             Database.executeBatch(new RSDNA_InsertTerritory2Batch(),20);   
         test.stoptest();
    }
    
    @isTest static void TestTRR03(){
        List<Territory2> terr = new List<Territory2>();
        List<String> lstTrrName = new List<String>{'RSD_NA_TEST1234','RSD_NA_ABCD1234'};
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN: lstTrrName];
        
        RSD_Org_To_Territory__c orgTrr2 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 3.0, RSD_Parent_Territory_Number__c = 'TEST1234',RSD_Source_System__c ='USMF',RSD_Territory_Number__c='NewChild');    
        insert orgTrr2;     
  
        test.starttest();
             Database.executeBatch(new RSDNA_InsertTerritory2Batch(),20);   
         test.stoptest();
    }
    
    @isTest static void TestTRR04(){
        List<Territory2> terr = new List<Territory2>();
        List<String> lstTrrName = new List<String>{'RSD_NA_TEST1234','RSD_NA_ABCD1234'};
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN: lstTrrName];
        
        RSD_Org_To_Territory__c orgTrr2 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 5.0, RSD_Source_System__c ='USMF',RSD_Territory_Number__c='TEST1234');    
        insert orgTrr2;     
         
        test.starttest();
             Database.executeBatch(new RSDNA_InsertTerritory2Batch());   
         test.stoptest();        
    }
    
    @isTest static void TestTRR05(){
        List<Territory2> terr = new List<Territory2>();
        List<String> lstTrrName = new List<String>{'RSD_NA_TEST1234','RSD_NA_ABCD1234'};
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN: lstTrrName];
        
        RSD_Org_To_Territory__c orgTrr2 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'I', RSD_Level__c = 2.0, RSD_Parent_Territory_Number__c = 'Parent NotFound ',RSD_Source_System__c ='USMF',RSD_Territory_Number__c='NewChild');    
        insert orgTrr2;  
        
         test.starttest();
             Database.executeBatch(new RSDNA_InsertTerritory2Batch());   
         test.stoptest();        
    }
    
    @isTest static Void TestTRR06(){
        List<Territory2> terr = new List<Territory2>();
        List<String> lstTrrName = new List<String>{'RSD_NA_TEST1234','RSD_NA_ABCD1234'};
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN: lstTrrName];
        
        RSD_Org_To_Territory__c orgTrr2 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'D', RSD_Level__c = 5.0, RSD_Parent_Territory_Number__c = 'TEST1234',RSD_Source_System__c ='USMF',RSD_Territory_Number__c='ABCD1234');    
        insert orgTrr2;     
         
         test.starttest();
             Database.executeBatch(new RSDNA_InsertTerritory2Batch());   
         test.stoptest(); 
    }
    
    @isTest static Void TestTRR07(){
        List<Territory2> terr = new List<Territory2>();
        List<String> lstTrrName = new List<String>{'RSD_NA_TEST1234','RSD_NA_ABCD1234'};
        terr = [SELECT Id, DeveloperName,Name FROM Territory2 WHERE DeveloperName IN: lstTrrName];
        
        RSD_Org_To_Territory__c orgTrr2 = new RSD_Org_To_Territory__c( RSD_Action_Indicator__c = 'D', RSD_Level__c = 5.0, RSD_Parent_Territory_Number__c = 'TEST1234',RSD_Source_System__c ='USMF',RSD_Territory_Number__c='NoChildRecords');    
        insert orgTrr2;     
         
         test.starttest();
             Database.executeBatch(new RSDNA_InsertTerritory2Batch());   
         test.stoptest();
    }
    

}