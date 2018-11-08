({
	fireClickEvent : function(component) {
        var apiName = component.get("v.apiName");
        var clickEvent = component.getEvent("click");
        var isSortable = component.get("v.isSortable");

        if (isSortable) {
        	clickEvent.setParams({apiName: apiName});
        	clickEvent.fire();
        }
	}
})