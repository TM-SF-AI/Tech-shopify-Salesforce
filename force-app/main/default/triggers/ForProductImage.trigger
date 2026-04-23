trigger ForProductImage on Product2 (Before insert) {
    if(trigger.isInsert && trigger.isBefore){
        for(product2 prod : trigger.new){
            if(prod.Shopify_Product_Image_URL__c == null || prod.Shopify_Product_Image_URL__c == ''){
                prod.Shopify_Product_Image_URL__c = 'https://www.m1homes.com/images/not-available.png';
             }
        }    
    }
}