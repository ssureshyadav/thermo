({
	doInit : function(component, event, helper) {
        var action = component.get("c.accountTeams");
        var callBackMsg;
        action.setParams({
          "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            component.set("v.lstAccountTeams",a.getReturnValue()); 
            //alert(a.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})