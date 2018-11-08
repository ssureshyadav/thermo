public without sharing class RSD_TriggerSettings {

  public static Map<String,RSD_Triggers__c> triggerSettingsMap;
  public static Boolean getIsTriggerEnabled(String triggerName){
    if(null == triggerSettingsMap){
      triggerSettingsMap = RSD_Triggers__c.getAll();
    }
    
    RSD_Triggers__c thisTriggerSetting = triggerSettingsMap.get(triggerName);
    Boolean returnFlag = true;
   
    if(null == thisTriggerSetting){
      system.debug('No setting found for trigger:  '+triggerName);
      returnFlag = True;
    } else {
      returnFlag = thisTriggerSetting.IsEnabled__c;
    }
   
    return returnFlag;
  }
}