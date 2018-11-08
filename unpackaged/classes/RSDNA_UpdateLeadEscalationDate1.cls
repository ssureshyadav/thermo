/*
    Created By  : Ajay Kumar
    Email ID    : pendelavenkatabaji.ajaykumar@nttdata.com    
    Company     : NTTDATA
    Date        : 20 June,2017
    Requirement : W-000184:T-00375: Dev 
    Test Class  : RSDNA_UpdateLeadEscalationDateTest
    Last Updated By : 
    
*/

global class RSDNA_UpdateLeadEscalationDate1 implements Database.Batchable<sObject>, Database.Stateful{
          string day_week='';
    global Database.QueryLocator start(Database.BatchableContext BC){
        integer n=2;
        
       day_week = system.now().format('E');
        if(day_week == 'Mon' || day_week == 'Tue' || Test.isRunningTest()){
           n=4;
        }
        
        DateTime d=System.now()-n;
        
        //System.debug('----->Date '+d);
        
        string query='SELECT Id,RSD_Escalation_Date_1__c FROM Lead WHERE RSD_Escalation_Date_1__c=NULL and RSDNA_Lead_Stage__c=\'MQL\' and Status=\'New\' and RSDNA_MQL_Date__c <=:d';
        //System.debug('--->Query '+query);
       
        return Database.getQueryLocator(query);
    }
    
    // Processing the scope   
    global void execute(Database.BatchableContext BC, List<Lead> scope){
        
       // System.debug('-->Scope '+scope);
        
        List<Lead> lstUpdateLeads = new List<Lead>();
        
        for(Lead lead : scope){
            Lead updateLead = new Lead();
            updateLead.Id = lead.Id;
            updateLead.RSD_Escalation_Date_1__c = system.now();
            lstUpdateLeads.add(updateLead);
        }
        
        if(!lstUpdateLeads.isEmpty()){
            Update lstUpdateLeads;          
        }   
        
    }
    
     global void finish(Database.BatchableContext BC){
       database.executebatch(new RSDNA_UpdateLeadEscalationDate2());
    }
    
    
}