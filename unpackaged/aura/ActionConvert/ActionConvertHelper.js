({
    configMap: {
        "ANYTYPE": { componentDef: "ui:inputText" },
        "BASE64": { componentDef: "ui:inputText" },
        "BOOLEAN": {componentDef: "ui:inputCheckbox" },
        "COMBOBOX": { componentDef: "ui:inputText" },
        "CURRENCY": { componentDef: "ui:inputCurrency" },
        "DATACATEGORYGROUPREFERENCE": { componentDef: "ui:inputText" },
        "DATE": { componentDef: "ui:inputDate", attributes: { displayDatePicker: "true"} },
        "DATETIME": { componentDef: "ui:inputDateTime", attributes: { displayDatePicker: "true"} },
        "DOUBLE": { componentDef: "ui:inputNumber", attributes: { format: "0.00"} },
        "EMAIL": { componentDef: "ui:inputEmail" },
        "ENCRYPTEDSTRING": { componentDef: "ui:inputText" },
        "ID": { componentDef: "ui:inputText" },
        "INTEGER": { componentDef: "ui:inputNumber", attributes: { format: "0"} },
        "MULTIPICKLIST": { componentDef: "LBI:InputMultiSelect", attributes: { } }, //{ componentDef: "ui:inputSelect", attributes: { multiple: true} },
        "PERCENT": { componentDef: "ui:inputNumber", attributes: { format: "0"} },
        "PICKLIST": { componentDef: "ui:inputSelect", attributes: { multiple: false} },
        "PHONE": { componentDef: "ui:inputPhone" },
        "REFERENCE": { componentDef: "LBI:InputLookup", attributes: { listIconClass: "custom:custom2", subtitleField:""} },
        "STRING": { componentDef: "ui:inputText" },
        "TEXTAREA": { componentDef: "ui:inputTextArea" },
        "TIME": { componentDef: "ui:inputDateTime", attributes: { displayDatePicker: "true", format: "h:mm a"} },
        "URL": { componentDef: "ui:inputURL" }
    },
    processConvertInitialLoad : function(component) {
        var action = component.get('c.convertStepOne');
        var recordId = component.get("v.parentId");
        var sObjectName = component.get("v.sObjectName");
        var recs = component.get("v.recommendations");

        return new Promise(function (resolve, reject) {
            action.setParams({
                recordId: recordId,
                sObjectName: sObjectName,
                recommendations: recs
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
    processConvertSave : function(component) {
        var action = component.get('c.attemptToSaveOpportunity');
        var pageInfo = component.get("v.pageInfo");
        pageInfo.partialOpportunity = component.get("v.partialOpp");

        var recs = component.get("v.recommendations");

        return new Promise(function (resolve, reject) {
            action.setParams({
                pageAsString: JSON.stringify(pageInfo),
                recommendations: recs
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
    generateEditableObject : function(component, helper) {
        var pageInfo = component.get("v.pageInfo");
        var fields = pageInfo.fieldsToMap;

        var oppty = component.get("v.partialOpp");

        var fieldsToEdit = [];
        var config = null;

        fields.forEach(function(fld) {
            var type = fld.type;

            if (helper.configMap[type] == undefined) {
                console.log('DID NOT FIMD: ' + type);
                type = 'ANYTYPE';
            }

            config = JSON.parse(JSON.stringify(helper.configMap[type]));
            // Add attributes.values if needed
            config.attributes = config.attributes || {};

            config.attributes.value = component.getReference("v.partialOpp." + fld.name);
            config.attributes.label = fld.label;
            config.attributes['aura:id'] = fld.name;

            if (fld.type == 'REFERENCE' || fld.type == 'MULTIPICKLIST') {
                //These values are for the custom inputLookup
                config.attributes.sObjectAPIName = "Opportunity";
                config.attributes.fieldAPIName = fld.name;
            }

            //Because the attributes that are "Specify on Convert" do not come from the Apex controller (they are null values)
            //there is no getter-setter. This means that the dynamic binding I put in place has nothing to update the values
            //Therefore, we attach the controls to an event we control, and update the properties in that event
            //Not much binding, but....
            config.attributes.change = component.getReference("c.handleStandardFieldChange");
            if (fld.type == 'DATE' || fld.type == 'TIME' || fld.type == 'DATETIME') {
                config.attributes.select = component.getReference("c.handleStandardFieldChange");
            }

            if (fld.options != []) {
                var opts = [];

                fld.options.forEach(function(opt) {
                    var val = {
                                label: opt,
                                value: opt
                                };

                    opts.push(val);
                });

                config.attributes.options = opts;
            }


            var newComponent = [config.componentDef, config.attributes];

            fieldsToEdit.push(newComponent);
        });

        $A.createComponents(
                fieldsToEdit,
                function(components, status, errorMessage){
                    if (status === "SUCCESS") {

                        component.set("v.opportunityFieldInfo", components);
                    }
                    else if (status === "INCOMPLETE") {
                        console.log("No response from server or client is offline.")
                        // Show offline error
                    }
                    else if (status === "ERROR") {
                        console.log(errorMessage);
                        console.log("Error: " + errorMessage);
                        // Show error message
                    }
                }
            );

    },
    fieldValueChanged : function(component, fieldName, newValue) {

        var opp = component.get("v.partialOpp");

        opp[fieldName] = newValue;

        component.set("v.partialOpp", opp);
    },
    fireCancelEvent : function(component) {
        var cancelEvent = component.getEvent("cancel");

        cancelEvent.fire();
	},
	fireSaveEvent : function(component) {
        var saveEvent = component.getEvent("save");
        var message = component.get("v.closingMessage");

        saveEvent.setParams({message: message});
        saveEvent.fire();
	},
    toggleSpinner: function(component) {
        var spinner = component.find("loadingSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})