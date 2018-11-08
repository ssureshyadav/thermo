trigger OpportunityTrigger on Opportunity (before update) {
    if(trigger.isBefore && trigger.isUpdate){
    
        Map<Id, Opportunity> oldOppMap = (Map<Id, Opportunity>) Trigger.oldMap;
        Set<Id> oppId = new Set<Id>();
        Id pccOppRecordType = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('PCC Opportunity').getRecordTypeId();
        for(Opportunity newOpp: trigger.new){
            Opportunity oldOpp = oldOppMap .get(newOpp.Id);
            if(newOpp.PCC_Sub_Stage__c != oldOpp.PCC_Sub_Stage__c && newOpp.PCC_Sub_Stage__c=='Qualification' && newOpp.RecordTypeId == pccOppRecordType && (newOpp.PCC_Revenue_Type__c == 'Mix' || newOpp.PCC_Revenue_Type__c == 'Services')){
                System.debug('Jomark Test oppId: ' + oppId);
                oppId.add(newOpp.Id);        
            }
        }
        
        Map<Id, OpportunityLineItem> oppItemMap = new Map<Id, OpportunityLineItem>();
        for(OpportunityLineItem o: [SELECT OpportunityId, Product2.Family FROM OpportunityLineItem WHERE OpportunityId IN: oppId AND Product2.Family = 'Services']){
            oppItemMap.put(o.OpportunityId, o);
        }
    
        for(Opportunity newOpp: trigger.new){
            Opportunity oldOpp2 = oldOppMap .get(newOpp.Id);
            if(newOpp.PCC_Sub_Stage__c != oldOpp2.PCC_Sub_Stage__c && newOpp.PCC_Sub_Stage__c=='Qualification' && newOpp.RecordTypeId == pccOppRecordType && (newOpp.PCC_Revenue_Type__c == 'Mix' || newOpp.PCC_Revenue_Type__c == 'Services')){
                if(oppItemMap.get(newOpp.Id) == null){
                    newOpp.addError('PCC: If Revenue Type is Services or Mix, it needs to have a Service Product Category'); 
                }                 
            }
        }
    }
}