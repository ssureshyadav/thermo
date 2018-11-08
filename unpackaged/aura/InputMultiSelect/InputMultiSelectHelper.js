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
                valueString: value
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
    * Set the List of Options
    **/
    setOptions : function(component, options, selected) {
    	var allOptions = [];

    	options.forEach(function(option){
    		var optToAdd = {
    				label: option,
    				isSelected: false,
                    isClicked: false
    		};

    		if (selected.indexOf(option) >= 0) {
    			optToAdd.isSelected = true;
    		}


    		allOptions.push(optToAdd);
    	});

    	component.set("v.options", allOptions);
	},
    /**
    * Change the Look-and-Feel of an option when it's clicked
    **/
    toggleClicked : function(component, elementClicked) {
        var allOptions = component.get("v.options");

        allOptions.forEach(function(option){
            if (option.label == elementClicked) {
                option.isClicked = ! option.isClicked;
            }
        });

        component.set("v.options", allOptions);
    },
    processDoubleClick : function(component, elementClicked) {
        var allOptions = component.get("v.options");

        allOptions.forEach(function(option){
            if (option.label == elementClicked) {
                option.isSelected = !option.isSelected;
            }
        });

        component.set("v.options", allOptions);
    },
    /**
    * Add items to the list of "Selected"
    **/
    addItems : function(component, helper) {
        var allOptions = component.get("v.options");

        allOptions.forEach(function(option){
            if (option.isClicked && ! option.isSelected) {
                 option.isSelected = true;
            }
        });

        component.set("v.options", allOptions);
        helper.fireChangeValue(component);
    },
    /**
    * Remove items from the list of "Selected"
    **/
    removeItems : function(component, helper) {
        var allOptions = component.get("v.options");

        allOptions.forEach(function(option){
            if (option.isClicked && option.isSelected) {
                 option.isSelected = false;
            }
        });

        component.set("v.options", allOptions);
        helper.fireChangeValue(component);
    },
    fireChangeValue: function(component) {

        var changeEvent  = component.getEvent("inputChanged");

        var sObjectAPIName = component.get('v.sObjectAPIName');
        var fieldAPIName = component.get('v.fieldAPIName');

        var allOptions = component.get("v.options");

        var selectedValues = [];
        allOptions.forEach(function(option){
            if (option.isSelected) {
                selectedValues.push(option.label);
            }
        });

        var selectedValue = selectedValues.join(';');

        changeEvent.setParams({
            sObjectAPIName: sObjectAPIName,
            fieldAPIName: fieldAPIName,
            sObjectId : selectedValue
        });
        // Fire the event
        changeEvent.fire();
    }
})