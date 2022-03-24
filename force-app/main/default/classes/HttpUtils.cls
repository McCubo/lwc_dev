/**
 * @description       : provides helper methods for HTTP operations
 * @author            : cubiascaceres
 * @last modified on  : 03-24-2022
 * @last modified by  : cubiascaceres
**/
public with sharing class HttpUtils {

    private String namedCredential;
    private String method;
    private Map<String, String> headerParameters = new Map<String, String>();
    private String body;
    private List<String> allowedHttpMethods = new List<String>{'GET', 'POST'};

    /**
    * @description set the name of the Named Credential to be used
    * @author cubiascaceres | 03-24-2022 
    * @param namedCredential NamedCredential API Name
    * @return HttpUtils 
    **/
    public HttpUtils withNamedCredential(String namedCredential) {
        this.namedCredential = namedCredential;
        return this;
    }

    /**
    * @description set HTTP method for the new request
    * @author cubiascaceres | 03-24-2022 
    * @param httpMethod allowd value: `POST` or `GET`
    * @return HttpUtils 
    **/
    public HttpUtils withMethod(String httpMethod) {
        if (this.allowedHttpMethods.contains(httpMethod.toUpperCase().trim())) {
            this.method = httpMethod;
            return this;
        }
        throw new HttpException('Http Method not supported');
    }

    /**
    * @description 
    * @author cubiascaceres | 03-24-2022 
    * @param headerParameters 
    * @return HttpUtils 
    **/
    public HttpUtils withHeaders(Map<String, String> headerParameters) {
        this.headerParameters.putAll(headerParameters);
        return this;
    }

    /**
    * @description 
    * @author cubiascaceres | 03-24-2022 
    * @param body 
    * @return HttpUtils 
    **/
    public HttpUtils withBody(String body) {
        this.body = body;
        return this;
    }

    /**
    * @description 
    * @author cubiascaceres | 03-24-2022 
    * @return Response body
    **/
    public HTTPResponse getResponse() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(this.namedCredential);
        req.setMethod(this.method);
        if (!this.headerParameters.isEmpty()) {
            for (String paramKey : this.headerParameters.keySet()) {
                req.setHeader(paramKey, this.headerParameters.get(paramKey));
            }
        }
        if (String.isNotBlank(this.body)) {
            req.setBody(this.body);
            // req.setHeader('Content-Length', this.body.length());
        }
        Http http = new Http();
        return http.send(req);
    }

    /**
     * @description :   Custom Exception
     */
    public class HttpException extends Exception {}
}
