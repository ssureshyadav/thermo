@isTest
private Class RSDNA_SearchQuotesTest
{
    private static TestMethod void SearchQuotes()
    {
        System.debug(Test.getStandardPricebookId());
        RSDNA_DataFactory dataCreation=new RSDNA_DataFactory();
        dataCreation.orgRecordTypes();
        /*Record_Types__c org_recordType = new Record_Types__c();
        org_recordType.RSDEU_Parent_Campaign__c = '1234';
        insert org_recordType;*/
        
        List<Account> lstAccount=dataCreation.insertAccount(2,null);
        List<Opportunity> lstOpportunity=dataCreation.insertOpportunities(1,Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').recordTypeId,lstAccount[0].Id);
        //dataCreation.insertOptyProduct();
        List<RSD_Quote_Header__c> lstQuoteHeader=dataCreation.insertQuoteHeader(2,lstAccount[0].Id,null);
        List<Product2> prod=dataCreation.insertProduct(1);
        //Price Book Entry
        
        RSD_Quote_Header__c qheade=new RSD_Quote_Header__c(Id=lstQuoteHeader[1].Id);
        qheade.RSD_Opportunity__c =lstOpportunity[0].Id;
        update qheade;
        
        delete qheade;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        //Pricebook2 priceBook=[Select Id,name,isstandard from Pricebook2 Where Id = : Test.getStandardPricebookId() FOR UPDATE];
        
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = dataCreation.priceBookId(), Product2Id = prod[0].Id,UnitPrice = 10000, IsActive = true);
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
        
        Apexpages.currentPage().getParameters().put('Id',lstAccount[0].Id);
        
        RSDNA_SearchQuotes sQuotes=new RSDNA_SearchQuotes();
        RSDNA_SearchQuotes.QuoteHeaders qHeader=new RSDNA_SearchQuotes.QuoteHeaders();
        qHeader.checked =true;
        qHeader.quoteHeader = lstQuoteHeader[0];
        
        sQuotes.lstQuoteHeaders =new List<RSDNA_SearchQuotes.QuoteHeaders>{qHeader};
        
        sQuotes.oppCloseDate =System.today()+1;
        sQuotes.sortExpression ='RSD_Opportunity__c';
        sQuotes.getFields();
        sQuotes.getSortDirection();
        sQuotes.btncreateOpportunities();
        sQuotes.btncancel();
        sQuotes.sortPage();
        sQuotes.btnClickSearch();
        sQuotes.isFromOpportunity =false;
        sQuotes.btncreateOpportunities();
        
        Test.startTest();
            RSD_Opportunity_Settings__c oppsetting=new RSD_Opportunity_Settings__c();
            oppsetting.Name ='Thermo Fisher Scientific Inc. - CCG';
            oppsetting.RSD_NA_Price_Book_Id__c =customPB.Id;
            insert oppsetting;
            
            Apexpages.currentPage().getParameters().put('Id',lstOpportunity[0].Id);
            
            RSDNA_SearchQuotes newInsQuotes=new RSDNA_SearchQuotes();
            newInsQuotes.lstQuoteHeaders =new List<RSDNA_SearchQuotes.QuoteHeaders>{qHeader};
            newInsQuotes.btncreateOpportunities();
            
            RSDNA_LtngRemoveQuoteFromOpportunity.updateOpportunityLines(lstQuoteHeader[0].Id,false);
            RSDNA_LtngRemoveQuoteFromOpportunity.removeOpportunity(lstQuoteHeader[0].Id);    
            RSDNA_LtngRemoveQuoteFromOpportunity.updateOpportunityLines(lstQuoteHeader[0].Id,false);
            RSDNA_LtngRemoveQuoteFromOpportunity.updateOpportunityLines(null,false);
            RSDNA_LtngRemoveQuoteFromOpportunity.removeOpportunity(null);
            
        Test.stopTest();
        
        
    }
}