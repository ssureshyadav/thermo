/*
        Created By  : Venkatesh Kumar
        Email ID    : VenkateshKumar.Sakthivel@nttdata.com   
        Company     : NTTDATA
        Date        : 25 April,2017
        Description :
                    -After new Quote Line Items are loaded in the system, update its corresponding Opportunities products with Order No from the loaded Quote line items.
                       
        Test Class  :
    */
     
    global class RSDNA_UpdateProductfrQuoteBatch implements Database.Batchable<sObject> {              
       
        // Batch Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
            // Get the last run batch time from the custom setting 
            RSD_Batch_Settings__c batchSetting = RSD_Batch_Settings__c.getValues('UpdateOpptyProductOrderNumberBatch');
            DateTime getLastrundate = batchSetting.RSD_Last_Successful_Run_Date__c;         
            system.debug('The value of getLastrundate----------->'+ getLastrundate);
            
            return Database.getQueryLocator([SELECT RSD_Order_Number__c ,CurrencyIsoCode,RSD_Quantity__c,Quote__c,RSD_CMT_Level2_Code__c,RSD_CMT_Level3_Code__c,Quote__r.RSD_Opportunity__r.CurrencyIsoCode,Quote__r.RSD_Opportunity__c,LastModifiedDate,RSD_Unit_Price__c FROM RSD_Quote_Line_Item__c where LastModifiedDate >: getLastrundate ]);
        }   
        
        //Batch Execute method
        global void execute(Database.BatchableContext BC, List<RSD_Quote_Line_Item__c> scope) {
            system.debug('The value of scope------------->'+scope);
            
            // Value declarication
            Map<Id,RSD_Quote_Line_Item__c> getQuoteNoProdCodeMap = new Map<Id,RSD_Quote_Line_Item__c>();
            Set<ID> getMappedQuotesSET = new Set<ID>();
            List<OpportunityLineItem> lstProdUpdateLst =  new List<OpportunityLineItem>();  
    
            if(!scope.isEmpty()){
            for(RSD_Quote_Line_Item__c itrQuotelineItem : scope){
                if(itrQuotelineItem.RSD_CMT_Level2_Code__c != Null && itrQuotelineItem.RSD_CMT_Level3_Code__c != Null && itrQuotelineItem.RSD_Order_Number__c != Null){             
                getQuoteNoProdCodeMap.put(itrQuotelineItem.ID,itrQuotelineItem);        
                   }           
                }
            }           
            System.debug('The value of getQuoteNoProdCodeMap------>'+getQuoteNoProdCodeMap);

            // Updating the Order Number for Opportunity Line items based on the Quote # updated on Quote Line items     
            for(OpportunityLineItem oppProd : [select ID,RSD_Quote__c,RSD_Quote_Line_Item__c,ProductCode,opportunityID from OpportunityLineItem where RSD_Quote_Line_Item__c IN: getQuoteNoProdCodeMap.keyset()]){              
            if(oppProd.opportunityID == getQuoteNoProdCodeMap.get(oppProd.RSD_Quote_Line_Item__c).Quote__r.RSD_Opportunity__c){
                System.debug('The value of oppProd------>'+oppProd) ; 
                // get all the Quote line items which has mapped Opportunity Line item in the system.
                getMappedQuotesSET.add(oppProd.RSD_Quote_Line_Item__c);  
                // update the order number for the mapped opportunities 
                oppProd.RSD_Order_Number__c = getQuoteNoProdCodeMap.get(oppProd.RSD_Quote_Line_Item__c).RSD_Order_Number__c;
                lstProdUpdateLst.add(oppProd); 
            }           
            }
            System.debug('The value of lstProdUpdateLst------>'+lstProdUpdateLst) ;           
            // Find the Quotes which doesnt have the related Opportunity Line item
            System.debug('The value of lstProdUpdateLst ------>'+lstProdUpdateLst);              
   
            if(!lstProdUpdateLst.isEmpty()){
                    System.debug('The value of lstProdUpdateLst Update inside IF------>'+lstProdUpdateLst);
                    // DML statement                  
                    RSD_Batch_Settings__c UpdateBatch = RSD_Batch_Settings__c.getInstance('UpdateOpptyProductOrderNumberBatch');
                    UpdateBatch.RSD_Last_Successful_Run_Date__c = System.Now();
                    try{
                    Update lstProdUpdateLst;
                    Update UpdateBatch; 
                    }catch(dmlexception e){
                    System.debug('The following exception has occured ------>'+e);  
                    }
            }
            else{
                    System.debug('There are no records for update'); 
            }            
        }
     
        global void finish(Database.BatchableContext BC) {
        }
     }