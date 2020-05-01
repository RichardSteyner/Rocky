global class ImportGetProvidersBatch implements Database.Batchable<Contact>, Database.Stateful, Database.AllowsCallouts{
    public String org;
    public Boolean isAll;
    global ImportGetProvidersBatch(String org, Boolean isAll){
        this.org = org;
        this.isAll = isAll;
    }
    global List<Contact> start(Database.BatchableContext BC){
        List<Contact> contactsLastUpdated = [Select id, Changed_Date__c from Contact where AdvancedMDID__c != null order by Changed_Date__c desc Nulls Last limit 1];
        Map<String, Contact> contactsMap = new Map<String, Contact>();
        String xmlData = '<ppmdmsg action="getupdatedproviders" class="api" datechanged="' + (!isAll ? (!contactsLastUpdated.isEmpty() ? contactsLastUpdated[0].Changed_Date__c.format() : Datetime.now().addHours(-24).format()) : Datetime.valueOf('2000-01-01 00:00:00').format()) + '"><provider lastname="LastName" firstname="FirstName" middlename="MiddleName" name="Name" financialsummaryfid="FinancialSummaryFID" accountreceivablefid="AccountReceivableFID" practicefid="PracticeFID" title="Title" upinnumber="UPINNumber" cell="Cell" pager="Pager" homephone="HomePhone" email="Email" changedat="ChangedAt" createuser="CreateUser" createdat="CreatedAt" changedby="ChangedBy" type="Type" status="Status" emraccess="EMRAccess" emractiveat="EMRActiveAt" isinstitutional="IsInstitutional" inactiveat="InactiveAt" inactiveby="InactiveBy" /><profile profilecode="ProfileCode" license="License" federalid="FederalID" clianumber="CLIANumber" userfilefid="UserFileFID" taxonomy="Taxonomy" npinumber="NPINumber" billasfid="BillAsFID" feeschedulefid="FeeScheduleFID" referringproviderfid="ReferringProviderFID" groupfid="GroupFID" statementgroupfid="StatementGroupFID" description="Description" facilityfid="FacilityFID" xrefidschangedat="XRefIDsChangedAt" address1="Address1" address2="Address2" zipcode="ZipCode" city="City" state="State" areacode="AreaCode" countrycode="CountryCode" officephone="OfficePhone" officeextension="OfficeExtension" fax="Fax" changedat="ChangedAt" changedby="ChangedBy" createuser="CreateUser" createdat="CreatedAt" isdefault="IsDefault" hideinchargeentry="HideInChargeEntry" providername="ProviderName" upinnumber="UPINNumber"/></ppmdmsg>';
        for(Dom.XmlNode childElement1:AdvancedMDConnector.getAdvancedMDObject(org, xmlData)){
            for(Dom.XmlNode childElement2:childElement1.getChildElements()){
                if(String.isNotBlank(childElement2.getAttributeValue('id', ''))) contactsMap.put(org.touppercase() + '-' + childElement2.getAttributeValue('id', ''), new Contact(
                    AdvancedMDID__c = org.touppercase() + '-' + childElement2.getAttributeValue('id', ''),
                    Profile_Id__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('id', '') : '',
                    Facility_Id__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? org.touppercase() + '-' +  childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('facilityfid', '') : '',
                    FirstName = String.isNotBlank(childElement2.getAttributeValue('firstname', '')) ? childElement2.getAttributeValue('firstname', '').trim() : '',
                    MiddleName = String.isNotBlank(childElement2.getAttributeValue('middlename', '')) ? childElement2.getAttributeValue('middlename', '').trim() : '',
                    LastName = String.isNotBlank(childElement2.getAttributeValue('lastname', '')) ? childElement2.getAttributeValue('lastname', '').trim() : '',
                    Created_Date__c = String.isNotBlank(childElement2.getAttributeValue('createdat', '')) ? DateTime.valueOf(childElement2.getAttributeValue('createdat', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                    Changed_Date__c = String.isNotBlank(childElement2.getAttributeValue('changedat', '')) ? DateTime.valueOf(childElement2.getAttributeValue('changedat', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                    Code__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('profilecode', '') : '',
                    MailingStreet = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? (String.isNotBlank(childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('address1', '')) ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('address1', '') : '') + (String.isNotBlank(childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('address2', '')) ? (String.isNotBlank(childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('address1', '')) ? ', ' : '') + childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('address2', '') : '') : '',
                    MailingCity = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('city', '') : '',
                    MailingState = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('state', '') : '',
                    MailingPostalCode = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('zipcode', '') : '',
                    Phone = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? (String.isNotBlank(childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('officephone', '')) ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('officephone', '') : '') + (String.isNotBlank(childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('officeextension', '')) ? (String.isNotBlank(childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('officephone', '')) ? ' - ' : '') + childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('officeextension', '') : '') : '',
                    HomePhone = childElement2.getAttributeValue('homephone', ''),
                    Fax = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('fax', '') : '',
                    MobilePhone = childElement2.getAttributeValue('cell', ''),
                    Email = childElement2.getAttributeValue('email', ''),
                    OtherPhone = childElement2.getAttributeValue('pager', ''),
                    Status__c = String.isNotBlank(childElement2.getAttributeValue('status', '')) ? childElement2.getAttributeValue('status', '').toLowerCase().capitalize() : '',
                    License__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('license', '') : '',
                    Federal_ID__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('federalid', '') : '',
                    Clia_Number__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('clianumber', '') : '',
                    Taxonomy__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('taxonomy', '') : '',
                    NPI_Number__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('npinumber', '') : '',
                    Group__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? (childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('groupfid', '') == '3' ? 'ARCHES INTERNAL MEDICINE' : childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('groupfid', '') == '6' ? 'ARCHES BEHAVIORAL' : childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('groupfid', '') == '5' ? 'ARCHES OB/GYN' : childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('groupfid', '')) : '',
                    Statement_Group__c = childElement2.getChildElement('profilelist', null) != null && !childElement2.getChildElement('profilelist', null).getChildElements().isEmpty() ? (childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('statementgroupfid', '') == '1' ? 'ARCHES MEDICAL CENTER' : childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('statementgroupfid', '') == '2' ? 'ARCHES MEDICAL CENTER' : childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('statementgroupfid', '') == '23' ? 'BAKER' : childElement2.getChildElement('profilelist', null).getChildElements()[0].getAttributeValue('statementgroupfid', '')) : '',
                    Upin_Number__c = childElement2.getAttributeValue('upinnumber', ''),
                    Title = childElement2.getAttributeValue('title', '')
                ));
            } 
        }
        AdvancedMD_List__c authentication = AdvancedMD_List__c.getValues(org);
        try{
            System.debug('Update auth!' + authentication.Name + '-' + authentication.Token_Datetime__c);
            authentication.Token_Datetime__c = Datetime.now();update authentication;
        }catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
        }
        return contactsMap.values();
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        Map<String, Account> accountsMap = new Map<String, Account>();
        List<Account> accountsToInsert = new List<Account>();
        for(Contact contact:scope) if(String.isNotBlank(contact.Facility_Id__c) && contact.Facility_Id__c != 'NMC-0') accountsMap.put(contact.Facility_Id__c, new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('RMC Facility') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('RMC Facility').getRecordTypeId() : null, AdvancedMD_Facility_ID__c = contact.Facility_Id__c, Name = contact.Facility_Id__c));
        for(Account account:[Select id, AdvancedMD_Facility_ID__c from Account where AdvancedMD_Facility_ID__c in:accountsMap.keySet()]) accountsMap.put(account.AdvancedMD_Facility_ID__c, account);
        for(Account account:accountsMap.values()) if(String.isEmpty(account.id)) accountsToInsert.add(account);
        if(!accountsToInsert.isEmpty()){
            ApexUtil.isAdvancedMDAccountTriggerInvoked = true;
            List<Database.SaveResult> saveResults = Database.insert(accountsToInsert, false);
            for(Database.SaveResult saveResult:saveResults) if(!saveResult.isSuccess()) for(Database.Error saveError : saveResult.getErrors()) System.debug('AdvancedMDGetUpdatedProviders - Account Insert Error: ' + saveError.getMessage());
        }
        for(Contact contact:scope) if(accountsMap.get(contact.Facility_Id__c) != null) contact.AccountId = accountsMap.get(contact.Facility_Id__c).id;
        ApexUtil.isContactTriggerInvoked = true;
        List<Database.UpsertResult> upsertResults = Database.upsert(scope, Contact.AdvancedMDID__c, false);
        for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetUpdatedProviders - Contact Upsert Error: ' + upsertError.getMessage());
    }
    global void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()) Database.executeBatch(new ImportGetPatientsBatch(org)); 
    }
}