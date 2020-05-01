@isTest
public class AdvancedMDTest {
    
    private static AdvancedMD_List__c authentication = AdvancedMD_List__c.getOrgDefaults();
    
    static{
        authentication.Name = 'RMMC';
        authentication.APP_Name__c = 'TEMP';
        authentication.Office_Code__c = '13667';
        authentication.Password__c = 'password';
        authentication.URL_Login__c = 'https://partnerlogin.advancedmd.com/practicemanager/xmlrpc/processrequest.aspx';
        authentication.Username__c = 'user';
        insert authentication;
        AdvancedMD_List__c authenticationAMC = new AdvancedMD_List__c();
        authenticationAMC.Name = 'AMC';
        authenticationAMC.APP_Name__c = 'TEMP';
        authenticationAMC.Office_Code__c = '13667';
        authenticationAMC.Password__c = 'password';
        authenticationAMC.URL_Login__c = 'https://partnerlogin.advancedmd.com/practicemanager/xmlrpc/processrequest.aspx';
        authenticationAMC.Username__c = 'user';
        insert authenticationAMC;
        AdvancedMD_List__c authenticationBRMC = new AdvancedMD_List__c();
        authenticationBRMC.Name = 'BRMC';
        authenticationBRMC.APP_Name__c = 'TEMP';
        authenticationBRMC.Office_Code__c = '13667';
        authenticationBRMC.Password__c = 'password';
        authenticationBRMC.URL_Login__c = 'https://partnerlogin.advancedmd.com/practicemanager/xmlrpc/processrequest.aspx';
        authenticationBRMC.Username__c = 'user';
        insert authenticationBRMC;
        AdvancedMD_List__c authenticationCMC = new AdvancedMD_List__c();
        authenticationCMC.Name = 'CMC';
        authenticationCMC.APP_Name__c = 'TEMP';
        authenticationCMC.Office_Code__c = '13667';
        authenticationCMC.Password__c = 'password';
        authenticationCMC.URL_Login__c = 'https://partnerlogin.advancedmd.com/practicemanager/xmlrpc/processrequest.aspx';
        authenticationCMC.Username__c = 'user';
        insert authenticationCMC;
        AdvancedMD_List__c authenticationNMC = new AdvancedMD_List__c();
        authenticationNMC.Name = 'NMC';
        authenticationNMC.APP_Name__c = 'TEMP';
        authenticationNMC.Office_Code__c = '13667';
        authenticationNMC.Password__c = 'password';
        authenticationNMC.URL_Login__c = 'https://partnerlogin.advancedmd.com/practicemanager/xmlrpc/processrequest.aspx';
        authenticationNMC.Username__c = 'user';
        insert authenticationNMC;
        AdvancedMD_List__c authenticationTMC = new AdvancedMD_List__c();
        authenticationTMC.Name = 'TMC';
        authenticationTMC.APP_Name__c = 'TEMP';
        authenticationTMC.Office_Code__c = '13667';
        authenticationTMC.Password__c = 'password';
        authenticationTMC.URL_Login__c = 'https://partnerlogin.advancedmd.com/practicemanager/xmlrpc/processrequest.aspx';
        authenticationTMC.Username__c = 'user';
        insert authenticationTMC;
    }
    
    @isTest static void testConnectorOrgInvalida(){
        Test.startTest();
        AdvancedMDConnector.getAdvancedMDObject('RRMC', '<ppmdmsg action="getupdatedpatients" class="api" datechanged="' + Datetime.now().addHours(-24).format() + '"><patient lastname="LastName" firstname="FirstName" middlename="MiddleName" name="Name" chart="Chart" title="Title" address1="Address1" address2="Address2" zip="Zip" city="City" state="State" officephone="OfficePhone" officeext="OfficeExt" homephone="HomePhone" otherphone="OtherPhone" additionalmrn="AdditionalMrn" ethnicityid="EthnicityID" languageid="LanguageID" maritalstatusid="MaritalStatusID" othertype="OtherType" email="Email" maritalstatus="MaritalStatus" dob="DOB" deceased="Deceased" sex="Sex" ssn="SSN" relationship="Relationship" hipaarelationship="HIPAARelationship" ethnicity="Ethnicity" language="Language" races="Races" ptinactivedate="PtInactiveDate" ptinactivestatuscode="PtInactiveStatusCode" ptinactivedescription="PtInactiveDescription" ptinactiveexcludedfromsearch="PtInactiveExcludedFromSearch" respparty="RespParty" rplastname="RPLastName" rpfirstname="RPFirstName" rpmiddlename="RPMiddleName" rpfullname="RPFullName" rpaddress1="RPAddress1" rpaddress2="RPAddress2" rpzipcode="RPZipCode" rpcity="RPCity" rpstate="RPState" rpemployer="RPEmployer" rpaccttypecode="RPAcctTypeCode" rpaccttypedescription="RPAcctTypeDescription" rpofficephone="RPOfficePhone" rpofficeextension="RPOfficeExtension" rphomephone="RPHomePhone" rpotherphone="RPOtherPhone" rpotherphonetype="RPOtherPhoneType" rpemail="RPEmail" rpdob="RPDOB" rpgender="RPGender" rpssn="RPSSN" rptitle="RPTitle" rpemploymentstatus="RPEmploymentStatus" rpcreatedat="RPCreatedAt" rpcreatedby="RPCreatedBy" rpdisplay="RPDisplay" rpchangedat="RPChangedAt" rpchangedby="RPChangedBy" provider="Provider" profile="Profile" profilecode="ProfileCode" profilename="ProfileName" provlastname="ProvLastName" provfirstname="ProvFirstName" provmiddlename="ProvMiddleName" provfullname="ProvFullName" provtitle="ProvTitle" finclass="FinClass" finclasscode="FinClassCode" finclassdescription="FinClassDescription" employerid="EmployerID" employer="Employer" insorder="InsOrder" createdat="CreatedAt" createdby="CreatedBy" changedat="ChangedAt" changedby="ChangedBy" iccreatedat="ICCreatedAt" icchangedat="ICChangedAt" refplanchangedat="RefPlanChangedAt" customdatachangedat="CustomDataChangedAt" episodechangedat="EpisodeChangedAt" confidentialcommunicationf="ConfidentialCommunicationf"/><referralplan referraltype="ReferralType" defaultinchargeentry="DefaultinChargeEntry" byreferringproviderfid="ByReferringProviderFID" toreferringproviderfid="ToReferringProviderFID" reason="Reason" preauthcode="PreAuthCode" expirationdate="ExpirationDate" maxcharge="MaxCharge" usedcharge="UsedCharge" maxauthvisits="MaxAuthVisits" authvisitsused="AuthVisitsUsed" chargecodefid="ChargeCodeFID" statuscodefid="StatusCodeFID" facilityfid="FacilityFID" preauthorizationrequired="PreAuthorizationRequired" sequencenumber="SequenceNumber" referralplansourcefid="ReferralPlanSourceFID" diagnosiscodes="DiagnosisCodes" createdby="CreatedBy" createdat="CreatedAt" changedby="ChangedBy" changedat="ChangedAt" byrefprovlastname="ByRefProvLastName" byrefprovfirstname="ByRefProvFirstName" byrefprovmiddlename="ByRefProvMiddleName" byrefprovfullname="ByRefProvFullName" byrefprovtitle="ByRefProvTitle"/></ppmdmsg>');
        Test.stopTest();
    }
    
    @isTest static void testConnectorOrgValida(){
        Test.startTest();
        AdvancedMDConnector.getAdvancedMDObject('RMMC', '<ppmdmsg action="getupdatedpatients" class="api" datechanged="' + Datetime.now().addHours(-24).format() + '"><patient lastname="LastName" firstname="FirstName" middlename="MiddleName" name="Name" chart="Chart" title="Title" address1="Address1" address2="Address2" zip="Zip" city="City" state="State" officephone="OfficePhone" officeext="OfficeExt" homephone="HomePhone" otherphone="OtherPhone" additionalmrn="AdditionalMrn" ethnicityid="EthnicityID" languageid="LanguageID" maritalstatusid="MaritalStatusID" othertype="OtherType" email="Email" maritalstatus="MaritalStatus" dob="DOB" deceased="Deceased" sex="Sex" ssn="SSN" relationship="Relationship" hipaarelationship="HIPAARelationship" ethnicity="Ethnicity" language="Language" races="Races" ptinactivedate="PtInactiveDate" ptinactivestatuscode="PtInactiveStatusCode" ptinactivedescription="PtInactiveDescription" ptinactiveexcludedfromsearch="PtInactiveExcludedFromSearch" respparty="RespParty" rplastname="RPLastName" rpfirstname="RPFirstName" rpmiddlename="RPMiddleName" rpfullname="RPFullName" rpaddress1="RPAddress1" rpaddress2="RPAddress2" rpzipcode="RPZipCode" rpcity="RPCity" rpstate="RPState" rpemployer="RPEmployer" rpaccttypecode="RPAcctTypeCode" rpaccttypedescription="RPAcctTypeDescription" rpofficephone="RPOfficePhone" rpofficeextension="RPOfficeExtension" rphomephone="RPHomePhone" rpotherphone="RPOtherPhone" rpotherphonetype="RPOtherPhoneType" rpemail="RPEmail" rpdob="RPDOB" rpgender="RPGender" rpssn="RPSSN" rptitle="RPTitle" rpemploymentstatus="RPEmploymentStatus" rpcreatedat="RPCreatedAt" rpcreatedby="RPCreatedBy" rpdisplay="RPDisplay" rpchangedat="RPChangedAt" rpchangedby="RPChangedBy" provider="Provider" profile="Profile" profilecode="ProfileCode" profilename="ProfileName" provlastname="ProvLastName" provfirstname="ProvFirstName" provmiddlename="ProvMiddleName" provfullname="ProvFullName" provtitle="ProvTitle" finclass="FinClass" finclasscode="FinClassCode" finclassdescription="FinClassDescription" employerid="EmployerID" employer="Employer" insorder="InsOrder" createdat="CreatedAt" createdby="CreatedBy" changedat="ChangedAt" changedby="ChangedBy" iccreatedat="ICCreatedAt" icchangedat="ICChangedAt" refplanchangedat="RefPlanChangedAt" customdatachangedat="CustomDataChangedAt" episodechangedat="EpisodeChangedAt" confidentialcommunicationf="ConfidentialCommunicationf"/><referralplan referraltype="ReferralType" defaultinchargeentry="DefaultinChargeEntry" byreferringproviderfid="ByReferringProviderFID" toreferringproviderfid="ToReferringProviderFID" reason="Reason" preauthcode="PreAuthCode" expirationdate="ExpirationDate" maxcharge="MaxCharge" usedcharge="UsedCharge" maxauthvisits="MaxAuthVisits" authvisitsused="AuthVisitsUsed" chargecodefid="ChargeCodeFID" statuscodefid="StatusCodeFID" facilityfid="FacilityFID" preauthorizationrequired="PreAuthorizationRequired" sequencenumber="SequenceNumber" referralplansourcefid="ReferralPlanSourceFID" diagnosiscodes="DiagnosisCodes" createdby="CreatedBy" createdat="CreatedAt" changedby="ChangedBy" changedat="ChangedAt" byrefprovlastname="ByRefProvLastName" byrefprovfirstname="ByRefProvFirstName" byrefprovmiddlename="ByRefProvMiddleName" byrefprovfullname="ByRefProvFullName" byrefprovtitle="ByRefProvTitle"/></ppmdmsg>');
        Test.stopTest();
    }
    
    @isTest static void testProviderBatch(){
        Test.startTest();
        Database.executeBatch(new AdvancedMDGetProvidersBatch('RMMC', false), 100);
        Test.stopTest();
    }
    
    @isTest static void testPatientBatch() {
        Test.startTest();
        Database.executeBatch(new AdvancedMDGetPatientsBatch('RMMC', false));
        Test.stopTest();
    }
    
    @isTest static void testPatientDemographics(){
        Map<String, Account> accountMap = new Map<String, Account> {'57676'=>new Account(LastName='Test', AdvancedMDID__c='57676', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null)};
        Test.startTest();
        Database.executeBatch(new AdvancedMDGetPatientDemographicsBatch('RMMC', true, accountMap, 12));
        Test.stopTest();
    }
    
    @isTest static void testEhrAllergies(){
        Map<String, Account> accountMap = new Map<String, Account> {'57676'=>new Account(LastName='Test', AdvancedMDID__C='57676', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null)};
        Test.startTest();
        Database.executeBatch(new AdvancedMDGetEhrAllergiesBatch('RMMC', true, accountMap, 12));
        Test.stopTest();
    }
    
    @isTest static void testGetLabResults(){
        Map<String, Account> accountMap = new Map<String, Account> {'57676'=>new Account(LastName='Test', AdvancedMDID__C='57676', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null)};
        Test.startTest();
        Database.executeBatch(new AdvancedMDGetLabResultsBatch('RMMC', true, accountMap, 18));
        Test.stopTest();
    }
    
    @isTest static void testGetEhrNotes(){
        Map<String, Account> accountMap = new Map<String, Account> {'57676'=>new Account(LastName='Test', AdvancedMDID__C='57676', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null)};
        Test.startTest();
        Database.executeBatch(new AdvancedMDGetEhrNotesBatch('RMMC', true, accountMap, 18));
        Test.stopTest();
    }
    
    @isTest static void testGetVisits(){
        Map<String, Account> accountMap = new Map<String, Account> {'57676'=>new Account(LastName='Test', AdvancedMDID__C='57676', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null)};
        Test.startTest();
        Database.executeBatch(new AdvancedMDGetVisitsBatch('RMMC', true, accountMap, 12));
    }
                              
    @isTest static void testGetVisitsPaginated(){
        Map<String, Account> accountMap = new Map<String, Account> {'57676'=>new Account(LastName='Test', AdvancedMDID__C='57676', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null)};
        Test.startTest();
        Database.executeBatch(new AdvancedMDGetVisitsBatch('RMMC', true, accountMap, true, new Map<String, Appointment__c>{'123456'=>new Appointment__c(Name='Test', AdvancedMDID__C='123456' )}, new Map<String, Account>(), 12));
    	Test.stopTest();
    }
    
    @isTest static void testGetTxHistory(){
        Map<String, Account> accountMap = new Map<String, Account> {'57676'=>new Account(LastName='Test', AdvancedMDID__C='57676', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null)};
        Test.startTest();
        Database.executeBatch(new AdvancedMDGetTxHistoryBatch('RMMC', true, accountMap, 12));
        Test.stopTest();
    }
    
    @isTest static void testAddPostPatients(){
        Account acc = new Account();
        Contact conP = new Contact();
        conP.LastName = 'Test';
        conP.Profile_Id__c = '159735';
        insert conP;
        acc.Provider__c = conP.Id;
        /*Account responsible = new Account();
        responsible.LastName = 'Responsible';
        responsible.AdvancedMD_Resp_Party_ID__c = '963147';
        responsible.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Responsible Party')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Responsible Party').getRecordTypeId() : null;
        insert responsible;
        acc.Responsible_Party__c = responsible.Id;*/
        acc.FirstName = 'Richard';
        acc.MiddleName = 'Steyner';
        acc.LastName = 'Urupeque';
        acc.Sex__c = 'Male';
        acc.SSN__c = '159637';
        acc.GI__c = 'Male';
        acc.SO__c = 'Straight / Heterosexual';
        acc.Chart_Number__c = 'text';
        acc.Marital_Status__c = 'Single';
        acc.Employer__c = 'employer';
        acc.Relationship__c = '18-Self';
        acc.PersonTitle = 'Title';
        acc.Preferred_Language__c = '149';
        acc.Race__c = '968';
        acc.Ethnicity__c = '601';
        acc.Additional_MRN__c = 'additional';
        acc.PersonEmail = 'test@hotmail.com';
        acc.BillingStreet = 'street';
        //Select Description From Account Where AdvancedMD_To_Sync__c = true and Primary_Clinic__c=\''+ primaryClinic+'\' limit 12
    	acc.BillingPostalCode = 'zip';
        acc.BillingCity = 'city';
        acc.BillingState = 'state';
        acc.BillingCountry = 'country';
        acc.PersonHomePhone = '987456321';
        acc.PersonMobilePhone = '152645111';
        acc.Fax = '84496232';
        acc.PersonOtherPhone = '46645556';
        acc.Phone = '1554514';
        acc.Confidential__c = 'Work Phone';
        acc.Description = 'description';
        acc.AdvancedMD_To_Sync__c = true;
        acc.Primary_Clinic__c = 'Rocky Mountain Mens Clinic';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null;
        insert acc;
        Test.startTest();
        Database.executeBatch(new AdvancedMDPostPatientsBatch('RMMC'));
        Test.stopTest();
    }
    
    @isTest static void testUpdatePostPatients(){
        Account acc = new Account();
        acc.AdvancedMDID__c = '987654';
        Contact conP = new Contact();
        conP.LastName = 'Test';
        conP.Profile_Id__c = '159735';
        insert conP;
        acc.Provider__c = conP.Id;
        /*Account responsible = new Account();
        responsible.LastName = 'Responsible';
        responsible.AdvancedMD_Resp_Party_ID__c = '963147';
        responsible.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Responsible Party')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Responsible Party').getRecordTypeId() : null;
        insert responsible;
        acc.Responsible_Party__c = responsible.Id;*/
        acc.FirstName = 'Richard';
        acc.MiddleName = 'Steyner';
        acc.LastName = 'Urupeque';
        acc.Sex__c = 'Male';
        acc.SSN__c = '159637';
        acc.GI__c = 'Male';
        acc.SO__c = 'Straight / Heterosexual';
        acc.Chart_Number__c = 'text';
        acc.Marital_Status__c = 'Single';
        acc.Employer__c = 'employer';
        acc.Relationship__c = '18-Self';
        acc.PersonTitle = 'Title';
        acc.Preferred_Language__c = '149';
        acc.Race__c = '968';
        acc.Ethnicity__c = '601';
        acc.Additional_MRN__c = 'additional';
        acc.PersonEmail = 'test@hotmail.com';
        acc.BillingStreet = 'street';
        //Select Description From Account Where AdvancedMD_To_Sync__c = true and Primary_Clinic__c=\''+ primaryClinic+'\' limit 12
    	acc.BillingPostalCode = 'zip';
        acc.BillingCity = 'city';
        acc.BillingState = 'state';
        acc.BillingCountry = 'country';
        acc.PersonHomePhone = '987456321';
        acc.PersonMobilePhone = '152645111';
        acc.Fax = '84496232';
        acc.PersonOtherPhone = '46645556';
        acc.Phone = '1554514';
        acc.Confidential__c = 'Work Phone';
        acc.Description = 'description';
        acc.AdvancedMD_To_Sync__c = true;
        acc.Primary_Clinic__c = 'Rocky Mountain Mens Clinic';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null;
        insert acc;
        Test.startTest();
        Database.executeBatch(new AdvancedMDPostPatientsBatch('RMMC'));
        Test.stopTest();
    }
    
    @isTest static void testUpdatePostVisits(){
        Account acc = new Account();
        acc.AdvancedMDID__c = '987654';
        Contact conP = new Contact();
        conP.LastName = 'Test';
        conP.Profile_Id__c = '159735';
        insert conP;
        acc.Provider__c = conP.Id;
        /*Account responsible = new Account();
        responsible.LastName = 'Responsible';
        responsible.AdvancedMD_Resp_Party_ID__c = '963147';
        responsible.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Responsible Party')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Responsible Party').getRecordTypeId() : null;
        insert responsible;
        acc.Responsible_Party__c = responsible.Id;*/
        acc.FirstName = 'Richard';
        acc.MiddleName = 'Steyner';
        acc.LastName = 'Urupeque';
        acc.Sex__c = 'Male';
        acc.SSN__c = '159637';
        acc.GI__c = 'Male';
        acc.SO__c = 'Straight / Heterosexual';
        acc.Chart_Number__c = 'text';
        acc.Marital_Status__c = 'Single';
        acc.Employer__c = 'employer';
        acc.Relationship__c = '18-Self';
        acc.PersonTitle = 'Title';
        acc.Preferred_Language__c = '149';
        acc.Race__c = '968';
        acc.Ethnicity__c = '601';
        acc.Additional_MRN__c = 'additional';
        acc.PersonEmail = 'test@hotmail.com';
        acc.BillingStreet = 'street';
        //Select Description From Account Where AdvancedMD_To_Sync__c = true and Primary_Clinic__c=\''+ primaryClinic+'\' limit 12
    	acc.BillingPostalCode = 'zip';
        acc.BillingCity = 'city';
        acc.BillingState = 'state';
        acc.BillingCountry = 'country';
        acc.PersonHomePhone = '987456321';
        acc.PersonMobilePhone = '152645111';
        acc.Fax = '84496232';
        acc.PersonOtherPhone = '46645556';
        acc.Phone = '1554514';
        acc.Confidential__c = 'Work Phone';
        acc.Description = 'description';
        acc.AdvancedMD_To_Sync__c = true;
        acc.Primary_Clinic__c = 'Rocky Mountain Mens Clinic';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null;
        insert acc;
        Appointment__c app = new Appointment__c(Name = 'Test app', Patient__c = acc.Id, Provider__c=conP.Id);
        insert app;
        Test.startTest();
        Database.executeBatch(new AdvancedMDPostVisitsBatch('RMMC'));
        Test.stopTest();
    }
    
    @isTest static void testScheduleRMMC() {
        AdvancedMDScheduleRMMC scheduler = new AdvancedMDScheduleRMMC();
        SchedulableContext context;
        Test.startTest();
        scheduler.execute(context);
        Test.stopTest();
    }
    
    @isTest static void testScheduleAMC() {
        AdvancedMDScheduleAMC scheduler = new AdvancedMDScheduleAMC();
        SchedulableContext context;
        Test.startTest();
        scheduler.execute(context);
        Test.stopTest();
    }
    
    @isTest static void testScheduleBRMC() {
        AdvancedMDScheduleBRMC scheduler = new AdvancedMDScheduleBRMC();
        SchedulableContext context;
        Test.startTest();
        scheduler.execute(context);
        Test.stopTest();
    }
    
    @isTest static void testScheduleCMC() {
        AdvancedMDScheduleCMC scheduler = new AdvancedMDScheduleCMC();
        SchedulableContext context;
        Test.startTest();
        scheduler.execute(context);
        Test.stopTest();
    }
    
    @isTest static void testScheduleNMC() {
        AdvancedMDScheduleNMC scheduler = new AdvancedMDScheduleNMC();
        SchedulableContext context;
        Test.startTest();
        scheduler.execute(context);
        Test.stopTest();
    }
    
    @isTest static void testScheduleTMC() {
        AdvancedMDScheduleTMC scheduler = new AdvancedMDScheduleTMC();
        SchedulableContext context;
        Test.startTest();
        scheduler.execute(context);
        Test.stopTest();
    }
    
    @isTest static void testMetadata(){
        MetadataAPIUtility.createRemoteSiteSettings('www.test.com/test');
    }
    
    @isTest static void testMetadataService(){
        MetadataService.ReportTypeColumnTranslation rtct = new MetadataService.ReportTypeColumnTranslation();
        rtct.label = 'test';
        rtct.name = 'test';
        MetadataService.LightningBoltFeatures lbf = new MetadataService.LightningBoltFeatures();
        lbf.description = 'test';
        lbf.order = 1;
        lbf.title = 'test';
        MetadataService.LiveChatDeployment lcd = new MetadataService.LiveChatDeployment();
        MetadataService.ReportFilterItem rfi = new MetadataService.ReportFilterItem();
        MetadataService.FlowElementReferenceOrValue ferv = new MetadataService.FlowElementReferenceOrValue();
        MetadataService.FlowWaitEventOutputParameter fwop = new MetadataService.FlowWaitEventOutputParameter();
        MetadataService.MacroSettings ms = new MetadataSErvice.MacroSettings();
        MetadataService.KnowledgeSuggestedArticlesSettings ksas = new MetadataService.KnowledgeSuggestedArticlesSettings();
        MetadataService.SaveResult sv = new MetadataService.SaveResult();
        MetadataService.ExtendedErrorDetails eed = new MetadataService.ExtendedErrorDetails();
        MetadataService.SessionSettings ss = new MetadataService.SessionSettings();
        MetadataService.SharingOwnerRule sor = new MetadataService.SharingOwnerRule();
        MetadataService.CustomExperienceTabSet cets = new MetadataService.CustomExperienceTabSet();
        MetadataService.FieldMappingField fmf = new MetadataService.FieldMappingField();
        MetadataService.CaseSettings cs = new MetadataService.CaseSettings();
        MetadataService.readMetadataResponse_element rmdre = new MetadataService.readMetadataResponse_element();
        MetadataService.RecommendationDefinition rd = new MetadataService.RecommendationDefinition();
        MetadataService.MiniLayout ml = new MetadataService.MiniLayout();
        MetadataService.FieldValue fv = new MetadataService.FieldValue();
        MetadataService.LicensedCustomPermissions lcp = new MetadataService.LicensedCustomPermissions();
        MetadataService.UpsertResult ur = new MetadataService.UpsertResult();
        MetadataService.WaveXmdDimension wxd = new MetadataService.WaveXmdDimension();
    	MetadataService.ConnectedAppAttribute cap = new MetadataService.ConnectedAppAttribute();
        MetadataService.WorkflowFieldUpdate wfu = new MetadataService.WorkflowFieldUpdate();
        MetadataService.AssignmentRule ar = new MetadataService.AssignmentRule();
        MetadataService.ValueSettings vs = new MetadataService.ValueSettings();
        MetadataService.LiveChatButtonDeployments lcbd = new MetadataService.LiveChatButtonDeployments();
        MetadataService.DataCategoryGroup dcg = new MetadataService.DataCategoryGroup();
        MetadataService.DashboardGridComponent dgc = new MetadataService.DashboardGridComponent();
        MetadataService.CustomDataTypeComponent cdc = new MetadataService.CustomDataTypeComponent();
        MetadataService.NetworkBranding nb = new MetadataService.NetworkBranding();
        MetadataService.UserCriteria uc = new MetadataService.UserCriteria();
        MetadataService.KnowledgeSitesSettings kss = new MetadataService.KnowledgeSitesSettings();
        MetadataService.LightningBoltImages lbi = new MetadataService.LightningBoltImages();
        MetadataService.SearchLayouts sl = new MetadataService.SearchLayouts();
        MetadataService.retrieve_element re = new MetadataService.retrieve_element();
        MetadataService.AssignmentRules ars = new MetadataService.AssignmentRules();
        MetadataService.DeleteResult dr = new MetadataService.DeleteResult();
        MetadataService.PackageTypeMembers ptm = new MetadataService.PackageTypeMembers();
        MetadataService.DashboardFilter df = new MetadataService.DashboardFilter();
        MetadataService.RecommendationAudience ra = new MetadataService.RecommendationAudience();
        MetadataService.ProfileApplicationVisibility pav = new MetadataService.ProfileApplicationVisibility();
        MetadataService.ReportParam rp = new MetadataService.ReportParam();
        MetadataService.RelatedListItem rli = new MetadataService.RelatedListItem();
        MetadataService.SynonymDictionary sd = new MetadataService.SynonymDictionary();
        MetadataService.WaveXmd ww = new MetadataService.WaveXmd();
        MetadataService.WebLinkTranslation wlt = new MetadataService.WebLinkTranslation();
        MetadataService.LightningExperienceTheme let = new MetadataService.LightningExperienceTheme();
        MetadataService.ProfileCategoryGroupVisibility pcgv = new MetadataService.ProfileCategoryGroupVisibility();
        MetadataService.CustomTabTranslation ctt = new MetadataService.CustomTabTranslation();
        MetadataService.PackageVersion pv = new MetadataService.PackageVersion();
        MetadataService.DescribeMetadataObject dmo = new MetadataService.DescribeMetadataObject();
        MetadataService.LiveAgentSettings las = new MetadataService.LiveAgentSettings();
        MetadataService.WorkflowFlowAction wffa = new MetadataService.WorkflowFlowAction();
        MetadataService.WaveApplication wa = new MetadataService.WaveApplication();
        MetadataService.AllOrNoneHeader_element aonh = new MetadataService.AllOrNoneHeader_element();
        MetadataService.WorkflowTaskTranslation wftt = new MetadataService.WorkflowTaskTranslation();
        MetadataService.SearchSettings shs = new MetadataService.SearchSettings();
        MetadataService.listMetadata_element lme = new MetadataService.listMetadata_element();
        MetadataService.AuraDefinitionBundle adb = new MetadataService.AuraDefinitionBundle();
        MetadataService.Queue q = new MetadataService.Queue();
        MetadataService.CleanDataService cds = new MetadataService.CleanDataService();
        MetadataService.HomePageLayout hpg = new MetadataService.HomePageLayout();
        MetadataService.WaveLens wl = new MetadataService.WaveLens();
        MetadataService.QuickActionSendEmailOptions qaseo = new MetadataService.QuickActionSendEmailOptions();
        MetadataService.FlowCategoryItems fci = new MetadataService.FlowCategoryItems();
        MetadataService.AppPreferences ap = new MetadataService.AppPreferences();
        MetadataService.SocialCustomerServiceSettings scss = new MetadataService.SocialCustomerServiceSettings();
        MetadataService.MilestoneType mt = new MetadataService.MilestoneType();
        MetadataService.WeightedSourceCategory wsc = new MetadataService.WeightedSourceCategory();
        MetadataService.ApprovalProcess aps = new MetadataService.ApprovalProcess();
        MetadataService.EmbeddedServiceQuickAction esqa = new MetadataService.EmbeddedServiceQuickAction();
        MetadataService.EntitlementProcess ep = new MetadataService.EntitlementProcess();
        MetadataService.FlowRecordDelete frd = new MetadataService.FlowRecordDelete();
        MetadataService.FlowScreenFieldTranslation fsft = new MetadataService.FlowScreenFieldTranslation();
        MetadataService.ApexTestSuite ats = new MetadataService.ApexTestSuite();
        MetadataService.GlobalQuickActionTranslation gqat = new MetadataService.GlobalQuickActionTranslation();
        MetadataService.Holiday h = new MetadataService.Holiday();
        MetadataService.Layout l = new MetadataService.Layout();
        MetadataService.LiveChatButton livechatbutton = new MetadataService.LiveChatButton();
		MetadataService.FlowDefinitionTranslation flowdefinitiontranslation = new MetadataService.FlowDefinitionTranslation();
        MetadataService.Territory2SettingsOpportunityFilter territory2settingsopportunityfilter = new MetadataService.Territory2SettingsOpportunityFilter();
        MetadataService.ActivitiesSettings activitiessettings = new MetadataService.ActivitiesSettings();
        MetadataService.FlowWaitEvent flowwaitevent = new MetadataService.FlowWaitEvent();
        MetadataService.ApexComponent apexcomponent = new MetadataService.ApexComponent();
        MetadataService.StrategyNode strategynode = new MetadataService.StrategyNode();
        MetadataService.AutoResponseRule autoresponserule = new MetadataService.AutoResponseRule();
        MetadataService.NamedCredential namedcredential = new MetadataService.NamedCredential();
        MetadataService.QuickAction quickaction = new MetadataService.QuickAction();
        MetadataService.SharingCriteriaRule sharingcriteriarule = new MetadataService.SharingCriteriaRule();
        MetadataService.FlowAssignment flowassignment = new MetadataService.FlowAssignment();
        MetadataService.MatchingRules matchingrules = new MetadataService.MatchingRules();
        MetadataService.Index index = new MetadataService.Index();
        MetadataService.Attachment attachment = new MetadataService.Attachment();
        MetadataService.PathAssistantStep pathassistantstep = new MetadataService.PathAssistantStep();
        MetadataService.ChannelLayoutItem channellayoutitem = new MetadataService.ChannelLayoutItem();
        MetadataService.ListView listview = new MetadataService.ListView();
        MetadataService.CustomApplicationTranslation customapplicationtranslation = new MetadataService.CustomApplicationTranslation();
        MetadataService.KnowledgeCaseSettings knowledgecasesettings = new MetadataService.KnowledgeCaseSettings();
        MetadataService.FiscalYearSettings fiscalyearsettings = new MetadataService.FiscalYearSettings();
        MetadataService.Approver approver = new MetadataService.Approver();
        MetadataService.ObjectNameCaseValue objectnamecasevalue = new MetadataService.ObjectNameCaseValue();
        MetadataService.SiteWebAddress sitewebaddress = new MetadataService.SiteWebAddress();
        MetadataService.FlowInputValidationRule flowinputvalidationrule = new MetadataService.FlowInputValidationRule();
        MetadataService.CompanySettings companysettings = new MetadataService.CompanySettings();
        MetadataService.FlowScreenField flowscreenfield = new MetadataService.FlowScreenField();
        MetadataService.LookupFilterTranslation lookupfiltertranslation = new MetadataService.LookupFilterTranslation();
        MetadataService.LetterheadLine letterheadline = new MetadataService.LetterheadLine();
        MetadataService.ValidationRule validationrule = new MetadataService.ValidationRule();
        MetadataService.ChatterAnswersReputationLevel chatteranswersreputationlevel = new MetadataService.ChatterAnswersReputationLevel();
        MetadataService.Role role = new MetadataService.Role();
        MetadataService.WaveXmdDate wavexmddate = new MetadataService.WaveXmdDate();
        MetadataService.PublicGroups publicgroups = new MetadataService.PublicGroups();
        MetadataService.FeedLayoutFilter feedlayoutfilter = new MetadataService.FeedLayoutFilter();
        MetadataService.State state = new MetadataService.State();
        MetadataService.SupervisorAgentConfigSkills supervisoragentconfigskills = new MetadataService.SupervisorAgentConfigSkills();
        MetadataService.describeValueTypeResponse_element describevaluetyperesponse_element = new MetadataService.describeValueTypeResponse_element();
        MetadataService.ActionOverride actionoverride = new MetadataService.ActionOverride();
        MetadataService.Translations translations = new MetadataService.Translations();
		MetadataService.WebToCaseSettings webtocasesettings = new MetadataService.WebToCaseSettings();
        MetadataService.CustomMetadata custommetadata = new MetadataService.CustomMetadata();
        MetadataService.FileProperties fileproperties = new MetadataService.FileProperties();
        MetadataService.OrderSettings ordersettings = new MetadataService.OrderSettings();
        MetadataService.ReportTimeFrameFilter reporttimeframefilter = new MetadataService.ReportTimeFrameFilter();
        MetadataService.ContentAssetLink contentassetlink = new MetadataService.ContentAssetLink();
        MetadataService.StandardValue standardvalue = new MetadataService.StandardValue();
        MetadataService.NavigationSubMenu navigationsubmenu = new MetadataService.NavigationSubMenu();
        MetadataService.WorkflowTask workflowtask = new MetadataService.WorkflowTask();
        MetadataService.GlobalValueSetTranslation globalvaluesettranslation = new MetadataService.GlobalValueSetTranslation();
        MetadataService.deployResponse_element deployresponse_element = new MetadataService.deployResponse_element();
        MetadataService.FeedItemSettings feeditemsettings = new MetadataService.FeedItemSettings();
        MetadataService.AgentConfigAssignments agentconfigassignments = new MetadataService.AgentConfigAssignments();
        MetadataService.ApprovalStepApprover approvalstepapprover = new MetadataService.ApprovalStepApprover();
        MetadataService.ApexTrigger apextrigger = new MetadataService.ApexTrigger();
        MetadataService.CustomConsoleComponents customconsolecomponents = new MetadataService.CustomConsoleComponents();
        MetadataService.TouchMobileSettings touchmobilesettings = new MetadataService.TouchMobileSettings();
        MetadataService.AppMenu appmenu = new MetadataService.AppMenu();
        MetadataService.DebuggingInfo_element debugginginfo_element = new MetadataService.DebuggingInfo_element();
        MetadataService.Report report = new MetadataService.Report();
        MetadataService.KnowledgeSettings knowledgesettings = new MetadataService.KnowledgeSettings();
        MetadataService.StaticResource staticresource = new MetadataService.StaticResource();
        MetadataService.ReportTypeColumn reporttypecolumn = new MetadataService.ReportTypeColumn();
        MetadataService.ApprovalStep approvalstep = new MetadataService.ApprovalStep();
        MetadataService.RecordTypeTranslation recordtypetranslation = new MetadataService.RecordTypeTranslation();
        MetadataService.FlowInputFieldAssignment flowinputfieldassignment = new MetadataService.FlowInputFieldAssignment();
        MetadataService.WorkflowActionReference workflowactionreference = new MetadataService.WorkflowActionReference();
        MetadataService.FilterItem filteritem = new MetadataService.FilterItem();
        MetadataService.OpportunityListFieldsUnselectedSettings opportunitylistfieldsunselectedsettings = new MetadataService.OpportunityListFieldsUnselectedSettings();
        MetadataService.ReportChartComponentLayoutItem reportchartcomponentlayoutitem = new MetadataService.ReportChartComponentLayoutItem();
        MetadataService.StandardValueSetTranslation standardvaluesettranslation = new MetadataService.StandardValueSetTranslation();
        MetadataService.BrandingSet brandingset = new MetadataService.BrandingSet();
        MetadataService.ChatterAnswersSettings chatteranswerssettings = new MetadataService.ChatterAnswersSettings();
        MetadataService.ConnectedAppCanvasConfig connectedappcanvasconfig = new MetadataService.ConnectedAppCanvasConfig();
        MetadataService.QuotasSettings quotassettings = new MetadataService.QuotasSettings();
        MetadataService.OrgPreferenceSettings orgpreferencesettings = new MetadataService.OrgPreferenceSettings();
        MetadataService.Community community = new MetadataService.Community();
        MetadataService.BusinessProcess businessprocess = new MetadataService.BusinessProcess();
        MetadataService.EmailToCaseRoutingAddress emailtocaseroutingaddress = new MetadataService.EmailToCaseRoutingAddress();
        MetadataService.DataCategory datacategory = new MetadataService.DataCategory();
        MetadataService.PermissionSetTabSetting permissionsettabsetting = new MetadataService.PermissionSetTabSetting();
        MetadataService.ReportHistoricalSelector reporthistoricalselector = new MetadataService.ReportHistoricalSelector();
        MetadataService.Users users = new MetadataService.Users();
        MetadataService.PermissionSetUserPermission permissionsetuserpermission = new MetadataService.PermissionSetUserPermission();
        MetadataService.SharingRules sharingrules = new MetadataService.SharingRules();
        MetadataService.SharingRecalculation sharingrecalculation = new MetadataService.SharingRecalculation();
        MetadataService.CustomLabels customlabels = new MetadataService.CustomLabels();
        MetadataService.FieldSetTranslation fieldsettranslation = new MetadataService.FieldSetTranslation();
        MetadataService.RelatedContentItem relatedcontentitem = new MetadataService.RelatedContentItem();
        MetadataService.LiveAgentConfig liveagentconfig = new MetadataService.LiveAgentConfig();
        MetadataService.RunTestsResult runtestsresult = new MetadataService.RunTestsResult();
        MetadataService.CommunityThemeDefinition communitythemedefinition = new MetadataService.CommunityThemeDefinition();
        MetadataService.LicenseDefinition licensedefinition = new MetadataService.LicenseDefinition();
        MetadataService.FlowOutputFieldAssignment flowoutputfieldassignment = new MetadataService.FlowOutputFieldAssignment();
        MetadataService.FlowApexPluginCallOutputParameter flowapexplugincalloutputparameter = new MetadataService.FlowApexPluginCallOutputParameter();
        MetadataService.DashboardGridLayout dashboardgridlayout = new MetadataService.DashboardGridLayout();
        MetadataService.AdjustmentsSettings adjustmentssettings = new MetadataService.AdjustmentsSettings();
        MetadataService.SummaryLayoutItem summarylayoutitem = new MetadataService.SummaryLayoutItem();
        MetadataService.QuickActionLayoutItem quickactionlayoutitem = new MetadataService.QuickActionLayoutItem();
        MetadataService.DeployDetails deploydetails = new MetadataService.DeployDetails();
        MetadataService.FlexiPage flexipage = new MetadataService.FlexiPage();
        MetadataService.EntitlementProcessMilestoneTimeTrigger entitlementprocessmilestonetimetrigger = new MetadataService.EntitlementProcessMilestoneTimeTrigger();
        MetadataService.NavigationLinkSet navigationlinkset = new MetadataService.NavigationLinkSet();
        MetadataService.CommunityTemplateBundleInfo communitytemplatebundleinfo = new MetadataService.CommunityTemplateBundleInfo();
        MetadataService.UiFormulaCriterion uiformulacriterion = new MetadataService.UiFormulaCriterion();
        MetadataService.PlatformActionList platformactionlist = new MetadataService.PlatformActionList();
        MetadataService.CallCenter callcenter = new MetadataService.CallCenter();
        MetadataService.LightningComponentBundle lightningcomponentbundle = new MetadataService.LightningComponentBundle();
        MetadataService.MarketingActionSettings marketingactionsettings = new MetadataService.MarketingActionSettings();
        MetadataService.AccountSharingRuleSettings accountsharingrulesettings = new MetadataService.AccountSharingRuleSettings();
        MetadataService.AgentConfigButtons agentconfigbuttons = new MetadataService.AgentConfigButtons();
        MetadataService.CustomShortcut customshortcut = new MetadataService.CustomShortcut();
        MetadataService.ArticleTypeChannelDisplay articletypechanneldisplay = new MetadataService.ArticleTypeChannelDisplay();
        MetadataService.FlowWaitEventInputParameter flowwaiteventinputparameter = new MetadataService.FlowWaitEventInputParameter();
        MetadataService.WorkflowOutboundMessage workflowoutboundmessage = new MetadataService.WorkflowOutboundMessage();
        MetadataService.WaveDataset wavedataset = new MetadataService.WaveDataset();
        MetadataService.CorsWhitelistOrigin corswhitelistorigin = new MetadataService.CorsWhitelistOrigin();
        MetadataService.AnalyticSnapshot analyticsnapshot = new MetadataService.AnalyticSnapshot();
        MetadataService.ReputationPointsRules reputationpointsrules = new MetadataService.ReputationPointsRules();
        MetadataService.ProfileCustomPermissions profilecustompermissions = new MetadataService.ProfileCustomPermissions();
        MetadataService.FlowScreenFieldInputParameter flowscreenfieldinputparameter = new MetadataService.FlowScreenFieldInputParameter();
        MetadataService.deployRecentValidationResponse_element deployrecentvalidationresponse_element = new MetadataService.deployRecentValidationResponse_element();
        MetadataService.Orchestration orchestration = new MetadataService.Orchestration();
        MetadataService.ScheduledRecommendation scheduledrecommendation = new MetadataService.ScheduledRecommendation();
        MetadataService.IpRange iprange = new MetadataService.IpRange();
        MetadataService.deployRecentValidation_element deployrecentvalidation_element = new MetadataService.deployRecentValidation_element();
        MetadataService.FlowScreenRule flowscreenrule = new MetadataService.FlowScreenRule();
        MetadataService.ManagedTopics managedtopics = new MetadataService.ManagedTopics();
        MetadataService.FeedFilterCriterion feedfiltercriterion = new MetadataService.FeedFilterCriterion();
        MetadataService.ReportBlockInfo reportblockinfo = new MetadataService.ReportBlockInfo();
        MetadataService.Profile profile = new MetadataService.Profile();
        MetadataService.KnowledgeLanguage knowledgelanguage = new MetadataService.KnowledgeLanguage();
        MetadataService.DeployOptions deployoptions = new MetadataService.DeployOptions();
        MetadataService.InsightType insighttype = new MetadataService.InsightType();
        MetadataService.FieldSet fieldset = new MetadataService.FieldSet();
        MetadataService.ProfileLoginHours profileloginhours = new MetadataService.ProfileLoginHours();
        MetadataService.FlowChoiceUserInput flowchoiceuserinput = new MetadataService.FlowChoiceUserInput();
        MetadataService.HomePageComponent homepagecomponent = new MetadataService.HomePageComponent();
        MetadataService.PermissionSetFieldPermissions permissionsetfieldpermissions = new MetadataService.PermissionSetFieldPermissions();
        MetadataService.RetrieveRequest retrieverequest = new MetadataService.RetrieveRequest();
        MetadataService.ObjectRelationship objectrelationship = new MetadataService.ObjectRelationship();
        MetadataService.ReportLayoutSection reportlayoutsection = new MetadataService.ReportLayoutSection();
        MetadataService.CompactLayout compactlayout = new MetadataService.CompactLayout();
        MetadataService.VisualizationType visualizationtype = new MetadataService.VisualizationType();
        MetadataService.SharingBaseRule sharingbaserule = new MetadataService.SharingBaseRule();
        MetadataService.AuthProvider authprovider = new MetadataService.AuthProvider();
        MetadataService.FlowDynamicChoiceSet flowdynamicchoiceset = new MetadataService.FlowDynamicChoiceSet();
        MetadataService.RelatedContent relatedcontent = new MetadataService.RelatedContent();
        MetadataService.WebLink weblink = new MetadataService.WebLink();
        MetadataService.Flow flow = new MetadataService.Flow();
        MetadataService.CustomMetadataValue custommetadatavalue = new MetadataService.CustomMetadataValue();
        MetadataService.QueueMembers queuemembers = new MetadataService.QueueMembers();
        MetadataService.ArticleTypeTemplate articletypetemplate = new MetadataService.ArticleTypeTemplate();
        MetadataService.WaveDataflow wavedataflow = new MetadataService.WaveDataflow();
        MetadataService.StandardValueSet standardvalueset = new MetadataService.StandardValueSet();
        MetadataService.FileUploadAndDownloadSecuritySettings fileuploadanddownloadsecuritysettings = new MetadataService.FileUploadAndDownloadSecuritySettings();
        MetadataService.LetterheadHeaderFooter letterheadheaderfooter = new MetadataService.LetterheadHeaderFooter();
        MetadataService.PicklistValueTranslation picklistvaluetranslation = new MetadataService.PicklistValueTranslation();
        MetadataService.CountriesAndStates countriesandstates = new MetadataService.CountriesAndStates();
        MetadataService.PathAssistant pathassistant = new MetadataService.PathAssistant();
        MetadataService.AsyncResult asyncresult = new MetadataService.AsyncResult();
        MetadataService.XOrgHub xorghub = new MetadataService.XOrgHub();
        MetadataService.LightningBoltItems lightningboltitems = new MetadataService.LightningBoltItems();
        MetadataService.CustomLabel customlabel = new MetadataService.CustomLabel();
        MetadataService.ChatterExtension chatterextension = new MetadataService.ChatterExtension();
        MetadataService.NameSettings namesettings = new MetadataService.NameSettings();
        MetadataService.checkRetrieveStatusResponse_element checkretrievestatusresponse_element = new MetadataService.checkRetrieveStatusResponse_element();
        MetadataService.Territory2Settings territory2settings = new MetadataService.Territory2Settings();
        MetadataService.PlatformCachePartition platformcachepartition = new MetadataService.PlatformCachePartition();
        MetadataService.ConnectedAppIpRange connectedappiprange = new MetadataService.ConnectedAppIpRange();
        MetadataService.ExternalDataSource externaldatasource = new MetadataService.ExternalDataSource();
        MetadataService.retrieveResponse_element retrieveresponse_element = new MetadataService.retrieveResponse_element();
        MetadataService.ComponentInstance componentinstance = new MetadataService.ComponentInstance();
        MetadataService.LayoutSectionTranslation layoutsectiontranslation = new MetadataService.LayoutSectionTranslation();
        MetadataService.FlowActionCallOutputParameter flowactioncalloutputparameter = new MetadataService.FlowActionCallOutputParameter();
        MetadataService.MarketingResourceType marketingresourcetype = new MetadataService.MarketingResourceType();
        MetadataService.ApprovalSubmitter approvalsubmitter = new MetadataService.ApprovalSubmitter();
        MetadataService.FlowRecordCreate flowrecordcreate = new MetadataService.FlowRecordCreate();
        MetadataService.ChannelLayout channellayout = new MetadataService.ChannelLayout();
        MetadataService.PermissionSetRecordTypeVisibility permissionsetrecordtypevisibility = new MetadataService.PermissionSetRecordTypeVisibility();
        MetadataService.WaveXmdOrganization wavexmdorganization = new MetadataService.WaveXmdOrganization();
        MetadataService.cancelDeploy_element canceldeploy_element = new MetadataService.cancelDeploy_element();
        MetadataService.ReportFolder reportfolder = new MetadataService.ReportFolder();
        MetadataService.DashboardComponentSection dashboardcomponentsection = new MetadataService.DashboardComponentSection();
        MetadataService.EscalationRule escalationrule = new MetadataService.EscalationRule();
        MetadataService.RunTestFailure runtestfailure = new MetadataService.RunTestFailure();
        MetadataService.SubtabComponents subtabcomponents = new MetadataService.SubtabComponents();
        MetadataService.ConnectedAppMobileDetailConfig connectedappmobiledetailconfig = new MetadataService.ConnectedAppMobileDetailConfig();
        MetadataService.PermissionSet permissionset = new MetadataService.PermissionSet();
        MetadataService.WorkflowRule workflowrule = new MetadataService.WorkflowRule();
        MetadataService.FlowRule flowrule = new MetadataService.FlowRule();
        MetadataService.NetworkPageOverride networkpageoverride = new MetadataService.NetworkPageOverride();
        MetadataService.ModerationRule moderationrule = new MetadataService.ModerationRule();
        MetadataService.ValueTranslation valuetranslation = new MetadataService.ValueTranslation();
        MetadataService.KnowledgeWorkOrderField knowledgeworkorderfield = new MetadataService.KnowledgeWorkOrderField();
        MetadataService.PermissionSetApexClassAccess permissionsetapexclassaccess = new MetadataService.PermissionSetApexClassAccess();
        
        MetadataService.CampaignInfluenceModel campaigninfluencemodel = new MetadataService.CampaignInfluenceModel();
        MetadataService.OrchestrationContextEvent orchestrationcontextevent = new MetadataService.OrchestrationContextEvent();
        MetadataService.FlowScreenTranslation flowscreentranslation = new MetadataService.FlowScreenTranslation();
        MetadataService.CommunityRoles communityroles = new MetadataService.CommunityRoles();
        MetadataService.RoleAndSubordinatesInternal roleandsubordinatesinternal = new MetadataService.RoleAndSubordinatesInternal();
        MetadataService.CustomTab customtab = new MetadataService.CustomTab();
        MetadataService.LiveChatAgentConfig livechatagentconfig = new MetadataService.LiveChatAgentConfig();
        MetadataService.FieldMapping fieldmapping = new MetadataService.FieldMapping();
        MetadataService.EmailToCaseSettings emailtocasesettings = new MetadataService.EmailToCaseSettings();
        MetadataService.FlowSubflowOutputAssignment flowsubflowoutputassignment = new MetadataService.FlowSubflowOutputAssignment();
        MetadataService.SecuritySettings securitysettings = new MetadataService.SecuritySettings();
        MetadataService.ReportChart reportchart = new MetadataService.ReportChart();
        MetadataService.AppMenuItem appmenuitem = new MetadataService.AppMenuItem();
        MetadataService.TabLimitConfig tablimitconfig = new MetadataService.TabLimitConfig();
        MetadataService.ObjectMapping objectmapping = new MetadataService.ObjectMapping();
        MetadataService.ModeratedEntityField moderatedentityfield = new MetadataService.ModeratedEntityField();
        MetadataService.RecordType recordtype = new MetadataService.RecordType();
        MetadataService.EventSubscription eventsubscription = new MetadataService.EventSubscription();
        MetadataService.FieldOverride fieldoverride = new MetadataService.FieldOverride();
        MetadataService.ProfileTabVisibility profiletabvisibility = new MetadataService.ProfileTabVisibility();
        MetadataService.ReportCrossFilter reportcrossfilter = new MetadataService.ReportCrossFilter();
        MetadataService.LookupFilter lookupfilter = new MetadataService.LookupFilter();
        MetadataService.UiPlugin uiplugin = new MetadataService.UiPlugin();
        MetadataService.AppBrand appbrand = new MetadataService.AppBrand();
        MetadataService.FlowLoop flowloop = new MetadataService.FlowLoop();
        MetadataService.FlowDefinition flowdefinition = new MetadataService.FlowDefinition();
        MetadataService.ReputationLevelDefinitions reputationleveldefinitions = new MetadataService.ReputationLevelDefinitions();
        MetadataService.CustomPageWebLink custompageweblink = new MetadataService.CustomPageWebLink();
        MetadataService.DashboardFlexTableComponentProperties dashboardflextablecomponentproperties = new MetadataService.DashboardFlexTableComponentProperties();
        MetadataService.ApprovalAction approvalaction = new MetadataService.ApprovalAction();
        MetadataService.IntegrationHubSettings integrationhubsettings = new MetadataService.IntegrationHubSettings();
        MetadataService.WaveTemplateBundle wavetemplatebundle = new MetadataService.WaveTemplateBundle();
        MetadataService.CommunityThemeSetting communitythemesetting = new MetadataService.CommunityThemeSetting();
        MetadataService.LayoutColumn layoutcolumn = new MetadataService.LayoutColumn();
        MetadataService.Error error = new MetadataService.Error();
        MetadataService.Territory2RuleItem territory2ruleitem = new MetadataService.Territory2RuleItem();
        MetadataService.FlowStep flowstep = new MetadataService.FlowStep();
        MetadataService.updateMetadata_element updatemetadata_element = new MetadataService.updateMetadata_element();
        MetadataService.OrchestrationContext orchestrationcontext = new MetadataService.OrchestrationContext();
        MetadataService.AccountSettings accountsettings = new MetadataService.AccountSettings();
        MetadataService.ContentAssetVersion contentassetversion = new MetadataService.ContentAssetVersion();
        MetadataService.CancelDeployResult canceldeployresult = new MetadataService.CancelDeployResult();
        MetadataService.AgentConfigUserAssignments agentconfiguserassignments = new MetadataService.AgentConfigUserAssignments();
        MetadataService.EventParameterMap eventparametermap = new MetadataService.EventParameterMap();
        MetadataService.TransactionSecurityAction transactionsecurityaction = new MetadataService.TransactionSecurityAction();
        MetadataService.KnowledgeWorkOrderLineItemField knowledgeworkorderlineitemfield = new MetadataService.KnowledgeWorkOrderLineItemField();
        MetadataService.DashboardFilterColumn dashboardfiltercolumn = new MetadataService.DashboardFilterColumn();
        MetadataService.CspTrustedSite csptrustedsite = new MetadataService.CspTrustedSite();
        MetadataService.FlowVariable flowvariable = new MetadataService.FlowVariable();
        MetadataService.FlowCategory flowcategory = new MetadataService.FlowCategory();
        MetadataService.SharingTerritoryRule sharingterritoryrule = new MetadataService.SharingTerritoryRule();
        MetadataService.WorkflowFlowActionParameter workflowflowactionparameter = new MetadataService.WorkflowFlowActionParameter();
        MetadataService.ScontrolTranslation scontroltranslation = new MetadataService.ScontrolTranslation();
        MetadataService.PlatformActionListItem platformactionlistitem = new MetadataService.PlatformActionListItem();
        MetadataService.CallOptions_element calloptions_element = new MetadataService.CallOptions_element();
        MetadataService.ApprovalEntryCriteria approvalentrycriteria = new MetadataService.ApprovalEntryCriteria();
        MetadataService.CallCenterItem callcenteritem = new MetadataService.CallCenterItem();
        MetadataService.Document document = new MetadataService.Document();
        MetadataService.LightningBolt lightningbolt = new MetadataService.LightningBolt();
        MetadataService.ProfileExternalDataSourceAccess profileexternaldatasourceaccess = new MetadataService.ProfileExternalDataSourceAccess();
        MetadataService.ValueTypeField valuetypefield = new MetadataService.ValueTypeField();
        MetadataService.FlowAssignmentItem flowassignmentitem = new MetadataService.FlowAssignmentItem();
        MetadataService.EmailFolder emailfolder = new MetadataService.EmailFolder();
        MetadataService.renameMetadata_element renamemetadata_element = new MetadataService.renameMetadata_element();
        MetadataService.DelegateGroup delegategroup = new MetadataService.DelegateGroup();
        MetadataService.PicklistValue picklistvalue = new MetadataService.PicklistValue();
        MetadataService.SkillProfileAssignments skillprofileassignments = new MetadataService.SkillProfileAssignments();
        MetadataService.EscalationAction escalationaction = new MetadataService.EscalationAction();
        MetadataService.CaseSubjectParticle casesubjectparticle = new MetadataService.CaseSubjectParticle();
        MetadataService.WaveXmdDimensionSalesforceAction wavexmddimensionsalesforceaction = new MetadataService.WaveXmdDimensionSalesforceAction();
        MetadataService.Workflow workflow = new MetadataService.Workflow();
        MetadataService.Roles roles = new MetadataService.Roles();
        MetadataService.CustomFieldTranslation customfieldtranslation = new MetadataService.CustomFieldTranslation();
        MetadataService.FileTypeDispositionAssignmentBean filetypedispositionassignmentbean = new MetadataService.FileTypeDispositionAssignmentBean();
        MetadataService.AppWorkspaceConfig appworkspaceconfig = new MetadataService.AppWorkspaceConfig();
        MetadataService.ScheduledRecommendationDetail scheduledrecommendationdetail = new MetadataService.ScheduledRecommendationDetail();
        MetadataService.UiFormulaRule uiformularule = new MetadataService.UiFormulaRule();
        MetadataService.VisualizationPlugin visualizationplugin = new MetadataService.VisualizationPlugin();
        MetadataService.DataPipeline datapipeline = new MetadataService.DataPipeline();
        MetadataService.QueueSobject queuesobject = new MetadataService.QueueSobject();
        MetadataService.ApexClass apexclass = new MetadataService.ApexClass();
        MetadataService.FieldMappingRow fieldmappingrow = new MetadataService.FieldMappingRow();
        MetadataService.EntitlementTemplate entitlementtemplate = new MetadataService.EntitlementTemplate();
        MetadataService.Group_x group_x = new MetadataService.Group_x();
        MetadataService.WaveXmdRecordDisplayLookup wavexmdrecorddisplaylookup = new MetadataService.WaveXmdRecordDisplayLookup();
        MetadataService.IntegrationHubSettingsType integrationhubsettingstype = new MetadataService.IntegrationHubSettingsType();
        MetadataService.KnowledgeLanguageSettings knowledgelanguagesettings = new MetadataService.KnowledgeLanguageSettings();
        MetadataService.KnowledgeCaseField knowledgecasefield = new MetadataService.KnowledgeCaseField();
        MetadataService.DebuggingHeader_element debuggingheader_element = new MetadataService.DebuggingHeader_element();
        MetadataService.ApprovalPageField approvalpagefield = new MetadataService.ApprovalPageField();
        MetadataService.PermissionSetApexPageAccess permissionsetapexpageaccess = new MetadataService.PermissionSetApexPageAccess();
        MetadataService.CustomExperience customexperience = new MetadataService.CustomExperience();
        MetadataService.ExternalServiceRegistration externalserviceregistration = new MetadataService.ExternalServiceRegistration();
        MetadataService.FlowChoice flowchoice = new MetadataService.FlowChoice();
        MetadataService.WaveXmdDimensionMember wavexmddimensionmember = new MetadataService.WaveXmdDimensionMember();
        MetadataService.ConnectedApp connectedapp = new MetadataService.ConnectedApp();
        MetadataService.describeMetadata_element describemetadata_element = new MetadataService.describeMetadata_element();
        MetadataService.LayoutItem layoutitem = new MetadataService.LayoutItem();
        MetadataService.Portal portal = new MetadataService.Portal();
        MetadataService.ContentAssetVersions contentassetversions = new MetadataService.ContentAssetVersions();
        MetadataService.RunTestSuccess runtestsuccess = new MetadataService.RunTestSuccess();
        MetadataService.PermissionSetExternalDataSourceAccess permissionsetexternaldatasourceaccess = new MetadataService.PermissionSetExternalDataSourceAccess();
        MetadataService.CustomDataType customdatatype = new MetadataService.CustomDataType();
        MetadataService.FlowConnector flowconnector = new MetadataService.FlowConnector();
        MetadataService.EventDelivery eventdelivery = new MetadataService.EventDelivery();
        MetadataService.LiveMessageSettings livemessagesettings = new MetadataService.LiveMessageSettings();
        MetadataService.ListMetadataQuery listmetadataquery = new MetadataService.ListMetadataQuery();
        MetadataService.LogInfo loginfo = new MetadataService.LogInfo();
        MetadataService.SharedTo sharedto = new MetadataService.SharedTo();
        MetadataService.PlatformCachePartitionType platformcachepartitiontype = new MetadataService.PlatformCachePartitionType();
        MetadataService.ReputationPointsRule reputationpointsrule = new MetadataService.ReputationPointsRule();
        MetadataService.FlowRecordLookup flowrecordlookup = new MetadataService.FlowRecordLookup();
        MetadataService.QuickActionLayoutColumn quickactionlayoutcolumn = new MetadataService.QuickActionLayoutColumn();
        MetadataService.ForecastingDisplayedFamilySettings forecastingdisplayedfamilysettings = new MetadataService.ForecastingDisplayedFamilySettings();
        MetadataService.ReputationBranding reputationbranding = new MetadataService.ReputationBranding();
        MetadataService.ReputationLevel reputationlevel = new MetadataService.ReputationLevel();
        MetadataService.ContentAssetRelationships contentassetrelationships = new MetadataService.ContentAssetRelationships();
        MetadataService.ProfileLayoutAssignment profilelayoutassignment = new MetadataService.ProfileLayoutAssignment();
        MetadataService.QuickActionTranslation quickactiontranslation = new MetadataService.QuickActionTranslation();
        MetadataService.ReportTypeTranslation reporttypetranslation = new MetadataService.ReportTypeTranslation();
        MetadataService.ActionLinkGroupTemplate actionlinkgrouptemplate = new MetadataService.ActionLinkGroupTemplate();
        MetadataService.ReportDataCategoryFilter reportdatacategoryfilter = new MetadataService.ReportDataCategoryFilter();
        MetadataService.ReportBucketFieldSourceValue reportbucketfieldsourcevalue = new MetadataService.ReportBucketFieldSourceValue();
        MetadataService.ValidationRuleTranslation validationruletranslation = new MetadataService.ValidationRuleTranslation();
        MetadataService.DocumentFolder documentfolder = new MetadataService.DocumentFolder();
        MetadataService.createMetadataResponse_element createmetadataresponse_element = new MetadataService.createMetadataResponse_element();
        MetadataService.Dashboard dashboard = new MetadataService.Dashboard();
        MetadataService.PersonListSettings personlistsettings = new MetadataService.PersonListSettings();
        MetadataService.KeyboardShortcuts keyboardshortcuts = new MetadataService.KeyboardShortcuts();
        MetadataService.ManagedTopic managedtopic = new MetadataService.ManagedTopic();
        MetadataService.SkillAssignments skillassignments = new MetadataService.SkillAssignments();
        MetadataService.WorkflowEmailRecipient workflowemailrecipient = new MetadataService.WorkflowEmailRecipient();
        MetadataService.CodeCoverageResult codecoverageresult = new MetadataService.CodeCoverageResult();
        MetadataService.RecordTypePicklistValue recordtypepicklistvalue = new MetadataService.RecordTypePicklistValue();
        MetadataService.FlowApexPluginCall flowapexplugincall = new MetadataService.FlowApexPluginCall();
        MetadataService.Container container = new MetadataService.Container();
        MetadataService.FeedLayout feedlayout = new MetadataService.FeedLayout();
        MetadataService.NetworkAccess networkaccess = new MetadataService.NetworkAccess();
        MetadataService.ProfileActionOverride profileactionoverride = new MetadataService.ProfileActionOverride();
        MetadataService.IdeasSettings ideassettings = new MetadataService.IdeasSettings();
        MetadataService.EmailServicesFunction emailservicesfunction = new MetadataService.EmailServicesFunction();
        MetadataService.CustomDataTypeTranslation customdatatypetranslation = new MetadataService.CustomDataTypeTranslation();
        MetadataService.readMetadata_element readmetadata_element = new MetadataService.readMetadata_element();
        MetadataService.PostTemplate posttemplate = new MetadataService.PostTemplate();
        MetadataService.ValueSet valueset = new MetadataService.ValueSet();
        MetadataService.IndexField indexfield = new MetadataService.IndexField();
        MetadataService.QuickActionList quickactionlist = new MetadataService.QuickActionList();
        MetadataService.FlexiPageRegion flexipageregion = new MetadataService.FlexiPageRegion();
        MetadataService.PrimaryTabComponents primarytabcomponents = new MetadataService.PrimaryTabComponents();
        MetadataService.Territory territory = new MetadataService.Territory();
        MetadataService.updateMetadataResponse_element updatemetadataresponse_element = new MetadataService.updateMetadataResponse_element();
        MetadataService.FolderShare foldershare = new MetadataService.FolderShare();
        MetadataService.QuickActionListItem quickactionlistitem = new MetadataService.QuickActionListItem();
        MetadataService.SiteDotCom sitedotcom = new MetadataService.SiteDotCom();
        MetadataService.MobileSettings mobilesettings = new MetadataService.MobileSettings();
        MetadataService.ObjectMappingField objectmappingfield = new MetadataService.ObjectMappingField();
        MetadataService.DescribeValueTypeResult describevaluetyperesult = new MetadataService.DescribeValueTypeResult();
        MetadataService.EntitlementSettings entitlementsettings = new MetadataService.EntitlementSettings();
        MetadataService.Territory2RuleAssociation territory2ruleassociation = new MetadataService.Territory2RuleAssociation();
        MetadataService.FlowChoiceTranslation flowchoicetranslation = new MetadataService.FlowChoiceTranslation();
        MetadataService.PermissionSetCustomPermissions permissionsetcustompermissions = new MetadataService.PermissionSetCustomPermissions();
        MetadataService.CustomApplicationComponent customapplicationcomponent = new MetadataService.CustomApplicationComponent();
        MetadataService.ComponentInstanceProperty componentinstanceproperty = new MetadataService.ComponentInstanceProperty();
        MetadataService.ChatterMobileSettings chattermobilesettings = new MetadataService.ChatterMobileSettings();
        MetadataService.WorkflowAlert workflowalert = new MetadataService.WorkflowAlert();
        MetadataService.KnowledgeCaseFieldsSettings knowledgecasefieldssettings = new MetadataService.KnowledgeCaseFieldsSettings();
        MetadataService.EmailTemplate emailtemplate = new MetadataService.EmailTemplate();
        MetadataService.FlowTextTemplate flowtexttemplate = new MetadataService.FlowTextTemplate();
        MetadataService.PushNotification pushnotification = new MetadataService.PushNotification();
        MetadataService.TransactionSecurityPolicy transactionsecuritypolicy = new MetadataService.TransactionSecurityPolicy();
        MetadataService.FlowScreen flowscreen = new MetadataService.FlowScreen();
        MetadataService.OpportunityListFieldsSelectedSettings opportunitylistfieldsselectedsettings = new MetadataService.OpportunityListFieldsSelectedSettings();
        MetadataService.Certificate certificate = new MetadataService.Certificate();
        MetadataService.WaveXmdDimensionCustomAction wavexmddimensioncustomaction = new MetadataService.WaveXmdDimensionCustomAction();
        MetadataService.AccessMapping accessmapping = new MetadataService.AccessMapping();
        MetadataService.AnalyticSnapshotMapping analyticsnapshotmapping = new MetadataService.AnalyticSnapshotMapping();
        MetadataService.DefaultShortcut defaultshortcut = new MetadataService.DefaultShortcut();
        MetadataService.WorkspaceMapping workspacemapping = new MetadataService.WorkspaceMapping();
        MetadataService.FlowScreenRuleAction flowscreenruleaction = new MetadataService.FlowScreenRuleAction();
        MetadataService.WorkflowSend workflowsend = new MetadataService.WorkflowSend();
        MetadataService.FlowRecordFilter flowrecordfilter = new MetadataService.FlowRecordFilter();
        MetadataService.deleteMetadata_element deletemetadata_element = new MetadataService.deleteMetadata_element();
        MetadataService.ForecastRangeSettings forecastrangesettings = new MetadataService.ForecastRangeSettings();
        MetadataService.FlowActionCall flowactioncall = new MetadataService.FlowActionCall();
        MetadataService.ListViewFilter listviewfilter = new MetadataService.ListViewFilter();
        MetadataService.DashboardTableColumn dashboardtablecolumn = new MetadataService.DashboardTableColumn();
        MetadataService.Territory2 territory2 = new MetadataService.Territory2();
        MetadataService.ListPlacement listplacement = new MetadataService.ListPlacement();
        MetadataService.PicklistEntry picklistentry = new MetadataService.PicklistEntry();
        MetadataService.ReportBucketField reportbucketfield = new MetadataService.ReportBucketField();
        MetadataService.FlexiPageTemplateInstance flexipagetemplateinstance = new MetadataService.FlexiPageTemplateInstance();
        MetadataService.KnowledgeCommunitiesSettings knowledgecommunitiessettings = new MetadataService.KnowledgeCommunitiesSettings();
        MetadataService.AppComponentList appcomponentlist = new MetadataService.AppComponentList();
        MetadataService.KnowledgeWorkOrderLineItemFieldsSettings knowledgeworkorderlineitemfieldssettings = new MetadataService.KnowledgeWorkOrderLineItemFieldsSettings();
        MetadataService.OpportunitySettings opportunitysettings = new MetadataService.OpportunitySettings();
        MetadataService.CodeCoverageWarning codecoveragewarning = new MetadataService.CodeCoverageWarning();
        MetadataService.CustomLabelTranslation customlabeltranslation = new MetadataService.CustomLabelTranslation();
        MetadataService.KnowledgeAnswerSettings knowledgeanswersettings = new MetadataService.KnowledgeAnswerSettings();
        MetadataService.Letterhead letterhead = new MetadataService.Letterhead();
        MetadataService.AddressSettings addresssettings = new MetadataService.AddressSettings();
        MetadataService.FlowApexPluginCallInputParameter flowapexplugincallinputparameter = new MetadataService.FlowApexPluginCallInputParameter();
        MetadataService.PathAssistantSettings pathassistantsettings = new MetadataService.PathAssistantSettings();
        MetadataService.DuplicateRuleMatchRule duplicaterulematchrule = new MetadataService.DuplicateRuleMatchRule();
        MetadataService.EventTypeParameter eventtypeparameter = new MetadataService.EventTypeParameter();
        MetadataService.QuoteSettings quotesettings = new MetadataService.QuoteSettings();
        MetadataService.CustomExperienceBranding customexperiencebranding = new MetadataService.CustomExperienceBranding();
        MetadataService.BusinessHoursEntry businesshoursentry = new MetadataService.BusinessHoursEntry();
        MetadataService.NetworkMemberGroup networkmembergroup = new MetadataService.NetworkMemberGroup();
        MetadataService.ApexPage apexpage = new MetadataService.ApexPage();
        MetadataService.CustomSite customsite = new MetadataService.CustomSite();
        MetadataService.Skill skill = new MetadataService.Skill();
        MetadataService.renameMetadataResponse_element renamemetadataresponse_element = new MetadataService.renameMetadataResponse_element();
        MetadataService.RelatedList relatedlist = new MetadataService.RelatedList();
        MetadataService.SynonymGroup synonymgroup = new MetadataService.SynonymGroup();
        MetadataService.FlowSubflow flowsubflow = new MetadataService.FlowSubflow();
        MetadataService.MatchingRule matchingrule = new MetadataService.MatchingRule();
        MetadataService.PasswordPolicies passwordpolicies = new MetadataService.PasswordPolicies();
        MetadataService.AnalyticsCloudComponentLayoutItem analyticscloudcomponentlayoutitem = new MetadataService.AnalyticsCloudComponentLayoutItem();
        MetadataService.ServiceCloudConsoleConfig servicecloudconsoleconfig = new MetadataService.ServiceCloudConsoleConfig();
        MetadataService.SFDCMobileSettings sfdcmobilesettings = new MetadataService.SFDCMobileSettings();
        MetadataService.SharingReason sharingreason = new MetadataService.SharingReason();
        MetadataService.FlowDecision flowdecision = new MetadataService.FlowDecision();
        MetadataService.CustomFeedFilter customfeedfilter = new MetadataService.CustomFeedFilter();
        MetadataService.ProfileRecordTypeVisibility profilerecordtypevisibility = new MetadataService.ProfileRecordTypeVisibility();
        MetadataService.DashboardMobileSettings dashboardmobilesettings = new MetadataService.DashboardMobileSettings();
        MetadataService.SiteRedirectMapping siteredirectmapping = new MetadataService.SiteRedirectMapping();
        MetadataService.AgentConfigProfileAssignments agentconfigprofileassignments = new MetadataService.AgentConfigProfileAssignments();
        MetadataService.ReadCustomSiteResult readcustomsiteresult = new MetadataService.ReadCustomSiteResult();
        MetadataService.readCustomSiteResponse_element readcustomsiteresponse_element = new MetadataService.readCustomSiteResponse_element();
        MetadataService.ReadListViewResult readlistviewresult = new MetadataService.ReadListViewResult();
        MetadataService.readListViewResponse_element readlistviewresponse_element = new MetadataService.readListViewResponse_element();
        MetadataService.ReadInstalledPackageResult readinstalledpackageresult = new MetadataService.ReadInstalledPackageResult();
        MetadataService.readInstalledPackageResponse_element readinstalledpackageresponse_element = new MetadataService.readInstalledPackageResponse_element();
        MetadataService.ReadCustomFieldResult readcustomfieldresult = new MetadataService.ReadCustomFieldResult();
        MetadataService.readCustomFieldResponse_element readcustomfieldresponse_element = new MetadataService.readCustomFieldResponse_element();
        MetadataService.ReadFieldSetResult readfieldsetresult = new MetadataService.ReadFieldSetResult();
        MetadataService.readFieldSetResponse_element readfieldsetresponse_element = new MetadataService.readFieldSetResponse_element();
        MetadataService.ReadPicklistValueResult readpicklistvalueresult = new MetadataService.ReadPicklistValueResult();
        MetadataService.readPicklistValueResponse_element readpicklistvalueresponse_element = new MetadataService.readPicklistValueResponse_element();
        MetadataService.ReadRecordTypeResult readrecordtyperesult = new MetadataService.ReadRecordTypeResult();
        MetadataService.readRecordTypeResponse_element readrecordtyperesponse_element = new MetadataService.readRecordTypeResponse_element();
        MetadataService.ReadResult readresult = new MetadataService.ReadResult();
        MetadataService.ReportBucketFieldValue reportbucketfieldvalue = new MetadataService.ReportBucketFieldValue();
        MetadataService.BrandingSetProperty brandingsetproperty = new MetadataService.BrandingSetProperty();
        MetadataService.ProfileApexPageAccess profileapexpageaccess = new MetadataService.ProfileApexPageAccess();
        MetadataService.Scontrol scontrol = new MetadataService.Scontrol();
        MetadataService.Network network = new MetadataService.Network();
        MetadataService.ActionLinkTemplate actionlinktemplate = new MetadataService.ActionLinkTemplate();
        MetadataService.EntitlementProcessMilestoneItem entitlementprocessmilestoneitem = new MetadataService.EntitlementProcessMilestoneItem();
        MetadataService.ReportFilter reportfilter = new MetadataService.ReportFilter();
        MetadataService.RetrieveResult retrieveresult = new MetadataService.RetrieveResult();
        MetadataService.KnowledgeWorkOrderFieldsSettings knowledgeworkorderfieldssettings = new MetadataService.KnowledgeWorkOrderFieldsSettings();
        MetadataService.Territory2Model territory2model = new MetadataService.Territory2Model();
        MetadataService.SearchSettingsByObject searchsettingsbyobject = new MetadataService.SearchSettingsByObject();
        MetadataService.CustomObject customobject = new MetadataService.CustomObject();
        MetadataService.FlowTranslation flowtranslation = new MetadataService.FlowTranslation();
        MetadataService.DuplicateRuleFilter duplicaterulefilter = new MetadataService.DuplicateRuleFilter();
        MetadataService.LayoutSection layoutsection = new MetadataService.LayoutSection();
        MetadataService.cancelDeployResponse_element canceldeployresponse_element = new MetadataService.cancelDeployResponse_element();
        MetadataService.FlowMetadataValue flowmetadatavalue = new MetadataService.FlowMetadataValue();
        MetadataService.WaveRecipe waverecipe = new MetadataService.WaveRecipe();
        MetadataService.ReportGrouping reportgrouping = new MetadataService.ReportGrouping();
        MetadataService.ProfileObjectPermissions profileobjectpermissions = new MetadataService.ProfileObjectPermissions();
        MetadataService.DeployMessage deploymessage = new MetadataService.DeployMessage();
        MetadataService.EmailServicesAddress emailservicesaddress = new MetadataService.EmailServicesAddress();
        MetadataService.PermissionSetObjectPermissions permissionsetobjectpermissions = new MetadataService.PermissionSetObjectPermissions();
		MetadataService.ProfileApexClassAccess profileapexclassaccess = new MetadataService.ProfileApexClassAccess();
        MetadataService.ProfileLoginIpRange profileloginiprange = new MetadataService.ProfileLoginIpRange();
        MetadataService.ProfileSessionSetting profilesessionsetting = new MetadataService.ProfileSessionSetting();
        MetadataService.DashboardComponentColumn dashboardcomponentcolumn = new MetadataService.DashboardComponentColumn();
        MetadataService.FlowWait flowwait = new MetadataService.FlowWait();
        MetadataService.FlowStage flowstage = new MetadataService.FlowStage();
        MetadataService.ChartSummary chartsummary = new MetadataService.ChartSummary();
        MetadataService.InstalledPackage installedpackage = new MetadataService.InstalledPackage();
        MetadataService.NavigationMenuItem navigationmenuitem = new MetadataService.NavigationMenuItem();
        MetadataService.checkRetrieveStatus_element checkretrievestatus_element = new MetadataService.checkRetrieveStatus_element();
        MetadataService.Country country = new MetadataService.Country();
        MetadataService.ObjectUsage objectusage = new MetadataService.ObjectUsage();
        MetadataService.Package_x package_x = new MetadataService.Package_x();
        MetadataService.SharingReasonTranslation sharingreasontranslation = new MetadataService.SharingReasonTranslation();
        MetadataService.CustomDataTypeComponentTranslation customdatatypecomponenttranslation = new MetadataService.CustomDataTypeComponentTranslation();
        MetadataService.CustomNotificationType customnotificationtype = new MetadataService.CustomNotificationType();
        MetadataService.FeedLayoutComponent feedlayoutcomponent = new MetadataService.FeedLayoutComponent();
        MetadataService.AssistantRecommendationType assistantrecommendationtype = new MetadataService.AssistantRecommendationType();
        MetadataService.FlowCondition flowcondition = new MetadataService.FlowCondition();
        MetadataService.CallCenterSection callcentersection = new MetadataService.CallCenterSection();
        MetadataService.RecommendationStrategy recommendationstrategy = new MetadataService.RecommendationStrategy();
        MetadataService.WaveDashboard wavedashboard = new MetadataService.WaveDashboard();
        MetadataService.CustomApplication customapplication = new MetadataService.CustomApplication();
        MetadataService.DescribeMetadataResult describemetadataresult = new MetadataService.DescribeMetadataResult();
        MetadataService.LeadConvertSettings leadconvertsettings = new MetadataService.LeadConvertSettings();
        MetadataService.OpportunityListFieldsLabelMapping opportunitylistfieldslabelmapping = new MetadataService.OpportunityListFieldsLabelMapping();
        MetadataService.ReportType reporttype = new MetadataService.ReportType();
        MetadataService.deleteMetadataResponse_element deletemetadataresponse_element = new MetadataService.deleteMetadataResponse_element();
        MetadataService.CodeLocation codelocation = new MetadataService.CodeLocation();
        MetadataService.Keyword keyword = new MetadataService.Keyword();
        MetadataService.PermissionSetApplicationVisibility permissionsetapplicationvisibility = new MetadataService.PermissionSetApplicationVisibility();
        MetadataService.AppActionOverride appactionoverride = new MetadataService.AppActionOverride();
        MetadataService.RoleAndSubordinates roleandsubordinates = new MetadataService.RoleAndSubordinates();
        MetadataService.StandardFieldTranslation standardfieldtranslation = new MetadataService.StandardFieldTranslation();
        MetadataService.EmbeddedServiceBranding embeddedservicebranding = new MetadataService.EmbeddedServiceBranding();
        MetadataService.ProfilePasswordPolicy profilepasswordpolicy = new MetadataService.ProfilePasswordPolicy();
        MetadataService.RecommendationAudienceDetail recommendationaudiencedetail = new MetadataService.RecommendationAudienceDetail();
        MetadataService.RoleOrTerritory roleorterritory = new MetadataService.RoleOrTerritory();
        MetadataService.FlowSubflowInputAssignment flowsubflowinputassignment = new MetadataService.FlowSubflowInputAssignment();
        MetadataService.LiveChatButtonSkills livechatbuttonskills = new MetadataService.LiveChatButtonSkills();
        MetadataService.ConnectedAppOauthConfig connectedappoauthconfig = new MetadataService.ConnectedAppOauthConfig();
        MetadataService.ObjectSearchSetting objectsearchsetting = new MetadataService.ObjectSearchSetting();
        MetadataService.VisualizationResource visualizationresource = new MetadataService.VisualizationResource();
        MetadataService.FieldServiceSettings fieldservicesettings = new MetadataService.FieldServiceSettings();
        MetadataService.NextAutomatedApprover nextautomatedapprover = new MetadataService.NextAutomatedApprover();
        MetadataService.Territory2Rule territory2rule = new MetadataService.Territory2Rule();
        MetadataService.RetrieveMessage retrievemessage = new MetadataService.RetrieveMessage();
        MetadataService.ForecastingCategoryMapping forecastingcategorymapping = new MetadataService.ForecastingCategoryMapping();
        MetadataService.EclairMap eclairmap = new MetadataService.EclairMap();
        MetadataService.HistoryRetentionPolicy historyretentionpolicy = new MetadataService.HistoryRetentionPolicy();
        MetadataService.FlowFormula flowformula = new MetadataService.FlowFormula();
        MetadataService.Picklist picklist = new MetadataService.Picklist();
        MetadataService.deploy_element deploy_element = new MetadataService.deploy_element();
        MetadataService.ReportTypeSectionTranslation reporttypesectiontranslation = new MetadataService.ReportTypeSectionTranslation();
        MetadataService.PersonalJourneySettings personaljourneysettings = new MetadataService.PersonalJourneySettings();
        MetadataService.AppProfileActionOverride appprofileactionoverride = new MetadataService.AppProfileActionOverride();
        MetadataService.CustomPermission custompermission = new MetadataService.CustomPermission();
        MetadataService.DuplicateRule duplicaterule = new MetadataService.DuplicateRule();
        MetadataService.FlowScreenFieldOutputParameter flowscreenfieldoutputparameter = new MetadataService.FlowScreenFieldOutputParameter();
        MetadataService.AgentConfigSkills agentconfigskills = new MetadataService.AgentConfigSkills();
        MetadataService.DeployResult deployresult = new MetadataService.DeployResult();
        MetadataService.IdeaReputationLevel ideareputationlevel = new MetadataService.IdeaReputationLevel();
        MetadataService.EmbeddedServiceConfig embeddedserviceconfig = new MetadataService.EmbeddedServiceConfig();
        MetadataService.WorkflowTimeTrigger workflowtimetrigger = new MetadataService.WorkflowTimeTrigger();
        MetadataService.AutoResponseRules autoresponserules = new MetadataService.AutoResponseRules();
        MetadataService.LayoutTranslation layouttranslation = new MetadataService.LayoutTranslation();
        MetadataService.DashboardFolder dashboardfolder = new MetadataService.DashboardFolder();
        MetadataService.DuplicateRuleFilterItem duplicaterulefilteritem = new MetadataService.DuplicateRuleFilterItem();
        MetadataService.ReportAggregateReference reportaggregatereference = new MetadataService.ReportAggregateReference();
        MetadataService.CommunityTemplateDefinition communitytemplatedefinition = new MetadataService.CommunityTemplateDefinition();
        MetadataService.DashboardFilterOption dashboardfilteroption = new MetadataService.DashboardFilterOption();
        MetadataService.FlowConstant flowconstant = new MetadataService.FlowConstant();
        MetadataService.ConnectedAppSamlConfig connectedappsamlconfig = new MetadataService.ConnectedAppSamlConfig();
        MetadataService.LiveChatSensitiveDataRule livechatsensitivedatarule = new MetadataService.LiveChatSensitiveDataRule();
        MetadataService.ApprovalStepRejectBehavior approvalsteprejectbehavior = new MetadataService.ApprovalStepRejectBehavior();
        MetadataService.XOrgHubSharedObject xorghubsharedobject = new MetadataService.XOrgHubSharedObject();
        MetadataService.createMetadata_element createmetadata_element = new MetadataService.createMetadata_element();
        MetadataService.ContentAsset contentasset = new MetadataService.ContentAsset();
        MetadataService.CustomPageWebLinkTranslation custompageweblinktranslation = new MetadataService.CustomPageWebLinkTranslation();
        MetadataService.describeMetadataResponse_element describemetadataresponse_element = new MetadataService.describeMetadataResponse_element();
        MetadataService.CustomPermissionDependencyRequired custompermissiondependencyrequired = new MetadataService.CustomPermissionDependencyRequired();
        MetadataService.ProfileFieldLevelSecurity profilefieldlevelsecurity = new MetadataService.ProfileFieldLevelSecurity();
        MetadataService.checkDeployStatus_element checkdeploystatus_element = new MetadataService.checkDeployStatus_element();
        MetadataService.RecommendationDefinitionDetail recommendationdefinitiondetail = new MetadataService.RecommendationDefinitionDetail();
        MetadataService.FlowActionCallInputParameter flowactioncallinputparameter = new MetadataService.FlowActionCallInputParameter();
        MetadataService.SkillUserAssignments skilluserassignments = new MetadataService.SkillUserAssignments();
        MetadataService.checkDeployStatusResponse_element checkdeploystatusresponse_element = new MetadataService.checkDeployStatusResponse_element();
        MetadataService.FlowRecordUpdate flowrecordupdate = new MetadataService.FlowRecordUpdate();
        MetadataService.FlowInputValidationRuleTranslation flowinputvalidationruletranslation = new MetadataService.FlowInputValidationRuleTranslation();
        MetadataService.CleanRule cleanrule = new MetadataService.CleanRule();
        MetadataService.DashboardComponent dashboardcomponent = new MetadataService.DashboardComponent();
        MetadataService.ReportColorRange reportcolorrange = new MetadataService.ReportColorRange();
        MetadataService.OrganizationSettingsDetail organizationsettingsdetail = new MetadataService.OrganizationSettingsDetail();
        MetadataService.EclairGeoData eclairgeodata = new MetadataService.EclairGeoData();
        MetadataService.SummaryLayout summarylayout = new MetadataService.SummaryLayout();
        MetadataService.GlobalValueSet globalvalueset = new MetadataService.GlobalValueSet();
        MetadataService.QuickActionLayout quickactionlayout = new MetadataService.QuickActionLayout();
        MetadataService.Territory2Type territory2type = new MetadataService.Territory2Type();
        MetadataService.listMetadataResponse_element listmetadataresponse_element = new MetadataService.listMetadataResponse_element();
        MetadataService.CommunityCustomThemeLayoutType communitycustomthemelayouttype = new MetadataService.CommunityCustomThemeLayoutType();
        MetadataService.CommunityTemplatePageSetting communitytemplatepagesetting = new MetadataService.CommunityTemplatePageSetting();
        MetadataService.SamlSsoConfig samlssoconfig = new MetadataService.SamlSsoConfig();
        MetadataService.describeValueType_element describevaluetype_element = new MetadataService.describeValueType_element();
        MetadataService.ReputationLevels reputationlevels = new MetadataService.ReputationLevels();
        MetadataService.WaveXmdMeasure wavexmdmeasure = new MetadataService.WaveXmdMeasure();
        MetadataService.SidebarComponent sidebarcomponent = new MetadataService.SidebarComponent();
        MetadataService.PermissionSetGroup permissionsetgroup = new MetadataService.PermissionSetGroup();
        MetadataService.TransactionSecurityNotification transactionsecuritynotification = new MetadataService.TransactionSecurityNotification();
        MetadataService.ReportColumn reportcolumn = new MetadataService.ReportColumn();
        MetadataService.BusinessHoursSettings businesshourssettings = new MetadataService.BusinessHoursSettings();
        MetadataService.TopicsForObjects topicsforobjects = new MetadataService.TopicsForObjects();
        MetadataService.FlowChoiceUserInputTranslation flowchoiceuserinputtranslation = new MetadataService.FlowChoiceUserInputTranslation();
        MetadataService.FieldSetItem fieldsetitem = new MetadataService.FieldSetItem();
        MetadataService.ProfileUserPermission profileuserpermission = new MetadataService.ProfileUserPermission();
        MetadataService.FindSimilarOppFilter findsimilaroppfilter = new MetadataService.FindSimilarOppFilter();
        MetadataService.ReportAggregate reportaggregate = new MetadataService.ReportAggregate();
        MetadataService.ContractSettings contractsettings = new MetadataService.ContractSettings();
        MetadataService.EscalationRules escalationrules = new MetadataService.EscalationRules();
        MetadataService.NetworkTabSet networktabset = new MetadataService.NetworkTabSet();
        MetadataService.EmbeddedServiceLiveAgent embeddedserviceliveagent = new MetadataService.EmbeddedServiceLiveAgent();
        MetadataService.CustomField customfield = new MetadataService.CustomField();
        MetadataService.KeywordList keywordlist = new MetadataService.KeywordList();
        MetadataService.MatchingRuleItem matchingruleitem = new MetadataService.MatchingRuleItem();
        MetadataService.RuleEntry ruleentry = new MetadataService.RuleEntry();
        MetadataService.DashboardComponentSortInfo dashboardcomponentsortinfo = new MetadataService.DashboardComponentSortInfo();
        MetadataService.CustomObjectTranslation customobjecttranslation = new MetadataService.CustomObjectTranslation();
        MetadataService.ForecastingTypeSettings forecastingtypesettings = new MetadataService.ForecastingTypeSettings();


    }
    
    @isTest static void testImportProviderBatch(){
        Test.startTest();
        Database.executeBatch(new ImportGetProvidersBatch('RMMC', true), 100);
        Test.stopTest();
    }
    
    @isTest static void testImportPatientsBatch() {
        Test.startTest();
        Database.executeBatch(new ImportGetPatientsBatch('RMMC'));
        Test.stopTest();
    }
    
    @isTest static void auxBatchVisit(){
        Test.startTest();
        Database.executeBatch(new AuxAdvancedMDGetVisitsBatch('NMC', true, 150));
        Database.executeBatch(new AuxAdvancedMDGetVisitsBatch('RMMC', true, true, new Map<String, Appointment__c>{'123456'=>new Appointment__c(Name='Test', AdvancedMDID__C='123456' )}, 12));
        Test.stopTest();
    }
    
    @isTest static void testAuxAMDGetPatientsBatch(){
        Test.startTest();
        Database.executeBatch(new AuxAMDGetPatientsBatch('NMC', new String[]{'57676'}));
        Test.stopTest();
    }
    
    @isTest static void testAuxAMDGetVisitsPatientBatch(){
        Test.startTest();
        Database.executeBatch(new AuxAMDGetVisitsPatientBatch('NMC', new Map<String, Account>{'123456'=>new Account(Name='Test', AdvancedMDID__C='11249' )}));
        Test.stopTest();
    }
    
    @isTest static void auxBatchVisitDate(){
        Test.startTest();
        Database.executeBatch(new AuxAdvancedMDGetVisitsDateBatch('NMC', true, 150, '24-02-2020'));
        //Database.executeBatch(new AuxAdvancedMDGetVisitsBatch('RMMC', true, true, new Map<String, Appointment__c>{'123456'=>new Appointment__c(Name='Test', AdvancedMDID__C='123456' )}, 12));
        Test.stopTest();
    }
    
    @isTest static void auxBatchVisitUpdate(){
        Test.startTest();
        Database.executeBatch(new AuxAdvancedMDGetVisitsUpdateBatch(0, 150));
        Test.stopTest();
    }
    
    @isTest static void testAuxVisitsUpdatePaginated(){
        Map<String, Account> accountMap = new Map<String, Account> {'57676'=>new Account(LastName='Test', AdvancedMDID__C='57676', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient')!=null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null)};
        Test.startTest();
        Database.executeBatch(new AuxAdvancedMDGetVisitsUpdateBatch(0, true, new Map<String, Appointment__c>{'123456'=>new Appointment__c(Name='Test', AdvancedMDID__C='123456' )}, new Map<String, Account>(), 12));
    	Test.stopTest();
    }
    
    @isTest static void testAdvancedMDScheduleUpdateVisits() {
        AdvancedMDScheduleUpdateVisits scheduler = new AdvancedMDScheduleUpdateVisits();
        SchedulableContext context;
        Test.startTest();
        scheduler.execute(context);
        Test.stopTest();
    }
 
}