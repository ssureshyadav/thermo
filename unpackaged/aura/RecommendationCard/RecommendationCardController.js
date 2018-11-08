({
	init : function(component, event, helper) {
		var rec = component.get("v.recommendation");

		helper.markCardAsSelected(component, rec.isSelected);
		helper.calculateScoreToShow(component);
	},
	handleClickEvent : function(component, event, helper) {
		helper.fireClickEvent(component);
	},

	handleSelectEvent : function(component, event, helper) {
		helper.fireSelectEvent(component);
	},
    handleMouseOver: function (component, event, helper) {
		var rec = component.get("v.recommendation");

		if (! rec.isDisabled) {
	    	$A.util.addClass(component.find("ptIcon"), "hideMe");
	    	$A.util.removeClass(component.find("ptCheckbox"), "hideMe");

	    	$A.util.addClass(component.find("card"), "hover");
    	}

    },
    handleMouseOut: function (component, event, helper) {
    	var rec = component.get("v.recommendation");

		if (! rec.isDisabled) {
	    	$A.util.removeClass(component.find("ptIcon"), "hideMe");
    		$A.util.addClass(component.find("ptCheckbox"), "hideMe");

    		$A.util.removeClass(component.find("card"), "hover");
    	}
    }
})