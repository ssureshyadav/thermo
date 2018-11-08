/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 02 May,2017
    Requirement : W-000089:T-00116: Dev - Create Apex batch job to process Org Hierarchy records from custom object
    Description : This Batch runs on a daily basis and gets the records from the custom object RSD_Org_To_Territory__c and inserts it into the standard Object Territory2.
    Test Class  : 
    Last Updated By : Venkatesh Kumar Sakthivel
    
*/

global class RSDNA_InsertTerritory2BatchV2 implements Database.Batchable<sObject>, Database.Stateful{
    List<RSD_Org_To_Territory__c> scope = new List<RSD_Org_To_Territory__c>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('Select ID,RSD_Action_Indicator__c,RSD_Error_Message__c,RSD_Level__c,RSD_Parent_Territory_Number__c,RSD_Primary_External_Id__c,RSD_Processed_Date__c,RSD_Source_System__c,RSD_Territory_Id__c,RSD_Territory_Number__c From RSD_Org_To_Territory__c where  RSD_Processed_Date__c = Null  and  RSD_Invalid__c = False order by RSD_Extraction_Date__c ASC ,RSD_Level__c DESC ');
    }
    
    global void execute(Database.BatchableContext BC, List<RSD_Org_To_Territory__c> scopeItg){      
            for(RSD_Org_To_Territory__c getScope:scopeItg){
            scope.add(getScope);
            }
      }
      
     global void finish(Database.BatchableContext BC){
         map<string,RSD_Org_To_Territory__c> maptrrOrgTrrInfo = new map<string,RSD_Org_To_Territory__c>();
         map<string,RSD_Org_To_Territory__c> maptrrOrgTrrInfoD = new map<string,RSD_Org_To_Territory__c>();
         map<string,RSD_Org_To_Territory__c> maptrrNoParent = new map<string,RSD_Org_To_Territory__c>();
         Set<String> setParentTrrInfo = new Set<String>();
         RSD_Territory_Settings__c TS =     RSD_Territory_Settings__c.getInstance();
         map<String,Territory2> mapTrrInfoInstbel5 = new map<String,Territory2>();
         map<String,Territory2> mapTrrInfoInst5 = new map<String,Territory2>();
         map<String,Territory2> mapTrrInfoDelete = new map<String,Territory2>();
         map<String,Territory2> mapTrrInfoParent = new map<String,Territory2>();
         map<String,List<UserTerritory2Association>> mapTrrUsrTrrDelete = new map<String,List<UserTerritory2Association>>();
         map<String,List<ObjectTerritory2Association>> mapTrrObjTrrDelete = new map<String,List<ObjectTerritory2Association>>();
         List<Territory2> lstDeleteTerritory2 = new  List<Territory2>();
         map<string,string> mapParentChildTrr = new map<string,string>();
         set<string> setLevel5parentInsert = new set<string>();
         
         for(RSD_Org_To_Territory__c orgtrr: scope){
                if(orgtrr.RSD_Action_Indicator__c == 'I'){     
                     if(orgtrr.RSD_Parent_Territory_Number__c != Null){
                     mapParentChildTrr.put('RSD NA '+orgtrr.RSD_Territory_Number__c,'RSD NA '+orgtrr.RSD_Parent_Territory_Number__c);
                     setParentTrrInfo.add('RSD NA '+orgtrr.RSD_Parent_Territory_Number__c);
                     maptrrOrgTrrInfo.put('RSD NA '+orgtrr.RSD_Territory_Number__c,orgtrr);
                        if(orgTrr.RSD_Level__c == 5){
                            setLevel5parentInsert.add('RSD NA '+orgtrr.RSD_Parent_Territory_Number__c);
                        }
                    }else{
                            maptrrNoParent.put('RSD NA '+orgtrr.RSD_Territory_Number__c,orgtrr);
                    }                    
                }else{                  
                    maptrrOrgTrrInfoD.put('RSD NA '+orgtrr.RSD_Territory_Number__c,orgtrr);
                    if(orgtrr.RSD_Parent_Territory_Number__c != Null){
                    setParentTrrInfo.add('RSD NA '+orgtrr.RSD_Parent_Territory_Number__c);  
                    }
                }
         }
         
        for(territory2 trr:[select iD,Name From Territory2 where (Name IN: maptrrOrgTrrInfo.keyset() OR Name IN: maptrrNoParent.keyset() OR Name IN:maptrrOrgTrrInfoD.keyset() OR Name IN:setParentTrrInfo) and Territory2ModelID =: TS.RSD_Territory_Model__c]){
            //Existing Territory ID
            if(maptrrOrgTrrInfo.containskey(trr.Name)){
                mapTrrInfoInstbel5.put(trr.Name,trr);             
            }
            //Delete Territory ID
            if(maptrrOrgTrrInfoD.containskey(trr.Name)){
                mapTrrInfoDelete.put(trr.Name,trr);               
            }
            //Parent Territory ID
            if(setParentTrrInfo.contains(trr.Name)){
                mapTrrInfoParent.put(trr.Name,trr);               
            }       
        } 
         
        //W-000194-T-00387 : Dev - Delete Territory if Action_Ind = 'D'
        if(TS.RSD_NA_Delete_Inactive_Territories__c  == True && !mapTrrInfoDelete.isEmpty()){           
            
            for(UserTerritory2Association usrTrr:[select ID,UserID,Territory2.Name from UserTerritory2Association where Territory2.Name IN: mapTrrInfoDelete.keyset()]){
                if(!mapTrrUsrTrrDelete.containskey(usrTrr.Territory2.Name)){
                    mapTrrUsrTrrDelete.put(usrTrr.Territory2.Name, new List<UserTerritory2Association> {usrTrr});
                    }else{
                    mapTrrUsrTrrDelete.get(usrTrr.Territory2.Name).add(usrTrr);
                    }
            }
            
            for(ObjectTerritory2Association objTrr:[SELECT Id,ObjectId,SobjectType,Territory2Id,Territory2.Name FROM ObjectTerritory2Association where Territory2.Name IN: mapTrrInfoDelete.keyset()]){
                    if(!mapTrrObjTrrDelete.containskey(objTrr.Territory2.Name)){
                    mapTrrObjTrrDelete.put(objTrr.Territory2.Name, new List<ObjectTerritory2Association> {objTrr});
                    }else{
                    mapTrrObjTrrDelete.get(objTrr.Territory2.Name).add(objTrr);
                    }
            }

             for(string trrD: mapTrrInfoDelete.keyset()){
                 if(mapTrrUsrTrrDelete.get(trrD) == Null &&  mapTrrObjTrrDelete.get(trrD) == Null ){
                    lstDeleteTerritory2.add(mapTrrInfoDelete.get(trrD)); 
                 }   
            }
        }
        
        integer count = 0;
        
        if(!lstDeleteTerritory2.isEmpty()){
             try{      
             database.DeleteResult[] ds =  Database.Delete(lstDeleteTerritory2,false);
                for(database.DeleteResult d : ds){
                    if(d.issuccess()){
                        count++;
                        }    
                }
            }catch(exception e){
                system.debug('Delete failed---->'+ e.getmessage());
            }
        }
        
        List<RSD_Org_To_Territory__c> lstUpdateOrgTrr = new List<RSD_Org_To_Territory__c>();
        set<string> setPTrrInsertedlevel5 = new set<string>();
        map<String,territory2> mapTrrInsert = new map<String,territory2>();
        set<string> setChildParentMapped = new set<string>();
        //lstUpdateOrgTrr.add(orgTrr);
        
        for(RSD_Org_To_Territory__c orgTrr: Scope){
            if(orgTrr.RSD_Action_Indicator__c == 'I'){
                if(maptrrNoParent.containskey('RSD NA '+orgtrr.RSD_Territory_Number__c)){
                        orgTrr.RSD_Invalid__C = True;
                        orgTrr.RSD_Error_Message__c = 'Parent Territory is NULL';
                        orgTrr.RSD_Processed_Date__c = System.Now();
                        if(mapTrrInfoInstbel5.containskey('RSD NA ' +orgTrr.RSD_Territory_Number__c)){ //If the territory is already existing in the system, but the parent terriotry is Null
                        orgTrr.RSD_Territory_Id__c  =  mapTrrInfoInstbel5.get('RSD NA ' +orgTrr.RSD_Territory_Number__c).ID;
                        }                       
                }
                if(orgTrr.RSD_Level__c < 5){
                    if(!mapTrrInfoParent.containskey('RSD NA ' +orgTrr.RSD_Parent_Territory_Number__c) && !mapParentChildTrr.containskey('RSD NA ' +orgTrr.RSD_Parent_Territory_Number__c) && !maptrrNoParent.containskey('RSD NA '+orgtrr.RSD_Territory_Number__c)){
                            orgTrr.RSD_Invalid__C = True;
                            orgTrr.RSD_Error_Message__c = 'Parent Territory Not Found';
                            orgTrr.RSD_Processed_Date__c = System.Now();
                            if(mapTrrInfoInstbel5.containskey('RSD NA ' +orgTrr.RSD_Territory_Number__c)){ //If the territory is already existing in the system, but the parent terriotry is Null
                            orgTrr.RSD_Territory_Id__c  =  mapTrrInfoInstbel5.get('RSD NA ' +orgTrr.RSD_Territory_Number__c).ID;
                            }
                    }
                }else{
                    if(!mapTrrInfoParent.containskey(orgTrr.RSD_Parent_Territory_Number__c) && !mapTrrInfoInstbel5.containskey('RSD NA '+orgTrr.RSD_Territory_Number__c)){
                         if(!setPTrrInsertedlevel5.contains(orgTrr.RSD_Parent_Territory_Number__c)){
                                        Territory2 Pt2 = new Territory2();
                                        Pt2.Territory2TypeID = TS.RSD_Territory_Type__c ;
                                        Pt2.Territory2ModelID = TS.RSD_Territory_Model__c;
                                        Pt2.ParentTerritory2ID   =  TS.RSD_NA_Top_Level_Territory__c;
                                        Pt2.DeveloperName = 'RSD_NA_' +  orgTrr.RSD_Parent_Territory_Number__c;
                                        Pt2.Name = 'RSD NA ' +  orgTrr.RSD_Parent_Territory_Number__c;                            
                                        setPTrrInsertedlevel5 .add(orgTrr.RSD_Parent_Territory_Number__c);
                                        mapTrrInsert.put( 'RSD NA '+orgTrr.RSD_Parent_Territory_Number__c,Pt2);
                                        
                                        orgTrr.RSD_Invalid__C = False;
                                        orgTrr.RSD_Processed_Date__c = System.Now();                                    
                        }
                    }
                }
                
                if(mapTrrInfoParent.containskey('RSD NA ' +orgTrr.RSD_Parent_Territory_Number__c) ){
                    if(mapTrrInfoInstbel5.containskey('RSD NA '+orgTrr.RSD_Territory_Number__c)){
                            orgTrr.RSD_Territory_Id__c = mapTrrInfoInstbel5.get('RSD NA '+orgTrr.RSD_Territory_Number__c).id ;
                            orgTrr.RSD_Invalid__C = False;
                            orgTrr.RSD_Processed_Date__c = System.Now();
                            orgTrr.RSD_Error_Message__c = 'Territory already Existis with the same Parent';                         
                    }else{
                            Territory2 t2 = new Territory2();
                            t2.Territory2TypeID = TS.RSD_Territory_Type__c ;
                            t2.Territory2ModelID = TS.RSD_Territory_Model__c;
                            t2.DeveloperName = 'RSD_NA_'+ orgTrr.RSD_Territory_Number__c;
                            t2.Name = 'RSD NA '+orgTrr.RSD_Territory_Number__c;
                            if(mapTrrInfoParent.get('RSD NA ' +orgTrr.RSD_Parent_Territory_Number__c).ID != Null){
                                t2.ParentTerritory2ID = mapTrrInfoParent.get('RSD NA ' +orgTrr.RSD_Parent_Territory_Number__c).ID ;
                            }
                            mapTrrInsert.put( 'RSD NA '+orgTrr.RSD_Territory_Number__c,t2);
                            setChildParentMapped.add('RSD NA '+orgTrr.RSD_Territory_Number__c);
                    }                   
                }
                
                if(maptrrOrgTrrInfo.containskey('RSD NA '+orgTrr.RSD_Territory_Number__c) && !mapTrrInsert.containskey( 'RSD NA '+orgTrr.RSD_Territory_Number__c) && !mapTrrInfoInstbel5.containskey('RSD NA '+orgTrr.RSD_Territory_Number__c) &&  (mapParentChildTrr.containskey('RSD NA ' +orgTrr.RSD_Parent_Territory_Number__c) || setLevel5parentInsert.contains('RSD NA ' +orgTrr.RSD_Parent_Territory_Number__c))){
                        Territory2 t2 = new Territory2();
                        t2.Territory2TypeID = TS.RSD_Territory_Type__c ;
                        t2.Territory2ModelID = TS.RSD_Territory_Model__c;
                        t2.DeveloperName = 'RSD_NA_'+ orgTrr.RSD_Territory_Number__c;
                        t2.Name = 'RSD NA '+orgTrr.RSD_Territory_Number__c;
                        mapTrrInsert.put( 'RSD NA '+orgTrr.RSD_Territory_Number__c,t2);
                }           
            }else{
                if(maptrrOrgTrrInfoD.containskey( 'RSD NA '+orgTrr.RSD_Territory_Number__c)){
                    if(mapTrrInfoDelete.containskey('RSD NA '+orgTrr.RSD_Territory_Number__c)){ 
                        if(mapTrrUsrTrrDelete.containskey('RSD NA '+orgTrr.RSD_Territory_Number__c) ||  mapTrrObjTrrDelete.containskey('RSD NA '+orgTrr.RSD_Territory_Number__c) ){
                             orgTrr.RSD_Invalid__c = False;
                            orgTrr.RSD_Processed_Date__c = system.now();
                            orgTrr.RSD_Territory_Id__c  =  mapTrrInfoDelete.get('RSD NA '+orgTrr.RSD_Territory_Number__c).ID;
                            orgTrr.RSD_Error_Message__c = 'Territory cannot be deleted as there are active UserTerritory and Account Territory Combinations';    
                        }else{
                            orgTrr.RSD_Invalid__c = False;
                            orgTrr.RSD_Processed_Date__c = system.now();
                            orgTrr.RSD_Territory_Id__c  =  mapTrrInfoDelete.get('RSD NA '+orgTrr.RSD_Territory_Number__c).ID;  
                        }
                    }else{
                            orgTrr.RSD_Invalid__c = False;
                            orgTrr.RSD_Processed_Date__c = system.now();                      
                            orgTrr.RSD_Error_Message__c = 'Child Territory Not Found';
                    }
                }                
            }
        lstUpdateOrgTrr.add(orgTrr);        
        }
     system.debug('mapTrrInsert--->'+mapTrrInsert);   
        if(!mapTrrInsert.isEmpty()){
            try{      
                     database.saveresult[] ds =  Database.insert(mapTrrInsert.Values(),false);
                        for(database.SaveResult d : ds){
                            if(d.issuccess()){
                                count++;
                                }    
                        }
                    }catch(exception e){
                        system.debug('insert failed--->'+e.getmessage());
                    }
        }
    
    map<string,Territory2> mapInsertedTrr = new map<string,Territory2>();
    List<territory2> lstTrrUpdate = new List<territory2>();
    List<RSD_Org_To_Territory__c> lstOrgTrrUpdate2 = new List<RSD_Org_To_Territory__c>();
    
    for(Territory2 trr: [Select ID,Name,ParentTerritory2id From Territory2 where Name IN:mapTrrInsert.keyset() and Territory2ModelID =:  TS.RSD_Territory_Model__c ]){
                mapInsertedTrr.put(trr.Name,trr);     
    }

    // Mapping Parent with Child Territory
    for(string newTrrPatMap: maptrrOrgTrrInfo.keyset()){
        if(!mapTrrInfoInstbel5.containskey(newTrrPatMap) && !setPTrrInsertedlevel5.contains(newTrrPatMap) && mapInsertedTrr.containskey(newTrrPatMap) ){
            
            if(!setChildParentMapped.contains(newTrrPatMap)){
            territory2 trr = new territory2(id = mapInsertedTrr.get(newTrrPatMap).id );
            system.debug('newTrrPatMap--->'+newTrrPatMap); 
            system.debug('mapParentChildTrr.get(newTrrPatMap)--->'+mapParentChildTrr.get(newTrrPatMap)); 
                if(mapInsertedTrr.get(mapParentChildTrr.get(newTrrPatMap)) != Null){
                trr.ParentTerritory2id = mapInsertedTrr.get(mapParentChildTrr.get(newTrrPatMap)).id;
                }
            lstTrrUpdate.add(trr);
            }
            
            system.debug('maptrrOrgTrrInfo.get(newTrrPatMap).id--->'+maptrrOrgTrrInfo.get(newTrrPatMap).id); 
            RSD_Org_To_Territory__c orgTrr = new RSD_Org_To_Territory__c(id=maptrrOrgTrrInfo.get(newTrrPatMap).id);         
            orgTrr.RSD_Invalid__C = False;
            orgTrr.RSD_Processed_Date__c = System.Now(); 
                if(mapInsertedTrr.get(newTrrPatMap).ID != Null){
                orgTrr.RSD_Territory_Id__c  =  mapInsertedTrr.get(newTrrPatMap).ID;
                }           
            lstOrgTrrUpdate2.add(orgTrr);
            }
        }       
    
    if(!lstTrrUpdate.isEmpty()){
    update lstTrrUpdate;
    }

     Database.executeBatch(new RSDNA_InsertTerritory2BatchExt2 (lstUpdateOrgTrr));
     Database.executeBatch(new RSDNA_InsertTerritory2BatchExt2 (lstOrgTrrUpdate2));
     }
}