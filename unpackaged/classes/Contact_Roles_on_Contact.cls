/**
 * Shumon, 10/08/2015
 */
public class Contact_Roles_on_Contact {
    ApexPages.StandardController stdController;
    public Contact contactRecord;
    public List<AccountContactRole> contactRoleList {
        get;
        set;
    }
    public Contact_Roles_on_Contact(ApexPages.StandardController controller) {
    	stdController = controller;
    	contactRecord = (Schema.Contact)stdController.getRecord();
		contactRoleList = [
            SELECT
            	AccountId,
                Account.Name,
            	IsPrimary,
            	Role
            FROM
            	AccountContactRole
            where
            	ContactId =: contactRecord.Id
        ];
    }
}