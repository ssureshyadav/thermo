@isTest(SeeallData=true)
public class RSDNA_AccTOGAllOppViewCtrlTest {
  //user definition
  //user TestUser = new user (FirstName ='Tester', LastName = 'Pro', Alias = 'ProT', Email = 'test@sfdc.com', Username = 'Tester@Pro.com', CommunityNickname = 'Tester', UserRole = 'Global CEO', User License = 'Salesforce', EmailEncodingKey = 'Japanese (JIS)', Profile='Integration Administrator', IsActive = True); 
  //System.runAs(TestUser);  
  //Methods definition
  //test.startTest();
  
    static testMethod void RSDNA_AcctogalloppviewctrlTest01(){
    //Test Data Setup
    RSDNA_DataFactory data = new RSDNA_DataFactory();
    ID RecID = Schema.SObjectType.account.getRecordTypeInfosByName().get('RSD NA Customer').getRecordTypeId();
    List<Account> acc = data.insertAccount(1,RecID);
    //List<Opportunity> opp = data.insOpportunity(1,'01224000000LB5D',acc[0].Id);
    system.debug('accInsert------------->'+data);
    ApexPages.StandardController sc = new ApexPages.StandardController(acc[0]);
    RSDNA_Acctogalloppviewctrl rr = new RSDNA_Acctogalloppviewctrl(sc);
    }
  //test.stopTest();
  //Exception Handling
}