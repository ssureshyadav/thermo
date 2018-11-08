/*
    Created By  : Suresh Sanneboina
    Email ID    : 
    Company     : NTTDATA
    Date        : 12 June,2017
    Requirement : W-000180:
                    T-00353: Dev - Display 'Assigned Territories' list
                    T-00354: Dev - Display 'Users in Assigned Territories' list
    Test Class  : RSDNA_LtngAssignedTerritories
    Last Updated By : 
    
*/
@isTest
private class RSDNA_AssignedTerritoriesTest
{
    @isTest private static void territoriesTest()
    {
          Territory2Type type=[SELECT Description,DeveloperName,Id,Language,MasterLabel,Priority FROM Territory2Type];
          
          Territory2Model model=[SELECT ActivatedDate,CurrencyIsoCode,DeveloperName,Id,LastOppTerrAssignEndDate,Name,State FROM Territory2Model WHERE DeveloperName = 'ThermoFisher_RSD_Territory'];
          
          List<Territory2> terr=[SELECT DeveloperName,Id,Name,ParentTerritory2Id,Territory2ModelId,Territory2TypeId FROM Territory2 WHERE DeveloperName = 'RSD_NA_Division'];
          
            
            
            RSDNA_DataFactory data=new RSDNA_DataFactory(); 
            data.orgSpecificSetting();
            List<Account> lstAccount=data.insertAccount(1,Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
             User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ){
            
            Territory2 Pt2 = new Territory2();
            Pt2.Territory2TypeID = type.Id ;
            Pt2.Territory2ModelID = model.Id;
            Pt2.ParentTerritory2ID   =  terr[0].Id;
            Pt2.DeveloperName = 'RSD_NA_' +  'RSDNA001';
            Pt2.Name = 'RSD NA ' +  'RSDNA001';
            Pt2.RSD_Primary_Assigned_User_Id__c =UserInfo.getUserId();
            insert Pt2;
            
            Territory2 Pt3 = new Territory2();
            Pt3.Territory2TypeID = type.Id ;
            Pt3.Territory2ModelID = model.Id;
            Pt3.ParentTerritory2ID   =  Pt2.Id;
            Pt3.DeveloperName = 'RSD_NA_' +  'RSDNA002';
            Pt3.Name = 'RSD NA ' +  'RSDNA002';
            Pt3.RSD_Primary_Assigned_User_Id__c =UserInfo.getUserId();
            insert Pt3;
            
            Territory2 Pt4 = new Territory2();
            Pt4.Territory2TypeID = type.Id ;
            Pt4.Territory2ModelID = model.Id;
            Pt4.ParentTerritory2ID   =  Pt3.Id;
            Pt4.DeveloperName = 'RSD_NA_' +  'RSDNA003';
            Pt4.Name = 'RSD NA ' +  'RSDNA003';
            Pt4.RSD_Primary_Assigned_User_Id__c =UserInfo.getUserId();
            insert Pt4;
            
            Territory2 Pt5 = new Territory2();
            Pt5.Territory2TypeID = type.Id ;
            Pt5.Territory2ModelID = model.Id;
            Pt5.ParentTerritory2ID   =  Pt4.Id;
            Pt5.DeveloperName = 'RSD_NA_' +  'RSDNA004';
            Pt5.Name = 'RSD NA ' +  'RSDNA004';
            Pt5.RSD_Primary_Assigned_User_Id__c =UserInfo.getUserId();
            insert Pt5;
            
            Territory2 Pt6 = new Territory2();
            Pt6.Territory2TypeID = type.Id ;
            Pt6.Territory2ModelID = model.Id;
            Pt6.ParentTerritory2ID   =  Pt5.Id;
            Pt6.DeveloperName = 'RSD_NA_' +  'RSDNA005';
            Pt6.Name = 'RSD NA ' +  'RSDNA005';
            Pt6.RSD_Primary_Assigned_User_Id__c =UserInfo.getUserId();
            insert Pt6;
            
            Territory2 Pt7 = new Territory2();
            Pt7.Territory2TypeID = type.Id ;
            Pt7.Territory2ModelID = model.Id;
            Pt7.ParentTerritory2ID   =  Pt6.Id;
            Pt7.DeveloperName = 'RSD_NA_' +  'RSDNA006';
            Pt7.Name = 'RSD NA ' +  'RSDNA006';
            Pt7.RSD_Primary_Assigned_User_Id__c =UserInfo.getUserId();
            insert Pt7;
            
            Territory2 Pt8 = new Territory2();
            Pt8.Territory2TypeID = type.Id ;
            Pt8.Territory2ModelID = model.Id;
            Pt8.ParentTerritory2ID   =  Pt7.Id;
            Pt8.DeveloperName = 'RSD_NA_' +  'RSDNA007';
            Pt8.Name = 'RSD NA ' +  'RSDNA007';
            Pt8.RSD_Primary_Assigned_User_Id__c =UserInfo.getUserId();
            insert Pt8;
            
            Test.startTest();
            List<ObjectTerritory2Association> lstObjTerr=new List<ObjectTerritory2Association>();
            ObjectTerritory2Association objTerr=new ObjectTerritory2Association();
            objTerr.Territory2Id = terr[0].Id;
            objTerr.ObjectId =lstAccount[0].Id;
            objTerr.AssociationCause ='Territory2Manual';
            lstObjTerr.add(objTerr);
            
            ObjectTerritory2Association objTerr1=new ObjectTerritory2Association();
            objTerr1.ObjectId =lstAccount[0].Id;
            objTerr1.AssociationCause ='Territory2Manual';
            objTerr1.Territory2Id = Pt2.Id;
            lstObjTerr.add(objTerr1);
            
            ObjectTerritory2Association objTerr2=new ObjectTerritory2Association();
            objTerr2.ObjectId =lstAccount[0].Id;
            objTerr2.AssociationCause ='Territory2Manual';
            objTerr2.Territory2Id = Pt3.Id;
            lstObjTerr.add(objTerr2);
            
            ObjectTerritory2Association objTerr3=new ObjectTerritory2Association();
            objTerr3.ObjectId =lstAccount[0].Id;
            objTerr3.AssociationCause ='Territory2Manual';
            objTerr3.Territory2Id = Pt4.Id;
            lstObjTerr.add(objTerr3);
            
            ObjectTerritory2Association objTerr4=new ObjectTerritory2Association();
            objTerr4.ObjectId =lstAccount[0].Id;
            objTerr4.AssociationCause ='Territory2Manual';
            objTerr4.Territory2Id = Pt5.Id;
            lstObjTerr.add(objTerr4);
            
            ObjectTerritory2Association objTerr5=new ObjectTerritory2Association();
            objTerr5.ObjectId =lstAccount[0].Id;
            objTerr5.AssociationCause ='Territory2Manual';
            objTerr5.Territory2Id = Pt6.Id;
            lstObjTerr.add(objTerr5);
            
            insert lstObjTerr;
            
            List<UserTerritory2Association> lstUserTerr=new List<UserTerritory2Association>();
            UserTerritory2Association userTerr=new UserTerritory2Association();
            userTerr.Territory2Id =terr[0].Id;
            userTerr.UserId =UserInfo.getUserId();
            
            lstUserTerr.add(userTerr);
            
            UserTerritory2Association userTerr1=new UserTerritory2Association();
            userTerr1.UserId =UserInfo.getUserId();
            userTerr1.Territory2Id =Pt2.Id;
            lstUserTerr.add(userTerr1);
            
            UserTerritory2Association userTerr2=new UserTerritory2Association();
            userTerr2.UserId =UserInfo.getUserId();
            userTerr2.Territory2Id =Pt3.Id;
            lstUserTerr.add(userTerr2);
            
            UserTerritory2Association userTerr3=new UserTerritory2Association();
            userTerr3.UserId =UserInfo.getUserId();
            userTerr3.Territory2Id =Pt4.Id;
            lstUserTerr.add(userTerr3);
            
            UserTerritory2Association userTerr4=new UserTerritory2Association();
            userTerr4.UserId =UserInfo.getUserId();
            userTerr4.Territory2Id =Pt5.Id;
            lstUserTerr.add(userTerr4);
            
            UserTerritory2Association userTerr5=new UserTerritory2Association();
            userTerr5.UserId =UserInfo.getUserId();
            userTerr5.Territory2Id =Pt6.Id;
            lstUserTerr.add(userTerr5);
            
            
            insert lstUserTerr;
            
            RSDNA_LtngAssignedTerritories.assignedTerritories(lstAccount[0].Id);
            RSDNA_LtngAssignedTerritories.userAssignedTerritories(lstAccount[0].Id);
            RSDNA_LtngAssignedTerritories.deleteTerritory(objTerr.Id);
            RSDNA_LtngAssignedTerritories.deleteTerritory(objTerr.Id);
            Test.stopTest();
            }
    }
}