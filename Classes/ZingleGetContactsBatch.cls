global class ZingleGetContactsBatch implements Database.Batchable<Integer>, Database.Stateful, Database.AllowsCallouts{
    public Boolean isAll;
    public Integer pageSize;
    public Boolean hasMorePage;
    public List<Account> accountsLastUpdated;
    global ZingleGetContactsBatch(Boolean isAll, Integer pageSize){
        this.isAll = isAll;
        this.pageSize = pageSize;
        hasMorePage = true;
        accountsLastUpdated = new List<Account>();
    }
    global List<Integer> start(Database.BatchableContext BC){
        if(!isAll) accountsLastUpdated = [Select id, Updated_at__c from Account where Zingle_ID__c != null order by Updated_at__c desc Nulls Last limit 1];
        ZingleContactsParser contactsParsed = (ZingleContactsParser) json.deserialize(ZingleConnector.getZingleObject('contacts', 'sort_field=updated_at&sort_direction=desc&page_size=' + pageSize), ZingleContactsParser.class);
        Integer totalPages = isAll || (!isAll && !accountsLastUpdated.isEmpty() && !contactsParsed.result.isEmpty() && contactsParsed.result[0].updated_at >= accountsLastUpdated[0].Updated_at__c) || accountsLastUpdated.isEmpty() ? contactsParsed.status.total_pages : 0;
        List<Integer> pages = new List<Integer>();
        for(Integer i = 1; i <= totalPages; i++) pages.add(i);
        return pages;
    }
    global void execute(Database.BatchableContext BC, List<Integer> scope){
        Map<String, Account> accountsMap = new Map<String, Account>();
        for(ZingleContactsParser.Result contact:(isAll || hasMorePage || accountsLastUpdated.isEmpty() ? ((ZingleContactsParser) json.deserialize(ZingleConnector.getZingleObject('contacts', 'sort_field=updated_at&sort_direction=desc&page=' + scope[0] + '&page_size=' + pageSize), ZingleContactsParser.class)).Result : new List<ZingleContactsParser.Result>())){
            if(!isAll && !accountsLastUpdated.isEmpty() && contact.updated_at < accountsLastUpdated[0].Updated_at__c){hasMorePage = false;break;}
            if(String.isNotBlank(contact.id)){
                accountsMap.put(contact.id, new Account(
                    RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null,
                    Zingle_ID__c = contact.id,
                    FirstName = contact.first_name,
                    LastName = String.isNotBlank(contact.last_name) ? contact.last_name : '',
                    Created_at__c = contact.created_at != null ? DateTime.newInstance(contact.created_at * 1000) : null,
                    Updated_at__c = contact.updated_at,
                    PersonTitle = contact.title,
                    Zingle_Notes__c = contact.notes,
                    Zingle_Service_ID__c = contact.service_id,
                    Zingle_Messages__c = contact.is_messageable,
                    Zingle_is_Confirmed__c = contact.is_confirmed,
                    Zingle_Starred__c = contact.is_starred,
                    Zingle_Closed__c = contact.is_closed,
                    Optin_Status__c = contact.optin_status,
                    Zingle_Unconfirmed_Time__c = contact.unconfirmed_at != null ? DateTime.newInstance(contact.unconfirmed_at * 1000) : null,
                    Zingle_Last_Message__c = contact.last_message != null ? contact.last_message.body : ''
                ));
                for(ZingleContactsParser.Channels channel:(contact.channels != null ? contact.channels : new List<ZingleContactsParser.Channels>())){
                    if(channel.is_default){
                        accountsMap.get(contact.id).Zingle_Default_Phone__c = channel.value;
                        if(String.isBlank(accountsMap.get(contact.id).LastName)) accountsMap.get(contact.id).LastName = channel.value;
                        break;
                    }
                }
                for(ZingleContactsParser.Custom_field_values customField:(contact.custom_field_values != null ? contact.custom_field_values : new List<ZingleContactsParser.Custom_field_values>())){
                    if(customField.custom_field != null){
                        if(customField.custom_field.code == 'address') accountsMap.get(contact.id).BillingStreet = customField.value;
                        if(customField.custom_field.code == 'appt_date' && String.isNotBlank(customField.value)) accountsMap.get(contact.id).Zingle_Appt_Date__c = DateTime.newInstance(Long.valueOf(customField.value) * 1000).Date();
                        if(customField.custom_field.code == 'appt_time' && String.isNotBlank(customField.value)) accountsMap.get(contact.id).Zingle_Appt_Time__c = Time.newInstance(Integer.valueOf(customField.value.substringBefore(':')), Integer.valueOf(customField.value.substringAfter(':')), 0, 0);
                        if(customField.custom_field.code == 'e/d_patient' && String.isNotBlank(customField.value)) accountsMap.get(contact.id).E_D__c = Boolean.valueOf(customField.value);
                        if(customField.custom_field.code == 'office_visit_date' && String.isNotBlank(customField.value)) accountsMap.get(contact.id).Zingle_Office_Visit_Date__c = DateTime.newInstance(Long.valueOf(customField.value) * 1000).Date();
                        if(customField.custom_field.code == 'sign_up_date' && String.isNotBlank(customField.value)) accountsMap.get(contact.id).Zingle_Sign_up_Date__c = DateTime.newInstance(Long.valueOf(customField.value) * 1000).Date();
                        if(customField.custom_field.code == 'testosterone_patient' && String.isNotBlank(customField.value)) accountsMap.get(contact.id).Testosterone__c = Boolean.valueOf(customField.value);
                        if(customField.custom_field.code == 'treatment_end_date' && String.isNotBlank(customField.value)) accountsMap.get(contact.id).Treatment_End_Date__c = DateTime.newInstance(Long.valueOf(customField.value) * 1000).Date();
                        if(customField.custom_field.code == 'treatment_plan') accountsMap.get(contact.id).Treatment_Plan__c = customField.value;
                    }
                } 
            } 
        }
        List<Database.UpsertResult> upsertResults;
        if(!accountsMap.values().isEmpty()){
	        ApexUtil.isAccountTriggerInvoked = true;
            upsertResults = Database.upsert(accountsMap.values(), Account.Zingle_ID__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('ZingleGetContactsBatch Account Upsert Error: ' + upsertError.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
		if(!Test.isRunningTest()) Database.executeBatch(new ZingleGetMessagesBatch(isAll, pageSize), 1);       
    }
}