/*
    Created By  : Venkatesh Kumar
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 27 April,2017
    Description : 
    Test Class for: RSDNA_UpdateProductfrQuoteBatch and RSDNA_UpdateProductfrQuoteBatchSchedule
*/
@isTest
private class RSDNA_UpdateProductfrQuoteBatchTest{
    static TestMethod void updateOrderNoProdLI(){
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        data.orgSpecificSetting();    
        data.orgRecordTypes();   
        
        RSD_Batch_Settings__c bSettings=new RSD_Batch_Settings__c(Name ='UpdateOpptyProductOrderNumberBatch',RSD_Last_Successful_Run_Date__c = System.today()-1);
        insert bSettings;
               
        
        List<Account> lstAccount=data.insertAccount(1,null);
        List<Opportunity> lstOpportunity=data.insertOpportunities(1,Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').recordTypeId,lstAccount[0].Id);
        List<RSD_Quote_Header__c> lstQuoteHeader=data.insertQuoteHeader(1,lstAccount[0].Id,null);
        lstQuoteHeader[0].RSD_Opportunity__c =lstOpportunity[0].Id;
        update lstQuoteHeader[0];
            
        OpportunityLineItem getProdItem = data.insertOppProduct(lstOpportunity[0].Id);
        //RSD_Quote_Header__c quoteHeader = data.insertQuoteHeader(getProdItem.OpportunityID,'Active');
        
        Pricebook2 customPB = new Pricebook2(Name='RSD NA', isActive=true);
        insert customPB;
        
        RSD_Quote_Line_Item__c QuoteLI = new RSD_Quote_Line_Item__c(
        Quote__c = lstQuoteHeader[0].ID,CurrencyIsoCode = 'USD',RSD_CMT_Level2_Code__c = '10001',RSD_CMT_Level3_Code__c = '10146',RSD_Order_Number__c = '12345', RSD_Quantity__c = 1,RSD_Unit_Price__c = 100 );
        insert QuoteLI;
        
             
        
        //getProdItem.RSD_Quote__c = lstQuoteHeader[0].ID;
        //getProdItem.RSD_Quote_Line_Item__c = QuoteLI.ID;        
        //Update getProdItem;     
        
        
        
        // calling the batch call
        Database.executeBatch(new RSDNA_UpdateProductfrQuoteBatch());
        //Call the static method directly
        RSDNA_UpdateProductfrQuoteBatchSchedule runSchedule = new RSDNA_UpdateProductfrQuoteBatchSchedule();    
        String sch = '0  00 1 3 * ?';
        system.schedule('Run Batch for Test', sch, runSchedule);
        
      }
}