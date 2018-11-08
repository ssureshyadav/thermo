/*
Created By :Kuldeep
Email ID : kulrathore@deloitte.co.uk    
Company : Deloitte
Date : 08/07/2015
Test Class for Class team_members
*/
@isTest(SeeAllData = true)
private class team_members_Test{
    static testmethod void team_members_test(){
        Id RSDRecordType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD CBP').getRecordTypeId();
        Account acc = new Account(name= 'Test',RSD_Customer_Flag__c = 'Direct',RSD_Customer_Type__c='Reseller', RecordTypeId = RSDRecordType);
        insert acc;
        
         // start the test execution context
        Test.startTest();

        // set the test's page to your VF page (or pass in a PageReference)
        Test.setCurrentPage(Page.ParentAccounteammember);

        // call the constructor
        team_members controller = new team_members(new ApexPages.StandardController(acc));

        // stop the test
        Test.stopTest();
        
        }
        
}