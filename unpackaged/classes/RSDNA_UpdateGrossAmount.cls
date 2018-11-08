/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 22 April,2017
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

public class RSDNA_UpdateGrossAmount{
public Map<Id, Opportunity> opportunityMap = new Map<Id, Opportunity>();
public Set<ID> oppLineID = new set<ID>();
public Set<ID> oppLineIDonActive = new set<ID>();
public Set<ID> OppinactiveSetUPto0 = new set<ID>();
public List<OpportunityLineItem> UpdateOppLineItem = new List<OpportunityLineItem>();

/*
    Created By  : Venkatesh Kumar Sakthivel
    Requirement : W-000077:T-00289 RSDNA-0043: Opportunity Gross Margin based on Opportunity Products
    Description : Sums up all the gross amount values from all the Active opportunity line item and rolls up the same to the related opportunity.
    Last Updated By : Venkat    
*/    
    public void OppGrossAmountUpdate(List<OpportunityLineItem> OppProduct, Map<Id,OpportunityLineItem> OldMap){

    // Variable declaration
    set<ID> setOppID = new  set<ID>();
    List<Opportunity> lstUpdOpportunity =  new List<Opportunity>();

    for(OpportunityLineItem OppProdgetOpp: OppProduct){
        setOppID.add(OppProdgetOpp.OpportunityID);
    } 
    
    if(!setOppID.isEmpty()){
            //W-000077:T-00289: RSDNA-0043: Opportunity Gross Margin based on Opportunity Products
            for(opportunity opp: [select id,
                                    (select id,RSD_Active__c,opportunityID,RSD_Gross_Profit_Pct__c,RSD_List_Price__c,RSD_Unit_Cost__c,RSD_Order_Number__c,
                                    RSD_Unit_Price__c,opportunity.recordtypeid,UnitPrice,Quantity from OpportunityLineItems),recordtypeID,RSD_Actual_Amount__c,
                                    RSD_Actual_Gross_Margin_Pct__c,RSD_Gross_Margin_Pct__c,RSD_Estimated_Gross_Margin_Pct__c,RSD_Quote_Header_Count__c  
                                FROM 
                                    opportunity 
                                WHERE 
                                    id IN:setOppID 
                                AND 
                                    recordtypeid =: Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId() 
                                AND 
                                    RSD_Quote_Header_Count__c > 0])
            {
                double totalGrossPct = 0.0;
                decimal sumUnitCost = 0.0;
                decimal sumUnitPrice = 0.0;
                decimal sumActualAmount  = 0.0;
                double totalActualGrossPct = 0.0;
                decimal sumActualUnitCost = 0.0;
                decimal sumActualUnitPrice = 0.0;
                if(opp.OpportunityLineItems.size() > 0){
                    for(OpportunitylineItem opplineitem:opp.OpportunityLineItems){
                        if(opplineitem.RSD_Active__c){
                            if(opplineitem.RSD_Unit_Price__c != Null){
                                sumUnitPrice += opplineitem.RSD_Unit_Price__c;
                            }
                            if(opplineitem.RSD_Unit_Cost__c != Null){
                                sumUnitCost += opplineitem.RSD_Unit_Cost__c;
                            }
                            
                            if(opplineitem.RSD_Order_Number__c != Null ){
                                if(opplineitem.UnitPrice != Null && opplineitem.Quantity != Null){
                                    sumActualAmount +=  (opplineitem.UnitPrice * opplineitem.Quantity);
                                }                                   
                                if(opplineitem.RSD_Unit_Price__c != Null){
                                    sumActualUnitPrice += opplineitem.RSD_Unit_Price__c;
                                }
                                if(opplineitem.RSD_Unit_Cost__c != Null){
                                    sumActualUnitCost += opplineitem.RSD_Unit_Cost__c;
                                }
                            }                       
                        }                   
                    }               
                 if(sumUnitPrice != 0){
                    totalGrossPct =  (((sumUnitPrice - sumUnitCost)/sumUnitPrice)*100).setScale(2);
                }else{
                    totalGrossPct = 0.0;    
                }
                
                if(sumActualUnitPrice != 0){
                    totalActualGrossPct =  (((sumActualUnitPrice - sumActualUnitCost)/sumActualUnitPrice)*100).setScale(2);
                }else{
                    totalActualGrossPct = 0.0;    
                }                
                opp.RSD_Actual_Amount__c =sumActualAmount;
                opp.RSD_Gross_Margin_Pct__c =totalGrossPct;
                opp.RSD_Actual_Gross_Margin_Pct__c =totalActualGrossPct;
                  if(opp.RSD_Estimated_Gross_Margin_Pct__c == null || opp.RSD_Estimated_Gross_Margin_Pct__c == 0){
                           opp.RSD_Estimated_Gross_Margin_Pct__c = totalGrossPct;
                  }       
            }else{
               opp.RSD_Gross_Margin_Pct__c = 0;
               opp.RSD_Actual_Amount__c = 0;
               opp.RSD_Actual_Gross_Margin_Pct__c =0;
            }
            lstUpdOpportunity.add(opp);
            system.debug('lstUpdOpportunity-->'+lstUpdOpportunity);
        }
        }
        
                
        //Update UpdateOppLineItem;
        if(!lstUpdOpportunity.isEmpty() ){
        // DML statement
            try{
            Database.update(lstUpdOpportunity, true);
            system.debug('<-------------The value of Update Has happened----------->');
            }catch(dmlexception e){
            System.debug('The following exception has occured------>'+e);
            }
        }else{
             System.debug('There are no records for update'); 
        }       
    }  
    }