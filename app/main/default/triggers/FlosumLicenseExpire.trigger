trigger FlosumLicenseExpire on sfLma__License__c (after insert) 
{
    if(Trigger.isAfter && Trigger.isInsert)
    {
		FlosumLicenseExpireHandler.expireLicenseAndSendEmailsToCustomers();
    }
    /*if(Trigger.isBefore && Trigger.isInsert)
    {
    	FlosumLicenseExpireHandler.expireLicense(Trigger.New);
    }*/
}