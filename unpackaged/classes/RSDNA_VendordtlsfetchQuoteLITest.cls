/*
    Created By  : Venkatesh Kumar
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 24 April,2017
    Description : --Create a Opportunity Line Item and check for the Opportunity Amount field.
                  --Inactive a Opportunity Line item and then check whether the Opportunity amount has excluded this inactive product line item
    Test Class for: RSDNA_VendordtlsfetchQuoteLI
*/
@isTest(SeeAlldata=true)
private class RSDNA_VendordtlsfetchQuoteLITest{
    static TestMethod void runVendorAccountFetch(){        
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting();
        
        Account accCA = new Account(Name ='TestAccountCA',RSD_CA_Account_Number__c = 'CATest',RSD_MF_Account_Source__c = 'CMF',recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').getRecordTypeId());
        insert accCA;
        
        Account accUS = new Account(Name ='TestAccountUS',RSD_US_Account_Number__c = 'USTest',RSD_MF_Account_Source__c = 'USMF',recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').getRecordTypeId());
        insert accUS;

            Pricebook2 newPriceBookInsert = new Pricebook2(CurrencyIsoCode = 'USD',Description = 'TestClass',IsActive = True,Name='TestClass');     
            insert newPriceBookInsert;

            Product2 newProduct = new Product2 (CurrencyIsoCode = 'USD',IsActive = True, Name = 'Test Product'); 
            insert newProduct; 

            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = Test.getStandardPricebookId(), Product2Id = newProduct.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
            insert standardPrice;
                  
            PricebookEntry newPricebookEntry = new PricebookEntry (CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = newPriceBookInsert.id, Product2Id = newProduct.ID ,UnitPrice = 100);     
            insert newPricebookEntry;         


        opportunity opp = new opportunity (
                    Pricebook2Id =  newPriceBookInsert.Id,
                    CurrencyIsoCode = newPricebookEntry.CurrencyIsoCode,
                    Name = 'Test' , 
                    AccountId = accUS.Id ,
                    StageName = 'Assess/Prepare',
                  
                    RSD_Estimated_Gross_Margin_Pct__c = 2,
                    RSD_Opportunity_Sub_Type__c ='Conversion of Existing Business',
                    RSD_Estimated_Amount__c= 2500.00,
                    CloseDate = System.Today(),
                    recordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId());
        insert opp ;

        RSD_Quote_Header__c quoteHeader = new RSD_Quote_Header__c(Name = 'QuoteTest',Account__c=accUS.Id,RSD_Opportunity__c = opp.ID,RSD_Quote_Status__c = 'Active');
        insert quoteHeader;

        SYSTEM.DEBUG('quoteHeader------------------------->'+quoteHeader);
        
        RSD_Quote_Line_Item__c quoteLineItem = new RSD_Quote_Line_Item__c(Quote__c = quoteHeader.Id,RSD_Vendor_Number__c = 'USTest',RSD_Source_System__c = 'USMF');
        insert quoteLineItem;
        
        SYSTEM.DEBUG('quoteLineItem------------------------->'+quoteLineItem);
        
        quoteLineItem.RSD_Vendor_Number__c = 'CATest';
        quoteLineItem.RSD_Source_System__c = 'CMF';
        update quoteLineItem;
        
    }
}