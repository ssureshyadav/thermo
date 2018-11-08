({
	getRecord : function (component) {
    	var action = component.get('c.getRecommendationFromRecord');
		var recordId = component.get("v.recordId");
	 	var sObjectName = component.get("v.sObjectName");

        return new Promise(function (resolve, reject) {
            action.setParams({
                recordId: recordId,
                objectContainer: sObjectName
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
    calculateScoreToShow : function(component) {
		var rec = component.get("v.recommendation");
		var showScore = component.get("v.showScore");

		var progress = component.get("v.progress");
		var valueToOutput = component.get("v.valueToOutput");

		//Calculate the right value to show
		if (showScore) {
			valueToOutput = rec.likelihood;
		} else {
			valueToOutput = rec.rank;
		}

        var displayTextClass = 'overlay';

        if (rec.rank.length>1) {
            displayTextClass += ' condensed';
        }

		switch(rec.rank){
            case "A":
            case "HIGHEST": {
                progress = 100;
                break;
            }
            case "B":
            case "HIGH": {
                progress = 75;
                break;
            }
            case "C":
            case "MEDIUM": {
                progress = 50;
                break;
            }
            case "D":
            case "LOW": {
                progress = 25;
                break;
            }
            default : {
                progress = 0;
            }
        }

		component.set("v.progress", progress);
		component.set("v.valueToOutput", valueToOutput);
        component.set("v.displayTextClass", displayTextClass);

	},
	fireBackEvent : function(component) {
        //var rec = component.get("v.recommendation");
        var backEvent = component.getEvent("back");

        //clickEvent.setParams({recommendationId: rec.id});
        backEvent.fire();
	},
	toggleSpinner: function(component) {
		var spinner = component.find("loadingSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
	}
})