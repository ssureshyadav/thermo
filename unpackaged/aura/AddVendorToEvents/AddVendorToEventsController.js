({
	doInit : function(component, event, helper) {
         var action = component.get("c.getVendorAccounts");
        var callBackMsg;
        action.setCallback(this, function(a) {
            component.set("v.accounts",a.getReturnValue()); 
            if(a.getReturnValue() =='Success')
            {
                window.location.reload();
            }
            //alert(a.getReturnValue());
        });
        $A.enqueueAction(action);
        
		
	}
})