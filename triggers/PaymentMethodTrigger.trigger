trigger PaymentMethodTrigger on Payment_Method__c (before insert, before update){
    if(!ApexUtil.isAuthorizePaymentMethodTriggerInvoked){
        if(trigger.isInsert) for(Payment_Method__c paymentMethod : trigger.new) paymentMethod.Authorize_To_Sync__c = true;
        else for(Payment_Method__c account:trigger.new) if(account.First_Name__c != trigger.oldMap.get(account.Id).First_Name__c || account.Last_Name__c != trigger.oldMap.get(account.Id).Last_Name__c || account.Company__c != trigger.oldMap.get(account.Id).Company__c || account.Billing_Street__c != trigger.oldMap.get(account.Id).Billing_Street__c || account.Billing_City__c != trigger.oldMap.get(account.Id).Billing_City__c || account.Billing_State__c != trigger.oldMap.get(account.Id).Billing_State__c || account.Billing_Zip__c != trigger.oldMap.get(account.Id).Billing_Zip__c || account.Billing_Country__c != trigger.oldMap.get(account.Id).Billing_Country__c || account.Phone__c != trigger.oldMap.get(account.Id).Phone__c || account.Fax__c != trigger.oldMap.get(account.Id).Fax__c || account.Card_Number__c != trigger.oldMap.get(account.Id).Card_Number__c || account.Expiration_Date_Year__c != trigger.oldMap.get(account.Id).Expiration_Date_Year__c || account.Expiration_Date_Month__c != trigger.oldMap.get(account.Id).Expiration_Date_Month__c) account.Authorize_To_Sync__c = true;
    }
    if(trigger.isInsert) for(Payment_Method__c paymentMethod:trigger.new) paymentMethod.Name = (String.isNotEmpty(paymentMethod.Card_Type__c) ? paymentMethod.Card_Type__c : '') + (String.isNotEmpty(paymentMethod.Card_Number__c) ? ' - ' + paymentMethod.Card_Number__c.right(4) : '');
    else for(Payment_Method__c paymentMethod:trigger.new) if(paymentMethod.Card_Type__c != trigger.oldMap.get(paymentMethod.Id).Card_Type__c || paymentMethod.Card_Number__c != trigger.oldMap.get(paymentMethod.Id).Card_Number__c) paymentMethod.Name = (String.isNotEmpty(paymentMethod.Card_Type__c) ? paymentMethod.Card_Type__c : '') + (String.isNotEmpty(paymentMethod.Card_Number__c) ? ' - ' + paymentMethod.Card_Number__c.right(4) : '');
}