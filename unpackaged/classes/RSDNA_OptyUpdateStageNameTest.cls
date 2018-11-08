/*
    Created By  : Ajay Kumar Pendela
    Email ID    : Pendelavenkatabaji.Ajaykumar@nttdata.com
    Company     : NTTDATA
    Date        : 20 April,2017
    Description : Testing the apex class written for W-000074 : T-00039
    Test Class for: RSDNA_OptyUpdateStageName
*/

@isTest
private class RSDNA_OptyUpdateStageNameTest {
    
     @isTest static void updateStageName(){
         
         System.debug('----In Test Class Execution');
         
         RSDNA_DataFactory data=new RSDNA_DataFactory(); 
         data.orgSpecificSetting();
         data.orgRecordTypes();
         List<Account> acc=data.insertAccount(1, Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId());
         List<Opportunity> opty = data.insertOpportunities(2,Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId(),acc[0].id); 
         System.debug('----Opty created----'+opty[0]);                 
         RSD_Quote_Header__c optyQuoteHeader1=data.insertQuoteHeader(acc[0].Id, 'Active');  
         List<Contact> con = data.insertContact(1, Schema.SObjectType.Contact.getRecordTypeInfosByName().get('RSD NA Contact').getRecordTypeId() , acc[0].id);
         OpportunityContactRole optyCont1 = data.insertOptyContactRole(con[0].id,opty[0].Id); 
         System.debug('-----Opty Contact Created----'+optyCont1);      
         Opportunity optyUpdate = new Opportunity(Id=opty[0].Id, StageName='Proposal/Quote/Solution');
         //Create Opportunity Product
         OpportunityLineItem optyPdt1 = data.insertOppProduct(opty[0].Id);
         System.debug('----OptyItem---'+optyPdt1);
         
         try{
             Update optyUpdate;
             System.debug('----Opty Updated-----');
         }
         catch(Exception e){            
             System.debug('In Exception');             
         }
            
     }

}