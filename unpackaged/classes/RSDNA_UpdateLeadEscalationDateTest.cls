/*
    Created By  : Ajay Kumar
    Email ID    : pendelavenkatabaji.ajaykumar@nttdata.com    
    Company     : NTTDATA
    Date        : 20 June,2017
    Requirement : W-000184:T-00375: Dev 
    Test Class for Batch  : RSDNA_UpdateLeadEscalationDate1,RSDNA_UpdateLeadEscalationDate2
    Last Updated By : 
    
*/
@isTest
private class RSDNA_UpdateLeadEscalationDateTest {
    
    @isTest
    private static void test(){
       
        List<Lead> leads = new List<Lead>();
        Id recordtypeId=Schema.SobjectType.Lead.getRecordTypeInfosByName().get('RSDNA Leads').getRecordTypeId();
        Lead l1 = new Lead(FirstName = 'firstname1', LastName = 'lastname1', Email ='test1@gmail.com', Company='Testing',RSDNA_Lead_Stage__c='MQL',recordtypeID=recordtypeId,
                  Street='3197 Diamond Cove Providence',StateCode ='NY' , CountryCode ='US',PostalCode ='2908',RSDNA_MQL_Date__c=Date.today().addDays(-4));
                  
        Lead l2 = new Lead(FirstName = 'firstname2', LastName = 'lastname2', Email ='test2@gmail.com', Company='Testing',RSDNA_Lead_Stage__c='MQL',recordtypeID=recordtypeId,
                  Street='3197 Diamond Cove Providence',StateCode ='NY' , CountryCode ='US',PostalCode ='2908',RSDNA_MQL_Date__c=Date.today().addDays(-6));               
        Lead l3 = new Lead(FirstName = 'firstname3', LastName = 'lastname3', Email ='test2@gmail.com', Company='Testing',RSDNA_Lead_Stage__c='MQL',recordtypeID=recordtypeId,
                  Street='3197 Diamond Cove Providence',StateCode ='NY' , CountryCode ='US',PostalCode ='2908',RSDNA_MQL_Date__c=Date.today().addDays(-2));     
        leads.add(l1);                
        leads.add(l2);
        leads.add(l3);
        insert leads;
       // System.debug('Lead Inserted ----->'+l1.id);
        
        test.starttest();
             Database.executeBatch(new RSDNA_UpdateLeadEscalationDate1());   
        test.stoptest();
    }

}