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
        TestDataFactory.VerifyQuantityOrdered(originalProduct, updatedProduct, 5);
    }

    @IsTest
    static void OrderExtension_UnitTest() {
        PageReference pagRef = page.OrderEdit;
        Test.startTest();
        Order o = [SELECT Id FROM Order LIMIT 1];
        ApexPages.StandardController sc = new  ApexPages.StandardController(o);
        OrderExtension ext = new OrderExtension(sc);
        ext.OnFieldChange();
        ext.SelectFamily();
        ext.Save();
        ext.First();
        ext.Next();
        ext.Previous();
        ext.Last();
        ext.GetHasPrevious();
        ext.GetHasNext();
        ext.GetTotalPages();
        ext.GetPageNumber();
        ext.GetFamilyOptions();
        Test.stopTest();
        
    }
}