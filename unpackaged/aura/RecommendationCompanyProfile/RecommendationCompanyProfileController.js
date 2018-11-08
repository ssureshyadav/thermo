({
	init : function(component, event, helper) {
		Promise.all([helper.getCompanyProfileInfo(component)]).then(function(results) {
            var pageResults = results[0]; //page

            component.set("v.pageReturn", pageResults);

			//Do It after everything has been set
			helper.toggleSpinner(component);
        }).catch(function (err) {
            lightningUtilities.handleError(err);
        });

	},
	showSection: function(component, event, helper) {
		var linkId = event.toElement.id;
		var groupId = linkId.substring(4);

		helper.toggleSection(component, groupId);
	},
	goBack: function(component, event, helper) {
		var linkId = event.toElement.id;
		var groupId = linkId.substring(4);

		helper.closeSection(component, groupId);
	}
})