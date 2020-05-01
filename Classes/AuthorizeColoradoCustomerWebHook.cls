@RestResource(urlMapping='/AuthorizeColoradoCustomerWebHook/*')
global without sharing class AuthorizeColoradoCustomerWebHook{
    @HttpPost
    global static void AuthorizeCustomer() {
        System.debug('###AuthorizeCustomerWebHook-RestContext.request.signature: ' + RestContext.request.headers.get('X-ANET-Signature'));
        System.debug('###AuthorizeCustomerWebHook-RestContext.request.body: ' + RestContext.request.requestBody.ToString());
        if(RestContext.request.requestBody != null && RestContext.request.requestBody.ToString().contains('"customerProfile"')){
            Account account = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null);
            for(Dom.XmlNode childElement1:AuthorizeConnector.getAuthorizeObject((AuthorizeNetList__c.getValues('Colorado Springs') != null ? AuthorizeNetList__c.getValues('Colorado Springs') : new AuthorizeNetList__c()), 'CustomerProfile', new Map<String, String>{'customerProfileId' => (String) ((Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.ToString())).get('payload')).get('id')})){
                if(childElement1.getName() == 'profile') for(Dom.XmlNode childElement2:childElement1.getChildElements()){
                    if(childElement2.getName() == 'customerProfileId') account.Authorize_ID__c = childElement2.getText();
                    else if(childElement2.getName() == 'merchantCustomerId') account.Customer_Id__c = childElement2.getText();
                    else if(childElement2.getName() == 'description') account.LastName = childElement2.getText();
                    else if(childElement2.getName() == 'email') account.PersonEmail = childElement2.getText();
                }
            }
            if(String.isBlank(account.LastName)) account.LastName = String.isNotBlank(account.PersonEmail) ? account.PersonEmail : account.Customer_Id__c;
            try{
                upsert account Authorize_ID__c;
            }
            catch(DMLException e){
            	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); mail.setToAddresses(new String[] {'rurupeque@cloudcreations.com'}); mail.setSubject('Rocky Mountain: AuthorizeColoradoCustomerWebHook - Patient Account Upsert Error'); mail.setHtmlBody('<strong>Upsert Error: </strong>' + e.getMessage() + '<br/><strong>X-ANET-Signature: </strong>' + RestContext.request.headers.get('X-ANET-Signature') + '<br/><strong>Body: </strong>' + RestContext.request.requestBody.ToString()); Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            }
        }
        else{
            RestResponse res = RestContext.response;
            res.statusCode = 400;           
        }
    }
}