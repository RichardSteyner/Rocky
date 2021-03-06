global class AuxAMDGetPatientsBatch implements Database.Batchable<Account>, Database.Stateful, Database.AllowsCallouts{
    public String org;
    public Boolean isPaginated;
    public Map<String, Account> accountsMap;
    public Map<String, Account> accountsMapCopy;
    public Map<String, String> racesMap;
    public String[] keys;
    
    global AuxAMDGetPatientsBatch(String org, String[] keys){
        this(org, false, new Map<String, Account>(), new Map<String, Account>());
        this.keys = keys;
    }
    
    global AuxAMDGetPatientsBatch(String org, Boolean isPaginated, Map<String, Account> accountsMap, Map<String, Account> accountsMapCopy){
        this.org = org;
        this.isPaginated = isPaginated;
        this.accountsMap = accountsMap;
        this.accountsMapCopy = accountsMapCopy;
        racesMap = new Map<String, String>();
        for(Schema.PicklistEntry race:Account.Race__c.getDescribe().getPicklistValues()) racesMap.put(race.getLabel(), race.getValue());
    }
    global List<Account> start(Database.BatchableContext BC){
        String primaryClinic = String.isNotBlank(org) ? (!org.equalsIgnoreCase('AMC') ? (!org.equalsIgnoreCase('BRMC') ? (!org.equalsIgnoreCase('CMC') ? (!org.equalsIgnoreCase('TMC') ? (!org.equalsIgnoreCase('NMC') ? (!org.equalsIgnoreCase('RMMC') ? (!org.equalsIgnoreCase('Production') ? 'Colorado Springs' : 'Rocky Mountain Mens Clinic') : 'Rocky Mountain Mens Clinic') : 'Northeast Mens Clinic') : 'Tennessee Mens Clinic') : 'Columbus Mens Clinic') : 'Baton Rouge Mens Clinic') : 'Alabama Mens Clinic')  : '' ;
        System.debug('Start PC: ' + primaryClinic);
        if(!isPaginated){
            for(String key : keys){
                accountsMap.put(org.touppercase() + '-' + key, new Account(
                                Primary_Clinic__c = primaryClinic,
                                RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null,
                                AdvancedMDID__c = org.touppercase() + '-' + key
                            ));
            }
            isPaginated = true;
            accountsMapCopy = new Map<String, Account> (accountsMap);
        }
        if(isPaginated){
            List<Account> accountsListAux = new List<Account>();
            Integer i = 1;
            for(Account acc : accountsMapCopy.values()){
                if(i>1) break;
                accountsListAux.add(acc);
                i++;
            }
            return accountsListAux;
        }
        
        return accountsMap.values();
    }
    global void execute(Database.BatchableContext BC, List<Account> scopeB){
        Map<String, Account> accountsMapScope = new Map<String, Account>();
        String primaryClinic = String.isNotBlank(org) ? (!org.equalsIgnoreCase('AMC') ? (!org.equalsIgnoreCase('BRMC') ? (!org.equalsIgnoreCase('CMC') ? (!org.equalsIgnoreCase('TMC') ? (!org.equalsIgnoreCase('NMC') ? (!org.equalsIgnoreCase('RMMC') ? (!org.equalsIgnoreCase('Production') ? 'Colorado Springs' : 'Rocky Mountain Mens Clinic') : 'Rocky Mountain Mens Clinic') : 'Northeast Mens Clinic') : 'Tennessee Mens Clinic') : 'Columbus Mens Clinic') : 'Baton Rouge Mens Clinic') : 'Alabama Mens Clinic')  : '' ;
        System.debug('Execute PC: ' + primaryClinic);
        String patientsXml = '';
        for(Account acc:scopeB){patientsXml += '<patient id="' + ApexUtil.getAMDID(acc.AdvancedMDID__c, org) + '"/>';accountsMapCopy.remove(acc.AdvancedMDID__c);}
        String xmlData = '<ppmdmsg action="getupdatedpatients" class="api" datechanged="' + Datetime.valueOf('2000-01-01 00:00:00').format() +'"><patientlist>' + patientsXml + '</patientlist><patient lastname="LastName" firstname="FirstName" middlename="MiddleName" name="Name" chart="Chart" title="Title" address1="Address1" address2="Address2" zip="Zip" city="City" state="State" officephone="OfficePhone" officeext="OfficeExt" homephone="HomePhone" otherphone="OtherPhone" additionalmrn="AdditionalMrn" ethnicityid="EthnicityID" languageid="LanguageID" maritalstatusid="MaritalStatusID" othertype="OtherType" email="Email" maritalstatus="MaritalStatus" dob="DOB" deceased="Deceased" sex="Sex" ssn="SSN" relationship="Relationship" hipaarelationship="HIPAARelationship" ethnicity="Ethnicity" language="Language" races="Races" ptinactivedate="PtInactiveDate" ptinactivestatuscode="PtInactiveStatusCode" ptinactivedescription="PtInactiveDescription" ptinactiveexcludedfromsearch="PtInactiveExcludedFromSearch" respparty="RespParty" rplastname="RPLastName" rpfirstname="RPFirstName" rpmiddlename="RPMiddleName" rpfullname="RPFullName" rpaddress1="RPAddress1" rpaddress2="RPAddress2" rpzipcode="RPZipCode" rpcity="RPCity" rpstate="RPState" rpemployer="RPEmployer" rpaccttypecode="RPAcctTypeCode" rpaccttypedescription="RPAcctTypeDescription" rpofficephone="RPOfficePhone" rpofficeextension="RPOfficeExtension" rphomephone="RPHomePhone" rpotherphone="RPOtherPhone" rpotherphonetype="RPOtherPhoneType" rpemail="RPEmail" rpdob="RPDOB" rpgender="RPGender" rpssn="RPSSN" rptitle="RPTitle" rpemploymentstatus="RPEmploymentStatus" rpcreatedat="RPCreatedAt" rpcreatedby="RPCreatedBy" rpdisplay="RPDisplay" rpchangedat="RPChangedAt" rpchangedby="RPChangedBy" provider="Provider" profile="Profile" profilecode="ProfileCode" profilename="ProfileName" provlastname="ProvLastName" provfirstname="ProvFirstName" provmiddlename="ProvMiddleName" provfullname="ProvFullName" provtitle="ProvTitle" finclass="FinClass" finclasscode="FinClassCode" finclassdescription="FinClassDescription" employerid="EmployerID" employer="Employer" insorder="InsOrder" createdat="CreatedAt" createdby="CreatedBy" changedat="ChangedAt" changedby="ChangedBy" iccreatedat="ICCreatedAt" icchangedat="ICChangedAt" refplanchangedat="RefPlanChangedAt" customdatachangedat="CustomDataChangedAt" episodechangedat="EpisodeChangedAt" confidentialcommunicationf="ConfidentialCommunicationf"/><referralplan referraltype="ReferralType" defaultinchargeentry="DefaultinChargeEntry" byreferringproviderfid="ByReferringProviderFID" toreferringproviderfid="ToReferringProviderFID" reason="Reason" preauthcode="PreAuthCode" expirationdate="ExpirationDate" maxcharge="MaxCharge" usedcharge="UsedCharge" maxauthvisits="MaxAuthVisits" authvisitsused="AuthVisitsUsed" chargecodefid="ChargeCodeFID" statuscodefid="StatusCodeFID" facilityfid="FacilityFID" preauthorizationrequired="PreAuthorizationRequired" sequencenumber="SequenceNumber" referralplansourcefid="ReferralPlanSourceFID" diagnosiscodes="DiagnosisCodes" createdby="CreatedBy" createdat="CreatedAt" changedby="ChangedBy" changedat="ChangedAt" byrefprovlastname="ByRefProvLastName" byrefprovfirstname="ByRefProvFirstName" byrefprovmiddlename="ByRefProvMiddleName" byrefprovfullname="ByRefProvFullName" byrefprovtitle="ByRefProvTitle"/></ppmdmsg>';
        for(Dom.XmlNode childElement1:AdvancedMDConnector.getAdvancedMDObject(org, xmlData)){
            for(Dom.XmlNode childElement2:childElement1.getChildElements()){
                if(String.isNotBlank(childElement2.getAttributeValue('id', ''))){
                    accountsMapScope.put(org.touppercase() + '-' + childElement2.getAttributeValue('id', ''), new Account(
                        Primary_Clinic__c = primaryClinic,
                        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null,
                        AdvancedMDID__c = org.touppercase() + '-' + childElement2.getAttributeValue('id', ''),
                        Provider_Id__c = String.IsNotBlank(childElement2.getAttributeValue('provider', '')) ? org.touppercase() + '-' + childElement2.getAttributeValue('provider', '') : '',
                        Responsible_Party_Id__c = String.IsNotBlank(childElement2.getAttributeValue('respparty', '')) ? org.touppercase() + '-' + childElement2.getAttributeValue('respparty', '') : '',
                        FirstName = childElement2.getAttributeValue('firstname', ''),
                        MiddleName = childElement2.getAttributeValue('middlename', ''),
                        LastName = String.isNotBlank(childElement2.getAttributeValue('lastname', '')) ? childElement2.getAttributeValue('lastname', '') : childElement2.getAttributeValue('id', ''),
                        Created_Date__c = String.isNotBlank(childElement2.getAttributeValue('createdat', '')) ? DateTime.valueOf(childElement2.getAttributeValue('createdat', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                        Changed_Date__c = String.isNotBlank(childElement2.getAttributeValue('changedat', '')) ? DateTime.valueOf(childElement2.getAttributeValue('changedat', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                        Chart_Number__c = childElement2.getAttributeValue('chart', ''),
                        PersonTitle = String.isNotBlank(childElement2.getAttributeValue('rpemployer', '')) ? childElement2.getAttributeValue('rpemployer', '').left(80) + '.' : '',
                        Salutation = String.isNotBlank(childElement2.getAttributeValue('title', '')) ? childElement2.getAttributeValue('title', '') + '.' : '',
                        BillingStreet = (String.isNotBlank(childElement2.getAttributeValue('address1', '')) ? childElement2.getAttributeValue('address1', '') : '') + (String.isNotBlank(childElement2.getAttributeValue('address2', '')) ? (String.isNotBlank(childElement2.getAttributeValue('address1', '')) ? ', ' : '') + childElement2.getAttributeValue('address2', '') : ''),
                        BillingCity = childElement2.getAttributeValue('city', ''),
                        BillingState = childElement2.getAttributeValue('state', ''),
                        BillingPostalCode = childElement2.getAttributeValue('zip', ''),
                        PersonHomePhone = childElement2.getAttributeValue('homephone', ''),
                        Work_Phone__c = (String.isNotBlank(childElement2.getAttributeValue('officephone', '')) ? childElement2.getAttributeValue('officephone', '') : '') + (String.isNotBlank(childElement2.getAttributeValue('officeext', '')) ? (String.isNotBlank(childElement2.getAttributeValue('officephone', '')) ? ' - ' : '') + childElement2.getAttributeValue('officeext', '') : ''),
                        PersonMobilePhone = childElement2.getAttributeValue('othertype', '') == 'CELL' ? childElement2.getAttributeValue('otherphone', '') : '',
                        Fax = childElement2.getAttributeValue('othertype', '') == 'FAX' ? childElement2.getAttributeValue('otherphone', '') : '',
                        PersonOtherphone = childElement2.getAttributeValue('othertype', '') == 'OTHER' ? childElement2.getAttributeValue('otherphone', '') : '',
                        PersonEmail = childElement2.getAttributeValue('email', ''),
                        Patient_Status__c = String.isBlank(childElement2.getAttributeValue('deceased', '')) ? 'Active' : 'Deceased',
                        Patient_Inactivate_Date__c = String.isNotBlank(childElement2.getAttributeValue('ptinactivedate', '')) ? Date.valueOf(childElement2.getAttributeValue('ptinactivedate', '').substringBefore('T')) : null,
                        Patient_Inactivate_Description__c = childElement2.getAttributeValue('ptinactivedescription', ''),
                        As_of_Date__c = String.isNotBlank(childElement2.getAttributeValue('deceased', '')) ? Date.valueOf(childElement2.getAttributeValue('deceased', '').substringBefore('T')) : null,
                        PersonBirthdate = String.isNotBlank(childElement2.getAttributeValue('dob', '')) ? Date.valueOf(childElement2.getAttributeValue('dob', '').substringBefore('T')) : null,
                        Sex__c = childElement2.getAttributeValue('sex', '') == 'M' ? 'Male' : childElement2.getAttributeValue('sex', '') == 'F' ? 'Female' : childElement2.getAttributeValue('sex', '') == 'U' ? 'Unknown' : childElement2.getAttributeValue('sex', ''),
                        SSN__c = childElement2.getAttributeValue('ssn', ''),
                        Marital_Status__c = childElement2.getAttributeValue('maritalstatusid', '') == '1' ? 'Single' : childElement2.getAttributeValue('maritalstatusid', '') == '2' ? 'Married' : childElement2.getAttributeValue('maritalstatusid', '') == '3' ? 'Divorced' : childElement2.getAttributeValue('maritalstatusid', '') == '4' ? 'Legally Separated' : childElement2.getAttributeValue('maritalstatusid', '') == '5' ? 'Widowed' : childElement2.getAttributeValue('maritalstatusid', '') == '6' ? 'Unknown' : childElement2.getAttributeValue('maritalstatusid', '') == '0' ? '' : childElement2.getAttributeValue('maritalstatusid', ''),
                        Additional_MRN__c = childElement2.getAttributeValue('additionalmrn', ''),
                        Relationship__c = childElement2.getAttributeValue('hipaarelationship', '') == '18' ? '18-Self' : childElement2.getAttributeValue('hipaarelationship', '') == '01' ? '01-Spouse' : childElement2.getAttributeValue('hipaarelationship', '') == '04' ? '04-Grandfather or Grandmother' : childElement2.getAttributeValue('hipaarelationship', '') == '05' ? '05-Grandson or Granddaughter' : childElement2.getAttributeValue('hipaarelationship', '') == '07' ? '07-Nephew or Niece' : childElement2.getAttributeValue('hipaarelationship', '') == '09' ? '09-Adopted Child' : childElement2.getAttributeValue('hipaarelationship', '') == '10' ? '10-Foster Child' : childElement2.getAttributeValue('hipaarelationship', '') == '15' ? '15-Ward' : childElement2.getAttributeValue('hipaarelationship', '') == '17' ? '17-Stepson or Stepdaughter' : childElement2.getAttributeValue('hipaarelationship', '') == '19' ? '19-Child' : childElement2.getAttributeValue('hipaarelationship', '') == '20' ? '20-Employee' : childElement2.getAttributeValue('hipaarelationship', '') == '21' ? '21-Unknown' : childElement2.getAttributeValue('hipaarelationship', '') == '22' ? '22-Handicapped Dependent' : childElement2.getAttributeValue('hipaarelationship', '') == '23' ? '23-Sponsored Dependent' : childElement2.getAttributeValue('hipaarelationship', '') == '24' ? '24-Dependent of a Minor Dependent' : childElement2.getAttributeValue('hipaarelationship', '') == '29' ? '29-Significant Other' : childElement2.getAttributeValue('hipaarelationship', '') == '32' ? '32-Mother' : childElement2.getAttributeValue('hipaarelationship', '') == '33' ? '33-Father' : childElement2.getAttributeValue('hipaarelationship', '') == '34' ? '34-Other Adult' : childElement2.getAttributeValue('hipaarelationship', '') == '36' ? '36-Emancipated Minor' : childElement2.getAttributeValue('hipaarelationship', '') == '39' ? '39-Organ Donor' : childElement2.getAttributeValue('hipaarelationship', '') == '40' ? '40-Cadaver Donor' : childElement2.getAttributeValue('hipaarelationship', '') == '41' ? '41-Injured Plaintiff' : childElement2.getAttributeValue('hipaarelationship', '') == '43' ? '43-Child Where Insured Has No Financial Responsibility' : childElement2.getAttributeValue('hipaarelationship', '') == '53' ? '53-Life Partner' : childElement2.getAttributeValue('hipaarelationship', '') == 'G8' ? 'G8-Other Relationship' : childElement2.getAttributeValue('hipaarelationship', ''),
                        Preferred_Language__c = String.isNotBlank(childElement2.getAttributeValue('languageid', '')) && childElement2.getAttributeValue('languageid', '') != '0' ? childElement2.getAttributeValue('languageid', '') : null,
                        Employer__c = childElement2.getAttributeValue('employer', ''),
                        Race__c = String.isNotBlank(childElement2.getAttributeValue('races', '')) && racesMap.get(childElement2.getAttributeValue('races', '')) != null ? racesMap.get(childElement2.getAttributeValue('races', '')) : childElement2.getAttributeValue('races', ''),
                        Ethnicity__c = String.isNotBlank(childElement2.getAttributeValue('ethnicityid', '')) && childElement2.getAttributeValue('ethnicityid', '') != '0' ? childElement2.getAttributeValue('ethnicityid', '') : null,
                        Referring_Provider_First_Name__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('byrefprovfirstname', '') : '',
                        Referring_Provider_Last_Name__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('byrefprovlastname', '') : '',
                        Referral_Reason__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('reason', '') : '',
                        Referral_Type__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referraltype', '') : '',
                        Defaultinchargeentry__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('defaultinchargeentry', '') : '',
                        Referring_Expiration_Date__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() && String.isNotBlank(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('expirationdate', '')) ? DateTime.valueOf(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('expirationdate', '').substringBeforeLast('.').replace('T', ' ')) : null,
                        Max_Charge__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() && String.isNotBlank(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('maxcharge', '')) ? Decimal.valueOf(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('maxcharge', '')) : null,
                        Used_Charge__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() && String.isNotBlank(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('usedcharge', '')) ? Decimal.valueOf(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('usedcharge', '')) : null,
                        Max_Auth_Visits__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() && String.isNotBlank(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('maxauthvisits', '')) ? Integer.valueOf(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('maxauthvisits', '')) : null,
                        Auth_Visits_Used__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() && String.isNotBlank(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('authvisitsused', '')) ? Integer.valueOf(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('authvisitsused', '')) : null,
                        Preauthorization_Required__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('preauthorizationrequired', '') == '1' : false,
                        ChargecodefId__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('chargecodefid', '') : '',
                        Referral_Status__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? (childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('statuscodefid', '') == '11' ? 'Appeal' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('statuscodefid', '') == '8' ? 'Approved' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('statuscodefid', '') == '10' ? 'Closed' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('statuscodefid', '') == '9' ? 'Denied' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('statuscodefid', '') == '7' ? 'Pending Approval' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('statuscodefid', '')) : '',
                        Sequence_Number__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() && String.isNotBlank(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('sequencenumber', '')) ? Integer.valueOf(childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('sequencenumber', '')) : null,
                        Referral_Plan_Source__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? (childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '10' ? 'CLINIC SIGN' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '2' ? 'DOCTOR RECOMMENDED' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '11' ? 'EMPLOYER RECOMMENDED' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '14' ? 'FAMILY OR FRIEND' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '1' ? 'FORMER PATIENT' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '8' ? 'INSURANCE COMPANY' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '17' ? 'NEWSPAPER' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '16' ? 'OTHER' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '18' ? 'PT MESSAGE CAMPAIGN' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '12' ? 'RADIO ADVERTISEMENT' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '9' ? 'TV ADVERTISEMENT' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '15' ? 'WEB PAGE' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '13' ? 'YELLOW PAGES' :  childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '')) : '',
                        PersonLeadSource = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? (childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '10' ? 'CLINIC SIGN' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '2' ? 'DOCTOR RECOMMENDED' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '11' ? 'EMPLOYER RECOMMENDED' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '14' ? 'FAMILY OR FRIEND' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '1' ? 'FORMER PATIENT' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '8' ? 'INSURANCE COMPANY' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '17' ? 'NEWSPAPER' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '16' ? 'OTHER' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '18' ? 'PT MESSAGE CAMPAIGN' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '12' ? 'RADIO ADVERTISEMENT' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '9' ? 'TV ADVERTISEMENT' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '15' ? 'WEB PAGE' : childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '') == '13' ? 'YELLOW PAGES' :  childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('referralplansourcefid', '')) : '',
                        Diagnosis_Codes__c = childElement2.getChildElement('referralplanlist', null) != null && !childElement2.getChildElement('referralplanlist', null).getChildElements().isEmpty() ? childElement2.getChildElement('referralplanlist', null).getChildElements()[0].getAttributeValue('diagnosiscodes', '') : ''
                    ));
                }
            } 
        }
        
        List<Account> scope = accountsMapScope.values();
        
        Map<String, User> usersMap = new Map<String, User>();
        Map<String, Contact> contactsMap = new Map<String, Contact>();
        Map<String, Contact> referringContactsMap = new Map<String, Contact>();
        Map<String, Account> respPartyaccountsScopeMap = new Map<String, Account>();
        for(Account account:scope){
            if(String.isNotBlank(account.Provider_Id__c)) contactsMap.put(account.Provider_Id__c, new Contact());
            if(String.isNotBlank(account.Referring_Provider_First_Name__c) || String.isNotBlank(account.Referring_Provider_Last_Name__c)) referringContactsMap.put((account.Referring_Provider_First_Name__c + ' ' + account.Referring_Provider_Last_Name__c).trim().touppercase(), new Contact());
        }
        for(User user:[Select id, Name from User where isActive = true]) usersMap.put(user.Name, user);
        for(Contact contact:[Select id, AdvancedMDID__c, Name from Contact where AdvancedMDID__c in :contactsMap.keySet()]) contactsMap.put(contact.AdvancedMDID__c, contact);
        for(Contact contact:[Select id, Name from Contact where Name in :referringContactsMap.keySet() and isPersonAccount=false]) referringContactsMap.put(contact.Name.trim().touppercase(), contact);
        List<Database.UpsertResult> upsertResults;
        ApexUtil.isAdvancedMDAccountTriggerInvoked = true;
        
        for(Account account:scope){
            if(contactsMap.get(account.Provider_Id__c) != null) account.Provider__c = contactsMap.get(account.Provider_Id__c).id;
            if(contactsMap.get(account.Provider_Id__c) != null && usersMap.get(contactsMap.get(account.Provider_Id__c).Name) != null) account.ownerId = usersMap.get(contactsMap.get(account.Provider_Id__c).Name).id;
            System.debug(referringContactsMap.get((account.Referring_Provider_First_Name__c + ' ' + account.Referring_Provider_Last_Name__c).trim().touppercase()));
            if(referringContactsMap.get((account.Referring_Provider_First_Name__c + ' ' + account.Referring_Provider_Last_Name__c).trim().touppercase()) != null && referringContactsMap.get((account.Referring_Provider_First_Name__c + ' ' + account.Referring_Provider_Last_Name__c).trim().touppercase()).Id != null) account.Referred_By__c = referringContactsMap.get((account.Referring_Provider_First_Name__c + ' ' + account.Referring_Provider_Last_Name__c).trim().touppercase()).id;
        }
        upsertResults = Database.upsert(scope, Account.AdvancedMDID__c, false);
        for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetPatientsBatch - Account Upsert Error: ' + upsertError.getMessage());
    
        for(Account a: scope){
            if(a.Id!=null){
                if(accountsMap.get(a.AdvancedMDID__c)!=null)
                    accountsMap.get(a.AdvancedMDID__c).Id=a.Id;
            } else{
                System.debug('No se pudo guardar: ' + a.AdvancedMDID__c + '\n' + accountsMapScope.get(a.AdvancedMDID__c));
                accountsMap.remove(a.AdvancedMDID__c);
            }
        }
    }
    global void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()) {
            if(isPaginated && !accountsMapCopy.values().isEmpty()) System.scheduleBatch(new AuxAMDGetPatientsBatch(org, true, accountsMap, accountsMapCopy), 'AuxAMDGetPatientsBatch', 1, 200);
            else Database.executeBatch(new AuxAMDGetVisitsPatientBatch(org, accountsMap), 50);
        }       
    }
}