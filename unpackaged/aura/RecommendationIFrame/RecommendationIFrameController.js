({
	init : function(component, event, helper) {
		Promise.all([helper.getUrl(component), helper.getData(component)]).then(function(results) {
            var url = results[0]; //URL
            var data = results[1]; // JSON Data

            component.set("v.url", url);
            component.set("v.jsonData", data);
            //debugger;

			helper.setMessage(component);
        }).catch(function (err) {
            lightningUtilities.handleError(err);
        });
	}
})