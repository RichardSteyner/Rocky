global class AdvancedMDGetEhrAllergiesBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    public String org;
    public Boolean isAll;
    public Integer size;
    public Map<String, Account> accountsMap;
    public Map<String, Account> accountsMapToProcess;
    global AdvancedMDGetEhrAllergiesBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Integer size){
        this(org, isAll, accountsMap, new Map<String, Account>(accountsMap), size);
    }
    global AdvancedMDGetEhrAllergiesBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Map<String, Account> accountsMapToProcess, Integer size){
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
        for(Account account:scope){
            account.Allergy_s__c = null;
            for(Dom.XmlNode childElement1:AdvancedMDConnector.getAdvancedMDObject(org,'<ppmdmsg action="getehrallergies" class="api" msgtime="' + Datetime.now().format()  + '" patientid="' + ApexUtil.getAMDID(account.AdvancedMDID__c, org) + '"><allergy allergy="Allergy"/></ppmdmsg>')) for(Dom.XmlNode childElement2:childElement1.getChildElements()) if(String.isNotBlank(childElement2.getAttributeValue('id', ''))) account.Allergy_s__c = String.isNotBlank(account.Allergy_s__c) ? account.Allergy_s__c + ', ' + childElement2.getAttributeValue('allergy', '') : childElement2.getAttributeValue('allergy', '');
            accountsMapToProcess.remove(account.AdvancedMDID__c);
        }
        ApexUtil.isAdvancedMDAccountTriggerInvoked = true;
        List<Database.UpsertResult> upsertResults = Database.upsert(scope, Account.AdvancedMDID__c, false);
        for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetEhrAllergiesBatch - Account Upsert Error: ' + upsertError.getMessage());
        //if(AdvancedMDConnector.authentication.Token_Datetime__c == null || (DateTime.now() >= AdvancedMDConnector.authentication.Token_Datetime__c.addHours(24).addMinutes(-1))){AdvancedMDConnector.authentication.Token_Datetime__c = Datetime.now();update AdvancedMDConnector.authentication;}
    }
    global void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
    		/*if(!accountsMapToProcess.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetEhrAllergiesBatch(org, isAll, accountsMap, accountsMapToProcess, size), 'AdvancedMDGetEhrAllergiesBatch', 1, 50);    
    		else if(!accountsMap.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetVisitsBatch(org, isAll, accountsMap, 50), 'AdvancedMDGetVisitsBatch', 1, 200);    
    		else Database.executeBatch(new AdvancedMDGetVisitsBatch(org, isAll, accountsMap, 50));*/
            if(!accountsMapToProcess.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetEhrAllergiesBatch(org, isAll, accountsMap, accountsMapToProcess, size), 'AdvancedMDGetEhrAllergiesBatch-' + org, 1, 50);    
    		else if(!accountsMap.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetLabResultsBatch(org, isAll, accountsMap, 18), 'AdvancedMDGetLabResultsBatch-' + org, 1, 200);    
    		else Database.executeBatch(new AdvancedMDGetLabResultsBatch(org, isAll, accountsMap, 18));
        }
    }
}