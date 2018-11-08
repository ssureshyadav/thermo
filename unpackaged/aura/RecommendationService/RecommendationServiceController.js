({
	getParams: function (component) {
        var action = component.get('c.getPageParameters');

        return new Promise(function (resolve, reject) {

            action.setCallback(this, function (response) {
               var state = response.getState();

                if (component.isValid() && state === "SUCCESS") {
                	var xx = response.getReturnValue();

                	console.log('Returned From Promise xx2');
                	console.log(xx);
                    resolve(xx);
                }
                else if (component.isValid() && state === "ERROR") {
                    reject(response.getError()[0]);
                }
            });

            $A.enqueueAction(action);
        });
    }
})