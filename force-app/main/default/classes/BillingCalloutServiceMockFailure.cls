/**
 * @description       : 
 * @author            : cubiascaceres
 * @group             : 
 * @last modified on  : 03-25-2022
 * @last modified by  : cubiascaceres
**/
public class BillingCalloutServiceMockFailure implements WebServiceMock {
   
   /**
   * @description 
   * @author cubiascaceres | 03-25-2022 
   * @param stub 
   * @param req 
   * @param res 
   * @param endpoint 
   * @param action 
   * @param reqName 
   * @param responseNS 
   * @param resName 
   * @param resType 
   **/
   public void doInvoke(Object stub, Object req, Map<String, Object> res, String endpoint, String action, String reqName, String responseNS, String resName, String resType) {
      BillingServiceProxy.billProjectResponse_element responsex = new BillingServiceProxy.billProjectResponse_element();
      responsex.status = 'UNAUTHORIZED';
      res.put('response_x', responsex); 
   }
}