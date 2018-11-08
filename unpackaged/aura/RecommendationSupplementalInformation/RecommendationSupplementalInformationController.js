({
	init : function(component, event, helper) {

        component.set("v.pageCounter",1);
        component.set("v.searchTerm",'');

        Promise.all([lightningUtilities.getParams(component), helper.getSupplementalInfo(component)]).then(function(results) {
            //Set the page
            var pageParams = results[0]; //Page Stuff
            var suppInfoRecord = results[1]; //suppinfo Stuff

            component.set("v.suppInfo", suppInfoRecord);
            component.set("v.namespacePrefix", pageParams.namespace);


            helper.initializeSort(component);
            helper.processTitles(component);

            return Promise.all([suppInfoRecord, helper.getPageRecords(component)]);
        })
        .then(function(results) {
            // now I have both results (the previous one plus the page)
            var pagedRecords = results[1]; //pagedRecords

            helper.processPagedResults(component, helper, pagedRecords);
        })
        .catch(function (err) {
            helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });

	},
    handleChangeTerm: function(component, event, helper) {
        if (event.getParams("value").keyCode == 13) {
            helper.searchRecords(component, helper);
        }
    },
    handleSearch: function(component, event, helper) {
        helper.searchRecords(component, helper);
    },
    handleClearSearch: function(component, event, helper) {
        component.set("v.searchTerm", "");

        helper.searchRecords(component, helper);
    },
    sortTable: function(component, event, helper) {
        /*
        SK 1/11/17
        There is a significant bug, that clicking inside of the icon would not bubble the id of the element clicked
        So I created a component for the header and will handle the clicking via an event

        var columnId = event.toElement.id;
        var colName = columnId.substring(3);
        */

        var sortColumn = component.get("v.sortColumn");
        var isAscending = component.get("v.isAscending");

        var colName = event.getParam("apiName");

        if (colName == sortColumn) {
            isAscending = !isAscending;
        } else {
            sortColumn = colName;
            isAscending = true;
        }


        component.set("v.sortColumn", sortColumn);
        component.set("v.isAscending", isAscending);

        helper.changePage(component, helper);
    },
    firstPage : function(component, event, helper) {
        var cnt = component.get("v.pageCounter");
        cnt = 1;
        component.set("v.pageCounter",cnt);

        helper.changePage(component, helper);
    },
    previousPage : function(component, event, helper) {
        var cnt = component.get("v.pageCounter");
        cnt -= 1;
        component.set("v.pageCounter",cnt);

        helper.changePage(component, helper);
    },
    nextPage : function(component, event, helper) {
        var cnt = component.get("v.pageCounter");
        cnt += 1;
        component.set("v.pageCounter",cnt);

        helper.changePage(component, helper);
    },
    lastPage : function(component, event, helper) {
        var cnt = component.get("v.pageCounter");
        var pageInfo = component.get("v.pageInfo");
        cnt = pageInfo.totalPageCount;
        component.set("v.pageCounter",cnt);

        helper.changePage(component, helper);
    },
    goToExportPage: function(component, event, helper) {
        var pageInfo =  component.get("v.suppInfo");
        var supplementalInformationId = component.get("v.supplementalInformationId");
        var searchTerm = component.get("v.searchTerm");
        var namespacePrefix = component.get("v.namespacePrefix");

        var queryString = '';

        queryString += '?supplInfoId=' + supplementalInformationId;
        queryString += '&acctId=' + pageInfo.accountId;
        queryString += '&searchTerm=' + searchTerm;
        queryString += '&isAccountLevel=' + pageInfo.isAccountLevel;

        //SK 1/26/17 - Used window.open so I do not get an empty screen when navigating there.
        //var urlEvent = $A.get("e.force:navigateToURL");
        // urlEvent.setParams({
        //     "url": '/apex/SupplementalInfoCsvGenerator' + queryString
        // });

        //urlEvent.fire();
        window.open('/apex/' + namespacePrefix + 'SupplementalInfoCsvGenerator' + queryString, '_blank');

    }
})