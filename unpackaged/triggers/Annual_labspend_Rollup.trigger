/*
Created By :Kuldeep
Company : Deloitte
Date : 07/07/2015
Trigger to set rollup of all the child account to parent account.
Test Class : Annual_labspend_Rollup_Test 
*/
trigger Annual_labspend_Rollup on Account(before update, After delete, after update) {
If(Trigger.Isbefore)
{
    For(Account acc:trigger.new)
    {
        If(acc.type=='CBP')
        acc.AnnualRevenue = acc.RSD_Opportunity_Amount_Rollup__c;
    }
}
If(Trigger.isAfter)
    {
        Set<id> accids= new Set<id>();
        Set<id> uniqueid = new Set<id>();
        
        
        List<Account> shipmentsToUpdate = new List<Account>();
      
        
        If(!Trigger.isDelete)
        {    
            for (Account item : Trigger.new){
                    accids.add(item.Parentid);
            }
        }    
        if (Trigger.isUpdate || Trigger.isDelete) {
            for (Account item : Trigger.old){
            
                if(item.ParentId != null)
                    accids.add(item.Parentid);
            }
        }
       
        Map<id,Account> shipmentMap = new Map<id,Account>([select id, AnnualRevenue,RSD_Actual_Spend__c from Account where id IN :accids]);
        
        for (Account ship : [select id,Parentid,RSD_Opportunity_Amount_Rollup__c,RSD_Actual_Spend__c from Account where Parentid IN :accids])
        {      
 
            
            If(shipmentMap.get(ship.Parentid) <>null){
                
                If(uniqueid.contains(ship.Parentid)==False)
                {
                    shipmentMap.get(ship.Parentid).AnnualRevenue = ship.RSD_Opportunity_Amount_Rollup__c;
                    If(ship.RSD_Actual_Spend__c<>null)
                    {
                        shipmentMap.get(ship.Parentid).RSD_Actual_Spend__c =ship.RSD_Actual_Spend__c; 
                    }
                    uniqueid.add(ship.Parentid);
                }
                else
                {
                    shipmentMap.get(ship.Parentid).AnnualRevenue = shipmentMap.get(ship.Parentid).AnnualRevenue + ship.RSD_Opportunity_Amount_Rollup__c;
                    If(ship.RSD_Actual_Spend__c<>null)
                    {
                    shipmentMap.get(ship.Parentid).RSD_Actual_Spend__c= shipmentMap.get(ship.Parentid).RSD_Actual_Spend__c+ ship.RSD_Actual_Spend__c;
                    }
                }
                
            }
        
        
       
     
        }
        
         For(Account acc:shipmentMap.values()){
              shipmentsToUpdate.add(shipmentMap.get(acc.id));
         }
        
        If(shipmentsToUpdate.size()>0)
        {
           update shipmentsToUpdate;
       }
        
    }
}