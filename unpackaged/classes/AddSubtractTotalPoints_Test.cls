@isTest
private class AddSubtractTotalPoints_Test{

    @isTest static void testInsert(){
        Deployment_Bundle__c db = new Deployment_Bundle__c(Number_of_Cases__c = 0, 
                                                           Total_Size__c = 0);
        insert db;
        
        Case c1 = new Case(Type = 'Problem', 
                           Subject = 'Test', 
                           Description = 'Test',
                           Status = 'Open',
                           Size__c = '3',
                           Deployment_Bundle__c = db.Id);
        test.startTest();
            insert c1;
        test.stopTest();
        
    }
    
    @isTest static void testUpdate(){
        List<Deployment_Bundle__c> dbList = new List<Deployment_Bundle__c>();
        Deployment_Bundle__c db = new Deployment_Bundle__c(Number_of_Cases__c = 0, 
                                                           Total_Size__c = 0);
        insert db;
        Deployment_Bundle__c db2 = new Deployment_Bundle__c(Number_of_Cases__c = 0, 
                                                           Total_Size__c = 0);
        insert db2;
        
        Case c1 = new Case(Type = 'Problem', 
                           Subject = 'Test', 
                           Description = 'Test',
                           Status = 'Open',
                           Size__c = '3',
                           Deployment_Bundle__c = db.Id);
        insert c1;
        Case c2 = new Case(Type = 'Problem', 
                           Subject = 'Test', 
                           Description = 'Test',
                           Status = 'Open',
                           Size__c = '8',
                           Deployment_Bundle__c = db.Id);
        insert c2;
        
        List<Case> caseList = new List<Case>();
        Case c3 = new Case(Id = c1.Id);
        c3.Deployment_Bundle__c = db2.Id;
        
        Case c4 = new Case(Id = c2.Id);
        c4.Deployment_Bundle__c = db2.Id;
        caseList.add(c3);
        caseList.add(c4);
        
        test.startTest();
            update caseList;
        test.stopTest();
    }
    
    @isTest static void testUpdateSize(){
        List<Deployment_Bundle__c> dbList = new List<Deployment_Bundle__c>();
        Deployment_Bundle__c db = new Deployment_Bundle__c(Number_of_Cases__c = 0, 
                                                           Total_Size__c = 0);
        insert db;
        Case c1 = new Case(Type = 'Problem', 
                           Subject = 'Test', 
                           Description = 'Test',
                           Status = 'Open',
                           Size__c = '3',
                           Deployment_Bundle__c = db.Id);
        insert c1;
        Case c2 = new Case(Id = c1.Id);
        c2.Size__c = '8';
        
        test.startTest();
            update c2;
        test.stopTest();
    }
    
    @isTest static void testUpdateSize2(){
        List<Deployment_Bundle__c> dbList = new List<Deployment_Bundle__c>();
        Deployment_Bundle__c db = new Deployment_Bundle__c(Number_of_Cases__c = 0, 
                                                           Total_Size__c = 0);
        insert db;
        Case c1 = new Case(Type = 'Problem', 
                           Subject = 'Test', 
                           Description = 'Test',
                           Status = 'Open',
                           Deployment_Bundle__c = db.Id,
                           Size__c = '2'
                           );
        insert c1;
        Case c2 = new Case(Type = 'Problem', 
                           Subject = 'Test', 
                           Description = 'Test',
                           Status = 'Open',
                           Deployment_Bundle__c = db.Id,
                           Size__c = '2');
        insert c2;
        
        List<Case> caseList = new List<Case>();
        Case c3 = new Case(Id = c1.Id);
        c2.Size__c = '8';
        Case c4 = new Case(Id = c2.Id);
        c4.Size__c = '8';
        
        caseList.add(c3);
        caseList.add(c4);
        
        test.startTest();
            update caseList;
        test.stopTest();
    }
    
    @isTest static void testDelete(){
        List<Deployment_Bundle__c> dbList = new List<Deployment_Bundle__c>();
        Deployment_Bundle__c db = new Deployment_Bundle__c(Number_of_Cases__c = 0, 
                                                           Total_Size__c = 0);
        insert db;
        Case c1 = new Case(Type = 'Problem', 
                           Subject = 'Test', 
                           Description = 'Test',
                           Status = 'Open',
                           Size__c = '3',
                           Deployment_Bundle__c = db.Id);
        insert c1;
        
        Case c2 = new Case(Id = c1.Id);
        
        test.startTest();
            delete c2;
        test.stopTest();
    }

}