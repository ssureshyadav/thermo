/*
    Created By  : Venkatesh Kumar
    Email ID    : VenkateshKumar.Sakthivel@nttdata.com   
    Company     : NTTDATA
    Date        : 19 April,2017
    Description : W-000079 : RSDNA-0046: Delete Quotes marked as 'PURGED' from mainframe
                   - Check for the Quotes not related to any Opportunity
                   - Check for Quote status as Inactive and Current Date - Quote Last Modified Date > Days specified in the ‘Quote Retention Days’ Custom Setting
                   - Delete all the Quotes matching the above condition.
    Test Class  : RSDNA_DeleteArchievedQuotesBatchTest
*/
 
global class RSDNA_DeleteArchievedQuotesBatch implements Database.Batchable<sObject> {
 
    global Database.QueryLocator start(Database.BatchableContext BC){
        //RSD_Opportunity_Settings__c archievRec = RSD_Opportunity_Settings__c.getValues('Archive Quote');
        RSD_Opportunity_Settings__c archievRec = RSD_Opportunity_Settings__c.getInstance(); 
        decimal archValue = archievRec.RSD_Quote_Retention_Days__c;
        date getArchivedate = date.today().adddays(- integer.valueof(archValue)); 

        return Database.getQueryLocator([SELECT Id,LastModifiedDate FROM RSD_Quote_Header__c WHERE RSD_Opportunity__c = Null AND RSD_Quote_Status__c = 'Inactive' and LastModifiedDate >: getArchivedate ]);
    }
 
    global void execute(Database.BatchableContext BC, List<RSD_Quote_Header__c> scope) {
    List<RSD_Quote_Header__c>  quoteHeaderLST = new List<RSD_Quote_Header__c> ();
    system.debug('The value of scope------------->'+scope);       
        if(!scope.isEmpty()){
        quoteHeaderLST.addall(scope);    
        system.debug('The value of quoteHeaderLST------------->'+quoteHeaderLST); 
        }
            try{               
                if(!quoteHeaderLST.isEmpty()){
                // DML statement
                delete quoteHeaderLST;
                }
                else{
                     System.debug('There are no records for update'); 
                }
            }catch(dmlexception e){
                System.debug('The following error has occred---->'+e); 
            }                    
    }

    global void finish(Database.BatchableContext BC) {
    }
 }