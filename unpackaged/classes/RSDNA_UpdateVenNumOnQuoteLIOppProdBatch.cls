/*
    Created By  : Ajay Kumar
    Email ID    : pendelavenkatabaji.ajaykumar@nttdata.com    
    Company     : NTTDATA
    Date        : 27 June,2017
    Requirement : W-000193:T-00386: Dev 
                  Create an apex batch job to validate Quote Line Item 'Vendor Number' field and update Quote Line Item and OpportunityProduct records.
                  Conditions: 
                    -Created the Last N Days
                    -RSD_Quote_Line_Item__c.Vendor__c IS NULL 
                    -RSD_Quote_Line_Item__c.RSD_Vendor_Number__c IS NOT NULL
    Test Class  : RSDNA_UpdateVenNumOnQuoteLIOppProdBchTst
    Last Updated By : 
*/

global class RSDNA_UpdateVenNumOnQuoteLIOppProdBatch implements Database.Batchable<sObject>, Database.Stateful{
          
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        RSD_Opportunity_Settings__c optySetg= RSD_Opportunity_Settings__c.getInstance();
        Integer daysToProcess = 7;
        if(optySetg.RSD_Quote_Vendors_Days_to_Validate__c != Null){
            daysToProcess = optySetg.RSD_Quote_Vendors_Days_to_Validate__c.intValue();
        }
       // System.debug('---In Start---'+daysToProcess);
        return Database.getQueryLocator('SELECT Id,RSD_Source_System__c,RSD_Vendor_Number__c,Vendor__c FROM RSD_Quote_Line_Item__c WHERE RSD_Vendor_Number__c != Null AND Vendor__c = Null AND CreatedDate = LAST_N_DAYS:' + daysToProcess);
    }
    
    // Processing the scope   
    global void execute(Database.BatchableContext BC, List<RSD_Quote_Line_Item__c> scope){
        
        //System.debug('--In Execute---'+scope.size());
        
        List<RSD_Quote_Line_Item__c> lstUpdateLeads = new List<RSD_Quote_Line_Item__c>();
        set<string> getCMFVendorlist = new set<string> ();
        set<string> getUSVendorlist = new set<string> ();
        Map<string,id> mapvendorID = new Map<string,id>();
        List<OpportunityLineItem> optyLineItems = new  List<OpportunityLineItem>();
       
        if(!scope.isEmpty()){
        for(RSD_Quote_Line_Item__c s:scope){
         if(s.RSD_Source_System__c == 'CMF'){
          getCMFVendorlist.add(s.RSD_Vendor_Number__c);
            //System.debug('--->In CMF--->');
        }
        if(s.RSD_Source_System__c == 'USMF'){
          getUSVendorlist.add(s.RSD_Vendor_Number__c);
           // System.debug('--->In USMF--->');
        } 
        }
        
        //Get all Vendords records
        if(!getCMFVendorlist.isEmpty() || !getUSVendorlist.isEmpty()){
        
            for(Account acc:[select Id,RSD_CA_Account_Number__c,RSD_US_Account_Number__c from Account where (RSD_CA_Account_Number__c IN: getCMFVendorlist or RSD_US_Account_Number__c IN: getUSVendorlist) and recordtypeID =: Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').getRecordTypeId()]){
            if(acc.RSD_CA_Account_Number__c != null){
            mapvendorID.put(acc.RSD_CA_Account_Number__c,acc.id);           
            }
            if(acc.RSD_US_Account_Number__c != null){
            mapvendorID.put(acc.RSD_US_Account_Number__c,acc.id);   
            }                   
            }
            
            }
        //System.debug('-->Vendor Info-->'+mapvendorID);
        
        List<ID> qliUpdatedIds = new List<ID>();
        List<RSD_Quote_Line_Item__c> qliUpdateList = new List<RSD_Quote_Line_Item__c>();
        Map<Id,Id> qliVendorUpdate = new Map<Id,Id>();
        for(RSD_Quote_Line_Item__c qli:scope){
        if(mapvendorID.get(qli.RSD_Vendor_Number__c) != Null){
           RSD_Quote_Line_Item__c qliUpdate = new RSD_Quote_Line_Item__c();
           qliUpdate.Id= qli.Id;
           qliUpdatedIds.add(qli.Id);
           qliUpdate.Vendor__c = mapvendorID.get(qli.RSD_Vendor_Number__c);
           qliUpdateList.add(qliUpdate);
           qliVendorUpdate.put(qli.Id,mapvendorID.get(qli.RSD_Vendor_Number__c));
        }
        }
            
            //System.debug('QLIVendorUpdate Map '+qliVendorUpdate);
            //System.debug('List values '+qliUpdateList);
            //System.debug('Ids '+qliUpdatedIds);
        
        if(!qliUpdateList.isEmpty()){
         Update qliUpdateList; //Update QuoteLineItem Vendor__c field
         //System.debug('--->Update QLI<---');         
        optyLineItems = [SELECT ID,RSD_Quote_Line_Item__c  from OpportunityLineItem Where RSD_Quote_Line_Item__c IN:qliUpdatedIds AND RSD_Vendor__c = null];
        //System.debug('Query: SELECT ID,RSD_Quote_Line_Item__c  from OpportunityLineItem Where RSD_Quote_Line_Item__c IN:'+qliUpdatedIds+' AND RSD_Vendor__c = null ');
        }
        
        //System.debug('OptyLineItems list '+optyLineItems);
        
        List<OpportunityLineItem> oliUpdate = new List<OpportunityLineItem>();
        
        if(!optyLineItems.isEmpty()){
        
        for(OpportunityLineItem oli: optyLineItems){
        
        OpportunityLineItem olirecord = new OpportunityLineItem();
        
        olirecord.Id=oli.Id;
        olirecord.RSD_Vendor__c = qliVendorUpdate.get(oli.RSD_Quote_Line_Item__c );
        
        oliUpdate.add(olirecord);
             
        
        }
            //System.debug('--->OPtyLI<---'+oliUpdate);   
        }
        
        if(!oliUpdate.isEmpty()){
            if(oliUpdate.size()-Limits.getDmlRows() >0){
              RSDNA_UserTerritory2BatchExt  b=new RSDNA_UserTerritory2BatchExt(oliUpdate,null);
            }else{
              Update oliUpdate; //Update OpportunityLineItems RSD_Vendor__c field.
             //System.debug('--->Update OPLI<---');   
            }
        }
        }
    }
    
     global void finish(Database.BatchableContext BC){
    }
    
    
}