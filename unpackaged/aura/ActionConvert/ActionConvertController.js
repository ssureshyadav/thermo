({
	init : function(component, event, helper) {
		//try to convert directly
		helper.processConvertInitialLoad(component).then(function(results) {
            var resultInfo = results; //Page Stuff

            component.set("v.pageInfo", resultInfo);
            component.set("v.partialOpp", resultInfo.partialOpportunity);

            if (resultInfo.isConverted) {
            	//Converted immediately
				var recs = component.get("v.recommendations");

            	//var message = "Success: " + recs.length + " recommendation(s) have been converted into Opportunity <a href='/" + resultInfo.convertedOpportunityId + "' >" + resultInfo.convertedOpportunityName + "</a>";
            	var message = resultInfo.message;
            	component.set("v.closingMessage", message);

            	helper.toggleSpinner(component);
            	//close immediately
            	helper.fireSaveEvent(component);
            } else {
            	if (resultInfo.message != '') {
					lightningUtilities.showToastMessage("error", "Error", resultInfo.message);
				}
				helper.generateEditableObject(component, helper);

				//Do It after everything has been set
				helper.toggleSpinner(component);
            }
        }).catch(function (err) {
			helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });
	},
    handleLookupChange : function(component, event, helper) {
        var selectedId = event.getParam("sObjectId");
        var sourceField = event.getParam("fieldAPIName");

        helper.fieldValueChanged(component, sourceField, selectedId);
    },
    handleStandardFieldChange : function(component, event, helper) {
        var sourceField = event.getSource().getLocalId();

        if (sourceField == undefined) {
            console.log('unknown control');
            return;
        }

        var value = event.getSource().get("v.value");

        helper.fieldValueChanged(component, sourceField, value);
    },
	handleCancelEvent : function(component, event, helper) {
		helper.fireCancelEvent(component);
	},
	handleSaveEvent : function(component, event, helper) {
		helper.toggleSpinner(component);

		helper.processConvertSave(component).then(function(results) {
			var resultInfo = results; //Page Stuff

            component.set("v.pageInfo", resultInfo);
            component.set("v.partialOpp", resultInfo.partialOpportunity);

            if (resultInfo.isConverted) {
            	//Converted immediately
				var recs = component.get("v.recommendations");

            	//var message = "Success: " + recs.length + " recommendation(s) have been converted into Opportunity <a href='/" + resultInfo.convertedOpportunityId + "' >" + resultInfo.convertedOpportunityName + "</a>";
            	var message = resultInfo.message;
            	component.set("v.closingMessage", message);

            	helper.toggleSpinner(component);
            	//close immediately
            	helper.fireSaveEvent(component);
            } else {
            	if (resultInfo.message != '') {
					lightningUtilities.showToastMessage("error", "Error", resultInfo.message);
				}
				helper.generateEditableObject(component, helper);

				//Do It after everything has been set
				helper.toggleSpinner(component);
            }
        }).catch(function (err) {
			helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });


	}
})