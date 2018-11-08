({
	consolidateFieldTypes : function(component) {
		//Here we will normalize the field types into just the basic ones
		var typeName = component.get('v.fieldType');

		if (typeName == 'PICKLIST' || typeName == 'MULTIPICKLIST') {
            typeName =  'STRING'; //they display as strings
        }

        if (typeName == 'DOUBLE' || typeName == 'PERCENT' || typeName == 'INTEGER' || typeName == 'FLOAT') {
            typeName = 'NUMBER'; //they display as Numbers
        }

        if (typeName == 'REFERENCE') {
            typeName =  'ID'; //they compare as IDS
        }

        //Everything I can't display as its own value, turn it into a string display, to make the markup easier to read
        if (typeName != 'DATETIME' &&
			typeName != 'DATE' &&
			typeName != 'EMAIL' &&
			typeName != 'PHONE' &&
			typeName != 'CURRENCY' &&
			typeName != 'NUMBER' &&
			typeName != 'BOOLEAN' &&
			typeName != 'TEXTAREA' &&
			typeName != 'URL') {

        	typeName = 'STRING';
        }

        //Anything not on the above, will display as its default style
		component.set('v.displayType', typeName);
	}
})