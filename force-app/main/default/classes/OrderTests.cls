@IsTest
private class OrderTests {

    @TestSetup
    static void SetupTestData() {
        TestDataFactory.InsertTestData(1);
    }

    @IsTest
    static void OrderUpdate_UnitTest() {
        Order ord = [SELECT Id FROM Order LIMIT 1];
        Product2 originalProduct = [SELECT Id, Quantity_Ordered__c FROM Product2 LIMIT 1];
        Test.startTest();
        ord.Status = Constants.ACTIVATED_ORDER_STATUS;
        update ord;
        Test.stopTest();
        Product2 updatedProduct = [SELECT Id, Quantity_Ordered__c FROM Product2 LIMIT 1];
        TestDataFactory.VerifyQuantityOrdered(originalProduct, updatedProduct, 10);
    }
}