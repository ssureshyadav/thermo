({
	init : function(component, event, helper) {

		helper.consolidateFieldTypes(component);

		var fieldValue = component.get('v.fieldValue');
		var fieldType = component.get('v.fieldType');

		var displayValue = fieldValue;
		var numberRegEx = new RegExp('^\\d+$');

		if (fieldType == 'BOOLEAN') {
			displayValue = (fieldValue == 'true');
		} else if (fieldType == 'DATETIME' &&  numberRegEx.test(fieldValue)) {
			//We do this because company profile (from Dante) returns dates as unix seconds
			//SFDC, instead, returns it as text (so I don't have to convert)
			displayValue = new Date(fieldValue*1000);
		}

		component.set('v.displayValue', displayValue);
	}
})