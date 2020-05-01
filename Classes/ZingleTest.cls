@isTest
public class ZingleTest {
    
	private static Zingle__c authentication = Zingle__c.getOrgDefaults();
    
    static {
        authentication.EndPoint__c = 'test';
        authentication.Username__c = 'test';
        authentication.Password__c = 'test';
        authentication.Name = 'Test';
        insert authentication;
    }
    
    @isTest static void testConnector(){
        Test.startTest();
        ZingleConnector.getZingleObject('contacts', '');
        Test.stopTest();
    }
    
    @isTest static void testConnectorPost(){
        Id patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        System.debug(patientRecordTypeId);
        Account acc = new Account(FirstName = 'Richard', LastName='Urupeque', Zingle_Default_Phone__c='937323496', RecordTypeId=patientRecordTypeId);
        insert acc;
        Appointment__c app = new Appointment__c(Name='App', Patient__c=acc.Id);
        insert app;
        Task task = new Task(WhatId = acc.Id, Description = 'Test Description.!', Subject = 'Call', Status = 'Open', Priority = 'Normal');
        insert task;
        Set<Id> ids = new Set<Id>();
        ids.add(task.Id);
        Test.startTest();
        ZingleConnector.postZingleMessages(ids);
        Test.stopTest();
    }
    
    @isTest static void testContactsBatch(){
        Test.startTest();
        Database.executeBatch(new ZingleGetContactsBatch(false, 6), 100);
        Test.stopTest();
    }
    
    @isTest static void testMessagesBatch(){
        Test.startTest();
        Database.executeBatch(new ZingleGetMessagesBatch(true, 6), 100);
        Test.stopTest();
    }
    
    @isTest static void testScheduler(){
		ZingleGetSchedule scheduler= new ZingleGetSchedule();
        SchedulableContext sc;
        Test.startTest();
		scheduler.execute(sc);
        Test.stopTest();
	}

}