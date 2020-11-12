trigger EmailTrigger_License on sfLma__License__c (after insert) {
    string pkgname;
   for(sfLma__License__c lic :[select sfLma__Package_Version__c from sfLma__License__c where id=:trigger.new])
    {
       for (sfLma__Package__c Pkg : [select name from sfLma__Package__c where id in (select sfLma__Package__c from sfLma__Package_Version__c where id =:lic.sfLma__Package_Version__c )Limit 1])
        		pkgname = Pkg.name;
    }
    
    //List of all objects having FlosumStatus=Active Paid Customer and before inserting new objects
    List<sfLma__License__c> beforeInsertLicense = [Select FlosumStatus__c, sfLma__Lead__c From sfLma__License__c Where FlosumStatus__c ='Active Paid Customer' AND Id NOT IN :trigger.new];
    
    //store beforeInsertLicense Lead Id's 
    Set<Id> repeatLead = new Set<Id>(); 
    for(sfLma__License__c sf : beforeInsertLicense)
    	repeatLead.add(sf.sfLma__Lead__c);
    
    for(Lead  tmp : [select email,firstname,Id,Name,Company,Phone from lead where id in (select sfLma__Lead__c from sfLma__License__c where id=:Trigger.new)])
    { 
	  // check if lead Id's not already exist salesforce    
	  if(!repeatLead.contains(tmp.Id))  {  
	  		  List<Messaging.SingleEmailMessage> allTmails = new List<Messaging.SingleEmailMessage>();
	  		  //Email to girish saying new lead created
	  		  Messaging.SingleEmailMessage firstTmail = new Messaging.SingleEmailMessage();
	  		  firstTmail.setSubject('New lead has been created : '+tmp.Name);
	  		  String body ='The following lead has been created. Please reach out to them.\n'+ 'Lead Name: ' + tmp.Name + '\n' + 'Company: ' + tmp.Company + '\n' +
	  		  				 'Email: '+tmp.Email  + '\n' +'Phone: '+ tmp.Phone + '\n' + 'Thanks.'; 
	  		  firstTmail.setPlainTextBody(body);
	  		  firstTmail.setToAddresses(new String[] {'jshih@flosum.co'});
	  		  allTmails.add(firstTmail);
	  		  
	  		  
		      Messaging.SingleEmailMessage tmail = new Messaging.SingleEmailMessage();
		      string emailAddr =tmp.email;
		      string fname = tmp.FirstName;
		        
		     
		      String[] toAddresses = new String[] {emailAddr};
		      tmail.setToAddresses(toAddresses);
		
		      tmail.setSubject('Welcome to Flosum'); 
		        
		     // tmail.setReplyTo('girish@flosum.com');
		        tmail.setReplyTo('jshih@flosum.co');
		      /* disable below code before moving to production */
		     // tmail.setSenderDisplayName('Girsih Jashnani');
		        
		
		        /* enable below code for production*/
		        
		        //String[] bccAddress = new String[] {'girish@flosum.com','flosum.trial@gmail.com'};
		        String[] bccAddress = new String[] {'jshih@flosum.co','flosum.trial@gmail.com'};
		      	tmail.setBccAddresses(bccAddress);
		        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'jshih@flosum.co'];
		        if ( owea.size() > 0 ) {
		        tmail.setOrgWideEmailAddressId(owea.get(0).Id);
		        } 
		        
		        // use the html body to set the content of the body
		        //
		       if (pkgname =='Dataplier')
		        {
		            tmail.setHtmlBody('<p> Hi '+ fname + ',<br><br>Welcome onboard, thank you for trying out Data Migrator.<br><br>The user guide for data migrator can be found here:<br>'+
								'<a href=http://help.flosum.com/knowledgebase/articles/687288-data-migrator-s-user-guide/>http://help.flosum.com/knowledgebase/articles/687288-data-migrator-s-user-guide/</a>'+
								'<br><br>For any questions, please send an email to <a href=hello@flosum.com>hello@flosum.com</a>'+
								'<br><br>Thank You !<br><br>Girish Jashnani<br>650.387.1006<br>Demo: www.flosum.com<br></p>');
		        }
		        else
		        {
		            tmail.setHtmlBody('<p> Hi '+ fname +',<br><br>Thank for you taking the time to try out Flosum !'+
		                        '<br><br>The trial instructions are available here:<br>'+
		                         '<a href=http://www.flosum.com/trial-instructions/>http://www.flosum.com/trial-instructions/</a>'+
		                         '<br><br>Please use your corporate email address to register and you should '+
		                         'be able to access the trial instructions.<br><br>For any questions, '+
		                         'please send an email to <a href=hello@flosum.com>hello@flosum.com</a>'+
		                         '<br><br>Thank You !<br><br>Girish Jashnani<br>650.387.1006<br>Demo: www.flosum.com<br></p>');
		        }
		      	
		      	allTmails.add(tmail);
		        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { tmail});  
		        Messaging.sendEmail(allTmails);    
        
        }
      }  
    }