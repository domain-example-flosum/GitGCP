@isTest
private class WrapperExampleControllerTest{
    @isTest static void test_method_one() {
    WrapperExampleController demo = new WrapperExampleController ();
    demo.myValue = 100;
    demo.getCalculatedValue();
    demo.getCalculatedValueViaPrice(200);
    demo.sendEmail();
    demo.defineArray();
    demo.removeString();
    demo.equalsIgnoreString();
    demo.removeEndString();
    demo.prefixString();
    
    Account acc = new Account();
    acc.Name = 'TestAccount';
    acc.BillingStreet = 'TestStreet';
    acc.BillingCity = 'TestCity';
    acc.BillingPostalCode  = '230154';
    
    insert acc;
    demo.getAccounts();
    demo.getRowWrappers();
    

  }
}