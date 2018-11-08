public class RSDNA_UpdateQuoteCountonOppty{
    
    public void updQuoteCount(List<RSD_Quote_Header__c> lstQuoteHeader,Map<Id,RSD_Quote_Header__c> oldQuoteHeader){
        
        Map<Id,Integer> mapOppty=new Map<Id,Integer>();
        if(lstQuoteHeader != null)
        for(RSD_Quote_Header__c qHeader : lstQuoteHeader)
        {
            if((oldQuoteHeader == null && qHeader.RSD_Opportunity__c != null))
            {
                if(mapOppty.containsKey(qHeader.RSD_Opportunity__c))
                {
                    mapOppty.put(qHeader.RSD_Opportunity__c,mapOppty.get(qHeader.RSD_Opportunity__c)+1);
                }else{
                    mapOppty.put(qHeader.RSD_Opportunity__c,1);
                }
            }
            
            if(qHeader.RSD_Opportunity__c != oldQuoteHeader.get(qHeader.Id).RSD_Opportunity__c)
            {
                if(qHeader.RSD_Opportunity__c != null)
                {
                    if(mapOppty.containsKey(qHeader.RSD_Opportunity__c))
                    {
                        mapOppty.put(qHeader.RSD_Opportunity__c,mapOppty.get(qHeader.RSD_Opportunity__c)+1);
                    }else{
                        mapOppty.put(qHeader.RSD_Opportunity__c,1);
                    }
                }
                
                if(oldQuoteHeader.get(qHeader.Id).RSD_Opportunity__c != null)
                {
                    if(mapOppty.containsKey(oldQuoteHeader.get(qHeader.Id).RSD_Opportunity__c))
                    {
                        mapOppty.put(oldQuoteHeader.get(qHeader.Id).RSD_Opportunity__c,mapOppty.get(oldQuoteHeader.get(qHeader.Id).RSD_Opportunity__c)-1);
                    }else{
                        mapOppty.put(oldQuoteHeader.get(qHeader.Id).RSD_Opportunity__c,-1);
                    }
                }
            }
        }
        
        if(lstQuoteHeader == null)
        {
            for(RSD_Quote_Header__c qHeader:oldQuoteHeader.values())
            {
                if(qHeader.RSD_Opportunity__c != null)
                {
                    if(mapOppty.containsKey(qHeader.RSD_Opportunity__c))
                    {
                        mapOppty.put(qHeader.RSD_Opportunity__c,mapOppty.get(qHeader.RSD_Opportunity__c)-1);
                    }else{
                        mapOppty.put(qHeader.RSD_Opportunity__c,-1);
                    }
                }
            }
        }
        
        if(!mapOppty.isEmpty())
        {
            List<Opportunity> lstupdOppty=new List<Opportunity>();
            DELETE [SELECT ID from OpportunityLineItem Where OpportunityId IN:mapOppty.keySet() and RSD_Quote_Line_Item__c ='']; 
            for(Opportunity opty:[Select Id,RSD_Quote_Header_Count__c from Opportunity Where ID IN : mapOppty.keySet()])
            {
                Opportunity opp=new Opportunity(Id=opty.Id,RSD_Quote_Header_Count__c =opty.RSD_Quote_Header_Count__c != null?opty.RSD_Quote_Header_Count__c+ mapOppty.get(opty.Id) : mapOppty.get(opty.Id));
                lstupdOppty.add(opp);
            }
            
            if(!lstupdOppty.isEmpty())
            {
                update lstupdOppty;
            }
        }
    }
}