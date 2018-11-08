/*
    Created By  : Suresh Sanneboina
    Email ID    : sanneboinasuresh.yadav@nttdata.com    
    Company     : NTTDATA
    Date        : 31 May,2017
    Description : To delete opportunity line items related to quote and relation with opportunity
                  W-000178:RSDNA-0080: Remove Quote and Opportunity Lines from an Opportunity
    Test Class  :RSDNA_SearchQuotesTest
    
*/
public Class RSDNA_LtngRemoveQuoteFromOpportunity
{
    @auraEnabled
    public static String removeOpportunity(id recordId)
    {
        try{
            RSD_Quote_Header__c qHeader=[Select Id,RSD_Opportunity__c from RSD_Quote_Header__c Where ID = : recordId];
            if(qHeader.RSD_Opportunity__c != null)
            {
                delete [Select Id from OpportunityLineItem Where RSD_Quote__c = : recordId];
                qHeader.RSD_Opportunity__c =null;
                update qHeader;    
            }
        }catch(Exception e)
        {
            system.debug(e.getMessage()+'-'+e.getStackTraceString());
            return e.getMessage();
        }
        return 'Success';
    }
    
    @auraEnabled
    public static String updateOpportunityLines(id recordId,Boolean active)
    {
        try{
            RSD_Quote_Header__c qHeader=[Select Id,RSD_Opportunity__c from RSD_Quote_Header__c Where ID = : recordId];
            if(qHeader.RSD_Opportunity__c != null)
            {
                List<OpportunityLineItem> lstLineItem=new List<OpportunityLineItem>();
                for(OpportunityLineItem lineItem:[Select Id,RSD_Active__c from OpportunityLineItem Where RSD_Quote__c = : recordId])
                {
                    if(active != lineItem.RSD_Active__c)
                    {
                        lstLineItem.add(new OpportunityLineItem(Id=lineItem.Id,RSD_Active__c =active));
                    }
                }
                if(!lstLineItem.isEmpty())
                {
                    update lstLineItem;
                }
            }else{
                return 'Functionality only available when the quote is associated to an opportunity';
            }
        }catch(Exception e)
        {
            system.debug(e.getMessage()+'-'+e.getStackTraceString());
            return e.getMessage();
        }
        return 'Success';
    }
}