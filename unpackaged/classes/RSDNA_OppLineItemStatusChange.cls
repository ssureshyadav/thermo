/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 02 May,2017
    Requirement : W-000063 : RSDNA-0029: Select Opportunity Line Items as Active, 
                  W-000077:T-00289: RSDNA-0043: Opportunity Gross Margin based on Opportunity Products
    Description : 
                W-000063 : RSDNA-0029:
                -- During insert on Opportunity Product
                When Active flag is unchecked: Set RSD_Original_Sales_Price__c = UnitPrice and Set UnitPrice = 0
                When Active flag is checked: Set UnitPrice = RSD_Original_Sales_Price__c 

                -- During Update on Opportunity Product
                When Active flag is unchecked: Set RSD_Original_Sales_Price__c = UnitPrice and Set UnitPrice = 0
                When Active flag is checked: The standard salesforce functionality on Amount(Opportunity) takes care of the update from Opportunity Product Unit Price.
                
                W-000077:T-00289: RSDNA-0043:
                --During Insert
                When Active flag is unchecked: Set RSD_Original_Gross_Profit_Pct__c = RSD_Gross_Profit_Pct__c and RSD_Gross_Profit_Pct__c = 0.0
                RSD_Original_Unit_Cost__c = 0.0,RSD_Original_List_Price__c =0.0
                
                
                --During Update
                 When Active flag is unchecked: Set RSD_Original_Gross_Profit_Pct__c = RSD_Gross_Profit_Pct__c and                ORSD_Gross_Profit_Pct__c = 0.0
                 RSD_Original_Unit_Cost__c =  RSD_Unit_Cost__c;
                 RSD_Original_List_Price__c = RSD_List_Price__c;
                 
                
    Test Class  : RSDNA_UpdateGrossAmountTest
    Last Updated By :Venkatesh Kumar Sakthivel
    
*/

Public class RSDNA_OppLineItemStatusChange{
    
    public void onStatusChange(List<OpportunityLineItem> OppProduct, Map<Id,OpportunityLineItem> OldMap){
        set<Id> getOppID = new set<Id>();
        set<Id> checkRelatedOpp = new set<Id>();
        for(OpportunityLineItem OppProd: OppProduct){
        getOppID.add(OppProd.opportunityID);            
        }
        system.debug('The value of getOppID------>'+getOppID);
        
        // Get all the Opportunities related to RSD NA Opportunity record type
        if(!getOppID.isEmpty()){
            for(Opportunity opp : [select ID,recordtypeID from opportunity where ID IN: getOppID and recordtypeID =: Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId()]){
            checkRelatedOpp.add(opp.id);                
            }
        }
                
        for(OpportunityLineItem OppProd: OppProduct){ 
            // Check if the Opportunity is related to RSD NA Opportunity record type
            if(checkRelatedOpp.contains(OppProd.opportunityID)){
                if(OldMap != Null){        
                // get all the opportunity ID's with the current Active status as False 
                    if(OppProd.RSD_Active__c == False && OldMap.get(OppProd.id).RSD_Active__c != OppProd.RSD_Active__c){
                        
                        /*if(OppProd.RSD_Unit_Cost__c != 0.0 ){
                        OppProd.RSD_Original_Gross_Profit_Pct__c = OppProd.RSD_Gross_Profit_Pct__c;
                        OppProd.RSD_Gross_Profit_Pct__c = 0.0;
                        OppProd.RSD_Original_Unit_Cost__c = OppProd.RSD_Unit_Cost__c;
                        OppProd.RSD_Unit_Cost__c = 0.0;
                        }
                        if(OppProd.RSD_List_Price__c != 0.0){
                        OppProd.RSD_Original_List_Price__c = OppProd.RSD_List_Price__c;
                        OppProd.RSD_List_Price__c = 0.0;                            
                        }*/
                        if(OppProd.UnitPrice != 0.0){
                        OppProd.RSD_Original_Sales_Price__c = OppProd.UnitPrice;
                        OppProd.UnitPrice = 0;                          
                        }                   
                    }
                    if(OppProd.RSD_Active__c == True && OldMap.get(OppProd.id).RSD_Active__c != OppProd.RSD_Active__c ){
                        
                        /* if(OppProd.RSD_Gross_Profit_Pct__c == 0.0){
                        OppProd.RSD_Gross_Profit_Pct__c = OppProd.RSD_Original_Gross_Profit_Pct__c;
                        OppProd.RSD_Original_Gross_Profit_Pct__c = 0.0;
                        } */
                        
                        /*if(OppProd.RSD_List_Price__c == 0.0){
                        OppProd.RSD_List_Price__c = OppProd.RSD_Original_List_Price__c;
                        OppProd.RSD_Original_List_Price__c = 0.0;                           
                        }
                        if(OppProd.RSD_Unit_Cost__c == 0.0){
                        OppProd.RSD_Unit_Cost__c = OppProd.RSD_Original_Unit_Cost__c;
                        OppProd.RSD_Original_Unit_Cost__c = 0;                          
                        } */
                        
                        if(OppProd.UnitPrice == 0.0){
                        OppProd.UnitPrice = OppProd.RSD_Original_Sales_Price__c;
                        OppProd.RSD_Original_Sales_Price__c = 0;                    
                        }
                    }
                    if(OppProd.RSD_Active__c == False && OppProd.UnitPrice != 0.0 && OldMap.get(OppProd.id).UnitPrice != OppProd.UnitPrice && OldMap.get(OppProd.id).RSD_Active__c == OppProd.RSD_Active__c){
                    OppProd.addError('Unit Price can only be entered for Active products');             
                    }
                   /*if(OppProd.RSD_Active__c == False && OppProd.RSD_Unit_Cost__c != 0.0 && OldMap.get(OppProd.id).RSD_Unit_Cost__c != OppProd.RSD_Unit_Cost__c && OldMap.get(OppProd.id).RSD_Active__c == OppProd.RSD_Active__c){
                    OppProd.addError('Unit Cost can only be entered for Active products');               
                    }
                    if(OppProd.RSD_Active__c == False && OppProd.RSD_List_Price__c != 0.0 && OldMap.get(OppProd.id).RSD_List_Price__c != OppProd.RSD_List_Price__c && OldMap.get(OppProd.id).RSD_Active__c == OppProd.RSD_Active__c){
                    OppProd.addError('List Price can only be entered for Active products');               
                    }*/
                }else{
                    if(OppProd.RSD_Active__c == False){
                    OppProd.RSD_Original_Sales_Price__c = OppProd.UnitPrice;
                    /*OppProd.RSD_Original_List_Price__c = OppProd.RSD_List_Price__c;
                    OppProd.RSD_Original_Unit_Cost__c = OppProd.RSD_Unit_Cost__c;
                    OppProd.RSD_Original_Gross_Profit_Pct__c = OppProd.RSD_Gross_Profit_Pct__c;*/
                    OppProd.UnitPrice = 0;
                    /*OppProd.RSD_Gross_Profit_Pct__c = 0.0;
                    OppProd.RSD_List_Price__c = 0.0;    
                    OppProd.RSD_Unit_Cost__c = 0.0; */                      
                    }  
                }
            }
        }       
    }   
}