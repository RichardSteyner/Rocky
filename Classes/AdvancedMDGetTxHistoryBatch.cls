global class AdvancedMDGetTxHistoryBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    public String org;
    public Boolean isAll;
    public Integer size;
    public Map<String, Account> accountsMap;
    public Map<String, Account> accountsMapToProcess;
    global AdvancedMDGetTxHistoryBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Integer size){
        this(org, isAll, accountsMap, new Map<String, Account>(accountsMap), size);
    }
    global AdvancedMDGetTxHistoryBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Map<String, Account> accountsMapToProcess, Integer size){
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
    global void execute(Database.BatchableContext BC, List<Account> scope) {
        Map<String, Opportunity> opportunitiesMap = new Map<String, Opportunity>();
        Map<String, Account> facilityAccountsMap = new Map<String, Account>();
        Map<String, Contact> contactsMap = new Map<String, Contact>();
        Map<String, Appointment__c> appointmentsMap = new Map<String, Appointment__c>();
        List<Dom.XmlNode> chargesParsed;
        Integer page;
        for(Account account:scope){
            page = 1;
            do{
                chargesParsed = AdvancedMDConnector.getAdvancedMDObject(org,'<ppmdmsg action="gettxhistory" class="demographics" msgtime="' + Datetime.now().format()  + '" patientid="' + ApexUtil.getAMDID(account.AdvancedMDID__c, org) + '" filterhistory="0" pagenumber="' + page + '" typefilter="1" sortbypayment="0" groupbyvisit="0" sortdescending="1" profileid="" getmemo="0"/>');
                for(Dom.XmlNode charge:(!chargesParsed.isEmpty() ? chargesParsed[0].getChildElements() : new List<Dom.XmlNode>())){
                    if(String.isNotBlank(charge.getAttributeValue('id', ''))) opportunitiesMap.put(org.touppercase() + '-' + charge.getAttributeValue('id', ''), new Opportunity(
                        AdvancedMDID__c = org.touppercase() + '-' + charge.getAttributeValue('id', ''),
                        Name = String.isNotBlank(charge.getAttributeValue('description', '')) ? charge.getAttributeValue('description', '') : '',
                        AccountId = account.id,
                        StageName = charge.getAttributeValue('totbal', '') == charge.getAttributeValue('paid', '') ? 'Closed Won' : charge.getAttributeValue('void', '') == '1' ? 'Closed Lost' : 'Invoiced',
                        CloseDate = String.isNotBlank(charge.getAttributeValue('billdate', '')) ? Date.valueOf(charge.getAttributeValue('billdate', '').substringAfterLast('/') + '-' + charge.getAttributeValue('billdate', '').substringBefore('/') + '-' + charge.getAttributeValue('billdate', '').substringBetween('/')) : Date.Today(),
                        Amount = String.isNotBlank(charge.getAttributeValue('totalvisitcharge', '')) ? Decimal.valueOf(charge.getAttributeValue('totalvisitcharge', '')) : null,
                        Fee__c = String.isNotBlank(charge.getAttributeValue('fee', '')) ? Decimal.valueOf(charge.getAttributeValue('fee', '')) : null,
                        Paid_Amount__c = String.isNotBlank(charge.getAttributeValue('paid', '')) ? Decimal.valueOf(charge.getAttributeValue('paid', '')) : null,
                        Total_Billed__c = String.isNotBlank(charge.getAttributeValue('totbal', '')) ? Decimal.valueOf(charge.getAttributeValue('totbal', '')) : null,
                        Billed_Date__c = String.isNotBlank(charge.getAttributeValue('billdate', '')) ? Date.valueOf(charge.getAttributeValue('billdate', '').substringAfterLast('/') + '-' + charge.getAttributeValue('billdate', '').substringBefore('/') + '-' + charge.getAttributeValue('billdate', '').substringBetween('/')) : null,
                        Facility_Code__c = String.IsNotBlank(charge.getAttributeValue('faccode', '')) ? charge.getAttributeValue('faccode', '') : '',
                        Provider_Code__c = String.IsNotBlank(charge.getAttributeValue('provcode', '')) ? charge.getAttributeValue('provcode', '') : '',
                        Visit_Id__c = String.IsNotBlank(charge.getAttributeValue('visit', '')) ? org.touppercase() + '-' + charge.getAttributeValue('visit', '') : '',
                        Approved_by__c = charge.getAttributeValue('approvedby', '')
                    ));
                    if(String.isNotBlank(charge.getAttributeValue('faccode', ''))) facilityAccountsMap.put(charge.getAttributeValue('faccode', ''), new Account());
                    if(String.isNotBlank(charge.getAttributeValue('provcode', ''))) contactsMap.put(charge.getAttributeValue('provcode', ''), new Contact());
                    if(String.isNotBlank(charge.getAttributeValue('visit', ''))) appointmentsMap.put(org.touppercase() + '-' + charge.getAttributeValue('visit', ''), new Appointment__c());
                }
                page++;
            } while(!chargesParsed.isEmpty() && chargesParsed[0].getAttributeValue('pagecount', '') != null && page <= Integer.valueOf(chargesParsed[0].getAttributeValue('pagecount', '')));
            accountsMapToProcess.remove(account.AdvancedMDID__c);
        }
        if(!opportunitiesMap.values().isEmpty()){
            for(Account account:[Select id, Code__c from Account where Code__c in:facilityAccountsMap.keySet()]) facilityAccountsMap.put(account.Code__c, account);
            for(Contact contact:[Select id, Code__c from Contact where Code__c in:contactsMap.keySet()]) contactsMap.put(contact.Code__c, contact);
            for(Appointment__c appointment:[Select id, AdvancedMDID__c from Appointment__c where AdvancedMDID__c in:appointmentsMap.keySet()]) appointmentsMap.put(appointment.AdvancedMDID__c, appointment);
            for(Opportunity opportunity:opportunitiesMap.values()){
                if(facilityAccountsMap.get(opportunity.Facility_Code__c) != null) opportunity.Facility__c = facilityAccountsMap.get(opportunity.Facility_Code__c).id;                
                if(contactsMap.get(opportunity.Provider_Code__c) != null) opportunity.Provider__c = contactsMap.get(opportunity.Provider_Code__c).id;                
                if(appointmentsMap.get(opportunity.Visit_Id__c) != null) opportunity.Appointment__c = appointmentsMap.get(opportunity.Visit_Id__c).id;                
            }
            ApexUtil.isOpportunityTriggerInvoked = true;
            List<Database.UpsertResult> upsertResults = Database.upsert(opportunitiesMap.values(), Opportunity.AdvancedMDID__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetTxHistoryBatch - Opportunity Upsert Error: ' + upsertError.getMessage());
        }
        //if(AdvancedMDConnector.authentication.Token_Datetime__c == null || (DateTime.now() >= AdvancedMDConnector.authentication.Token_Datetime__c.addHours(24).addMinutes(-1))){AdvancedMDConnector.authentication.Token_Datetime__c = Datetime.now();update AdvancedMDConnector.authentication;}
    }
    global void finish(Database.BatchableContext BC) {
        if(!Test.isRunningTest()){
    		if(!accountsMapToProcess.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetTxHistoryBatch(org, isAll, accountsMap, accountsMapToProcess, size), 'AdvancedMDGetTxHistoryBatch-' + org, 1, 50);    
    		else if(!accountsMap.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetVisitsBatch(org, isAll, accountsMap, 12), 'AdvancedMDGetVisitsBatch-' + org, 1, 50);    
    		else Database.executeBatch(new AdvancedMDGetVisitsBatch(org, isAll, accountsMap, 12), 50); 
        }
    }
}