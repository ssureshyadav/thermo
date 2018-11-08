/*
Created By :Mohammed Abdul Qadeer
Company : Deloitte
Date : 19/10/2015
Description : This trigger is developed as per salesforce Best Practice listed on https://developer.salesforce.com/page/Trigger_Frameworks_and_Apex_Trigger_Best_Practices
There are context specific trigger handler methods(for eg..after update). The main purpose of this trigger is to set few rollup fields on parent accounts.

Test Class : RSD_AccountTriggerHandlerTest 
---------
Audit Log
---------
Date(DD/MM/YYYY)    Modified By     Reason
----------------------------------------------------------------------
19/09/2014          Mohammed        AccountTrigger covering after update & after delete context.
*/
trigger AccountTrigger on Account (after update) {

    //Static boolean to prevent trigger recursion
    if(RSD_AccountRollupTriggerHandler.disableAccountTrigger) return;
    
    
	//Checking the trigger context and calling context specific method
    if(Trigger.isAfter && Trigger.isUpdate){
        RSD_AccountRollupTriggerHandler.handleAfterUpdate(trigger.newMap, trigger.oldMap);
    }
}