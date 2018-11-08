@isTest(SeeAllData = true)
private class OpportunityTriggerTest {

    
    @isTest static void testUpdate() {
        
        
        User u = [Select Id FROM User WHERE Profile.Name = 'PCC Warehouse' AND IsActive = true LIMIT 1];
        
        Id TestRecId = [Select Id from RecordType where DeveloperName =: 'PCC_New_Customer' AND SObjectType =: 'Account'].Id;
        Account testAccount = new Account(Name = 'TestAcc', RecordTypeId = TestRecId);
        insert testAccount;
        
        Id oppRecTypeId = [Select Id from RecordType where DeveloperName =: 'PCC_Opportunity' AND SObjectType =: 'Opportunity'].Id;
        
        Opportunity opp = new Opportunity(Name = 'Test',
                                          RecordTypeId = oppRecTypeId,
                                          PCC_Sub_Stage__c = 'Identification',
                                          PCC_Revenue_Type__c = 'Mix',
                                          AccountId = testAccount.Id,
                                          PCC_Opportunity_Phase__c = 'Commercial',
                                          PCC_Opportunity_Source__c = 'Sales',
                                          PCC_Segment__c = 'Life Science',
                                          PCC_Distributor_Type__c = 'New',
                                          PCC_Product_Type__c = 'Existing Product',
                                          CloseDate = System.today(),
                                          StageName = 'Assessment');
  
        test.startTest();
            insert opp;
            opp.PCC_Sub_Stage__c = 'Qualification';
            try{
               update opp;
            }
            catch(Exception e){
               System.debug(opp.PCC_Sub_Stage__c);
            }
        test.stopTest();
    }
}