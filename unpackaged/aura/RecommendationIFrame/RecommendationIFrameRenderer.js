({
    afterRender : function( component, helper ) {

        this.superAfterRender();
        
        console.log('Attaching Listener');
		
		// Listen for message 
		window.addEventListener("message", function(msgEvent) { 
            
            console.log('parent received message!:  ',msgEvent.data);
		    
		    // Get Insights App message 
		    var latticeInsightsAppIsReady = msgEvent.data; 
		
		    // If Insights App is available, run this code 
		    if ( latticeInsightsAppIsReady == 'init' ) { 
		          
		        // Mapping of Fields Ulysses API expects from BIS 
		        // Mapping of fields happens on BIS back-end 
		        /*
		        var postMessageData = { 
                  Authentication: '54c43ef3-55e8-4a9a-809a-bd5103bc8eba', // real auth token goes here 
                  request: { 
                    modelId: '', // might not be needed 
                    performEnrichment: true, // always true 
                    record: { 
                      CompanyName: '', 
                      Email : '', 
                      Domain: '', 
                      City: '', 
                      State: '', 
                      Zip: '', 
                      Country: '', 
                      PhoneNumber: '' 
                    } 
                  } 
                };
                */

                var postMessageData = component.get('v.jsonData');
                //debugger;
                console.log('Posting this to the iframe:  ', postMessageData);
                
		        // Turn data string into JSON object and send via postMessage 
		        // This will work similar to how we're doing it for Dante 
		        var iFrame = component.find("iFrameContainer").getElement().contentWindow;
		        iFrame.postMessage(postMessageData, "*"); 
		
		    } 
		    return true;
            
		}, false);
    }
})