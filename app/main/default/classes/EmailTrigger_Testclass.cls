@isTest
public class EmailTrigger_Testclass {
    static testMethod void TestTrigger (){
        Lead ld = new Lead();
        ld.FirstName='test1';
        ld.LastName='test2';  
        ld.Email='testflosum@123india.com';     
        ld.company='Testcomp';
        insert ld;
             
        sfLma__License__c license = new sfLma__License__c();
        license.sfLma__License_Type__c = 'editable';
        license.sfLma__Used_Licenses__c = 1;
        license.sfLma__Seats__c = 10;         
        license.sfLma__Subscriber_Org_ID__c='00D610000008VKH';
        license.sfLma__Lead__c=ld.id;
        license.FlosumStatus__c = 'Indeterminate' ;       
        test.startTest();
        insert license;
        test.stoptest();
        for(Lead  tmp : [select email,firstname,Id from lead where id in (select sfLma__Lead__c from sfLma__License__c where id=:license.id)])
        {
            system.assertEquals(ld.id,tmp.id);
            system.assertEquals('test1',tmp.FirstName);
            system.assertEquals('testflosum@123india.com',tmp.email);
        }
        
        }
}