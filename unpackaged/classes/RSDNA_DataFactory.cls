/*
    Created By  : Suresh Sanneboina
    Email ID    : sanneboinasuresh.yadav@nttdata.com    
    Company     : NTTDATA
    Date        : 03 April,2017
    Description : Class for creating test data for test classes.
    Test Class for: RSD_Archive_Contact_Batch
    
*/
public Class RSDNA_DataFactory
{
    public Static Id priceBookId;
    /*public RSD_DataFactory()
    {
        //Managed Package Data
        InForceEW__messagesource__c mSource=new InForceEW__messagesource__c();
        mSource.InForceEW__defaultexternalaccountingentityid__c ='Default';
        mSource.InForceEW__defaultexternallocationid__c='Default';
        mSource.InForceEW__entityacronym__c ='BT;AC;PF;ST;CT;TR;CF;';
        mSource.InForceEW__entitytype__c ='Bill To;Account;Pay From;Ship To;Contact;Territory;Confirm BOD;';
        mSource.InForceEW__isActive__c=true;
        mSource.InForceEW__logicalid__c ='infor.aplus.localdi';
        //mSource.InForceEW__messagesourceurl__c
        mSource.InForceEW__sequenceid__c ='1';
        mSource.Name = 'Message Source';
        insert mSource;
        
        InForceEW__logger__c logger=new InForceEW__logger__c();
        logger.InForceEW__entity__c ='';
        InForceEW__messagesfid__c
        InForceEW__messagetype__c
        InForceEW__message__c
        InForceEW__relatedentityurl__c
    }*/
    
    public RSD_Organization_Specific_Settings__c orgSpecificSetting()
    {
        RSD_Organization_Specific_Settings__c org_settings =RSD_Organization_Specific_Settings__c.getOrgDefaults();
        
        //id getUserID = getInstance(UserInfo.getUserId());
        
        if (org_settings == null) {
            org_settings = new RSD_Organization_Specific_Settings__c();
            org_settings.RSD_Execute_Triggers__c = true;
            org_settings.RSD_Execute_Validation_Rules__c = true;
            org_settings.RSD_Execute_Workflow_Rules__c = true;
            org_settings.RSD_NA_Sales_Operations_Admin_User_ID__c = UserInfo.getUserId();
            //org_settings.RSD_NA_Sales_Operations_Admin_User_ID__c = getUserID ;
            upsert org_settings;
        }
        return org_settings;
    }
    
    public Record_Types__c orgRecordTypes()
    {
        //Record_Types__c org_recordType =Record_Types__c.getOrgDefaults();
        //System.debug(org_recordType);
            Record_Types__c org_recordType = new Record_Types__c();
            org_recordType.RSDEU_Parent_Campaign__c = '1234';
            org_recordType.RSDNA_Opportunity__c = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').recordTypeId;
            insert org_recordType;
        //}
        return org_recordType;
    }
    
    public List<Account> insertAccount(integer noofRecords,Id recordTypeId)
    {
        List<Account> lstAccount=new List<Account>();
        for(integer i=0;i<noofRecords;i++)
        {
            Account acc=new Account(Name ='data'+i);
            if(recordTypeId != null)
            {
                acc.recordTypeId =recordTypeId;
            }
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        return lstAccount;
    } 
    
    /*
        Method Name:insertContact
        
    */
    public List<Contact> insertContact(integer noofRecords,Id recordTypeId,Id accountId)
    {
        List<Contact> lstcontact=new List<Contact>();
        for(integer i=0;i<noofRecords;i++)
        {
            Contact con=new Contact(LastName ='data'+i,AccountId = accountId,RSD_Archive__c =true);
            if(recordTypeId != null)
            {
                con.recordTypeId =recordTypeId;
            }
            lstcontact.add(con);
        }
        
        insert lstcontact;
        return lstcontact;
    } 
    
     /*
        Method Name:insertOpportunities
        
    */
   
    public List<Opportunity> insertOpportunities (integer noofRecords, Id recordTypeId, Id accountId)
    {
        System.debug('In Data Factory'+recordTypeId);
        
        List<Opportunity> lstOpportunity = new List<Opportunity>();
        for(integer i=0; i<noofRecords; i++){
            System.debug('-----Opportunity'+i);
            Opportunity opp = new Opportunity(Name = 'data'+i, AccountId = accountId, 
                                              StageName = 'Assess/Prepare',  
                                              RSD_Opportunity_Sub_Type__c ='Conversion of Existing Business', 
                                              CurrencyIsoCode='USD',
                                              RSD_Created_from_Quote__c =true,
                                              RSD_Actual_Amount__c =10,
                                              RSD_Actual_Gross_Margin_Pct__c =10,
                                              RSD_Estimated_Gross_Margin_Pct__c=2.0,  
                                              RSD_Estimated_Amount__c=2500.00,
                                              CloseDate = System.Today());
            if(recordTypeId != null) {
                opp.recordTypeId = recordTypeId;
            }
            lstOpportunity.add(opp);    
        }
        insert lstOpportunity;
        return lstOpportunity;
    }
    
      /*
        Method Name:insertOppProduct with parameters
        
    */ 
    
   public OpportunityLineItem insertOppProduct (Id oppId)
    {
        
            Pricebook2 newPriceBookInsert = new Pricebook2(CurrencyIsoCode = 'USD',Description = 'TestClass',IsActive = True,Name='TestClass');     
            insert newPriceBookInsert;

            Product2 newProduct = new Product2 (CurrencyIsoCode = 'USD',IsActive = True, Name = 'Test Product2'); 
            insert newProduct; 

            //Pricebook2 standardPB = [select id from Pricebook2 where isStandard=true];
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = new RSDNA_DataFactory().priceBookId(), Product2Id = newProduct.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
            insert standardPrice;
          
            PricebookEntry newPricebookEntry = new PricebookEntry (CurrencyIsoCode = 'USD',IsActive = True, Pricebook2Id = newPriceBookInsert.id, Product2Id = newProduct.ID ,UnitPrice = 100);     
            insert newPricebookEntry;         

            System.debug('In Data Factory');
            OpportunityLineItem optyPdt = new OpportunityLineItem(PricebookEntryId=newPricebookEntry.Id,OpportunityId=oppId, Quantity=1,UnitPrice=1422.0,RSD_Active__c = True);
       
            insert optyPdt;
    
      return optyPdt; 
    }
    
      /*
        Method Name:insertOptyProduct
        
    */     
   public OpportunityLineItem insertOptyProduct (){
    Pricebook2 newPriceBookInsert = new Pricebook2(CurrencyIsoCode = 'USD',Description = 'TestClass',IsActive = True,Name='TestClass');     
    insert newPriceBookInsert;

    Product2 newProduct = new Product2 (CurrencyIsoCode = 'USD',IsActive = True, Name = 'Test Product'); 
    insert newProduct; 

    PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = new RSDNA_DataFactory().priceBookId(), Product2Id = newProduct.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
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
            RSD_Estimated_Gross_Margin_Pct__c = 2,
            RSD_Opportunity_Sub_Type__c ='Conversion of Existing Business',
            RSD_Estimated_Amount__c= 2500.00,
            CloseDate = System.Today(),
            recordTypeId = Schema.SObjectType.opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId());
            
            insert opp ;
             
    OpportunityLineItem optyPdt = new OpportunityLineItem(PricebookEntryId=newPricebookEntry.Id,OpportunityId=opp.id, Quantity=1,UnitPrice=1422.0,RSD_Active__c = True);
    insert optyPdt;
    
    return optyPdt; 
    }
    
  
      /*
        Method Name:insertOptyContactRole        
    */
   
    public OpportunityContactRole insertOptyContactRole (Id contactId, Id opportunityId)
    {
        System.debug('In Data Factory');
        OpportunityContactRole optyConRole = new OpportunityContactRole(ContactId =contactId, OpportunityId =opportunityId);
        insert optyConRole;
        return optyConRole;
    }
    
     /*
        Method Name:insertQuoteHeader
        Description: To insert Quote Header test data for test class and apex coverage.       
    */
    
    public RSD_Quote_Header__c insertQuoteHeader(Id accountId,string QuoteStatus){
        System.debug('<------------------In Data Factory------------------->');
        RSD_Quote_Header__c quoteHeader = new RSD_Quote_Header__c(Name = 'QuoteTest',Account__c = accountId,RSD_Quote_Status__c = QuoteStatus);
        insert quoteHeader; 
        return quoteHeader;    
    }
    
    public List<RSD_Quote_Header__c> insertQuoteHeader(integer noOfRecords,Id AccountId,Id opportunityId){
        System.debug('<------------------In Data Factory------------------->');
        List<RSD_Quote_Header__c> lstQuoteHeader=new List<RSD_Quote_Header__c>();
        for(Integer i=0;i<noOfRecords;i++)
        {
            RSD_Quote_Header__c header = new RSD_Quote_Header__c(Account__c = AccountId,Name ='test',RSD_Caller__c = 'CALL MICHELLE BUGDEN',RSD_Customer_PO__c ='',
                                                                RSD_MF_Created_Date__c =System.Today(),RSD_MF_Quote_Status__c ='NEW',RSD_Order_Number__c ='500200',
                                                                RSD_Preparer__c ='BEN GRASS',RSD_Primary_External_Id__c ='CMF30591620170418'+i,RSD_Quote_Status__c ='Active',
                                                                RSD_Total_Cost__c =440.01,RSD_Total_Gross_Profit_Pct__c =69.32,RSD_Total_List_Price__c = 1434.33,
                                                                RSD_Total_Price__c =849.16,CurrencyIsoCode = 'USD');

            //header.CurrencyIsoCode

            //header.RSD_Opportunity__c 
            lstQuoteHeader.add(header);
        }
        
        insert lstQuoteHeader; 
        return lstQuoteHeader;    
   } 
   
   public list<RSD_Quote_Line_Item__c> insertQuoteLineItem(Integer noOfRecords,Id quoteHeaderId)
   {
       List<RSD_Quote_Line_Item__c> lstQuoteLineItem=new List<RSD_Quote_Line_Item__c>();
       for(Integer i=0;i<noOfRecords;i++)
       {
           RSD_Quote_Line_Item__c qLineItem=new RSD_Quote_Line_Item__c(Quote__c = quoteHeaderId,RSD_CMT_Level2_Code__c ='test'+i,
                                                                       RSD_CMT_Level2_Description__c='Chemicals',RSD_CMT_Level3_Code__c='test'+i,
                                                                       RSD_CMT_Level3_Description__c ='Analytical Chemicals',RSD_Extended_Price__c=1714.0,
                                                                       RSD_Gross_Margin_Amount__c= 531.16,RSD_Line_Number__c='00001',RSD_List_Gross_Profit_Pct__c=30.99,
                                                                       RSD_List_Price__c=896.09,RSD_Order_Number__c='1620',RSD_Part_Description__c='384 WELL STORAGE PLATE V CS/50',
                                                                       RSD_Part_Number__c='AB0781',RSD_Pricing_Method__c='G',RSD_Primary_External_Id__c='USMFBena2f9E0000004slh'+i,
                                                                       RSD_Quantity__c=1,RSD_Source_System__c='CMF',RSD_Unit_Cost__c=295.71,
                                                                       RSD_Unit_of_Measure__c='CS',RSD_Unit_Price__c=428.5,RSD_Vendor_Name__c='ABGENE INC USA',
                                                                       RSD_Vendor_Part__c='AB0781');
           lstQuoteLineItem.add(qLineItem);
           //RSD_Vendor_Number__c,
           //CurrencyIsoCode,
        }
        insert lstQuoteLineItem;
        return lstQuoteLineItem;
   }
   
   public Id priceBookId()
   {   
       System.debug('Price Book Id:'+RSDNA_DataFactory.priceBookId); 
       if(RSDNA_DataFactory.priceBookId == null)
       {
            RSDNA_DataFactory.priceBookId=Test.getStandardPricebookId();
       }
       return RSDNA_DataFactory.priceBookId;
   }
   
   public List<Product2> insertProduct(Integer noOfRecords)
   {
       
       List<Product2> lstProduct=new List<Product2>();
       for(Integer i=0;i<noOfRecords;i++)
       {
           Product2 prod = new Product2(Name = 'Laptop X200', Family = 'Hardware',ProductCode = 'test'+i+'-'+'test'+i);
           lstProduct.add(prod);
       }
       insert lstProduct;
       return lstProduct;
   }
    
    
}