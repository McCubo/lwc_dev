@IsTest
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    @IsTest
    static void Product2Extension_UnitTest(){
        PageReference pagRef = page.Product2New;
        Test.startTest();
            ApexPages.StandardController sc = new  ApexPages.StandardController(new Product2());
            Product2Extension ext = new Product2Extension(sc);
            System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size(), 'Row number does not match the default!');
            ext.addRows();
            System.assertEquals(Constants.DEFAULT_ROWS * 2, ext.productsToInsert.size(), 'Row number does not match the default!');
            Integer i = 0;
            for (Product2Extension.ProductWrapper pw : ext.productsToInsert) {
                if (i == 5) {
                    break;
                }
                pw.getProductRecord().Name = 'Prod-Test';
                pw.getProductRecord().Family = 'Side';
                pw.getProductRecord().Initial_Inventory__c = 100;
                pw.getPricebookEntryRecord().UnitPrice = 9.99;
                i++;
            }
            ext.save();
            List<Product2> newProds = [SELECT Id FROM Product2];
            System.assertEquals(5, newProds.size(), 'Save Method failed!');
            List<SelectOption> options = ext.getFamilyOptions();
            System.assertEquals(5, options.size(), 'Incorrect Number of options were returned!');
        Test.stopTest();
    }

}