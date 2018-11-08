({
    /**
     * Get the basic details for the Component
     */
    getComponentDetails : function(component) {
        var action = component.get('c.getComponentDetails');
        var sObjectAPIName = component.get('v.sObjectAPIName');
        var fieldAPIName = component.get('v.fieldAPIName');
        var value = component.get("v.value");


        return new Promise(function (resolve, reject) {
            action.setParams({
                sObjectAPIName: sObjectAPIName,
                fieldAPIName: fieldAPIName,
                valueId: value
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
    /**
     * Perform the SObject search via an Apex Controller
     */
    doSearch : function(component) {
        // Get the search string, input element and the selection container
        var searchString = component.get("v.searchString");
        var lookupListItems = component.find("lookuplist-items");
        var mainSearch = component.find("lookup-div");

        // We need at least 2 characters for an effective search
        if (typeof searchString === 'undefined' || searchString.length < 2) {
            // Hide the lookuplist
        	$A.util.removeClass(mainSearch, 'slds-is-open');
            return;
        }

        // Show the lookuplist
        $A.util.addClass(mainSearch, 'slds-is-open');

        // Get the API Name
        var sObjectAPIName = component.get('v.sObjectAPIName');
        var fieldAPIName = component.get('v.fieldAPIName');
        var whereClause = component.get('v.whereClause');
        var subtitleField = component.get('v.subtitleField');

        // Create an Apex action
        var action = component.get("c.lookup");

        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();

        // Set the parameters
        action.setParams({ searchString: searchString,
                           sObjectAPIName: sObjectAPIName,
                           fieldAPIName: fieldAPIName,
                           whereClause: whereClause,
                           subtitleField: subtitleField});

        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();

            // Callback succeeded
            if (component.isValid() && state === "SUCCESS") {
                // Get the search matches
                var matches = response.getReturnValue();

                component.set("v.matches", matches);
            } else if (state === "ERROR") { // Handle any error by reporting it

                var errors = response.getError();

                if (errors) {
                    lightningUtilities.handleError(err);
                } else {
                    lightningUtilities.showToastMessage('error','Error','Unknown Error');
                }
            }
        });

        // Enqueue the action
        $A.enqueueAction(action);
    },


    /**
     * Handle the Selection of an Item
     */
    handleSelection : function(component, selectedId, selectedLabel, fireEvent) {

        // Create the UpdateLookupId event
        var updateEvent = component.getEvent("inputChanged");

        var sObjectAPIName = component.get('v.sObjectAPIName');
        var fieldAPIName = component.get('v.fieldAPIName');

        // Populate the event with the selected Object Id
        updateEvent.setParams({
            sObjectAPIName: sObjectAPIName,
            fieldAPIName: fieldAPIName,
            sObjectId : selectedId
        });

        if (fireEvent) {
            // Fire the event
            updateEvent.fire();
        }

        // Update the Searchstring with the Label
        component.set("v.searchString", selectedLabel);

        // Hide the Lookup List
        var mainSearch = component.find("lookup-div");
        $A.util.removeClass(mainSearch, 'slds-is-open');

        // Hide the Input Element
        var inputElement = component.find('lookup');
        $A.util.addClass(inputElement, 'slds-hide');

        // Show the Lookup pill
        var lookupPill = component.find("lookup-pill");
        $A.util.removeClass(lookupPill, 'slds-hide');

    },

    /**
     * Clear the Selection
     */
    clearSelection : function(component) {
        // Create the ClearLookupId event
        var clearEvent = component.getEvent("inputChanged");

        var sObjectAPIName = component.get('v.sObjectAPIName');
        var fieldAPIName = component.get('v.fieldAPIName');

		clearEvent.setParams({
            sObjectAPIName: sObjectAPIName,
            fieldAPIName: fieldAPIName,
            sObjectId : ''
        });
        // Fire the event
        clearEvent.fire();

        // Clear the Searchstring
        component.set("v.searchString", '');

        // Hide the Lookup pill
        var lookupPill = component.find("lookup-pill");
        $A.util.addClass(lookupPill, 'slds-hide');

        // Show the Input Element
        var inputElement = component.find('lookup');
        $A.util.removeClass(inputElement, 'slds-hide');
    }
})