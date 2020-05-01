trigger PaymentTrigger on Payment__c (after insert, after update, after delete) {
    
    Set<Id> oppIds = new Set<Id>(); 
    List<Opportunity> opps = new List<Opportunity>();
    if(trigger.isInsert || trigger.isUpdate) {
        for(Payment__c p: [select Id, Opportunity__c from Payment__c where Id in :Trigger.New])
        {
            if(String.isNotBlank(p.Opportunity__c)) {
                    oppIds.add(p.Opportunity__c);
            } 
        }
    }
    
    if(trigger.isDelete || trigger.isUpdate) {
        for(Payment__c p: Trigger.Old)
        {
            if(String.isNotBlank(trigger.oldMap.get(p.Id).Opportunity__c)) {
                    oppIds.add(trigger.oldMap.get(p.Id).Opportunity__c);
            }
        }
    }
    
    Opportunity opp;
    for (AggregateResult ar : [SELECT Opportunity__c oppId, SUM(Amount__c) sumPay 
                               FROM Payment__c 
                               WHERE Opportunity__c in: oppIds 
                               GROUP BY Opportunity__c]){
       	if(String.isNotBlank((Id)ar.get('oppId'))) {
            oppIds.remove((Id) ar.get('oppId'));
        	opp = new Opportunity();
            opp.Id = (Id) ar.get('oppId'); 
            opp.All_Payments__c = (Decimal) ar.get('sumPay');
            opps.add(opp);
        }
    }
    
    if(oppIds.size()>0){
        for(Id auxId: oppIds) {
            opps.add(new Opportunity(Id=auxId, All_Payments__c=0.0));
        }
    }
    
    if(opps.size()>0)
        update opps;

}