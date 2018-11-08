/*
    Created By  : Venkatesh Kumar
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 02 May,2017
    Description : --Create a Opportunity Line Item and check for the Opportunity Amount field.
                  --Inactive a Opportunity Line item and then check whether the Opportunity amount has excluded this inactive product line item
    Test Class for: RSDNA_UpdateGrossAmount,RSDNA_UpdateActualGrossMargin and RSDNA_OppLineItemStatusChange
*/
@isTest(SeeAlldata=true)
private class RSDNA_UpdateGrossAmountTest{
    
    static TestMethod void runUpdateOpp(){        
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting(); 
        
        OpportunityLineItem insertOptyProduct = data.insertOptyProduct ();         
        insertOptyProduct.UnitPrice = 0.0;
        insertOptyProduct.RSD_Active__c = False;
        update insertOptyProduct;  

        //Inserting all price product,pricebookentery and OpportunityLineItem related 
        Pricebook2 newPriceBookInsert = new Pricebook2(CurrencyIsoCode = 'USD',Description = 'TestClass',IsActive = True,Name='TestClass');     
        insert newPriceBookInsert;
        Product2 newProduct = new Product2 (CurrencyIsoCode = 'USD',IsActive = True, Name = 'Test Product'); 
        insert newProduct; 
        Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = standardPB.Id, Product2Id = newProduct.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert standardPrice;              
        PricebookEntry newPricebookEntry = new PricebookEntry (CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = newPriceBookInsert.id, Product2Id = newProduct.ID ,UnitPrice = 100);     
        insert newPricebookEntry;
        Account acc = new Account(Name ='TestAccount',recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
        insert acc; 

        opportunity opp = new opportunity (
                Pricebook2Id =  newPriceBookInsert.Id,
                CurrencyIsoCode = newPricebookEntry.CurrencyIsoCode,
                Name = 'Test' , 
                AccountId = acc.Id ,
                StageName = 'Assess/Prepare',
                RSD_Opportunity_Sub_Type__c ='Conversion of Existing Business',
                RSD_Estimated_Amount__c= 2500.00,
                CloseDate = System.Today(),
                RSD_Estimated_Gross_Margin_Pct__c = 2,
                RSD_Quote_Header_Count__c = 0,
                recordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId()
                );
                
                insert opp ;
                
                OpportunityLineItem optyPdtFalse = new OpportunityLineItem(PricebookEntryId=newPricebookEntry.Id,opportunityID=opp.id,RSD_List_Price__c = 100,RSD_Order_Number__c = '5684583459',RSD_Unit_Cost__c = 20, Quantity=1,UnitPrice=1422.0,RSD_Active__c = True,RSD_Gross_Profit_Pct__c = 0.0);
                insert optyPdtFalse ;    
                
                opp.RSD_Estimated_Gross_Margin_Pct__c = 4;              
                opp.RSD_Gross_Margin_Pct__c =1;
                opp.RSD_Quote_Header_Count__c =3;
                update opp;                   
        
        optyPdtFalse.RSD_Active__c = False;

        Update optyPdtFalse;
        
        try{            
        optyPdtFalse.UnitPrice  = 20;
        Update optyPdtFalse;
        }catch(exception e){
        system.debug(e);    
        }
        
        try{            
        optyPdtFalse.RSD_Active__c = True;
        optyPdtFalse.RSD_Gross_Profit_Pct__c = 100;
        optyPdtFalse.Unitprice = 200;
        Update optyPdtFalse;
        }catch(exception e){
        system.debug(e);    
        }
        
        OpportunityLineItem optyPdtFalset = new OpportunityLineItem(PricebookEntryId=newPricebookEntry.Id,OpportunityId=opp.id, Quantity=1,UnitPrice=1422.0,RSD_Active__c = False,RSD_Gross_Profit_Pct__c = 0.0,RSD_Unit_Price__c = 2,RSD_Unit_Cost__c = 5);
        insert optyPdtFalset ;
        
}


}