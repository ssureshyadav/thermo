({
	init : function(component, event, helper) {
        component.set("v.isMoreInfo", false);
        component.set("v.isMoreInfoReq", false);

		helper.getReasons(component).then(function(results) {
            var pageInfo = results; //Page Stuff

            component.set("v.reasons", pageInfo.details.reasons);
			component.set("v.labels", pageInfo.details.labels);

    		component.set("v.isLoaded", true);

            helper.generateReasonOptions(component);

			//Do It after everything has been set
			helper.toggleSpinner(component);
        }).catch(function (err) {
			helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });
	},
	handleReasonChange : function(component, event, helper) {
		helper.processReasonSelection(component);
	},
	handleCancelEvent : function(component, event, helper) {
		helper.fireCancelEvent(component);
	},
	handleSaveEvent : function(component, event, helper) {
		helper.toggleSpinner(component);

		helper.disqualify(component).then(function(results) {
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