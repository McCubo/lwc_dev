public class Product2Extension {

    public List<ProductWrapper> productsToInsert {get;set;}

    public Product2Extension(ApexPages.StandardController stdController){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for (Integer i = 0; i< Constants.DEFAULT_ROWS; i++) {
            productsToInsert.add(new ProductWrapper());
        }
    }

    public List<ChartHelper.ChartData> GetInventory() {
        return ChartHelper.GetInventory();
    }

    public PageReference save() {
        Savepoint sp = Database.setSavepoint();
        try {

            List<Product2> products = new List<Product2>();
            for (ProductWrapper pw : productsToInsert) {
                if (pw.isValidWrapper()) {
                    products.add(pw.productRecord);
                }                
            }
            insert products;

            List<PricebookEntry> pbes = new List<PricebookEntry>();
            for (ProductWrapper pw : productsToInsert) {
                if (pw.isValidWrapper()) {
                    PricebookEntry pbe = pw.pricebookEntryRecord;
                    pbe.Product2Id = pw.getProductId();
                    pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    pbe.IsActive = pw.productRecord.IsActive;
                    pbes.add(pbe);
                }
            }
            insert pbes;

            // //If successful clear the list and display an informational message
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, productsToInsert.size() + ' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e) {
            Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }

    public List<SelectOption> getFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for (Schema.PicklistEntry ple : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(ple.getValue(), ple.getLabel()));
        }
        return options;
    }

    class ProductWrapper {

        public Product2 productRecord = new Product2();
        public PricebookEntry pricebookEntryRecord = new PricebookEntry();
    
        public String getProductId() {
            return this.productRecord.Id;
        }
    
        public Product2 getProductRecord() {
            return productRecord;
        }
    
        public PricebookEntry getPricebookEntryRecord() {
            return pricebookEntryRecord;
        }
    
        public Boolean isValidWrapper() {
            return String.isNotBlank(productRecord.Name) 
                && pricebookEntryRecord.UnitPrice != null 
                && productRecord.Family != Constants.SELECT_ONE
                && productRecord.Initial_Inventory__c != null;
        }
    }    
}