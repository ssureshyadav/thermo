({
	deleteAssignedTerritory :function(component, event, helper) {
        var action = component.get("c.deleteTerritory");
        action.setParams({
            "recordId": component.get("v.containerGId")
        });
        action.setCallback(this, function(a) {
        	window.location.reload();
        });
        $A.enqueueAction(action);
        
    }
})