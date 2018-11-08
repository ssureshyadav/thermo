({
	getSupplementalInfo : function(component) {
		var action = component.get('c.getSupplementalInformationDefinition');
		var recordId = component.get("v.recordId");
	 	var sObjectName = component.get("v.sObjectName");
	 	var supplementalInformationId = component.get("v.supplementalInformationId");

        return new Promise(function (resolve, reject) {
            action.setParams({
            	suppInfoId: supplementalInformationId,
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
	getPageRecords : function(component) {
		var action = component.get('c.getRecords');

		var pageInfo =  component.get("v.suppInfo");
	 	var supplementalInformationId = component.get("v.supplementalInformationId");
	 	var sortColumn = component.get("v.sortColumn");
		var isAscending = component.get("v.isAscending");
		var pageNumber = component.get("v.pageCounter");
		var searchTerm = component.get("v.searchTerm");

		if (searchTerm != '') {
   			$A.util.removeClass(component.find("clearSearch"), "hideMe");
		} else {
			$A.util.addClass(component.find("clearSearch"), "hideMe");
		}

        return new Promise(function (resolve, reject) {
            action.setParams({
            	suppInfoId : supplementalInformationId,
				accountId: pageInfo.accountId,
				isAccountLevel: pageInfo.isAccountLevel,
				searchTerm: searchTerm,
				sortColumn : sortColumn,
				isAscending : isAscending,
				pageNumber: pageNumber
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
	initializeSort : function(component) {
		var pageInfo =  component.get("v.suppInfo");
		//Have to find the first column that is sortable
		var firstColumn = "";
		var alreadyFound = false;

		pageInfo.fieldsInOrder.forEach(function(fld){
			if (! alreadyFound) { //can't break out of a "forEach"
				firstColumn = fld;

				if (pageInfo.allFields[firstColumn].isSortable) {
					alreadyFound = true;;
				}
			}
		});

		component.set("v.sortColumn", firstColumn);
		// wrapper.selectedSortColumn = firstColumn;
		component.set("v.isAscending", true);
	},
	processPagedResults : function(component, helper, pagedRecords) {
		component.set("v.pageInfo", pagedRecords);

		if (pagedRecords.records.length > 0) {
			if (pagedRecords.hasNext || pagedRecords.hasPrevious) {
				//Only set this if I found at least two pages. Otherwise, the buttons won't be in the DOM
				component.find("firstButton").set("v.disabled", !pagedRecords.hasPrevious);
				component.find("prevButton").set("v.disabled", !pagedRecords.hasPrevious);
				component.find("nextButton").set("v.disabled", !pagedRecords.hasNext);
				component.find("lastButton").set("v.disabled", !pagedRecords.hasNext);
			}

			//Now get the records with the fields sorted (see "processTitles" as to why)
			var pageInfo = component.get("v.suppInfo");

			var sortedRecords = [];

			pagedRecords.records.forEach(function(rec){
				var record = {fields: []};

				pageInfo.fieldsInOrder.forEach(function(fld){
					var recValue = helper.getFieldValueFromName(rec, fld, 0);

					var value = {  apiName: fld,
							  	fieldLabel: pageInfo.allFields[fld].label,
							  	 fieldType: pageInfo.allFields[fld].fieldType,
									 value: recValue.value,
								 relatedId: recValue.id};

					record.fields.push(value);
				});

				sortedRecords.push(record);
			});

			component.set("v.sortedRecords", sortedRecords);
		}


        this.toggleSpinner(component);
	},
	getFieldValueFromName : function(record, fieldName, level) {
		if (! fieldName.includes(".")) {
			//Regular Field
			var recordReturn = {id: '', value: ''};

			recordReturn.value = record[fieldName];
			if (level > 0) {
				//Only do this for relationship fields
				recordReturn.id = record['Id'];
			}

			return recordReturn;
		} else {
			//Figure out the first object name
			var tokens = fieldName.split(".");

			var newObjectName = tokens[0];

			var newTokens = tokens.slice(1);
			var newFieldName = newTokens.join(".");

			if (record[newObjectName] == undefined) {
				return '';
			} else {
				return this.getFieldValueFromName(record[newObjectName], newFieldName, ++level);
			}
		}
	},
	searchRecords : function(component, helper) {
		this.toggleSpinner(component);

        component.set("v.pageCounter",1);

        this.getPageRecords(component).then(function(result) {
            var pagedRecords = result; //pagedRecords

            helper.processPagedResults(component, helper, pagedRecords);
        })
        .catch(function (err) {
        	helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });
	},
	changePage : function(component, helper) {
		this.toggleSpinner(component);

        this.getPageRecords(component).then(function(result) {
            var pagedRecords = result; //pagedRecords

            helper.processPagedResults(component, helper, pagedRecords);
        })
        .catch(function (err) {
        	helper.toggleSpinner(component);

            lightningUtilities.handleError(err);
        });
	},
	processTitles : function (component) {
		/*SK 1/9/17
		Because I cannot refer to map like this: {!v.suppInfo.fieldColumnHeaderMap[columnHeaderKey]}
		I will create a list in the controller with all the titles, pre-sorted
		*/
		var pageInfo = component.get("v.suppInfo");

		var titles = [];
		pageInfo.fieldsInOrder.forEach(function(fld){
			var sortedTitle = {apiName: fld,
								label: pageInfo.allFields[fld].label,
								isSortable: pageInfo.allFields[fld].isSortable};

			titles.push(sortedTitle);
		});

		component.set("v.titles", titles);
	},
	toggleSpinner: function(component) {
		var spinner = component.find("loadingSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
	}
})