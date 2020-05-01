@isTest
public class AuthorizeTest {
    
    private static AuthorizeNet__c authentication = AuthorizeNet__c.getOrgDefaults();
    private static AuthorizeNetList__c authorizeListClover = AuthorizeNetList__c.getValues('CastleRock');
    private static AuthorizeNetList__c authorizeListColorado = AuthorizeNetList__c.getValues('Colorado Springs');
    private static AuthorizeNetList__c authorizeListSandbox = AuthorizeNetList__c.getValues('Sandbox');
    private static AuthorizeNetList__c authorizeListDenverCentral = AuthorizeNetList__c.getValues('Denver Central');
    private static AuthorizeNetList__c authorizeListDenverNorth = AuthorizeNetList__c.getValues('Denver North');
    private static AuthorizeNetList__c authorizeListNortheast = AuthorizeNetList__c.getValues('Northeast');
    private static AuthorizeNetList__c authorizeListDedham = AuthorizeNetList__c.getValues('Northeast_Dedham');
    private static AuthorizeNetList__c authorizeListBaton = AuthorizeNetList__c.getValues('Baton');
    
    static {
        authentication.EndPoint__c = 'https://apitest.authorize.net/xml/v1/request.api';
        authentication.Api_Login_ID__c = '4p9E5hMx';
        authentication.Transaction_Key__c = '8JX7eu2B24P8da9q';
        insert authentication;
        authorizeListClover = new AuthorizeNetList__c();
        authorizeListClover.Name = 'CastleRock';
        authorizeListClover.Api_Login_ID__c = '6YcbFN947yt';
        authorizeListClover.Transaction_Key__c = '22D7H9rKs25kTq2S';
        authorizeListClover.EndPoint__c = 'https://api.authorize.net/xml/v1/request.api';
        insert authorizeListClover;
        authorizeListColorado = new AuthorizeNetList__c();
        authorizeListColorado.Name = 'Colorado Springs';
        authorizeListColorado.Api_Login_ID__c = '6YcbFN947yt';
        authorizeListColorado.Transaction_Key__c = '22D7H9rKs25kTq2S';
        authorizeListColorado.EndPoint__c = 'https://api.authorize.net/xml/v1/request.api';
        insert authorizeListColorado;
        authorizeListSandbox = new AuthorizeNetList__c();
        authorizeListSandbox.Name = 'Sandbox';
        authorizeListSandbox.Api_Login_ID__c = '6YcbFN947yt';
        authorizeListSandbox.Transaction_Key__c = '22D7H9rKs25kTq2S';
        authorizeListSandbox.EndPoint__c = 'https://api.authorize.net/xml/v1/request.api';
        insert authorizeListSandbox;
        authorizeListDenverCentral = new AuthorizeNetList__c();
        authorizeListDenverCentral.Name = 'Denver Central';
        authorizeListDenverCentral.Api_Login_ID__c = '6YcbFN947yt';
        authorizeListDenverCentral.Transaction_Key__c = '22D7H9rKs25kTq2S';
        authorizeListDenverCentral.EndPoint__c = 'https://api.authorize.net/xml/v1/request.api';
        insert authorizeListDenverCentral;
        authorizeListDenverNorth = new AuthorizeNetList__c();
        authorizeListDenverNorth.Name = 'Denver North';
        authorizeListDenverNorth.Api_Login_ID__c = '6YcbFN947yt';
        authorizeListDenverNorth.Transaction_Key__c = '22D7H9rKs25kTq2S';
        authorizeListDenverNorth.EndPoint__c = 'https://api.authorize.net/xml/v1/request.api';
        insert authorizeListDenverNorth;
        authorizeListNortheast = new AuthorizeNetList__c();
        authorizeListNortheast.Name = 'Northeast';
        authorizeListNortheast.Api_Login_ID__c = '6YcbFN947yt';
        authorizeListNortheast.Transaction_Key__c = '22D7H9rKs25kTq2S';
        authorizeListNortheast.EndPoint__c = 'https://api.authorize.net/xml/v1/request.api';
        insert authorizeListNortheast;
        authorizeListDedham = new AuthorizeNetList__c();
        authorizeListDedham.Name = 'Northeast_Dedham';
        authorizeListDedham.Api_Login_ID__c = '6YcbFN947yt';
        authorizeListDedham.Transaction_Key__c = '22D7H9rKs25kTq2S';
        authorizeListDedham.EndPoint__c = 'https://api.authorize.net/xml/v1/request.api';
        insert authorizeListDedham;
        authorizeListBaton = new AuthorizeNetList__c();
        authorizeListBaton.Name = 'Baton';
        authorizeListBaton.Api_Login_ID__c = '6YcbFN947yt';
        authorizeListBaton.Transaction_Key__c = '22D7H9rKs25kTq2S';
        authorizeListBaton.EndPoint__c = 'https://api.authorize.net/xml/v1/request.api';
        insert authorizeListBaton;
    }
    
    @isTest static void testPutTransaction(){
        Id patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acc = new Account(FirstName='Steyner', LastName = 'URu', Authorize_ID__c='123456', RecordTypeId = patientRecordTypeId);
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Yopi';
        opp.AccountId = acc.Id;
        opp.Invoice_Number__c = '654435';
        opp.PO_Number__c = '369712';
        opp.Discount_Amount__c = 400;
        opp.Shipping__c = 200;
        opp.Duty__c = 90;
        opp.Tax__c = 30;
        opp.Billing_First_Name__c = 'First';
        opp.Billing_Last_Name__c = 'Last';
        opp.Billing_Company__c = 'SertPro';
        opp.Billing_Street__c = 'Street';
        opp.Billing_City__c = 'City';
        opp.Billing_State__c = 'State';
        opp.Billing_Zip__c = 'Zip';
        opp.Billing_Country__c = 'Country';
        opp.Shipping_First_Name__c = 'First';
        opp.Shipping_Last_Name__c = 'Last';
        opp.Shipping_Company__c = 'SertPro';
        opp.Shipping_Street__c = 'Street';
        opp.Shipping_City__c = 'City';
        opp.Shipping_State__c = 'State';
        opp.Shipping_Zip__c = 'Zip';
        opp.Shipping_Country__c = 'Country';
        opp.Card_Number__c = '974216';
        opp.Expiration_Date_Month__c = '12';
        opp.Expiration_Date_Year__c = '2020';
        opp.Card_Code__c = '752145';
        opp.StageName = 'Qualification';
        opp.CloseDate = Date.today();
        opp.Primary_Clinic__c='Northeast Mens Clinic - Dedham';
        opp.Amount = 200;
        insert opp;
        Test.startTest();
        AuthorizeConnector.putTransaction(opp.Id);
        Test.stopTest();
    }
    
    @isTest static void testPutTransactionWithPaymentMethod(){
        Id patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acc = new Account(FirstName='Steyner', LastName = 'URu', Authorize_ID__c='123456', RecordTypeId = patientRecordTypeId);
        insert acc;
        Payment_Method__c objPM = new Payment_Method__c();
        objPM.Name = 'BN123';
        objPM.Authorize_ID__c = '123456';
        objPM.Account__c = acc.Id;
        objPM.Card_Number__c = '785412';
        objPM.Expiration_Date_Year__c = '2020';
        objPM.Expiration_Date_Month__c = '12';
        objPM.Card_Code__c = '012458';
        insert objPM;
        Opportunity opp = new Opportunity();
        opp.Name = 'Yopi';
        opp.AccountId = acc.Id;
        opp.Invoice_Number__c = '654435';
        opp.PO_Number__c = '369712';
        opp.Discount_Amount__c = 400;
        opp.Shipping__c = 200;
        opp.Duty__c = 90;
        opp.Tax__c = 30;
        opp.Billing_First_Name__c = 'First';
        opp.Billing_Last_Name__c = 'Last';
        opp.Billing_Company__c = 'SertPro';
        opp.Billing_Street__c = 'Street';
        opp.Billing_City__c = 'City';
        opp.Billing_State__c = 'State';
        opp.Billing_Zip__c = 'Zip';
        opp.Billing_Country__c = 'Country';
        opp.Shipping_First_Name__c = 'First';
        opp.Shipping_Last_Name__c = 'Last';
        opp.Shipping_Company__c = 'SertPro';
        opp.Shipping_Street__c = 'Street';
        opp.Shipping_City__c = 'City';
        opp.Shipping_State__c = 'State';
        opp.Shipping_Zip__c = 'Zip';
        opp.Shipping_Country__c = 'Country';
        opp.Card_Number__c = '974216';
        opp.Expiration_Date_Month__c = '12';
        opp.Expiration_Date_Year__c = '2020';
        opp.Card_Code__c = '752145';
        opp.Payment_Method__c = objPM.Id;
        opp.StageName = 'Qualification';
        opp.CloseDate = Date.today();
        opp.Primary_Clinic__c='Northeast Mens Clinic - Dedham';
        opp.Amount = 200;
        insert opp;
        Test.startTest();
        AuthorizeConnector.putTransaction(opp.Id);
        Test.stopTest();
    }
    
    @isTest static void testPutSubscripcion(){
        Id patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acc = new Account(FirstName='Steyner', LastName = 'URu', Authorize_ID__c='123456', RecordTypeId = patientRecordTypeId);
        insert acc;
        Opportunity opp = new Opportunity();
        opp.Name = 'Yopi';
        opp.AccountId = acc.Id;
        opp.Invoice_Number__c = '654435';
        opp.PO_Number__c = '369712';
        opp.Discount_Amount__c = 400;
        opp.Shipping__c = 200;
        opp.Duty__c = 90;
        opp.Tax__c = 30;
        opp.Billing_First_Name__c = 'First';
        opp.Billing_Last_Name__c = 'Last';
        opp.Billing_Company__c = 'SertPro';
        opp.Billing_Street__c = 'Street';
        opp.Billing_City__c = 'City';
        opp.Billing_State__c = 'State';
        opp.Billing_Zip__c = 'Zip';
        opp.Billing_Country__c = 'Country';
        opp.Shipping_First_Name__c = 'First';
        opp.Shipping_Last_Name__c = 'Last';
        opp.Shipping_Company__c = 'SertPro';
        opp.Shipping_Street__c = 'Street';
        opp.Shipping_City__c = 'City';
        opp.Shipping_State__c = 'State';
        opp.Shipping_Zip__c = 'Zip';
        opp.Shipping_Country__c = 'Country';
        opp.Card_Number__c = '974216';
        opp.Expiration_Date_Month__c = '12';
        opp.Expiration_Date_Year__c = '2020';
        opp.Card_Code__c = '752145';
        opp.StageName = 'Qualification';
        opp.CloseDate = Date.today();
        opp.Primary_Clinic__c='Northeast Mens Clinic - Dedham';
        opp.Amount = 200;
        insert opp;
        Test.startTest();
        AuthorizeConnector.putSubscription(opp.Id);
        Test.stopTest();
    }
    
    @isTest static void testPutSubscripctionWithPaymentMethod(){
        Id patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acc = new Account(FirstName='Steyner', LastName = 'URu', Authorize_ID__c='123456', RecordTypeId = patientRecordTypeId);
        insert acc;
        Payment_Method__c objPM = new Payment_Method__c();
        objPM.Name = 'BN123';
        objPM.Authorize_ID__c = '123456';
        objPM.Account__c = acc.Id;
        objPM.Card_Number__c = '785412';
        objPM.Expiration_Date_Year__c = '2020';
        objPM.Expiration_Date_Month__c = '12';
        objPM.Card_Code__c = '012458';
        insert objPM;
        Opportunity opp = new Opportunity();
        opp.Name = 'Yopi';
        opp.AccountId = acc.Id;
        opp.Invoice_Number__c = '654435';
        opp.PO_Number__c = '369712';
        opp.Discount_Amount__c = 400;
        opp.Shipping__c = 200;
        opp.Duty__c = 90;
        opp.Tax__c = 30;
        opp.Billing_First_Name__c = 'First';
        opp.Billing_Last_Name__c = 'Last';
        opp.Billing_Company__c = 'SertPro';
        opp.Billing_Street__c = 'Street';
        opp.Billing_City__c = 'City';
        opp.Billing_State__c = 'State';
        opp.Billing_Zip__c = 'Zip';
        opp.Billing_Country__c = 'Country';
        opp.Shipping_First_Name__c = 'First';
        opp.Shipping_Last_Name__c = 'Last';
        opp.Shipping_Company__c = 'SertPro';
        opp.Shipping_Street__c = 'Street';
        opp.Shipping_City__c = 'City';
        opp.Shipping_State__c = 'State';
        opp.Shipping_Zip__c = 'Zip';
        opp.Shipping_Country__c = 'Country';
        opp.Card_Number__c = '974216';
        opp.Expiration_Date_Month__c = '12';
        opp.Expiration_Date_Year__c = '2020';
        opp.Card_Code__c = '752145';
        opp.Payment_Method__c = objPM.Id;
        opp.StageName = 'Qualification';
        opp.CloseDate = Date.today();
        opp.Authorize_Total_Occurrences__c = 3;
        opp.Authorize_Payment_Frecuency__c = 'Weekly';
        opp.Authorize_Total_Occurrences__c = 3;
        opp.Primary_Clinic__c='Northeast Mens Clinic - Dedham';
        opp.Amount = 200;
        insert opp;
        Test.startTest();
        AuthorizeConnector.putSubscription(opp.Id);
        Test.stopTest();
    }
    
    @isTest static void testPutSubscripctionWithPaymentMethodAndAuthorizeSubscription(){
        Id patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId();
        Account acc = new Account(FirstName='Steyner', LastName = 'URu', Authorize_ID__c='123456', RecordTypeId = patientRecordTypeId);
        insert acc;
        Payment_Method__c objPM = new Payment_Method__c();
        objPM.Name = 'BN123';
        objPM.Authorize_ID__c = '123456';
        objPM.Account__c = acc.Id;
        objPM.Card_Number__c = '785412';
        objPM.Expiration_Date_Year__c = '2020';
        objPM.Expiration_Date_Month__c = '12';
        objPM.Card_Code__c = '012458';
        insert objPM;
        Opportunity opp = new Opportunity();
        opp.Name = 'Yopi';
        opp.AccountId = acc.Id;
        opp.Invoice_Number__c = '654435';
        opp.PO_Number__c = '369712';
        opp.Discount_Amount__c = 400;
        opp.Shipping__c = 200;
        opp.Duty__c = 90;
        opp.Tax__c = 30;
        opp.Billing_First_Name__c = 'First';
        opp.Billing_Last_Name__c = 'Last';
        opp.Billing_Company__c = 'SertPro';
        opp.Billing_Street__c = 'Street';
        opp.Billing_City__c = 'City';
        opp.Billing_State__c = 'State';
        opp.Billing_Zip__c = 'Zip';
        opp.Billing_Country__c = 'Country';
        opp.Shipping_First_Name__c = 'First';
        opp.Shipping_Last_Name__c = 'Last';
        opp.Shipping_Company__c = 'SertPro';
        opp.Shipping_Street__c = 'Street';
        opp.Shipping_City__c = 'City';
        opp.Shipping_State__c = 'State';
        opp.Shipping_Zip__c = 'Zip';
        opp.Shipping_Country__c = 'Country';
        opp.Card_Number__c = '974216';
        opp.Expiration_Date_Month__c = '12';
        opp.Expiration_Date_Year__c = '2020';
        opp.Card_Code__c = '752145';
        opp.Payment_Method__c = objPM.Id;
        opp.StageName = 'Qualification';
        opp.CloseDate = Date.today();
        opp.Authorize_Subscription_ID__c = '4845165';
        opp.Authorize_Total_Occurrences__c = 3;
        opp.Authorize_Payment_Frecuency__c = 'Weekly';
        opp.Authorize_Total_Occurrences__c = 3;
        opp.Primary_Clinic__c='Northeast Mens Clinic - Dedham';
        opp.Amount = 200;
        insert opp;
        Test.startTest();
        AuthorizeConnector.putSubscription(opp.Id);
        Test.stopTest();
    }
    
    /*@isTest static void TestPutAuthorizeObject(){
        Test.startTest();
        AuthorizeConnector.putAuthorizeObject('<xml></xml>');
        Test.stopTest();
    }*/
    
    @isTest static void TestGetAuthorizeObjectI(){
        Test.startTest();
        AuthorizeConnector.getAuthorizeObject(authorizeListClover, 'CustomerProfile', new Map<String, String>{'customerProfileId'=>'test1', 'customerPaymentProfileId'=>'test2', 'transId'=>''});
        Test.stopTest();
    }
        
    @isTest static void TestGetAuthorizeObjectII(){
        Test.startTest();
        AuthorizeConnector.getAuthorizeObject(authorizeListClover, 'CustomerPaymentProfile', new Map<String, String>{'customerProfileId'=>'test1', 'customerPaymentProfileId'=>'test2', 'transId'=>''});
        Test.stopTest();
    }
        
    @isTest static void TestGetAuthorizeObjectIII(){
        Test.startTest();
        AuthorizeConnector.getAuthorizeObject(authorizeListClover, 'TransactionDetails', new Map<String, String>{'customerProfileId'=>'test1', 'customerPaymentProfileId'=>'test2', 'transId'=>''});
        Test.stopTest();
    }
    
    @isTest static void TestAuthorizePostCustomersBatch(){
        Account acc = new Account(LastName='Test Last', PersonEmail='person@gmail.com', Authorize_To_Sync__c=true, Primary_Clinic__c='Baton Rouge Mens Clinic');
        insert acc;
        Test.startTest();
        Database.executeBatch(new AuthorizePostCustomersBatch('Baton'));
        Test.stopTest();
    }
    
    @isTest static void TestAuthorizePostCustomersBatchWithAuthorizeID(){
        Account acc = new Account(LastName='Test Last', PersonEmail='person@gmail.com', Authorize_ID__c='987451', Authorize_To_Sync__c=true, Primary_Clinic__c='Baton Rouge Mens Clinic');
        insert acc;
        Test.startTest();
        Database.executeBatch(new AuthorizePostCustomersBatch('Baton'));
        Test.stopTest();
    }
    
    @isTest static void TestAuthorizePostCustomerPaymentsBatch(){
        Account acc = new Account(LastName='Test Last', PersonEmail='person@gmail.com', Authorize_ID__c='987451', Authorize_To_Sync__c=true, Primary_Clinic__c='Baton Rouge Mens Clinic');
        insert acc;
        Payment_Method__c pm = new Payment_Method__c();
        pm.Authorize_ID__c = '654321';
        pm.Account__c = acc.Id;
        pm.Customer_Id__c = '985476';
        pm.Customer_Type__c = 'Individual';
        pm.First_Name__c = 'Test First';
        pm.Last_Name__c = 'Test Last';
        pm.Company__c = 'Test Company';
        pm.Billing_Street__c = 'Test Street';
        pm.Billing_State__c = 'Test State';
        pm.Billing_City__c = 'Test City';
        pm.Billing_Zip__c = 'Test Zip';
        pm.Billing_Country__c = 'Test Country';
        pm.Phone__c = '1245482148';
        pm.Fax__c = '4548152152';
        pm.Card_Number__c = '548845219';
        pm.Expiration_Date_Month__c = '12';
        pm.Expiration_Date_Year__c = '2022';
        pm.Card_Code__c = '4214485485';
        pm.Authorize_To_Sync__c = true;
        insert pm;
        Test.startTest();
        Database.executeBatch(new AuthorizePostCustomerPaymentsBatch('Baton'));
        Test.stopTest();
    }
    
    @isTest static void TestAuthorizePostCustomerPaymentsBatchWithAuthorizeID(){
        Account acc = new Account(LastName='Test Last', PersonEmail='person@gmail.com', Authorize_ID__c='987451', Authorize_To_Sync__c=true, Primary_Clinic__c='Baton Rouge Mens Clinic');
        insert acc;
        Payment_Method__c pm = new Payment_Method__c();
        pm.Account__c = acc.Id;
        pm.Customer_Id__c = '985476';
        pm.Customer_Type__c = 'Individual';
        pm.First_Name__c = 'Test First';
        pm.Last_Name__c = 'Test Last';
        pm.Company__c = 'Test Company';
        pm.Billing_Street__c = 'Test Street';
        pm.Billing_State__c = 'Test State';
        pm.Billing_City__c = 'Test City';
        pm.Billing_Zip__c = 'Test Zip';
        pm.Billing_Country__c = 'Test Country';
        pm.Phone__c = '1245482148';
        pm.Fax__c = '4548152152';
        pm.Card_Number__c = '548845219';
        pm.Expiration_Date_Month__c = '12';
        pm.Expiration_Date_Year__c = '2022';
        pm.Card_Code__c = '4214485485';
        pm.Authorize_To_Sync__c = true;
        insert pm;
        Test.startTest();
        Database.executeBatch(new AuthorizePostCustomerPaymentsBatch('Baton'));
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCastleRockCustomerWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCastleRockCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCastleRockCustomerWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCastleRockCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCastleRkCustomerPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCastleRkCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCastleRkCustomerPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCastleRkCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCastleRockPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCastleRockPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCastleRockPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "d0e8e7fe-c3e7-4add-a480-27bc5ce28a18","eventType":"net.authorize.payment.authcapture.created","eventDate": "2017-03-29T20:48:02.0080095Z","webhookId": "63d6fea2-aa13-4b1d-a204-f5fbc15942b7","payload": {"responseCode": 1,"authCode": "LZ6I19","avsResponse": "Y","authAmount": 45.00,"entityName": "transaction","id": "60020981676"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCastleRockPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeColoradoCustomerWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeColoradoCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeColoradoCustomerWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeColoradoCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeColoradoCustomerPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeColoradoCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeColoradoCustomerPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeColoradoCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeColoradoPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeColoradoPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeColoradoPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "d0e8e7fe-c3e7-4add-a480-27bc5ce28a18","eventType":"net.authorize.payment.authcapture.created","eventDate": "2017-03-29T20:48:02.0080095Z","webhookId": "63d6fea2-aa13-4b1d-a204-f5fbc15942b7","payload": {"responseCode": 1,"authCode": "LZ6I19","avsResponse": "Y","authAmount": 45.00,"entityName": "transaction","id": "60020981676"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeColoradoPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCustomerWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCustomerWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCustomerPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeCustomerPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizePaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizePaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizePaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "d0e8e7fe-c3e7-4add-a480-27bc5ce28a18","eventType":"net.authorize.payment.authcapture.created","eventDate": "2017-03-29T20:48:02.0080095Z","webhookId": "63d6fea2-aa13-4b1d-a204-f5fbc15942b7","payload": {"responseCode": 1,"authCode": "LZ6I19","avsResponse": "Y","authAmount": 45.00,"entityName": "transaction","id": "60020981676"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizePaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverCentralCustomerWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverCentralCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverCentralCustomerWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverCentralCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverCentralCustomerPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverCTCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverCentralCustomerPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverCTCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverCentralPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverCentralPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverCentralPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "d0e8e7fe-c3e7-4add-a480-27bc5ce28a18","eventType":"net.authorize.payment.authcapture.created","eventDate": "2017-03-29T20:48:02.0080095Z","webhookId": "63d6fea2-aa13-4b1d-a204-f5fbc15942b7","payload": {"responseCode": 1,"authCode": "LZ6I19","avsResponse": "Y","authAmount": 45.00,"entityName": "transaction","id": "60020981676"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverCentralPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverNorthCustomerWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverNorthCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverNorthCustomerWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverNorthCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverNorthCustomerPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverNTCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverNorthCustomerPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverNTCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverNorthPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverNorthPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDenverNorthPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "d0e8e7fe-c3e7-4add-a480-27bc5ce28a18","eventType":"net.authorize.payment.authcapture.created","eventDate": "2017-03-29T20:48:02.0080095Z","webhookId": "63d6fea2-aa13-4b1d-a204-f5fbc15942b7","payload": {"responseCode": 1,"authCode": "LZ6I19","avsResponse": "Y","authAmount": 45.00,"entityName": "transaction","id": "60020981676"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDenverNorthPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeNortheastCustomerWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeNortheastCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeNortheastCustomerWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeNortheastCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeNortheastCustomerPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeNortheastCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeNortheastCustomerPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeNortheastCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeNortheastPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeNortheastPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeNortheastPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "d0e8e7fe-c3e7-4add-a480-27bc5ce28a18","eventType":"net.authorize.payment.authcapture.created","eventDate": "2017-03-29T20:48:02.0080095Z","webhookId": "63d6fea2-aa13-4b1d-a204-f5fbc15942b7","payload": {"responseCode": 1,"authCode": "LZ6I19","avsResponse": "Y","authAmount": 45.00,"entityName": "transaction","id": "60020981676"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeNortheastPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDedhamCustomerWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDedhamCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDedhamCustomerWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDedhamCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDedhamCustomerPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDedhamCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDedhamCustomerPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDedhamCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDedhamPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDedhamPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeDedhamPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "d0e8e7fe-c3e7-4add-a480-27bc5ce28a18","eventType":"net.authorize.payment.authcapture.created","eventDate": "2017-03-29T20:48:02.0080095Z","webhookId": "63d6fea2-aa13-4b1d-a204-f5fbc15942b7","payload": {"responseCode": 1,"authCode": "LZ6I19","avsResponse": "Y","authAmount": 45.00,"entityName": "transaction","id": "60020981676"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeDedhamPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeSubscriptionWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "d0e8e7fe-c3e7-4add-a480-27bc5ce28a18","eventType":"net.authorize.payment.authcapture.created","eventDate": "2017-03-29T20:48:02.0080095Z","webhookId": "63d6fea2-aa13-4b1d-a204-f5fbc15942b7","payload": {"responseCode": 1,"authCode": "LZ6I19","avsResponse": "Y","authAmount": 45.00,"entityName": "transaction","id": "60020981676"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeSubscriptionWebHook.AuthorizeSubscription();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeSubscriptionWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "35e4c150-1d64-40b3-ba52-9356ebecd3c7","eventType":"net.authorize.customer.subscription.created","eventDate": "2016-03-08T08:18:27.434Z","webhookId": "873B7193-31FF-4881-9593-FA6578D52510","payload": {"entityName": "subscription","id": "1405","name": "testSubscription","amount": 23,"status": "active","profile": {"customerProfileId": 348,"customerPaymentProfileId": 644,"customerShippingAddressId": 675}}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeSubscriptionWebHook.AuthorizeSubscription();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizePostSchedule(){
        AuthorizePostSchedule scheduler = new AuthorizePostSchedule('Baton');
        SchedulableContext sc;
        Test.startTest();
        scheduler.execute(sc);
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeBatonCustomerWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeBatonCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeBatonCustomerWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeBatonCustomerWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeBatonCustomerPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "5c3f7e00-1265-4e8e-abd0-a7d734163881","eventType":"net.authorize.customer.created","eventDate": "2016-03-23T05:23:06.5430555Z","webhookId": "0b90f2e8-02ae-4d1d-b2e0-1bd167e60176","payload": {"paymentProfiles": [{	"id": "694","customerType":"individual"}],"merchantCustomerId": "cust457","description": "Profile created by Subscription: 1447","entityName": "customerProfile","id":"394"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeBatonCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeBatonCustomerPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeBatonCustomerPaymentWebHook.AuthorizeCustomer();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeBatonPaymentWebHookI(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "7201C905-B01E-4622-B807-AC2B646A3815","eventType": "net.authorize.customer.paymentProfile.created","eventDate": "2016-03-23T06:19:09.5297562Z","webhookId": "6239A0BE-D8F4-4A33-8FAD-901C02EED51F","payload": {"customerProfileId": 394,"entityName": "customerPaymentProfile","id": "694","customerType": "business"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeBatonPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }
    
    @isTest static void testAuthorizeBatonPaymentWebHookII(){
        Test.startTest();
        RestRequest request = new RestRequest();
        String instance = [SELECT InstanceName FROM Organization][0].InstanceName.toLowerCase();
        request.requestURI = 'https://' + instance + '.salesforce.com/services/apexrest/AuthorizeCastleRockCustomerWebHook/';
        request.requestBody = Blob.valueOf('{"notificationId": "d0e8e7fe-c3e7-4add-a480-27bc5ce28a18","eventType":"net.authorize.payment.authcapture.created","eventDate": "2017-03-29T20:48:02.0080095Z","webhookId": "63d6fea2-aa13-4b1d-a204-f5fbc15942b7","payload": {"responseCode": 1,"authCode": "LZ6I19","avsResponse": "Y","authAmount": 45.00,"entityName": "transaction","id": "60020981676"}}');
        request.httpMethod = 'POST';
        RestContext.request = request;
        RestContext.response = new RestResponse();
        AuthorizeBatonPaymentWebHook.AuthorizePayment();
        Test.stopTest();
    }

}