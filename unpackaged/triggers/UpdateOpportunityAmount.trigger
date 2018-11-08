trigger UpdateOpportunityAmount on OpportunityLineItem (after insert, after update) {
    List<Id> lstOppIDs = new List<Id>();
    for(OpportunityLineItem oli: Trigger.new) {
        lstOppIDs.add(oli.OpportunityId);
    }
    
    Map<Id, Opportunity> mapOpportunity = new Map<Id, Opportunity> ([SELECT Id, Name, Amount FROM Opportunity
                                                                    WHERE Id =:lstOppIDs]);
    
    List<Opportunity> lstOpportunities = new List<Opportunity>();
    for(AggregateResult result: [SELECT SUM(TotalPrice) Amt, OpportunityId FROM OpportunityLineItem
                                 GROUP BY OpportunityId HAVING OpportunityId IN :mapOpportunity.keyset()]) {
                                     Opportunity opp = mapOpportunity.get((ID)result.get('OpportunityId'));
                                     opp.Amount = (Decimal)result.get('Amt');
                                     lstOpportunities.add(opp);
                                 }
    if(lstOpportunities.size() > 0) {
        update lstOpportunities;
    }

}