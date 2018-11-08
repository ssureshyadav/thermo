({
	getReasons : function(component) {
        var action = component.get('c.getReasons');

        return new Promise(function (resolve, reject) {

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
    disqualify : function(component) {
        var action = component.get('c.disqualifyRecommendations');
        var recs = component.get("v.recommendations");

        var reason = component.find("reason").get("v.value");
        var moreInfo = '';
        if (component.find("moreInfo")) {
            moreInfo = component.find("moreInfo").get("v.value");
        }

        return new Promise(function (resolve, reject) {

            action.setParams({
                recommendations: recs,
                reasonName: reason,
                moreInfo: moreInfo
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
    generateReasonOptions : function(component) {
        var opts = [];
        var reasons = component.get("v.reasons");

        reasons.forEach(function(reason) {
            var value = {
                            label: reason.name,
                            value: reason.name
                        }

            opts.push(value);
        });

        opts[0].selected = true;

        component.find("reason").set("v.options", opts);

        this.processReasonSelection(component);

    },
    processReasonSelection : function(component) {
        var reasons = component.get("v.reasons");
        var selected = component.find("reason").get("v.value");

        for (var i = 0; i < reasons.length; i++) {
            if (reasons[i].name == selected) {
                component.set("v.isMoreInfoReq", ! reasons[i].isMoreInfoOptional);
                component.set('v.isMoreInfo', reasons[i].requiresMoreInfo);
                break;
            }
        }

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