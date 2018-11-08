public class RSDNA_NewAccountType {
	private ApexPages.StandardController controller;
    public string selectedType {get;set;}
    public List<SelectOption> rercordTypesOptions {get;set;}
    public List<SelectOption> rercordTypesOptions_Classic {get;set;}
    public List<Id> recordTypeInfo ;
    public Map<string,string> recondTypeInfoMap {get;set;}
    public Map<string,string> userRecordTypeInfo{get;set;}
    public Id profilename ;
    public Id sysAdminID ;
    
    public String retURL {get; set;}
    public String saveNewURL {get; set;}
    public String rType {get; set;}
    public String cancelURL {get; set;}
    public String ent {get; set;}
    public String confirmationToken {get; set;}
    
    public RSDNA_NewAccountType(ApexPages.StandardController controller){
        rercordTypesOptions = new List<SelectOption>();
        rercordTypesOptions_Classic = new List<SelectOption>();
        recondTypeInfoMap = new Map<string,string>();
        userRecordTypeInfo= new Map<string,string>();
        recordTypeInfo = new List<Id>();
        profilename = userinfo.getProfileId();
        sysAdminID=[SELECT Id, Name from Profile Where Name='System Administrator'].Id;
        
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        rType = ApexPages.currentPage().getParameters().get('RecordType');
        cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
        ent = ApexPages.currentPage().getParameters().get('ent');
        confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
        saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
        
    for(RecordTypeInfo info: Account.SObjectType.getDescribe().getRecordTypeInfos()) {
    if(info.isAvailable() && info.getName()!='Master') {
        rercordTypesOptions_Classic.add(new SelectOption(info.getRecordTypeId(), info.getName()));
        recondTypeInfoMap.put(info.getName(),info.getRecordTypeId());
        recordTypeInfo.add(info.getRecordTypeId());
    }
    if(info.isDefaultRecordTypeMapping()){
            selectedType = info.getRecordTypeId();
    }
    if(Test.isRunningTest() || (info.isDefaultRecordTypeMapping() && info.getName()=='Master')){
        
         rercordTypesOptions_Classic.add(new SelectOption(info.getRecordTypeId(), info.getName()));
         recondTypeInfoMap.put(info.getName(),info.getRecordTypeId());
         recordTypeInfo.add(info.getRecordTypeId());
    }
   } 
   System.debug('---->In Record type'+recordTypeInfo);
      
          if(!recordTypeInfo.isEmpty()) 
        {
            for(RecordType rType:[Select ID,Name,Description from RecordType Where Id IN : recordTypeInfo Order by Name ASC])
            {
                rercordTypesOptions.add(new SelectOption(rType.Id, (rType.Name+ ' \n ' + (rType.Description!= null?rType.Description:''))));
                userRecordTypeInfo.put(rType.Name,rType.Description!= null?rType.Description:''); 
                
            }
            if(recordTypeInfo[0]=='012000000000000AAA'){
                 rercordTypesOptions.add(new SelectOption('012000000000000AAA', 'Master'));
            }
        } 
      
    }
    
    public PageReference continueAction(){
      PageReference url;
        System.debug('---->Selected Value '+selectedType);
       
        if((profilename != sysAdminID) && (selectedType.equals(recondTypeInfoMap.get('RSD NA Customer')) || selectedType.equals(recondTypeInfoMap.get('RSD NA Customer Locked Record Type')) || selectedType.equals(recondTypeInfoMap.get('RSD NA Top of Group')) || selectedType.equals(recondTypeInfoMap.get('RSD Vendor')))){
           
            url=new PageReference('/apex/NewButtonOnAccountTab');
        }
        else {
              
            url=new PageReference('/001/e');
        }
        system.debug('=====>URL '+url);
        
        url.getParameters().put('retURL', retURL);
        url.getParameters().put('RecordType', rType);
        url.getParameters().put('cancelURL', cancelURL);
        url.getParameters().put('ent', ent);
        url.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
        url.getParameters().put('save_new_url', saveNewURL);
        url.getParameters().put('nooverride', '1');
        url.setRedirect(true);
        return url;
    }
    public PageReference cancel(){
    
     PageReference url;
     
       url = new PageReference('/001/o') ; 
       url.setRedirect(true); 
        return url;
    }
       
    
}