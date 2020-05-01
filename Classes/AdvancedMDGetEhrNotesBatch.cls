global class AdvancedMDGetEhrNotesBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    public String org;
    public Boolean isAll;
    public Integer size;
    public Map<String, Account> accountsMap;
    public Map<String, Account> accountsMapToProcess;
    public Map<String, String> templates;
    global AdvancedMDGetEhrNotesBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Integer size){
        this(org, isAll, accountsMap, new Map<String, Account>(accountsMap), size);
    }
    global AdvancedMDGetEhrNotesBatch(String org, Boolean isAll, Map<String, Account> accountsMap, Map<String, Account> accountsMapToProcess, Integer size){
        this.org = org;
        this.isAll = isAll;
        this.accountsMap = accountsMap;
        this.size = size;
        this.accountsMapToProcess = accountsMapToProcess;
        this.templates = org.equalsIgnoreCase('RMMC') ? new Map<String, String>(ApexUtil.templatesNameRMMC) : org.equalsIgnoreCase('BRMC') ?  new Map<String, String>(ApexUtil.templatesNameBRMC) : org.equalsIgnoreCase('NMC') ?  new Map<String, String>(ApexUtil.templatesNameNMC) : org.equalsIgnoreCase('CMC') ?  new Map<String, String>(ApexUtil.templatesNameCMC) : org.equalsIgnoreCase('AMC') ?  new Map<String, String>(ApexUtil.templatesNameAMC) : org.equalsIgnoreCase('TMC') ?  new Map<String, String>(ApexUtil.templatesNameTMC) : new Map<String, String>();
    }
    global List<Account> start(Database.BatchableContext BC){
        List<Account> accounts = new List<Account>();
        Integer i = 1;
        for(Account account:accountsMapToProcess.values()){if(i > size){break;}accounts.add(account);i++;}
        return accounts;
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        String recordType, note_id;
        Patient_Note__c objNote;
        Map<String,Patient_Note__c> mapNotes = new Map<String,Patient_Note__c>();
        for(Account account:scope){
            account.EHR_Note_s__c = null;
            /*for(Dom.XmlNode childElement1:AdvancedMDConnector.getAdvancedMDObject(org, '<ppmdmsg action="getehrnotes" class="api" msgtime="' + Datetime.now().format()  + '" patientid="' + account.AdvancedMDID__c + '" templateid="100000067"><patientnote templatename="TemplateName" notedatetime="NoteDatetime" username="UserName" signedbyuser="SignedByUser" reviewedbyuser="ReviewedByUser" confidential="Confidential" printedat="PrintedAt" /><sign username="FullName" signeddat="SignDatetime" /><page pagename="PageName" /><field ordinal="Ordinal" name="FieldName" value="Value" /><includefieldlist><includefield name="Vitals_Age" /><includefield name="Vitals_Grava" /></includefieldlist></ppmdmsg>')) 
                for(Dom.XmlNode childElement2:childElement1.getChildElements()) 
                	if(String.isNotBlank(childElement2.getAttributeValue('templatename', ''))) */
            for(String key : templates.keySet()){
                recordType=Schema.SObjectType.Patient_Note__c.getRecordTypeInfosByName().get(templates.get(key)) != null ? Schema.SObjectType.Patient_Note__c.getRecordTypeInfosByName().get(templates.get(key)).getRecordTypeId() : null;
                for(Dom.XmlNode childElement1:AdvancedMDConnector.getAdvancedMDObject(org, '<ppmdmsg action="getehrnotes" class="api" msgtime="' + Datetime.now().format()  + '" patientid="' + ApexUtil.getAMDID(account.AdvancedMDID__c, org) + '" templateid="'+ key +'"><patientnote templatename="TemplateName" notedatetime="NoteDatetime" username="UserName" signedbyuser="SignedByUser" reviewedbyuser="ReviewedByUser" confidential="Confidential" printedat="PrintedAt" /><sign username="FullName" signeddat="SignDatetime" /><page pagename="pagename" /><field ordinal="ordinal" name="fieldname" value="Value" /></ppmdmsg>'))
                    for(Dom.XmlNode childElement2:childElement1.getChildElements()){
                        //System.debug('c1:' + childElement1.getName() + '->patientnotelist');
                        //System.debug('c2:' + childElement2.getName() + '->patientnote');
                        if(String.isNotBlank(childElement2.getAttributeValue('id', ''))) {
                            System.debug('Aquí se creará el nuevo objeto: ' + childElement2.getAttributeValue('id', ''));
                            note_id = childElement2.getAttributeValue('id', '');
                            for(Dom.XmlNode childElement3:childElement2.getChildElements()){
                                //System.debug('c3:' + childElement3.getName() + '->signerlist and pagelist');
                                if(childElement3.getName().equalsIgnoreCase('pagelist')) for(Dom.XmlNode childElement4:childElement3.getChildElements()){
                                    //System.debug('c4:' + childElement4.getName() + '->page');
                                    objNote = new Patient_Note__c();
                                    objNote.Note_Id__c=note_id;
                                    objNote.KeyId__c=org.touppercase() + '-' + note_id + '-' + childElement4.getAttributeValue('id', '');
                                    objNote.Name=childElement4.getAttributeValue('id', '') + '-' + childElement4.getAttributeValue('pagename', '');
                                    objNote.Patient__c=account.Id;
                                    objNote.RecordTypeId=recordType;
                                    for(Dom.XmlNode childElement5:childElement4.getChildElements()){
                                        //System.debug('c5:' + childElement5.getName() + '->fieldlist');
                                        for(Dom.XmlNode childElement6:childElement5.getChildElements()){   
                                            if(String.isNotBlank(childElement6.getAttributeValue('value', ''))) 
                                            	account.EHR_Note_s__c = String.isNotBlank(account.EHR_Note_s__c) ? account.EHR_Note_s__c + ', ' + childElement6.getAttributeValue('name', '') + ':' + childElement6.getAttributeValue('value', '') : childElement6.getAttributeValue('name', '') + ': ' + childElement6.getAttributeValue('value', '');
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_QualTest1')){account.RMMC_QualTest1__c = childElement6.getAttributeValue('value', '').left(255); objNote.RMMC_QualTest1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_QualPSA1')){account.RMMC_QualPSA1__c = childElement6.getAttributeValue('value', '').left(255); objNote.RMMC_QualPSA1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Comments')){objNote.RMMC_Comments__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_ReviewDate')){objNote.RMMC_ReviewDate__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_todolist')){objNote.RMMC_todolist__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_NoteTime')){objNote.RMMC_NoteTime__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Quicknote')){objNote.RMMC_Quicknote__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BriefNote')){objNote.BriefNote__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_BP_Systolic1')){objNote.Vitals_BP_Systolic1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_BP_Diastolic1')){objNote.Vitals_BP_Diastolic1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_BP_Option1')){objNote.Vitals_BP_Option1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_BP_Location1')){objNote.Vitals_BP_Location1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Endocrine')){objNote.ROS_Endocrine__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionTime')){objNote.InjectionTime__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionProvider')){objNote.InjectionProvider__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionIndication')){objNote.InjectionIndication__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Staff')){objNote.Staff__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionType')){objNote.InjectionType__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionSite')){objNote.InjectionSite__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionMedication')){objNote.InjectionMedication__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionStrength')){objNote.InjectionStrength__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TRTDose')){objNote.RMMC_TRTDose__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TRTLot')){objNote.RMMC_TRTLot__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionDiagnosis')){objNote.InjectionDiagnosis__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionPrevious')){objNote.InjectionPrevious__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionDoseToday')){objNote.InjectionDoseToday__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('InjectionRemaining')){objNote.InjectionRemaining__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_LastDoseDate')){objNote.RMMC_LastDoseDate__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BloodDrawTime')){objNote.BloodDrawTime__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Hemoglobin')){objNote.Hemoglobin__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BloodDrawProvider')){objNote.BloodDrawProvider__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BloodDrawIndication')){objNote.BloodDrawIndication__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BloodDrawAdministeredBy')){objNote.BloodDrawAdministeredBy__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BloodDrawTests')){objNote.BloodDrawTests__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BloodDrawFasting')){objNote.InjectionTime__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BloodDrawAntiCoag')){objNote.BloodDrawAntiCoag__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BloodDrawTolerated')){objNote.BloodDrawTolerated__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Rmmc_trtfu')){objNote.Rmmc_trtfu__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Rmmc_hemacue')){objNote.Rmmc_hemacue__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Adjusteddose')){objNote.RMMC_Adjusteddose__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_FirmnessObtained')){objNote.RMMC_FirmnessObtained__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Adjdoration')){objNote.RMMC_Adjdoration__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled69')){objNote.Untitled69__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Adjpain')){objNote.RMMC_Adjpain__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_AdjSideFX')){objNote.RMMC_AdjSideFX__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_PtGoals')){objNote.RMMC_PtGoals__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_FinalDose')){objNote.RMMC_FinalDose__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Adjusteddose')){objNote.RMMC_Adjusteddose__c = childElement6.getAttributeValue('value', '').left(255);}
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Staff')){objNote.RMMC_Staff__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_NoofDosesTried')){objNote.RMMC_NoofDosesTried__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_AdjDuration')){objNote.RMMC_AdjDuration__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_complication')){objNote.RMMC_complication__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Rmmc_depth')){objNote.Rmmc_depth__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_providercomment')){objNote.RMMC_providercomment__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Provider')){objNote.RMMC_Provider__c = childElement6.getAttributeValue('value', '').left(255);}
                                        
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Date_PhoneMessage')){objNote.Date_PhoneMessage__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PatientName_PhoneMessage')){objNote.PatientName_PhoneMessage__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Name')){objNote.RMMC_Name__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Number_PhoneMessage')){objNote.Number_PhoneMessage__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ActionToBeTaken_PhoneMessage')){objNote.ActionToBeTaken_PhoneMessage__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ActionTaken_PhoneMessage')){objNote.ActionTaken_PhoneMessage__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('DateCompleted_PhoneMessage')){objNote.DateCompleted_PhoneMessage__c = childElement6.getAttributeValue('value', '').left(255);}
                                        
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TXplan')){objNote.RMMC_TXplan__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TXplan1')){objNote.RMMC_TXplan1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('MH_AdultHxMale_PastSurgeries')){objNote.MH_AdultHxMale_PastSurgeries__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('MH_AdultHxMale_CurrentMeds')){objNote.MH_AdultHxMale_CurrentMeds__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TMXlastdose')){objNote.RMMC_TMXlastdose__c = childElement6.getAttributeValue('value', '').left(255);}
                                        
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TMXPLANSTART')){objNote.RMMC_TMXPLANSTART__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('rmmc_TMxplanend')){objNote.rmmc_TMxplanend__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_SUBStart')){objNote.RMMC_SUBStart__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_SubEnd')){objNote.RMMC_SubEnd__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TRTEnd')){objNote.RMMC_TRTEnd__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TRTStart')){objNote.RMMC_TRTStart__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_DIMStart')){objNote.RMMC_DIMStart__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_DIMEnd')){objNote.RMMC_DIMEnd__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_HCGStart')){objNote.RMMC_HCGStart__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TXplan')){objNote.RMMC_TXplan__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_HCGEnd')){objNote.RMMC_HCGEnd__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_SermStart')){objNote.RMMC_SermStart__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_SermEnd')){objNote.RMMC_SermEnd__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_GWNo')){objNote.RMMC_GWNo__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_ESWTStart')){objNote.RMMC_ESWTStart__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_ESWTEnd')){objNote.RMMC_ESWTEnd__c = childElement6.getAttributeValue('value', '').left(255);}
                                        
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_ESWT_Session')){objNote.NEMC_ESWT_Session__c = childElement6.getAttributeValue('value', '').left(255);}
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_ESWT_Comment')){objNote.NEMC_ESWT_Comment__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_IIEF_SCORE')){objNote.NEMC_IIEF_SCORE__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_ESWT_Energy')){objNote.NEMC_ESWT_Energy__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_ESWT_Frequency')){objNote.NEMC_ESWT_Frequency__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_ESWT_PulseCount')){objNote.NEMC_ESWT_PulseCount__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('StartTime')){objNote.StartTime__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('EndTime')){objNote.EndTime__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('TimeTotal')){objNote.TimeTotal__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_ESWT_OPNote')){objNote.NEMC_ESWT_OPNote__c = childElement6.getAttributeValue('value', '').left(255);}
                                        
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_IIEF_Confidence')){objNote.NEMC_IIEF_Confidence__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_IIEF_Firmness')){objNote.NEMC_IIEF_Firmness__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_IIEF_Maintain')){objNote.NEMC_IIEF_Maintain__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_IIEF_Difficulty')){objNote.NEMC_IIEF_Difficulty__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_IIEF_Scale5')){objNote.RMMC_IIEF_Scale5__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_IIEF1_SCORE')){objNote.NEMC_IIEF1_SCORE__c = childElement6.getAttributeValue('value', '').left(255);}
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_IIEF_medications')){objNote.NEMC_IIEF_medications__c = childElement6.getAttributeValue('value', '').left(255);}
                     
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_PlanExpire')){objNote.RMMC_PlanExpire__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_PlanExpire2')){objNote.RMMC_PlanExpire2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Testdose')){objNote.RMMC_Testdose__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Rmmc_subdose')){objNote.Rmmc_subdose__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_ShipStatus')){objNote.RMMC_ShipStatus__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('NEMC_IIEF1_SCORE')){objNote.NEMC_IIEF1_SCORE__c = childElement6.getAttributeValue('value', '').left(255);}
                                        
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('CC_ChiefComplaint')){objNote.CC_ChiefComplaint__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_Weight')){objNote.Vitals_Weight__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_WeightPrev')){objNote.Vitals_WeightPrev__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_WeightChange')){objNote.Vitals_WeightChange__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_Height')){objNote.Vitals_Height__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_BMI')){objNote.Vitals_BMI__c = childElement6.getAttributeValue('value', '').left(255);}
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_Temperature')){objNote.Vitals_Temperature__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_Pulse')){objNote.Vitals_Pulse__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_Respiration')){objNote.Vitals_Respiration__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_O2SatRA')){objNote.Vitals_O2SatRA__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_BP_SystolicPrev')){objNote.Vitals_BP_SystolicPrev__c = childElement6.getAttributeValue('value', '').left(255);}
											if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_BP_DiastolicPrev')){objNote.Vitals_BP_DiastolicPrev__c = childElement6.getAttributeValue('value', '').left(255);}											
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PH_ReviewedAndUpdatedByPhysician')){objNote.PH_ReviewedAndUpdatedByPhysician__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PH_MedicalInjuriesOperationsTreatment')){objNote.PH_MedicalInjuriesOperationsTreatment__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('FH_FamilyParents')){objNote.FH_FamilyParents__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('SH_Social')){objNote.SH_Social__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('SH_SmokingComments')){objNote.SH_SmokingComments__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('SH_SocialSubstanceEmploymentSexual')){objNote.SH_SocialSubstanceEmploymentSexual__c = childElement6.getAttributeValue('value', '').left(255);}
                                        	
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Option')){objNote.ROS_Option__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_ConstitutionalNegative')){objNote.ROS_ConstitutionalNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Constitutional')){objNote.ROS_Constitutional__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_EyesNegative')){objNote.ROS_EyesNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Eyes')){objNote.ROS_Eyes__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_ENMT')){objNote.ROS_ENMT__c = childElement6.getAttributeValue('value', '').left(255);}
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_CardioNegative')){objNote.ROS_CardioNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Cardio')){objNote.ROS_Cardio__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_RespNegative')){objNote.ROS_RespNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Resp')){objNote.ROS_Resp__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_GastroNegative')){objNote.ROS_GastroNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Gastro')){objNote.ROS_Gastro__c = childElement6.getAttributeValue('value', '').left(255);}
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_GenitoNegative')){objNote.ROS_GenitoNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Genito')){objNote.ROS_Genito__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_MusculoskeletalNegative')){objNote.ROS_MusculoskeletalNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Musculoskeletal')){objNote.ROS_Musculoskeletal__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_SkinNegative')){objNote.ROS_SkinNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Skin')){objNote.ROS_Skin__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_NeuroNegative')){objNote.ROS_NeuroNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Neuro')){objNote.ROS_Neuro__c = childElement6.getAttributeValue('value', '').left(255);}
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_PsychNegative')){objNote.ROS_PsychNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Psych')){objNote.ROS_Psych__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_LymphNegative')){objNote.ROS_LymphNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Lymph')){objNote.ROS_Lymph__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_AllergicNegative')){objNote.ROS_AllergicNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Allergic')){objNote.ROS_Allergic__c = childElement6.getAttributeValue('value', '').left(255);}
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_EndocrineNegative')){objNote.ROS_EndocrineNegative__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('ROS_Endocrine')){objNote.ROS_Endocrine__c = childElement6.getAttributeValue('value', '').left(255);}
                                        
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_Gender')){objNote.PE_Gender__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_GastroAbdomen')){objNote.PE_GastroAbdomen__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_GastroLiver')){objNote.PE_GastroLiver__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_Lymphatic1')){objNote.PE_Lymphatic1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_Skin1')){objNote.PE_Skin1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('HPI_Description')){objNote.HPI_Description__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_General')){objNote.PE_General__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_GenitoSexualSatisfaction')){objNote.PE_GenitoSexualSatisfaction__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_Resp')){objNote.PE_Resp__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_Cardio')){objNote.PE_Cardio__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_NeckThyroid')){objNote.PE_NeckThyroid__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_NeuroMood')){objNote.PE_NeuroMood__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_Lymphatic')){objNote.PE_Lymphatic__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_Skin')){objNote.PE_Skin__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_GenitoSexualSatisfactionConcerns')){objNote.PE_GenitoSexualSatisfactionConcerns__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_RespNormal')){objNote.PE_RespNormal__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('PE_CardioNormal')){objNote.PE_CardioNormal__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled1280')){objNote.Untitled1280__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled1282')){objNote.Untitled1282__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Staff1')){objNote.RMMC_Staff1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_QtyOrdered')){objNote.RMMC_QtyOrdered__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_MedsPulled')){objNote.RMMC_MedsPulled__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Staff2')){objNote.RMMC_Staff2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled40')){objNote.Untitled40__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_FinalDose2')){objNote.RMMC_FinalDose2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Rmmc_subdose2')){objNote.Rmmc_subdose2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_TRTDose2')){objNote.RMMC_TRTDose2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_QtyOrdered2')){objNote.RMMC_QtyOrdered2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled58')){objNote.Untitled58__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled57')){objNote.Untitled57__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('StartTime2')){objNote.StartTime2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('EndTime2')){objNote.EndTime2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Nap_TotalStudyTime')){objNote.Nap_TotalStudyTime__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Firstcheck')){objNote.RMMC_Firstcheck__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Firm')){objNote.RMMC_Firm__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Staff')){objNote.Staff__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Check1')){objNote.RMMC_Check1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Firm1')){objNote.RMMC_Firm1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Staff1')){objNote.Staff1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Check2')){objNote.RMMC_Check2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Firm2')){objNote.RMMC_Firm2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Staff2')){objNote.Staff2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Check3')){objNote.RMMC_Check3__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Firm3')){objNote.RMMC_Firm3__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Staff3')){objNote.Staff3__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Check4')){objNote.RMMC_Check4__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Firm4')){objNote.RMMC_Firm4__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Staff5')){objNote.Staff5__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                        	if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Calltime')){objNote.RMMC_Calltime__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_RevTry')){objNote.RMMC_RevTry__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_doctalk')){objNote.RMMC_doctalk__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled1076')){objNote.Untitled1076__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_REV')){objNote.RMMC_REV__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Vitals_BP_Diastolic2')){objNote.Vitals_BP_Diastolic2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Check')){objNote.RMMC_Check__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('rmmc_bp_sys')){objNote.rmmc_bp_sys__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('rmmc_bp_dia')){objNote.rmmc_bp_dia__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled1076a')){objNote.Untitled1076a__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Rmmc_rev1time')){objNote.Rmmc_rev1time__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('rmmc_bp_sys1')){objNote.rmmc_bp_sys1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('rmmc_bp_dia1')){objNote.rmmc_bp_dia1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_REV1')){objNote.RMMC_REV1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Rmmc_rev1time1')){objNote.Rmmc_rev1time1__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled1076b')){objNote.Untitled1076b__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('rmmc_bp_sys2')){objNote.rmmc_bp_sys2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('rmmc_bp_dia2')){objNote.rmmc_bp_dia2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_REV2')){objNote.RMMC_REV2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Rmmc_rev1time2')){objNote.Rmmc_rev1time2__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled1076c')){objNote.Untitled1076c__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Anesthesia')){objNote.RMMC_Anesthesia__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('RMMC_Staff_aspiration_note')){objNote.RMMC_Staff_aspiration_note__c = childElement6.getAttributeValue('value', '').left(255);}
                                            
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('Untitled22')){objNote.Untitled22__c = childElement6.getAttributeValue('value', '').left(255);}
                                            if(childElement6.getAttributeValue('name', '').equalsIgnoreCase('BRMC_authorized')){objNote.BRMC_authorized__c = childElement6.getAttributeValue('value', '').left(255);}
                                        }
                                    }
                                    mapNotes.put(objNote.KeyId__c, objNote);
                                }
                            }
                            System.debug('Aquí se agregará a la lista y lo relacionaremos con el account.!' + account.Id);
                        }
                    }
            }
            account.EHR_Note_s__c = String.isNotBlank(account.EHR_Note_s__c) ? account.EHR_Note_s__c.left(6000) : '';
            accountsMapToProcess.remove(account.AdvancedMDID__c);
        }
        ApexUtil.isAdvancedMDAccountTriggerInvoked = true;
        List<Database.UpsertResult> upsertResults = Database.upsert(scope, Account.AdvancedMDID__c, false);
        for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetEhrNotesBatch - Account Upsert Error: ' + upsertError.getMessage());
        //if(AdvancedMDConnector.authentication.Token_Datetime__c == null || (DateTime.now() >= AdvancedMDConnector.authentication.Token_Datetime__c.addHours(24).addMinutes(-1))){AdvancedMDConnector.authentication.Token_Datetime__c = Datetime.now();update AdvancedMDConnector.authentication;}
        upsertResults = Database.upsert(mapNotes.values(), Patient_Note__c.KeyId__c, false);
        for(Database.UpsertResult upsertResult:upsertResults) if(!upsertResult.isSuccess()) for(Database.Error upsertError : upsertResult.getErrors()) System.debug('AdvancedMDGetEhrNotesBatch - Patient_Note Upsert Error: ' + upsertError.getMessage());
    }
    global void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()){
    		if(!accountsMapToProcess.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetEhrNotesBatch(org, isAll, accountsMap, accountsMapToProcess, size), 'AdvancedMDGetEhrNotesBatch-' + org, 1, 50);    
    		else if(!accountsMap.values().isEmpty()) System.scheduleBatch(new AdvancedMDGetTxHistoryBatch(org, isAll, accountsMap, 12), 'AdvancedMDGetTxHistoryBatch-' + org, 1, 50);    
    		else Database.executeBatch(new AdvancedMDGetTxHistoryBatch(org, isAll, accountsMap, 12));
        }
    }
}