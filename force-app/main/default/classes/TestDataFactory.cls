/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup() {
        
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates. 
        CollaborationGroup collabGroup = new CollaborationGroup(
            Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS,
            CollaborationType = 'Public'
        );
        return collabGroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt) {
        List<Product2> products = new List<Product2>();
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<String> productFamilies = getProductFamilyOptions();
        for (Integer i = 0, z = 0; i < cnt; i++) {
            Product2 product = new Product2(
                Name = 'Prod-Test #' + i,
                IsActive = true,
                Initial_Inventory__c = 10,
                Family = productFamilies.get(z)
            );
            if ((productFamilies.size() -1) == z) {
                z = 0;
            } else {
                z++;
            }            
            products.add(product);
        }
        return products;
    }

    private static List<String> getProductFamilyOptions() {
        List<String> options = new List<String>();
        for (Schema.PicklistEntry option : Constants.PRODUCT_FAMILY) {
            options.add(option.getValue());
        }
        return options;
    }
    
    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods) {
        List<PricebookEntry> pbes = new List<PricebookEntry>();
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        for (Product2 prod : prods) {
            PricebookEntry pbe = new PricebookEntry(
                Product2Id = prod.Id,
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID,
                IsActive = true,
                UnitPrice = 10
            );
            pbes.add(pbe);
        }
        return pbes;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < cnt; i++) {
            Account acc = new Account(
                Name = 'Acc-Test #' + i
            );
            accounts.add(acc);
        }
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        return accounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts) {
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < cnt; i++) {
            Contact con = new Contact(
                FirstName = 'ConFTest#' + i,
                LastName = 'ConLTest #' + i,
                AccountId = accts.get(i).Id
            );
            contacts.add(con);
        }
        return contacts;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts) {
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < cnt; i++) {
            Order o = new Order(
                AccountId = accts.get(i).Id,
                EffectiveDate = System.today(),
                Status = Constants.DRAFT_ORDER_STATUS,
                Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID
            );
            orders.add(o);
        }
        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords) {
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Integer i = 0; i < cnt; i++) {
            OrderItem oi = new OrderItem(
                OrderId = ords.get(i).Id,
                Product2Id = pbes.get(i).Product2Id,
                Quantity = Constants.DEFAULT_ROWS,
                PriceBookEntryId = pbes.get(i).Id,
                UnitPrice = 10
            );
            orderItems.add(oi);
        }
        return orderItems;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt) {
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        CollaborationGroup collabGroup = ConstructCollaborationGroup();
        insert collabGroup;
        List<Product2> prods = ConstructProducts(cnt);
        insert prods;
        List<PricebookEntry> pbes = ConstructPricebookEntries(prods);
        insert pbes;
        List<Account> accounts = ConstructAccounts(cnt);
        insert accounts;
        List<Contact> contacts = ConstructContacts(cnt, accounts);
        insert contacts;
        List<Order> orders = ConstructOrders(cnt, accounts);
        insert orders;
        List<OrderItem> orderItems = ConstructOrderItems(cnt, pbes, orders);
        insert orderItems;
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        System.assertEquals(qtyOrdered + originalProduct.Quantity_Ordered__c, updatedProduct.Quantity_Ordered__c, 'Field not updated correctly!');
    }

}