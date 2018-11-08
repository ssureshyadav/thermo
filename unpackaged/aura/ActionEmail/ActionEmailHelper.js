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
                activityType: 'email',
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
    saveEmail : function(component) {
        var action = component.get('c.sendEmail');
        var recs = component.get("v.recommendations");

        var subject = component.get("v.subject");
        var body = component.get("v.body");
        var ccEmails = component.get("v.ccEmails");
        var details = component.get("v.details");

        return new Promise(function (resolve, reject) {
            action.setParams({
                subject: subject,
                body: body,
                ccEmails: ccEmails,
                leadOrContactId: details.whoId,
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
    fireCancelEvent : function(component) {
        var cancelEvent = component.getEvent("cancel");

        cancelEvent.fire();
    },
    fireSaveEvent : function(component) {
        var saveEvent = component.getEvent("save");
        var message = component.get("v.closingMessage");

        saveEvent.setParams({message: message});
        saveEvent.fire();
    },
    toggleSpinner: function(component) {
        var spinner = component.find("loadingSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})