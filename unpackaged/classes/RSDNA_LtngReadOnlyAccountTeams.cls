/*
    Created By  : Suresh Sanneboina
    Email ID    : 
    Company     : NTTDATA
    Date        : 12 June,2017
    Requirement : W-000180:
                    T-00353: Dev - Display 'Assigned Territories' list
                    T-00354: Dev - Display 'Users in Assigned Territories' list
    Test Class  : RSDNA_AddUpdateVendorTest
    Last Updated By : 
    
*/
public class RSDNA_LtngReadOnlyAccountTeams
{
    @auraEnabled
    public static Boolean checkProfileAccess()
    {
        Set<String> setUserNames=new Set<String> {'RSD NA Sales User','RSD NA Manager-IDIR'};
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        if(!setUserNames.contains(profileName))
        {
            return false;
        }else{
            return true;
        }
    }
    @auraEnabled
    public static List<AccountTeamMember> accountTeams(Id recordId)
    {
        Set<String> setUserNames=new Set<String> {'RSD NA Sales User','RSD NA Manager-IDIR'};
        String profileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
        if(!setUserNames.contains(profileName))
        {
            return null;
        }else{
            return [SELECT 
                        AccountId,TeamMemberRole,User.Name 
                    FROM 
                        AccountTeamMember 
                    WHERE AccountId =: recordId];
        }
        
    }
    
}