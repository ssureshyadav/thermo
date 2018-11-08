/*
Created By :Kuldeep
Email ID : kulrathore@deloitte.co.uk    
Company : Deloitte
Date : 08/07/2015
Class for showing Parent team members on child account inline.
Test Class : team_members_test
*/
public class team_members {
    ApexPages.StandardController acc;
     public Schema.Account acct;
     public boolean mess{get;set;}
     public List<AccountTeammember> atm {get;set;}
     public team_members(ApexPages.StandardController controller) {
        acc= Controller;
        this.acct=(Schema.Account)acc.getRecord();
        Account a =[select parentid from account where id=:acct.id];
        If(a.parentid==null)
        {
            mess=true;
        }
        atm=[Select User.name, TeamMemberRole,AccountAccessLevel,Account.owner.name from AccountTeammember where AccountId =: a.parentid];
        If(atm.size()==0)
        mess=true;
        
    }

}