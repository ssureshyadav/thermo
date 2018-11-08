({
	doInit : function(component, event, helper) {
         var action = component.get("c.refreshPage");
        action.setParams({
              "recordId": component.get("v.recordId"),
            });
        $A.get('e.force:refreshView').fire();
        action.setCallback(this, function(a) {
            if(a.getReturnValue())
            {
                $A.get('e.force:refreshView').fire();
            }
            //alert(a.getReturnValue());
        });
        $A.enqueueAction(action);		
	}
})