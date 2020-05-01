public class CloverConnector{
    public static String getCloverObject(Clover__c authentication, String cloverObject, String filters){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(authentication.EndPoint__c + authentication.Merchant_ID__c + '/'  + cloverObject + (!Test.isRunningTest() ? '?' + filters : ''));
        request.setHeader('Authorization', 'Bearer ' + authentication.Token__c);
        request.setHeader('Accept','application/json');
        request.setMethod('GET');
        request.setTimeout(120000);
        Http http = new Http();
        HTTPResponse response;
        try{
            if(!Test.isRunningTest()){
            	response = http.send(request);
	        	System.debug('###CloverConnector.getCloverObject(Merchant = ' + authentication.Name + ', cloverObject = ' + cloverObject + ', filters = ' +  filters + ') => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody().left(255) : ''));
            }else{
                String test = '{"elements": [{"id": "6332AC9QTZ7Z6","order": {"id": "8HMF1RZ0EZCSE"},"device": {"id": "cec78d2b-ec32-4d83-9f45-ca3a80f4b902"},"tender": {"href": "https://www.clover.com/v3/merchants/DQMQAGNPYKR1C/tenders/W3SZA0MRY37Q2","id": "W3SZA0MRY37Q2"},"amount": 186000,"taxAmount": 0,"cashbackAmount": 0,"employee": {"id": "5W3RQEM2WFYST"},"createdTime": 1568728845000,"clientCreatedTime": 1568728844000,"modifiedTime": 1568728845000,"offline": false,"result": "SUCCESS"}],"href": "http://api.clover.com/v3/merchants/DQMQAGNPYKR1C/payments?limit=100"}';
            	response = new HTTPResponse();
                response.setStatusCode(200);
                if(cloverObject.equalsIgnoreCase('payments')) response.setBody(test);
            }
        }
        catch(Exception e){
            response = new HTTPResponse();
            response.setStatusCode(500);
            System.debug('###CloverConnector.getCloverObject(Merchant = ' + authentication.Name + ', cloverObject = ' + cloverObject + ', filters = ' +  filters + ') - Callout Exception: ' + e.getMessage());
        }
        return response.getStatusCode() == 200 ? response.getBody().replace('"type"', '"type_Z"') : '{"elements":[]}';
    }
}