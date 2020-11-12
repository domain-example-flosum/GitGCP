public with sharing class BatchWithCallout 
   implements Database.Batchable<SObject>, Database.AllowsCallouts 
{
    public Database.QueryLocator start(Database.BatchableContext BC) 
    { 

        return Database.getQueryLocator('select id,email,Business_Email__c,WP_User__c,WP_User_Created__c,'+
                                        'firstname from lead where WP_User_Created__c=false and WP_User__c=true '+
                                        'and Business_Email__c=true');
    }

    public void execute(Database.BatchableContext info, List<SObject> newlead) { 
    
        string nonce;
        string status;
        string value;
        string jsoninput;
        for (Lead l:[select id,email,Business_Email__c,WP_User__c,WP_User_Created__c,firstname,lastname from lead where WP_User_Created__c=false and WP_User__c=true and Business_Email__c=true])
        {
        	   	nonce=GetNonce();
            	string pwd = l.firstname.substring(0,1)+'100'+l.LastName.substring(0,1);
            	if (nonce !='')
            	{
               	status = createUser(l.email,l.FirstName,nonce,pwd);
                if(status=='ok')
                {
                    //system.debug('User created');
                    l.WP_User_Created__c = true;
                    update l;
                    NotifyNewUser nusr = new NotifyNewUser();
             		//if(pkgname=='Dataplier')
             		nusr.SendmailToNewUSer(l.email,l.FirstName,l.lastname,'flosum');
                    //send mail username and password
                    
                }
                else if(status=='error')
                {
                    //user already exist
                    l.WP_User_Created__c = true;
                    update l;
                    
                    //send mail to reset the password if forgotten
                }
            
            }
            
            
        }
        
    
    }

    public void finish(Database.BatchableContext info) { }
    
     public string parseJson(string sjson,string key){
        
         JSONParser parser = JSON.createParser(sjson);
         string value;
         while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == key)) {
                // Get the value.
                parser.nextToken();
                // Compute the grand total price for all invoices.
                value = parser.getText();
            }
        }
        system.debug(key+'='+value);
        return value;
    }
    
    public string GetNonce(){
        	string nonce;
        	string jsonInput;
        	BatchMockResponse mock = new BatchMockResponse();
        	HttpRequest request = new HttpRequest();
            HttpResponse res;
        	request.setHeader('Content-Type','text/xml;charset=utf-8');
        	request.setEndpoint('http://www.flosum.com/api/?json=get_nonce&controller=user&method=register');
        	request.setMethod('GET');
        	Http http = new Http();
            try{
            	if (Test.isRunningTest())
                {
                    res= mock.respond(request);
                }
                else
                {
                res = http.send(request);
                }
            	jsonInput = res.getBody();
           		string status = parseJson(jsonInput,'status');
                if(status=='ok')
                {
                    nonce = parseJson(jsonInput,'nonce');
                }
        
            }
            catch(System.CalloutException e) {
           		System.debug('Callout error: '+ e);
           		System.debug(res.toString());
                nonce ='';
        		}
        		return nonce;
        
    }
    
    public string createUser(string email,string fname,string nonce,string pwd)
    {
        	string jsonInput,status;
        	HttpRequest request = new HttpRequest();
        	BatchMockResponse mock = new BatchMockResponse();
            HttpResponse res;
            request.setEndpoint('http://www.flosum.com/api/?json=user/register&username='+email+'&email='+email+'&nonce='+nonce+'&display_name='+fname+'&user_pass='+pwd);
        	request.setHeader('Content-Type','text/xml;charset=utf-8');	
        	request.setMethod('GET');
        	HTTP http = new Http();
           		
        	try{
                	if (Test.isRunningTest())
                	{
                    res= mock.respond(request);
                	}
                	else
                	{
               	 	res = http.send(request);
                	}
                    jsonInput = res.getBody();
	                status = parseJson(jsonInput,'status');

            	}
                catch(System.CalloutException e) {
           			System.debug('Callout error: '+ e);
           			System.debug(res.toString());
                    status ='error';
        		}
        		return status;
    }
    
    }