/*
    Created By  : Suresh Sanneboina
    Email ID    : sanneboinasuresh.yadav@nttdata.com    
    Company     : NTTDATA
    Date        : 03 April,2017
    Description : 
                    -W-000046
                    - Get contacts where Record Type = 'RSDNA Contact' and Archive = True 
                    - Change the Contact Owner to a predefined Sales Operations Admin or System Admin user (Custom Setting RSD_Organization_Specific_Settings__c) 
                    - Set Contact Status to Inactive and Archive field to False
    Test Class  : RSDNA_Archive_Contact_Batch_Test
*/

global class RSDNA_Archive_Contact_Batch implements Database.Batchable<sObject> {

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT 
                                                Id, ownerId, AccountId
                                            FROM 
                                                Contact
                                            WHERE 
                                                RSD_Archive__c = true
                                            AND
                                                RecordTypeId = : Schema.SobjectType.Contact.getRecordTypeInfosByName().get('RSD NA Contact').getRecordTypeId()
                                            ]);
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        
        //Get org specific values
        RSD_Organization_Specific_Settings__c org_settings =RSD_Organization_Specific_Settings__c.getOrgDefaults();
    
        //Initialize list to add records to update the archive,owner and account fields.
        List<Contact> lstUpdateContact=new List<Contact>();
        //Loop Through the records that are queried on the start method.
        for (Contact c : scope) {
            Contact cont=new Contact(Id = c.Id,RSD_Contact_Status__c ='Inactive',RSD_Archive__c = false);
            if(org_settings.RSD_NA_Sales_Operations_Admin_User_ID__c != null){
                cont.ownerId =org_settings.RSD_NA_Sales_Operations_Admin_User_ID__c;
            }
            //add records to List
            lstUpdateContact.add(cont);
        }
        
        //Check the list has records to update
        if(!lstUpdateContact.isEmpty())
        {
            //Update contacts
            update lstUpdateContact;
        }
    }

    global void finish(Database.BatchableContext BC)
    {
    }
}