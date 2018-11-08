/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 04 May,2017
    Requirement : W-000077:T-00289: RSDNA-0043: Opportunity Gross Margin based on Opportunity Products
    Description : 
                1. Get the sum of RSD_Gross_Profit_Pct__c of all related Opportunity Product for the Opportunity: 
                    a) RSD_Active__c = True 
                    b) RSD_Gross_Profit_Pct__c is not null 
                The formula to update Gross Margin
                 Formula for opportunity 'Actual Gross Margin (%)' roll-up calculation:
                ((sum(ListPrice) - sum(RSD_Unit_Cost__c))/sum(ListPrice))*100    

                2. Update Opportunity 'RSD_Gross_Margin_Pct__c'
    Test Class  : RSDNA_UpdateGrossAmountTest
    Last Updated By : Venkatesh Kumar Sakthivel
    
*/


Public class RSDNA_UpdateActualGrossMargin{

    public void grossMarginUpdate(List<opportunity> lstOpp, Map<Id,opportunity> OldMapOpp){
    
    List<opportunity> lstOppupdate = new List<opportunity>();
    set<ID> checkOppProduct =  new set<ID> ();  
    Map<ID,decimal> getOppGrossAmount = new Map<ID,decimal>();
    double totalGrossPct = 0.0;
    decimal sumUnitCost = 0.0;
    decimal sumUnitPrice = 0.0;
    
        for(opportunity opp : lstOpp){
            system.debug('newvalue------------'+opp.RSD_Quote_Header_Count__c);
            
            if(OldMapOpp == Null){            
                    if(!(opp.RSD_Quote_Header_Count__c > 0) && opp.RSD_Estimated_Gross_Margin_Pct__c != Null && opp.RSD_Gross_Margin_Pct__c == Null){                     
                        opp.RSD_Gross_Margin_Pct__c = opp.RSD_Estimated_Gross_Margin_Pct__c ;
                        //lstOpp.add(opp);
                    }
             }else{
              if(!(opp.RSD_Quote_Header_Count__c > 0) && opp.RSD_Estimated_Gross_Margin_Pct__c != OldMapOpp.get(opp.id).RSD_Estimated_Gross_Margin_Pct__c && opp.RSD_Estimated_Gross_Margin_Pct__c != Null && opp.RSD_Gross_Margin_Pct__c == Null){
                opp.RSD_Gross_Margin_Pct__c = opp.RSD_Estimated_Gross_Margin_Pct__c ;
                //lstOpp.add(opp);             
              }           
              
              if( OldMapOpp.get(opp.id).RSD_Quote_Header_Count__c == 0 && opp.RSD_Quote_Header_Count__c != OldMapOpp.get(opp.id).RSD_Quote_Header_Count__c ){
                checkOppProduct.add(opp.id);              
              }
            }
        }
    system.debug('checkOppProduct------------'+checkOppProduct);    
    
    if(!checkOppProduct.isEmpty()){
        for(OpportunityLineItem getGrossProfit: [select id,RSD_Gross_Profit_Pct__c,RSD_List_Price__c,RSD_Unit_Cost__c,RSD_Unit_Price__c,opportunity.recordtypeid from OpportunityLineItem where opportunityID IN:checkOppProduct and RSD_Active__c = True and opportunity.recordtypeid =: Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId()]){
            system.debug('getGrossProfit------------'+getGrossProfit);
            
            if(checkOppProduct.contains(getGrossProfit.opportunityID)){
                //((sum(ListPrice) - sum(RSD_Unit_Cost__c))/sum(ListPrice))*100 
                system.debug('getGrossProfit.RSD_List_Price__c------------'+getGrossProfit.RSD_List_Price__c);
                system.debug('getGrossProfit.RSD_Unit_Cost__c------------'+getGrossProfit.RSD_Unit_Cost__c);
                system.debug('getGrossProfit.RSD_Unit_Price__c------------'+getGrossProfit.RSD_Unit_Price__c);
                
                if(getGrossProfit.RSD_Unit_Price__c != Null){
                    sumUnitPrice += getGrossProfit.RSD_Unit_Price__c;
                }
                if(getGrossProfit.RSD_Unit_Cost__c != Null){
                sumUnitCost += getGrossProfit.RSD_Unit_Cost__c;
                }
                system.debug('sumUnitCost ------------'+sumUnitCost);
                system.debug('sumUnitPrice------------'+sumUnitPrice);
                if(sumUnitPrice != 0){
                totalGrossPct =  (((sumUnitPrice - sumUnitCost)/sumUnitPrice)*100).setScale(2);
                }else{
                totalGrossPct = 0.0;    
                }
            system.debug('totalGrossPct ------------'+totalGrossPct );
                }
                
        getOppGrossAmount.put(getGrossProfit.opportunityID,totalGrossPct);          
        }
        }
     system.debug('getOppGrossAmount ------------'+getOppGrossAmount ); 
     
     
    for(opportunity oppActualMargin : lstOpp){
        if(OldMapOpp != Null){ 
            if( OldMapOpp.get(oppActualMargin.id).RSD_Quote_Header_Count__c == 0 && oppActualMargin.RSD_Quote_Header_Count__c != OldMapOpp.get(oppActualMargin.id).RSD_Quote_Header_Count__c ){
                if(getOppGrossAmount.containskey(oppActualMargin.id)){
                    oppActualMargin.RSD_Gross_Margin_Pct__c = getOppGrossAmount.get(oppActualMargin.Id);
                    if(oppActualMargin.RSD_Estimated_Gross_Margin_Pct__c == Null){
                    oppActualMargin.RSD_Estimated_Gross_Margin_Pct__c = oppActualMargin.RSD_Gross_Margin_Pct__c;
                    }                    
                } else{
                    if(oppActualMargin.RSD_Estimated_Gross_Margin_Pct__c != Null && oppActualMargin.RSD_Gross_Margin_Pct__c == Null){
                    oppActualMargin.RSD_Gross_Margin_Pct__c = oppActualMargin.RSD_Estimated_Gross_Margin_Pct__c ;                       
                    }                   
                }                   
            }
        }
    }       
    }
}