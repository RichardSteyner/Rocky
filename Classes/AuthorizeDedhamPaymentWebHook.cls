@RestResource(urlMapping='/AuthorizeDedhamPaymentWebHook/*')
global without sharing class AuthorizeDedhamPaymentWebHook{
    @HttpPost
    global static void AuthorizePayment(){
        System.debug('###AuthorizePaymentWebHook-RestContext.request.signature: ' + RestContext.request.headers.get('X-ANET-Signature'));
        System.debug('###AuthorizePaymentWebHook-RestContext.request.body: ' + RestContext.request.requestBody.ToString());
        if(RestContext.request.requestBody != null && RestContext.request.requestBody.ToString().contains('"transaction"')){
            Map<String, Product2> productsMap = new Map<String, Product2>();
            Map<String, OpportunityLineItem> olisMap = new Map<String, OpportunityLineItem>();
            Account account = new Account(RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null ? Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId() : null);
            Opportunity opportunity = new Opportunity(CloseDate = Date.Today(), StageName = 'Closed Won');
            Payment_Method__c paymentMethod = new Payment_Method__c();
            Payment__c payment = new Payment__c(RecordTypeId = Schema.SObjectType.Payment__c.getRecordTypeInfosByName().get('Authorize.Net') != null ? Schema.SObjectType.Payment__c.getRecordTypeInfosByName().get('Authorize.Net').getRecordTypeId() : null, Merchant__c = 'Northeast Dedham');
            OpportunityLineItem oli;
            Product2 product;
            for(Dom.XmlNode childElement1:AuthorizeConnector.getAuthorizeObject((AuthorizeNetList__c.getValues('Northeast_Dedham') != null ? AuthorizeNetList__c.getValues('Northeast_Dedham') : new AuthorizeNetList__c()), 'TransactionDetails', new Map<String, String>{'transId' => (String) ((Map<String, Object>) ((Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.ToString())).get('payload')).get('id')})){
                if(childElement1.getName() == 'transaction') for(Dom.XmlNode childElement2:childElement1.getChildElements()){
                    if(childElement2.getName() == 'transId') payment.Authorize_ID__c = opportunity.Authorize_ID__c = childElement2.getText();
                    else if(childElement2.getName() == 'submitTimeUTC' && String.isNotBlank(childElement2.getText())) payment.Submit_Date_Time__c = DateTime.valueOf(childElement2.getText().substringBeforeLast('.').replace('T', ' '));
                    else if(childElement2.getName() == 'transactionType') payment.Transaction_Type__c = childElement2.getText();
                    else if(childElement2.getName() == 'transactionStatus') payment.Transaction_Status__c = childElement2.getText() == 'authorizedPendingCapture' ? 'Authorized/Pending Capture' : childElement2.getText() == 'capturedPendingSettlement' ? 'Captured/Pending Settlement' : childElement2.getText() == 'communicationError' ? 'Communication Error' : childElement2.getText() == 'refundSettledSuccessfully' ? 'Refund' : childElement2.getText() == 'refundPendingSettlement' ? 'Refund/Pending Settlement' : childElement2.getText() == 'approvedReview' ? 'Approved Review' : childElement2.getText() == 'declined' ? 'Declined' : childElement2.getText() == 'couldNotVoid' ? 'Could Not Void' : childElement2.getText() == 'expired' ? 'Expired' : childElement2.getText() == 'generalError' ? 'General Error' : childElement2.getText() == 'failedReview' ? 'Failed Review' : childElement2.getText() == 'settledSuccessfully' ? 'Settled Successfully' : childElement2.getText() == 'settlementError' ? 'Settlement Error' : childElement2.getText() == 'underReview' ? 'Under Review' : childElement2.getText() == 'voided' ? 'Voided' : childElement2.getText() == 'FDSPendingReview' ? 'FDS - Pending Review' : childElement2.getText() == 'FDSAuthorizedPendingReview' ? 'FDS - Authorized/Pending Review' : childElement2.getText() == 'returnedItem' ? 'Returned Item' : childElement2.getText();
                    else if(childElement2.getName() == 'settleAmount' && String.isNotBlank(childElement2.getText())) payment.Amount__c = payment.Settlement_Amount__c = opportunity.Amount = Decimal.valueOf(childElement2.getText());
                    else if(childElement2.getName() == 'authAmount' && String.isNotBlank(childElement2.getText())) payment.Auth_Amount__c = Decimal.valueOf(childElement2.getText());
                    else if(childElement2.getName() == 'authCode') payment.Authorization_Code__c = childElement2.getText();
                    else if(childElement2.getName() == 'marketType') payment.Market_Type__c = childElement2.getText();
                    else if(childElement2.getName() == 'product') payment.Product__c = childElement2.getText();
                    else if(childElement2.getName() == 'customerIP') payment.Customer_IP__c = childElement2.getText();
                    else if(childElement2.getName() == 'cardCodeResponse') payment.Card_Code_Response__c = childElement2.getText();
                    else if(childElement2.getName() == 'responseReasonCode') payment.Response_Reason_Code__c = childElement2.getText();
                    else if(childElement2.getName() == 'responseReasonDescription') payment.Response_Reason_Description__c = childElement2.getText();
                    else if(childElement2.getName() == 'taxExempt' && String.isNotBlank(childElement2.getText())) payment.Tax_Exempt__c = Boolean.valueOf(childElement2.getText());
                    else if(childElement2.getName() == 'AVSResponse') payment.Address_Verification_Status__c = childElement2.getText() == 'Y' ? 'Street Address: Match Zip: Matched first 5 digits' : childElement2.getText() == 'A' ? 'Street Address matches, ZIP code does not' : childElement2.getText() == 'E' ? 'AVS error' : childElement2.getText() == 'B' ? 'Address information not provided for AVS check' : childElement2.getText() == 'N' ? 'No match on Street Address and ZIP code' : childElement2.getText() == 'W' ? '9 digit ZIP code matches, Street Address does not' : childElement2.getText() == 'Z' ? '5 digit ZIP matches, Street Address does not' : childElement2.getText();
                    else if(childElement2.getName() == 'recurringBilling' && String.isNotBlank(childElement2.getText())) payment.Recurring_Billing__c = Boolean.valueOf(childElement2.getText());
                    else if(childElement2.getName() == 'profile') for(Dom.XMLNode childElement3:childElement2.getChildElements()){
                        if(childElement3.getName() == 'customerProfileId') payment.Customer_Id__c = account.Authorize_ID__c = childElement3.getText();                        
                        else if(childElement3.getName() == 'customerPaymentProfileId') payment.Customer_Payment_Id__c = paymentMethod.Authorize_ID__c = childElement3.getText();
                    } 
                    else if(childElement2.getName() == 'customer') for(Dom.XMLNode childElement3:childElement2.getChildElements()){
                        if(childElement3.getName() == 'id') account.Customer_Id__c = childElement3.getText();
                        else if(childElement3.getName() == 'email') account.LastName = account.PersonEmail = childElement3.getText();
                        else if(childElement3.getName() == 'type') paymentMethod.Customer_Type__c = childElement3.getText();
                    } 
                    else if(childElement2.getName() == 'order') for(Dom.XMLNode childElement3:childElement2.getChildElements()){
                        if(childElement3.getName() == 'invoiceNumber') opportunity.Name = opportunity.Invoice_Number__c = childElement3.getText();
                        else if(childElement3.getName() == 'purchaseOrderNumber') opportunity.PO_Number__c = childElement3.getText();
                        else if(childElement3.getName() == 'description') opportunity.Description = childElement3.getText();
                        else if(childElement3.getName() == 'discountAmount' && String.isNotBlank(childElement3.getText())) opportunity.Discount_Amount__c = Decimal.valueOf(childElement3.getText());
                    } 
                    else if(childElement2.getName() == 'tax') for(Dom.XMLNode childElement3:childElement2.getChildElements()){if(childElement3.getName() == 'amount' && String.isNotBlank(childElement3.getText())) opportunity.Tax__c = Decimal.valueOf(childElement3.getText());}
                    else if(childElement2.getName() == 'shipping') for(Dom.XMLNode childElement3:childElement2.getChildElements()){if(childElement3.getName() == 'amount' && String.isNotBlank(childElement3.getText())) opportunity.Shipping__c = Decimal.valueOf(childElement3.getText());}
                    else if(childElement2.getName() == 'duty') for(Dom.XMLNode childElement3:childElement2.getChildElements()){if(childElement3.getName() == 'amount' && String.isNotBlank(childElement3.getText())) opportunity.Duty__c = Decimal.valueOf(childElement3.getText());}
                    else if(childElement2.getName() == 'billTo') for(Dom.XMLNode childElement3:childElement2.getChildElements()){
                        if(childElement3.getName() == 'firstName') opportunity.Billing_First_Name__c = paymentMethod.First_Name__c = childElement3.getText();                        
                        else if(childElement3.getName() == 'lastName') opportunity.Billing_Last_Name__c = paymentMethod.Last_Name__c = childElement3.getText();
                        else if(childElement3.getName() == 'company') opportunity.Billing_Company__c = paymentMethod.Company__c = childElement3.getText();
                        else if(childElement3.getName() == 'address') opportunity.Billing_Street__c = paymentMethod.Billing_Street__c = childElement3.getText();
                        else if(childElement3.getName() == 'city') opportunity.Billing_City__c = paymentMethod.Billing_City__c = childElement3.getText();
                        else if(childElement3.getName() == 'state') opportunity.Billing_State__c = paymentMethod.Billing_State__c = childElement3.getText();
                        else if(childElement3.getName() == 'zip') opportunity.Billing_Zip__c = paymentMethod.Billing_Zip__c = childElement3.getText();
                        else if(childElement3.getName() == 'country') opportunity.Billing_Country__c = paymentMethod.Billing_Country__c = childElement3.getText();
                    } 
                    else if(childElement2.getName() == 'shipTo') for(Dom.XMLNode childElement3:childElement2.getChildElements()){
                        if(childElement3.getName() == 'firstName') opportunity.Shipping_First_Name__c = childElement3.getText();                        
                        else if(childElement3.getName() == 'lastName') opportunity.Shipping_Last_Name__c = childElement3.getText();
                        else if(childElement3.getName() == 'company') opportunity.Shipping_Company__c = childElement3.getText();
                        else if(childElement3.getName() == 'address') opportunity.Shipping_Street__c = childElement3.getText();
                        else if(childElement3.getName() == 'city') opportunity.Shipping_City__c = childElement3.getText();
                        else if(childElement3.getName() == 'state') opportunity.Shipping_State__c = childElement3.getText();
                        else if(childElement3.getName() == 'zip') opportunity.Shipping_Zip__c = childElement3.getText();
                        else if(childElement3.getName() == 'country') opportunity.Shipping_Country__c = childElement3.getText();
                    } 
                    else if(childElement2.getName() == 'subscription') for(Dom.XMLNode childElement3:childElement2.getChildElements()){
                        if(childElement3.getName() == 'id') payment.Authorize_Subscription_Id__c = opportunity.Authorize_Subscription_Id__c = childElement3.getText();                        
                        else if(childElement3.getName() == 'payNum' && String.isNotBlank(childElement3.getText())) payment.Authorize_Payment_Number__c = opportunity.Authorize_Payment_Count__c = Integer.valueOf(childElement3.getText());
                    }
                    else if(childElement2.getName() == 'payment') for(Dom.XMLNode childElement3:childElement2.getChildElements()) for(Dom.XMLNode childElement4:childElement3.getChildElements()){
                        if(childElement4.getName() == 'cardType') payment.Card_Type__c = paymentMethod.Card_Type__c = childElement4.getText();                        
                        else if(childElement4.getName() == 'cardNumber') payment.Card_Number__c = paymentMethod.Card_Number__c = opportunity.Card_Number__c = childElement4.getText();
                    }
                    else if(childElement2.getName() == 'lineItems') for(Dom.XMLNode childElement3:childElement2.getChildElements()){
                        oli = new OpportunityLineItem(UnitPrice = 0);
                        product = new product2(isActive = true);
                        for(Dom.XMLNode childElement4:childElement3.getChildElements()){
                            if(childElement4.getName() == 'itemId'){oli.Item_Id__c = childElement4.getText();oli.Authorize_ID__c = (String.isNotBlank(opportunity.Name) ? opportunity.Name : String.isNotBlank(opportunity.PO_Number__c) ? opportunity.PO_Number__c : payment.Authorize_ID__c) + '-' + childElement4.getText();}
                            else if(childElement4.getName() == 'name') oli.Authorize_Product_Name__c = product.Name = childElement4.getText();
                            else if(childElement4.getName() == 'description') oli.Description = product.Description = childElement4.getText();
                            else if(childElement4.getName() == 'quantity' && String.isNotBlank(childElement4.getText())) oli.Quantity = Integer.valueOf(childElement4.getText());
                            else if(childElement4.getName() == 'unitPrice' && String.isNotBlank(childElement4.getText())) oli.UnitPrice = product.List_Price__c = Decimal.valueOf(childElement4.getText());
                        }
                        if(String.isNotBlank(oli.Item_Id__c)) olisMap.put(oli.Authorize_ID__c, oli);
                        if(String.isNotBlank(product.Name)) productsMap.put(product.Name.toLowerCase(), product);
                    } 
                }
            }
	        List<Database.SaveResult> saveResults;
            Database.SaveResult saveResult;
            if(String.isNotBlank(payment.Customer_Id__c)){
                for(Account acc:[Select id, Authorize_ID__c from Account where Authorize_ID__c =:payment.Customer_Id__c]) account.id = acc.id;                    
                if(String.isEmpty(account.id)){
                    saveResult = Database.insert(account, false);
                    if(!saveResult.isSuccess()) for(Database.Error saveError : saveResult.getErrors()) System.debug('AuthorizePaymentWebHook - Person Account insert Error: ' + saveError.getMessage());
                }
            } 
            else if(String.isNotBlank(account.Customer_Id__c)) for(Account acc:[Select id, Authorize_ID__c from Account where Authorize_ID__c =:account.Customer_Id__c]) account.id = acc.id;
            if(String.isNotBlank(payment.Customer_Payment_Id__c)){
                for(Payment_Method__c payMethod:[Select id, Authorize_ID__c from Payment_Method__c where Authorize_ID__c =:payment.Customer_Payment_Id__c]) paymentMethod.id = payMethod.id;
                if(String.isEmpty(paymentMethod.id)){
                    saveResult = Database.insert(paymentMethod, false);
                    if(!saveResult.isSuccess()) for(Database.Error saveError : saveResult.getErrors()) System.debug('AuthorizePaymentWebHook - Payment Method Insert Error: ' + saveError.getMessage());
                }
            }
            List<product2> productsToInsert = new List<product2>();
            for(Product2 prod:[Select id, Name from Product2 where Name in:productsMap.keySet()]) productsMap.get(prod.Name.toLowerCase()).id = prod.id;
            for(Product2 prod:productsMap.values()) if(String.isEmpty(prod.id)) productsToInsert.add(prod);
            if(!productsToInsert.isEmpty()){
                saveResults = Database.insert(productsToInsert);
                for(Database.SaveResult saveRslt:saveResults) if(!saveRslt.isSuccess()) for(Database.Error saveError : saveRslt.getErrors()) System.debug('AuthorizePaymentWebHook - Product2 Insert Error: ' + saveError.getMessage());
                List<pricebookentry> pbes = new List<pricebookentry>();
                Id standardPricebookId = !Test.isRunningTest() ? [Select id from pricebook2 where isStandard = true limit 1].id : Test.getStandardPricebookId();
                for(Product2 prod:productsToInsert) pbes.add(new pricebookentry(product2id = prod.id, pricebook2id = standardPricebookId, UnitPrice = prod.List_Price__c, isActive = true));
                saveResults = Database.insert(pbes, false);
                for(Database.SaveResult saveRslt:saveResults) if(!saveRslt.isSuccess()) for(Database.Error saveError : saveRslt.getErrors()) System.debug('AuthorizePaymentWebHook - Pricebookentry insert Error: ' + saveError.getMessage());
            }
            try{
                if(String.isBlank(opportunity.Name)) opportunity.Name = String.isNotBlank(opportunity.PO_Number__c) ? opportunity.PO_Number__c : payment.Authorize_ID__c;
	            if(String.isNotEmpty(opportunity.Authorize_Subscription_ID__c)) for(Opportunity opp:[Select id from Opportunity where Authorize_Subscription_ID__c =:opportunity.Authorize_Subscription_ID__c]) opportunity.id = opp.id;
                opportunity.AccountId = account.id;
                opportunity.Payment_Method__c = paymentMethod.id;
                if((payment.Transaction_Status__c != 'Captured/Pending Settlement' || payment.Transaction_Status__c!='Settled Successfully') && String.isNotEmpty(opportunity.Authorize_Subscription_ID__c)) opportunity.Authorize_Subscription_Status__c='Suspended';
                if(String.isNotEmpty(opportunity.id)) update opportunity;
                else upsert opportunity Authorize_ID__c;                
                List<OpportunityLineItem> olisToInsert = new List<OpportunityLineItem>();
                Map<String, pricebookentry> pbesMap = new Map<String, pricebookentry>();
                for(pricebookentry pbe : [Select id, product2.Name from pricebookentry where product2.Name in:productsMap.keySet() and pricebook2.isStandard = true]) pbesMap.put(pbe.product2.Name.toLowerCase(), pbe);
                for(OpportunityLineItem oppli:[Select id, Authorize_ID__c from OpportunityLineItem where Authorize_ID__c in:olisMap.keySet()]) olisMap.get(oppli.Authorize_ID__c).id = oppli.id;
                for(OpportunityLineItem oppli:olisMap.values()){
                    if(String.isEmpty(oppli.id)){
                        oppli.opportunityid = opportunity.id;
                        oppli.pricebookEntryId = String.isNotBlank(oppli.Authorize_Product_Name__c) && pbesMap.get(oppli.Authorize_Product_Name__c.toLowerCase()) != null ? pbesMap.get(oppli.Authorize_Product_Name__c.toLowerCase()).id : null;
                        olisToInsert.add(oppli);
                    }
                }
                if(!olisToInsert.isEmpty()){
                    saveResults = Database.insert(olisToInsert, false);
                    for(Database.SaveResult saveRslt:saveResults) if(!saveRslt.isSuccess()) for(Database.Error saveError : saveRslt.getErrors()) System.debug('AuthorizePaymentWebHook - OpportunityLineItem insert Error: ' + saveError.getMessage());
                }
                payment.Account__c = account.id;
                payment.Payment_Method__c = paymentMethod.id;
                payment.Opportunity__c = opportunity.id;
                if(String.isEmpty(account.id)) payment.Orphaned_Payments__c = true;
                upsert payment Authorize_ID__c;
            }
            catch(DMLException e){
            	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); mail.setToAddresses(new String[] {'rurupeque@cloudcreations.com'}); mail.setSubject('Rocky Mountain: AuthorizeNortheastPaymentWebHook - DML Error'); mail.setHtmlBody('<strong>Upsert Error: </strong>' + e.getMessage() + '<br/><strong>X-ANET-Signature: </strong>' + RestContext.request.headers.get('X-ANET-Signature') + '<br/><strong>Body: </strong>' + RestContext.request.requestBody.ToString()); Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            }
        }
        else{
            RestResponse res = RestContext.response;
            res.statusCode = 400;           
        }
    }
}