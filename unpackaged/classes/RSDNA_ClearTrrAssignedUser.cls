/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 27 June,2017
    Requirement : W-000192:T-00385: Dev 
    Test Class  : 
    Last Updated By : Venkatesh Kumar Sakthivel
    
*/

public class RSDNA_ClearTrrAssignedUser{
    
    public void clearAssignedUserTrr(map<ID,UserTerritory2Association> mapOldTrr){
        MAP<ID, SET<ID>> mapUsrTrrID = new MAP<ID,SET<ID>>();
        List<territory2> lstUpdTrr = new List<territory2>();
        List<territory2> setUpdTrr = new List<territory2>();
        
        for(UserTerritory2Association usrTrr: mapOldTrr.Values()){
                if(mapUsrTrrID.ContainsKey(usrTrr.Territory2Id)){
                    Set<ID> setAdd = new Set<ID>();
                    setAdd.addall(mapUsrTrrID.get(usrTrr.Territory2Id));
                    setAdd.add(usrTrr.UserId);
                    mapUsrTrrID.put(usrTrr.Territory2Id ,setAdd);
                }else{
                Set<ID> setAdd1 = new Set<ID>();
                setAdd1.add(usrTrr.UserId);
                mapUsrTrrID.put(usrTrr.Territory2Id,setAdd1);
                }               
            
        }
        
        for(territory2 trr:[select id,Name,RSD_Primary_Assigned_User_Id__c,RSD_Primary_Assigned_User__c From territory2 where ID IN: mapUsrTrrID.KEYSET()]){
            System.debug('------>'+trr);
            if(mapUsrTrrID.containskey(trr.ID)){
                if((mapUsrTrrID.get(trr.ID)).contains(trr.RSD_Primary_Assigned_User_Id__c)){
                        trr.RSD_Primary_Assigned_User__c = NULL;
                        trr.RSD_Primary_Assigned_User_Id__c = NULL;
                        setUpdTrr.ADD(trr);                     
                    }                   
                }               
            }
            System.debug('------>'+setUpdTrr);
            if(!setUpdTrr.isEmpty()){
                lstUpdTrr.addall(setUpdTrr);                
            }
            System.debug('------>'+lstUpdTrr);
            if(!lstUpdTrr.isEmpty()){
            update lstUpdTrr;
        }
    }

}