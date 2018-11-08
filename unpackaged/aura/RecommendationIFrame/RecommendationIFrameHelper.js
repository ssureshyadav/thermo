({
	getUrl : function (component) {
    	var action = component.get('c.getIFrameSource');
		var recordId = component.get("v.recordId");
	 	var sObjectName = component.get("v.sObjectName");
	 	var iFrameType = component.get("v.iFrameType");

        return new Promise(function (resolve, reject) {
            action.setParams({
            	type: iFrameType,
                recordId: recordId,
                objectName: sObjectName
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
    getData : function (component) {
    	var action = component.get('c.getJSONData');
		var recordId = component.get("v.recordId");
	 	var sObjectName = component.get("v.sObjectName");
	 	var iFrameType = component.get("v.iFrameType");

        return new Promise(function (resolve, reject) {
            
            if (iFrameType != 'Lattice Insights') {
                resolve('');
            } else {
                action.setParams({
                    recordId: recordId,
                    objectName: sObjectName
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
            }
        });
    },
	setMessage : function(component) {
		var iFrame = component.find("iFrameContainer").getElement().contentWindow;
	 	var iFrameType = component.get("v.iFrameType");

	 	//SK 1/3
	 	//postMessage doesn't seem to be working in LEX, so I simply put an override in AccountRecommendationListIFrameSettings (see controller)
	 	//to change the default tab directly.

		switch(iFrameType){
            case "Spend Analytics": {
                //iFrame.postMessage("CrmTabSelectedEvent=spendAnalytics", "*"); // switch to Spend Analytics, previously Purchase History
				break;
            }
            case "Talking Points": {
            	//iFrame.postMessage("CrmTabSelectedEvent=TalkingPoints", "*"); // switch to Buying Signals
                break;
            }
            case "Buying Signals": {
            	//iFrame.postMessage("CrmTabSelectedEvent=BuyingSignals", "*"); // switch to Buying Signals
                break;
            }
            case "Lattice Insights": {
            	// the iframe postmessage for Lattice Insights is handed during a response event, see attachPMListener
                break;
            }
            default : {
                console.log('Incorrect parameter: ' + iFrameType);
            }
        }

	}
})


/* Grabbed this known working snippet from http://nube53.com/blogaaron/index.php/2017/01/05/communicating-between-lightning-components-and-visualforce-pages/
({
    sendToVF : function(component, event, helper) {
        var message = component.get("v.message");
        var vfOrigin = "https://" + component.get("v.vfHost");
        var vfWindow = component.find("vfFrame").getElement().contentWindow;
        vfWindow.postMessage(message, vfOrigin);
    }
})
*/