trigger TaskTrigger on Task (before update) {
    if(trigger.isBefore && trigger.isUpdate){
        Map<Id, Task> oldTaskMap = (Map<Id, Task>) Trigger.oldMap;
        for(Task newTask: trigger.new){
            Task oldTask = oldTaskMap.get(newTask.Id);
            if(newTask.Status == 'Completed' && newTask.Status != oldTask.Status && newTask.Subject == 'Sample Request'){
                newTask.ActivityDate = System.today(); 
            }
        }

    }
}