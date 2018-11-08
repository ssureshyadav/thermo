/*
 * Shumon Saha, 15/07/2015
 * Declare test class and no visibility to existing data
 */
@isTest(seeAllData=true)
public class RSD_Archive_Contact_Schedulable_Test {
    // CRON expression: midnight on March 15. 
    // Because this is a test, job executes 
    // immediately after Test.stopTest(). 
    public static final String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void test() {
        list<User> u = [select Id
                        from User
                        where username like 'data.administrator@thermofisher.com%'
                        or username like 'deployment.administrator@thermofisher.com%'
                        order by username desc
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
                            limit 1];
            a.RSD_Customer_Flag__c = 'Flag';
            a.RSD_Customer_Type__c = 'Type';
            insert a;
            /*
             * Create sample contact
             */
            //Id RSDRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('RSDEU Contact').getRecordTypeId();
            Contact c = new Contact();
            c.LastName = 'Last Name';
            c.AccountId = a.Id;
            c.RSD_Archive__c = true;
            c.Reason_for_Archive__c = 'Reason for Archive';
            //c.RecordTypeId = RSDRecordType;
            /*
             * Insert the created sample data
             */
            insert c;
            /*
             * Update the sample contact and start test
             */
            Test.startTest();
            // Schedule the test job 
            String jobId = System.schedule(
                'ScheduleApexClassTest',
                CRON_EXP,
                new RSD_Archive_Contact_Schedulable()
            );
            // Get the information from the CronTrigger API object 
            CronTrigger ct = [
                SELECT Id, CronExpression, TimesTriggered, NextFireTime
                FROM CronTrigger
                WHERE id = :jobId
            ];
            // Verify the expressions are the same 
            System.assertEquals(CRON_EXP, ct.CronExpression);
            // Verify the job has not run 
            System.assertEquals(0, ct.TimesTriggered);
            // Verify the next time the job will run 
            System.assertEquals('2022-03-15 00:00:00', 
            String.valueOf(ct.NextFireTime));
            
            // Verify the scheduled job hasn't run yet. 
            
            list<Contact> contactList = [
                /*
                * Select ID and other fields required to be updated
                */
                SELECT Id, ownerId, AccountId, RSD_Archive__c
                FROM Contact
                /*
                * Which have been archived but the other fields aren't processed yet
                */
                WHERE Id = :c.Id
            ];
            System.assertEquals(contactList[0].RSD_Archive__c, true);
            Test.stopTest();
            // Now that the scheduled job has executed after Test.stopTest(), 
            // fetch the new merchandise that got added. 
            contactList = [
                /*
                * Select ID and other fields required to be updated
                */
                SELECT Id, ownerId, AccountId, RSD_Archive__c
                FROM Contact
                /*
                * Which have been archived but the other fields aren't processed yet
                */
                WHERE Id = :c.Id
            ];
            System.assertEquals(contactList[0].RSD_Archive__c, false);
        }
    }
}