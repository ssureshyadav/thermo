({
	/**
     * Get the details for the component
     */
    init : function(component, event, helper) {

        helper.getComponentDetails(component).then(function(results) {
            var resultInfo = results; //Page Stuff

			if (resultInfo.message != '') {
				lightningUtilities.showToastMessage("error", "Error", resultInfo.message);
			}

            if (resultInfo.isSuccess) {
            	helper.setOptions(component, resultInfo.details.options, resultInfo.details.selections);
            }

        }).catch(function (err) {

            lightningUtilities.handleError(err);
        });
    },
    handleClickItem : function(component, event, helper) {
        var containerElem = event.toElement.parentElement;
        if (containerElem.id == null) {
            containerElem = event.toElement.parentElement.parentElement;
        }

        var elementSelected = containerElem.id.substring(3); //removing 'lab'

        helper.toggleClicked(component, elementSelected);

    },
    handleDoubleClickItem : function(component, event, helper) {
        var containerElem = event.toElement.parentElement;
        if (containerElem.id == null) {
            containerElem = event.toElement.parentElement.parentElement;
        }

        var elementSelected = containerElem.id.substring(3); //removing 'lab'

        helper.processDoubleClick(component, elementSelected);

    },
    handleAdd : function(component, event, helper) {
        helper.addItems(component, helper);
    },
    handleRemove : function(component, event, helper) {
        helper.removeItems(component, helper);
    }
})