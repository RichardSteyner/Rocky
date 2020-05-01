global class AuxAMDGetVisitsPatientBatch implements Database.Batchable<Account>, Database.Stateful, Database.AllowsCallouts{
    public String org;
    public Map<String, Account> updatedAccountsMap;
    public Map<String, Account> accountsMap;
    public Map<String, Appointment__c> appointmentsMap;
    global AuxAMDGetVisitsPatientBatch(String org, Map<String, Account> updatedAccountsMap){
        this(org, updatedAccountsMap, new Map<String, Appointment__c>());
    }
    global AuxAMDGetVisitsPatientBatch(String org, Map<String, Account> updatedAccountsMap, Map<String, Appointment__c> appointmentsMap){
        this.org = org;
        this.updatedAccountsMap = updatedAccountsMap;
        accountsMap = new Map<String, Account>(updatedAccountsMap);
        this.appointmentsMap = appointmentsMap;
    }
    global List<Account> start(Database.BatchableContext BC){
        System.debug('Start AuxAMDGetVisitsPatientBatch');
        String primaryClinic = String.isNotBlank(org) ? (!org.equalsIgnoreCase('AMC') ? (!org.equalsIgnoreCase('BRMC') ? (!org.equalsIgnoreCase('CMC') ? (!org.equalsIgnoreCase('TMC') ? (!org.equalsIgnoreCase('NMC') ? (!org.equalsIgnoreCase('RMMC') ? (!org.equalsIgnoreCase('Production') ? 'Colorado Springs' : 'Rocky Mountain Mens Clinic') : 'Rocky Mountain Mens Clinic') : 'Northeast Mens Clinic') : 'Tennessee Mens Clinic') : 'Columbus Mens Clinic') : 'Baton Rouge Mens Clinic') : 'Alabama Mens Clinic')  : '' ;
        
            List<Account> accounts = new List<Account>();
            Integer i = 1;
            for(Account a:accountsMap.values()){if(i > 1){break;}accounts.add(a);i++;}
            return accounts;
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        String primaryClinic = String.isNotBlank(org) ? (!org.equalsIgnoreCase('AMC') ? (!org.equalsIgnoreCase('BRMC') ? (!org.equalsIgnoreCase('CMC') ? (!org.equalsIgnoreCase('CMC2') ? (!org.equalsIgnoreCase('NMC') ? (!org.equalsIgnoreCase('RMMC') ? (!org.equalsIgnoreCase('Production') ? 'Colorado Springs' : 'Rocky Mountain Mens Clinic') : 'Rocky Mountain Mens Clinic') : 'Northeast Mens Clinic') : 'Columbus Mens Clinic') : 'Columbus Mens Clinic') : 'Baton Rouge Mens Clinic') : 'Alabama Mens Clinic')  : '';
        String auxPrimaryClinic='';
        Map<String, Appointment__c> appointmentsScopeMap = new Map<String, Appointment__c>();
        Map<String, Account> accountsScopeMap = new Map<String, Account>();
        Map<String, Contact> contactsMap = new Map<String, Contact>();
            Appointment__c appointment;
            String patientXml, xmlData = '';
            for(Account acc:scope){patientXml = ApexUtil.getAMDID(acc.AdvancedMDID__c, org); accountsScopeMap.put(acc.AdvancedMDID__c, acc); accountsMap.remove(acc.AdvancedMDID__c);}
            xmlData = '<ppmdmsg action="getpatientvisits" class="api" msgtime="12/31/2015 4:55:49 AM" patientid="' + patientXml +'" ><visit visit_uid="Visit_UID" patientid="PatientID" columnheading="ColumnHeading" appointmenttypeid="AppointmentTypeID" appointmenttype="AppointmentType" visitstartdatetime="VisitStartDateTime" visitdate="VisitDate" visitstarttime="VisitStartTime" duration="Duration" color="Color" profilecode="ProfileCode" profilename="ProfileName" profileuid="ProfileUID" providername="ProviderName" provideremail="ProviderEmail" comments="Comments" apptstatus="ApptStatus" arrivetime="ArriveTime" othertime="OtherTime" seentime="SeenTime" chargesposted="ChargesPosted" confirmmethod="ConfirmMethod" confirmedat="ConfirmedAt" confirmedby="ConfirmedBy" episode="Episode" facilitycode="FacilityCode" facilityname="FacilityName" visitnote="VisitNote" insurancebillingorder="InsuranceBillingOrder" acceptassignment="AcceptAssignment" forcepaperclaim="ForcePaperClaim" createdat="CreatedAt" createdby="CreatedBy" modifiedat="ModifiedAt" modifiedby="ModifiedBy" reftype="RefType" refreason="RefReason" refcreation="RefCreation" refexpiration="RefExpiration" byrefprovcode="ByRefProvCode" byrefprovlastname="ByRefProvLastName" byrefprovfirstname="ByRefProvFirstName" byrefprovmiddlename="ByRefProvMiddleName" byrefprovtitle="ByRefProvTitle" byreferringproviderfid="ByReferringProviderFID"/><patient lastname="LastName" firstname="FirstName" middlename="MiddleName" name="Name" chart="Chart" title="Title" address1="Address1" address2="Address2" zip="Zip" city="City" state="State" officephone="OfficePhone" officeext="OfficeExt" homephone="HomePhone" otherphone="OtherPhone" additionalmrn="AdditionalMrn" ethnicityid="EthnicityID" languageid="LanguageID" maritalstatusid="MaritalStatusID" othertype="OtherType" email="Email" maritalstatus="MaritalStatus" dob="DOB" deceased="Deceased" sex="Sex" ssn="SSN" relationship="Relationship" hipaarelationship="HIPAARelationship" ethnicity="Ethnicity" language="Language" races="Races" ptinactivedate="PtInactiveDate" ptinactivestatuscode="PtInactiveStatusCode" ptinactivedescription="PtInactiveDescription" ptinactiveexcludedfromsearch="PtInactiveExcludedFromSearch" respparty="RespParty" rplastname="RPLastName" rpfirstname="RPFirstName" rpmiddlename="RPMiddleName" rpfullname="RPFullName" rpaddress1="RPAddress1" rpaddress2="RPAddress2" rpzipcode="RPZipCode" rpcity="RPCity" rpstate="RPState" rpemployer="RPEmployer" rpaccttypecode="RPAcctTypeCode" rpaccttypedescription="RPAcctTypeDescription" rpofficephone="RPOfficePhone" rpofficeextension="RPOfficeExtension" rphomephone="RPHomePhone" rpotherphone="RPOtherPhone" rpotherphonetype="RPOtherPhoneType" rpemail="RPEmail" rpdob="RPDOB" rpgender="RPGender" rpssn="RPSSN" rptitle="RPTitle" rpemploymentstatus="RPEmploymentStatus" rpcreatedat="RPCreatedAt" rpcreatedby="RPCreatedBy" rpdisplay="RPDisplay" rpchangedat="RPChangedAt" rpchangedby="RPChangedBy" provider="Provider" profile="Profile" profilecode="ProfileCode" profilename="ProfileName" provlastname="ProvLastName" provfirstname="ProvFirstName" provmiddlename="ProvMiddleName" provfullname="ProvFullName" provtitle="ProvTitle" finclass="FinClass" finclasscode="FinClassCode" finclassdescription="FinClassDescription" employerid="EmployerID" employer="Employer" insorder="InsOrder" createdat="CreatedAt" createdby="CreatedBy" changedat="ChangedAt" changedby="ChangedBy" iccreatedat="ICCreatedAt" icchangedat="ICChangedAt" refplanchangedat="RefPlanChangedAt" customdatachangedat="CustomDataChangedAt" episodechangedat="EpisodeChangedAt"/></ppmdmsg>';
            for(Dom.XmlNode childElement1:AdvancedMDConnector.getAdvancedMDObject(org, xmlData)){
                for(Dom.XmlNode childElement2:childElement1.getChildElements()){
                    if(String.isNotBlank(childElement2.getAttributeValue('id', ''))) appointmentsScopeMap.put(org.touppercase() + '-' + childElement2.getAttributeValue('id', ''), new Appointment__c(
                        AdvancedMDID__c = org.touppercase() + '-' + childElement2.getAttributeValue('id', ''),
                        Patient_Id__c = childElement2.getChildElement('patientlist', null) != null && !childElement2.getChildElement('patientlist', null).getChildElements().isEmpty() ? org.touppercase() + '-' + childElement2.getChildElement('patientlist', null).getChildElements()[0].getAttributeValue('id', '') : '',
                        Provider_Code__c = String.isNotBlank(childElement2.getAttributeValue('profilecode', '')) ? childElement2.getAttributeValue('profilecode', '').trim() : '',
                        Name = String.isNotBlank(childElement2.getAttributeValue('visit_uid', '')) ? childElement2.getAttributeValue('visit_uid', '') : childElement2.getAttributeValue('id', ''),
                        Visit_Number__c = childElement2.getAttributeValue('visit_uid', ''),
                        Created_Date__c = String.isNotBlank(childElement2.getAttributeValue('createdat', '')) ? DateTime.valueOf(childElement2.getAttributeValue('createdat', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                        Changed_Date__c = String.isNotBlank(childElement2.getAttributeValue('modifiedat', '')) ? DateTime.valueOf(childElement2.getAttributeValue('modifiedat', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                        Appointment_Type__c = childElement2.getAttributeValue('appointmenttype', ''),
                        Appointment_Status__c = childElement2.getAttributeValue('apptstatus', '') == '0' ? 'Made' : childElement2.getAttributeValue('apptstatus', '') == '1' ? 'Arrived' : childElement2.getAttributeValue('apptstatus', '') == '2' ? 'Other' : childElement2.getAttributeValue('apptstatus', '') == '3' ? 'Complete' : childElement2.getAttributeValue('apptstatus', '') == '5' ? 'Moved' : childElement2.getAttributeValue('apptstatus', '') == '12' ? 'No Show' : childElement2.getAttributeValue('apptstatus', '') == '10' ? 'Cancelled' : childElement2.getAttributeValue('apptstatus', '') == '11' ? 'Deleted' : childElement2.getAttributeValue('apptstatus', ''),
                        Provider_Room__c = childElement2.getAttributeValue('columnheading', ''),
                        Start_Date_time__c = String.isNotBlank(childElement2.getAttributeValue('visitstartdatetime', '')) ? DateTime.valueOf(childElement2.getAttributeValue('visitstartdatetime', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                        End_date_Time__c = String.isNotBlank(childElement2.getAttributeValue('visitstartdatetime', '')) && String.isNotBlank(childElement2.getAttributeValue('duration', '')) ? DateTime.valueOf(childElement2.getAttributeValue('visitstartdatetime', '').substringBeforeLast('.').replace('T', ' ')).addMinutes(Integer.valueOf(childElement2.getAttributeValue('duration', ''))) : null,                    
                        Episode__c = childElement2.getAttributeValue('episode', ''),
                        Appointment_Color__c = childElement2.getAttributeValue('color', ''),
                        Confirmed_Method__c = childElement2.getAttributeValue('confirmmethod', '') == '11' ? 'Auto Confirmed' : childElement2.getAttributeValue('confirmmethod', '') == '4' ? 'Email' : childElement2.getAttributeValue('confirmmethod', '') == '3' ? 'Fax Sent' : childElement2.getAttributeValue('confirmmethod', '') == '5' ? 'Letter Sent' : childElement2.getAttributeValue('confirmmethod', '') == '6' ? 'Left a message' : childElement2.getAttributeValue('confirmmethod', '') == '9' ? 'Phoned-No Answer-No voice mail' : childElement2.getAttributeValue('confirmmethod', '') == '2' ? 'Phone Call' : childElement2.getAttributeValue('confirmmethod', '') == '8' ? 'Spoke with Person' : childElement2.getAttributeValue('confirmmethod', '') == '7' ? 'Spoke with Patient' : childElement2.getAttributeValue('confirmmethod', ''),
                        Arrive_Time__c = String.isNotBlank(childElement2.getAttributeValue('arrivetime', '')) ? DateTime.valueOf(childElement2.getAttributeValue('arrivetime', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                        Other_Time__c = String.isNotBlank(childElement2.getAttributeValue('othertime', '')) ? DateTime.valueOf(childElement2.getAttributeValue('othertime', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                        Seen_Time__c = String.isNotBlank(childElement2.getAttributeValue('seentime', '')) ? DateTime.valueOf(childElement2.getAttributeValue('seentime', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                        Confirmed_At__c = String.isNotBlank(childElement2.getAttributeValue('confirmedat', '')) ? DateTime.valueOf(childElement2.getAttributeValue('confirmedat', '').substringBeforeLast('.').replace('T', ' ')) : null,                    
                        Confirmed_By__c = childElement2.getAttributeValue('confirmedby', ''),
                        Comments__c = childElement2.getAttributeValue('comments', ''),
                        Visit_Note__c = childElement2.getAttributeValue('visitnote', ''),
                        Accepts_Assignment__c = childElement2.getAttributeValue('acceptassignment', ''),
                        Referred_Type__c = childElement2.getAttributeValue('reftype', ''),
                        Referred_Reason__c = childElement2.getAttributeValue('refreason', ''),
                        Referring_Provider_Code__c = String.isNotBlank(childElement2.getAttributeValue('byrefprovcode', '')) ? childElement2.getAttributeValue('byrefprovcode', '').trim() : '',
                        Facility__c = (String.isNotBlank(childElement2.getAttributeValue('facilitycode', '')) ? childElement2.getAttributeValue('facilitycode', '').trim() + ' ' : '') + (String.isNotBlank(childElement2.getAttributeValue('facilityname', '')) ? childElement2.getAttributeValue('facilityname', '').trim() : '')
                    ));
                    auxPrimaryClinic = org.equalsIgnoreCase('RMMC') || org.equalsIgnoreCase('NMC')  ? String.isNotBlank(childElement2.getAttributeValue('facilitycode', '')) ? childElement2.getAttributeValue('facilitycode', '').trim() : '' : '';
                    if(childElement2.getChildElement('patientlist', null) != null && !childElement2.getChildElement('patientlist', null).getChildElements().isEmpty() && String.isNotBlank(childElement2.getChildElement('patientlist', null).getChildElements()[0].getAttributeValue('id', ''))) accountsScopeMap.put(org.touppercase() + '-' + childElement2.getChildElement('patientlist', null).getChildElements()[0].getAttributeValue('id', ''), new Account(
                        RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null,
                        AdvancedMDID__c = org.touppercase() + '-' + childElement2.getChildElement('patientlist', null).getChildElements()[0].getAttributeValue('id', ''),
                        Primary_Clinic__c = String.isNotBlank(auxPrimaryClinic) ? auxPrimaryClinic.equalsIgnoreCase('COS') ? 'Colorado Springs' :  auxPrimaryClinic.equalsIgnoreCase('DEN') ? 'Central Denver' :  auxPrimaryClinic.equalsIgnoreCase('NOCO') ? 'North Denver' :  auxPrimaryClinic.equalsIgnoreCase('CROCK') ? 'Castle Rock' : auxPrimaryClinic.equalsIgnoreCase('NEMH2') ? 'Northeast Mens Clinic - Dedham' : primaryClinic   : primaryClinic
                    ));
                }                 
            } 
        for(Appointment__c appmnt:appointmentsScopeMap.values()){
            if(String.isNotBlank(appmnt.Provider_Code__c)) contactsMap.put(appmnt.Provider_Code__c, new Contact());
            if(String.isNotBlank(appmnt.Referring_Provider_Code__c)) contactsMap.put(appmnt.Referring_Provider_Code__c, new Contact());
        }
        List<Database.UpsertResult> upsertResults;
            ApexUtil.isAdvancedMDAccountTriggerInvoked = true;
            upsertResults = Database.upsert(accountsScopeMap.values(), Account.AdvancedMDID__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetVisitsBatch - Account Upsert Error: ' + upsertError.getMessage());
        for(Contact contact:[Select id, Code__c from Contact where Code__c in :contactsMap.keySet()]) contactsMap.get(contact.Code__c).id = contact.id;
        for(Appointment__c appmnt:appointmentsScopeMap.values()){
            if(accountsScopeMap.get(appmnt.Patient_Id__c) != null) appmnt.Patient__c = accountsScopeMap.get(appmnt.Patient_Id__c).id;
            if(contactsMap.get(appmnt.Provider_Code__c) != null) appmnt.Provider__c = contactsMap.get(appmnt.Provider_Code__c).id;
            if(contactsMap.get(appmnt.Referring_Provider_Code__c) != null) appmnt.Provider_Referral__c = contactsMap.get(appmnt.Referring_Provider_Code__c).id;
        }
        if(!appointmentsScopeMap.values().isEmpty()){
            ApexUtil.isAppointmentTriggerInvoked = true;
            upsertResults = Database.upsert(appointmentsScopeMap.values(), Appointment__c.AdvancedMDID__c, false);
            for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AuxAMDGetVisitsPatientBatch - Appointment__c Upsert Error: ' + upsertError.getMessage());
        }
        //if(AdvancedMDConnector.authentication.Token_Datetime__c == null || (DateTime.now() >= AdvancedMDConnector.authentication.Token_Datetime__c.addHours(24).addMinutes(-1))){AdvancedMDConnector.authentication.Token_Datetime__c = Datetime.now();update AdvancedMDConnector.authentication;}
    }
    global void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
    		if(!accountsMap.values().isEmpty()) System.scheduleBatch(new AuxAMDGetVisitsPatientBatch(org, updatedAccountsMap, appointmentsMap), 'AuxAMDGetVisitsPatientBatch-' + org, 1, 200);      
        }
    }
}