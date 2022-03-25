/**
 * @description       : 
 * @author            : cubiascaceres
 * @group             : 
 * @last modified on  : 03-25-2022
 * @last modified by  : cubiascaceres
**/
@IsTest
private class BillingCalloutServiceTest {

    @TestSetup
    static void initData() {
      Opportunity opNewProject = new Opportunity(
          Name = 'Super Badge Opportunity',
          Type = 'New Project',
          StageName = 'Prospecting',
          CloseDate = Date.today()
      );
      insert opNewProject;

      Project__c project = new Project__c(
        Name = 'Super badge Project',
        Opportunity__c = opNewProject.Id,
        Status__c = 'Running'
      );
      insert project;

      ServiceCredentials__c billingServiceCredential = new ServiceCredentials__c(
        Name = 'BillingServiceCredential',
        Username__c = 'bsUser1',
        Password__c = 'bsPassword1'
      );
      insert billingServiceCredential;

    }

    @IsTest
    static void soapSuccessTest() {
      Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
      Project__c project = [SELECT Id FROM Project__c WHERE Name = 'Super badge Project'];
      Test.startTest();
      project.Status__c = 'Billable';
      update project;
      Test.stopTest();
      Project__c updatedProject = [SELECT Id, Status__c FROM Project__c WHERE Id = :project.Id];
      System.assertEquals('Billed', updatedProject.Status__c, 'Project callout failed');
    }

    @IsTest
    static void soapFailureTest() {
      Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
      Project__c project = [SELECT Id FROM Project__c WHERE Name = 'Super badge Project'];
      Test.startTest();
      project.Status__c = 'Billable';
      update project;
      Test.stopTest();
      Project__c updatedProject = [SELECT Id, Status__c FROM Project__c WHERE Id = :project.Id];
      System.assertEquals('Billable', updatedProject.Status__c, 'Project callout failed');
    }    
}