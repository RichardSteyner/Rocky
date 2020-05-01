public class ZingleConnector{
    public static Zingle__c authentication = Zingle__c.getOrgDefaults();
    public static String getZingleObject(String zingleObject, String filters){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(authentication.EndPoint__c + zingleObject + (!Test.isRunningTest() ? '?' + filters : ''));
        request.setMethod('GET');
        request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(authentication.Username__c+':'+authentication.Password__c)));
        request.setTimeout(120000);
        Http http = new Http();
        HTTPResponse response;
        try{
            if(!Test.isRunningTest())
            	response = http.send(request);
            else {
                response = new HTTPResponse();
                response.setStatusCode(200);
                if(zingleObject.equalsIgnoreCase('contacts')) response.setBody('{"status":{"text":"OK","status_code":200,"description":null,"sort_field":"created_at","sort_direction": "asc","page": 1,"page_size": 10,"total_pages": 1,"total_records":1},"result": [{"id": "6021fc93-7f41-4f0a-88ae-a813432fb571","title": null,"fullName": "Michael Hudson","notes": null,"external_id": null,"service_id": "40e821f9-db31-4da5-87da-7d2f150407cc","first_name": "Michael","last_name": "Hudson","assigned_to_team_id": null,"assigned_to_user_id": null,"is_messageable": true,"is_confirmed": true,"is_starred": false,"is_closed": true,"avatar_uri": "https://storage.googleapis.com/zingle-public/aec/16/2f/73/6b2f02acc6caa645dd10a61878e84a7.png","optin_status": null,"unconfirmed_at": 1571148951,"created_at": 1539700280,"updated_at": 1571148951,"locked_by_source": null,"last_message": {"id": "9f49bef7-3043-4e6f-bfc3-987fe986188d","body": "Order meds","created_at": 1571086051},"channels":[{"id": "0ee15f6a-439c-4246-ac51-5f09d9cdd366","display_name": "MOBILE","value": "+17202997543","formatted_value": "(720) 299-7543","country": "US","is_default": true,"is_default_for_type": false,"block_inbound": false,"block_outbound": false,"is_messageable": true,"channel_type": {"id": "0a293ea3-4721-433e-a031-610ebcf43255","type_class": "PhoneNumber","display_name": "Phone Number","inbound_notification_url": null,"outbound_notification_url": null,"allow_communications": true}}],"custom_field_values": [{"value": "Hudson","custom_field": {"id": "0df80524-3b27-4fb0-8eeb-c81bd448d294","display_name": "Last Name","data_type": "string","code": "last_name","replacement_variable":"LAST NAME","is_global": false,"options": null}}],"labels": [{"id": "f043f196-f7b8-4837-9a67-a37bc2820b86","code": "ed_1_year_plan","display_name": "ED 1 year plan","background_color": "#FEE9E8","text_color": "#FD612C","is_automatic": false,"is_global": false}],"contact_groups": [],"calendar_events": []}]}');
                else if(zingleObject.equalsIgnoreCase('services/40e821f9-db31-4da5-87da-7d2f150407cc/messages')) { response.setBody('{"status": {"text": "OK","status_code": 200,"description": null,"sort_field":"created_at","sort_direction": "asc","page": 1,"page_size":10,"total_pages": 1,"total_records": 1},"result": [{"body": "Hi, this is Michael with the RMMC.","id": "ee08abb2-8921-42a2-9bb9-42664c8f04f7","template_id": null,"created_at": 1539700280,"updated_at": 1539700280,"read_at": null,"deleted_by_contact_at": null,"triggered_by_user_id": "ecdeda26-882a-44cd-a320-75f9c099e0d2","triggered_by_user": {"id": "ecdeda26-882a-44cd-a320-75f9c099e0d2","email": "michael@rmmensclinic.com","first_name": "Michael","last_name": "Hudson","title": null,"username": "michael@rmmensclinic.com","avatar_uri": null},"sender_type": "service","sender": {"id": "40e821f9-db31-4da5-87da-7d2f150407cc","channel": {"type_class": "PhoneNumber","display_name": null,"value": "+17205132410","formatted_value": "(720) 513-2410"}},"recipient_type": "contact","recipient": {"id": "6021fc93-7f41-4f0a-88ae-a813432fb571","channel": {"type_class": "PhoneNumber","display_name": "(720) 299-7543","value": "+17202997543","formatted_value": "(720) 299-7543"}},"communication_direction": "outbound","attachments": [],"is_delayed": false,"execute_at": 0,"executed_at": null,"forwarded_by_service_uuid": null,"translated_body_language_code": null,"translated_body": null,"body_language_code": null}]}');}
            }
        }
        catch(Exception e){
            response = new HTTPResponse();
            response.setStatusCode(500);
            System.debug('###ZingleConnection.getZingleObject - Callout Exception: '+e.getMessage());
        }
        System.debug('getZingleObject(zingleObject = ' + zingleObject + ', filters = ' +  filters + ') => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody().left(255) : ''));
        return response.getStatusCode() == 200 && ( response.getBody().contains('"status_code":200') || response.getBody().contains('"status_code": 200')  || response.getBody().contains('"status_code" : 200') || response.getBody().contains('"status_code" :200') )? response.getBody() : '{"status":{"status_code":200,"page":1,"total_pages":0},"result":[]}';
    }
    @future(callout=true)
    public static void postZingleMessages(Set<Id> zingleMessagesTaskIds){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(authentication.EndPoint__c + 'services/40e821f9-db31-4da5-87da-7d2f150407cc/messages');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Basic ' + EncodingUtil.base64Encode(Blob.valueOf(authentication.Username__c+':'+authentication.Password__c)));
        request.setHeader('Content-Type','application/json');
        request.setTimeout(120000);
        Http http = new Http();
        HTTPResponse response;
        Map<String, SObject> whatIdsMap = new Map<String, SObject>();
        List<Task> zingleMessages = [Select id, WhatId, Description from Task where id in:zingleMessagesTaskIds];
        for(Task task:zingleMessages) if(String.isNotEmpty(task.WhatId)) whatIdsMap.put(task.WhatId, new Account());                    
        for(Account account:[Select id, Zingle_Default_Phone__c from Account where id in:whatIdsMap.keySet() and recordtype.Name = 'Patient']) whatIdsMap.put(account.id, account);
        for(Appointment__c appointment:[Select id, Patient__r.Zingle_Default_Phone__c from Appointment__c where id in:whatIdsMap.keySet() and Patient__r.recordtype.Name = 'Patient']) whatIdsMap.put(appointment.id, appointment);
        String body;
        for(Task task:zingleMessages){
            if(whatIdsMap.get(task.WhatId) != null && ((whatIdsMap.get(task.WhatId).getSObjectType() == Account.sObjectType && String.isNotBlank(((Account) whatIdsMap.get(task.WhatId)).Zingle_Default_Phone__c)) || (whatIdsMap.get(task.WhatId).getSObjectType() == Appointment__c.sObjectType && String.isNotBlank(((Appointment__c) whatIdsMap.get(task.WhatId)).Patient__r.Zingle_Default_Phone__c)))){
                try{
                    body = '{'
                              +'"sender_type": "service",'
                              +'"sender": {'
                                +'"id": "40e821f9-db31-4da5-87da-7d2f150407cc",'
                                +'"channel_value": "+17205132410"'
                              +'},'
                              +'"recipient_type": "contact",'
                              +'"recipients": ['
                                +'{'
                                  +'"channel_value": "' + (whatIdsMap.get(task.WhatId).getSObjectType() == Account.sObjectType ? ((Account) whatIdsMap.get(task.WhatId)).Zingle_Default_Phone__c : ((Appointment__c) whatIdsMap.get(task.WhatId)).Patient__r.Zingle_Default_Phone__c) + '"'
                                +'}'
                              +'],'
                              +'"channel_type_ids": ['
                                +'"0a293ea3-4721-433e-a031-610ebcf43255"'
                              +'],'
                              +'"body": "' + task.Description + '"'
                            +'}';
                    request.setBody(body);
                    if(!Test.isRunningTest()){
                    	response = http.send(request);
                        if(response.getStatusCode() == 200 && (response.getBody().contains('"status_code":200') || response.getBody().contains('"status_code": 200') || response.getBody().contains('"status_code" :200') || response.getBody().contains('"status_code" : 200'))) task.Zingle_ID__c = (String) ((List<Object>) ((Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(response.getBody())).get('result')).get('message_ids'))[0];
                    	else task.Zingle_Sync_Error__c = (String) ((List<Object>) ((Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(response.getBody())).get('result')).get('errors'))[0];
                    }
                    else{
                        response = new HTTPResponse();
                		response.setStatusCode(200);
                        response.setBody('');
                    }
                }
                catch(Exception e){
                    task.Zingle_Sync_Error__c = 'Error';
                    System.debug('###ZingleConnection.postZingleMessages - Callout Exception: '+e.getMessage());
                }
                System.debug('###ZingleConnection.postZingleMessages(messageId = ' + task.id + ') => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody().left(255) : ''));
            }
            else task.Zingle_Sync_Error__c = 'The Recipient does not present valid data';
        }
        ApexUtil.isTaskTriggerInvoked = true;
        if(!zingleMessages.isEmpty()){
            List<Database.SaveResult> saveResults = Database.update(zingleMessages, false);
            for(Database.SaveResult saveResult:saveResults) if(!saveResult.isSuccess()) for(Database.Error saveError : saveResult.getErrors()) System.debug('ZingleConnection.postZingleMessages - Task Insert Error: ' + saveError.getMessage());
        }
    }
}