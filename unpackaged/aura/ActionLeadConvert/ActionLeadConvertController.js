({
	init : function(component, event, helper) {
		helper.getDetails(component).then(function(results) {
            var pageInfo = results; //Page Stuff

            component.set("v.details", pageInfo.details);
            component.set("v.labels", pageInfo.details.labels);
            component.set("v.statuses", pageInfo.details.statuses);

			component.set("v.assignedTo", pageInfo.details.assignedTo);
			component.set("v.status", pageInfo.details.statuses[0]);

			component.set("v.isLoaded", true);
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

		if (fieldName == details.contactFieldName) {
			//The Contact Lookup

	        var contactId = event.getParam("sObjectId");
			component.set("v.contactId", contactId);
		} else if (fieldName == details.accountFieldName) {
			//The Account Lookup

	        var accountId = event.getParam("sObjectId");
			component.set("v.accountId", accountId);

			var whereClause = '';
			if (accountId != '') {
				whereClause = "AccountId='" + accountId+ "'";
			}

			console.log('Clause: ' + whereClause);
			component.set("v.whereClause", whereClause);
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

		helper.convert(component).then(function(results) {
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