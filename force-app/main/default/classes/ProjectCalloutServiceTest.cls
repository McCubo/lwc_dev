/**
 * @description       : 
 * @author            : cubiascaceres
 * @group             : 
 * @last modified on  : 03-24-2022
 * @last modified by  : cubiascaceres
**/
@IsTest
private class ProjectCalloutServiceTest {

    /**
    * @description creates data used across all test methods
    * @author cubiascaceres | 03-24-2022 
    **/
    @TestSetup
    static void init() {
        Account acMain = new Account(
            Name = 'Test Account'
        );
        insert acMain;

        Opportunity opNewProject = new Opportunity(
            Name = 'Test Opportunity',
            Type = 'New Project',
            StageName = 'Prospecting',
            AccountId = acMain.Id,
            CloseDate = Date.today()
        );
        insert opNewProject;
        
        ServiceTokens__c projectService = new ServiceTokens__c(
          Token__c = '00000000-0000-0000-0000-000000000001',
          Name = 'ProjectServiceToken'
        );

        insert projectService;
    }

    @IsTest
    static void restCallOnSuccessTest() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());        
        Test.startTest();
        Opportunity opNewProject = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity'];
        opNewProject.StageName = 'Closed Won';
        opNewProject.Amount = 1500;
        update opNewProject;
        Test.stopTest();
        Opportunity updatedOp = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Test Opportunity'];
        System.assertEquals('Submitted Project', updatedOp.StageName, 'Stage was not updated');
    }

    @IsTest
    static void restCallOnFailureTest() {
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());        
        Test.startTest();
        Opportunity opNewProject = [SELECT Id FROM Opportunity WHERE Name = 'Test Opportunity'];
        opNewProject.StageName = 'Closed Won';
        opNewProject.Amount = 1500;
        update opNewProject;
        Test.stopTest();
        Opportunity updatedOp = [SELECT Id, StageName FROM Opportunity WHERE Name = 'Test Opportunity'];
        System.assertEquals('Resubmit Project', updatedOp.StageName, 'Stage was not updated');
    }    

}