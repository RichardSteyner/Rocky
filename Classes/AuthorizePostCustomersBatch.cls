global class AuthorizePostCustomersBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    global String org;
    global String primaryClinic;
    global AuthorizePostCustomersBatch(String org){
        this.org=org;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        primaryClinic = !org.equalsIgnoreCase('CastleRock') ? (!org.equalsIgnoreCase('Colorado Springs') ? (!org.equalsIgnoreCase('Denver Central') ? (!org.equalsIgnoreCase('Denver North') ? (!org.equalsIgnoreCase('Northeast') ? (!org.equalsIgnoreCase('Northeast_Dedham') ? (!org.equalsIgnoreCase('Baton') ? '' : 'Baton Rouge Mens Clinic') : 'Northeast Mens Clinic - Dedham') : 'Northeast Mens Clinic') : 'North Denver') : 'Central Denver') : 'Colorado Springs') : 'Castle Rock';
        return Database.getQueryLocator('Select Id, LastName, PersonEmail, Authorize_ID__c From Account Where Authorize_To_Sync__c = true and Primary_Clinic__c=\'' + primaryClinic + '\'');
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        String xmlBody;
        HttpRequest request;
        Http http;
        HTTPResponse response;
        for(Account account:scope){
            if(String.isBlank(account.Authorize_ID__c)){
                xmlBody = '<createCustomerProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                            +'<merchantAuthentication>'
                                +'<name>' + AuthorizeNetList__c.getValues(org).Api_Login_ID__c + '</name>'
                                +'<transactionKey>' + AuthorizeNetList__c.getValues(org).Transaction_Key__c + '</transactionKey>'
                            +'</merchantAuthentication>'
                            +'<profile>'
                                +'<merchantCustomerId>' + account.Id + '</merchantCustomerId>'
        						+'<description>' + account.LastName.escapeXml() + '</description>'
                                +'<email>' + (String.isNotBlank(account.PersonEmail) ? account.PersonEmail.escapeXml() : '') + '</email>'
                            +'</profile>'
         				+'</createCustomerProfileRequest>';
                response = AuthorizeConnector.putAuthorizeObject(org, xmlBody);
                if(response.getStatusCode() == 200 && response.getBody().contains('<resultCode>Ok</resultCode>')) account.Authorize_ID__c = response.getBody().substringBetween('<customerProfileId>','</customerProfileId>');
                else account.Authorize_Sync_Error__c = String.isNotBlank(response.getBody().substringBetween('<description>','</description>')) ? response.getBody().substringBetween('<description>','</description>').left(255) : response.getBody().left(255);
            }
            else{
                xmlBody = '<updateCustomerProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                            +'<merchantAuthentication>'
                                +'<name>' + AuthorizeNetList__c.getValues(org).Api_Login_ID__c + '</name>'
                                +'<transactionKey>' + AuthorizeNetList__c.getValues(org).Transaction_Key__c + '</transactionKey>'
                            +'</merchantAuthentication>'
                            +'<profile>'
                                +'<merchantCustomerId>' + account.Id + '</merchantCustomerId>'
                                +'<description>' + account.LastName.escapeXml() + '</description>'
                                +'<email>' + (String.isNotBlank(account.PersonEmail) ? account.PersonEmail.escapeXml() : '') + '</email>'
                                +'<customerProfileId>' + account.Authorize_ID__c + '</customerProfileId>'
                            +'</profile>'
         				+'</updateCustomerProfileRequest>';
                response = AuthorizeConnector.putAuthorizeObject(org, xmlBody);
                if(response.getStatusCode() != 200 || (String.isNotBlank(response.getBody()) && !response.getBody().contains('<resultCode>Ok</resultCode>'))) account.Authorize_Sync_Error__c = String.isNotBlank(response.getBody().substringBetween('<description>','</description>')) ? response.getBody().substringBetween('<description>','</description>').left(255) : response.getBody().left(255);
            }
            account.Authorize_To_Sync__c = false;
        }
        ApexUtil.isAuthorizeAccountTriggerInvoked = true;
        List<Database.SaveResult> saveResults = Database.update(scope, false);
        for(Database.SaveResult saveResult:saveResults) if(!saveResult.isSuccess()) for(Database.Error saveError : saveResult.getErrors()) System.debug('AuthorizePostCustomersBatch - Account update Error: ' + saveError.getMessage());
    }
    global void finish(Database.BatchableContext BC){
        if(!Test.isRunningTest()) Database.executeBatch(new AuthorizePostCustomerPaymentsBatch(org), 30);
    }
}