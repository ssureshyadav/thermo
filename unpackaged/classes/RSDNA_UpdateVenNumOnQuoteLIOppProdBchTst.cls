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
    Test Class for Batch : RSDNA_UpdateVenNumOnQuoteLIOppProdBatch
    Last Updated By : 
*/
@isTest
private class RSDNA_UpdateVenNumOnQuoteLIOppProdBchTst {

    @isTest
    private static void updateVendorNumber(){
        
        RSD_Opportunity_Settings__c optySetg= RSD_Opportunity_Settings__c.getInstance();
        
        optySetg.RSD_Quote_Vendors_Days_to_Validate__c = 5;
        RSDNA_DataFactory data = new RSDNA_DataFactory();
        List<Account> acc=data.insertAccount(2, Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').getRecordTypeId());
        
       
        Record_Types__c org_recordType = new Record_Types__c();
        org_recordType.RSDEU_Parent_Campaign__c = '1234';
        insert org_recordType;
        //List<Opportunity> opty = data.insertOpportunities(1, '0129E0000008lx1', acc[0].id);
        Id recordtypeId=Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId();
        Opportunity opty = new Opportunity(Name = 'data1', AccountId = acc[0].id, 
                                              StageName = 'Assess/Prepare',  
                                              RSD_Opportunity_Sub_Type__c ='Conversion of Existing Business', 
                                              CurrencyIsoCode='USD',
                                              RSD_Actual_Amount__c =10,
                                              RSD_Actual_Gross_Margin_Pct__c =10,
                                              RSD_Estimated_Gross_Margin_Pct__c=2.0,  
                                              RSD_Estimated_Amount__c=2500.00,
                                              recordTypeId = recordtypeId,
                                              CloseDate = System.Today());
        Insert opty;
      


        List<RSD_Quote_Header__c > quotes = data.insertQuoteHeader(1, acc[0].id, opty.id);
        
        
         List<Product2> prod=data.insertProduct(1);
        //Price Book Entry
        
        Id pricebookId = Test.getStandardPricebookId();
        
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = data.priceBookId(), Product2Id = prod[0].Id,
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
        
        List<RSD_Quote_Line_Item__c> lstQLineItem=data.insertQuoteLineItem(2,quotes[0].Id);
    
        
        
        RSD_Quote_Line_Item__c qLineItem1=new RSD_Quote_Line_Item__c(Quote__c = quotes[0].id,RSD_CMT_Level2_Code__c ='test1',
                                                                       RSD_CMT_Level2_Description__c='Chemicals',RSD_CMT_Level3_Code__c='test1',
                                                                       RSD_CMT_Level3_Description__c ='Analytical Chemicals',RSD_Extended_Price__c=1714.0,
                                                                       RSD_Gross_Margin_Amount__c= 531.16,RSD_Line_Number__c='00001',RSD_List_Gross_Profit_Pct__c=30.99,
                                                                       RSD_List_Price__c=896.09,RSD_Order_Number__c='1620',RSD_Part_Description__c='384 WELL STORAGE PLATE V CS/50',
                                                                       RSD_Part_Number__c='AB0781',RSD_Pricing_Method__c='G',RSD_Primary_External_Id__c='USMFBena2f9E0000004slh',
                                                                       RSD_Quantity__c=1,RSD_Source_System__c='USMF',RSD_Unit_Cost__c=295.71,
                                                                       RSD_Unit_of_Measure__c='CS',RSD_Unit_Price__c=428.5,
                                                                       RSD_Vendor_Number__c='VN00201728');
        
        
        Insert qLineItem1; 
        
        RSD_Quote_Line_Item__c qLineItem2=new RSD_Quote_Line_Item__c(Quote__c = quotes[0].id,RSD_CMT_Level2_Code__c ='test1',
                                                                       RSD_CMT_Level2_Description__c='Chemicals',RSD_CMT_Level3_Code__c='test2',
                                                                       RSD_CMT_Level3_Description__c ='Analytical Chemicals',RSD_Extended_Price__c=1714.0,
                                                                       RSD_Gross_Margin_Amount__c= 531.16,RSD_Line_Number__c='00001',RSD_List_Gross_Profit_Pct__c=30.99,
                                                                       RSD_List_Price__c=896.09,RSD_Order_Number__c='1620',RSD_Part_Description__c='384 WELL STORAGE PLATE V CS/50',
                                                                       RSD_Part_Number__c='AB07812',RSD_Pricing_Method__c='G',RSD_Primary_External_Id__c='CMFafsdf',
                                                                       RSD_Quantity__c=1,RSD_Source_System__c='CMF',RSD_Unit_Cost__c=295.71,
                                                                       RSD_Unit_of_Measure__c='CS',RSD_Unit_Price__c=428.5,
                                                                       RSD_Vendor_Number__c='VN002017');
        
        
        Insert qLineItem2;
        
     
        
        Account vendorAcc1 = new Account();
            vendorAcc1.id=acc[0].id;
           vendorAcc1.RSD_US_Account_Number__c='VN00201728';
            vendorAcc1.RSD_MF_Account_Source__c='USMF';
            vendorAcc1.RSD_Account_Status__c='Active';
        Update vendorAcc1;
        
         Account vendorAcc2 = new Account();
            vendorAcc2.id=acc[0].id;
           vendorAcc2.RSD_CA_Account_Number__c='VN002017';
            vendorAcc2.RSD_MF_Account_Source__c='CMF';
            vendorAcc2.RSD_Account_Status__c='Active';
        Update vendorAcc2;
           
        OpportunityLineItem optyLI = data.insertOppProduct(opty.id);
        OpportunityLineItem optyLIUpdate = new OpportunityLineItem(Id=optyLI.id);
        optyLIUpdate.RSD_Quote_Line_Item__c = qLineItem1.id;
        optyLIUpdate.RSD_Vendor__c =null;
        Update optyLIUpdate;
       
        
        Database.executeBatch(new RSDNA_UpdateVenNumOnQuoteLIOppProdBatch());
    }
}