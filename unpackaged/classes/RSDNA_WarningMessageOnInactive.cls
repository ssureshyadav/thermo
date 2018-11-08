/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 11 April,2017
    Requirement : W-000021 : T-00023
    Description : This call is a Controller for the VF page RSDN_WarningMessageOnInactive, This is used to display to the end user when the Account gets Inactive
    Test Class  : 
    Last Updated By :
    
*/

public with sharing class RSDNA_WarningMessageOnInactive {
    private final account acc;  
    //W-000021 : T-00023 : Dev - Display a message when users manually change the Account Status to 'Inactive'
    public RSDNA_WarningMessageOnInactive (Apexpages.StandardController stdController){
        this.acc =(Account)stdController.getRecord();       
    }
    
    public PageReference Dismiss(){
        acc.RSD_Display_Alert__c = false ;
        update acc;        
        //referesh Page     
        return new PageReference('/'+acc.id);    
    }
}