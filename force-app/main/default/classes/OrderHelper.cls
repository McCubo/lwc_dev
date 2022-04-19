/**
 * @author  cubiascaceres
 * @date    2022.04.12
 */
public without sharing class OrderHelper {

    /**
     * @name AfterUpdate
     * @description 
     * @param List<Order> newList
     * @param List<Order> oldList
     * @return void
    **/
    public static void AfterUpdate(List<Order> newList, List<Order> oldList) {
        Set<Id> orderIds = new Set<Id>();
        for (Integer i = 0; i < newList.size(); i++) {
            if (newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status == Constants.DRAFT_ORDER_STATUS) {
                orderIds.add(newList[i].Id);
            }
        }
        if (!orderIds.isEmpty()) {
            OrderHelper.RollUpOrderItems(orderIds);
        }        
    }

    /**
     * @name RollUpOrderItems
     * @description Given a set of Activated Order ids, query the child Order Items and related Products to calculate Inventory levels
     * @param Set<Id> activatedOrderIds
     * @return void
    **/
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        //ToDo: Declare a Map named "productMap" of Ids to Product2 records
        Map<Id, Product2> productMap = new Map<Id, Product2>();
        //ToDo: Loop through a query of OrderItems related to the activatedOrderIds
        for (OrderItem oi : [SELECT Id, Product2Id, Product2.Quantity_Ordered__c FROM OrderItem WHERE OrderId IN :activatedOrderIds]) {
            //ToDo: Populate the map with the Id of the related Product2 as the key and Product2 record as the value
            productMap.put(oi.Product2Id, oi.Product2);
        }

        //ToDo: Loop through a query that aggregates the OrderItems related to the Products in the ProductMap keyset
        for (AggregateResult ag : [SELECT Product2Id, SUM(Quantity) quantityOrdered FROM OrderItem WHERE Product2Id IN :productMap.keySet() GROUP BY Product2Id]) {
            String prodId = (String) ag.get('Product2Id');
            if (productMap.containsKey(prodId)) {
                Product2 prod = productMap.get(prodId);
                prod.Quantity_Ordered__c += Integer.valueOf(ag.get('quantityOrdered'));
                productMap.put(prodId, prod);
            }
        }

        //ToDo: Perform an update on the records in the productMap
        if (!productMap.values().isEmpty()) {
            update productMap.values();
        }        
    }

}