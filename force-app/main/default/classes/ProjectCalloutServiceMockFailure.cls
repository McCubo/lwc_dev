/**
 * @description       : 
 * @author            : cubiascaceres
 * @group             : 
 * @last modified on  : 03-24-2022
 * @last modified by  : cubiascaceres
**/
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {

   /**
   * @description 
   * @author cubiascaceres | 03-24-2022 
   * @param req 
   * @return HTTPResponse 
   **/
   public HTTPResponse respond(HTTPRequest req) {
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"status":"incomplete"}');
      res.setStatusCode(500);
      return res;
   }
}