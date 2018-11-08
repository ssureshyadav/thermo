({
	doInit : function(component, event, helper) {
        var action = component.get("c.userAssignedTerritories");
        var callBackMsg;
        action.setParams({
          "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(a) {
            component.set("v.lstTerritory",a.getReturnValue()); 
            //alert(a.getReturnValue());
        });
        $A.enqueueAction(action);
    }
})