/*
    Created By  : Suresh Sanneboina
    Email ID    : 
    Company     : NTTDATA
    Date        : 12 June,2017
    Requirement : W-000180:
                    T-00353: Dev - Display 'Assigned Territories' list
                    T-00354: Dev - Display 'Users in Assigned Territories' list
    Test Class  : RSDNA_AssignedTerritoriesTest
    Last Updated By : 
    
*/
public class RSDNA_LtngAssignedTerritories
{
    @auraEnabled
    public static boolean deleteTerritory(Id recordId)
    {
        try{
        Delete [SELECT 
                    Id 
                FROM
                     ObjectTerritory2Association 
                WHERE 
                    Id =: recordId];
        }catch(Exception e)
        {
            return false;    
        }
        return true;
    }
    @auraEnabled
    public static List<ObjectTerritory2Association> assignedTerritories(Id recordId)
    {
        return [SELECT 
                    Id,ObjectId,Territory2Id,Territory2.Name,Territory2.ParentTerritory2Id,Territory2.Territory2ModelId,Territory2.Territory2Model.Name,Territory2.Territory2TypeId,LastModifiedDate 
                FROM 
                    ObjectTerritory2Association 
                WHERE 
                    ObjectId =: recordId
                ORDER BY 
                    Territory2.Name ASC];
    }
    
    @auraEnabled
    public static List<UserTerritory> userAssignedTerritories(Id recordId)
    {
        List<UserTerritory> lstUserTerr=new List<UserTerritory>();
        Map<Id,Id> mapTerrUserIds=new Map<Id,Id>(); 
        Set<String> setTerrName=new Set<String>();
        Set<Id> topTerritories=new Set<Id>();
        Map<Id,ObjectTerritory2Association> mapTerr=new Map<Id,ObjectTerritory2Association>();
        Account acct=[Select Id,RSD_Territories__c FROM Account Where Id = : recordId];
        if(acct.RSD_Territories__c != null)
        {
            for(String accTerr:acct.RSD_Territories__c.split(','))
            {
                setTerrName.add(accTerr);
            }
        }
        
        for(ObjectTerritory2Association objTerr:[SELECT 
                    Id,ObjectId,
                    Territory2Id,Territory2.Name,Territory2.RSD_Primary_Assigned_User_Id__c,
                    Territory2.ParentTerritory2Id,Territory2.ParentTerritory2.Name,Territory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c,
                    Territory2.ParentTerritory2.ParentTerritory2Id,Territory2.ParentTerritory2.ParentTerritory2.Name,Territory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c,
                    Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id,Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c,
                    Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id,Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name,Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c,
                    Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id,
                    Territory2.Territory2ModelId,Territory2.Territory2Model.Name,Territory2.Territory2TypeId,LastModifiedDate 
                FROM 
                    ObjectTerritory2Association 
                WHERE 
                    ObjectId =: recordId
                ORDER BY Territory2.Name ASC])
        {
            mapTerr.put(objTerr.Territory2Id,objTerr);
            if(objTerr.Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id != null)
            {
                topTerritories.add(objTerr.Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id);
            }
            
            if(objTerr.Territory2.RSD_Primary_Assigned_User_Id__c != null)
            {
                mapTerrUserIds.put(objTerr.Territory2Id,objTerr.Territory2.RSD_Primary_Assigned_User_Id__c);
            }
            
            if(objTerr.Territory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c != null)
            {
                mapTerrUserIds.put(objTerr.Territory2.ParentTerritory2Id,objTerr.Territory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c);
            }
            
            if(objTerr.Territory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c != null)
            {
                mapTerrUserIds.put(objTerr.Territory2.ParentTerritory2.ParentTerritory2Id,objTerr.Territory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c);
            }
            
            if(objTerr.Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c != null)
            {
                mapTerrUserIds.put(objTerr.Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id,objTerr.Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c);
            }
            
            if(objTerr.Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c != null)
            {
                mapTerrUserIds.put(objTerr.Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id,objTerr.Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c);
            }
        }
        
        Map<Id,Territory2> mapTopTerritory;
        if(!topTerritories.isEmpty())
        {
            mapTopTerritory =new map<Id,Territory2>([SELECT Name,RSD_Primary_Assigned_User_Id__c FROM Territory2]);
            for(Territory2 terr:mapTopTerritory.values())
            {
                if(terr.RSD_Primary_Assigned_User_Id__c != null)
                {
                    mapTerrUserIds.put(terr.Id,terr.RSD_Primary_Assigned_User_Id__c);
                }
            }
        }
        
        Map<Id,User> mapUser;
        if(!mapTerrUserIds.isEmpty())
        {
            mapUser=new Map<Id,User>([Select Id,Name from User WHERE Id IN : mapTerrUserIds.values()]);
        }
        
       
        for(UserTerritory2Association UserTerr:[SELECT 
                                                    Id,RoleInTerritory2,Territory2Id,UserId,User.Name,User.Email 
                                                FROM 
                                                    UserTerritory2Association 
                                                WHERE 
                                                    Territory2Id IN : mapTerr.keySet() 
                                                Order By 
                                                    User.Name ASC])
        {
            UserTerritory uTerr=new UserTerritory();
            uTerr.userName = UserTerr.User.Name;
            uTerr.userId = UserTerr.UserId;
            uTerr.email = UserTerr.User.Email;
            uTerr.role = UserTerr.RoleInTerritory2;
            uTerr.territory = mapTerr.get(UserTerr.Territory2Id).Territory2.Name;
            if(setTerrName.contains(uTerr.territory)&& UserTerr.UserId == mapTerr.get(UserTerr.Territory2Id).Territory2.RSD_Primary_Assigned_User_Id__c)
            {
                uTerr.primary =true;
            }
            uTerr.territoryId = UserTerr.Territory2Id;
            uTerr.territoryModel = mapTerr.get(UserTerr.Territory2Id).Territory2.Territory2Model.Name;
            uTerr.territoryModelId =mapTerr.get(UserTerr.Territory2Id).Territory2.Territory2ModelId;
            
            uTerr.areaDirector =mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.Name;
            if(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c != null){
                uTerr.areaDirectorName =mapUser.get(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c).Name;
            }
            
            uTerr.parent3 =mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.Name;
            if(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c != null){
                uTerr.parent3Name =mapUser.get(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c).Name;
            }
            
            uTerr.parent4 =mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
            if(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c != null){
                uTerr.parent4Name =mapUser.get(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c).Name;
            }
            
            uTerr.parent5 =mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.Name;
            if(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c != null){
                uTerr.parent5Name =mapUser.get(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.RSD_Primary_Assigned_User_Id__c).Name;
            }
            
            if(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id != null)
            {
                uTerr.parent6=mapTopTerritory.get(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id).Name;
                if(mapTopTerritory.get(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id).RSD_Primary_Assigned_User_Id__c != null){
                    uTerr.parent6Name =mapUser.get(mapTopTerritory.get(mapTerr.get(UserTerr.Territory2Id).Territory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2.ParentTerritory2Id).RSD_Primary_Assigned_User_Id__c).Name;
                }
            }
            
            lstUserTerr.add(uTerr);
        }

        return lstUserTerr;
    }
    
    public Class UserTerritory
    {
        @auraEnabled public String userName;
        @auraEnabled public String userId;
        @auraEnabled public String email;
        @auraEnabled public Boolean primary;
        @auraEnabled public String role;
        @auraEnabled public String territory;
        @auraEnabled public String territoryId;
        @auraEnabled public String territoryModel;
        @auraEnabled public String territoryModelId;
        @auraEnabled public String areaDirector;
        @auraEnabled public String areaDirectorName;
        @auraEnabled public String parent3;
        @auraEnabled public String parent3Name;
        @auraEnabled public String parent4;
        @auraEnabled public String parent4Name;
        @auraEnabled public String parent5;
        @auraEnabled public String parent5Name;
        @auraEnabled public String parent6;
        @auraEnabled public String parent6Name;
        
    }
    
    
}