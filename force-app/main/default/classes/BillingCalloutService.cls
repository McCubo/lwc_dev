/**
 * @description       : 
 * @author            : cubiascaceres
 * @group             : 
 * @last modified on  : 03-25-2022
 * @last modified by  : cubiascaceres
**/
public with sharing class BillingCalloutService {
    
    /**
    * @description if criteria is met, callout external web service
    * @author cubiascaceres | 03-25-2022 
    * @param projects list of new records
    * @param oldRecords Map of old records
    **/
    public static void callBillingService(List<Project__c> projects, Map<Id, Project__c> oldRecords) {
        
        String projectId;

        for (Project__c project : projects) {
            if (project.Status__c == 'Billable' && project.Status__c != oldRecords.get(project.Id).Status__c) {
                projectId = project.Id;
                break;
            }
        }
        if (String.isNotBlank(projectId)) {
            callBillingService(projectId);
        }
    }

    @future(callout = true)
    private static void callBillingService(String projectId) {
        BillingServiceProxy.project billProject = getBillProject(projectId);
        String response = new BillingServiceProxy.InvoicesPortSoap11().billProject(billProject);
        if (response.toUpperCase() == 'OK' && Project__c.SObjectType.getDescribe().isUpdateable()) {
            Project__c project = new Project__c(
                Id = projectId,
                Status__c = 'Billed'
            );
            update project;
        }
    }

    private static BillingServiceProxy.project getBillProject(String projectId) {
        ServiceCredentials__c billingServiceCredential = ServiceCredentials__c.getValues('BillingServiceCredential');
        Project__c project = [SELECT Id, ProjectRef__c, Billable_Amount__c FROM Project__c WHERE Id = :projectId WITH SECURITY_ENFORCED];
        BillingServiceProxy.project billProject = new BillingServiceProxy.project();
        billProject.username = billingServiceCredential.Username__c;
        billProject.password = billingServiceCredential.Password__c;
        billProject.projectid = project.ProjectRef__c;
        billProject.billAmount = project.Billable_Amount__c;
        return billProject;
    }

}