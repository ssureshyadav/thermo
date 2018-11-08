({
	init : function(cmp, ev) {
		this.getRelatedRecommendations(cmp, ev);
	},
	getRelatedRecommendations : function(cmp, ev) {
		var relatedType = cmp.get("v.relatedType");
		var recordId = cmp.get("v.recordId");

		var action = cmp.get("c.getRelatedRecommendations");
		action.setParams({recommendationId: recordId, relatedType: relatedType});

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
	}
})