/*
 * Shumon Saha, 10/08/2015
 */
@isTest(seeAllData=true)
public class Contact_Roles_on_Contact_Test {
    static testmethod void test() {
        list<User> u = [select Id
                        from User
                        where username like 'data.administrator@thermofisher.com%'
                        or username like 'deployment.administrator@thermofisher.com%'
                        limit 2];
        System.runAs(u[1]) {
            /*
             * Fetches or creates a Custom Setting at the organization level
             */
            RSD_Organization_Specific_Settings__c org_settings =
                RSD_Organization_Specific_Settings__c.getOrgDefaults();
            if (org_settings == null) {
                org_settings = new RSD_Organization_Specific_Settings__c();
            }
            org_settings.RSD_Execute_Triggers__c = true;
            org_settings.RSD_Execute_Validation_Rules__c = true;
            org_settings.RSD_Execute_Workflow_Rules__c = true;
            org_settings.RSD_NA_Sales_Operations_Admin_User_ID__c = u[0].Id;
            upsert org_settings;
            /*
             * Create sample account
             */
            Account a = new Account();
            a.Name = 'Account';
            /*
             * Get record type
             */
            a.RecordType = [select Id
                            from RecordType
                            where Name = 'RSD CBP'
                            and SobjectType = 'Account'
                            limit 1 ];
            a.RSD_Customer_Flag__c = 'Flag';
            a.RSD_Customer_Type__c = 'Type';
            insert a;
            /*
             * Create sample contact
             */
             
            Id RSDRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('RSDEU Contact').getRecordTypeId();
            Contact c = new Contact();
            c.LastName = 'Last Name';
            c.AccountId = a.Id;
            c.RSD_Archive__c = false;
            c.RecordTypeId = RSDRecordType;
            /*
             * Insert the created sample data
             */
            insert c;
             // start the test execution context
            Test.startTest();
            // set the test's page to the VF page (or pass in a PageReference)
            Test.setCurrentPage(Page.Contact_Roles_on_Contact);
            // call the constructor
            Contact_Roles_on_Contact crc = new Contact_Roles_on_Contact(new ApexPages.StandardController(c));
            // stop the test
            Test.stopTest();
        }
    }
}