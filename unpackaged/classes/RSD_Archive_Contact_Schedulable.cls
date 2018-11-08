global class RSD_Archive_Contact_Schedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        /*
		* Get org specific values
		*/
        RSD_Organization_Specific_Settings__c org_settings =
            RSD_Organization_Specific_Settings__c.getOrgDefaults();
        /*
		* Org specific custom setting should exist
		*/
        if(org_settings != null &&
           /*
			* Org specific value for reassignment user ID should be populated
			*/
           org_settings.RSD_Sales_Operations_Admin_User_ID__c != null) {
            /*
             * For all updated contacts
             */
            list<Contact> contactList = [
                /*
                 * Select ID and other fields required to be updated
                 */
                SELECT Id, ownerId, AccountId
                FROM Contact
                /*
                 * Which have been archived but the other fields aren't processed yet
                 */
                WHERE RSD_Archive__c = true
                AND ownerId != :org_settings.RSD_Sales_Operations_Admin_User_ID__c
                AND AccountId != null
            ];
			for (Contact c : contactList) {
                c.ownerId = org_settings.RSD_Sales_Operations_Admin_User_ID__c;
                c.AccountId = null;
                /*
                 * Uncheck the Archive box after archiving is done
                 */
                c.RSD_Archive__c = false;
            }
            update contactList;
		}
    }
}