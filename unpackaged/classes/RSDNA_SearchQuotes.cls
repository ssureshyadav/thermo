/*
    Created By  : Suresh Sanneboina
    Email ID    : sanneboinasuresh.yadav@nttdata.com    
    Company     : NTTDATA
    Date        : 20 April,2017
    Description : 
                    - Fetch The Quote Header records based on the account Id and display in VF page(RSDNASearchQuotes)
                    - Choose the Opportunity Close date and select the quote headers to create opportunity and 
                      relate the quote header, Fetch the Quote Line item records and Create the Opportunity products based on code 2 and 3 from
                      product. The default PriceBook id is passed from RSD_Opportunity_Settings__c.
                    - W-000064 -RSDNA-0030: Create an Opportunity from an Existing Quote
                    - W-000077 -RSDNA-0043: Opportunity Gross Margin based on Opportunity Products
    Test Class  : RSD_Archive_Contact_Batch_Test
*/

public class RSDNA_SearchQuotes {

    //Constructor
    public RSDNA_SearchQuotes() {
        //acc =(Account)controller.getRecord();
        isFromOpportunity =false;
        if(Apexpages.currentPage().getParameters().get('Id').startsWith('006'))
        {
            isFromOpportunity =true;
            Opportunity oppty=[Select AccountId,Id,CurrencyIsoCode from Opportunity where Id =: Apexpages.currentPage().getParameters().get('Id')];
            oppCurrencyISOCode = oppty.CurrencyIsoCode;
            acc =[Select Id,Name From Account Where Id = : oppty.AccountId];
        }else if(Apexpages.currentPage().getParameters().get('Id').startsWith('001'))
        {
            acc =[Select Id,Name From Account Where Id = : Apexpages.currentPage().getParameters().get('Id')];    
        }
        getQuoteHeaderList();
    }


    public Class QuoteHeaders
    {
        public boolean checked {get;set;}
        public RSD_Quote_Header__c quoteHeader {get;set;}
        
        public QuoteHeaders(){
            quoteHeader = new RSD_Quote_Header__c();
            checked = false;
        }

        public QuoteHeaders(RSD_Quote_Header__c qHeader){
            quoteHeader = qHeader;
            checked = false;
        }
    }
    
    private String sortDirection = 'ASC';
    private String sortExp = 'Name';

    //Sorting Column Expression
   public String sortExpression
   {
     get
     {
        return sortExp;
     }
     set
     {
       //if the column is clicked on then switch between Ascending and Descending modes
       if (value == sortExp)
         sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
       else
         sortDirection = 'ASC';
       sortExp = value;
     }
   }

     public String getSortDirection()
     {
        //if no column is selected 
        if (sortExpression == null || sortExpression == '')
          return 'ASC';
        else
         return sortDirection;
     }
    
    public string searchText {get;set;}
    public Date oppCloseDate {get;set;}
    public List<QuoteHeaders> lstQuoteHeaders {get;set;}
    public String currencyISOCode ='USD';
    public String oppCurrencyISOCode;
    public Boolean isFromOpportunity {get;set;}
    public Account acc {get;set;}
    
    public void btnClickSearch()
    {
        getQuoteHeaderList();
    }
    
    public pageReference btncreateOpportunities()
    {
        System.Savepoint sp=Database.setSavePoint();
        Opportunity opp;
        List<Id> lstQuoteHeaderId=new List<Id>();
        Set<String> lstCurrencyCode=new Set<String>();
        String quotechecked='';
        try{
            for (QuoteHeaders qHeaders : lstQuoteHeaders) {
                if (qHeaders.checked){
                    lstQuoteHeaderId.add(qHeaders.quoteHeader.Id);
                    quotechecked +=qHeaders.quoteHeader.Name+',';
                    if(isFromOpportunity && qHeaders.quoteHeader.CurrencyIsoCode != oppCurrencyISOCode)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Cannot associate quotes to an opportunity with different currencies'));
                        return null;
                    }
                    currencyISOCode = qHeaders.quoteHeader.CurrencyIsoCode;
                    lstCurrencyCode.add(qHeaders.quoteHeader.CurrencyIsoCode);
                }
            }
            
            if(lstCurrencyCode.size()>1)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Cannot create an opportunity from quotes with different currencies'));
                return null;
            }
            
            if(quotechecked != null)
            {
                quotechecked =quotechecked.removeEnd(',');
            }
            if(!lstQuoteHeaderId.isEmpty())
            {
                if(!isFromOpportunity)
                {
                    if(oppCloseDate == null)
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please enter a Close Date for the new Opportunity'));
                        return null;
                    }
        
                    opp=new Opportunity(Name = acc.Name + ' - Opportunity from Quote ('+quotechecked+')',RSD_Created_from_Quote__c =true,AccountId = acc.Id,CurrencyIsoCode=currencyISOCode);
                    opp.RecordTypeId = Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getrecordTypeId();
                    opp.CloseDate=oppCloseDate;
                    opp.StageName='Proposal/Quote/Solution'; 
                    //opp.RSD_Quote_Header_Count__c = lstQuoteHeaderId.size();
                    insert opp;
                }else{
                    opp=new Opportunity(Id=Apexpages.currentPage().getParameters().get('Id'));
                    /*Decimal headerCount=[Select Id,RSD_Quote_Header_Count__c from Opportunity Where Id = : Apexpages.currentPage().getParameters().get('Id')].RSD_Quote_Header_Count__c; 
                    opp.RSD_Quote_Header_Count__c = headerCount+lstQuoteHeaderId.size();
                    update opp;
                    
                    //Delete the OpportunityLineItems which does having RSD_Quote_Line_Item__c as NULL 
                    DELETE [SELECT ID from OpportunityLineItem Where OpportunityId=: Apexpages.currentPage().getParameters().get('Id') and RSD_Quote_Line_Item__c =''];*/       
                }

                Map<String,RSD_Quote_Line_Item__c> mapProductNames=new Map<String,RSD_Quote_Line_Item__c>();
                List<RSD_Quote_Line_Item__c> lstRSDQuloteLineItem=[SELECT 
                                Quote__c,Quote__r.Name,RSD_CMT_Level2_Code__c,RSD_CMT_Level3_Code__c,RSD_Quantity__c,RSD_Extended_Price__c,RSD_Gross_Margin_Amount__c,
                                RSD_Line_Number__c, RSD_List_Gross_Profit_Pct__c,RSD_Part_Description__c,RSD_Part_Number__c,RSD_Pricing_Method__c,RSD_Unit_Cost__c,
                                RSD_Unit_Price__c,RSD_Unit_of_Measure__c,Vendor__c, RSD_List_Price__c, RSD_Vendor_Number__c, RSD_Vendor_Part__c, RSD_Order_Number__c
                            FROM 
                                RSD_Quote_Line_Item__c 
                            Where 
                                Quote__c IN : lstQuoteHeaderId ];
                if(!lstRSDQuloteLineItem.isEmpty())
                for(RSD_Quote_Line_Item__c lineItem:lstRSDQuloteLineItem){
                    mapProductNames.put(lineItem.RSD_CMT_Level2_Code__c +'-'+lineItem.RSD_CMT_Level3_Code__c,lineItem);    
                }
                
                if(!mapProductNames.isEmpty())
                {
                    List<OpportunityLineItem> lstLineItems=new List<OpportunityLineItem>();
                    Id priceBookId;
                    RSD_Opportunity_Settings__c oppSettings=RSD_Opportunity_Settings__c.getOrgDefaults();
                    if(oppSettings.RSD_NA_Price_Book_Id__c != null)
                    {
                       priceBookId =  oppSettings.RSD_NA_Price_Book_Id__c;
                    }else{
                        priceBookId = [SELECT Id,Name FROM Pricebook2 WHERE Name = 'RSD NA'].Id;
                    }
                    Map<String,PricebookEntry> mapPriceBookEntry=new Map<String,PricebookEntry>();
                    for(PricebookEntry priceBook:[SELECT 
                                                        Id,Product2.Name, Product2.ProductCode
                                                    FROM 
                                                        PricebookEntry 
                                                    WHERE 
                                                        Product2Id IN : ([Select Id from Product2 Where ProductCode IN : mapProductNames.keySet()]) 
                                                    AND
                                                       CurrencyIsoCode = :currencyISOCode
                                                   AND 
                                                       Pricebook2Id = : priceBookId])
                    {
                            mapPriceBookEntry.put(priceBook.Product2.ProductCode,priceBook);
                    }
                    
                    for(RSD_Quote_Line_Item__c quotelineItem:lstRSDQuloteLineItem)
                    {
                        if(mapPriceBookEntry.containsKey(quotelineItem.RSD_CMT_Level2_Code__c +'-'+quotelineItem.RSD_CMT_Level3_Code__c))
                        {
                            OpportunityLineItem lineItem=new OpportunityLineItem();
                            lineItem.PricebookEntryId = mapPriceBookEntry.get(quotelineItem.RSD_CMT_Level2_Code__c +'-'+quotelineItem.RSD_CMT_Level3_Code__c).Id;
                            if(!isFromOpportunity)
                            {
                                lineItem.OpportunityId = opp.Id;
                            }else{
                                lineItem.OpportunityId = Apexpages.currentPage().getParameters().get('Id');
                            }
                            
                            lineItem.Quantity = 1;
                            lineItem.UnitPrice = quotelineItem.RSD_Extended_Price__c;
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
                            lineItem.RSD_Order_Number__c = quotelineItem.RSD_Order_Number__c;
                            lineItem.RSD_Vendor_Part__c = quotelineItem.RSD_Vendor_Part__c;
                                
                            lstLineItems.add(lineItem);
                        }
                    }
                    
                    System.debug(lstLineItems);
                    if(!lstLineItems.isEmpty())
                    {
                        insert lstLineItems;
                    }
                    
                }
                List<RSD_Quote_Header__c> lstQuoteHeader=new List<RSD_Quote_Header__c>();
                for(Id qHeaderIds:lstQuoteHeaderId)
                {
                    RSD_Quote_Header__c qHeader=new RSD_Quote_Header__c(Id=qHeaderIds);
                    qHeader.RSD_Opportunity__c = opp.id;
                    lstQuoteHeader.add(qHeader);
                }
                
                if(!lstQuoteHeader.isEmpty())
                {
                    update lstQuoteHeader;
                }
                                
                System.debug(lstQuoteHeaderId);    
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Should Select atleast one record'));
                return null;
            }
        }
        catch(Exception e){
        
            system.debug(e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
            Database.rollback(sp);
            return null;
        }        
        pageReference pg=new PageReference('/'+opp.Id);
        pg.setRedirect(true); 
        return pg;
    }
    
    public pageReference btncancel()
    {
        PageReference pg=new PageReference('/'+Apexpages.currentPage().getParameters().get('Id'));
        pg.setRedirect(true);
        return pg;
    }
    
    
    public PageReference sortPage()
    {
        getQuoteHeaderList();
        return null;
    }
    
    public List<QuoteHeaders> getQuoteHeaderList()
    {   
        try{
        //RSD_Opportunity__c = NULL AND     
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        if(sortExpression =='RSD_Opportunity__c')
        {
           sortFullExp = 'RSD_Opportunity__r.Name'+ ' ' + sortDirection;
        }
        
        String queryValue='SELECT Account__c,CreatedById,CreatedDate,CurrencyIsoCode,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,'
                           +'RSD_Caller__c,RSD_Customer_PO__c,RSD_MF_Created_Date__c,RSD_MF_Quote_Status__c,RSD_Opportunity__c,RSD_Opportunity__r.Name,RSD_Order_Number__c,RSD_Preparer__c,RSD_Primary_External_Id__c,'
                           +'RSD_Quote_Status__c,RSD_Total_Cost__c,RSD_Total_Gross_Profit_Pct__c,RSD_Total_List_Price__c,RSD_Total_Price__c FROM RSD_Quote_Header__c WHERE Account__c = ' + '\'' + acc.Id + '\'';
                          
        if(String.isNotEmpty(searchText))
        {
            System.debug(searchText);
            queryValue +=' AND Name LIKE ' + '\'' + searchText + '%' + '\'';
        }
        
        if(sortFullExp != null)
        {
            queryValue += ' ORDER BY ' + sortFullExp +' NULLS FIRST';
        }
        System.debug(queryValue);
        lstQuoteHeaders = new List<QuoteHeaders>();
        for (RSD_Quote_Header__c headers : (List<RSD_Quote_Header__c>)Database.query(queryValue))
            lstQuoteHeaders.add(new QuoteHeaders(headers));
 
        return lstQuoteHeaders; 
        }catch(Exception e)
        {
            system.debug(e.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));
            return null;
        }                 
    }
    
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.RSD_Quote_Header__c.FieldSets.RSD_Create_Opportunity.getFields();
    }

}