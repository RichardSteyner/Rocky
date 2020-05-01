global class CloverGetPaymentsBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    private List<Clover__c> merchants;
    public Integer merchantIndex;
    public Boolean isAll;
    public Integer page;
    public Integer pageSize;
    public Boolean hasMorePage;
    public List<Payment__c> paymentsLastUpdated;
    global CloverGetPaymentsBatch(Boolean isAll, Integer pageSize){
        this(0, isAll, 0, pageSize);
    }
    global CloverGetPaymentsBatch(Integer merchantIndex, Boolean isAll, Integer page, Integer pageSize){
        merchants = Clover__c.getAll().values();
        this.merchantIndex = merchantIndex;
        this.isAll = isAll;
        this.page = page;
        this.pageSize = pageSize;
        hasMorePage = false;
        if(!isAll) paymentsLastUpdated = [Select id, Updated_at__c from Payment__c where Clover_ID__c != null and Merchant__c =:(!merchants.isEmpty() ? merchants[merchantIndex].Name : null) order by Updated_at__c desc Nulls Last limit 1];
    }
    global List<Payment__c> start(Database.BatchableContext BC){
        Map<String, Payment__c> paymentsMap = new Map<String, Payment__c>();
        CloverPaymentsParser paymentsParsed = (CloverPaymentsParser) json.deserialize(CloverConnector.getCloverObject((!merchants.isEmpty() ? merchants[merchantIndex] : new Clover__c()), 'payments', (!isAll ? 'filter=modifiedTime>=' + (!paymentsLastUpdated.isEmpty() ? paymentsLastUpdated[0].Updated_at__c : Datetime.now().addHours(-24).getTime()) + '&orderBy=modifiedTime%20DESC&' : '') + 'expand=order.customers,order.employee,cardTransaction,tender&offset=' + page + '&limit=' + pageSize), CloverPaymentsParser.class);
        for(CloverPaymentsParser.Elements payment:(paymentsParsed.elements != null ? paymentsParsed.elements : new List<CloverPaymentsParser.Elements>())){
            if(String.isNotBlank(payment.id)) paymentsMap.put(payment.id, new Payment__c(
                RecordTypeId = Schema.SObjectType.Payment__c.getRecordTypeInfosByName().get('Clover') != null ? Schema.SObjectType.Payment__c.getRecordTypeInfosByName().get('Clover').getRecordTypeId() : null,
                Clover_ID__c = payment.id,
                Created_at__c = payment.createdTime != null ? DateTime.newInstance(payment.createdTime) : null,
                Updated_at__c = payment.modifiedTime,
                Merchant__c = merchants[merchantIndex].Name,
                Amount__c = payment.amount != null ? payment.amount/100 : null,
                Tax_Amount__c = payment.taxAmount != null ? payment.taxAmount/100 : null,
                Result__c = payment.result,
                Clover_Customer_Id__c = payment.order != null && payment.order.customers != null && payment.order.customers.elements != null && !payment.order.customers.elements.isEmpty() ? payment.order.customers.elements[0].id : '',
                Clover_Customer_First_Name__c = payment.order != null && payment.order.customers != null && payment.order.customers.elements != null && !payment.order.customers.elements.isEmpty() ? payment.order.customers.elements[0].firstName : '',
                Clover_Customer_Last_Name__c = payment.order != null && payment.order.customers != null && payment.order.customers.elements != null && !payment.order.customers.elements.isEmpty() ? payment.order.customers.elements[0].lastName : '',
                Employee_Id__c = payment.order != null && payment.order.employee != null ? payment.order.employee.id : '',
                Clover_Employee_Name__c = payment.order != null && payment.order.employee != null ? payment.order.employee.name : '',
                Clover_Employee_Email__c = payment.order != null && payment.order.employee != null ? payment.order.employee.email : '',
                Pay_Type__c = payment.order != null ? payment.order.payType : '',
                Tender__c = payment.tender != null ? payment.tender.label : '',
                Currency__c = payment.order != null ? payment.order.currenci : '',
                Tax_Removed__c = payment.order != null ? payment.order.taxRemoved : false,
                State__c = payment.order != null ? payment.order.state : '',
                Manual_Transaction__c = payment.order != null ? payment.order.manualTransaction : false,
                Group_Line_Items__c = payment.order != null ? payment.order.groupLineItems : false,
                Transaction_No__c = payment.cardTransaction != null ? payment.cardTransaction.transactionNo : '',
                Card_Transaction_Type__c = payment.cardTransaction != null ? payment.cardTransaction.type_Z : '',
                Card_Transaction_State__c = payment.cardTransaction != null ? payment.cardTransaction.state : '',
                Cardholder_Name__c = payment.cardTransaction != null ? payment.cardTransaction.cardholderName : '',
                Card_Type__c = payment.cardTransaction != null ? payment.cardTransaction.cardType : '',
                Card_Entry_Method__c = payment.cardTransaction != null ? payment.cardTransaction.entryType : '',
                Auth_Code__c = payment.cardTransaction != null ? payment.cardTransaction.authCode : '',
                Last4__c = payment.cardTransaction != null ? payment.cardTransaction.last4 : '',
                Reference_Id__c = payment.cardTransaction != null ? payment.cardTransaction.referenceId : '',
                Func__c = payment.cardTransaction != null && payment.cardTransaction.extra != null ? payment.cardTransaction.extra.func : '',
                Exp__c = payment.cardTransaction != null && payment.cardTransaction.extra != null ? payment.cardTransaction.extra.exp : ''
            ));
        }         
        hasMorePage = paymentsMap.values().size() >= pageSize;
        return paymentsMap.values();
    }
    global void execute(Database.BatchableContext BC, List<Payment__c> scope){
        Map<String, User> usersMap = new Map<String, User>();
        Map<String, User> usersByNameMap = new Map<String, User>();
        Map<String, Account> accountsMap = new Map<String, Account>();
        Map<String, Account> accountsByNameMap = new Map<String, Account>();
        for(Payment__c payment:scope){
            if(String.isNotBlank(payment.Clover_Customer_Id__c)) accountsMap.put(payment.Clover_Customer_Id__c, new Account());
            if(String.isNotBlank(payment.Clover_Customer_First_Name__c) || String.isNotBlank(payment.Clover_Customer_Last_Name__c)) accountsByNameMap.put(((String.isNotBlank(payment.Clover_Customer_First_Name__c) ? payment.Clover_Customer_First_Name__c.toLowerCase() : '') + ' ' + (String.isNotBlank(payment.Clover_Customer_Last_Name__c) ? payment.Clover_Customer_Last_Name__c.toLowerCase() : '')).trim(), new Account());
        }
        for(User user:[Select id, Name, UserName from User where isActive = true]){
            usersMap.put(user.UserName, user);
            usersByNameMap.put(user.Name.toLowerCase(), user);
        } 
        for(Account account:[Select id, Clover_ID__c, Name from Account where recordtype.Name = 'Patient' and Primary_Clinic__c =:merchants[merchantIndex].Name and (Clover_ID__c in:accountsMap.keySet() or Name in:accountsByNameMap.keySet())]){
            if(accountsMap.get(account.Clover_ID__c) != null) accountsMap.put(account.Clover_ID__c, account); 
            if(accountsByNameMap.get(account.Name.toLowerCase()) != null) accountsByNameMap.put(account.Name.toLowerCase(), account); 
        } 
        for(Payment__c payment:scope){
            if(usersMap.get(payment.Clover_Employee_Email__c) != null && String.isNotEmpty(usersMap.get(payment.Clover_Employee_Email__c.toLowerCase()).id)) payment.ownerId = usersMap.get(payment.Clover_Employee_Email__c.toLowerCase()).id;
            else if(String.isNotBlank(payment.Clover_Employee_Name__c) && usersByNameMap.get(payment.Clover_Employee_Name__c.toLowerCase()) != null) payment.ownerId = usersByNameMap.get(payment.Clover_Employee_Name__c.toLowerCase()).id;
            if(accountsMap.get(payment.Clover_Customer_Id__c) != null && String.isNotEmpty(accountsMap.get(payment.Clover_Customer_Id__c).id)) payment.Account__c = accountsMap.get(payment.Clover_Customer_Id__c).id;
            else if(accountsByNameMap.get(((String.isNotBlank(payment.Clover_Customer_First_Name__c) ? payment.Clover_Customer_First_Name__c.toLowerCase() : '') + ' ' + (String.isNotBlank(payment.Clover_Customer_Last_Name__c) ? payment.Clover_Customer_Last_Name__c.toLowerCase() : '')).trim()) != null) payment.Account__c = accountsByNameMap.get(((String.isNotBlank(payment.Clover_Customer_First_Name__c) ? payment.Clover_Customer_First_Name__c.toLowerCase() : '') + ' ' + (String.isNotBlank(payment.Clover_Customer_Last_Name__c) ? payment.Clover_Customer_Last_Name__c.toLowerCase() : '')).trim()).id;
            if(String.isBlank(payment.Account__c)) payment.Orphaned_Payments__c = true;
            else payment.Orphaned_Payments__c = false;
        }
        List<Database.UpsertResult> upsertResults = Database.upsert(scope, Payment__c.Clover_ID__c, false);
        for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('CloverGetPaymentsBatch - Payment Upsert Error: ' + upsertError.getMessage());
    }
    global void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
    		if(hasMorePage) Database.executeBatch(new CloverGetPaymentsBatch(merchantIndex, isAll, page + pageSize, pageSize));
            else if(merchants.size() > merchantIndex + 1) Database.executeBatch(new CloverGetPaymentsBatch(merchantIndex + 1, isAll, 0, pageSize));
        }
    }
}