global class AuthorizePostCustomerPaymentsBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    global String org;
    global String primaryClinic;
    global AuthorizePostCustomerPaymentsBatch(String org){
        this.org=org;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        primaryClinic = !org.equalsIgnoreCase('CastleRock') ? (!org.equalsIgnoreCase('Colorado Springs') ? (!org.equalsIgnoreCase('Denver Central') ? (!org.equalsIgnoreCase('Denver North') ? (!org.equalsIgnoreCase('Northeast') ? (!org.equalsIgnoreCase('Northeast_Dedham') ? (!org.equalsIgnoreCase('Baton') ? '' : 'Baton Rouge Mens Clinic') : 'Northeast Mens Clinic - Dedham') : 'Northeast Mens Clinic') : 'North Denver') : 'Central Denver') : 'Colorado Springs') : 'Castle Rock';
        return Database.getQueryLocator('Select Id, Authorize_ID__c, Account__c, Account__r.Authorize_ID__c, Account__r.LastName, Account__r.PersonEmail, Customer_Id__c, Customer_Type__c, First_Name__c, Last_Name__c, Company__c, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Zip__c, Billing_Country__c, Phone__c, Fax__c, Card_Number__c, Expiration_Date_Month__c, Expiration_Date_Year__c, Card_Code__c From Payment_Method__c Where Authorize_To_Sync__c = true and Account__r.Primary_Clinic__c=\'' + primaryClinic + '\'');
    }
    global void execute(Database.BatchableContext BC, List<Payment_Method__c> scope){
        String xmlBody;
        HttpRequest request;
        Http http;
        HTTPResponse response;
        Map<Id, Account> accountsToSendMap = new Map<Id, Account>();
        for(Payment_Method__c paymentMethod:scope) if(String.isBlank(paymentMethod.Account__r.Authorize_ID__c)) accountsToSendMap.put(paymentMethod.Account__c, new Account(Id = paymentMethod.Account__c, LastName = paymentMethod.Account__r.LastName, PersonEmail = paymentMethod.Account__r.PersonEmail));
        for(Account account:accountsToSendMap.values()){
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
            else account.Authorize_Sync_Error__c = String.isNotBlank(response.getBody().substringBetween('<description>','</description>')) ? response.getBody().substringBetween('<description>','</description>').left(255) : String.isNotBlank(response.getBody().substringBetween('<text>','</text>')) ? response.getBody().substringBetween('<text>','</text>').left(255) : response.getBody().left(255);
        }
        for(Payment_Method__c paymentMethod:scope){
            paymentMethod.Authorize_Sync_Error__c = '';
            if(String.isBlank(paymentMethod.Authorize_ID__c)){
                if(String.isBlank(paymentMethod.Account__r.Authorize_ID__c) && accountsToSendMap.get(paymentMethod.Account__c) != null) paymentMethod.Customer_Id__c = accountsToSendMap.get(paymentMethod.Account__c).Authorize_ID__c;
                if(String.isNotBlank(paymentMethod.Account__r.Authorize_ID__c) && String.isBlank(paymentMethod.Customer_Id__c)) paymentMethod.Customer_Id__c = paymentMethod.Account__r.Authorize_ID__c;
                xmlBody = '<createCustomerPaymentProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                            +'<merchantAuthentication>'
                                +'<name>' + AuthorizeNetList__c.getValues(org).Api_Login_ID__c + '</name>'
                                +'<transactionKey>' + AuthorizeNetList__c.getValues(org).Transaction_Key__c + '</transactionKey>'
                            +'</merchantAuthentication>'
        					+'<customerProfileId>' + (String.isNotBlank(paymentMethod.Customer_Id__c) ? paymentMethod.Customer_Id__c : '') + '</customerProfileId>'
                            +'<paymentProfile>'
            					+'<customerType>' + (String.isNotBlank(paymentMethod.Customer_Type__c) ? paymentMethod.Customer_Type__c.toLowerCase() : '') + '</customerType>'
                                +'<billTo>'
                                  +'<firstName>' + (String.isNotBlank(paymentMethod.First_Name__c) ? paymentMethod.First_Name__c.escapeXml() : '') + '</firstName>'
                                  +'<lastName>' + (String.isNotBlank(paymentMethod.Last_Name__c) ? paymentMethod.Last_Name__c.escapeXml() : '') + '</lastName>'
                                  +'<company>' + (String.isNotBlank(paymentMethod.Company__c) ? paymentMethod.Company__c : '') +'</company>'
                                  +'<address>' + (String.isNotBlank(paymentMethod.Billing_Street__c) ? paymentMethod.Billing_Street__c.escapeXml() : '') + '</address>'
                                  +'<city>' + (String.isNotBlank(paymentMethod.Billing_City__c) ? paymentMethod.Billing_City__c.escapeXml() : '') + '</city>'
                                  +'<state>' + (String.isNotBlank(paymentMethod.Billing_State__c) ? paymentMethod.Billing_State__c.escapeXml() : '') + '</state>'
                                  +'<zip>' + (String.isNotBlank(paymentMethod.Billing_Zip__c) ? paymentMethod.Billing_Zip__c.escapeXml() : '') + '</zip>'
                                  +'<country>' + (String.isNotBlank(paymentMethod.Billing_Country__c) ? paymentMethod.Billing_Country__c.escapeXml() : '') + '</country>'
                                  +'<phoneNumber>' + (String.isNotBlank(paymentMethod.Phone__c) ? paymentMethod.Phone__c.escapeXml() : '') +'</phoneNumber>'
                                  +'<faxNumber>' + (String.isNotBlank(paymentMethod.Fax__c) ? paymentMethod.Fax__c.escapeXml() : '') +'</faxNumber>'
                                +'</billTo>'
                                +'<payment>'
                                  +'<creditCard>'
                                    +'<cardNumber>' + paymentMethod.Card_Number__c + '</cardNumber>'
                                    +'<expirationDate>' + (String.isNotBlank(paymentMethod.Expiration_Date_Year__c) ? paymentMethod.Expiration_Date_Year__c : '') + '-' + (String.isNotBlank(paymentMethod.Expiration_Date_Month__c) ? paymentMethod.Expiration_Date_Month__c : '') + '</expirationDate>'
                                    + (String.isNotBlank(paymentMethod.Card_Code__c) ? '<cardCode>' + paymentMethod.Card_Code__c.escapeXml() + '</cardCode>' : '') 
                                  +'</creditCard>'
                                +'</payment>'
                                +'<defaultPaymentProfile>false</defaultPaymentProfile>'
                          +'</paymentProfile>'
                          +'<validationMode>liveMode</validationMode>'
         				+'</createCustomerPaymentProfileRequest>';
                response = AuthorizeConnector.putAuthorizeObject(org, xmlBody);
                if(response.getStatusCode() == 200 && response.getBody().contains('<resultCode>Ok</resultCode>')) paymentMethod.Authorize_ID__c = response.getBody().substringBetween('<customerPaymentProfileId>','</customerPaymentProfileId>');
                else paymentMethod.Authorize_Sync_Error__c = String.isNotBlank(response.getBody().substringBetween('<text>','</text>')) ? response.getBody().substringBetween('<text>','</text>').left(255) : response.getBody().left(255);
            }
            else{
                xmlBody = '<updateCustomerPaymentProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                            +'<merchantAuthentication>'
                                +'<name>' + AuthorizeNetList__c.getValues(org).Api_Login_ID__c + '</name>'
                                +'<transactionKey>' + AuthorizeNetList__c.getValues(org).Transaction_Key__c + '</transactionKey>'
                            +'</merchantAuthentication>'
        					+'<customerProfileId>' + (String.isNotBlank(paymentMethod.Account__r.Authorize_ID__c) ? paymentMethod.Account__r.Authorize_ID__c : '') + '</customerProfileId>'
                            +'<paymentProfile>'
            					+'<customerType>' + (String.isNotBlank(paymentMethod.Customer_Type__c) ? paymentMethod.Customer_Type__c.toLowerCase() : '') + '</customerType>'
                                +'<billTo>'
                                  +'<firstName>' + (String.isNotBlank(paymentMethod.First_Name__c) ? paymentMethod.First_Name__c.escapeXml() : '') + '</firstName>'
                                  +'<lastName>' + (String.isNotBlank(paymentMethod.Last_Name__c) ? paymentMethod.Last_Name__c.escapeXml() : '') + '</lastName>'
                                  +'<company>' + (String.isNotBlank(paymentMethod.Company__c) ? paymentMethod.Company__c : '') +'</company>'
                                  +'<address>' + (String.isNotBlank(paymentMethod.Billing_Street__c) ? paymentMethod.Billing_Street__c.escapeXml() : '') + '</address>'
                                  +'<city>' + (String.isNotBlank(paymentMethod.Billing_City__c) ? paymentMethod.Billing_City__c.escapeXml() : '') + '</city>'
                                  +'<state>' + (String.isNotBlank(paymentMethod.Billing_State__c) ? paymentMethod.Billing_State__c.escapeXml() : '') + '</state>'
                                  +'<zip>' + (String.isNotBlank(paymentMethod.Billing_Zip__c) ? paymentMethod.Billing_Zip__c.escapeXml() : '') + '</zip>'
                                  +'<country>' + (String.isNotBlank(paymentMethod.Billing_Country__c) ? paymentMethod.Billing_Country__c.escapeXml() : '') + '</country>'
                                  +'<phoneNumber>' + (String.isNotBlank(paymentMethod.Phone__c) ? paymentMethod.Phone__c.escapeXml() : '') +'</phoneNumber>'
                                  +'<faxNumber>' + (String.isNotBlank(paymentMethod.Fax__c) ? paymentMethod.Fax__c.escapeXml() : '') +'</faxNumber>'
                                +'</billTo>'
                                +'<payment>'
                                  +'<creditCard>'
                                    +'<cardNumber>' + paymentMethod.Card_Number__c + '</cardNumber>'
                                    +'<expirationDate>' + (String.isNotBlank(paymentMethod.Expiration_Date_Year__c) ? paymentMethod.Expiration_Date_Year__c : '') + '-' + (String.isNotBlank(paymentMethod.Expiration_Date_Month__c) ? paymentMethod.Expiration_Date_Month__c : '') + '</expirationDate>'
                                    + (String.isNotBlank(paymentMethod.Card_Code__c) ? '<cardCode>' + paymentMethod.Card_Code__c.escapeXml() +'</cardCode>' : '')
                                  +'</creditCard>'
                                +'</payment>'
                                +'<defaultPaymentProfile>false</defaultPaymentProfile>'
            					+'<customerPaymentProfileId>' + paymentMethod.Authorize_ID__c + '</customerPaymentProfileId>'
                          +'</paymentProfile>'
                          +'<validationMode>liveMode</validationMode>'
         				+'</updateCustomerPaymentProfileRequest>';
                response = AuthorizeConnector.putAuthorizeObject(org, xmlBody);
                if(response.getStatusCode() != 200 || (String.isNotBlank(response.getBody()) && !response.getBody().contains('<resultCode>Ok</resultCode>'))) paymentMethod.Authorize_Sync_Error__c = String.isNotBlank(response.getBody().substringBetween('<text>','</text>')) ? response.getBody().substringBetween('<text>','</text>').left(255) : response.getBody().left(255);
            }
            System.debug('xmlBody: ' + xmlBody);
            paymentMethod.Authorize_To_Sync__c = false;
        }
        List<Database.SaveResult> saveResults;
        if(!accountsToSendMap.values().isEmpty()){
            ApexUtil.isAccountTriggerInvoked = ApexUtil.isAuthorizeAccountTriggerInvoked = true;
            saveResults = Database.update(accountsToSendMap.values(), false);
            for(Database.SaveResult saveResult:saveResults) if(!saveResult.isSuccess()) for(Database.Error saveError : saveResult.getErrors()) System.debug('AuthorizePostCustomerPaymentsBatch - Account update Error: ' + saveError.getMessage());
        }
        ApexUtil.isAuthorizePaymentMethodTriggerInvoked = true;
        saveResults = Database.update(scope, false);
        for(Database.SaveResult saveResult:saveResults) if(!saveResult.isSuccess()) for(Database.Error saveError : saveResult.getErrors()) System.debug('AuthorizePostCustomerPaymentsBatch - PaymentMethod update Error: ' + saveError.getMessage());
    }
    global void finish(Database.BatchableContext BC){
    }
}