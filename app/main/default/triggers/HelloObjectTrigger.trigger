trigger HelloObjectTrigger on Hello_Object__c (before insert) 
{
    if(Trigger.IsBefore && Trigger.IsInsert)
    {
        for(Hello_Object__c hel : Trigger.New)
        {
            hel.Name = 'My Name';
        }
    }
}