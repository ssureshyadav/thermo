/*
    Created By  : Suresh Sanneboina
    Email ID    : sanneboinasuresh.yadav@nttdata.com    
    Company     : NTTDATA
    Date        : 24 May,2017
     Last Modified Date: 21 June,2017
    Description : 
                    After inserting Quote Line Item, check QuoteHeader is associated to any oppotunity. If so add opportunity products based on Quote Line Item.
                    and if opportunity products are entered manually delete those records.
                    - W-000094
                    - T-00308 -Create trigger in 'RSD_Quote_Line_Item__c' object to add/delete/update records in opportunity Product items
                    
                    W-000188 : T-00377:     Modify QuoteLineItem Trigger to update Quote Header with 'Order Number'
    Test Class  : RSDNA_QuoteLineItemServiceTest
*/
public class RSDNA_QuoteLineItemService 
{
    public void afterInsert(List<RSD_Quote_Line_Item__c> triggerNew)
    {
    //System.debug('---->In AfterInsert<------');
        updateOrderNo(triggerNew);
        Set<Id> setHeaderId = new Set<Id>();
        Map<String,RSD_Quote_Line_Item__c> mapProductNames = new Map<String,RSD_Quote_Line_Item__c>();
        for(RSD_Quote_Line_Item__c lineItem:triggerNew)
        {
            setHeaderId.add(lineItem.Quote__c);
            mapProductNames.put(lineItem.RSD_CMT_Level2_Code__c +'-'+lineItem.RSD_CMT_Level3_Code__c,lineItem);
        }
        
        Map<Id,Id> mapQuoteOpportunity = new Map<Id,Id>();
        Map<Id,String> mapQuote = new Map<Id,String>();
        for(RSD_Quote_Header__c header:[Select Id,Name,RSD_Opportunity__c FROM RSD_Quote_Header__c Where Id IN : setHeaderId])
        {
            if(header.RSD_Opportunity__c != null)
            {
                mapQuoteOpportunity.put(header.Id,header.RSD_Opportunity__c);
            }
            mapQuote.put(header.Id,header.Name);
        }
        
        if(!mapProductNames.isEmpty())
        {
            List<OpportunityLineItem> lstLineItems = new List<OpportunityLineItem>();
            Id priceBookId;
            RSD_Opportunity_Settings__c oppSettings = RSD_Opportunity_Settings__c.getOrgDefaults();
            if(oppSettings.RSD_NA_Price_Book_Id__c != null)
            {
               priceBookId = oppSettings.RSD_NA_Price_Book_Id__c;
            }else{
                priceBookId = [SELECT Id,Name FROM Pricebook2 WHERE Name = 'RSD NA'].Id;
            }
            
            Map<String,PricebookEntry> mapPriceBookEntry=new Map<String,PricebookEntry>();
            for(PricebookEntry priceBook:[SELECT Id,Product2.Name, Product2.ProductCode
                                            FROM PricebookEntry 
                                            WHERE Product2Id IN : ([Select Id from Product2 Where ProductCode IN : mapProductNames.keySet()]) 
                                              AND Pricebook2Id =: priceBookId])
            {
                mapPriceBookEntry.put(priceBook.Product2.ProductCode,priceBook);
            }
            
            for(RSD_Quote_Line_Item__c quotelineItem:triggerNew)
            {
                if(mapPriceBookEntry.containsKey(quotelineItem.RSD_CMT_Level2_Code__c +'-'+quotelineItem.RSD_CMT_Level3_Code__c) && mapQuoteOpportunity.containsKey(quotelineItem.Quote__c))
                {
                    OpportunityLineItem lineItem=new OpportunityLineItem();
                    lineItem.PricebookEntryId = mapPriceBookEntry.get(quotelineItem.RSD_CMT_Level2_Code__c +'-'+quotelineItem.RSD_CMT_Level3_Code__c).Id;
                    lineItem.OpportunityId = mapQuoteOpportunity.get(quotelineItem.Quote__c);
                    lineItem.Quantity = quotelineItem.RSD_Quantity__c;
                    lineItem.UnitPrice = quotelineItem.RSD_Unit_Price__c;   
                    lineItem.RSD_Actual_Quantity__c = quotelineItem.RSD_Quantity__c; 
                    lineItem.RSD_Total_Price__c = quotelineItem.RSD_Extended_Price__c;
                    lineItem.RSD_Gross_Margin_Amount__c = quotelineItem.RSD_Gross_Margin_Amount__c;
                    lineItem.RSD_Line_Number__c = quotelineItem.RSD_Line_Number__c;
                    lineItem.RSD_Gross_Profit_Pct__c = quotelineItem.RSD_List_Gross_Profit_Pct__c;
                    lineItem.RSD_List_Price__c = quotelineItem.RSD_List_Price__c;
                    lineItem.RSD_Part_Description__c = quotelineItem.RSD_Part_Description__c;
                    lineItem.RSD_Part_Number__c = quotelineItem.RSD_Part_Number__c;
                    lineItem.RSD_Pricing_Method__c = quotelineItem.RSD_Pricing_Method__c;
                    lineItem.RSD_Unit_Cost__c = quotelineItem.RSD_Unit_Cost__c;
                    lineItem.RSD_Unit_Price__c = quotelineItem.RSD_Unit_Price__c;
                    lineItem.RSD_Unit_of_Measure__c = quotelineItem.RSD_Unit_of_Measure__c;
                    lineItem.RSD_Vendor__c = quotelineItem.Vendor__c;
                    lineItem.RSD_Quote__c = quotelineItem.Quote__c;
                    lineItem.RSD_Quote_Line_Item__c = quotelineItem.Id;
                    lineItem.RSD_Vendor_Part__c = quotelineItem.RSD_Vendor_Part__c;
                    lineItem.RSD_Order_Number__c = mapQuote.get(quotelineItem.Quote__c);
                    if(lineItem.RSD_Order_Number__c != null && lineItem.RSD_Order_Number__c.length() >20)
                    {
                        lineItem.RSD_Order_Number__c = lineItem.RSD_Order_Number__c.subString(0,20);
                    }
                        
                    lstLineItems.add(lineItem);
                }
            }
            
            System.debug(lstLineItems);
            if(!lstLineItems.isEmpty())
            {
                insert lstLineItems;
            }
            
        }        
    }
    
    public void afterUpdate(List<RSD_Quote_Line_Item__c> triggerNew, Map<Id,RSD_Quote_Line_Item__c> triggerOldMap)
    {
        List<Id> lstIdDelProd = new List<Id>();
        Map<Id,String> mapIdUpdProd = new Map<Id,String>();
        List<RSD_Quote_Line_Item__c> lstOrderUpdate = new List<RSD_Quote_Line_Item__c>();
        
        String opptyCloseWinReason = 'Auto Closed/Won confirmed by Ordered Products';
        RSD_Opportunity_Settings__c oppSettings = RSD_Opportunity_Settings__c.getOrgDefaults();
        if(oppSettings.RSD_Opportunity_Auto_Close_Win_Reason__c != null)
        {
            opptyCloseWinReason = oppSettings.RSD_Opportunity_Auto_Close_Win_Reason__c;
        }
                       
        for(RSD_Quote_Line_Item__c lineItem:triggerNew){

            if(lineItem.RSD_Deleted__c && lineItem.RSD_Deleted__c != triggerOldMap.get(lineItem.Id).RSD_Deleted__c)
            {
                lstIdDelProd.add(lineItem.Id);
            }
            
            if(lineItem.RSD_Order_Number__c != null && lineItem.RSD_Order_Number__c != triggerOldMap.get(lineItem.Id).RSD_Order_Number__c)
            {
                mapIdUpdProd.put(lineItem.Id, lineItem.RSD_Order_Number__c);
                lstOrderUpdate.add(lineItem);                
            }
        }
        updateOrderNo(lstOrderUpdate);
        
        if(!lstIdDelProd.isEmpty())
        {
            delete [Select Id from OpportunityLineItem Where RSD_Quote_Line_Item__c IN : lstIdDelProd];
        }
        
        if(!mapIdUpdProd.isEmpty())
        {
            List<OpportunityLineItem> lstOppLineItem = new List<OpportunityLineItem>();
            Set<Id> setOppId = new Set<Id>();
            for(OpportunityLineItem lineItem:[Select Id,RSD_Quote_Line_Item__c,OpportunityId from OpportunityLineItem Where RSD_Quote_Line_Item__c IN : mapIdUpdProd.keySet()])
            {
                OpportunityLineItem oppLineItem = new OpportunityLineItem(Id = lineItem.Id);
                oppLineItem.RSD_Order_Number__c = mapIdUpdProd.get(lineItem.RSD_Quote_Line_Item__c);
                lstOppLineItem.add(oppLineItem);
                setOppId.add(lineItem.OpportunityId);
            }
            if(!lstOppLineItem.isEmpty())
            {
                update lstOppLineItem;
            }
            
            if(!setOppId.isEmpty())
            {
                List<Opportunity> lstOpp=new List<Opportunity>();
                for(Opportunity oppty:[SELECT Id,CloseDate 
                                         FROM Opportunity 
                                        WHERE Id IN : setOppId 
                                          AND StageName != 'Closed Won'])
                {
                    Opportunity opp=new Opportunity(Id=oppty.Id, StageName = 'Closed Won', RSD_Reason_for_Win_Lost__c = opptyCloseWinReason, CloseDate = System.today());
                    lstOpp.add(opp);
                }
                
                if(!lstOpp.isEmpty())
                {
                    update lstOpp;
                }
            }
        }
    }
    
    //W-000188 : T-00377:     Modify QuoteLineItem Trigger to update Quote Header with 'Order Number'
    public void updateOrderNo(List<RSD_Quote_Line_Item__c> triggerNew){
        Map<Id,RSD_Quote_Line_Item__c> mapQuoteLine=new Map<Id,RSD_Quote_Line_Item__c>();
         for(RSD_Quote_Line_Item__c lineItem:triggerNew){
                if(lineItem.RSD_Order_Number__c != null){
                mapQuoteLine.put(lineItem.Quote__c,lineItem);
                }
            }
         
         if(!mapQuoteLine.isEmpty()){
            List<RSD_Quote_Header__c> lstQuoteHeader=new List<RSD_Quote_Header__c>();
            for(RSD_Quote_Header__c header:[Select Id,Name,RSD_Opportunity__c,RSD_Order_Number__c  FROM RSD_Quote_Header__c Where Id IN : mapQuoteLine.keySet()]){
                RSD_Quote_Header__c qheader=new RSD_Quote_Header__c(Id=header.Id);
                qheader.RSD_Order_Number__c = mapQuoteLine.get( header.ID).RSD_Order_Number__c;
                lstQuoteHeader.add(qheader);
            }            
            if(!lstQuoteHeader.isEmpty())
            {
                update lstQuoteHeader;
            }
         }
    }
    
}