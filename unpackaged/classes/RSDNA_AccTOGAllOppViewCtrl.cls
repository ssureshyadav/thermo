/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 01 April,2017
    Requirement : W-000018 : T-00015 ,T-00014,T-00016
    Description : This call is a Controller for the VF page RSDNA_AccTOGAllOppView_VF, This is used to display all the Opportunities under TOG and its corresponding child accounts
    Test Class  : RSDNA_AccTOGAllOppViewCtrlTest
    Last Updated By :
    
*/

public with sharing class RSDNA_AccTOGAllOppViewCtrl {
public String Accid{get;set;}
public Boolean noOppFlag{get;set;}
public List<opportunity> Opplst{get;set;}
public Account sourceAccount;
public ID acctID;

/*
   Parameters : StandardController as input to the constructor */

    public RSDNA_Acctogalloppviewctrl (ApexPages.StandardController controller) {
    account temp=(Account)controller.getRecord();
    Accid = temp.id;
    this.sourceAccount = [select id,ParentId from Account where id = :Accid limit 1];
    id parentAccID = sourceAccount.ParentId;
    // Check whether the current Account is the parent Account
    
    if(parentAccID == Null){
    // get all the child accounts related to parent Account
    Opplst =[SELECT Id,Name,AccountId,Amount,Account.Name,CloseDate,Opportunity_Owner_TEXT__c,OwnerId,Probability,StageName FROM Opportunity where (AccountId IN: ([select id,ParentId from Account where ParentId =: Accid]) OR AccountId =: Accid) AND (StageName NOT IN ('Closed Won','Closed Lost')) ];
    }
    else{
    Opplst = new List<opportunity>([SELECT Id,Name,AccountId,Account.Name,Amount,CloseDate,Opportunity_Owner_TEXT__c,OwnerId,Probability,StageName FROM Opportunity where AccountId =: Accid AND (StageName NOT IN ('Closed Won','Closed Lost'))]);
    }
      
    if(Opplst.size() == 0){
    noOppFlag = False ;
    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'There are no Opportunities Related to this TOG'));
    }else{
    noOppFlag = True ;
    }
   }

}