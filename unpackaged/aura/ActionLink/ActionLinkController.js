({
	init : function(component, event, helper) {
        component.set("v.showDropdown", false);
        component.set("v.whereClause", "");

		helper.getDetails(component).then(function(results) {
            var pageInfo = results; //Page Stuff

			component.set("v.labels", pageInfo.details.labels);
            component.set("v.dropdownObject", pageInfo.details.dropdownObject);
            component.set("v.dropdownField", pageInfo.details.dropdownField);
            component.set("v.whereClause", pageInfo.details.whereClause);
            component.set("v.showDropdown", pageInfo.details.showDropdown);

			//Do It after everything has been set
			helper.toggleSpinner(component);
        }).catch(function (err) {
			helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });
	},
	handleLookupChange : function(component, event, helper) {

		component.set("v.selectedOpptyID", event.getParam("sObjectId"));
	},
	handleCancelEvent : function(component, event, helper) {
		helper.fireCancelEvent(component);
	},
	handleSaveEvent : function(component, event, helper) {
		helper.toggleSpinner(component);

		helper.link(component).then(function(results) {
			var resultInfo = results; //Page Stuff

            if (resultInfo.isSuccess) {
            	//Disqualify worked
            	helper.toggleSpinner(component);

            	//close immediately
            	helper.fireSaveEvent(component, resultInfo.message);
            } else {
            	if (resultInfo.message != '') {
					lightningUtilities.showToastMessage("error", "Error", resultInfo.message);
				}

				//Do It after everything has been set
				helper.toggleSpinner(component);
            }
        }).catch(function (err) {
			helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });


	}
})