({
    doInit : function(component, event, helper) {
        
        // Create an instance of the Apex controller method
        var action = component.get("c.getQuoteHeaderList");
        action.setParams({
            //"accountId": component.get("v.recordId")
            "accountId": "0019E000008X3HX"
        });
        // Set the response data on the component attribute 
        action.setCallback(this, function(a) {
            if(a.getState() == "SUCCESS"){
                component.set("v.quote", a.getReturnValue());
            }else{
  				alert(a.getState());              
            }
        });
        // Add the server-side action to the queue of actions to be executed
        $A.enqueueAction(action);
    }
})