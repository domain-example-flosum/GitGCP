public class FlosumLicenseExpireHandler 
{
	public static void expireLicenseAndSendEmailsToCustomers()
	{
		String flosumPackageId = '033o000000036oLAAQ';
		String dataMigratorPackageId = '0331a000000U4XiAAK';
    
		Map<Id, sfLma__License__c> FlosumlicenseIdMap = new Map<Id, sfLma__License__c>();
		Map<Id, sfLma__License__c> dataMigratorIdMap = new Map<Id, sfLma__License__c>();
		
		
		for(sfLma__License__c lic : [SELECT Id,Package_Name__c,sfLma__Install_Date__c,sfLma__Expiration_Date__c,sfLma__Package__c,sfLma__Subscriber_Org_ID__c,sfLma__Package__r.sfLma__Package_ID__c,sfLma__Lead__c, sfLma__Lead__r.Email,sfLma__Lead__r.Firstname,
									sfLma__Lead__r.Lastname,sfLma__Lead__r.Phone,sfLma__Lead__r.Company,sfLma__Lead__r.Business_Email__c,
                                    sfLma__Lead__r.WP_User_Created__c, sfLma__Lead__r.Title FROM sfLma__License__c WHERE Id IN:Trigger.New])
		{
			if(lic.sfLma__Package__c != null && lic.sfLma__Package__r.sfLma__Package_ID__c == flosumPackageId)
			{
				FlosumlicenseIdMap.put(lic.Id,lic);
			}
			else if(lic.sfLma__Package__c != null && lic.sfLma__Package__r.sfLma__Package_ID__c == dataMigratorPackageId)
			{
				dataMigratorIdMap.put(lic.Id,lic);
			}
		}
		if(FlosumlicenseIdMap.size() > 0 || dataMigratorIdMap.size() > 0)
		{
			List<sfLma__License__c> licenseList = new List<sfLma__License__c>();
			List<Messaging.SingleEmailMessage> messageLi = new List<Messaging.SingleEmailMessage>();
			for(Id licId : FlosumlicenseIdMap.keySet()) 
			{
				//Email to Flosum customers
				Messaging.SingleEmailMessage tmail = new Messaging.SingleEmailMessage();
				sfLma__License__c licRec = FlosumlicenseIdMap.get(licId);
				String[] toAddresses = new String[] {licRec.sfLma__Lead__r.Email};
				tmail.setToAddresses(toAddresses);
				tmail.setSubject('Please contact the Flosum team first before downloading the trial.'); 
		      	tmail.setReplyTo(label.replyTo);
		      	tmail.setSenderDisplayName('Flosum');
		      	String body = '<p> Hi '+ licRec.sfLma__Lead__r.Firstname + ',<br><br>'+
		      					'Thanks for installing the Flosum trial. Due to the nature of the solution, we recommend to setup a meeting with our account team so that they can train on the solution. To setup a time with our training team, please fill this form ('+
		      					'<a href=http://info.flosum.com/free-trial>http://info.flosum.com/free-trial</a>).'+
		                        '<br><br>Thanks.</p>';
		      	tmail.setHtmlBody(body);
		      	messageLi.add(tmail);
		      	
		      	//Email to Flosum team.
		      	Messaging.SingleEmailMessage tmail2 = new Messaging.SingleEmailMessage();
		      	String[] tmail2ToAddresses = new String[] {'hello@flosum.com','Stephen@flosum.com','gjashnani@flosum.com'};
				tmail2.setToAddresses(tmail2ToAddresses);
				tmail2.setSubject(licRec.sfLma__Lead__r.Firstname+' '+licRec.sfLma__Lead__r.Company+' has download the Flosum trial.');
		      	tmail.setSenderDisplayName('Flosum');
		      	String body2 = '<p>A trial for Flosum has been downloaded.<br><br>'+
		      					'First Name:'+licRec.sfLma__Lead__r.Firstname+'<br>'+
								'Last Name:'+licRec.sfLma__Lead__r.Lastname+'<br>'+
								'Company:'+licRec.sfLma__Lead__r.Company+'<br>'+
								'Email:'+licRec.sfLma__Lead__r.Email+'<br>'+
								'Phone:'+licRec.sfLma__Lead__r.Phone+'<br>'+
								'Title:'+licRec.sfLma__Lead__r.Title+'<br><br>'+
								
								'Org ID:'+licRec.sfLma__Subscriber_Org_ID__c+'<br>'+
								'Install Date:'+licRec.sfLma__Install_Date__c+'<br>'+
								'Expiration Date:'+licRec.sfLma__Expiration_Date__c+'<br>'+
								'Package Name:'+licRec.Package_Name__c+'</p>';
		      	tmail2.setHtmlBody(body2);
		      	messageLi.add(tmail2);
			}
			for(Id licId : dataMigratorIdMap.keySet()) 
			{
				//Email to Data Migrator customers
				Messaging.SingleEmailMessage tmail = new Messaging.SingleEmailMessage();
				sfLma__License__c licRec = dataMigratorIdMap.get(licId);
				String[] toAddresses = new String[] {licRec.sfLma__Lead__r.Email};
				tmail.setToAddresses(toAddresses);
				tmail.setSubject('Please contact the Flosum team first before downloading the trial.'); 
		      	tmail.setReplyTo(label.replyTo);
		      	tmail.setSenderDisplayName('Flosum');
		      	String body = '<p> Hi '+ licRec.sfLma__Lead__r.Firstname + ',<br><br>'+
		      					'Thanks for installing the Data Migrator trial. Due to the nature of the solution, we recommend to setup a meeting with our account team so that they can train on the solution. To setup a time with our training team, please fill this form ('+
		      					'<a href=http://info.flosum.com/free-trial>http://info.flosum.com/free-trial</a>).'+
		                        '<br><br>Thanks.</p>';
		      	tmail.setHtmlBody(body);
		      	messageLi.add(tmail);
		      	
		      	//Email to Data Migrator team.
		      	Messaging.SingleEmailMessage tmail2 = new Messaging.SingleEmailMessage();
		      	String[] tmail2ToAddresses = new String[] {'hello@flosum.com','Stephen@flosum.com','gjashnani@flosum.com'};
				tmail2.setToAddresses(tmail2ToAddresses);
				tmail2.setSubject(licRec.sfLma__Lead__r.Firstname+' '+licRec.sfLma__Lead__r.Company+' has download the Flosum trial.');
		      	tmail.setSenderDisplayName('Flosum');
		      	String body2 = '<p>A trial for Data Migrator has been downloaded.<br><br>'+
		      					'First Name:'+licRec.sfLma__Lead__r.Firstname+'<br>'+
								'Last Name:'+licRec.sfLma__Lead__r.Lastname+'<br>'+
								'Company:'+licRec.sfLma__Lead__r.Company+'<br>'+
								'Email:'+licRec.sfLma__Lead__r.Email+'<br>'+
								'Phone:'+licRec.sfLma__Lead__r.Phone+'<br>'+
								'Title:'+licRec.sfLma__Lead__r.Title+'<br><br>'+
								
								'Org ID:'+licRec.sfLma__Subscriber_Org_ID__c+'<br>'+
								'Install Date:'+licRec.sfLma__Install_Date__c+'<br>'+
								'Expiration Date:'+licRec.sfLma__Expiration_Date__c+'<br>'+
								'Package Name:'+licRec.Package_Name__c+'</p>';
		      	tmail2.setHtmlBody(body2);
		      	messageLi.add(tmail2);
			}
			
			if(messageLi.size() > 0)
			{
				Messaging.sendEmail(messageLi);
			}
			Set<Id> idSet = new Set<Id>();
			idSet.addAll(dataMigratorIdMap.keySet());
			idSet.addAll(FlosumlicenseIdMap.keySet());
			expireTheseLicense(idSet);
		}
	}
	
	@future
	public static void expireTheseLicense(Set<Id> licenseIdSet)
	{
		List<sfLma__License__c> newList = new List<sfLma__License__c>();
		for(sfLma__License__c lic : [SELECT Id, sfLma__Seats__c, sfLma__Expiration__c, RecordTypeId, sfLma__Status__c FROM sfLma__License__c WHERE Id IN:licenseIdSet])
		{
			lic.sfLma__Seats__c = 1;
			lic.sfLma__Expiration__c = System.today();
			//lic.sfLma__Status__c = 'Suspended';
			//lic.RecordTypeId = Schema.SObjectType.sfLma__License__c.RecordTypeInfosByName.get('Expired').RecordTypeId;
			newList.add(lic);
		}
		if(newList.size() > 0)
			update newList;
	}
}