@isTest(SeeAllData = true)
private class AutoQuoteDashboardController_Test {

  @isTest static void vewData(){
        
        /*Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD CBP').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account', RecordTypeId = accRecType, AccountSource = 'Migrated', RSD_Active__c = true);
        insert acc;*/
        
        Id TestRecId = [Select Id from RecordType where DeveloperName =: 'RSD_CBP' AND SObjectType =: 'Account'].Id;
        Account TestAccount = new Account(Name = 'TestAcc', RecordTypeId = TestRecId);
        insert TestAccount;
        
        
        Id oppRecType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RSD EU').getRecordTypeId();
        Opportunity opp = new Opportunity(Name = 'AutoQuote: DummyOpportunity', 
                                          RecordTypeId = oppRecType, 
                                          AccountId = TestAccount.Id, 
                                          Type = 'New Customer', 
                                          CloseDate = Date.today() + 2,
                                          StageName = 'Assessment',
                                          RSD_Opportunity_Sub_Type__c = 'Quote');
        
        insert opp;
        
        test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='test123t@exa.aaa', 
            EmailEncodingKey='UTF-8', LastName='test', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test123t@exa.aaa', Sales_ID__c = 'RM000000');
            
        System.runAs(u) {
               
            PageReference pageRef = Page.AutoQuoteDashboardPage;
            Test.setCurrentPage(pageRef);
            AutoQuoteDashboardController controller = new AutoQuoteDashboardController();
                 
        }
        
        test.stopTest();
        
   }
   
   @isTest static void noData(){
        
        /*Id accRecType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD CBP').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account', RecordTypeId = accRecType, AccountSource = 'Migrated', RSD_Active__c = true);
        insert acc;*/
        
        test.startTest();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='test123t@exa.aaa', 
            EmailEncodingKey='UTF-8', LastName='test', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='test123t@exa.aaa', Sales_ID__c = 'RM000000');
            
        System.runAs(u) {
        
            
            
                PageReference pageRef = Page.AutoQuoteDashboardPage;
                Test.setCurrentPage(pageRef);
                AutoQuoteDashboardController controller = new AutoQuoteDashboardController();
                   
            
        }
        
        test.stopTest();
        
   }

}