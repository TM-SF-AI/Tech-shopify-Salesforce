public class ProductData {
    @AuraEnabled
    public static ProductDataTableWrapper getProductData(Integer pageNumber, Integer pageSize,String shopid) {
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name from Shopify_Configuration__c where id = : shopids];//shopid];
        system.debug('shopdetails' +shopdetails);
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Product2 where Shopify_Shop_Url__c = :shopdetails.Name];
        system.debug('totalRecords ==> ' +totalRecords);
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        ProductDataTableWrapper objDT =  new ProductDataTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;       
        list<string> idslist = new list<string>();
        List<product2> productList2 = [Select Id,CreatedBy.Name,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Product__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 where Shopify_Shop_Url__c = :shopdetails.Name and Product__c = 'Shopify' ORDER BY Name LIMIT :pSize OFFSET :offset];
        system.debug('productList2' +productList2);
        if(productList2.size()>0 && productList2 !=null && productList2.size() != totalRecords){
            System.debug('Size ==> '+productList2.size());
            totalRecords = productList2.size();
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        	objDT.totalRecords = totalRecords;
            System.debug('totalRecords ==> '+objDT.totalRecords);
        }
        
        
        objDT.productList = productList2;
        for(Product2 st: productList2 ){
            idslist.add(st.Id);
            
            system.debug('value'+idslist);
        }
        objDT.productidsList = idslist;
        return objDT;
    }
    
    
    @AuraEnabled
    public static ProductDataTableWrapper getAllProductData(Integer pageNumber, Integer pageSize,String shopid) {
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
         id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name from Shopify_Configuration__c where id = :shopids];
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Product2 where Product__c = 'Salesforce' or Shopify_Shop_Url__c = :shopdetails.Name];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        ProductDataTableWrapper objDT =  new ProductDataTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;       
        list<string> idslist = new list<string>();
        List<product2>productList2 = [Select Id,CreatedBy.Name,Price__c,Product__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 ORDER BY Name LIMIT :pSize OFFSET :offset];
        objDT.productList = productlist2;
        for(Product2 st: productList2 ){
            idslist.add(st.Id);
            system.debug('value'+idslist);
        }
        objDT.productidsList = idslist;
        return objDT;
    }
    
    // import products
    @AuraEnabled
    public static ProductDataTableWrapper getConditionalProductSyncData(date Shopify_Updated_After,date Shopify_Updated_Before,date Shopify_Published_After,date Shopify_Published_Before,Integer pageNumber, Integer pageSize,String shopid,String Productfilter) 
    {
         ProductDataTableWrapper objDT =  new ProductDataTableWrapper();  
        
        system.debug('Shopify_Updated_After :'+ Shopify_Updated_After);
        system.debug('Shopify_Updated_Before :'+ Shopify_Updated_Before);  
        system.debug('Shopify_Published_After :'+ Shopify_Published_After);    
        system.debug('Shopify_Published_Before :'+ Shopify_Published_Before);
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        //Total Records
        //
        Http http = new Http();
         id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c,Product_Mapping__c from Shopify_Configuration__c where id = :shopids limit 1];
        system.debug('shop'+shopdetails);
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        // String shopname = 'https://healthyxpressdemo.myshopify.com';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopname+'/admin/products.json');
        request.setMethod('GET');
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
         map<string,string >newlist = new map<string,string>();
        Map<String, Object> valuesMap = new Map<String, Object>();
        
        String selected = shopdetails.Product_Mapping__c.unescapeHtml4();
        system.debug('selected'+selected);
        List<Object> objList = (List<Object>)  JSON.deserializeUntyped(selected);
        system.debug('objList'+objList);
        for(Object obj : objList) {
            
            String strObj = String.valueOf(obj);
            
            List<String> keyValueList = strObj.split('=');
            
            if(keyValueList.size() > 1) {
                String responseKey = keyValueList[0].replaceAll('[^a-zA-Z0-9\\s+]', '');
                String sfFieldName = keyValueList[1].replaceAll('[^a-zA-Z0-9\\s+]', '');
              //  System.debug('responseKey $$$' + responseKey);
             //   System.debug('sfFieldName $$$' +  sfFieldName);
                newlist.put(responseKey,sfFieldName);
            }                
        }
         for(Object obj : (List<Object>)JSON.deserializeUntyped(selected)){
            //convert values to map
            Map<String, Object> data = (Map<String, Object>)obj;
            valuesMap.putAll(data );
        }
        List<sObject> records = new List<sObject>();
         List <ShopifyParsing> myList =new  List <ShopifyParsing>();
        //Here the repsonse  handle
     
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            ShopifyParsing myShoipfyData = ShopifyParsing.parse(response.getBody());
            myList.add(myShoipfyData);
            For(ShopifyParsing ab : myList){
                for(ShopifyParsing.products typ : ab.products ){
                    SObject s = new product2();
                    string Name = 'Name';
                    s.put(Name, typ.title);
                    string Handle = 'Shopify_Handle__c';
                    s.put(Handle, typ.handle);
                    string Description = 'Shopify_Product_Description__c';
                    s.put(Description, typ.body_html);
                    string tags = 'Tags__c';
                    s.put(tags, typ.tags);
                    string Product_type = 'Shopify_Product_Type__c';
                    s.put(Product_type, typ.Product_type);
                    
                    for(string key : newlist.keyset()){
                        if(key == 'Product_type'){
                            string value = String.valueOf(valuesMap.get('Product_type'));
                            s.put(value, typ.product_type);
                        }
                        else if(key == 'Vendor'){
                            string value = String.valueOf(valuesMap.get('Vendor'));
                            s.put(value, typ.vendor);
                        } 
                    }
                    for(ShopifyParsing.Variants var : typ.variants ){
                        string Product_id = 'Shopify_Product_Id__c';
                        s.put(Product_id, String.valueOf(var.product_id));
                        string variant_id = 'Shopify_variant_id__c';
                        s.put(variant_id, String.valueOf(var.id));
                        string sku = 'Shopify_SKU__c';
                        s.put(sku,String.valueOf(var.sku));
                        string weight = 'Shopify_Weight__c';
                        s.put(weight,String.valueOf(var.weight));
                        string weightunit = 'Shopify_Weight_unit__c';
                        s.put(weightunit,String.valueOf(var.weight_unit));   
                        
                        string price = 'Price__c';
                        s.put(price, Decimal.valueOf(var.price));
                        for(string key : newlist.keyset()){
                            
                            if(key == 'Variants_price'){
                                string value = String.valueOf(valuesMap.get('Variants_price'));
                                s.put(value, Decimal.valueOf(var.price));
                            }
                        }
                    }
                    for(ShopifyParsing.Images img : typ.images ){
                        string Product_Image = 'Shopify_Product_Image_URL__c';
                        s.put(Product_Image, img.src);
                        for(string key : newlist.keyset()){
                            if(key == 'Image_Src'){
                                string value = String.valueOf(valuesMap.get('Image_Src'));
                                s.put(value, img.src);
                            }
                        }
                    }
                    
                    //Product Url 
                    string Shopify_Shop_Url = 'Shopify_Shop_Url__c';
                    s.put(Shopify_Shop_Url, shopname);
                    
                    // Product type 
                    string producttype = 'Product__c';
                    s.put(producttype, 'Shopify');
                    // System.debug('Inserted Product' + s);
                    string Published_At = 'Shopify_Published_At__c';
                    // s.put(Published_At, typ.published_at);
                    String ConvertedPublishedAt;
                    ConvertedPublishedAt = typ.published_at.substring(0, typ.published_at.indexOf('T'));
                    //System.debug('Shopify_Published_At__c : '+typ.published_at);
                    s.put(Published_At, date.ValueOf(ConvertedPublishedAt));
                    
                    string Updated_At = 'Shopify_Updated_At__c';
                    //s.put(Updated_At, typ.updated_at);
                    String ConvertedUpdatedAt;
                    ConvertedUpdatedAt = typ.updated_at.substring(0, typ.updated_at.indexOf('T'));
                    System.debug('Shopify_Updated_At__c : '+ConvertedUpdatedAt);
                    // System.debug('Shopify_Updated_At__c : '+typ.updated_at);
                    s.put(Updated_At, date.ValueOf(ConvertedUpdatedAt));
                    
                    if(Shopify_Updated_After !=null && Shopify_Updated_Before !=null && Shopify_Published_After !=null && Shopify_Published_Before !=null  ){
                        if(date.ValueOf(ConvertedUpdatedAt) >= Shopify_Updated_After && date.ValueOf(ConvertedUpdatedAt) <= Shopify_Updated_Before ||
                           date.ValueOf(ConvertedPublishedAt) >= Shopify_Published_After && date.ValueOf(ConvertedPublishedAt) <= Shopify_Published_Before
                          ){
                              System.debug('Shopify_Updated_At__c : '+ConvertedUpdatedAt);
                              records.add(s); 
                          }
                    }
                    else if(Shopify_Published_After !=null && Shopify_Published_Before ==null ){
                        records.add(s); 
                    }
                    else if(Shopify_Published_After ==null && Shopify_Published_Before !=null ){
                        records.add(s); 
                    }
                    else if(Shopify_Published_After !=null && Shopify_Published_Before !=null ){
                        if(date.ValueOf(ConvertedPublishedAt) >= Shopify_Published_After && date.ValueOf(ConvertedPublishedAt) <= Shopify_Published_Before){
                            records.add(s); 
                        }
                    }
                    else if(Shopify_Updated_After !=null && Shopify_Updated_Before ==null){ 
                        records.add(s); 
                    }
                    else if(Shopify_Updated_After ==null && Shopify_Updated_Before !=null){ 
                        records.add(s); 
                    }
                     else if(Shopify_Updated_After !=null && Shopify_Updated_Before !=null ){
                        if(date.ValueOf(ConvertedUpdatedAt) >= Shopify_Updated_After && date.ValueOf(ConvertedUpdatedAt) <= Shopify_Updated_Before){
                            records.add(s); 
                        }
                    }

                    
                    
                }
            }
        }
      
       System.debug('Orginal Value : '+records);
       System.debug('Orginal Value size : '+records.size());
        
        List<Product2> productsToInsert = new List<Product2>();
        for(sObject s : records) {
            productsToInsert.add((Product2) s);
        }
        System.debug('New Product2 '+productsToInsert);
        System.debug('New Product2 size : '+productsToInsert.size());
        
        // Deserialize the JSON string into collections of primitive data types.
        List<Product2> firstList = [Select Shopify_Product_Id__c From Product2 ];
        Map<String, Product2> firstMap = new Map<String, Product2>();
        Map<String, Product2> secondMap = new Map<String, Product2>();
        for(Product2 ocr : productsToInsert){
            secondMap.put(ocr.Shopify_Product_Id__c, ocr);
        }
        for(Product2 ocr : firstList){
            firstMap.put(ocr.Shopify_Product_Id__c, ocr);
        }
        Map<String, Product2> result = new Map<String, Product2>();
        Map<String, Product2> sameresult = new Map<String, Product2>();
        
        for (String i : secondMap.keySet()) {
            if (!firstMap.containsKey(i)) {
                result.put(i,secondMap.get(i));
            }
        }
        for (String i : secondMap.keySet()) {
            if (firstMap.containsKey(i)) {
                sameresult.put(i,secondMap.get(i));
            }
        }
        List<Product2> finalproductlist = new list<Product2>();
        for(Product2 results : result.values()) {
            finalproductlist.add(results);
        }
        System.debug('Inserted Value : '+finalproductlist);
        System.debug('Inserted Value SIze : '+finalproductlist.size());
        //  upsert productsToInsert;
        try {
            //database.upsert(productsToInsert, false);
            insert finalproductlist;
            objDT.message = 'success';
            // This doesn't execute since insert causes an exception
            System.debug('Statement after insert.');
        } catch(DmlException e) {
           objDT.message = 'The following error has occurred: ' + e.getMessage();
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
         objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        
         if(Productfilter == 'All'){
            list<string> idslist = new list<string>() ;
            List<Product2> product_all = [Select Id,CreatedBy.Name,Shopify_Updated_At__c,Product__c,Price__c,Shopify_Published_At__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2  WHERE Product__c = 'Salesforce' or Shopify_Shop_Url__c = :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 where Product__c = 'Salesforce' or Shopify_Shop_Url__c = :shopname];
            Integer recordEnd = pSize * pNumber;
            objDT.productList = product_all;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
             for(Product2 st: product_all ){
                idslist.add(st.Id);
                system.debug('value'+idslist);
            }
            objDT.productidsList = idslist;
        }
        else if(Productfilter == 'Salesforce'){
            list<string> idslist = new list<string>() ;
            List<Product2> product_Salesforce = [Select Id,CreatedBy.Name,Price__c,Shopify_Updated_At__c,Shopify_Published_At__c,Product__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:Productfilter ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:Productfilter ];
            Integer recordEnd = pSize * pNumber;
            objDT.productList = product_Salesforce;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
             for(Product2 st: product_Salesforce ){
                idslist.add(st.Id);
                system.debug('value'+idslist);
            }
            objDT.productidsList = idslist;
        }
        else if(Productfilter == 'Shopify'){
            list<string> idslist = new list<string>() ;
            List<Product2> product_Shopify = [Select Id,CreatedBy.Name,Product__c,Shopify_Updated_At__c,Shopify_Published_At__c,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:Productfilter And Shopify_Shop_Url__c like :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:Productfilter  And Shopify_Shop_Url__c like :shopname ];
            Integer recordEnd = pSize * pNumber;
            objDT.productList = product_Shopify;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            for(Product2 st: product_Shopify ){
                idslist.add(st.Id);
                system.debug('value'+idslist);
            }
            objDT.productidsList = idslist;
        }
        return objDT;
    }
    
    @AuraEnabled
    public static ProductDataTableWrapper getProductSyncData(Integer pageNumber, Integer pageSize,String shopid,String Productfilter) 
    {
        ProductDataTableWrapper objDT =  new ProductDataTableWrapper();  
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        //Total Records
        
        Product2 prod = new Product2();												
        List<Product2> list_pbe = new List<Product2>();
        Http http = new Http();
         id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
       
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c,Product_Mapping__c from Shopify_Configuration__c where id = :shopids limit 1];
        system.debug('shop'+shopdetails);
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        // String shopname = 'https://healthyxpressdemo.myshopify.com';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopname+'/admin/products.json');
        request.setMethod('GET');
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        system.debug('headerValue' +headerValue);
        String authorizationHeader = 'Basic '+ EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        
        // Geting the selected  Fields 
        map<string,string >newlist = new map<string,string>();
        
        String selected = shopdetails.Product_Mapping__c.unescapeHtml4();
        system.debug('selected'+selected);
        List<Object> objList = (List<Object>)  JSON.deserializeUntyped(selected);
        system.debug('objList'+objList);
        for(Object obj : objList) {
            
            String strObj = String.valueOf(obj);
            
            List<String> keyValueList = strObj.split('=');
            
            if(keyValueList.size() > 1) {
                String responseKey = keyValueList[0].replaceAll('[^a-zA-Z0-9\\s+]', '');
                String sfFieldName = keyValueList[1].replaceAll('[^a-zA-Z0-9\\s+]', '');
                System.debug('responseKey $$$' + responseKey);
                System.debug('sfFieldName $$$' + sfFieldName);
                newlist.put(responseKey,sfFieldName);
            }                
        }
        
        Map<String, Object> valuesMap = new Map<String, Object>();
        
        for(Object obj : (List<Object>)JSON.deserializeUntyped(selected)){
            //convert values to map
            Map<String, Object> data = (Map<String, Object>)obj;
            valuesMap.putAll(data );
        }
        System.debug('sfFieldName $$$' +  valuesMap);        
        List<sObject> records = new List<sObject>();
        List <ShopifyParsing> myList =new  List <ShopifyParsing>();
        //Here the repsonse  handle
       
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                system.debug('resultBody'+response.getBody());
                ShopifyParsing myShoipfyData = ShopifyParsing.parse(response.getBody());
                myList.add(myShoipfyData);
                For(ShopifyParsing ab : myList){
                    for(ShopifyParsing.products typ : ab.products ){
                        SObject s = new product2();
                        string Name = 'Name';
                        s.put(Name, typ.title);
                        string Handle = 'Shopify_Handle__c';
                        s.put(Handle, typ.handle);
                        string Description = 'Shopify_Product_Description__c';
                        s.put(Description, typ.body_html);
                        string tags = 'Tags__c';
                        s.put(tags, typ.tags);
                        string Product_type = 'Shopify_Product_Type__c';
                        s.put(Product_type, typ.Product_type);
                        
                        string Handlevalue = 'Shopify_Handle__c';
                        s.put(Handlevalue, typ.handle);
                        
                        for(string key : newlist.keyset()){
                            if(key == 'Product_type'){
                                string value = String.valueOf(valuesMap.get('Product_type'));
                                s.put(value, typ.product_type);
                            }
                            else if(key == 'Vendor'){
                                string value = String.valueOf(valuesMap.get('Vendor'));
                                s.put(value, typ.vendor);
                            } 
                            /*  else  if(key == 'Handle'){
									string value = String.valueOf(valuesMap.get('Handle'));
									s.put(value, typ.handle);
								}*/
                        }
                        for(ShopifyParsing.Variants var : typ.variants ){
                            string Product_id = 'Shopify_Product_Id__c';
                            s.put(Product_id, String.valueOf(var.product_id));
                            string variant_id = 'Shopify_variant_id__c';
                            s.put(variant_id, String.valueOf(var.id));
                            string sku = 'Shopify_SKU__c';
                            s.put(sku,var.sku);
                            string weight = 'Shopify_Weight__c';
                            s.put(weight,string.valueOf(var.weight));
                            //s.put(weight,var.weight);
                            string weightunit = 'Shopify_Weight_unit__c';
                            s.put(weightunit,string.valueOf(var.weight_unit));   
                            
                            string price = 'Price__c';
                            s.put(price, Decimal.valueOf(var.price));
                            for(string key : newlist.keyset()){
                                
                                if(key == 'Variants_price'){
                                    string value = String.valueOf(valuesMap.get('Variants_price'));
                                    s.put(value, Decimal.valueOf(var.price));
                                }
                            }
                        }
                        for(ShopifyParsing.Images img : typ.images ){
                            string Product_Image = 'Shopify_Product_Image_URL__c';
                            s.put(Product_Image, img.src);
                            for(string key : newlist.keyset()){
                                if(key == 'Image_Src'){
                                    string value = String.valueOf(valuesMap.get('Image_Src'));
                                    s.put(value, img.src);
                                }
                            }
                        }
                        
                        //Product Url 
                        string Shopify_Shop_Url = 'Shopify_Shop_Url__c';
                        s.put(Shopify_Shop_Url, shopname);
                        
                        // Product type 
                        string producttype = 'Product__c';
                        s.put(producttype, 'Shopify');
                        System.debug('Inserted Product' + s);
                        records.add(s);
                    }
                }
        
        }
        System.debug('Orginal Value : '+records);
        System.debug('Orginal Value size : '+records.size());
        
        List<Product2> productsToInsert = new List<Product2>();
        for(sObject s : records) {
            productsToInsert.add((Product2) s);
        }
        System.debug('New Product2 '+productsToInsert);
        System.debug('New Product2 size : '+productsToInsert.size());
        
        // Deserialize the JSON string into collections of primitive data types.
        List<Product2> firstList = [Select Shopify_Product_Id__c From Product2 ];
        Map<String, Product2> firstMap = new Map<String, Product2>();
        Map<String, Product2> secondMap = new Map<String, Product2>();
        for(Product2 ocr : productsToInsert){
            secondMap.put(ocr.Shopify_Product_Id__c, ocr);
        }
        for(Product2 ocr : firstList){
            firstMap.put(ocr.Shopify_Product_Id__c, ocr);
        }
        Map<String, Product2> result = new Map<String, Product2>();
        Map<String, Product2> sameresult = new Map<String, Product2>();
        
        for (String i : secondMap.keySet()) {
            if (!firstMap.containsKey(i)) {
                result.put(i,secondMap.get(i));
            }
        }
        for (String i : secondMap.keySet()) {
            if (firstMap.containsKey(i)) {
                sameresult.put(i,secondMap.get(i));
            }
        }
        List<Product2> finalproductlist = new list<Product2>();
        for(Product2 results : result.values()) {
            finalproductlist.add(results);
        }
        System.debug('Inserted Value : '+finalproductlist);
        System.debug('Inserted Value SIze : '+finalproductlist.size());
        //  upsert productsToInsert;
        try {
            //database.upsert(productsToInsert, false);
            insert finalproductlist;
            objDT.message = 'success';
            // This doesn't execute since insert causes an exception
            System.debug('Statement after insert.');
        } catch(DmlException e) {
            objDT.message = 'The following error has occurred: ' + e.getMessage();
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
        
        //Total Records
        //Instance of Contact DataTable Wrapper Class
      
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        
         if(Productfilter == 'All'){
            list<string> idslist = new list<string>() ;
            List<Product2> product_all = [Select Id,CreatedBy.Name,Product__c,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Shopify_variant_id__c from Product2  WHERE Product__c = 'Salesforce' or Shopify_Shop_Url__c = :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 where Product__c = 'Salesforce' or Shopify_Shop_Url__c = :shopname];
            Integer recordEnd = pSize * pNumber;
            objDT.productList = product_all;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
             for(Product2 st: product_all ){
                idslist.add(st.Id);
                system.debug('value'+idslist);
            }
            objDT.productidsList = idslist;
        }
        else if(Productfilter == 'Salesforce'){
            list<string> idslist = new list<string>() ;
            List<Product2> product_Salesforce = [Select Id,CreatedBy.Name,Price__c,Product__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:Productfilter ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:Productfilter ];
            Integer recordEnd = pSize * pNumber;
            objDT.productList = product_Salesforce;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
             for(Product2 st: product_Salesforce ){
                idslist.add(st.Id);
                system.debug('value'+idslist);
            }
            objDT.productidsList = idslist;
        }
        else if(Productfilter == 'Shopify'){
            list<string> idslist = new list<string>() ;
            List<Product2> product_Shopify = [Select Id,CreatedBy.Name,Product__c,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:Productfilter And Shopify_Shop_Url__c like :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:Productfilter  And Shopify_Shop_Url__c like :shopname ];
            Integer recordEnd = pSize * pNumber;
            objDT.productList = product_Shopify;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            for(Product2 st: product_Shopify ){
                idslist.add(st.Id);
                system.debug('value'+idslist);
            }
            objDT.productidsList = idslist;
        }
        
        
        /*
        Integer totalRecords = [SELECT COUNT() FROM Product2 Where Shopify_Shop_Url__c =:shopname ];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.productList = [Select Id,CreatedBy.Name,CreatedDate,Product__c,Price__c,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c from Product2 Where Shopify_Shop_Url__c =:shopname  ORDER BY Name LIMIT :pSize OFFSET :offset];
*/       
return objDT;
        
    }
    
    public class ProductDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public List<String> Shopnames {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public String message {get;set;}
        @AuraEnabled
        public List<Product2> productList {get;set;}
        @AuraEnabled
        public List<String> productidsList {get;set;}
        
    }
    
    @AuraEnabled
    public static ProductDataTableSearchWrapper fetchSearchProduct(String searchKeyWord,String shopid,Integer pageNumber, Integer pageSize,String ProductType) {
        ProductDataTableSearchWrapper objDT =  new ProductDataTableSearchWrapper();  
        
        String searchKey ='%' + searchKeyWord + '%';
        system.debug('VAlue : '+ProductType);
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name from Shopify_Configuration__c where id =:shopids limit 1];
        String shopname = shopdetails.Name; 
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        if(ProductType == 'All'){
            List<Product2> prod = [Select Id,CreatedBy.Name,Product__c,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2  WHERE (Product__c = 'Salesforce' or Shopify_Shop_Url__c like :shopname) and Name LIKE: searchKey ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 where (Product__c = 'Salesforce' or Shopify_Shop_Url__c like :shopname ) and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;
             objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.productList = prod;
        }
        else if(ProductType == 'Salesforce'){
            List<Product2> prod = [Select Id,CreatedBy.Name,Price__c,Product__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:ProductType and Name LIKE: searchKey ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:ProductType and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;
             objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.productList = prod;
        }
        else if(ProductType == 'Shopify'){
            
            List<Product2> prod = [Select Id,CreatedBy.Name,Product__c,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:ProductType And Shopify_Shop_Url__c like :shopname and Name LIKE: searchKey ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:ProductType  And Shopify_Shop_Url__c like :shopname and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
             objDT.recordStart = offset + 1;
            objDT.pageNumber = pNumber;
            objDT.productList = prod;
        }			
        return objDT;
    }
    public class ProductDataTableSearchWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public String message {get;set;}
        @AuraEnabled
        public List<Product2> productList {get;set;}
    }
    
    
    
    @Auraenabled
    public static ProductDeleteDataTableWrapper deleteProductById(String accid,Integer pageNumber, Integer pageSize,String shopid,string ProductDataType)
    {
        
        ProductDeleteDataTableWrapper objDT =  new ProductDeleteDataTableWrapper();  
        system.debug('accid:'+accid); 
        system.debug('ProductDataType:'+ProductDataType);
        id selectedshopid = [Select id,TechnologyMind__Selected_App__c from TechnologyMind__App_Configuration__c].TechnologyMind__Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids limit 1];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        String Product_name ;
        try {
            Product2 delAccount =[Select Id,Shopify_Product_Id__c,name from Product2 where Id =:accid];
            Product_name = delAccount.Name;
            system.debug('delAccount.Shopify_Product_Id__c :'+delAccount.Shopify_Product_Id__c);
            if(delAccount.Shopify_Product_Id__c != null){
                //DELETE /admin/api/2019-07/products/#{product_id}.json
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(shopname+'/admin/api/2019-10/products/'+ delAccount.Shopify_Product_Id__c +'.json');
                request.setMethod('DELETE');
                // String username = '61aa8cff33084fb5eebfd721b7a6e3e5';
                // String password = '51f5bfdbd12e120d34fe3669a3ed1949';
                Blob headerValue = Blob.valueOf(Token + ':' + Password);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                system.debug('64code '+ authorizationHeader);
                String authnull = 'null';
                request.setHeader('Authorization', authorizationHeader);
                HttpResponse response = http.send(request);
                System.debug('response'+response.getBody());
                if (response.getStatusCode() == 200) {
                    system.debug('Product Deleted');
                    objDT.message = 'success';
                    delete delAccount;
                }
                else{
                    objDT.message =response.getBody();
                }
            }
            else{
                objDT.message = 'success';
                delete delAccount;
            }
        } 
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            objDT.message ='The following exception has occurred: '+Product_name+e.getMessage();
        }
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        
        
        if(ProductDataType == 'Salesforce'){
            
            //Total Records
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c='Salesforce'];
            Integer recordEnd = pSize * pNumber;
            
            //Instance of Contact DataTable Wrapper Class
            
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords; 
            objDT.productList = [Select Id,CreatedBy.Name,CreatedDate,Price__c,Product__c,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c='Salesforce' ORDER BY Name LIMIT :pSize OFFSET :offset];
        }
        else if(ProductDataType == 'Shopify'){
            
            //Total Records
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Shopify_Shop_Url__c =:shopname and Product__c='Shopify'];
            Integer recordEnd = pSize * pNumber;
            
            //Instance of Contact DataTable Wrapper Class
            
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords; 
            objDT.productList = [Select Id,CreatedBy.Name,CreatedDate,Price__c,Product__c,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Shopify_Shop_Url__c =:shopname and Product__c='Shopify' ORDER BY Name LIMIT :pSize OFFSET :offset];
        }
        else{
            
            //Total Records
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Shopify_Shop_Url__c =:shopname];
            Integer recordEnd = pSize * pNumber;
            
            //Instance of Contact DataTable Wrapper Class
            
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords; 
            objDT.productList = [Select Id,CreatedBy.Name,CreatedDate,Price__c,Product__c,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Shopify_Shop_Url__c =:shopname ORDER BY Name LIMIT :pSize OFFSET :offset]; 
        }
        
        return  objDT;
    }
    
    @AuraEnabled
    public static ProductSingleSyncDataTableWrapper Get_single_Product_Data(String id,Integer pageNumber, Integer pageSize,String shopid,String ProductType) {
        system.debug('Value :'+ProductType);
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        Product2 prod = [Select Id,CreatedBy.Name,CreatedDate,Price__c,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 where Shopify_Product_Id__c= :id limit 1];											
        // List<Product2> list_pbe = new List<Product2>();
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopid limit 1];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopname+'/admin/api/2019-10/products/'+id+'.json');
        request.setMethod('GET');
        // String username = '61aa8cff33084fb5eebfd721b7a6e3e5';
        //String password = '51f5bfdbd12e120d34fe3669a3ed1949';
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        system.debug('64code '+ authorizationHeader);
        String authnull = 'null';
        request.setHeader('Authorization', authorizationHeader);
        
       
            HttpResponse response = http.send(request);
            System.debug('response'+response.getBody());
            if (response.getStatusCode() == 200) {
                
                JSONParser parser = JSON.createParser(response.getBody());
                
                // Parsing of string    
                
                while(parser.nextToken()!= null) {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                        parser.nextValue();      
                        if(parser.getCurrentName() == 'title') {
                            prod.Name = parser.getText();
                            system.debug('prod.Name '+prod.Name);
                        } 
                        else if (parser.getCurrentName() == 'product_type') {
                            prod.Shopify_Product_Type__c = parser.getText();
                            system.debug('prod.Shopify_Product_Type__c '+prod.Shopify_Product_Type__c);
                        } 
                        else if (parser.getCurrentName() == 'vendor') {
                            prod.Shopify_Vendor_Name__c = parser.getText();
                            system.debug('prod.Shopify_Vendor_Name__c '+prod.Shopify_Vendor_Name__c);
                        }
                        else if (parser.getCurrentName() == 'handle') {
                            prod.Shopify_Handle__c = parser.getText();
                            system.debug('prod.Shopify_Handle__c '+prod.Shopify_Handle__c);
                        }
                        else if (parser.getCurrentName() == 'product_id') {
                            prod.Shopify_Product_Id__c	 = parser.getText();
                            system.debug('prod.Shopify_Product_Id__c'+prod.Shopify_Product_Id__c);
                        }
                        else if (parser.getCurrentName() == 'src') {
                            prod.Shopify_Product_Image_URL__c = parser.getText();
                            system.debug('prod.Shopify_Product_Image_URL__c '+prod.Shopify_Product_Image_URL__c);
                        } 
                        
                        else if (parser.getCurrentName() == 'variants') {
                            while(parser.nextToken()!= JSONToken.END_ARRAY) {
                                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                    parser.nextValue();
                                    if (parser.getCurrentName() == 'price') {
                                        prod.Price__c = Decimal.valueOf(parser.getText());
                                        system.debug('prod.Price__c '+prod.Price__c);
                                    }
                                } else if(parser.getCurrentToken() == JSONToken.END_OBJECT) {
                                    
                                    //prod = new Product2();
                                    continue;
                                } else if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                    continue;
                                }
                            }
                        }
                    }
                }
            }
     
        
        update prod; 
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        
        //Total Records
        //Integer totalRecords = [SELECT COUNT() FROM Product2 Where Shopify_Shop_Url__c =:shopname];
        //  Integer recordEnd = pSize * pNumber;
        
        //Instance of Contact DataTable Wrapper Class
        ProductSingleSyncDataTableWrapper objDT =  new ProductSingleSyncDataTableWrapper();  
        //  objDT.pageSize = pSize;
        //   objDT.pageNumber = pNumber;
        //  objDT.recordStart = offset + 1;
        //  objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        //  objDT.totalRecords = totalRecords;
        //  objDT.productList = [Select Id,CreatedBy.Name,CreatedDate,Product__c,Price__c,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c from Product2  Where Shopify_Shop_Url__c =:shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
        
        
        if(ProductType == 'All'){
            List<Product2> aftersyncprod = [Select Id,CreatedBy.Name,Product__c,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2  WHERE Product__c = 'Salesforce' or Shopify_Shop_Url__c like :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 where Product__c = 'Salesforce' or Shopify_Shop_Url__c like :shopname];
            Integer recordEnd = pSize * pNumber;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.productList = aftersyncprod;
        }
        else if(ProductType == 'Salesforce'){
            List<Product2> aftersyncprod = [Select Id,CreatedBy.Name,Price__c,Product__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:ProductType ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:ProductType ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.productList = aftersyncprod;
        }
        else if(ProductType == 'Shopify'){
            List<Product2> aftersyncprod = [Select Id,CreatedBy.Name,Product__c,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:ProductType And Shopify_Shop_Url__c like :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:ProductType  And Shopify_Shop_Url__c like :shopname];
            Integer recordEnd = pSize * pNumber;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.productList = aftersyncprod;
        }
        
        return objDT;
    }
    public class ProductSingleSyncDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public String message {get;set;}
        @AuraEnabled
        public List<Product2> productList {get;set;}
        @AuraEnabled
        public List<String> productidsList {get;set;}
    }    
    
    
    public class ProductDeleteDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public String message {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<Product2> productList {get;set;}
    }
    
    @AuraEnabled
    Public static list<string> productFieldsList(){
        List < String > allOpts = new list < String > ();
        SObjectType objToken = Schema.getGlobalDescribe().get('Product2');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        Set<String> fieldSet = fields.keySet();
        for(String s:fieldSet)
        {
            SObjectField fieldToken = fields.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            allOpts.add(selectedField.getName());
        }
        // Add these values to the selectoption list.
        system.debug('allOpts ---->' + allOpts);
        
        list<string> customfields = new list<string>();
        for(string flds : allOpts){
            if(flds.contains('__c')){
                customfields.add(flds);
            }
        }
        customfields.sort();
        system.debug('Custom values'+customfields);
        return customfields;
    }
    @AuraEnabled
    public static ProductSingleSyncDataTableWrapper Product_Type_Data(String ProductType,Integer pageNumber, Integer pageSize,String shopid) {
        //List<Product2> list_pbe = new List<Product2>();
       id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
       id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c  where id = :shopids limit 1];
        String shopname = shopdetails.Name; 
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        
        //Total Records
        //Instance of Contact DataTable Wrapper Class
        ProductSingleSyncDataTableWrapper objDT =  new ProductSingleSyncDataTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        
        if(ProductType == 'All'){
            list<string> idslist = new list<string>() ;
            List<Product2> prod = [Select Id,CreatedBy.Name,Product__c,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2  WHERE Product__c = 'Salesforce' or Shopify_Shop_Url__c = :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 where Product__c = 'Salesforce' or Shopify_Shop_Url__c = :shopname];
            Integer recordEnd = pSize * pNumber;
            objDT.productList = prod;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
             for(Product2 st: prod ){
                idslist.add(st.Id);
                system.debug('value'+idslist);
            }
            objDT.productidsList = idslist;
        }
        else if(ProductType == 'Salesforce'){
            list<string> idslist = new list<string>() ;
            List<Product2> prod = [Select Id,CreatedBy.Name,Price__c,Product__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:ProductType ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:ProductType ];
            Integer recordEnd = pSize * pNumber;
            objDT.productList = prod;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
             for(Product2 st: prod ){
                idslist.add(st.Id);
                system.debug('value'+idslist);
            }
            objDT.productidsList = idslist;
        }
        else if(ProductType == 'Shopify'){
            list<string> idslist = new list<string>() ;
            List<Product2> prod = [Select Id,CreatedBy.Name,Product__c,Price__c,CreatedDate,Description,DisplayUrl,IsActive,IsDeleted,LastModifiedDate,Name,ProductCode,Shopify_Product_Image_URL__c,Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,Tags__c,Shopify_Product_Id__c,Shopify_Product_Description__c,Family,Shopify_variant_id__c from Product2 Where Product__c =:ProductType And Shopify_Shop_Url__c like :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Product2 Where Product__c =:ProductType  And Shopify_Shop_Url__c like :shopname ];
            Integer recordEnd = pSize * pNumber;
            objDT.productList = prod;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            for(Product2 st: prod ){
                idslist.add(st.Id);
                system.debug('value'+idslist);
            }
            objDT.productidsList = idslist;
        }
        return objDT;
    }
    
    @AuraEnabled
    public static ProductSingleSyncDataTableWrapper exportToShopify(String shopid,String productId) 
    {        
        system.debug('Productid'+productId);
        system.debug('shopid'+shopid);
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids limit 1];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        
        Product2 producttoinsert = [Select Id,Price__c,Description,Product__c,Name,Shopify_Product_Image_URL__c,
                                    Shopify_Handle__c,Shopify_Product_Type__c,Shopify_Shop_Url__c,Shopify_Vendor_Name__c,
                                    Tags__c, Shopify_variant_id__c, Shopify_SKU__c,Family from product2 where id = :productId And IsActive = true];
        ProductSingleSyncDataTableWrapper objDT =  new ProductSingleSyncDataTableWrapper();  
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopname+'/admin/api/2019-10/products.json');
        request.setMethod('POST');
        
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', 'application/json');
        System.debug('producttoinsert @@ ' + producttoinsert);
        String title = producttoinsert.Name;
        String bodyHtml = producttoinsert.Description != null ? producttoinsert.Description : producttoinsert.Name;
        bodyHtml = '<strong>' + bodyHtml + '</strong>';
        String vendor = producttoinsert.Shopify_Vendor_Name__c;
        String product_type = producttoinsert.Shopify_Product_Type__c;
        String tags = producttoinsert.Tags__c;
        String productVariantId = producttoinsert.Shopify_variant_id__c;
        String productVariantSku = producttoinsert.Shopify_SKU__c;
        String productPrice = String.valueOf(producttoinsert.Price__c);
        List<String> images = new List<String>();
        
        images.add(producttoinsert.Shopify_Product_Image_URL__c);
        
        //RequestJSON jsonObj = new RequestJSON(title, bodyHtml, vendor, product_type, tags, images);
        RequestJSON2 jsonObj = new RequestJSON2(title, bodyHtml, vendor, product_type, productPrice, productVariantSku, productVariantId, tags, images);
        system.debug('Till Here 1');
        system.debug(jsonObj);
        
        String jsonBody = json.serialize(jsonObj); 
        system.debug('Value '+jsonBody);
        if (jsonBody != null){
            request.setBody(jsonBody);
        }
        
        if(!test.isRunningTest()){
            HttpResponse response = http.send(request);
            system.debug(response.getStatus());
            if (response.getStatusCode() == 200) {
                objDT.message = 'success';
            }
            else{
                objDT.message =response.getBody();
            }
        }
        return objDT;
    }
    
    
}