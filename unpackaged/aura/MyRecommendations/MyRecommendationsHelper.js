({
	// hints to ensure labels are preloaded
	// $Label.c.LAB_ViewAll
	// $Label.LBI.LAB_ViewAll

	init : function(cmp, ev) {
		this.getAllLabels(cmp, ev);
		this.getAllPlays(cmp, ev);
	},
	getAllPlays : function(cmp, ev) {
		var actionPlay = cmp.get("c.getAllPlaysForComponent");
		//Setting up init value
		actionPlay.setParams({});

		actionPlay.setCallback(this, function(response) {
			var state = response.getState();
			// This callback doesn’t reference cmp. If it did,
			// you should run an isValid() check
			if (cmp.isValid() &&state === "SUCCESS") {
				// First get the list of Plays
				cmp.set("v.allPlays", response.getReturnValue());

				// Then select the first Id
				this.getRecommendationsForPlay(cmp, ev, 'All');
			}
			//else if (cmp.isValid() && state === "INCOMPLETE") {
			else if (state === "INCOMPLETE") {
				// do something
			}
			//else if (cmp.isValid() && state === "ERROR") {
			else if (state === "ERROR") {
				this.handleErrors(response.getError());
			}
		});

		$A.enqueueAction(actionPlay);
	},
	changePlay : function(cmp, ev) {
		cmp.set("v.recommendations", []);
        var selected = cmp.find("plays").get("v.value");

		this.getRecommendationsForPlay(cmp, ev, selected);
	},
	getAllLabels : function(cmp, ev) {
		// var namespace = 'c';
		//
		// cmp.set("v.namespace", namespace);
		//
		// var labels = cmp.get("v.labels");
		//
		// labels.push($A.get("$Label." + namespace + ".DSH_AllPlays"));
		//
		// cmp.set("v.labels", labels);
		var action = cmp.get("c.getNamespace");
		action.setParams({});

		action.setCallback(this, function(response) {
			var state = response.getState();

			if (cmp.isValid() && state === "SUCCESS") {
				cmp.set("v.namespace", response.getReturnValue());
			}
			//else if (cmp.isValid() && state === "INCOMPLETE") {
			else if (state === "INCOMPLETE") {
				// do something
			}
			//else if (cmp.isValid() && state === "ERROR") {
			else if (state === "ERROR") {
				this.handleErrors(response.getError());
			}
		});

		$A.enqueueAction(action);

	},
	getRecommendationsForPlay : function(cmp, ev, playName) {
		var action = cmp.get("c.getRecommendationsForComponent");
		action.setParams({playType:playName});

		cmp.set("v.showSpinner", true);

		action.setCallback(this, function(response) {
			var state = response.getState();

			if (cmp.isValid() && state === "SUCCESS") {
				cmp.set("v.showSpinner", false);

				cmp.set("v.recommendations", response.getReturnValue());
			}
			//else if (cmp.isValid() && state === "INCOMPLETE") {
			else if (state === "INCOMPLETE") {
				// do something
				console.log(state);
			}
			//else if (cmp.isValid() && state === "ERROR") {
			else if (state === "ERROR") {
				console.log(state);

				this.handleErrors(response.getError());
			}
		});

		$A.enqueueAction(action);
	},
	navigateToRecs : function (cmp, ev) {
		var namespacePrefix = cmp.get("v.namespace");

	    var homeEvent = $A.get("e.force:navigateToObjectHome");
	    homeEvent.setParams({
	        "scope": namespacePrefix + "Recommendation__c"
	    });
	    homeEvent.fire();

	},
	handleErrors : function (errors) {
		if (errors) {
			if (errors[0] && errors[0].message) {
				console.log("Error message: " +
						 errors[0].message);
			}
		} else {
			console.log("Unknown error");
		}
	}
})