/*
    Created By  : Suresh Sanneboina
    Email ID    : 
    Company     : NTTDATA
    Date        : 5 June,2017
    Requirement : W-000027:T-00350: Dev - Create "Add/Update Vendor" button on Events
    Test Class  : RSDNA_AddUpdateVendorTest
    Last Updated By : 
    
*/
public Class RSDNA_AddUpdateVendor
{

    public RSDNA_AddUpdateVendor()
    {
        getVendorAccounts();
    }
    public String searchText { get; set; }
    
    public List<Account> lstAccount {get;set;}
    
    public String accountId {get;set;}

    public PageReference btncancel() {
        PageReference pg=new pageReference('/'+Apexpages.currentPage().getParameters().get('Id'));
        pg.setRedirect(true);
        return pg;
    }
    
    public void getSearchAccounts()
    {
        if(searchText != null)
        {
            searchText =searchText.trim();
        }
        Id recordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').recordtypeId;
        lstAccount =new List<Account>();
        lstAccount.addAll((List<Account>)DataBase.query('SELECT Id,Name,ERP_Number__c,Phone,Type,BillingCity,BillingCountry,BillingState,BillingStreet FROM Account WHERE RecordtypeId= : recordTypeId AND RSD_Account_Status__c = \'Active\' AND (Name like ' + '\'' + '%' + searchText + '%' +'\''  +' OR ERP_Number__c like ' + '\'' + '%' + searchText + '%' +'\') Limit 1000'));
    }


    
    @auraEnabled
    public void getVendorAccounts()
    {

        Id recordTypeId = Schema.SobjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').recordtypeId;
        lstAccount =new List<Account>();
        lstAccount.addAll([SELECT 
                    Id,Name,ERP_Number__c,Phone,Type,BillingCity,BillingCountry,BillingState,BillingStreet 
                FROM 
                    Account 
                WHERE 
                    RecordtypeId= : recordTypeId 
                AND 
                    RSD_Account_Status__c ='Active' 
                LIMIT 100]);
        
    }
    
    @auraEnabled
    public static Boolean refreshPage(Id recordId)
    {
        Event evt=[Select Id,RSDNA_RefreshPage__c FROM Event Where ID =:recordId];
        if(evt.RSDNA_RefreshPage__c)
        {
            evt.RSDNA_RefreshPage__c =false;
            update evt;
            return true;
        }
        return false;
                
    }
    
    
    
    
    
    public pageReference updateEvent()
    {
        Account acct=[Select Id,Name,RSD_US_Account_Number__c,RSD_CA_Account_Number__c from Account Where Id = : accountId];
        Event evt=new Event(Id = Apexpages.currentPage().getParameters().get('Id'),RSD_Vendor_Text__c = acct.Name,RSD_Vendor_ID__c = acct.Id);
        evt.RSD_US_Vendor_Number__c =acct.RSD_US_Account_Number__c;
        evt.RSD_CA_Vendor_Number__c = acct.RSD_CA_Account_Number__c;
        evt.RSDNA_RefreshPage__c =true;
        update evt;
        //PageReference pg=new pageReference('/apex/RSDNA_PageNavigate?id='+Apexpages.currentPage().getParameters().get('Id'));
        PageReference pg=new pageReference('/'+Apexpages.currentPage().getParameters().get('Id'));
        //PageReference pg=new pageReference('/one/one.app?source=aloha#/'+'sObject/'+Apexpages.currentPage().getParameters().get('Id')+'/view');
        pg.setRedirect(true);
        return pg;
    }
    
    public pageReference navigate()
    {
        PageReference pg=new pageReference('/'+Apexpages.currentPage().getParameters().get('Id'));
        //PageReference pg=new pageReference('/one/one.app?source=aloha#/'+'sObject/'+Apexpages.currentPage().getParameters().get('Id')+'/view');
        pg.setRedirect(true);
        return pg;
    }
    
    
    
    
    
}