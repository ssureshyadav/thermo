({
	init : function(component, event, helper) {
		helper.getDetails(component).then(function(results) {
            var pageInfo = results; //Page Stuff

            component.set("v.details", pageInfo.details);
            component.set("v.labels", pageInfo.details.labels);

			//Do It after everything has been set
			helper.toggleSpinner(component);
        }).catch(function (err) {
			helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });
	},
	handleLookupChange : function(component, event, helper) {
        var details = component.get("v.details");

        details.whoId = event.getParam("sObjectId");
		component.set("v.details", details);

	},
	handleCancelEvent : function(component, event, helper) {
		helper.fireCancelEvent(component);
	},
	handleSaveEvent : function(component, event, helper) {
		helper.toggleSpinner(component);

		helper.saveCall(component).then(function(results) {
			var resultInfo = results; //Page Stuff

			if (resultInfo.isSuccess) {
            	var message = resultInfo.message;
            	component.set("v.closingMessage", message);

            	helper.toggleSpinner(component);
            	//close immediately
            	helper.fireSaveEvent(component);
            } else {
            	if (resultInfo.message != '') {
					lightningUtilities.showToastMessage("error", "Error", resultInfo.message);
				}
            }
        }).catch(function (err) {
			helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });


	}
})