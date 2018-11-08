/*
    Created By  : Venkatesh Kumar
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 24 April,2017
    Description : Creates a Quote Header and test the Quote Purge functioanlity developed to handle Inactive Quote records via batch class .
    Test Class for: RSDNA_DeleteArchievedQuotes_BATCH and RSDNA_DeleteArchievedQuotesBatchSchedule
*/
@isTest(SeeAlldata=true)
private class RSDNA_DeleteArchievedQuotesBatchTest{
    static TestMethod void runBatchToPurgeQuote(){
        id oppID;
        RSDNA_DataFactory data=new RSDNA_DataFactory(); 
        //data.orgSpecificSetting();              
        Test.startTest();
        //List<Account> lstAccount=data.insertAccount(1,Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
         Account acc=new Account(Name ='data 1', recordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
         insert acc;        
        List<Opportunity> lstOpp = data.insertOpportunities(1,Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId(), acc.id);
        
        RSD_Quote_Header__c  quoteHeader = data.insertQuoteHeader(acc.Id,'Inactive');
        delete data.insertQuoteHeader(1,acc.Id,lstOpp[0].Id);
        
        system.debug('The value of quoteHeader------>'+quoteHeader);
        // calling the batch call
        Database.executeBatch(new RSDNA_DeleteArchievedQuotesBatch());
        //Call the static method directly
        RSDNA_DeleteArchievedQuotesBatchSchedule runSchedule = new RSDNA_DeleteArchievedQuotesBatchSchedule();    
        String sch = '0  00 1 3 * ?';
        system.schedule('Run Batch for Test', sch, runSchedule);
        Test.stopTest();
      }
}