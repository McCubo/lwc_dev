/**
 * @description       : 
 * @author            : cubiascaceres
 * @group             : 
 * @last modified on  : 03-25-2022
 * @last modified by  : cubiascaceres
**/
@IsTest
private class ProjectRESTServiceTest {

    @TestSetup
    static void initData() {
      Opportunity parentOpportunity = new Opportunity(
        Name = 'Super Badge Opportunity',
        StageName = 'Prospesting',
        CloseDate = Date.today()
      );
      insert parentOpportunity;
    }

    @IsTest
    static void postProjectSuccessTest() {      
      RestRequest req = new RestRequest();
      req.requestURI = '/services/apexrest/project/';
      req.httpMethod = 'POST';
      RestContext.request = req;
      Opportunity parentOpportunity = [SELECT Id FROM Opportunity WHERE Name = 'Super Badge Opportunity'];
      String response;
      Test.startTest();
      response = ProjectRESTService.postProjectData('0000001', 'Project Super Badge', parentOpportunity.Id, Date.today(), Date.today().addDays(30), 1984, 'Billed');
      Test.stopTest();
      System.assertEquals('OK', response, 'Exception thrown by POST method');
    }

    @IsTest
    static void postProjectErrorTest() {      
      RestRequest req = new RestRequest();
      req.requestURI = '/services/apexrest/project/';
      req.httpMethod = 'POST';
      RestContext.request = req;
      String response;
      Test.startTest();
      response = ProjectRESTService.postProjectData('0000001', 'Project Super Badge', null, Date.today(), Date.today().addDays(30), 1984, 'Billed');
      Test.stopTest();
      System.assert(response.contains('Upsert failed'), 'Exception was not thrown by POST method');
    }

}