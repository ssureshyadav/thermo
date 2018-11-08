({
	fireSomething :function(component, event, helper) {
        var containerGId = component.get("v.containerGId");
        if(containerGId == null)
        {
        	containerGId = component.get("v.recordId");
        }
        var acct = component.get("v.Account");
        var action = component.get("c.updateAccount");
        action.setParams({
          "recordId": containerGId,
		  "acct" : acct
        });
        $A.enqueueAction(action);
        window.location.reload();
    }
})