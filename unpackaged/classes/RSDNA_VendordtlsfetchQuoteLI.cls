/*
    Created By  : Venkatesh Kumar Sakthivel
    Email ID    : venkateshkumar.sakthivel@nttdata.com    
    Company     : NTTDATA
    Date        : 01 May,2017
    Requirement : W-000095:T-00101: Update the Vendor Id information in the Quote Line item.
    Description : Fetch the Vendor Account information for the corresponding Quote Line item based on RSD_Source_System__c and Vendor Number                
    Test Class  : RSDNA_VendordtlsfetchQuoteLITest
    Last Updated By : Venkatesh Kumar Sakthivel
    
*/

public class RSDNA_VendordtlsfetchQuoteLI{

    public void updatevendorinfo(List<RSD_Quote_Line_Item__c> lstNewQuoteLineItem , Map<ID,RSD_Quote_Line_Item__c> mapOldQuoteLineItem){
   
    List<string> getCMFvendorInfo = new List<string>();
    List<string> getUSMFvendorInfo = new List<string>();
    Map<string,id> mapvendorID = new Map<string,id>();    
    List<id> quotetoprocess = new List<id>();
    List<RSD_Quote_Line_Item__c> updateQuoteLineitem = new List<RSD_Quote_Line_Item__c>();
    
    for(RSD_Quote_Line_Item__c Qli : lstNewQuoteLineItem){
        
        if(mapOldQuoteLineItem != Null){    
            if(Qli.RSD_Vendor_Number__c != Null && Qli.RSD_Source_System__c != Null ){                
                if(Qli.RSD_Source_System__c == 'CMF'){              
                getCMFvendorInfo.add(Qli.RSD_Vendor_Number__c);     
                }
                if(Qli.RSD_Source_System__c == 'USMF'){
                getUSMFvendorInfo.add(Qli.RSD_Vendor_Number__c);        
                }       
            }
        } else{
            if(Qli.RSD_Vendor_Number__c != Null && Qli.RSD_Source_System__c != Null ){
                if(Qli.RSD_Source_System__c == 'CMF'){              
                getCMFvendorInfo.add(Qli.RSD_Vendor_Number__c);     
                }
                if(Qli.RSD_Source_System__c == 'USMF'){
                getUSMFvendorInfo.add(Qli.RSD_Vendor_Number__c);        
                }   
            }         
        }
    }   
   
        if(!getCMFvendorInfo.isEmpty() || !getUSMFvendorInfo.isEmpty()){
            for(Account acc: [select id,RSD_CA_Account_Number__c,RSD_US_Account_Number__c from Account where (RSD_CA_Account_Number__c IN: getCMFvendorInfo or RSD_US_Account_Number__c IN: getUSMFvendorInfo) and recordtypeID =: Schema.SObjectType.Account.getRecordTypeInfosByName().get('RSD Vendor').getRecordTypeId()]){         
            if(acc.RSD_CA_Account_Number__c != null){
            mapvendorID.put(acc.RSD_CA_Account_Number__c,acc.id);           
            }
            if(acc.RSD_US_Account_Number__c != null){
            mapvendorID.put(acc.RSD_US_Account_Number__c,acc.id);   
            }                   
            }
        }

        for(RSD_Quote_Line_Item__c QliValue : lstNewQuoteLineItem){
        QliValue.Vendor__c = mapvendorID.get(QliValue.RSD_Vendor_Number__c);            
        }     
    
    }
 }