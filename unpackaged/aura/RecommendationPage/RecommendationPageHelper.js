({
	// getPage : function(component, event, helper) {
	// 	var pageNumber = component.get("v.pageCounter");
	// 	var parentId = component.get("v.parentId");
	// 	var sObjectName = component.get("v.sObjectName");

	// 	var action = component.get("c.getRecordsForPage");
	// 	action.setParams({parentId : parentId, sObjectName: sObjectName, pageNumber: pageNumber});

	// 	this.toggleSpinner(component);
	// 	//Setting up init value
	// 	action.setCallback(this, function(response) {
	// 		var state = response.getState();

	// 		if (component.isValid() && state === "SUCCESS") {
	// 			var recPage = response.getReturnValue();

	// 			component.set("v.hasInitialized", true); //Marked page ready

	// 			component.set("v.labels", recPage.labels); //Recs x-y of z

	// 			this.postProcessRecommendations(component, recPage.recommendations);
	// 			component.set("v.pageDisplay", recPage.pageRecordDisplay); //Recs x-y of z

	// 			if (recPage.recommendations.length > 0) {
	// 				//Only set this if I found recommendations. Otherwise, the buttons won't be in the DOM
	// 				component.find("prevButton").set("v.disabled", !recPage.hasPrevious);
	// 				component.find("nextButton").set("v.disabled", !recPage.hasNext);
	// 			}

	// 			//Do It after everything has been set
	// 			this.toggleSpinner(component);
	// 		} else if (component.isValid() && state === "ERROR") {
	// 			this.toggleSpinner(component);

	// 			var errors = response.getError();
	// 			lightningUtilities.handleError(errors[0]);
	// 		}
	// 	});

	// 	$A.enqueueAction(action);
	// },
	getPage : function(component, event, helper) {
		var pageNumber = component.get("v.pageCounter");
		var parentId = component.get("v.parentId");
		var sObjectName = component.get("v.sObjectName");

		var action = component.get("c.getRecordsForPage");

		this.toggleSpinner(component);
		return new Promise(function (resolve, reject) {
            action.setParams({
            	parentId : parentId,
            	sObjectName: sObjectName,
            	pageNumber: pageNumber
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
	postProcessRecommendations: function(component, recommendations) {
		//Mark as selected/disabled those recommendations who are selected/disabled
		var selected = component.get("v.selectedRecommendations");

		recommendations.forEach(function(rec){

			if (selected.indexOf(rec.id) >= 0) {
				rec.isSelected = true;
			}

		});

		component.set("v.pagedRecommendations", recommendations); //Assign Page Recs

		this.disableRecs(component, component.get("v.selectedWorkflowType"));
	},
	toggleSpinner: function(component) {
		var spinner = component.find("loadingSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
	},
	manageSelection: function(component, event, helper) {
		var selected = component.get("v.selectedRecommendations");

		if (event.getParam("isSelected")) {
			selected.push(event.getParam("recommendationId"));
		} else {
			var index = selected.indexOf(event.getParam("recommendationId"));

			if (index > -1) {
			    selected.splice(index, 1);
			}
		}

		component.set("v.selectedRecommendations", selected);

		if (selected.length > 0) {
			this.disableRecs(component, event.getParam('workflowType'));
		} else {
			this.enableAllRecs(component);
		}
	},
	disableRecs: function(component, typeToKeep) {
		var recommendations = component.get("v.pagedRecommendations");

		recommendations.forEach(function(rec){
			if (typeToKeep != '' && rec.workflowType != typeToKeep) {
				rec.isDisabled = true;
			}
		});

		component.set("v.pagedRecommendations", recommendations);
		component.set("v.selectedWorkflowType", typeToKeep);
	},
	enableAllRecs: function(component) {
		var recommendations = component.get("v.pagedRecommendations");

		recommendations.forEach(function(rec){
			rec.isDisabled = false;
		});

		component.set("v.pagedRecommendations", recommendations);
		component.set("v.selectedWorkflowType", "");
	},
	showDetailRecord: function(component, recordId, leadId) {

		if (leadId != '') {
			//Lead Workflow
			var navEvt = $A.get("e.force:navigateToSObject");
			navEvt.setParams({
		      "recordId": leadId
		    });

		    navEvt.fire();

		}  else {
			//Rec Workflow
			//I set the sObjectName to "" (default) because I might, conceivably, one time put the child component directly in an account, and pick the first rec
			var detailComponentDef = [["LBI:RecommendationIndividual", {recordId : recordId, sObjectName: '', backButton: true}]];

			$A.createComponents(detailComponentDef,
			                function(recDetailComponent, status, statusMessagesList){
			                    component.set("v.recDetail", recDetailComponent);
								component.set("v.isShowingDetail", true);
			                });
		}
	},
	hideDetailRecord: function(component, recordId) {
		var recommendations = component.get("v.pagedRecommendations");
		this.postProcessRecommendations(component, recommendations);

		component.set("v.isShowingDetail", false);
	}
})