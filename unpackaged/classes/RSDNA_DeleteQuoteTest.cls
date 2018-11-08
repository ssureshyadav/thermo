/*
Test Class For RSDNA_UpdateQuoteCountonOppty
*/
@isTest
private class RSDNA_DeleteQuoteTest
{
    @isTest
    static void deleteQuotes()
    {
        RSDNA_DataFactory dataCreation=new RSDNA_DataFactory();
        dataCreation.orgRecordTypes();
        List<Account> lstAccount=dataCreation.insertAccount(1,null);
        List<Opportunity> lstOpportunity=dataCreation.insertOpportunities(1,Schema.SobjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').recordTypeId,lstAccount[0].Id);
        //dataCreation.insertOptyProduct();
        delete dataCreation.insertQuoteHeader(1,lstAccount[0].Id,lstOpportunity[0].Id);
        
    }
}