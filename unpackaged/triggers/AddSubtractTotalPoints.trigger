trigger AddSubtractTotalPoints on Case (after update, after insert, after delete) {
    
    //After update - Add and Subtract Number of Cases and Total Sizes
    if(trigger.isAfter && trigger.isUpdate){
        Map<Id, Decimal> idBundleToCount = new Map<Id, Decimal>();
        Map<Id, Decimal> idBundleToSize = new Map<Id, Decimal>();
        Map<Id, Decimal> idToCountAddCase = new Map<Id, Decimal>();
        Map<Id, Decimal> idToCountAddSize = new Map<Id, Decimal>();
        
        Map<Id, Decimal> idToSizeEdit = new Map<Id, Decimal>();
        Integer flag = 0;
        for(Case newCase: trigger.new){
            Case oldCase = trigger.oldMap.get(newCase.Id);
            if(newCase.Deployment_Bundle__c != oldCase.Deployment_Bundle__c){  
                //subtract Map Number of Cases
                if(!idBundleToCount.containskey(oldCase.Deployment_Bundle__c)){
                    idBundleToCount.put(oldCase.Deployment_Bundle__c, 1);
                }
                else{
                    idBundleToCount.put(oldCase.Deployment_Bundle__c, idBundleToCount.get(oldCase.Deployment_Bundle__c) + 1);
                }
                //Add Map Number of Cases
                if(!idToCountAddCase.containskey(newCase.Deployment_Bundle__c)){
                    idToCountAddCase.put(newCase.Deployment_Bundle__c, 1);
                }
                else{
                    idToCountAddCase.put(newCase.Deployment_Bundle__c, idToCountAddCase.get(newCase.Deployment_Bundle__c) + 1);
                }               
                //subtract Map Total Size  
                //bchapp [CASE 00001672] : handling null pointer exceptions by adding a method DecimalValueOf             
                if(!idBundleToSize.containskey(oldCase.Deployment_Bundle__c)){
                
                    idBundleToSize.put(oldCase.Deployment_Bundle__c, DecimalValueOf(oldCase.Size__c));
                }
                else{
                    idBundleToSize.put(oldCase.Deployment_Bundle__c, idBundleToSize.get(oldCase.Deployment_Bundle__c) + DecimalValueOf(oldCase.Size__c));
                }                     
                
                //bchapp [CASE 00001672] : handling null pointer exceptions by adding a method DecimalValueOf             
                //Add Map Total Size
                if(!idToCountAddSize.containskey(newCase.Deployment_Bundle__c)){
                    idToCountAddSize.put(newCase.Deployment_Bundle__c, DecimalValueOf(newCase.Size__c));
                }
                else{
                    idToCountAddSize.put(newCase.Deployment_Bundle__c, idToCountAddSize.get(newCase.Deployment_Bundle__c) + DecimalValueOf(newCase.Size__c));
                }
                
                
            }
            //bchapp [CASE 00001672] : handling null pointer exceptions by adding a method DecimalValueOf             
            if(newCase.Size__c!= oldCase.Size__c){
                if(oldCase.Size__c != null){
                    if(!idToSizeEdit.containskey(newCase.Deployment_Bundle__c)){
                        idToSizeEdit.put(newCase.Deployment_Bundle__c, Decimal.valueOf(oldCase.Size__c) - DecimalValueOf(newCase.Size__c));
                    }
                    else{
                        idToSizeEdit.put(newCase.Deployment_Bundle__c, idToSizeEdit.get(newCase.Deployment_Bundle__c) + Decimal.valueOf(oldCase.Size__c) - DecimalValueOf(newCase.Size__c));
                    }
                }    
                else{
                    flag = 1;
                    if(!idToSizeEdit.containskey(newCase.Deployment_Bundle__c)){
                        idToSizeEdit.put(newCase.Deployment_Bundle__c, DecimalValueOf(newCase.Size__c));
                    }
                    else{
                        idToSizeEdit.put(newCase.Deployment_Bundle__c, idToSizeEdit.get(newCase.Deployment_Bundle__c) + DecimalValueOf(newCase.Size__c));
                    }    
                }           
            }
        }  
        
        List<Deployment_Bundle__c>  depListEdit = new List<Deployment_Bundle__c>();
        for(Deployment_Bundle__c d: [SELECT Id, Number_of_Cases__c, Total_Size__c  FROM Deployment_Bundle__c WHERE Id IN :idToSizeEdit.keySet()]){
            if(flag == 0){
                d.Total_Size__c  = d.Total_Size__c - idToSizeEdit.get(d.Id);
            }
            else{
                 d.Total_Size__c  = d.Total_Size__c + idToSizeEdit.get(d.Id);    
            }
            depListEdit.add(d);
        }
        if(depListEdit.size() > 0){ update depListEdit; }
                   
        List<Deployment_Bundle__c>  depList = new List<Deployment_Bundle__c>();
        //Loop for Deployment Bundle Ids - Subtract
        for(Deployment_Bundle__c dep: [SELECT Id, Number_of_Cases__c, Total_Size__c  FROM Deployment_Bundle__c WHERE Id IN :idBundleToCount.keySet()]){
            dep.Number_of_Cases__c  = dep.Number_of_Cases__c - idBundleToCount.get(dep.Id);
            dep.Total_Size__c = dep.Total_Size__c - idBundleToSize.get(dep.Id);
            depList.add(dep);
        }    
        //Loop for Deployment Bundle Ids - Addition
        for(Deployment_Bundle__c dep2: [SELECT Id, Number_of_Cases__c, Total_Size__c  FROM Deployment_Bundle__c WHERE Id IN :idToCountAddCase.keySet()]){
            dep2.Number_of_Cases__c = dep2.Number_of_Cases__c + idToCountAddCase.get(dep2.Id);
            dep2.Total_Size__c = dep2.Total_Size__c + idToCountAddSize.get(dep2.Id);
            depList.add(dep2);
        } 
        //DML update
        if(depList.size() > 0){ update depList; }       
    }
    
    //after insert trigger
    if(trigger.isAfter && trigger.isInsert){
        Integer flag = 0;
        Map<Id, Decimal> idToCountCase = new Map<Id, Decimal>();
        Map<Id, Decimal> idToCountSize = new Map<Id, Decimal>();
        for(Case newCase: trigger.new){
            if(!idToCountCase.containskey(newCase.Deployment_Bundle__c)){
                idToCountCase.put(newCase.Deployment_Bundle__c, 1);
            }
            else{
                idToCountCase.put(newCase.Deployment_Bundle__c, idToCountCase.get(newCase.Deployment_Bundle__c) + 1);    
            }
            
            if(newCase.Size__c != null){
                flag = 1;
                if(!idToCountSize.containskey(newCase.Deployment_Bundle__c)){
                    idToCountSize.put(newCase.Deployment_Bundle__c, Decimal.valueOf(newCase.Size__c));
                }
                else{
                    idToCountSize.put(newCase.Deployment_Bundle__c, idToCountSize.get(newCase.Deployment_Bundle__c) + Decimal.valueOf(newCase.Size__c));
                }
            }
        }
        
        List<Deployment_Bundle__c>  depListInsert = new List<Deployment_Bundle__c>();
        for(Deployment_Bundle__c dep3: [SELECT Id, Number_of_Cases__c, Total_Size__c  FROM Deployment_Bundle__c WHERE Id IN :idToCountCase.keySet()]){
            dep3.Number_of_Cases__c = dep3.Number_of_Cases__c + idToCountCase.get(dep3.Id);
            if(flag == 1){
                dep3.Total_Size__c  = dep3.Total_Size__c  + idToCountSize.get(dep3.Id);
            }
            depListInsert.add(dep3);
        }
        if(depListInsert.size()>0) { update depListInsert; }
    }
    
    //after delete
    if(trigger.isAfter && trigger.isDelete){
        Map<Id, Decimal> idToCountCaseDelete = new Map<Id, Decimal>();
        Map<Id, Decimal> idToCountSizeDelete = new Map<Id, Decimal>();
        for(Case oldCase: trigger.old){
            if(!idToCountCaseDelete.containskey(oldCase.Deployment_Bundle__c)){
                idToCountCaseDelete.put(oldCase.Deployment_Bundle__c, 1);
            }
            else{
                idToCountCaseDelete.put(oldCase.Deployment_Bundle__c, idToCountCaseDelete.get(oldCase.Deployment_Bundle__c) + 1);    
            }
            
            if(!idToCountSizeDelete.containskey(oldCase.Deployment_Bundle__c)){
                idToCountSizeDelete.put(oldCase.Deployment_Bundle__c, Decimal.valueOf(oldCase.Size__c));
            }
            else{
                idToCountSizeDelete.put(oldCase.Deployment_Bundle__c, idToCountSizeDelete.get(oldCase.Deployment_Bundle__c) + Decimal.valueOf(oldCase.Size__c));
            }        
        }
        
        List<Deployment_Bundle__c>  depListDelete = new List<Deployment_Bundle__c>();
        for(Deployment_Bundle__c dep4: [SELECT Id, Number_of_Cases__c, Total_Size__c  FROM Deployment_Bundle__c WHERE Id IN :idToCountCaseDelete.keySet()]){
            dep4.Number_of_Cases__c = dep4.Number_of_Cases__c - idToCountCaseDelete.get(dep4.Id);
            dep4.Total_Size__c  = dep4.Total_Size__c  - idToCountSizeDelete.get(dep4.Id);
            depListDelete.add(dep4);
        }
        if(depListDelete .size()>0) { update depListDelete ; }
    }
    
    /* bchapp [CASE: 00001672] : method to handle Null Pointer Exceptions*/
    private Decimal DecimalValueOf(String val)
    {
    
        if(val != null)
        {
            return Decimal.valueOf(val);
        }
        
        return Decimal.valueOf(0);
    }
            
}