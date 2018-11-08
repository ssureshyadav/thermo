/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 27 April,2017
    Requirement : W-000071 : T-00286: RSDNA-0037: IDIR Change to Close-Won without Quote
    Description : 
                -- Creates a roll up logic to give the total count of avaliable Quote Headers associated to an Opportunity
    Test Class  : 
    Last Updated By :Venkatesh
    
*/

public class RSDNA_GetCountofQuoteonOpportunity{
    
    public void getQuoteCount(List<RSD_Quote_Header__c> getQuoteHeader){
        system.debug('The value of getQuoteHeader-------------->'+getQuoteHeader);
        Set<id> getOppID = new Set<id>();
        List<Opportunity> updateOpportunity = new List<Opportunity>();
        Map<ID,Integer > getQuoteCount =  new Map<ID,Integer > ();
            if(!getQuoteHeader.isEmpty()){
                for(RSD_Quote_Header__c quoteHeader : getQuoteHeader){
                    if(quoteHeader.RSD_Opportunity__c != Null){
                    getOppID.add(quoteHeader.RSD_Opportunity__c );                  
                    }
            }       
        }

        if(!getOppID.isEmpty()){
        //Delete the OpportunityLineItems which does having RSD_Quote_Line_Item__c as NULL 
        DELETE [SELECT ID from OpportunityLineItem Where OpportunityId IN:getOppID and RSD_Quote_Line_Item__c =''];   
            for(Opportunity opp: [select id,name,(select ID from Quote_Headers__r) from opportunity Where Id IN : getOppID]){
            system.debug('COUNT for each quoteHeader associated----->'+ opp.Quote_Headers__r.Size() );
                    if(opp.Quote_Headers__r.Size() != 0){
                    opp.RSD_Quote_Header_Count__c = opp.Quote_Headers__r.Size();
                    updateOpportunity.add(opp); 
                    }
            }  
        }        
        System.debug('The value of updateOpportunity----------------->'+updateOpportunity);

        try{
        if(!updateOpportunity.isEmpty()){
        // DML statement
        Database.update(updateOpportunity, false);
         }else{
         System.debug('There are no records for update'); 
        }
        }catch(dmlexception e){
        System.debug('The following exception has occured-->'+e);     
        }

    }    
}