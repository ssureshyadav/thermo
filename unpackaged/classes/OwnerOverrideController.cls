public with sharing class OwnerOverrideController {
        
    public ApexPages.StandardController stdCntrlr {get; set;}
    public OwnerOverrideController(ApexPages.StandardController controller) {stdCntrlr = controller;}
    
    public PageReference redirPage() {
        try {
            Id profileId = UserInfo.getprofileid();
            String profileName = [SELECT Id, Name FROM Profile WHERE Id =: profileId].Name;
            System.debug('Profile name: ' + profileName);
            
            if(profileName.equalsIgnoreCase('RSD NA Sales Operations User')) {
                return null;
            }
            else {
                PageReference p = new PageReference('/' + Account.SObjectType.getDescribe().getKeyPrefix() + '/e');
                Map<String, String> m = p.getParameters();
                m.putAll(ApexPages.currentPage().getParameters());
                m.put('nooverride', '1');
                p.setRedirect(true);
                return p;
                }
                }
    
        catch(Exception objEx) {
            String stMsg = 'Exception while redirecting to VF page.';
            String stErrMessage = objEx.getTypeName() + ': ' + stMsg;
            System.debug(stErrMessage);
            return null;
        }
    }

// Below code for all the profiles in custom setting Redirect_Profile__c, page will be redirected to mypage1 and for other
// profiles page will be redirected to mypage 2. Still needs to be tested.        
       /* public PageReference redirect2() {
            Integer flag=0;
            List<Redirect_Profile__c> l = Redirect_Profile_c.getall().values();
            pagereference pr;
            for(Redirect_Profile__c p: l) {
                Profile p1 = [SELECT id FROM Profile WHERE name= :p.name];
                if(Userinfo.getProfileID() ==p1.id) {
                    flag=1;
                }
            }
            if(flag==1) {
                pr=Page.mypage1;
            } else
                pr=Page.mypage2;
            return pr;
       } */
}