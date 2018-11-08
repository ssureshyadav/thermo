@isTest
private class RSDNA_QuoteLineItemServiceTest
{
    @isTest private static void insQuoteLineItem()
    {
        RSDNA_DataFactory dataCreation=new RSDNA_DataFactory();
        dataCreation.orgRecordTypes();
        List<Account> lstAccount=dataCreation.insertAccount(1,null);
        List<Opportunity> lstOpportunity=dataCreation.insertOpportunities(1,Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').recordTypeId,lstAccount[0].Id);
        List<RSD_Quote_Header__c> lstQuoteHeader=dataCreation.insertQuoteHeader(1,lstAccount[0].Id,null);
        lstQuoteHeader[0].RSD_Opportunity__c =lstOpportunity[0].Id;
        update lstQuoteHeader[0];
        
        List<Product2> prod=dataCreation.insertProduct(1);
        //Price Book Entry
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = dataCreation.priceBookId(), Product2Id = prod[0].Id,
            UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        // Create a custom price book
        Pricebook2 customPB = new Pricebook2(Name='RSD NA', isActive=true);
        insert customPB;
        
        // 2. Insert a price book entry with a custom price.
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = customPB.Id, Product2Id = prod[0].Id,
            UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        List<RSD_Quote_Line_Item__c> lstQLineItem=dataCreation.insertQuoteLineItem(2,lstQuoteHeader[0].Id);
        
        RSD_Quote_Line_Item__c lineItem=new RSD_Quote_Line_Item__c(Id = lstQLineItem[0].Id);
        lineItem.RSD_Order_Number__c ='1234';
        update lineItem;
        
        lineItem.RSD_Deleted__c =true;
        update lineItem;
        
    }
}