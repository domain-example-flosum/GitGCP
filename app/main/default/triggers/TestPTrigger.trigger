trigger TestPTrigger on TestP__c (before insert) {
    System.debug('TestP');
}