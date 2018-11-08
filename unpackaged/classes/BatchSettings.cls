global without sharing class BatchSettings {
    public class BatchSettingsException extends Exception {}
    
    private static Map<String, RSD_Batch_Settings__c> batchSettingsMap;
    private static System.LoggingLevel debugLevel = LoggingLevel.DEBUG;
    
    public static BatchSettings.SettingWrapper getBatchSettings(String batchName){
        if(null == batchSettingsMap){
            batchSettingsMap = RSD_Batch_Settings__c.getAll();
        }
        
        RSD_Batch_Settings__c thisBatchSetting = batchSettingsMap.get(batchName);
        SettingWrapper returnSetting;
        
        if(null == thisBatchSetting){
            system.debug(debugLevel, 'No setting found for batch:  '+batchName);
            returnSetting = new SettingWrapper();
            returnSetting.name = batchName;
            returnSetting.isEnabled = true;
            returnSetting.emails = new List<String>();
            returnSetting.sendEmails = true;
            returnSetting.batchSize = 200;
            returnSetting.nextBatch = '';
            returnSetting.lastSucessfulRunDate = null;
            returnSetting.doNotRunNextBatchOnError = false;
        } else {
            returnSetting = new SettingWrapper();
            returnSetting.name = thisBatchSetting.Name;
            returnSetting.isEnabled = thisBatchSetting.RSD_Is_Enabled__c;
            returnSetting.emails = thisBatchSetting.RSD_Status_Email_Recipient__c.split(',');
            returnSetting.sendEmails = thisBatchSetting.RSD_Send_Emails__c;
            returnSetting.batchSize = Integer.valueOf(thisBatchSetting.RSD_Batch_Size__c);
            returnSetting.nextBatch = thisBatchSetting.RSD_Next_Batch_Name__c;
            returnSetting.lastSucessfulRunDate = thisBatchSetting.RSD_Last_Successful_Run_Date__c;
            returnSetting.doNotRunNextBatchOnError = thisBatchSetting.RSD_Do_Not_Run_Next_Batch_On_Error__c;
        }
        
        return returnSetting;
    }
    
    public void setLastSuccessfulRunDateToday(String batchName){
        
        RSD_Batch_Settings__c configEntry = [Select Id, Name, RSD_category__c, RSD_Last_Successful_Run_Date__c From RSD_Batch_Settings__c Where Name = : batchName ]; 

        configEntry.RSD_Last_Successful_Run_Date__c = Date.Today();
        
        update configEntry;
    
    }
    
    public void setLastSuccessfulRunDate(String batchName, datetime dt){
        
        List<RSD_Batch_Settings__c> configEntry = [Select Id, Name, RSD_category__c, RSD_Last_Successful_Run_Date__c From  RSD_Batch_Settings__c Where Name = : batchName Limit 1]; 

        system.debug( 'configEntry ' + configEntry + ' batchName ' + batchName );
        
        if ( !configEntry.IsEmpty() )   
        {            
            configEntry[0].RSD_Last_Successful_Run_Date__c = dt;
            
            update configEntry;
        }
    }
    
    global class SettingWrapper {
        public String name;
        public Boolean isEnabled;
        public List<String> emails;
        public Boolean sendEmails;
        public Integer batchSize;
        public String nextBatch;
        public DateTime lastSucessfulRunDate;
        public Boolean doNotRunNextBatchOnError;
        public Id queueNextBatch() {
            Id batchId = null;
            if(this.nextBatch != null && !''.equalsIgnoreCase(this.nextBatch)){
                System.Type nextBatch = Type.forName(this.nextBatch);
                SettingWrapper nextBatchSettings = BatchSettings.getBatchSettings(this.nextBatch);
                Database.executeBatch((Database.Batchable<SObject>)nextBatch.newInstance(), nextBatchSettings.batchSize);
            }
            return batchId;
        }
        public Id requeueThisBatch() {
            System.Type nextBatch = Type.forName(this.name);
            return Database.executeBatch((Database.Batchable<SObject>)nextBatch.newInstance(), this.batchSize);
        }
        public void setLastSuccessfulRunDate(DateTime runDate) {
            List<RSD_Batch_Settings__c> batchSettings = [select Id, RSD_Last_Successful_Run_Date__c from RSD_Batch_Settings__c where name = :this.name];
            for (RSD_Batch_Settings__c bs : batchSettings) {
                bs.RSD_Last_Successful_Run_Date__c = runDate;
            }
            if (batchSettings.size() == 1) {
                update batchSettings;
            } else {
                throw new BatchSettingsException('The custom batch settings for batch name = ' + this.name + ' were not found.');
            }
        }
        
    }
    
}