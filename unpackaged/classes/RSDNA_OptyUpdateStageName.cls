/*
    Created By  : Ajay Kuamr Pendela
    Email ID    : Pendelavenkatabaji.Ajaykumar@nttdata.com
    Company     : NTTDATA
    Date        : 20 April,2017
    Requirement : W-000074 : T-00039
    Description : The rule should be Not to allow users to update Opportunity Stage to 'Proposal/Quote/Solution', 'Next Steps/Decision Due', 'Closed Won' 
                  When no Active Quote Headers AND no contact role associated with the opportunity.
                  When no contact role associated with the opportunity for the profiles like RSD NA IDIR, RSD NA Specialist, RSD NA Sales Operations User
    Test Class  : RSDNA_OptyUpdateStageNameTest
    Last Updated By : Ajay on 05 May 2017
    
*/

public class RSDNA_OptyUpdateStageName {
        
    public void OptyStageNameUpdate(List<Opportunity> oppList,Map<id,Opportunity> oldMap){
        
    List<Opportunity> lstOptyIds=new List<Opportunity>();
        Profile userProfile= [SELECT Id,Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        RSD_Profiles__c RSDProfileIds = RSD_Profiles__c.getInstance();
        /*set<Id> RSDProfileIdsSet = new set<Id>{RSDProfileIds.RSD_NA_Sales_Operations_User__c,
                                                RSDProfileIds.RSD_NA_Specialist__c,
                                                RSDProfileIds.RSD_NA_IDIR__c};*/
         set<string> RSDProfileNameSet = new set<string>{'RSD NA Sales User','RSD NA Sales Operations User','RSD NA Manager-IDIR','RSD NA Specialist'};

        //Get list of Opportunities which meets the condition StageName is 'Proposal/Quote/Solution', 'Next Steps/Decision Due', 'Closed Won' AND opty.RecordType is 'RSD NA Opportunity'
    for(Opportunity opty:oppList){
            
            if(opty.StageName != oldMap.get(opty.id).StageName && (opty.StageName=='Proposal/Quote/Solution' || opty.StageName=='Next Steps/Decision Due' || opty.StageName=='Closed Won') && opty.RecordTypeId==Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('RSD NA Opportunity').getRecordTypeId()){
                lstOptyIds.add(opty);
            }
    }
        //List of Opportunities which meets the condition StageName is 'Proposal/Quote/Solution' AND opty.RecordType is 'RSD NA Opportunity'
        if(!lstOptyIds.isEmpty())
        {
            Map<Id,Id> mapOptyProd=new Map<Id,Id>();
            Map<Id,Id> mapOptyQuoteHeader=new Map<Id,Id>();
            map<Id,Id> mapOptyCont=new Map<Id,Id>();
            //Get the Quote Header, OportunityProduct and Contact Roles for the Opportunity
            List<OpportunityLineItem> optyProducts = [SELECT Id,OpportunityId from OpportunityLineItem WHERE OpportunityId IN :lstOptyIds];
            List<RSD_Quote_Header__c> optyQuoteHeader = [SELECT Id,RSD_Opportunity__c  FROM RSD_Quote_Header__c WHERE RSD_Opportunity__c IN :lstOptyIds];
            List<OpportunityContactRole> optyContacts = [SELECT Id,OpportunityId FROM OpportunityContactRole where OpportunityId IN : lstOptyIds];
            
            system.debug('------Products count-----'+optyProducts.size());
            system.debug('------Quote Header count-----'+optyQuoteHeader.size());
            system.debug('------Contact Roles count-----'+optyContacts.size());
            
            for(RSD_Quote_Header__c item:optyQuoteHeader)
            {
                
                mapOptyQuoteHeader.put(item.RSD_Opportunity__c,item.Id);
            }
           
            for(OpportunityContactRole item:optyContacts)
            {
                mapOptyCont.put(item.OpportunityId,item.Id);
            }

            system.debug('------Products count-----'+optyProducts.size());
            
            for(OpportunityLineItem item:optyProducts)
            {
                
                mapOptyProd.put(item.OpportunityId,item.Id);
            }            
            //Check Condition no Quote AND there is no contact role associated with the opportunity, then display Error message
                  
            for(Opportunity opp:lstOptyIds)
            {
                /*if(userProfile.Name == 'RSD NA Sales User' && (!(mapOptyQuoteHeader.containsKey(opp.Id)) || !(mapOptyCont.containsKey(opp.Id)) || !(mapOptyProd.containsKey(opp.Id))))
                {
                    opp.StageName.addError('Opportunity Stage cannot be moved beyond ‘Qualify/Open/Needs’ without an associated Product, Quote and Contact Role.');
                }*/
                
                if(RSDProfileNameSet.contains(userProfile.Name) && (!(mapOptyProd.containsKey(opp.Id)) || !(mapOptyCont.containsKey(opp.Id))))
                {
                    opp.StageName.addError('Opportunity Stage cannot be moved beyond ‘Qualify/Open/Needs’ without an associated Product and Contact Role.');
                }
            }
        }
        
    }

}