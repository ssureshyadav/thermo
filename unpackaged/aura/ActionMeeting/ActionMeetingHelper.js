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
                activityType: 'event',
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
    saveMeeting : function(component) {
        var action = component.get('c.newMeeting');
        var recs = component.get("v.recommendations");

        var subject = component.get("v.subject");
        var description = component.get("v.description");
        var assignedTo = component.get("v.assignedTo");
        var startDate = component.get("v.startDate");
        var endDate = component.get("v.endDate");
        var allDay = component.get("v.allDay");
        var details = component.get("v.details");

        return new Promise(function (resolve, reject) {
            action.setParams({
                subject: subject,
                description: description,
                accountId: details.whatId,
                leadOrContactId: details.whoId,
                assignedTo: assignedTo,
                startDateTime: startDate,
                endDateTime: endDate,
                allDay: allDay,
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