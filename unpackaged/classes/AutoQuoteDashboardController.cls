public with sharing class AutoQuoteDashboardController {

public List<Opportunity> oppRecords{get; set;}
public Boolean noData {get; set;}
public Boolean hasData {get; set;}
public Boolean displayVF {get; set;}
public User currentuser {get; set;}
public Set<String> salesId = new Set<String>{'AM', 'RM', 'RS'};
public String ownRec = 'AMDS';

    public AutoQuoteDashboardController(){
        oppRecords = new List<Opportunity>();        
        currentuser=new User();
        currentuser=[SELECT Id, Sales_ID__c FROM User WHERE Id=:userinfo.getuserId() LIMIT 1];
        if(currentUser.Sales_ID__c != null && salesId.contains(currentUser.Sales_ID__c.substring(0,2))){
            displayVF = true;
        }
        else{
            displayVF  = false;
        }
        if(displayVF == true){
            if(currentUser.Sales_ID__c.substring(0,4) == ownRec){
                oppRecords = [SELECT Id, 
                                     Name, 
                                     Account.Name, 
                                     StageName, 
                                     OwnerId, 
                                     Owner.Name, 
                                     Account.ShippingCity, 
                                     Account.ShippingPostalCode, 
                                     Account.ShippingCountry 
                                     FROM Opportunity 
                                     where CreatedDate >= YESTERDAY 
                                     and Name Like 'AutoQuote: %' AND OwnerId =: userinfo.getuserId()];    
            }
            else{
                oppRecords = [SELECT Id, 
                                     Name, 
                                     Account.Name, 
                                     StageName, 
                                     OwnerId, 
                                     Owner.Name, 
                                     Account.ShippingCity, 
                                     Account.ShippingPostalCode, 
                                     Account.ShippingCountry 
                                     FROM Opportunity 
                                     where CreatedDate >= YESTERDAY 
                                     and Name Like 'AutoQuote: %'];
            }                        
            System.debug('size: ' + oppRecords.size());
            if(oppRecords.size()>0){
                noData = false;
                hasData = true;
            }
            else{
                noData = true;
                hasData = false;
            }
        }
    }
    
}