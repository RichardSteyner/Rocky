global class AdvancedMDPostVisitsBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    public String org;
    
    global AdvancedMDPostVisitsBatch(String org){
        this.org = org;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug('Start Post');
        String primaryClinic = String.isNotBlank(org) ? (!org.equalsIgnoreCase('AMC') ? (!org.equalsIgnoreCase('BRMC') ? (!org.equalsIgnoreCase('CMC') ? (!org.equalsIgnoreCase('TMC') ? (!org.equalsIgnoreCase('NMC') ? (!org.equalsIgnoreCase('RMMC') ? (!org.equalsIgnoreCase('Production') ? 'Colorado Springs' : 'Rocky Mountain Mens Clinic') : 'Rocky Mountain Mens Clinic') : 'Northeast Mens Clinic') : 'Tennessee Mens Clinic') : 'Columbus Mens Clinic') : 'Baton Rouge Mens Clinic') : 'Alabama Mens Clinic')  : '' ;
        String auxFilter = String.isNotBlank(org) ? org.equalsIgnoreCase('RMMC') ? ' or Patient__r.Primary_Clinic__c=\'Colorado Springs\' or Patient__r.Primary_Clinic__c=\'Central Denver\' or Patient__r.Primary_Clinic__c=\'North Denver\' or Patient__r.Primary_Clinic__c=\'Castle Rock\') ' : org.equalsIgnoreCase('NMC') ? ' or Patient__r.Primary_Clinic__c=\'Northeast Mens Clinic - Dedham\' ) ' : ') ' : ') ';
        System.debug('Select Id, Provider__r.Profile_Id__c, AdvancedMDID__c, Created_Date__c, Patient__r.AdvancedMDID__c From Appointment__c Where Patient__r.AdvancedMDID__c != null and Provider__r.Profile_Id__c!=null and AdvancedMDID__c=null and (Patient__r.Primary_Clinic__c=\''+ primaryClinic+'\''+ auxFilter + ' limit 12');
        return Database.getQueryLocator('Select Id, Provider__r.Profile_Id__c, AdvancedMDID__c, Created_Date__c, Patient__r.AdvancedMDID__c From Appointment__c Where Patient__r.AdvancedMDID__c != null and Provider__r.Profile_Id__c!=null and AdvancedMDID__c=null and (Patient__r.Primary_Clinic__c=\''+ primaryClinic+'\''+ auxFilter + ' limit 12');
    }
    global void execute(Database.BatchableContext BC, List<Appointment__c> scope){
        System.debug('Execute Post');
        try{
            HTTPResponse response;
            String xmlBody;
            for(Appointment__c app : scope){
               	xmlBody = '<ppmdmsg action="addvisit" class="chargeentry" msgtime="' + Datetime.now().format()  + '">'
                                    +'<appt patient="' + ApexUtil.getAMDID(app.Patient__r.AdvancedMDID__c, org) + '" profile="' + app.Provider__r.Profile_Id__c +'" date="' + (app.Created_Date__c != null ? app.Created_Date__c.format() : '') + '"/>'
                                +'</ppmdmsg>';
              	response = AdvancedMDConnector.postAdvancedMDObject(org, xmlBody);
               	if(response.getStatusCode() == 200 && !response.getBody().contains('<Error>')){
                  	app.AdvancedMDID__c = String.isNotBlank(response.getBody().substringBetween('<visit id="','"')) ? org.touppercase() + '-' + response.getBody().substringBetween('<visit id="','"').substringAfter('vst') : '';
                	if(app.Created_Date__c==null)app.Created_Date__c = System.now();
                } else System.debug(response.getBody().substringBetween('<Error>', '</Error>'));
                System.debug('xmlBody: ' + xmlBody);
            }
            List<Appointment__c> apps = new List<Appointment__c>();
            List<Database.SaveResult> saveResults;
            for(Appointment__c app:scope) if(app.AdvancedMDID__c!=null) apps.add(app);
            if(apps.size()>0) {
                saveResults = Database.update(scope, false);
            	for(Database.SaveResult saveResult:saveResults) if(!saveResult.isSuccess()) for(Database.Error saveError : saveResult.getErrors()) System.debug('AdvancedMDPostVisitsBatch - Appoinment update Error: ' + saveError.getMessage());
            }
       	}catch(Exception e){
            System.debug('AdvancedMDPostVisitsBatch error: ' + e.getLineNumber() +  ' - ' + e.getMessage());
        }
    
        //if(AdvancedMDConnector.authentication.Token_Datetime__c == null || (DateTime.now() >= AdvancedMDConnector.authentication.Token_Datetime__c.addHours(24).addMinutes(-1))){AdvancedMDConnector.authentication.Token_Datetime__c = Datetime.now();update AdvancedMDConnector.authentication;}
    }
    global void finish(Database.BatchableContext BC){
        System.debug('Finish Post');
        AdvancedMD_List__c authentication = AdvancedMD_List__c.getValues(org);
        try{
            System.debug('Update auth!' + authentication.Name + '-' + authentication.Token_Datetime__c);
            authentication.Token_Datetime__c = null;update authentication;
        }catch(Exception e){
            System.debug('Exception: ' + e.getMessage());
        }
        //if(!Test.isRunningTest()) System.scheduleBatch(new AdvancedMDGetProvidersBatch(isAll), 'AdvancedMDGetProvidersBatch', 1, 200);
    }
}