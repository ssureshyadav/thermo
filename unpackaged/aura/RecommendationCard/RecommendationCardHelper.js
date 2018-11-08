({
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
	fireClickEvent : function(component) {
        var rec = component.get("v.recommendation");
        var clickEvent = component.getEvent("click");

        clickEvent.setParams({recommendationId: rec.id, leadId: rec.leadId});
        clickEvent.fire();
	},
	fireSelectEvent : function(component) {
        var rec = component.get("v.recommendation");
        var chk = component.find("selectCheckbox").get("v.value");
        var selectEvent = component.getEvent("select");

        this.markCardAsSelected(component, chk);

        selectEvent.setParams({recommendationId: rec.id, isSelected: chk, workflowType: rec.workflowType});
        selectEvent.fire();
	},
    markCardAsSelected: function(component, isSelected) {
        if (isSelected) {
            $A.util.addClass(component.find("card"), "selected");
        } else {
            $A.util.removeClass(component.find("card"), "selected");
        }
    }

})