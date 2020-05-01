global class AdvancedMDGetPatientDemographicsBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    public String org;
    public Boolean isAll;
    public Integer size;
    public Map<String, Account> accountsMap;
    public Map<String, Account> accountsMapToProcess;
    global AdvancedMDGetPatientDemographicsBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Integer size){
        this(org, isAll, accountsMap, new Map<String, Account>(accountsMap), size);
    }
    global AdvancedMDGetPatientDemographicsBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Map<String, Account> accountsMapToProcess, Integer size){
        this.org = org;
        this.isAll = isAll;
        this.accountsMap = accountsMap;
        this.size = size;
        this.accountsMapToProcess = accountsMapToProcess;
    }
    global List<Account> start(Database.BatchableContext BC){
        System.debug('Start');
        List<Account> accounts = new List<Account>();
        Integer i = 1;
        for(Account account:accountsMapToProcess.values()){if(i > size){break;}accounts.add(account);i++;}
        return accounts;
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        System.debug('Execute');
        Map<String, Account> facilityAccountsMap = new Map<String, Account>();
        for(Account account:scope){
            for(Dom.XmlNode childElement1:AdvancedMDConnector.getAdvancedMDObject(org, '<ppmdmsg action="getdemographic" class="demographics" msgtime="' + Datetime.now().format()  + '" patientid="' + ApexUtil.getAMDID(account.AdvancedMDID__c, org) + '"/>')){
                if(childElement1.getName() == 'patientlist' && !childElement1.getChildElements().isEmpty() && String.isNotBlank(childElement1.getChildElements()[0].getAttributeValue('id', ''))){
                    account.Phone = childElement1.getChildElements()[0].getAttributeValue('preferredcommunicationfid', '') == '1' ? account.PersonHomePhone : childElement1.getChildElements()[0].getAttributeValue('preferredcommunicationfid', '') == '2' ? account.Work_Phone__c : childElement1.getChildElements()[0].getAttributeValue('preferredcommunicationfid', '') == '3' ? childElement1.getChildElements()[0].getAttributeValue('otherphone', '') : '';
                    account.Confidential__c = childElement1.getChildElements()[0].getAttributeValue('confidentialcommunicationfid', '') == '1' ? 'Home Phone' : childElement1.getChildElements()[0].getAttributeValue('confidentialcommunicationfid', '') == '2' ? 'Work Phone' : childElement1.getChildElements()[0].getAttributeValue('confidentialcommunicationfid', '') == '4' ? 'Email' : childElement1.getChildElements()[0].getAttributeValue('confidentialcommunicationfid', '') == '5' ? 'Letter' : childElement1.getChildElements()[0].getAttributeValue('confidentialcommunicationfid', '') == '6' ? 'Other' : childElement1.getChildElements()[0].getAttributeValue('confidentialcommunicationfid', '') == '7' ? 'Patient Portal' : childElement1.getChildElements()[0].getAttributeValue('confidentialcommunicationfid', '') == '3' ? (childElement1.getChildElements()[0].getAttributeValue('othertype', '') == 'F' ? 'Fax' : childElement1.getChildElements()[0].getAttributeValue('othertype', '') == 'C' ? 'Cell' : childElement1.getChildElements()[0].getAttributeValue('othertype', '') == 'O' ? 'Other Phone' : childElement1.getChildElements()[0].getAttributeValue('othertype', '')) : childElement1.getChildElements()[0].getAttributeValue('confidentialcommunicationfid', '');
                    account.Description = childElement1.getChildElements()[0].getAttributeValue('communicationnote', '');
                    account.GI__c = childElement1.getChildElements()[0].getAttributeValue('genderidentity', '') == '558' ? 'Male' : childElement1.getChildElements()[0].getAttributeValue('genderidentity', '') == '559' ? 'Female' : childElement1.getChildElements()[0].getAttributeValue('genderidentity', '') == '560' ? 'Transgender Male / Trans Man / Female-to-Male' : childElement1.getChildElements()[0].getAttributeValue('genderidentity', '') == '561' ? 'Transgender Female / Trans Wormen / Male-to-Female' : childElement1.getChildElements()[0].getAttributeValue('genderidentity', '') == '562' ? 'Genderqueer, Neither exclusively male nor female' : childElement1.getChildElements()[0].getAttributeValue('genderidentity', '') == '564' ? 'Decline to answer' : childElement1.getChildElements()[0].getAttributeValue('genderidentity', '');
                    account.SO__c = childElement1.getChildElements()[0].getAttributeValue('orientation', '') == '565' ? 'Straight / Heterosexual' : childElement1.getChildElements()[0].getAttributeValue('orientation', '') == '566' ? 'Lesbian / Gay / Homosexual' : childElement1.getChildElements()[0].getAttributeValue('orientation', '') == '567' ? 'Bisexual' : childElement1.getChildElements()[0].getAttributeValue('orientation', '') == '568' ? 'Something else' : childElement1.getChildElements()[0].getAttributeValue('orientation', '') == '569' ? 'Don\'t know' : childElement1.getChildElements()[0].getAttributeValue('orientation', '') == '570' ? 'Decline to answer' : childElement1.getChildElements()[0].getAttributeValue('orientation', '');
                    account.Area_Code__c = childElement1.getChildElements()[0].getAttributeValue('areacode', '');
                    account.BillingCountry = childElement1.getChildElements()[0].getAttributeValue('countrycode', '');
                } 
                if(childElement1.getName() == 'facilitylist' && !childElement1.getChildElements().isEmpty() && String.isNotBlank(childElement1.getChildElements()[0].getAttributeValue('id', ''))){
                    account.Facility_Id__c = org.touppercase() + '-' + childElement1.getChildElements()[0].getAttributeValue('id', '').substringAfter('fac');
                    facilityAccountsMap.put(org.touppercase() + '-' + childElement1.getChildElements()[0].getAttributeValue('id', '').substringAfter('fac'), new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RMC Facility') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('RMC Facility').getRecordTypeId() : null, AdvancedMD_Facility_ID__c = org.touppercase() + '-' + childElement1.getChildElements()[0].getAttributeValue('id', '').substringAfter('fac'), Name = childElement1.getChildElements()[0].getAttributeValue('name', ''), Code__c = childElement1.getChildElements()[0].getAttributeValue('code', '')));                    
                } 
            }
            accountsMapToProcess.remove(account.AdvancedMDID__c);
        }
        Map<String, Account> facilityAccountsMapToUpsert = new Map<String, Account>(facilityAccountsMap);
        for(Account account:[Select id, AdvancedMD_Facility_ID__c, Name, Code__c from Account where AdvancedMD_Facility_ID__c in:facilityAccountsMapToUpsert.keySet()]) if(facilityAccountsMapToUpsert.get(account.AdvancedMD_Facility_ID__c).Name == account.Name && facilityAccountsMapToUpsert.get(account.AdvancedMD_Facility_ID__c).Code__c == account.Code__c){facilityAccountsMap.get(account.AdvancedMD_Facility_ID__c).id = account.id;facilityAccountsMapToUpsert.remove(account.AdvancedMD_Facility_ID__c);}
        List<Database.UpsertResult> upsertResults;
        ApexUtil.isAdvancedMDAccountTriggerInvoked = true;
        if(!facilityAccountsMapToUpsert.values().isEmpty()){
            upsertResults = Database.upsert(facilityAccountsMapToUpsert.values(), Account.AdvancedMD_Facility_ID__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetPatientDemographicsBatch - Facility Account Upsert Error: ' + upsertError.getMessage());
        }
        for(Account account:scope) if(facilityAccountsMap.get(account.Facility_Id__c) != null) account.Referral_Facility__c = facilityAccountsMap.get(account.Facility_Id__c).id;
        upsertResults = Database.upsert(scope, Account.AdvancedMDID__c, false);
        for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetPatientDemographicsBatch - Account Upsert Error: ' + upsertError.getMessage());
        //if(AdvancedMDConnector.authentication.Token_Datetime__c == null || (DateTime.now() >= AdvancedMDConnector.authentication.Token_Datetime__c.addHours(24).addMinutes(-1))){AdvancedMDConnector.authentication.Token_Datetime__c = Datetime.now();update AdvancedMDConnector.authentication;}
    }
    global void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
    		if(!accountsMapToProcess.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetPatientDemographicsBatch(org, isAll, accountsMap, accountsMapToProcess, size), 'AdvancedMDGetPatientDemographicsBatch-' + org, 1, 50);    
    		else if(!accountsMap.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetEhrAllergiesBatch(org, isAll, accountsMap, 12), 'AdvancedMDGetEhrAllergiesBatch-' + org, 1, 50);    
    		else Database.executeBatch(new AdvancedMDGetEhrAllergiesBatch(org, isAll, accountsMap, 12), 50);
        }
    }
}