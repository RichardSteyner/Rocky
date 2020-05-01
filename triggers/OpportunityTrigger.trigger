trigger OpportunityTrigger on Opportunity (before insert, before update) {
    Map<Id, Payment_Method__c> paymentMethodsMap = new Map<Id, Payment_Method__c>();
    if(trigger.isInsert){
        for(Opportunity opportunity : trigger.new) if(String.isNotEmpty(opportunity.Payment_Method__c)) paymentMethodsMap.put(opportunity.Payment_Method__c, new Payment_Method__c());
        for(Payment_Method__c paymentMethod:[Select id, Card_Number__c, Expiration_Date_Year__c, Expiration_Date_Month__c, Card_Code__c, First_Name__c, Last_Name__c, Company__c, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Zip__c, Billing_Country__c from Payment_Method__c where id in:paymentMethodsMap.keySet()]) paymentMethodsMap.put(paymentMethod.id, paymentMethod);
        for(Opportunity opportunity : trigger.new){ 
            if(String.isNotEmpty(opportunity.Payment_Method__c)){
                opportunity.Card_Number__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Card_Number__c;
                opportunity.Expiration_Date_Month__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Expiration_Date_Month__c;
                opportunity.Expiration_Date_Year__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Expiration_Date_Year__c;
                opportunity.Card_Code__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Card_Code__c;                
                opportunity.Billing_First_Name__c = paymentMethodsMap.get(opportunity.Payment_Method__c).First_Name__c;                
                opportunity.Billing_Last_Name__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Last_Name__c;                
                opportunity.Billing_Company__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Company__c;                
                opportunity.Billing_Street__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_Street__c;                
                opportunity.Billing_City__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_City__c;                
                opportunity.Billing_State__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_State__c;                
                opportunity.Billing_Zip__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_Zip__c;                
                opportunity.Billing_Country__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_Country__c;                
            }
            if(opportunity.Authorize_Payment_Frecuency__c == 'Once'){
                opportunity.Authorize_Total_Occurrences__c = 1;
                opportunity.Authorize_No_End_Date__c = false;
            } 
        }
    }
    else{
        for(Opportunity opportunity : trigger.new) if(opportunity.Payment_Method__c != Trigger.oldMap.get(opportunity.id).Payment_Method__c && opportunity.Payment_Method__c != null) paymentMethodsMap.put(opportunity.Payment_Method__c, new Payment_Method__c());
        for(Payment_Method__c paymentMethod:[Select id, Card_Number__c, Expiration_Date_Year__c, Expiration_Date_Month__c, Card_Code__c, First_Name__c, Last_Name__c, Company__c, Billing_Street__c, Billing_City__c, Billing_State__c, Billing_Zip__c, Billing_Country__c from Payment_Method__c where id in:paymentMethodsMap.keySet()]) paymentMethodsMap.put(paymentMethod.id, paymentMethod);
        for(Opportunity opportunity : trigger.new){
            if(String.isNotEmpty(opportunity.Payment_Method__c) && opportunity.Payment_Method__c != Trigger.oldMap.get(opportunity.id).Payment_Method__c){
                opportunity.Card_Number__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Card_Number__c;
                opportunity.Expiration_Date_Month__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Expiration_Date_Month__c;
                opportunity.Expiration_Date_Year__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Expiration_Date_Year__c;
                opportunity.Card_Code__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Card_Code__c;
                opportunity.Billing_First_Name__c = paymentMethodsMap.get(opportunity.Payment_Method__c).First_Name__c;                
                opportunity.Billing_Last_Name__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Last_Name__c;                
                opportunity.Billing_Company__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Company__c;                
                opportunity.Billing_Street__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_Street__c;                
                opportunity.Billing_City__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_City__c;                
                opportunity.Billing_State__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_State__c;                
                opportunity.Billing_Zip__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_Zip__c;                
                opportunity.Billing_Country__c = paymentMethodsMap.get(opportunity.Payment_Method__c).Billing_Country__c;                
            }
            if(opportunity.Authorize_Payment_Frecuency__c == 'Once'){
                opportunity.Authorize_Total_Occurrences__c = 1;
                opportunity.Authorize_No_End_Date__c = false;
            } 
        }
    }
}