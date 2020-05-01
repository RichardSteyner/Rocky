@RestResource(urlMapping='/AuthorizeDedhamCustomerPaymentWebHook/*')
global without sharing class AuthorizeDedhamCustomerPaymentWebHook{
    @HttpPost
    global static void AuthorizeCustomer() {
        System.debug('###AuthorizeCustomerPaymentWebHook-RestContext.request.signature: ' + RestContext.request.headers.get('X-ANET-Signature'));
        System.debug('###AuthorizeCustomerPaymentWebHook-RestContext.request.body: ' + RestContext.request.requestBody.ToString());
        if(RestContext.request.requestBody != null && RestContext.request.requestBody.ToString().contains('"customerPaymentProfile"')){
            Map<String, Account> accountsMap = new Map<String, Account>();
            Payment_Method__c paymentMethod = new Payment_Method__c();
            for(Dom.XmlNode childElement1:AuthorizeConnector.getAuthorizeObject((AuthorizeNetList__c.getValues('Northeast_Dedham') != null ? AuthorizeNetList__c.getValues('Northeast_Dedham') : new AuthorizeNetList__c()), 'customerPaymentProfile', new Map<String, String>{'customerProfileId' => String.valueOf((Long) ((Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.ToString())).get('payload')).get('customerProfileId')), 'customerPaymentProfileId' => (String) ((Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.ToString())).get('payload')).get('id')})){
                if(childElement1.getName() == 'paymentProfile') for(Dom.XmlNode childElement2:childElement1.getChildElements()){
                    if(childElement2.getName() == 'customerPaymentProfileId') paymentMethod.Authorize_ID__c = childElement2.getText();
                    else if(childElement2.getName() == 'customerProfileId'){paymentMethod.Customer_Id__c = childElement2.getText();accountsMap.put(childElement2.getText(), new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null));}
                    else if(childElement2.getName() == 'customerType') paymentMethod.Customer_Type__c = childElement2.getText();
                    else if(childElement2.getName() == 'billTo') for(Dom.XMLNode childElement3:childElement2.getChildElements()){
                        if(childElement3.getName() == 'firstName') paymentMethod.First_Name__c = childElement3.getText();                        
                        else if(childElement3.getName() == 'lastName') paymentMethod.Last_Name__c = childElement3.getText();
                        else if(childElement3.getName() == 'company') paymentMethod.Company__c = childElement3.getText();
                        else if(childElement3.getName() == 'address') paymentMethod.Billing_Street__c = childElement3.getText();
                        else if(childElement3.getName() == 'city') paymentMethod.Billing_City__c = childElement3.getText();
                        else if(childElement3.getName() == 'state') paymentMethod.Billing_State__c = childElement3.getText();
                        else if(childElement3.getName() == 'zip') paymentMethod.Billing_Zip__c = childElement3.getText();
                        else if(childElement3.getName() == 'country') paymentMethod.Billing_Country__c = childElement3.getText();
                        else if(childElement3.getName() == 'phoneNumber') paymentMethod.Phone__c = childElement3.getText();
                        else if(childElement3.getName() == 'faxNumber') paymentMethod.Fax__c = childElement3.getText();
                    } 
                    else if(childElement2.getName() == 'payment') for(Dom.XMLNode childElement3:childElement2.getChildElements()) if(childElement3.getName() == 'creditCard') for(Dom.XMLNode childElement4:childElement3.getChildElements()){
                        if(childElement4.getName() == 'cardType') paymentMethod.Card_Type__c = childElement4.getText();                        
                        else if(childElement4.getName() == 'cardNumber') paymentMethod.Card_Number__c = childElement4.getText();
                        else if(childElement4.getName() == 'expirationDate' && String.isNotBlank(childElement4.getText())) paymentMethod.Expiration_Date_Year__c = childElement4.getText().substringBefore('-');
                        else if(childElement4.getName() == 'expirationDate' && String.isNotBlank(childElement4.getText())) paymentMethod.Expiration_Date_Month__c = childElement4.getText().substringAfter('-');
                    }
                }
            }
            for(Account account:[Select id, Authorize_ID__c from Account where Authorize_ID__c in:accountsMap.keySet()]) accountsMap.put(account.Authorize_ID__c, account);
            if(accountsMap.get(paymentMethod.Customer_Id__c) != null && String.isEmpty(accountsMap.get(paymentMethod.Customer_Id__c).id)){
                for(Dom.XmlNode childElement1:AuthorizeConnector.getAuthorizeObject((AuthorizeNetList__c.getValues('Northeast_Dedham') != null ? AuthorizeNetList__c.getValues('Northeast_Dedham') : new AuthorizeNetList__c()), 'CustomerProfile', new Map<String, String>{'customerProfileId' => paymentMethod.Customer_Id__c})){
                    if(childElement1.getName() == 'profile') for(Dom.XmlNode childElement2:childElement1.getChildElements()){
                        if(childElement2.getName() == 'customerProfileId') accountsMap.get(paymentMethod.Customer_Id__c).Authorize_ID__c = childElement2.getText();
                        else if(childElement2.getName() == 'merchantCustomerId') accountsMap.get(paymentMethod.Customer_Id__c).Customer_Id__c = childElement2.getText();
                        else if(childElement2.getName() == 'description') accountsMap.get(paymentMethod.Customer_Id__c).LastName = childElement2.getText();
                        else if(childElement2.getName() == 'email') accountsMap.get(paymentMethod.Customer_Id__c).PersonEmail = childElement2.getText();
                    }
                }
                if(String.isBlank(accountsMap.get(paymentMethod.Customer_Id__c).LastName)) accountsMap.get(paymentMethod.Customer_Id__c).LastName = String.isNotBlank(accountsMap.get(paymentMethod.Customer_Id__c).PersonEmail) ? accountsMap.get(paymentMethod.Customer_Id__c).PersonEmail : accountsMap.get(paymentMethod.Customer_Id__c).Customer_Id__c;
	            ApexUtil.isAuthorizeAccountTriggerInvoked = true;
                List<Database.SaveResult> saveResults = Database.insert(accountsMap.values(), false);
                for(Database.SaveResult saveResult:saveResults) if(!saveResult.isSuccess()) for(Database.Error saveError : saveResult.getErrors()) System.debug('AuthorizeCustomerPaymentWebHook - Person Account insert Error: ' + saveError.getMessage());
            }
            if(accountsMap.get(paymentMethod.Customer_Id__c) != null) paymentMethod.Account__c = accountsMap.get(paymentMethod.Customer_Id__c).id;
            try{
		        ApexUtil.isAuthorizePaymentMethodTriggerInvoked = true;
                upsert paymentMethod Authorize_ID__c;
            }
            catch(DMLException e){
            	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); mail.setToAddresses(new String[] {'rurupeque@cloudcreations.com'}); mail.setSubject('Rocky Mountain: AuthorizeNortheastCustomerPaymentWebHook - PaymentMethod Upsert Error'); mail.setHtmlBody('<strong>Upsert Error: </strong>' + e.getMessage() + '<br/><strong>X-ANET-Signature: </strong>' + RestContext.request.headers.get('X-ANET-Signature') + '<br/><strong>Body: </strong>' + RestContext.request.requestBody.ToString()); Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            }
        }
        else{
            RestResponse res = RestContext.response;
            res.statusCode = 400;           
        }
    }
}