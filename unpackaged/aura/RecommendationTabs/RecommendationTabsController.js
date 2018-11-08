({
	init : function(component, event, helper) {

        Promise.all([helper.getTabs(component)]).then($A.getCallback(function(results) {
            var tabs = results[0]; //Tabs

            helper.createAllTabs(component, tabs);
        })).catch($A.getCallback(function (err) {
            lightningUtilities.handleError(err);
        }));
	},
	handleTabFocusEvent : function (component, event, helper) {
        var tab = event.detail.selectedTab;

        var existingBody = tab.get("v.body");

        if (existingBody.length > 0) {
            //There is already a body in that component, no need to re-create it.
            return;
        }

        var tabName = tab.get('v.id');
        var showScore = component.get("v.showScore");
        var showRevenue = component.get("v.showRevenue");
        var recordId = component.get("v.parentRecordId");
        var sObjectName = component.get("v.objectContainer");
        var suppInfoId = '';

        //This little code is so we can distiguish when we get an unknown parameter from an SuppInfoID
        //If the tabName looks like a SFDCId, then assume it is a Supplemental Info record
        var idRegEx = /[a-zA-Z0-9]{18}|[a-zA-Z0-9]{15}/;
        if (idRegEx.test(tabName)) {
            suppInfoId = tabName;
            tabName = "Supplemental Information";
        }

        switch(tabName){
            case "Recommendation Information": {
                helper.createTabContent(tab, component, [["LBI:RecommendationPage", {parentId : recordId, sObjectName: sObjectName, showRevenue: showRevenue, showScore: showScore}]]);
                break;
            }
            case "Purchase History": {
                helper.createTabContent(tab, component, [["LBI:RecommendationIFrame", {recordId : recordId, sObjectName: sObjectName, iFrameType: "Spend Analytics"}]]);
                break;
            }
            case "Talking Points": {
                helper.createTabContent(tab, component, [["LBI:RecommendationIFrame", {recordId : recordId, sObjectName: sObjectName, iFrameType: "Talking Points"}]]);
                break;
            }
            case "Buying Signals": {
                helper.createTabContent(tab, component, [["LBI:RecommendationIFrame", {recordId : recordId, sObjectName: sObjectName, iFrameType: "Buying Signals"}]]);
                break;
            }
            case "Company Profile": {
                helper.createTabContent(tab, component, [["LBI:RecommendationCompanyProfile", {recordId : recordId, sObjectName: sObjectName}]]);
                break;
            }
            case "Lattice Insights": {
                helper.createTabContent(tab, component, [["LBI:RecommendationIFrame", {recordId : recordId, sObjectName: sObjectName, iFrameType: "Lattice Insights"}]]);
                break;
            }
            case "Supplemental Information": {
                helper.createTabContent(tab, component, [["LBI:RecommendationSupplementalInformation", {recordId : recordId, sObjectName: sObjectName, supplementalInformationId: suppInfoId}]]);
                break;

            }
            default : {
                helper.createTabContent(tab, component, [["lightning:textarea", {label: 'Title', value : tabName}]]);
            }
        }
    },
    handleTabBlurEvent : function (component, event, helper) {
        //Do Nothing
    }
})