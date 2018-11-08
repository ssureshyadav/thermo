({
	init : function(component, event, helper) {
        var recService = component.find("recService");

        //Promise.all([recService.getParams()).then($A.getCallback(function(results) {
        Promise.all([lightningUtilities.getParams(component)]).then($A.getCallback(function(results) {
            var pageParams = results[0]; //Page Stuff

            console.log('I returned');
            console.log(pageParams);

            component.set("v.showScore", pageParams.showScore);
            component.set("v.showRevenue", pageParams.showRevenue);
        })).catch($A.getCallback(function (err) {
            lightningUtilities.handleError(err);
        }));
	}
})