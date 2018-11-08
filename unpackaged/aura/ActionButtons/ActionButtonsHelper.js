({
	getDetails : function(component) {
        var action = component.get('c.getPageDetails');
        var recId = component.get("v.parentId");
        var sObjectName = component.get("v.sObjectName");
        var recs = component.get("v.recommendations");

        return new Promise(function (resolve, reject) {
            action.setParams({
                recordId: recId,
                sObjectName: sObjectName,
                recommendations: recs
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
    validateSelection : function(component, allowMultiple) {
		var recs = component.get("v.recommendations");

		if (recs.length == 0) {
             var labels = component.get("v.labels");

			lightningUtilities.showToastMessage("error", "Error", labels['noRecSelected']);
			return false;
		}

        if (recs.length > 1 && ! allowMultiple) {
             var labels = component.get("v.labels");

            lightningUtilities.showToastMessage("error", "Error", labels['onlyOneAllowed']);
            return false;
        }

		return true;
	},
	launchModalAction : function(component, title, componentName, allowMultiple) {
		if (! this.validateSelection(component, allowMultiple)) {
			return;
		}

		var parentId = component.get("v.parentId");
        var sObjectName = component.get("v.sObjectName");
        var recs = component.get("v.recommendations");
        var labels = component.get("v.labels");

		component.set("v.modalTitle", labels[title]);

		this.showModal(component, [[componentName, {parentId: parentId, sObjectName: sObjectName, recommendations: recs}]]);
	},
	showModal : function(component, modalToShow) {

		$A.createComponents(modalToShow,
            function(modalContent, status, statusMessagesList){
	            component.set("v.modalBody", modalContent);

				$A.util.removeClass(component.find("modal"), "hideMe");
           	});

	},
	hideModal : function(component, event, helper) {
		$A.util.addClass(component.find("modal"), "hideMe");

	},
    toggleSpinner: function(component) {
        var spinner = component.find("loadingSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})