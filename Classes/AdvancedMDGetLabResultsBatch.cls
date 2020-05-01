global class AdvancedMDGetLabResultsBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    public String org;
    public Boolean isAll;
    public Integer size;
    public Map<String, Account> accountsMap;
    public Map<String, Account> accountsMapToProcess;
    global AdvancedMDGetLabResultsBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Integer size){
        this(org, isAll, accountsMap, new Map<String, Account>(accountsMap), size);
    }
    global AdvancedMDGetLabResultsBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Map<String, Account> accountsMapToProcess, Integer size){
        this.org = org;
        this.isAll = isAll;
        this.accountsMap = accountsMap;
        this.size = size;
        this.accountsMapToProcess = accountsMapToProcess;
    }
    global List<Account> start(Database.BatchableContext BC){
        List<Account> accounts = new List<Account>();
        Integer i = 1;
        for(Account account:accountsMapToProcess.values()){if(i > size){break;}accounts.add(account);i++;}
        return accounts;
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        Map<String, List<ContentNote>> mapNotes = new Map<String, List<ContentNote>>();
        Map<String, List<ContentDocumentLink>> mapDocuments = new Map<String, List<ContentDocumentLink>>();
        List<ContentNote> listNotes = new List<ContentNote>();
        List<ContentDocumentLink> listDocuments = new List<ContentDocumentLink>();
        List<ContentNote> auxNotes = new List<ContentNote>();
        List<ContentDocumentLink> auxDocuments = new List<ContentDocumentLink>();
        String body;
        ContentNote testNote;
        ContentDocumentLink cdlnk;
        for(Account account:scope){
            account.LabResult_s__c = null;
            auxNotes = new List<ContentNote>();
            auxDocuments = new List<ContentDocumentLink>();
            for(Dom.XmlNode childElement1:AdvancedMDConnector.getAdvancedMDObject(org, '<ppmdmsg action="getehrlabresults" class="api" msgtime="' + Datetime.now().format()  + '" patientid="' + ApexUtil.getAMDID(account.AdvancedMDID__c, org) + '"><labresult profileid="ProfileID" companyname="CompanyName" obsdatetime="ObsDatetime" specdatetime="SpecDatetime" signby="SignBy" signat="SignAt" resultcode="ResultCode" resultdesc="ResultDesc" resultvalue="ResultValue" resultunits="ResultUnits" resultrange="ResultRange" resultstatus="ResultStatus"/></ppmdmsg>')) 
                for(Dom.XmlNode childElement2:childElement1.getChildElements()) 
                    if(String.isNotBlank(childElement2.getAttributeValue('id', ''))){
                        account.Result_Code_Lab_Results__c = String.isNotBlank(account.Result_Code_Lab_Results__c) ? account.Result_Code_Lab_Results__c + ', ' + childElement2.getAttributeValue('resultcode', '') : childElement2.getAttributeValue('resultcode', '');
                        account.Result_Desc_Lab_Results__c = String.isNotBlank(account.Result_Desc_Lab_Results__c) ? account.Result_Desc_Lab_Results__c + ', ' + childElement2.getAttributeValue('resultdesc', '') : childElement2.getAttributeValue('resultdesc', '');
                        account.Result_Value_Lab_Results__c = String.isNotBlank(account.Result_Value_Lab_Results__c) ? account.Result_Value_Lab_Results__c + ', ' + childElement2.getAttributeValue('resultvalue', '') : childElement2.getAttributeValue('resultvalue', '');
                        account.Result_Units_Lab_Results__c = String.isNotBlank(account.Result_Units_Lab_Results__c) ? account.Result_Units_Lab_Results__c + ', ' + childElement2.getAttributeValue('resultunits', '') : childElement2.getAttributeValue('resultunits', '');
                        account.Result_Range_Lab_Results__c = String.isNotBlank(account.Result_Range_Lab_Results__c) ? account.Result_Range_Lab_Results__c + ', ' + childElement2.getAttributeValue('resultrange', '') : childElement2.getAttributeValue('resultrange', '');
                        account.Result_Status_Lab_Results__c = String.isNotBlank(account.Result_Status_Lab_Results__c) ? account.Result_Status_Lab_Results__c + ', ' + childElement2.getAttributeValue('resultstatus', '') : childElement2.getAttributeValue('resultstatus', '');
                    	/*testNote = new ContentNote();
                        testNote.Title = childElement2.getAttributeValue('id', '');
                        body = 'Result Code:' + childElement2.getAttributeValue('resultcode', '') + '\nResult Desc:' + childElement2.getAttributeValue('resultdesc', '') + '\nResult Value:' + childElement2.getAttributeValue('resultvalue', '') + '\nResult Units:' + childElement2.getAttributeValue('resultunits', '') + + '\nResultRange:' + childElement2.getAttributeValue('resultrange', '') + + '\nResult Status:' + childElement2.getAttributeValue('resultstatus', '');
                        testNote.Content = Blob.valueOf(body);
                        auxNotes.add(testNote);
                        cdlnk = new ContentDocumentLink();
                        cdlnk.LinkedEntityId = account.AdvancedMDID__c;
                        cdlnk.ContentDocumentId = testNote.Title;
                        cdlnk.ShareType = 'I';
                        auxDocuments.add(cdlnk);*/
                    }
            /*mapNotes.put(account.AdvancedMDID__c, auxNotes);
            mapDocuments.put(account.AdvancedMDID__c, auxDocuments);*/

			account.Result_Code_Lab_Results__c = String.isNotBlank(account.Result_Code_Lab_Results__c) ? account.Result_Code_Lab_Results__c.left(255) : '';
            account.Result_Desc_Lab_Results__c = String.isNotBlank(account.Result_Desc_Lab_Results__c) ? account.Result_Desc_Lab_Results__c.left(255) : '';
            account.Result_Value_Lab_Results__c = String.isNotBlank(account.Result_Value_Lab_Results__c) ? account.Result_Value_Lab_Results__c.left(255) : '';
            account.Result_Units_Lab_Results__c = String.isNotBlank(account.Result_Units_Lab_Results__c) ? account.Result_Units_Lab_Results__c.left(255) : '';
            account.Result_Range_Lab_Results__c = String.isNotBlank(account.Result_Range_Lab_Results__c) ? account.Result_Range_Lab_Results__c.left(255) : '';
            account.Result_Status_Lab_Results__c = String.isNotBlank(account.Result_Status_Lab_Results__c) ? account.Result_Status_Lab_Results__c.left(255) : '';
            accountsMapToProcess.remove(account.AdvancedMDID__c);
        }
        ApexUtil.isAdvancedMDAccountTriggerInvoked = true;
        List<Database.UpsertResult> upsertResults = Database.upsert(scope, Account.AdvancedMDID__c, false);
        for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetEhrAllergiesBatch - Account Upsert Error: ' + upsertError.getMessage());
        /*for(Account acc: scope){
            if(acc.Id!=null){
                for(Integer i=0; i<mapNotes.get(acc.AdvancedMDID__c).size(); i++){
                    mapNotes.get(acc.AdvancedMDID__c).get(i).Title='';
                    listNotes.add(mapNotes.get(acc.AdvancedMDID__c).get(i));
                }
            }
            else{
                mapNotes.remove(acc.AdvancedMDID__c);
                mapDocuments.remove(acc.AdvancedMDID__c);
            }
        }*/
        //if(AdvancedMDConnector.authentication.Token_Datetime__c == null || (DateTime.now() >= AdvancedMDConnector.authentication.Token_Datetime__c.addHours(24).addMinutes(-1))){AdvancedMDConnector.authentication.Token_Datetime__c = Datetime.now();update AdvancedMDConnector.authentication;}
    }
    global void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
    		if(!accountsMapToProcess.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetLabResultsBatch(org, isAll, accountsMap, accountsMapToProcess, size), 'AdvancedMDGetLabResultsBatch-' + org, 1, 50);    
    		else if(!accountsMap.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetEhrNotesBatch(org, isAll, accountsMap, 1), 'AdvancedMDGetEhrNotesBatch-' + org, 1, 51);/*System.scheduleBatch(new AdvancedMDGetTxHistoryBatch(org, isAll, accountsMap, 12), 'AdvancedMDGetTxHistoryBatch', 1, 50); */  
    		else Database.executeBatch(new AdvancedMDGetEhrNotesBatch(org, isAll, accountsMap, 1)); /*Database.executeBatch(new AdvancedMDGetTxHistoryBatch(org, isAll, accountsMap, 12)); */
        }
    }
}