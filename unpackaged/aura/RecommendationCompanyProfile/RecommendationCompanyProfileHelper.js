({
	getCompanyProfileInfo : function (component) {
    	var action = component.get('c.getCompanyProfileInformation');
		var recordId = component.get("v.recordId");
	 	var sObjectName = component.get("v.sObjectName");

        return new Promise(function (resolve, reject) {
            action.setParams({
            	recordId: recordId,
                objectName: sObjectName
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
	toggleSpinner: function(component) {
		var spinner = component.find("loadingSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
	},
	toggleSection: function(component, sectionid) {
		var page = component.get("v.pageReturn");

		var allGroups = page.displayGroups;

		allGroups.forEach(function(grp){
			if (grp.groupId == sectionid) {
				grp.isSelected = true;
			} else {
				grp.isSelected = false;
			}

		});

		component.set("v.pageReturn", page);
	},
	closeSection: function(component, sectionid) {

	}
})