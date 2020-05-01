global class ZingleGetMessagesBatch implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts{
    public Boolean isAll;
    public Integer pageSize;
    public Boolean hasMorePage;
    public List<Task> tasksLastUpdated;
    global ZingleGetMessagesBatch(Boolean isAll, Integer pageSize){
        this.isAll = isAll;
        this.pageSize = pageSize;
        hasMorePage = true;
        tasksLastUpdated = new List<Task>();
    }
    global List<Integer> start(Database.BatchableContext BC){
        if(!isAll) tasksLastUpdated = [Select id, Updated_at__c from Task where Zingle_ID__c != null order by Updated_at__c desc Nulls Last limit 1];
        ZingleMessagesParser messagesParsed = (ZingleMessagesParser) json.deserialize(ZingleConnector.getZingleObject('services/40e821f9-db31-4da5-87da-7d2f150407cc/messages', 'sort_field=updated_at&sort_direction=desc&page_size=' + pageSize), ZingleMessagesParser.class);
        Integer totalPages = isAll || (!isAll && !tasksLastUpdated.isEmpty() && !messagesParsed.result.isEmpty() && messagesParsed.result[0].updated_at >= tasksLastUpdated[0].Updated_at__c) || tasksLastUpdated.isEmpty() ? messagesParsed.status.total_pages : 0;
        List<Integer> pages = new List<Integer>();
        for(Integer i = 1; i <= totalPages; i++) pages.add(i);
        return pages;
    }
    global void execute(Database.BatchableContext BC, List<Integer> scope){
        Map<String, Task> tasksMap = new Map<String, Task>();
        Map<String, Account> accountsMap = new Map<String, Account>();
        Map<String, User> usersMap = new Map<String, User>();
        for(ZingleMessagesParser.Result message:(isAll || hasMorePage || tasksLastUpdated.isEmpty() ? ((ZingleMessagesParser) json.deserialize(ZingleConnector.getZingleObject('services/40e821f9-db31-4da5-87da-7d2f150407cc/messages', 'sort_field=updated_at&sort_direction=desc&page=' + scope[0] + '&page_size=' + pageSize), ZingleMessagesParser.class)).Result : new List<ZingleMessagesParser.Result>())){
            if(!isAll && !tasksLastUpdated.isEmpty() && message.updated_at < tasksLastUpdated[0].Updated_at__c){hasMorePage = false;break;}
            if(String.isNotBlank(message.id)){
                tasksMap.put(message.id, new Task(
                    RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Text Message') != null ? Schema.SObjectType.Task.getRecordTypeInfosByName().get('Text Message').getRecordTypeId() : null,
                    Zingle_ID__c = message.id,
                    Sender_Id__c = message.sender != null ? message.sender.id : '',
                    Recipient_Id__c = message.recipient != null ? message.recipient.id : '',
                    Username__c = message.triggered_by_user != null ? message.triggered_by_user.username : '',
                    Subject = 'Zingle Message' + (message.created_at != null ? ' - ' + DateTime.newInstance(message.created_at * 1000).Date().format() : ''),
                    OwnerId = UserInfo.getUserId(),
                    activityDate = message.created_at != null ? DateTime.newInstance(message.created_at * 1000).Date() : Date.Today(),
                    Status = 'Completed',
                    Description = message.body,
                    Communication_Direction__c = message.communication_direction,
                    Service_Type__c = message.sender_type,
                    Created_at__c = message.created_at != null ? DateTime.newInstance(message.created_at * 1000) : null,
                    Updated_at__c = message.updated_at,
                    Read_At__c = String.isNotBlank(message.read_at) ? DateTime.newInstance(Integer.valueOf(message.read_at) * 1000) : null,
                    Is_Delayed__c = message.is_delayed,
                    Delayed__c = message.execute_at != null && message.execute_at != 0 ? DateTime.newInstance(message.execute_at * 1000) : null,
                    Sent_at__c = String.isNotBlank(message.executed_at) && message.executed_at != '0' ? DateTime.newInstance(Integer.valueOf(message.executed_at) * 1000) : null
                ));
                if(message.recipient != null && String.isNotBlank(message.recipient.id) && message.communication_direction == 'outbound') accountsMap.put(message.recipient.id, new Account());
                if(message.sender != null && String.isNotBlank(message.sender.id) && message.communication_direction == 'inbound') accountsMap.put(message.sender.id, new Account());
                if(message.triggered_by_user != null && String.isNotBlank(message.triggered_by_user.username) && message.communication_direction == 'outbound') usersMap.put(message.triggered_by_user.username, new User());
            } 
        }
        for(Account account:[Select id, Zingle_ID__c, PersonContactId from Account where Zingle_ID__c in:accountsMap.keySet()]) accountsMap.put(account.Zingle_ID__c, account);
        for(User user:[Select id, Zingle_Username__c from User where Zingle_Username__c in:usersMap.keySet()]) usersMap.put(user.Zingle_Username__c, user);
        for(Task task:tasksMap.values()){
            if(task.Communication_Direction__c == 'outbound' && accountsMap.get(task.Recipient_Id__c) != null){
                task.WhoId = accountsMap.get(task.Recipient_Id__c).PersonContactId;
                task.WhatId = accountsMap.get(task.Recipient_Id__c).id;
            }
            if(task.Communication_Direction__c == 'inbound' && accountsMap.get(task.Sender_Id__c) != null){
                task.WhoId = accountsMap.get(task.Sender_Id__c).PersonContactId;
                task.WhatId = accountsMap.get(task.Sender_Id__c).id;
            }
            if(task.Communication_Direction__c == 'outbound' && usersMap.get(task.Username__c) != null && String.isNotEmpty(usersMap.get(task.Username__c).id)) task.OwnerId = usersMap.get(task.Username__c).id;
        } 
        List<Database.UpsertResult> upsertResults;
        if(!tasksMap.values().isEmpty()){
	        ApexUtil.isTaskTriggerInvoked = true;
            upsertResults = Database.upsert(tasksMap.values(), Task.Zingle_ID__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('ZingleGetMessagesBatch Task Upsert Error: ' + upsertError.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
    }
}