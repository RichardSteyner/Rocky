global class AuthorizeConnector{
    //public static AuthorizeNet__c authentication = AuthorizeNet__c.getOrgDefaults();
    webservice static String putTransaction(String opportunityId){
        Opportunity opportunity = [Select Id, Name, Primary_Clinic__c, AccountId, Amount, Invoice_Number__c, PO_Number__c, Discount_Amount__c, Shipping__c, Duty__c, Tax__c, Billing_First_Name__c, Billing_Last_Name__c, Billing_Company__c, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Zip__c, Billing_Country__c, Shipping_First_Name__c, Shipping_Last_Name__c, Shipping_Company__c, Shipping_Street__c, Shipping_City__c, Shipping_State__c, Shipping_Zip__c, Shipping_Country__c, Card_Number__c, Expiration_Date_Month__c, Expiration_Date_Year__c, Card_Code__c, Payment_Method__c, Payment_Method__r.Authorize_ID__c, Payment_Method__r.Account__r.Authorize_ID__c, Payment_Method__r.Card_Number__c, Payment_Method__r.Expiration_Date_Year__c, Payment_Method__r.Expiration_Date_Month__c, Payment_Method__r.Card_Code__c from Opportunity where id =:opportunityId];
        if(opportunity.Primary_Clinic__c == null || opportunity.Payment_Method__c == null || String.isBlank(opportunity.Payment_Method__r.Authorize_ID__c) || String.isBlank(opportunity.Payment_Method__r.Account__r.Authorize_ID__c) || opportunity.Amount == null){
            opportunity.Authorize_Payment_Status__c = 'Payment not processed';
            opportunity.Error_Message__c = 'The credit card information is invalid';
            update opportunity;
            
        System.debug(opportunity.Primary_Clinic__c);
            return 'The credit card information is invalid.';
        }
        if(String.isEmpty(opportunity.Invoice_Number__c)){
            /*opportunity.Authorize_Payment_Status__c = 'Payment not processed';
            opportunity.Error_Message__c = 'Invoice Number must be specified';
            update opportunity;
            return 'Please specify the Invoice Number.';*/
            try{
				opportunity.Invoice_Number__c = 'IN-' + opportunity.Name.left(6);
            }catch(Exception e){
                system.debug(opportunity.Invoice_Number__c + ':' + e.getMessage());
            }
        }
        String org = opportunity.Primary_Clinic__c;
        //replace Sandbox to Northeast_Dedham
        String primaryClinic = getPrimaryClinic(org);
        if(String.isEmpty(primaryClinic)){
            return 'Primary clinic value is invalid.!';
        }
        if(AuthorizeNetList__c.getValues(primaryClinic) == null){
            return 'Custom Settings error.!';
        }
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        String items='';
        for(OpportunityLineItem oli : [Select Id, Authorize_ID__c, Item_Id__c, Quantity, UnitPrice, Description, Product2Id, Product2.Name, OpportunityId FROM OpportunityLineItem WHERE OpportunityId =:opportunity.id]) {
            if(String.isBlank(oli.Item_Id__c)){
                oli.Authorize_ID__c = opportunity.Invoice_Number__c + '-' + oli.Id;
                oli.Item_Id__c = oli.Id;
                olis.add(oli);
            } 
            items += '<lineItem>'
                        +'<itemId>' + oli.Item_Id__c + '</itemId>'
                        +'<name>' + oli.Product2.Name.left(31) + '</name>'
                        +'<description>' + oli.Description + '</description>'
                        +'<quantity>' + oli.Quantity + '</quantity>'
                        +'<unitPrice>' + oli.UnitPrice + '</unitPrice>'
                     +'</lineItem>';
        }
        String xmlBody = '<createTransactionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                            +'<merchantAuthentication>'
                                +'<name>' + AuthorizeNetList__c.getValues(primaryClinic).Api_Login_ID__c + '</name>'
                                +'<transactionKey>' + AuthorizeNetList__c.getValues(primaryClinic).Transaction_Key__c + '</transactionKey>'
                            +'</merchantAuthentication>'
                            +'<refId>' + opportunity.id + '</refId>'
                            +'<transactionRequest>'
                                +'<transactionType>authCaptureTransaction</transactionType>'
                                +'<amount>' + opportunity.Amount + '</amount>'
                                +'<profile>'
                                    +'<customerProfileId>' + opportunity.Payment_Method__r.Account__r.Authorize_ID__c + '</customerProfileId>'
                                    +'<paymentProfile>'
                                        +'<paymentProfileId>' + opportunity.Payment_Method__r.Authorize_ID__c + '</paymentProfileId>'
                                    +'</paymentProfile>'
                                +'</profile>'
                                +'<order>'
                                    +'<invoiceNumber>' + opportunity.Invoice_Number__c + '</invoiceNumber>'
                                    +'<description>' + opportunity.Name.escapeXml() + '</description>'
                                +'</order>'
                                +'<lineItems>'
                                    +items
                                +'</lineItems>'
                                +'<tax>'
                                    +'<amount>' + (opportunity.Tax__c != null ? String.valueOf(opportunity.Tax__c) : '0.00') + '</amount>'
                                +'</tax>'
                                +'<duty>'
                                    +'<amount>' + (opportunity.Duty__c != null ? String.valueOf(opportunity.Duty__c) : '0.00') + '</amount>'
                                +'</duty>'
                                +'<shipping>'
                                    +'<amount>' + (opportunity.Shipping__c != null ? String.valueOf(opportunity.Shipping__c) : '0.00') + '</amount>'
                                +'</shipping>'
                                +'<poNumber>' + (String.isNotBlank(opportunity.PO_Number__c) ? opportunity.PO_Number__c : '') + '</poNumber>'
                                +'<shipTo>'
                                    +'<firstName>' + (String.isNotBlank(opportunity.Shipping_First_Name__c) ? opportunity.Shipping_First_Name__c : '') + '</firstName>'
                                    +'<lastName>' + (String.isNotBlank(opportunity.Shipping_Last_Name__c) ? opportunity.Shipping_Last_Name__c : '') + '</lastName>'
                                    +'<company>' + (String.isNotBlank(opportunity.Shipping_Company__c) ? opportunity.Shipping_Company__c : '') + '</company>'
                                    +'<address>' + (String.isNotBlank(opportunity.Shipping_Street__c) ? opportunity.Shipping_Street__c : '') + '</address>'
                                    +'<city>' + (String.isNotBlank(opportunity.Shipping_City__c) ? opportunity.Shipping_City__c : '') + '</city>'
                                    +'<state>' + (String.isNotBlank(opportunity.Shipping_State__c) ? opportunity.Shipping_State__c : '') + '</state>'
                                    +'<zip>' + (String.isNotBlank(opportunity.Shipping_Zip__c) ? opportunity.Shipping_Zip__c : '') + '</zip>'
                                    +'<country>' + (String.isNotBlank(opportunity.Shipping_Country__c) ? opportunity.Shipping_Country__c : '') + '</country>'
                                +'</shipTo>'
                            +'</transactionRequest>'
                        +'</createTransactionRequest>';
        System.debug('xmlBody: ' + xmlBody);
        httprequest request = new httprequest();
        request.setEndpoint(AuthorizeNetList__c.getValues(primaryClinic).EndPoint__c);
		request.setBody(xmlBody);
		request.setmethod('PUT');
		request.setTimeout(120000);
		Http http = new Http();
        HTTPResponse response = new HTTPResponse();
        if(!Test.isRunningTest()) response = http.send(request);
        else{
            String xmlResponse = '{"status":"This transaction has been approved"}';
            response.setBody(xmlResponse);
            response.setStatusCode(200);
        }
        Payment__c payment;
        if(response.getBody().contains('This transaction has been approved')){
            payment = new Payment__c(RecordTypeId = Schema.SObjectType.Payment__c.getRecordTypeInfosByName().get('Authorize.Net') != null ? Schema.SObjectType.Payment__c.getRecordTypeInfosByName().get('Authorize.Net').getRecordTypeId() : null);
            payment.Authorize_ID__c = response.getBody().substringBetween('<transId>','</transId>');
            payment.Opportunity__c = opportunity.id;
            payment.Account__c = opportunity.AccountId;
            payment.Payment_Method__c = opportunity.Payment_Method__c;
            payment.Submit_Date_Time__c = Datetime.now();
            payment.Transaction_Type__c = 'authCaptureTransaction';
            payment.Transaction_Status__c = 'Captured/Pending Settlement';
            payment.Authorization_Code__c = response.getBody().substringBetween('<authCode>','</authCode>');
            payment.Address_Verification_Status__c = response.getBody().substringBetween('<avsResultCode>', '</avsResultCode>') == 'Y' ? 'Street Address: Match Zip: Matched first 5 digits' : response.getBody().substringBetween('<avsResultCode>', '</avsResultCode>') == 'A' ? 'Street Address matches, ZIP code does not' : response.getBody().substringBetween('<avsResultCode>', '</avsResultCode>') == 'E' ? 'AVS error' : response.getBody().substringBetween('<avsResultCode>', '</avsResultCode>') == 'B' ? 'Address information not provided for AVS check' : response.getBody().substringBetween('<avsResultCode>', '</avsResultCode>') == 'N' ? 'No match on Street Address and ZIP code' : response.getBody().substringBetween('<avsResultCode>', '</avsResultCode>') == 'W' ? '9 digit ZIP code matches, Street Address does not' : response.getBody().substringBetween('<avsResultCode>', '</avsResultCode>') == 'Z' ? '5 digit ZIP matches, Street Address does not' : response.getBody().substringBetween('<avsResultCode>', '</avsResultCode>');
            payment.Amount__c = payment.Settlement_Amount__c = opportunity.Amount;
            opportunity.Authorize_ID__c = response.getBody().substringBetween('<transId>','</transId>');
            opportunity.Authorize_Payment_Status__c = 'Payment processed';
            opportunity.Error_Message__c = '';
        }
        else{
            opportunity.Authorize_Payment_Status__c = 'Payment not processed';
            opportunity.Error_Message__c = response.getBody().contains('<responseCode>2</responseCode>') ? 'Card declined' : String.isNotEmpty(response.getBody().substringBetween('<text>','</text>')) ? response.getBody().substringBetween('<text>','</text>') : String.isNotEmpty(response.getBody().substringBetween('<errorText>','</errorText>')) ? response.getBody().substringBetween('<errorText>','</errorText>') : 'The transaction was unsuccessful.';
        }
        try{ 
            update opportunity;
            if(!olis.isEmpty()) update olis;
            if(payment != null) upsert payment Authorize_ID__c;
        }
        catch(Dmlexception e){
            System.debug('AuthorizeConnector - Payment upsert Error: :'+e.getMessage());
        }
        System.debug('###AuthorizeConnector.putTransaction(opportunityid = ' + opportunityId + ') => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody() : ''));
        return String.isNotEmpty(response.getBody().substringBetween('<description>','</description>')) ? response.getBody().substringBetween('<description>','</description>') : response.getBody().contains('<responseCode>2</responseCode>') ? 'Card declined' : String.isNotEmpty(response.getBody().substringBetween('<text>','</text>')) ? response.getBody().substringBetween('<text>','</text>') : String.isNotEmpty(response.getBody().substringBetween('<errorText>','</errorText>')) ? response.getBody().substringBetween('<errorText>','</errorText>') : 'The transaction was unsuccessful.';
    }
    webservice static String putSubscription(String opportunityId){
        Opportunity opportunity = [Select Id, Name, Primary_Clinic__c, Amount, Down_Payment__c, Invoice_Number__c, Authorize_Subscription_ID__c, Authorize_Payment_Frecuency__c, Authorize_Subscription_Status__c, Authorize_Payment_Start_Date__c, Authorize_Total_Occurrences__c, Authorize_No_End_Date__c, Payment_Method__c, Payment_Method__r.Authorize_ID__c, Payment_Method__r.Account__r.Authorize_ID__c from Opportunity where id =:opportunityId];
        if(opportunity.Primary_Clinic__c == null || opportunity.Payment_Method__c == null || String.isBlank(opportunity.Payment_Method__r.Authorize_ID__c) || String.isBlank(opportunity.Payment_Method__r.Account__r.Authorize_ID__c) || opportunity.Amount == null || opportunity.Authorize_Total_Occurrences__c ==null) return 'The credit card information is invalid.';
        if(String.isEmpty(opportunity.Invoice_Number__c)) { //return 'Please specify the Invoice Number.';
        	try{
				opportunity.Invoice_Number__c = 'IN-' + opportunity.Name.left(6);
            }catch(Exception e){
                system.debug(opportunity.Invoice_Number__c + ':' + e.getMessage());
            }
        }
        String org = opportunity.Primary_Clinic__c;
        //replace Sandbox to Northeast_Dedham
        String primaryClinic = getPrimaryClinic(org);
        if(String.isEmpty(primaryClinic)){
            return 'Primary clinic value is invalid.!';
        }
        if(AuthorizeNetList__c.getValues(primaryClinic) == null){
            return 'Custom Settings error.!';
        }
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        String xmlBody;
        If(String.isEmpty(opportunity.Authorize_Subscription_ID__c)) xmlBody = '<ARBCreateSubscriptionRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                            +'<merchantAuthentication>'
                                +'<name>' + AuthorizeNetList__c.getValues(primaryClinic).Api_Login_ID__c + '</name>'
                                +'<transactionKey>' + AuthorizeNetList__c.getValues(primaryClinic).Transaction_Key__c + '</transactionKey>'
                            +'</merchantAuthentication>'
                            +'<refId>' + opportunity.id + '</refId>'
                        	+'<subscription>'
                        		+'<name>Subscription for ' + opportunity.Invoice_Number__c.escapeXml() + '</name>'
                        		+'<paymentSchedule>'
                        			+'<interval>'
                        				+'<length>' + (opportunity.Authorize_Payment_Frecuency__c == 'Once' || opportunity.Authorize_Payment_Frecuency__c == 'Weekly' ? '7' : opportunity.Authorize_Payment_Frecuency__c == 'Biweekly' ? '14' : opportunity.Authorize_Payment_Frecuency__c == 'Monthly' ? '1' : opportunity.Authorize_Payment_Frecuency__c == 'Bimonthly' ? '2' : opportunity.Authorize_Payment_Frecuency__c == 'Quarterly' ? '3' : opportunity.Authorize_Payment_Frecuency__c == 'Annual' ? '12' : '') + '</length>'
                        				+'<unit>' + (opportunity.Authorize_Payment_Frecuency__c == 'Once' || opportunity.Authorize_Payment_Frecuency__c == 'Weekly' || opportunity.Authorize_Payment_Frecuency__c == 'Biweekly' ? 'days' : 'months') + '</unit>'
                        			+'</interval>'
                        			+'<startDate>' + String.valueOf(opportunity.Authorize_Payment_Start_Date__c) + '</startDate>'
                        			+'<totalOccurrences>' + String.valueOf(opportunity.Authorize_Total_Occurrences__c) + '</totalOccurrences>'
            						+'<trialOccurrences>' + ((opportunity.Down_Payment__c != null && opportunity.Down_Payment__c > 0) ? '1' : '0') + '</trialOccurrences>'
                        		+'</paymentSchedule>'
                        		+'<amount>' + ((opportunity.Down_Payment__c != null && opportunity.Down_Payment__c > 0) ? String.valueOf(((opportunity.Amount - opportunity.Down_Payment__c)/opportunity.Authorize_Total_Occurrences__c).setScale(2)) : String.valueOf((opportunity.Amount/opportunity.Authorize_Total_Occurrences__c.setScale(2)))) + '</amount>'
            					+'<trialAmount>' + ((opportunity.Down_Payment__c != null && opportunity.Down_Payment__c > 0) ? String.valueOf(opportunity.Down_Payment__c) : '') + '</trialAmount>'
                                +'<order>'
                                    +'<invoiceNumber>' + opportunity.Invoice_Number__c.escapeXml() + '</invoiceNumber>'
                                    +'<description>' + opportunity.Name.escapeXml() + '</description>'
                                +'</order>'
                                +'<profile>'
                                  +'<customerProfileId>' + opportunity.Payment_Method__r.Account__r.Authorize_ID__c + '</customerProfileId>'
                                  +'<customerPaymentProfileId>' + opportunity.Payment_Method__r.Authorize_ID__c + '</customerPaymentProfileId>'
                                +'</profile>'
                        	+'</subscription>'
                        +'</ARBCreateSubscriptionRequest>';
        else  xmlBody = '<ARBUpdateSubscriptionRequest  xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                            +'<merchantAuthentication>'
                                +'<name>' + AuthorizeNetList__c.getValues(primaryClinic).Api_Login_ID__c + '</name>'
                                +'<transactionKey>' + AuthorizeNetList__c.getValues(primaryClinic).Transaction_Key__c + '</transactionKey>'
                            +'</merchantAuthentication>'
                            +'<refId>' + opportunity.id + '</refId>'
                            +'<subscriptionId>' + opportunity.Authorize_Subscription_ID__c + '</subscriptionId>'
                        	+'<subscription>'
                        		+'<name>Subscription for ' + opportunity.Invoice_Number__c.escapeXml() + '</name>'
                        		+'<paymentSchedule>'
                        			+'<interval>'
                        				+'<length>' + (opportunity.Authorize_Payment_Frecuency__c == 'Once' || opportunity.Authorize_Payment_Frecuency__c == 'Weekly' ? '7' : opportunity.Authorize_Payment_Frecuency__c == 'Biweekly' ? '14' : opportunity.Authorize_Payment_Frecuency__c == 'Monthly' ? '1' : opportunity.Authorize_Payment_Frecuency__c == 'Bimonthly' ? '2' : opportunity.Authorize_Payment_Frecuency__c == 'Quarterly' ? '3' : opportunity.Authorize_Payment_Frecuency__c == 'Annual' ? '12' : '') + '</length>'
                        				+'<unit>' + (opportunity.Authorize_Payment_Frecuency__c == 'Once' || opportunity.Authorize_Payment_Frecuency__c == 'Weekly' || opportunity.Authorize_Payment_Frecuency__c == 'Biweekly' ? 'days' : 'months') + '</unit>'
                        			+'</interval>'
                        			+'<startDate>' + String.valueOf(opportunity.Authorize_Payment_Start_Date__c) + '</startDate>'
                        			+'<totalOccurrences>' + String.valueOf(opportunity.Authorize_Total_Occurrences__c) + '</totalOccurrences>'
            						+'<trialOccurrences>' + ((opportunity.Down_Payment__c != null && opportunity.Down_Payment__c > 0) ? '1' : '0') + '</trialOccurrences>'
                        		+'</paymentSchedule>'
                        		+'<amount>' + ((opportunity.Down_Payment__c != null && opportunity.Down_Payment__c > 0) ? String.valueOf(((opportunity.Amount - opportunity.Down_Payment__c)/opportunity.Authorize_Total_Occurrences__c).setScale(2)) : String.valueOf((opportunity.Amount/opportunity.Authorize_Total_Occurrences__c.setScale(2)))) + '</amount>'
                                +'<trialAmount>' + ((opportunity.Down_Payment__c != null && opportunity.Down_Payment__c > 0) ? String.valueOf(opportunity.Down_Payment__c) : '') + '</trialAmount>'
            					+'<order>'
                                    +'<invoiceNumber>' + opportunity.Invoice_Number__c.escapeXml() + '</invoiceNumber>'
                                    +'<description>' + opportunity.Name.escapeXml() + '</description>'
                                +'</order>'
                                +'<profile>'
                                  +'<customerProfileId>' + opportunity.Payment_Method__r.Account__r.Authorize_ID__c + '</customerProfileId>'
                                  +'<customerPaymentProfileId>' + opportunity.Payment_Method__r.Authorize_ID__c + '</customerPaymentProfileId>'
                                +'</profile>'
                        	+'</subscription>'
                        +'</ARBUpdateSubscriptionRequest >';
        System.debug('putSubscription - xmlBody: ' + xmlBody);
        httprequest request = new httprequest();
        request.setEndpoint(AuthorizeNetList__c.getValues(primaryClinic).EndPoint__c);
		request.setBody(xmlBody);
		request.setmethod('PUT');
		request.setTimeout(120000);
		Http http = new Http();
        HTTPResponse response = new HTTPResponse();
        try{
            if(!Test.isRunningTest()) response = http.send(request);
            else{
                String xmlResponse = '{"status":"This transaction has been approved"}';
                response.setBody(xmlResponse);
                response.setStatusCode(200);
            }
            System.debug('###AuthorizeConnector.putSubscription() => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody() : ''));
        }
        catch(Exception e){
            response = new HTTPResponse();
            response.setStatusCode(500);
            response.setBody(e.getMessage());
            System.debug('###AuthorizeConnector.putSubscription() - Callout Exception: ' + e.getMessage());
        }
        if(response.getStatusCode() == 200 && response.getBody().contains('<resultCode>Ok</resultCode>')){
            if(String.isEmpty(opportunity.Authorize_Subscription_ID__c)){
                opportunity.Authorize_Subscription_ID__c = response.getBody().substringBetween('<subscriptionId>','</subscriptionId>');
                opportunity.Authorize_Subscription_Status__c = 'Active';                
            }
        }
        else return String.isNotBlank(response.getBody().substringBetween('<text>','</text>')) ? response.getBody().substringBetween('<text>','</text>').left(255) : String.isNotEmpty(response.getBody().substringBetween('<errorText>','</errorText>')) ? response.getBody().substringBetween('<errorText>','</errorText>') : 'An internal error has occurred. Please contact your Administrator.<br/>' + response.getBody().left(255);
        try{ 
            update opportunity;
        }
        catch(Dmlexception e){
            System.debug('AuthorizeConnector - opportunity Update Error: :' + e.getMessage());
            return 'An error occurred while recording to Database your Subscription data. Please contact your Administrator.<br/>' + response.getBody().left(255);
        }
        System.debug('###AuthorizeConnector.putTransaction(opportunityid = ' + opportunityId + ') => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody() : ''));
        return 'Subscription ' + opportunity.Authorize_Subscription_ID__c + ' has been successfully ' + (xmlBody.contains('ARBCreateSubscriptionRequest') ? 'created' : 'updated') + '. Your ' + (opportunity.Authorize_Payment_Frecuency__c != 'Once' ? 'first ' : '') + 'payment for this subscription will be on ' + opportunity.Authorize_Payment_Start_Date__c.format() + '.';
    }
    public static List<Dom.XmlNode> getAuthorizeObject(AuthorizeNetList__c auth, String authorizeObject, Map<String, String> authorizeIds){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(auth.EndPoint__c);
		request.setmethod('PUT');
		request.setTimeout(120000);
		String xmlBody = '';
		if(authorizeObject == 'CustomerProfile') xmlBody = '<getCustomerProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                                                              +'<merchantAuthentication>'
                                                                +'<name>' + auth.Api_Login_ID__c + '</name>'
                                                                +'<transactionKey>' + auth.Transaction_Key__c + '</transactionKey>'
                                                              +'</merchantAuthentication>'
                                                              +'<customerProfileId>' + (!authorizeIds.values().isEmpty() ? authorizeIds.get('customerProfileId') : '') + '</customerProfileId>'
                                                              +'<includeIssuerInfo>true</includeIssuerInfo>'
                                                            +'</getCustomerProfileRequest>';
        else if(authorizeObject == 'CustomerPaymentProfile') xmlBody = '<getCustomerPaymentProfileRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                                                                          +'<merchantAuthentication>'
                                                                            +'<name>' + auth.Api_Login_ID__c + '</name>'
                                                                            +'<transactionKey>' + auth.Transaction_Key__c + '</transactionKey>'
                                                                          +'</merchantAuthentication>'
                                                                          +'<customerProfileId>' + (!authorizeIds.values().isEmpty() ? authorizeIds.get('customerProfileId') : '') + '</customerProfileId>'
                                                                          +'<customerPaymentProfileId>' + (!authorizeIds.values().isEmpty() ? authorizeIds.get('customerPaymentProfileId') : '') + '</customerPaymentProfileId>'
                                                                          +'<unmaskExpirationDate>true</unmaskExpirationDate>'
                                                                          +'<includeIssuerInfo>true</includeIssuerInfo>'
                                                                        +'</getCustomerPaymentProfileRequest>';
        else if(authorizeObject == 'TransactionDetails') xmlBody = '<getTransactionDetailsRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                                                                          +'<merchantAuthentication>'
                                                                            +'<name>' + auth.Api_Login_ID__c + '</name>'
                                                                            +'<transactionKey>' + auth.Transaction_Key__c + '</transactionKey>'
                                                                          +'</merchantAuthentication>'
                                                                          +'<transId>' + (!authorizeIds.values().isEmpty() ? authorizeIds.get('transId') : '') + '</transId>'
                                                                        +'</getTransactionDetailsRequest>';
		request.setBody(xmlBody);
		Http http = new Http();
        HTTPResponse response = new HTTPResponse();
        try{
            if(!Test.isRunningTest()) response = http.send(request);
            else{
                String xmlResponse = '{"status":"This transaction has been approved"}';
                if(authorizeObject == 'CustomerProfile') xmlResponse = '<getCustomerProfileResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd" xmlns:xsd="https://www.w3.org/2001/XMLSchema" xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><profile><merchantCustomerId>CUST001</merchantCustomerId><description>Profile created by Subscription:3078153</description><email>joe@mail.com</email><customerProfileId>39598611</customerProfileId><paymentProfiles><customerType>individual</customerType><billTo><firstName>John</firstName><lastName>Smith</lastName></billTo><defaultPaymentProfile>true</defaultPaymentProfile><customerPaymentProfileId>35936989</customerPaymentProfileId><payment><creditCard><cardNumber>XXXX1111</cardNumber><expirationDate>XXXX</expirationDate><cardType>Visa</cardType><issuerNumber>411111</issuerNumber><isPaymentToken>true</isPaymentToken></creditCard></payment></paymentProfiles></profile><subscriptionIds><subscriptionId>3078153</subscriptionId><subscriptionId>3078154</subscriptionId></subscriptionIds></getCustomerProfileResponse>';
                else if(authorizeObject == 'CustomerPaymentProfile') xmlResponse = '<getCustomerPaymentProfileResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd" xmlns:xsd="https://www.w3.org/2001/XMLSchema" xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><paymentProfile><customerType>individual</customerType><billTo><firstName>John</firstName><lastName>Smith</lastName></billTo><customerProfileId>39598611</customerProfileId><customerPaymentProfileId>35936989</customerPaymentProfileId><payment><creditCard><cardNumber>XXXX1111</cardNumber><expirationDate>XXXX</expirationDate><cardType>Visa</cardType><issuerNumber>411111</issuerNumber><isPaymentToken>true</isPaymentToken></creditCard></payment><subscriptionIds><subscriptionId>3078153</subscriptionId><subscriptionId>3078154</subscriptionId></subscriptionIds></paymentProfile></getCustomerPaymentProfileResponse>';
                else if(authorizeObject == 'TransactionDetails') xmlResponse = '<getTransactionDetailsResponse xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><transaction><transId>40022826172</transId><submitTimeUTC>2018-12-14T08:54:33.177Z</submitTimeUTC><submitTimeLocal>2018-12-14T00:54:33.177</submitTimeLocal><transactionType>authCaptureTransaction</transactionType><transactionStatus>pendingFinalSettlement</transactionStatus><responseCode>1</responseCode><responseReasonCode>1</responseReasonCode><profile><customerProfileId>654</customerProfileId><customerPaymentProfileId>321</customerPaymentProfileId></profile><customer><id>123</id><email>test@test.com</email><type>Individual</type></customer><order><invoiceNumber>15415</invoiceNumber><purchaseOrderNumber>48415</purchaseOrderNumber><description>test</description><discountAmount>230</discountAmount></order><subscription><id>5486668</id><payNum>1</payNum></subscription><responseReasonDescription>Approval</responseReasonDescription><authCode>12CD56</authCode><AVSResponse>Y</AVSResponse><cardCodeResponse>M</cardCodeResponse><batch><batchId>8863437</batchId><settlementTimeUTC>2018-12-14T15:12:19.473Z</settlementTimeUTC><settlementTimeLocal>2018-12-14T07:12:19.473</settlementTimeLocal><settlementState>settlementError</settlementState></batch><authAmount>10.29</authAmount><settleAmount>10.29</settleAmount><taxExempt>false</taxExempt><payment><creditCard><cardNumber>XXXX1111</cardNumber><expirationDate>XXXX</expirationDate><cardType>Visa</cardType></creditCard></payment><billTo><firstName>Iam</firstName><lastName>Testing</lastName><address>123</address><zip>98004</zip><country>New</country></billTo><shipTo><firstName>Iam</firstName><lastName>Testing</lastName><address>123</address><zip>98004</zip><country>New</country></shipTo><recurringBilling>false</recurringBilling><product>Card Not Present</product><marketType>eCommerce</marketType><networkTransId>123456789 NNN H</networkTransId></transaction></getTransactionDetailsResponse>';
                response.setBody(xmlResponse);
                response.setStatusCode(200);
            }
        	System.debug('###AuthorizeConnector.getAuthorizeObject(Account = ' + auth.Name + ', authorizeObject = ' + authorizeObject + ', authorizeIds = ' +  authorizeIds + ') => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody() : ''));
        }
        catch(Exception e){
            response = new HTTPResponse();
            response.setStatusCode(500);
            System.debug('###AuthorizeConnector.getAuthorizeObject(Account = ' + auth.Name + ', authorizeObject = ' + authorizeObject + ', authorizeIds = ' +  authorizeIds + ') - Callout Exception: ' + e.getMessage());
        }
        return response.getStatusCode() == 200 && response.getBody().contains('<resultCode>Ok</resultCode>') ? xmlParser(response.getBody()) : new List<Dom.XmlNode>();
    }     
    public static HTTPResponse putAuthorizeObject(String org, String xmlBody){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(AuthorizeNetList__c.getValues(org).EndPoint__c);
		request.setBody(xmlBody);
		request.setMethod('PUT'); 
		request.setTimeout(120000);
		Http http = new Http();
        HTTPResponse response = new HTTPResponse();
        try{
            if(!Test.isRunningTest()) response = http.send(request);
            else{
                String xmlResponse = '{"status":"This transaction has been approved"}';
                response.setBody(xmlResponse);
                response.setStatusCode(200);
            }
            System.debug('###AuthorizeConnector.putAuthorizeObject() => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody() : ''));
        }
        catch(Exception e){
            response = new HTTPResponse();
            response.setStatusCode(500);
            response.setBody(e.getMessage());
            System.debug('###AuthorizeConnector.putAuthorizeObject - Callout Exception: ' + e.getMessage());
        }
        return response;
    }
    /*public static HttpResponse getSettledBatchListRequest(){
		String xmlBody = '<getSettledBatchListRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                                +'<merchantAuthentication>'
                                    +'<name>' + authentication.Api_Login_ID__c + '</name>'
                                    +'<transactionKey>' + authentication.Transaction_Key__c + '</transactionKey>'
                                +'</merchantAuthentication>'
                                +'<includeStatistics>false</includeStatistics>'
         				 +'</getSettledBatchListRequest>';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(authentication.EndPoint__c);
		request.setBody(xmlBody);
		request.setmethod('PUT');
		request.setTimeout(120000);
		Http http = new Http();
        HTTPResponse response = new HTTPResponse();
        if(!Test.isRunningTest()) response = http.send(request);
        else{
            String xmlResponse = '<?xml version="1.0" encoding="utf-8"?> <getSettledBatchListResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">  <messages><resultCode>  Ok</resultCode><message>  <code>I00001  </code>  <text>Successful.  </text></message>  </messages>  <batchList><batch>  <batchId>7367705  </batchId>  <settlementTimeUTC>2017-08-08T02:00:24Z  </settlementTimeUTC>  <settlementTimeLocal>2017-08-07T19:00:24  </settlementTimeLocal>  <settlementState>settledSuccessfully  </settlementState>  <paymentMethod>creditCard  </paymentMethod>  <marketType>eCommerce  </marketType>  <product>Card Not Present  </product></batch><batch>  <batchId>7370828  </batchId>  <settlementTimeUTC>2017-08-09T01:55:32Z  </settlementTimeUTC>  <settlementTimeLocal>2017-08-08T18:55:32  </settlementTimeLocal>  <settlementState>settledSuccessfully  </settlementState>  <paymentMethod>creditCard  </paymentMethod>  <marketType>eCommerce  </marketType>  <product>Card Not Present  </product></batch>  </batchList></getSettledBatchListResponse>';
            response.setBody(xmlResponse);
            response.setStatusCode(200);
        }
        System.debug(response.getBody());
        return response;
    }     
    public static HttpResponse getUnsettledTransactionListRequest(){
        String xmlBody = '<getUnsettledTransactionListRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                                +'<merchantAuthentication>'
                                    +'<name>' + authentication.Api_Login_ID__c + '</name>'
                                    +'<transactionKey>' + authentication.Transaction_Key__c + '</transactionKey>'
                                +'</merchantAuthentication>'
             				+'</getUnsettledTransactionListRequest>';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(authentication.EndPoint__c);
		request.setBody(xmlBody);
		request.setmethod('PUT');
		request.setTimeout(120000);
		Http http = new Http();
        HTTPResponse response = new HTTPResponse();
        if(!Test.isRunningTest()) response = http.send(request);
        else{
            String xmlResponse = '<?xml version="1.0" encoding="utf-8"?><getUnsettledTransactionListResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><transactions><transaction><transId>60039527873</transId><submitTimeUTC>2018-01-31T19:56:44Z</submitTimeUTC><submitTimeLocal>2018-01-31T11:56:44</submitTimeLocal><transactionStatus>authorizedPendingCapture</transactionStatus><invoiceNumber>I-01150</invoiceNumber><accountType>Visa</accountType><accountNumber>XXXX0027</accountNumber><settleAmount>100.00</settleAmount><marketType>eCommerce</marketType><product>Card Not Present</product></transaction></transactions><totalNumInResultSet>1</totalNumInResultSet></getUnsettledTransactionListResponse>';
            response.setBody(xmlResponse);
            response.setStatusCode(200);
        }
        System.debug(response.getBody());
        return response;
    }    
    public static HttpResponse getTransactionListRequest(String batchId){
        String xmlBody = '<getTransactionListRequest xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd">'
                                +'<merchantAuthentication>'
                                    +'<name>' + authentication.Api_Login_ID__c + '</name>'
                                    +'<transactionKey>' + authentication.Transaction_Key__c + '</transactionKey>'
                                +'</merchantAuthentication>'
                                +'<batchId>'+batchId+'</batchId>'
             				+'</getTransactionListRequest>';
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(authentication.EndPoint__c);
		request.setBody(xmlBody);
		request.setmethod('PUT');
		request.setTimeout(120000);
		Http http = new Http();
        HTTPResponse response = new HTTPResponse();
        if(!Test.isRunningTest()) response = http.send(request);
        else{
            String xmlResponse = '<?xml version="1.0" encoding="utf-8"?><getTransactionListResponse xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="AnetApi/xml/v1/schema/AnetApiSchema.xsd"><messages><resultCode>Ok</resultCode><message><code>I00001</code><text>Successful.</text></message></messages><transactions><transaction><transId>60027721489</transId><submitTimeUTC>2017-08-07T16:59:13Z</submitTimeUTC><submitTimeLocal>2017-08-07T09:59:13</submitTimeLocal><transactionStatus>settledSuccessfully</transactionStatus><invoiceNumber>1001</invoiceNumber><firstName>FirstName01</firstName><lastName>LastName01</lastName><accountType>Visa</accountType><accountNumber>XXXX0027</accountNumber><settleAmount>20.00</settleAmount><marketType>eCommerce</marketType><product>Card Not Present</product></transaction></transactions><totalNumInResultSet>1</totalNumInResultSet></getTransactionListResponse>';
            response.setBody(xmlResponse);
            response.setStatusCode(200);
        }
        System.debug(response.getBody());
        return response;
    }*/
    public static List<Dom.XmlNode> xmlParser(String strXml){
        Dom.Document document = new Dom.Document();
        document.load(strXml);
        return document.getRootElement().getChildElements();
    }
    public static String getPrimaryClinic(String orgAuth){
        String primaryClinicRespuesta = !orgAuth.equalsIgnoreCase('Castle Rock') ? (!orgAuth.equalsIgnoreCase('Colorado Springs') ? (!orgAuth.equalsIgnoreCase('Central Denver') ? (!orgAuth.equalsIgnoreCase('North Denver') ? (!orgAuth.equalsIgnoreCase('Northeast Mens Clinic') ? (!orgAuth.equalsIgnoreCase('Northeast Mens Clinic - Dedham') ? (!orgAuth.equalsIgnoreCase('Baton Rouge Mens Clinic') ? '' : 'Baton') : 'Northeast_Dedham') : 'Northeast') : 'Denver North') : 'Denver Central') : 'Colorado Springs') : 'CastleRock';
        return primaryClinicRespuesta;
    }
}