@RestResource(urlMapping='/AuthorizeSubscriptionWebHook/*')
global without sharing class AuthorizeSubscriptionWebHook{
    @HttpPost
    global static void AuthorizeSubscription() {
        System.debug('###AuthorizeSubscriptionWebHook-RestContext.request.signature: ' + RestContext.request.headers.get('X-ANET-Signature'));
        System.debug('###AuthorizeSubscriptionWebHook-RestContext.request.body: ' + RestContext.request.requestBody.ToString());
        if(RestContext.request.requestBody != null && RestContext.request.requestBody.ToString().contains('"subscription"')){
            Opportunity opportunity = new Opportunity(Authorize_Subscription_ID__c = (String) ((Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.ToString())).get('payload')).get('id'), Authorize_Subscription_Status__c = (String) ((Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.ToString())).get('payload')).get('status'));
            if(String.isNotEmpty(opportunity.Authorize_Subscription_ID__c)) for(Opportunity opp:[Select id from Opportunity where Authorize_Subscription_ID__c =:opportunity.Authorize_Subscription_ID__c]) opportunity.id = opp.id;
            try{
                if(String.isNotEmpty(opportunity.id)) update opportunity;
            }
            catch(DMLException e){
            	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); mail.setToAddresses(new String[] {'rtapia@cloudcreations.com'}); mail.setSubject('Rocky Mountain Sandbox: AuthorizeSubscriptionWebHook - Opportunity Update Error'); mail.setHtmlBody('<strong>Update Error: </strong>' + e.getMessage() + '<br/><strong>X-ANET-Signature: </strong>' + RestContext.request.headers.get('X-ANET-Signature') + '<br/><strong>Body: </strong>' + RestContext.request.requestBody.ToString()); Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            }
        }
        else{
            RestResponse res = RestContext.response;
            res.statusCode = 400;           
        }
    }
}