/*
Created By :Kuldeep
Company : Deloitte
Date : 08/07/2015
Test Class For Trigger Annual_labspend_Rollup 
*/
@isTest(seeAllData=true)
Private Class Annual_labspend_Rollup_Test { 

    //this first method is for covering the SetAccountOwnerTrigger, Created by: Jorn van der Steen, Company: Endowance Solutions
    static Testmethod void SetAccountOwnerTest(){
        RecordType TheInforceRec = [Select id from RecordType where SObjectType = 'Account' AND RecordType.DeveloperName = 'inforceaccountrectype'];
        Account SetAccountOwnerTestAcc = new Account(name = 'SetAccOwnerTest', PCC_Customer_Type__c = 'Existing', PCC_Sales_Rep_1_Code__c = '1', RecordTypeId = TheInforceRec.Id);
        insert SetAccountOwnerTestAcc;
    }
    /*
static Testmethod void Annual_labspend_Rollup_Test(){       
    
        Account acc = new Account(name= 'Test',RSD_Customer_Flag__c = 'Direct',RSD_Customer_Type__c='Reseller', Type='Debtor');
        insert acc;
        
        Account acc1 = new Account(name= 'Test',RSD_Customer_Flag__c = 'Direct',RSD_Customer_Type__c='Reseller', Parentid=acc.id);
        insert acc1;
        
        Account acc2 = new Account(name= 'Test',RSD_Customer_Flag__c = 'Direct',RSD_Customer_Type__c='Reseller', ParentId = acc.id);
        insert acc2;
        
        Opportunity opp = new Opportunity(Name='Test Opp',Accountid=acc1.id,Type='New Customer',RSD_Opportunity_Sub_Type__c='Grant',CloseDate=System.today(),Stagename='Assessment'); 
        insert Opp;
        
        Opportunity opp1 = new Opportunity(Name='Test Opp',Accountid=acc1.id,Type='New Customer',RSD_Opportunity_Sub_Type__c='Grant',CloseDate=System.today(),Stagename='Assessment'); 
        insert Opp1;
        
        Opportunity opp2 = new Opportunity(Name='Test Opp',Accountid=acc2.id,Type='New Customer',RSD_Opportunity_Sub_Type__c='Grant',CloseDate=System.today(),Stagename='Assessment'); 
        insert Opp2;
        
        Pricebook2 pb22 = new Pricebook2(Name='testDIE');
        insert pb22;

        Product2 pro2 = new Product2(Name='BXCD', isActive=true);
        insert pro2;
        
        PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(),
                                                 isActive=true,UseStandardPrice = false);
         insert pbe2;
        
         OpportunityLineItem OPplineitem2 = new OpportunityLineItem (Quantity=1, OpportunityId=opp.Id,UnitPrice=0.01,PriceBookEntryId=pbe2.Id);
         insert OPplineitem2;
         
         OpportunityLineItem OPplineitem3 = new OpportunityLineItem (Quantity=1, OpportunityId=opp1.Id,UnitPrice=0.11,PriceBookEntryId=pbe2.Id);
         insert OPplineitem3;
         
         OpportunityLineItem OPplineitem4 = new OpportunityLineItem (Quantity=1, OpportunityId=opp2.Id,UnitPrice=200,PriceBookEntryId=pbe2.Id);
         insert OPplineitem4;
    } */
}