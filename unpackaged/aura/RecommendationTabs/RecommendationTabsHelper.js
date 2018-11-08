({
	createTabContent : function(tabElement, component, tabContent) {
        if (tabContent){
            $A.createComponents(tabContent,
                function(newTabContent, status, statusMessagesList){
                    tabElement.set("v.body", newTabContent);
                });
        }

    },
    createAllTabs : function(component, tabs) {
    	//Sort the tabs
		tabs.sort(function (a, b) {
		  if (a.tabIndex > b.tabIndex) {
		    return 1;
		  }
		  if (a.tabIndex < b.tabIndex) {
		    return -1;
		  }
		  // a must be equal to b
		  return 0;
		});

        var defaultTab = '';
        tabs.forEach(function(tab) {
            if (tab.focus) {
                defaultTab = tab.name;
            }
        });

        component.set("v.tabs", tabs);
        component.set("v.defaultTab", defaultTab);
    },
    getTabs : function (component) {
    	var action = component.get('c.getTabsInfo');
    	var objectContainer = component.get('v.objectContainer');
        var parentRecordId = component.get('v.parentRecordId');
    	var isDetail = component.get('v.isDetail');

        return new Promise(function (resolve, reject) {
            action.setParams({
                parentRecordId: parentRecordId,
                objectToDisplay: objectContainer,
                isDetail: isDetail
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
    }
})