/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 22 May,2017
    Requirement : W-000091:T-00122: Dev 
    Test Class  : 
    Last Updated By : Venkatesh Kumar Sakthivel
    
*/
global class RSDNA_UserTerritory2Batch implements Database.Batchable<sObject>, Database.Stateful{
    
      Set<Territory2> setUpdTrr = new Set<Territory2>();
      Public set<Account> setUpdateAcc = new set<Account>();
      Public Map<ID,Territory2> mapttUpdate = new Map<ID,Territory2> ();
      Public set<Contact> setUpdateCon = new set<Contact>();
      Public List<RSD_User_To_Territory__c> lstUpdUsrTerr=new List<RSD_User_To_Territory__c>();
      Public List<User> lstUserdel = new List<User>();
      Public List<User> lstUseradd = new List<User>();
     
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select Name,RSD_Action_Indicator__c,OwnerID,RSD_Error_Message__c,RSD_Extraction_Date__c,RSD_Invalid__c,RSD_Primary_External_Id__c,RSD_Processed_Date__c,RSD_Role__c,RSD_Source_System__c,RSD_Territory_Id__c,RSD_Territory_Number__c,RSD_Workday_Number__c from RSD_User_To_Territory__c where  RSD_Processed_Date__c = Null and RSD_Invalid__c = False order by RSD_Extraction_Date__c ASC,RSD_Action_Indicator__c ASC');
    }
    
    // Processing the scope   
    global void execute(Database.BatchableContext BC, List<RSD_User_To_Territory__c> scope){
        RSD_Organization_Specific_Settings__c orgSp= RSD_Organization_Specific_Settings__c.getInstance();
        String UserName;
        boolean checkWkno = false;
        Set<String> setCheck = new Set<String>();
        Set<String> setWrNotnull = new Set<String>();
        set<string> setDterritories = new set<string> ();            
        set<ID> setTrrIDGENL = new set<ID>();       
        Set<User> setUpdateUser = new Set<User>();        
        set<ID> chkUserID = new set<ID>();
        map<string,set<String>> mapTrrUserlist = new map<string,set<String>> ();
        map<String,String> mapTrrWrkDay = new map<String,String>();
        map<String,ID> mapWrkUserID = new map<String,ID>();
        map<ID,string> mapUserUpdate = new map<ID,string>();
        map<ID,String> mapdelupdate = new map<ID,String> ();
        map<String,User> mapWrkUser = new map<String,User>();
        map<String,ID> mapTrrInfo = new map<String,ID>();
        map<String,UserTerritory2Association> mapUsrTrrID = new map<String,UserTerritory2Association>();
        map<ID,ID> mapGENLupdate =new map<ID,ID>();
        map<String,Set<String>> mapSetTrrWrkDay = new map<String,set<String>>();

        for(RSD_User_To_Territory__c usrTrr: scope){
            System.debug('The current Job is processing --->'+usrTrr.RSD_Territory_Number__c);
            if(usrTrr.RSD_Action_Indicator__c == 'D'){                
                setDterritories.add(usrTrr.RSD_Workday_Number__c);
                if(!mapTrrUserlist.containskey(usrTrr.RSD_Workday_Number__c)){
                        set<string> setStr = new set<string>();
                        setStr.add(usrTrr.RSD_Territory_Number__c);
                        mapTrrUserlist.put(usrTrr.RSD_Workday_Number__c,setStr);            
                    }else{
                        set<string> setStr1 = new set<string>();
                        setStr1.addall(mapTrrUserlist.get(usrTrr.RSD_Workday_Number__c));
                        setStr1.add(usrTrr.RSD_Territory_Number__c);
                        mapTrrUserlist.put(usrTrr.RSD_Workday_Number__c,setStr1);       
                    }             
                }                
            
            if(usrTrr.RSD_Workday_Number__c != Null){
                setWrNotnull.add(usrTrr.RSD_Workday_Number__c); 
             }
                
            if(usrTrr.RSD_Workday_Number__c == '00000000'){
              checkWkno = True;
            }    
               
            if(usrTrr.RSD_Territory_Number__c != Null){
                mapTrrWrkDay.put('RSD NA '+usrTrr.RSD_Territory_Number__c,usrTrr.RSD_Workday_Number__c);           
            }
        }
        
        for(RSD_User_To_Territory__c usrTrr: scope){
            if(usrTrr.RSD_Action_Indicator__c == 'I' && setDterritories.contains(usrTrr.RSD_Workday_Number__c)){
                setCheck.add(usrTrr.RSD_Workday_Number__c);
            }           
        }
        
        for(User usr: [Select ID, RSD_Workday_Number__c,FirstName,LastName,RSD_Territory_number__c from user where RSD_Workday_Number__c IN: setWrNotnull]){
            mapWrkUserID.put(usr.RSD_Workday_Number__c,usr.ID); 
            mapWrkUser.put(usr.RSD_Workday_Number__c,usr);
        }
        
        if(checkWkno == True){
                mapWrkUserID.put('00000000',orgSp.RSD_NA_Default_Record_Owner_User_ID__c);
                for(User usr:[Select ID, RSD_Workday_Number__c,FirstName,LastName from user where ID =: orgSp.RSD_NA_Default_Record_Owner_User_ID__c]){
                    UserName = usr.FirstName+' '+ usr.LastName;
                }
        } 

        // Update Territory number in the user Object
        for(RSD_User_To_Territory__c usrTrr:scope){     
                        if(usrTrr.RSD_Action_Indicator__c == 'I'){
                                if(mapWrkUser.containskey(usrTrr.RSD_Workday_Number__c) && usrTrr.RSD_Territory_Number__c != Null  ){
                                        if(!setDterritories.contains(usrTrr.RSD_Workday_Number__c)){                                                    
                                                User usrUpdate = new User(id = mapWrkUser.get(usrTrr.RSD_Workday_Number__c).id); 
                                                Set<String> setGetExistingTrr = new Set<String>();
                                                if(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).RSD_Territory_number__c != Null){
                                                    
                                                     setGetExistingTrr.addAll(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).RSD_Territory_number__c.split(',')); 
                                                }
                                                if(!setGetExistingTrr.contains(usrTrr.RSD_Territory_Number__c)){    
                                                    if(!mapUserUpdate.containskey(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).id)){
                                                         String str= (mapWrkUser.get(usrTrr.RSD_Workday_Number__c).RSD_Territory_number__c != null? mapWrkUser.get(usrTrr.RSD_Workday_Number__c).RSD_Territory_number__c +',':'') +usrTrr.RSD_Territory_Number__c;                                  
                                                        mapUserUpdate.put(usrUpdate.ID,str);
                                                    }else{
                                                        string str= mapUserUpdate.get(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).ID)+','+usrTrr.RSD_Territory_Number__c ;
                                                        mapUserUpdate.put(usrUpdate.ID,str);
                                                    }
                                                }
                                        }else{
                                                Set<String> setTerrNames=new Set<String>();
                                                setTerrNames.addAll(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).RSD_Territory_number__c.split(','));            
                                                    for(string str: mapTrrUserlist.get(usrTrr.RSD_Workday_Number__c)){
                                                        if(setTerrNames.contains(str)){
                                                            setTerrNames.remove(str);                                    
                                                        }                               
                                                    }
                                                List<String> lst=new List<String>();
                                                lst.addAll(setTerrNames);   
                                                lst.add(usrTrr.RSD_Territory_Number__c);
                                            User usrUpdate = new User(id = mapWrkUser.get(usrTrr.RSD_Workday_Number__c).id);
                                            usrUpdate.RSD_Territory_number__c = String.join(lst,',');
                                            lstUseradd.add(usrUpdate);                                              
                                        }
                                }               
                        }else{
                            if(mapWrkUser.containskey(usrTrr.RSD_Workday_Number__c) && usrTrr.RSD_Territory_Number__c != Null && !setCheck.contains(usrTrr.RSD_Workday_Number__c) && mapWrkUser.get(usrTrr.RSD_Workday_Number__c).RSD_Territory_number__c != Null){
                                        if(!mapdelupdate.containskey(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).id)){
                                            Set<String> setTerrNames1=new Set<String>();
                                            setTerrNames1.addAll(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).RSD_Territory_number__c.split(',')); 
                                            string str;
                                                if(setTerrNames1.contains(usrTrr.RSD_Territory_Number__c)) {
                                                    setTerrNames1.remove(usrTrr.RSD_Territory_Number__c);
                                                }
                                            List<String> lst1=new List<String>();
                                            lst1.addAll(setTerrNames1);                    
                                                if(!lst1.isEmpty()){
                                                str = String.join(lst1,',');
                                                }else{                                      
                                                str = Null;                     
                                                }
                                            mapdelupdate.put(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).id, str);                                         
                                        }else{
                                            Set<String> setTerrNames2=new Set<String>();
                                                if(mapdelupdate.get(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).id) != Null){
                                                setTerrNames2.addAll(mapdelupdate.get(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).id).split(',')); 
                                                string str;
                                                    if(setTerrNames2.contains(usrTrr.RSD_Territory_Number__c)) {
                                                        setTerrNames2.remove(usrTrr.RSD_Territory_Number__c);
                                                    } 
                                                
                                                List<String> lst2=new List<String>();
                                                lst2.addAll(setTerrNames2);                    
                                                if(!lst2.isEmpty()){
                                                str = String.join(lst2,',');
                                                }else{
                                                str = Null;                     
                                                }
                                                mapdelupdate.put(mapWrkUser.get(usrTrr.RSD_Workday_Number__c).id, str);
                                            }
                                        }
                            }               
                        }
        }                   
        
         if(!mapUserUpdate.isEmpty()){
             for(id userID: mapUserUpdate.keyset()){
                    User usrUpdate = new User(id = userID);
                        usrUpdate.RSD_Territory_number__c = mapUserUpdate.get(userID);
                        lstUseradd.add(usrUpdate);               
             }           
         }  
         
          if(!mapdelupdate.isEmpty()){
             for(id userID: mapdelupdate.keyset()){
                    User usrUpdate = new User(id = userID);
                        usrUpdate.RSD_Territory_number__c = mapdelupdate.get(userID);
                        lstUserdel.add(usrUpdate);               
             }           
         }  
        
        for(territory2 trr : [select id,Name,RSD_Primary_Assigned_User_Id__c,RSD_Primary_Assigned_User__c From territory2 where Name IN: mapTrrWrkDay.KEYSET()]){
            mapTrrInfo.put(trr.Name,trr.ID);
        }
        
        for(UserTerritory2Association UsrTrr : [select RoleInTerritory2,Territory2Id,UserId FROM UserTerritory2Association where Territory2Id IN:mapTrrInfo.Values() and UserId IN: mapWrkUserID.Values()]){
            mapUsrTrrID.put(UsrTrr.Territory2Id+'-'+UsrTrr.UserId,UsrTrr);
        }        
        
        Map<String,List<ID>> mapObjTerr2Acc=new Map<String,List<ID>>();
    
        Set<ID>  setaddID = new Set<ID> ();        
        Set<ID>  setAccID = new set<ID> ();        
        Map<Id,UserTerritory2Association> mapUsrTerr2Assoc=new Map<Id,UserTerritory2Association>();            
        set<id> selDelUsrTrrID = new set<id>();

            for(RSD_User_To_Territory__c usrTrr: scope){
                 if(usrTrr.RSD_Action_Indicator__c == 'D') {                  
                     if(usrTrr.RSD_Territory_Number__c.substring(0,4) == 'GENL'){
                            setTrrIDGENL.add(mapTrrInfo.get('RSD NA '+usrTrr.RSD_Territory_Number__c));
                      }
                 }
                  
                 if(!mapWrkUserID.containskey(usrTrr.RSD_Workday_Number__c)|| usrTrr.RSD_Workday_Number__c == Null){
                        usrTrr.RSD_Error_Message__c = 'User with matching Workday Number Not Found';
                        usrTrr.RSD_Processed_Date__c = System.now();
                            if(usrTrr.RSD_Action_Indicator__c == 'D') {                 
                            usrTrr.RSD_Invalid__c = True;                           
                            }else{
                            usrTrr.RSD_Invalid__c = False;
                            }
                    lstUpdUsrTerr.add(usrTrr);
                    }else if(!mapTrrInfo.containskey('RSD NA '+usrTrr.RSD_Territory_Number__c) || usrTrr.RSD_Territory_Number__c == Null) {
                        usrTrr.RSD_Error_Message__c = 'Territory  Not Found';
                        usrTrr.RSD_Processed_Date__c = System.now();
                            if(usrTrr.RSD_Action_Indicator__c == 'D') {                 
                                    usrTrr.RSD_Invalid__c = True;                           
                                    }else{
                                    usrTrr.RSD_Invalid__c = False;
                                    }
                    lstUpdUsrTerr.add(usrTrr);                        
                    }else if(mapUsrTrrID.containskey(mapTrrInfo.get('RSD NA '+usrTrr.RSD_Territory_Number__c)+'-'+mapWrkUserID.get(usrTrr.RSD_Workday_Number__c))){
                            usrTrr.RSD_Invalid__c = False;
                            usrTrr.RSD_Processed_Date__c = System.now(); 
                            //Check
                            usrTrr.RSD_Territory_Id__c = mapUsrTrrID.get(mapTrrInfo.get('RSD NA '+usrTrr.RSD_Territory_Number__c)+'-'+mapWrkUserID.get(usrTrr.RSD_Workday_Number__c)).ID;
                                if(usrTrr.RSD_Action_Indicator__c == 'D') { 
                                    //Check
                                    selDelUsrTrrID.add(mapUsrTrrID.get(mapTrrInfo.get('RSD NA '+usrTrr.RSD_Territory_Number__c)+'-'+mapWrkUserID.get(usrTrr.RSD_Workday_Number__c)).ID); 
                                    usrTrr.RSD_Error_Message__c =  Null;                                   
                                }else{
                                        territory2 trr = new territory2(ID = mapTrrInfo.get('RSD NA '+usrTrr.RSD_Territory_Number__c));
                                        if(usrTrr.RSD_Workday_Number__c == '00000000'){
                                            trr.RSD_Primary_Assigned_User__c = UserName;
                                            trr.RSD_Primary_Assigned_User_Id__c = orgSp.RSD_NA_Default_Record_Owner_User_ID__c;
                                        }else{
                                            trr.RSD_Primary_Assigned_User__c = mapWrkUser.get(usrTrr.RSD_Workday_Number__c).FirstName +' '+mapWrkUser.get(usrTrr.RSD_Workday_Number__c).LastName;
                                            trr.RSD_Primary_Assigned_User_Id__c = mapWrkUser.get(usrTrr.RSD_Workday_Number__c).ID;
                                        }
                                        if(!mapttUpdate.containskey(trr.ID)){   
                                        setUpdTrr.add(trr);
                                        mapttUpdate.put(trr.ID,trr);
                                        }                                       
                                        usrTrr.RSD_Error_Message__c = 'User is aleady assigned to Territory';
                                        if(usrTrr.RSD_Territory_Number__c.substring(0,4) == 'GENL'){
                                        mapGENLupdate.put(mapTrrInfo.get('RSD NA '+usrTrr.RSD_Territory_Number__c),mapWrkUserID.get(usrTrr.RSD_Workday_Number__c));             
                                        }
                                }
                    lstUpdUsrTerr.add(usrTrr);           
                    }else{
                       territory2 trr = new territory2(ID = mapTrrInfo.get('RSD NA '+usrTrr.RSD_Territory_Number__c));
                        if(usrTrr.RSD_Action_Indicator__c == 'D') {
                            usrTrr.RSD_Invalid__c = False;
                            usrTrr.RSD_Error_Message__c = 'User is not assigned to Territory';
                            usrTrr.RSD_Processed_Date__c = System.now();    
                            usrTrr.RSD_Territory_Id__c = Null;
                        lstUpdUsrTerr.add(usrTrr);
                           
                        }else{
                            if(usrTrr.RSD_Workday_Number__c == '00000000'){
                                trr.RSD_Primary_Assigned_User__c = UserName;
                                trr.RSD_Primary_Assigned_User_Id__c = orgSp.RSD_NA_Default_Record_Owner_User_ID__c;
                            }else{
                                trr.RSD_Primary_Assigned_User__c = mapWrkUser.get(usrTrr.RSD_Workday_Number__c).FirstName +' '+mapWrkUser.get(usrTrr.RSD_Workday_Number__c).LastName;
                                trr.RSD_Primary_Assigned_User_Id__c = mapWrkUser.get(usrTrr.RSD_Workday_Number__c).ID;
                            }
                            //lstUpdTrr.add(trr); 
                            if(!mapttUpdate.containskey(trr.ID)){   
                                        setUpdTrr.add(trr);
                                        mapttUpdate.put(trr.ID,trr);
                                        }   
                            
                            UserTerritory2Association usrTrrAss = new UserTerritory2Association();
                            usrTrrAss.Territory2Id = mapTrrInfo.get('RSD NA '+usrTrr.RSD_Territory_Number__c);
                            usrTrrAss.RoleInTerritory2 = usrTrr.RSD_Role__c;
                            usrTrrAss.UserId = mapWrkUserID.get(usrTrr.RSD_Workday_Number__c);
                            mapUsrTerr2Assoc.put(usrTrr.ID,usrTrrAss);
                                if(usrTrr.RSD_Territory_Number__c.substring(0,4) == 'GENL'){
                                //Check
                                mapGENLupdate.put(mapTrrInfo.get('RSD NA '+usrTrr.RSD_Territory_Number__c),mapWrkUserID.get(usrTrr.RSD_Workday_Number__c));             
                                }
                        }
                    }
                }
                map<id,id> mapAccTrrInfoGet = new map<id,id>();
                map<id,id> mapAccTrrInfoGetD = new map<id,id>();
                system.debug('setTrrIDGENL----------------->'+setTrrIDGENL);
                system.debug('selDelUsrTrrID----------------->'+selDelUsrTrrID);

                if(!mapUsrTerr2Assoc.isEmpty()){
                    insert mapUsrTerr2Assoc.values();
                     Map<Id,List<String>> mapUsrtTerrId=new Map<Id,List<String>>();
                         for(Id UsrTerrID:mapUsrTerr2Assoc.keySet()){
                            RSD_User_To_Territory__c UsrTerr=new RSD_User_To_Territory__c(Id= UsrTerrID);
                            UsrTerr.RSD_Error_Message__c ='';
                            UsrTerr.RSD_Invalid__c =false;
                            UsrTerr.RSD_Processed_Date__c = DateTime.now();
                            UsrTerr.RSD_Territory_Id__c =mapUsrTerr2Assoc.get(UsrTerrID).Id;
                            lstUpdUsrTerr.add(UsrTerr);
                        }
                }     
                
                if(!selDelUsrTrrID.isEmpty()){
                    Delete [Select Id from UserTerritory2Association Where Id IN : selDelUsrTrrID]; 
                }

                set<id> accID = new set<id>();
                map<id,ObjectTerritory2Association> mapTrrObjAinfo = new map<id,ObjectTerritory2Association>();
                map<id,id> mapAccObjTrrInfoGet = new map<id,id>();
                List<ObjectTerritory2Association> lstObj = new list<ObjectTerritory2Association> ();
                map<id,String> mapAccPrimTrr = new map<id,String>();

                for(ObjectTerritory2Association obj : [SELECT Id,ObjectId,Territory2Id,Territory2.Name FROM ObjectTerritory2Association where (Territory2Id IN: mapGENLupdate.KEYSET() OR Territory2Id IN: setTrrIDGENL )]){
                    if(mapGENLupdate.containsKey(obj.Territory2Id) || setTrrIDGENL.contains(obj.Territory2Id))
                    {
                        //mapAccTrrInfoGet.put(obj.ObjectId,obj.Territory2Id);
                        accID.add(obj.ObjectId);
                        lstObj.add(obj);
                        //mapTrrObjAinfo.put(obj.ID,obj);                       
                    }
                }
                system.debug('accID---->'+accID);
                system.debug('lstObj---->'+lstObj);
                map<ID,List<contact>> mapAccContact = new map<ID,List<contact>>();
                Map<ID,List<Contact>> mapAccConInfo = new Map<ID,List<Contact>>();

                if(!accID.isEmpty()){
                    for(Account accUp :[select id,RSD_Territories__c from Account where ID IN: accID]){
                        mapAccPrimTrr.put(accUp.id,accUp.RSD_Territories__c);                   
                    }
                    
                    for(contact con: [SELECT AccountId,Id,OwnerID,Account.RSD_Territories__c FROM Contact where accountid IN: accID]){
                        if(!mapAccConInfo.containskey(con.AccountId)){
                            List<Contact> conUpdate = new List<Contact>();
                            conUpdate.add(con);
                            mapAccConInfo.put(con.AccountId,conUpdate);
                        }else{
                            List<Contact> conUpdatemap = mapAccConInfo.get(con.AccountId);
                            conUpdatemap.add(con);
                            mapAccConInfo.put(con.AccountId,conUpdatemap);
                        }                   
                    }
                }
                system.debug('mapAccPrimTrr---->'+mapAccPrimTrr);
                system.debug('mapAccConInfo---->'+mapAccConInfo);

                map<id,id> mapAccOwner = new map<id,id>();

                for(ObjectTerritory2Association obj:lstObj){
                    Set<String> setTerrNamemAcc=new Set<String>();
                    if(mapAccPrimTrr.containskey(obj.ObjectId) && mapAccPrimTrr.get(obj.ObjectId) != Null){
                        setTerrNamemAcc.addAll(mapAccPrimTrr.get(obj.ObjectId).split(','));              
                        if(setTerrNamemAcc.contains(obj.Territory2.Name)) {
                            Account acc=new Account(Id= obj.ObjectId);
                            if(mapGENLupdate.containsKey(obj.Territory2Id))
                            {
                                acc.OwnerID = mapGENLupdate.get(obj.Territory2Id);
                            }else{ //The territory is primary for the Account, but it is getting deleted
                                acc.OwnerID = orgSp.RSD_NA_Default_Record_Owner_User_ID__c ;
                            }
                            if(!mapAccOwner.containskey(acc.ID)){
                            setUpdateAcc.add(acc);
                            mapAccOwner.put(acc.ID ,acc.OwnerID);
                            }
                            if(mapAccConInfo.containskey(acc.ID )){
                                for(Contact con:mapAccConInfo.get(acc.ID)){
                                    con.OwnerID = mapAccOwner.get(con.AccountId);                        
                                    setUpdateCon.ADD(con);
                                }
                            }
                        }
                    }
                }         
        }

    global void finish(Database.BatchableContext BC){
     
            List<territory2> lstUpdTrr=new List<territory2>();
            if(!setUpdTrr.isEmpty())
            {
                lstUpdTrr.addall(setUpdTrr);         
                RSDNA_UserTerritory2BatchExt  b=new RSDNA_UserTerritory2BatchExt(lstUpdTrr,Null);
                Id batchId = Database.executeBatch(b,2000);
            }

            List<Account>  lstUpdateAcc = new List<Account> ();
              if(!setUpdateAcc.isEmpty())    {  
                  lstUpdateAcc.addall(setUpdateAcc);        
                  RSDNA_UserTerritory2BatchExt  b=new RSDNA_UserTerritory2BatchExt(lstUpdateAcc,Null);
                  Id batchId = Database.executeBatch(b,2000);
            }    
            
            if(!lstUpdUsrTerr.isEmpty())
            {
                System.debug('Batch ID-->'+bc.getJobId());
                RSDNA_UserTerritory2BatchExt  b=new RSDNA_UserTerritory2BatchExt(lstUpdUsrTerr,bc.getJobId());
                Id batchId = Database.executeBatch(b,2000);
            }
            
            List<contact>  lstUpdateCon = new List<contact> ();
            if(!setUpdateCon.isEmpty())    {
                lstUpdateCon.addall(setUpdateCon);    
                RSDNA_UserTerritory2BatchExt b=new RSDNA_UserTerritory2BatchExt(lstUpdateCon,Null);
                Id batchId = Database.executeBatch(b,2000);
            }
            
            if(!lstUserdel.isEmpty())    {
                map<ID,User> mapUserTrrDel = new map<ID,User> ();
                List<User> lstUsrTrrDel = new List<User>();
                    for(User usr:lstUserdel){
                        if(!mapUserTrrDel.containskey(usr.ID)){
                            mapUserTrrDel.put(usr.id,usr);
                        }else{
                            Set<String> setTerrNames1=new Set<String>();
                            setTerrNames1.addAll(mapUserTrrDel.get(usr.id).RSD_Territory_number__c.split(',')); 
                            string str;
                                if(!setTerrNames1.contains(usr.RSD_Territory_Number__c)) {
                                    setTerrNames1.remove(usr.RSD_Territory_Number__c);
                            }
                            List<String> lst1=new List<String>();
                            lst1.addAll(setTerrNames1);                    
                            if(!lst1.isEmpty()){
                            str = String.join(lst1,',');
                            }else{
                            str = Null;                     
                            }           
                            usr.RSD_Territory_number__c = str;
                            mapUserTrrDel.put(usr.id,usr);
                        }           
                    }       
                lstUsrTrrDel.addall(mapUserTrrDel.values());
                RSDNA_UserTerritory2BatchExt b=new RSDNA_UserTerritory2BatchExt(lstUsrTrrDel,Null);
                Id batchId = Database.executeBatch(b,2000);
            }
            
            if(!lstUseradd.isEmpty())    {
                map<ID,User> mapUserInsert = new map<ID,User> ();
                List<User> lstUsrUpdate = new List<User>();
                for(User usr:lstUseradd){
                    if(!mapUserInsert.containskey(usr.ID)){
                        mapUserInsert.put(usr.id,usr);
                    }else{
                        
                            Set<String> setTerrNames1=new Set<String>();
                            setTerrNames1.addAll(mapUserInsert.get(usr.id).RSD_Territory_number__c.split(',')); 
                            string str;
                                if(!setTerrNames1.contains(usr.RSD_Territory_Number__c)) {
                                    setTerrNames1.add(usr.RSD_Territory_Number__c);
                            }
                            List<String> lst1=new List<String>();
                            lst1.addAll(setTerrNames1);                    
                            if(!lst1.isEmpty()){
                            str = String.join(lst1,',');
                            }else{
                            str = Null;                     
                            }       
                        usr.RSD_Territory_number__c = str;
                        mapUserInsert.put(usr.id,usr);
                    }           
                }
                lstUsrUpdate.addall(mapUserInsert.Values());
                RSDNA_UserTerritory2BatchExt b=new RSDNA_UserTerritory2BatchExt(lstUsrUpdate,Null);
                Id batchId = Database.executeBatch(b,2000);
            }
        }
            
    
}