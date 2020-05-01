@isTest
public class CloverTest {
    
    private static Clover__c authentication = Clover__c.getOrgDefaults();
    
    static{
    	//authentication = Clover__c.getAll().values()[0];
    	authentication.Endpoint__c = 'https://api.clover.com/v3/merchants/';
        authentication.Name = 'Test';
        authentication.Token__c = '995171b0-83e2-9b9f-1635-3e33e91e1b4c';
        authentication.Merchant_ID__c = 'DQMQAGNPYKR1C';
        insert authentication;
    }
    @isTest static void testConnector(){
        Test.startTest();
        CloverConnector.getCloverObject(authentication, 'payments', 'expand=order.customers,order.employee,cardTransaction,tender&offset=1&limit=1');
        Test.stopTest();
    }
    
    @isTest static void testPaymentsBatch(){
        Test.startTest();
        Database.executeBatch(new CloverGetPaymentsBatch(true, 6), 100);
        Test.stopTest();
    }
    
    @isTest static void testPaymentsScheduler(){
		CloverGetPaymentsSchedule scheduler= new CloverGetPaymentsSchedule();
        SchedulableContext sc;
        Test.startTest();
		scheduler.execute(sc);
        Test.stopTest();
	}

}