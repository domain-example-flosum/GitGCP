//@lastupdated : 2015.12.14 6pm
trigger License_user_Verify_Alert on sfLma__License__c (after insert) 
{
          
        
    string pkgname;
    string enddate;
    set<id> leadIds = new Set<Id>();
     NotifyNewUser nusr = new NotifyNewUser();
     list<sfLma__License__c> licenses = [select sfLma__Expiration_Date__c,sfLma__Seats__c,Name,sfLma__Lead__c,
                                          sfLma__Package_Version__c from sfLma__License__c where ID IN:trigger.new ];
    for( sfLma__License__c license : licenses)
    {
        leadIds.add(license.sfLma__Lead__c);
    }
        
    for(sfLma__License__c lic :licenses)
    {
       for (sfLma__Package__c Pkg : [select name from sfLma__Package__c 
                                        where id in 
                                        ( select sfLma__Package__c from sfLma__Package_Version__c
                                            where id =:lic.sfLma__Package_Version__c )
                                            Limit 1] )
            pkgname = Pkg.name;            
    }  
      
    Map<Id,lead> leads = new Map<Id,Lead>([select email,firstname,lastname,Phone,Company,Id,Business_Email__c,
                                            WP_User_Created__c from lead where id IN: leadIds]);
    
    //List of all objects having FlosumStatus=Active Paid Customer and before inserting new objects
    List<sfLma__License__c> beforeInsertLicense = [Select FlosumStatus__c, sfLma__Lead__c, LeadEmail__c From sfLma__License__c Where FlosumStatus__c ='Active Paid Customer' AND Id NOT IN :trigger.new];
        
    //store beforeInsertLicense Lead Id's 
    Set<String> repeatLead = new Set<String>(); 
    for(sfLma__License__c sf : beforeInsertLicense)       
    	repeatLead.add(sf.LeadEmail__c);
          
    for(Lead  tmp : leads.values())
    {
      
      //string emailAddr =tmp.email;    
      //string fname = tmp.FirstName; 
      boolean allowed;
      if(tmp.Email != null && !repeatLead.contains(tmp.Email)) {
      		//disable if lead already a paid customer
      		if(!tmp.WP_User_Created__c)  
	        {
	         VerifyEmailDomain alldom = new VerifyEmailDomain();
	         allowed = alldom.IsdomainAllowed(tmp.email);
	            if( allowed )
	            {
	                if( pkgname!='Dataplier') 
	                {
	                  tmp.Business_Email__c = True;
	                  tmp.WP_User__c = true;
	                  update tmp;
	                  //BatchWithCallout batchapex = new BatchWithCallout();
	                  //Database.executebatch(batchapex,1);
	                    
	                  //send welcome email with package
	                     //NotifyNewUser nusr = new NotifyNewUser();
	                     //if(pkgname=='Dataplier')
	                     //nusr.SendmailToNewUSer(tmp.email,tmp.FirstName,tmp.lastname,pkgname);
	                 nusr.SendmailToNonBusinessUser(tmp.email,tmp.FirstName,pkgname);
	             
	                }
	                else
	                {
	                    //send mail to use business email address
	                    //if(pkgname=='Dataplier')
	                        //nusr.SendmailToNewUser(tmp.email,tmp.FirstName,tmp.lastname,pkgname);
	                    //else
	                        nusr.SendmailToNonBusinessUser(tmp.email,tmp.FirstName,pkgname);
	                }
	            }
	            else
	            {
	                //send mail to use business email address
	                nusr.SendmailToNonBusinessUser(tmp.email,tmp.FirstName,pkgname);
	            }
	      }
	      else
	      {
	          //user already exists
	          //send mail to login using same credentials. Send link to reset password
	         
	           if(pkgname=='Dataplier')
	                nusr.SendmailToNewUser(tmp.email,tmp.FirstName,tmp.lastname,pkgname);
	            else
	              nusr.SendmailToReturningUser(tmp.email,tmp.FirstName,pkgname);
	          
	      } 
      	
      }
      
    }
    lead leadrec= leads.get( licenses[0].sfLma__Lead__c );
    //only when new lead
    if(!repeatLead.contains(leadrec.Email))
    	nusr.SendmailforLicense( pkgname, licenses[0] , leadrec );
        
}