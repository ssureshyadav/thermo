({
	getDetails : function(component) {
        var action = component.get('c.getPageDetails');
        var recId = component.get("v.parentId");
        var sObjectName = component.get("v.sObjectName");
        var recs = component.get("v.recommendations");

        return new Promise(function (resolve, reject) {
            action.setParams({
                recordId: recId,
                sObjectName: sObjectName,
                recommendations: recs
            });

            action.setCallback(this, function (response) {
               var state = response.getState();

                if (component.isValid() && state === "SUCCESS") {
                    resolve(response.getReturnValue());
                }
                else if (component.isValid() && state === "ERROR") {
                    var errors = response.getError();
                    reject(response.getError()[0]);
                }
            });

            $A.enqueueAction(action);
        });
    },
    link : function(component) {
        var action = component.get('c.linkToOpportunities');
        var recs = component.get("v.recommendations");
        var opptyId = component.get("v.selectedOpptyID");

        return new Promise(function (resolve, reject) {
            action.setParams({
                recommendations: recs,
                opportunityId: opptyId
            });

            action.setCallback(this, function (response) {
               var state = response.getState();

                if (component.isValid() && state === "SUCCESS") {
                    resolve(response.getReturnValue());
                }
                else if (component.isValid() && state === "ERROR") {
                    var errors = response.getError();
                    reject(response.getError()[0]);
                }
            });

            $A.enqueueAction(action);
        });
    },
    fireCancelEvent : function(component) {
        var cancelEvent = component.getEvent("cancel");

        cancelEvent.fire();
	},
	fireSaveEvent : function(component, message) {
        var saveEvent = component.getEvent("save");

        saveEvent.setParams({message: message});
        saveEvent.fire();
	},
    toggleSpinner: function(component) {
        var spinner = component.find("loadingSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})