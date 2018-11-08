/*
    Created By  : Ajay Kumar
    Email ID    : pendelavenkatabaji.ajaykumar@nttdata.com    
    Company     : NTTDATA
    Date        : 20 June,2017
    Requirement : W-000184:T-00375: Dev 
    Test Class  : 
    Last Updated By : 
    
*/

global class RSDNA_UpdateLeadEscalationDate2 implements Database.Batchable<sObject>, Database.Stateful{
          
    global Database.QueryLocator start(Database.BatchableContext BC){
		integer n=4;
        string day_week = system.now().format('E');
        if(day_week == 'Mon'|| day_week == 'Tue' || day_week == 'Wed' || day_week == 'Thu'||Test.isRunningTest()){
           n=6;
        }
        DateTime d=System.now()-n;
        string query='SELECT Id,RSD_Escalation_Date_2__c FROM Lead WHERE RSD_Escalation_Date_2__c=NULL and RSDNA_Lead_Stage__c=\'MQL\' and Status=\'New\' and RSDNA_MQL_Date__c <=:d';
        return Database.getQueryLocator(query);
    }
    
    // Processing the scope   
    global void execute(Database.BatchableContext BC, List<Lead> scope){
        
       		
		List<Lead> lstUpdateLeads = new List<Lead>();
		
		for(Lead lead : scope){
			Lead updateLead = new Lead();
			updateLead.Id = lead.Id;
			updateLead.RSD_Escalation_Date_2__c = system.now();
			lstUpdateLeads.add(updateLead);
		}
		
		if(!lstUpdateLeads.isEmpty()){
			Update lstUpdateLeads;		
		}	
		
	}
	
	 global void finish(Database.BatchableContext BC){
    }
	
	
}