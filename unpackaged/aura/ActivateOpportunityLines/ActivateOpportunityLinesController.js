({
	doInit : function(component, event, helper) {
        var action = component.get("c.updateOpportunityLines");
        var callBackMsg;
        action.setParams({
          "recordId": component.get("v.recordId"),
            "active" : "true"
        });
        action.setCallback(this, function(a) {
            component.set("v.response",a.getReturnValue()); 
            if(a.getReturnValue() =='Success')
            {
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    refreshPage:function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})