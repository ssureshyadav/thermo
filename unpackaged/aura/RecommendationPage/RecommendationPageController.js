({
	init : function(component, event, helper) {
		//first time initialization
		component.set("v.pageCounter",1);
		component.set("v.hasInitialized", false);
		component.set("v.isShowingDetail", false);
		component.set("v.selectedWorkflowType", "");

		// helper.getPage(component, event, helper);
		Promise.all([lightningUtilities.getParams(component), helper.getPage(component)]).then(function(results) {
            var pageParams = results[0]; //Page Stuff
            var recPage = results[1]; //rec Stuff

            component.set("v.hasInitialized", true); //Marked page ready

            component.set("v.namespacePrefix", pageParams.namespace); //Marked page ready

			component.set("v.labels", recPage.labels); //Recs x-y of z

			helper.postProcessRecommendations(component, recPage.recommendations);
			component.set("v.pageDisplay", recPage.pageRecordDisplay); //Recs x-y of z

			if (recPage.recommendations.length > 0) {
				//Only set this if I found recommendations. Otherwise, the buttons won't be in the DOM
				component.find("prevButton").set("v.disabled", !recPage.hasPrevious);
				component.find("nextButton").set("v.disabled", !recPage.hasNext);
			}

			//Do It after everything has been set
			helper.toggleSpinner(component);
        }).catch(function (err) {
            lightningUtilities.handleError(err);
        });
	},
	nextPage : function(component, event, helper) {
		var cnt = component.get("v.pageCounter");
		cnt += 1;
		component.set("v.pageCounter",cnt);

		helper.getPage(component, event, helper);
	},
	previousPage : function(component, event, helper) {
		var cnt = component.get("v.pageCounter");
		cnt -= 1;
		component.set("v.pageCounter",cnt);

		helper.getPage(component, event, helper);
	},
	handleClickEvent : function(component, event, helper) {
		helper.showDetailRecord(component, event.getParam("recommendationId"), event.getParam("leadId"));
    },
	handleBackEvent : function(component, event, helper) {
		helper.hideDetailRecord(component);
	},
	handleSelectEvent : function(component, event, helper) {
        helper.manageSelection(component, event, helper);
	},
	handleRefreshPage : function(component, event, helper) {
		component.set("v.selectedRecommendations", []);
		component.set("v.selectedWorkflowType", "");

		helper.getPage(component, event, helper);
	},
})