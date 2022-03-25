/**
 * @description       : exposes methods to be accesible through REST calls to
 *                      Synchronize Inbound Project Data
 * @author            : cubiascaceres
 * @group             : 
 * @last modified on  : 03-25-2022
 * @last modified by  : cubiascaceres
**/
@RestResource (urlMapping = '/project/*')
global with sharing class ProjectRESTService {
    
    
    /**
    * @description If @HttpPost method has parameters, then Apex REST attempts to deserialize the data into those parameters and the data 
    *               won't be deserialized into the RestRequest.requestBody property
    * @author cubiascaceres | 03-25-2022 
    * @param ProjectRef 
    * @param ProjectName 
    * @param OpportunityId 
    * @param StartDate 
    * @param EndDate 
    * @param Amount 
    * @param Status 
    * @return String `OK` when success, Exception error otherwise
    **/
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        Savepoint sp = Database.setSavepoint();
        try {
            Project__c project = new Project__c(
                ProjectRef__c = ProjectRef,
                Name = ProjectName,
                Opportunity__c = OpportunityId,
                Start_Date__c = StartDate,
                End_Date__c = EndDate,
                Billable_Amount__c = Amount,
                Status__c = Status
            );
            if (Project__c.SObjectType.getDescribe().isUpdateable() || Project__c.SObjectType.getDescribe().isCreateable()) {
                upsert project ProjectRef__c;
            }
            Opportunity parentOpportunity = new Opportunity(
                Id = OpportunityId,
                DeliveryInstallationStatus__c = 'In progress'
            );
            if (Opportunity.SObjectType.getDescribe().isUpdateable()) {
                update parentOpportunity;
            }
            return 'OK';
        } catch (Exception e) {
            Database.rollback(sp);
            return e.getMessage();
        }
    }
}