({
	init : function(component, event, helper) {
		var langLocale = $A.get("$Locale.langLocale");

		component.set("v.langLocale", langLocale);
		component.set("v.allDay", false);

		helper.getDetails(component).then(function(results) {
            var pageInfo = results; //Page Stuff

            component.set("v.details", pageInfo.details);
            component.set("v.labels", pageInfo.details.labels);
			component.set("v.assignedTo", pageInfo.details.assignedTo);
			component.set("v.startDate", pageInfo.details.startDate);
			component.set("v.endDate", pageInfo.details.endDate);

			//Do It after everything has been set
			helper.toggleSpinner(component);
        }).catch(function (err) {
			helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });
	},
	handleLookupChange : function(component, event, helper) {
		var fieldName = event.getParam("fieldAPIName");
		var details = component.get("v.details");

		if (fieldName == details.fieldName) {
			//The Contact Lookup

	        details.whoId = event.getParam("sObjectId");
			component.set("v.details", details);
		} else if (fieldName == details.userFieldName) {
			//The User Lookup

	        var assignedTo = component.get("v.assignedTo");

	        assignedTo = event.getParam("sObjectId");
			component.set("v.assignedTo", assignedTo);

		}

	},
	handleCancelEvent : function(component, event, helper) {
		helper.fireCancelEvent(component);
	},
	handleSaveEvent : function(component, event, helper) {
		helper.toggleSpinner(component);

		helper.saveMeeting(component).then(function(results) {
			var resultInfo = results; //Page Stuff

            helper.toggleSpinner(component);

			if (resultInfo.isSuccess) {
            	var message = resultInfo.message;
            	component.set("v.closingMessage", message);

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