public class Wordpress_AsyncCall {
	
    @future (callout=true)
    public static void callwordpress(string endp){
        Httprequest req = new HttpRequest();
        
        req.setEndpoint(endp);
        
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setBody('name2=Kamran');
        req.setCompressed(true); // otherwise we hit a limit of 32000
      
        Http http = new Http();
        //try{
        http.send(req);
       // }
        //catch(System.CalloutException e) {
         //  System.debug('Callout error: '+ e);
         //  }
        
   }
  public Httpresponse sendNotification(string endp) {

      //string endp ='http://www.petraforce.com/wordpress/wp-salesforce.php?name='+name+'&email='+email+'&orgid='+orgid;
      //string endp ='http://www.flosum.com/wp-salesforce.php?name='+name+'&email='+email+'&orgid='+orgid;
      HttpRequest req = new HttpRequest();
		      
      HttpResponse res = new HttpResponse();
      Http http = new Http();  
      req.setEndpoint(endp);
        req.setMethod('GET');
        req.setTimeout(120000);
        req.setBody('name2=Kamran');
        req.setCompressed(true); // otherwise we hit a limit of 32000
        //req = req1;
      //if(!Test.isRunningtest())
        // callwordpress(endp);
        //else
        //{
       	
         try {
           
            res = http.send(req);
        } catch(System.CalloutException e) {
           System.debug('Callout error: '+ e);
           System.debug(res.toString());
        }
        //}
return res;     
        }
    }