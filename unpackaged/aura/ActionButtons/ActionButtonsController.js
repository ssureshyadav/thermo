({
	init : function(component, event, helper) {
        component.set("v.showConvert", false);
        component.set("v.showConvertLead", false);
        component.set("v.showLink", false);
        component.set("v.showDisqualify", false);

		helper.getDetails(component).then(function(results) {
            var pageInfo = results; //Page Stuff

            component.set("v.labels", pageInfo.details.labels);
            component.set("v.showConvert", pageInfo.details.showConvert);
            component.set("v.showConvertLead", pageInfo.details.showConvertLead);
            component.set("v.showLink", pageInfo.details.showLink);
            component.set("v.showDisqualify", pageInfo.details.showDisqualify);

            component.set("v.leadButtons", pageInfo.details.leadButtons);
            component.set("v.recButtons", pageInfo.details.recButtons);

			//Do It after everything has been set
			helper.toggleSpinner(component);
        }).catch(function (err) {
			helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });
	},
	handleConvert : function(component, event, helper) {
		//var buttonPressed = event.getSource().getLocalId(); //for API 39 and up

		helper.launchModalAction(component, "convertTitle", "LBI:ActionConvert", true);
	},
	handleLink : function(component, event, helper) {
		helper.launchModalAction(component, "linkTitle", "LBI:ActionLink", true);
	},
	handleDisqualify : function(component, event, helper) {
		helper.launchModalAction(component, "disqualifyTitle", "LBI:ActionDisqualify", true);
	},
	handleLeadConvert : function(component, event, helper) {
		var workflowType = component.get("v.workflowType"); //Only allow multiples for Rec Workflow

		helper.launchModalAction(component, "convertLeadTitle", "LBI:ActionLeadConvert", (workflowType == 'Recommendation'));
	},
	handleEmail : function(component, event, helper) {
		var workflowType = component.get("v.workflowType"); //Only allow multiples for Rec Workflow

		helper.launchModalAction(component, "emailTitle", "LBI:ActionEmail", (workflowType == 'Recommendation'));
	},
	handleLogCall : function(component, event, helper) {
		var workflowType = component.get("v.workflowType"); //Only allow multiples for Rec Workflow

		helper.launchModalAction(component, "callTitle", "LBI:ActionLogCall", (workflowType == 'Recommendation'));
	},
	handleTask : function(component, event, helper) {
		var workflowType = component.get("v.workflowType"); //Only allow multiples for Rec Workflow

		helper.launchModalAction(component, "taskTitle", "LBI:ActionTask", (workflowType == 'Recommendation'));
	},
	handleMeeting : function(component, event, helper) {
		var workflowType = component.get("v.workflowType"); //Only allow multiples for Rec Workflow

		helper.launchModalAction(component, "eventTitle", "LBI:ActionMeeting", (workflowType == 'Recommendation'));
	},
	handleClose : function(component, event, helper) {
		helper.hideModal(component, event, helper);
	},
	handleCancelEvent : function(component, event, helper) {
		helper.hideModal(component, event, helper);
	},
	handleSaveEvent : function(component, event, helper) {
		//Show any toaster messages that are appropriate
		var message = event.getParam("message");
		var refreshEvent = component.getEvent("refresh");

		//Hide the modal
		helper.hideModal(component, event, helper);

		lightningUtilities.showToastMessage("success", "Saved", message);

        refreshEvent.fire();
	}
})