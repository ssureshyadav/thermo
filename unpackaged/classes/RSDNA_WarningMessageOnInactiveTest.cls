@isTest(seeAllData = True)
Public class RSDNA_WarningMessageOnInactiveTest{

    static TestMethod Void displayMessage(){
    ID RecID = Schema.SObjectType.account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId();
    
    RSDNA_DataFactory data = new RSDNA_DataFactory();
    List<Account> acc = data.insertAccount(1,RecID);
    
    ApexPages.standardController sc = new apexpages.standardController(acc[0]);
    RSDNA_WarningMessageOnInactive cntrl = new RSDNA_WarningMessageOnInactive (sc);   
    cntrl.Dismiss();
    }

}