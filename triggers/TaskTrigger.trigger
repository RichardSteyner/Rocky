trigger TaskTrigger on Task (after insert){
    if(!ApexUtil.isTaskTriggerInvoked){
        Set<Id> zingleMessagesTaskIds = new Set<Id>();
        for(Task task : trigger.new) if(Schema.SObjectType.Task.getRecordTypeInfosByName().get('Text Message') != null && task.recordtypeId.equals(Schema.SObjectType.Task.getRecordTypeInfosByName().get('Text Message').getRecordTypeId())) zingleMessagesTaskIds.add(task.id);
        if(!zingleMessagesTaskIds.isEmpty() && zingleMessagesTaskIds.size() <= 10) ZingleConnector.postZingleMessages(zingleMessagesTaskIds);
    }
}