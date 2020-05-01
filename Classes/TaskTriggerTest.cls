@isTest
public class TaskTriggerTest {
    
    @isTest static void test01(){
        Id patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        System.debug(patientRecordTypeId);
        Account acc = new Account(FirstName = 'Richard', LastName='Urupeque', Zingle_Default_Phone__c='937323496', RecordTypeId=patientRecordTypeId);
        insert acc;
        Appointment__c app = new Appointment__c(Name='App', Patient__c=acc.Id);
        insert app;
        Task task = new Task(WhatId = acc.Id, Description = 'Test Description.!', Subject = 'Call', Status = 'Open', Priority = 'Normal');
        insert task;
    }

}