@isTest
private class RSDNA_LtngReadOnlyAccountTeamsTest {
    @isTest
    private static void check(){
       Profile profileId = [SELECT Id FROM Profile WHERE Name = 'RSD NA Sales User' LIMIT 1];
        User u=new User(email='rsdna@gmail.com', 
                        LastName='Sales', Alias='RSD', UserName='rsdna@gmail.com', 
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                       ProfileId = profileId.id);
        Insert u;
        //system.debug('u--------------->'+u);
        
        Account acc = new Account(Name='Test');
		insert acc;        
        System.runAs(u){ 
            
            RSDNA_LtngReadOnlyAccountTeams.checkProfileAccess();
            RSDNA_LtngReadOnlyAccountTeams.accountTeams(acc.Id);
        
        }
    }
    
   

}