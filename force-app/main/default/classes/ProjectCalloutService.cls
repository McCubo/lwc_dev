/**
 * @description       : make an outbound RESTful call. Then send a POST request to the service endpoint with a JSON packet 
 *                      containing the fields OpportunityId, OpportunityName, AccountName, CloseDate, and Amount.
 * @author            : cubiascaceres
 * @group             : trailblazer
 * @last modified on  : 03-24-2022
 * @last modified by  : cubiascaceres
**/
public class ProjectCalloutService {

    /**
    * @description Complete the implementation for business and callout logic
    * @author cubiascaceres | 03-23-2022 
    * @param opportunityIds
    **/
    @InvocableMethod(label = 'Post Opportunity To PMS')
    public static void postOpportunityToPMS(List<Id> opportunityIds) {
        System.enqueueJob(new QueueablePMSCall(opportunityIds.get(0)));
    }

    /**
     * @description : potential future enqueuing inside other asynchronous jobs
     */
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts {

        private PmsWrapper opportunityWrapper;

        /**
        * @description Init Queueable variable with all required properties
        * @author cubiascaceres | 03-24-2022 
        * @param opportunityId
        **/
        public QueueablePMSCall(Id opportunityId) {
            this.opportunityWrapper = new PmsWrapper(opportunityId);
        }

        /**
        * @description 
        * @author cubiascaceres | 03-23-2022 
        * @param context 
        **/
        public void execute(QueueableContext context) {
            ServiceTokens__c projectService = ServiceTokens__c.getValues('ProjectServiceToken');
            HTTPResponse response = new HttpUtils()
                .withNamedCredential('callout:ProjectService')
                .withMethod('post')
                .withBody(JSON.serialize(this.opportunityWrapper))
                .withHeaders(new Map<String, String>{'token' => projectService.Token__c, 'Content-Type' => 'application/json'})
                .getResponse();
            // Response Codes: 201 = Success | 500 = Failure
            if (response.getStatusCode() == 201) {
                Opportunity op = new Opportunity(
                    Id = this.opportunityWrapper.opportunityId,
                    StageName = 'Submitted Project'
                );
                update op;
            } else if (response.getStatusCode() == 500) {
                Opportunity op = new Opportunity(
                    Id = this.opportunityWrapper.opportunityId,
                    StageName = 'Resubmit Project'
                );
                update op;
            }
        }
    }

    /**
     * @description     : provides a wrapper class to capture all required parameters
     */
    public with sharing class PmsWrapper {

        public String opportunityId;
        public String opportunityName;
        public String accountName;
        public String closeDate;
        public Decimal amount;


        /**
        * @description 
        * @author cubiascaceres | 03-24-2022 
        * @param opportunityId 
        **/
        public PmsWrapper(Id opportunityId) {
            this.opportunityId = opportunityId;
            this.fillProperties();
        }

        private void fillProperties() {
            List<Opportunity> opList = [SELECT Id, Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id = :this.opportunityId WITH SECURITY_ENFORCED];
            if (!opList.isEmpty()) {
                Opportunity op = opList.get(0);
                this.opportunityName = op.Name;
                this.accountName = op.Account.Name;
                this.closeDate = String.valueOf(op.CloseDate);
                this.amount = op.Amount;
            }
        }

    }

}