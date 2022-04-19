public class Product2Helper {

    /**
     * @name COLLABORATION_GROUP
     * @description List of CollaborationGroup used in both business and test logic
    **/
    public static List<CollaborationGroup> COLLABORATION_GROUP = [
        SELECT Id
        FROM CollaborationGroup
        WHERE Name = :Constants.INVENTORY_ANNOUNCEMENTS
        OR Name = :('TEST'+ Constants.INVENTORY_ANNOUNCEMENTS)
        LIMIT 1
    ];

    /**
     * @name afterUpdate
     * @description called by product2 Trigger on After Update
     * @param List<Product2> newList
     * @param List<Product2> oldList
    **/
    public static void AfterUpdate(List<Product2> newList, List<Product2> oldList) {
        //ToDo: Declare a List of Product2 records named needsAnnouncement
        List<Product2> needsAnnouncement = new List<Product2>();
        //ToDo: Declare a Map of Strings to Inventory_Setting__mdt records
        //ToDo: Loop through a query of Inventory_Setting__mdt records and populate the Map with Name as the key
        Map<String, Inventory_Setting__mdt> inventorySettings = Inventory_Setting__mdt.getAll();        

        //ToDo: Loop through the Products in newList
        // Use the corresponding Inventory Setting record to determine the correct Low Quantity Alert
        // If the Product's Quantity Remaining has been changed to less than the Low Quantity Alert
        //      add it to the needsAnnouncement list
        for (Integer i = 0; i < newList.size(); i++) {
            if (newList[i].Quantity_Remaining__c < inventorySettings.get(newList[i].Family).Low_Quantity_Alert__c 
                && newList[i].Quantity_Remaining__c != oldList[i].Quantity_Remaining__c) {
                needsAnnouncement.add(newList[i]);
            }
        }
        //ToDo: Pass records to the postAlerts method
        if (!needsAnnouncement.isEmpty()) {
            PostAlerts(needsAnnouncement);
        }        
    }

    /**
     * @name postAlerts
     * @description called by product2 Trigger on After Update
     * @param List<Product2> productList
    **/
    public static void PostAlerts(List<Product2> productList) {
        List<ConnectApi.AnnouncementInput> announcements = new List<ConnectApi.AnnouncementInput>();
        for ( Product2 p : productList ){
            // ToDo: Construct a new AnnouncementInput for the Chatter Group so that it:
            // expires in a day
            // does not notify users via email.
            // and has a text body that includes the name of the product followed by the INVENTORY_LEVEL_LOW constant
            ConnectApi.MessageBodyInput messageBody = new ConnectApi.MessageBodyInput();
            ConnectApi.TextSegmentInput announcementTextBody = new ConnectApi.TextSegmentInput();
            announcementTextBody.text = p.Name + Constants.INVENTORY_LEVEL_LOW;
            messageBody.messageSegments = new List<ConnectApi.TextSegmentInput>{announcementTextBody};

            ConnectApi.AnnouncementInput announcement = new ConnectApi.AnnouncementInput();            
            announcement.body = messageBody;
            announcement.sendEmails = false;
            announcement.parentId = COLLABORATION_GROUP.get(0).Id;
            announcement.expirationDate = System.today().addDays(1);
            announcements.add(announcement);
        }
        // ToDo: Create and enqueue an instance of the announcementQueuable class with the list of Products
        AnnouncementQueueable q = new AnnouncementQueueable();
        q.toPost = announcements;
        //ToDo: Enqueue the above instance of announcementQueueable
        System.enqueueJob(q);
    }
}