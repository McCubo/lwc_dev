/**
 * @description       : 
 * @author            : cubiascaceres
 * @group             : 
 * @last modified on  : 03-25-2022
 * @last modified by  : cubiascaceres
**/
trigger ProjectTrigger on Project__c (after update) {
    
    BillingCalloutService.callBillingService(Trigger.new, Trigger.oldMap);

}