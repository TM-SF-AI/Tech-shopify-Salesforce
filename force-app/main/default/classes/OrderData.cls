public class OrderData {
   
    // import orders from Shopify to Salesforce
    @AuraEnabled
    public static OrderDataTableWrapper getConditionalOrderSyncData(date Shopify_Updated_After,date Shopify_Updated_Before,date Shopify_Created_After,date Shopify_Created_Before,Integer pageNumber, Integer pageSize,String shopid) 
    {
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        Integer recordEnd = pSize * pNumber;
        
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c,Order_Mapping__c from Shopify_Configuration__c where id = :shopid];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name;
        
        OrderDataTableWrapper objDT =  new OrderDataTableWrapper();  
        ShopifyOrders__c ord = new ShopifyOrders__c();
        
        List<ShopifyOrders__c> list_pbe = new List<ShopifyOrders__c>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopname+'/admin/orders.json');
        request.setMethod('GET');
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        String authnull = 'null';
        request.setHeader('Authorization', authorizationHeader);
        // Geting the selected  Fields 
        map<string,string >newlist = new map<string,string>();
        String selected = shopdetails.Order_Mapping__c.unescapeHtml4();
        Map<String, Object> valuesMap = new Map<String, Object>();
        for(Object obj : (List<Object>)JSON.deserializeUntyped(selected)){
            //convert values to map
            Map<String, Object> data = (Map<String, Object>)obj;
            valuesMap.putAll(data );
        }
        system.debug('Map VAlue : '+valuesMap);
        List<sObject> orderecords = new List<sObject>();
        List <ShopifyParsingOrders1> myList =new  List <ShopifyParsingOrders1>();
        
        HttpResponse response = http.send(request);
        System.debug('response:--> ' + response.getBody());
        
        if (response.getStatusCode() == 200) {
            
            ShopifyParsingOrders1 myShoipfyData = ShopifyParsingOrders1.parse(response.getBody());
            myList.add(myShoipfyData);
            For(ShopifyParsingOrders1 ab : myList){
                for(ShopifyParsingOrders1.Orders typ : ab.Orders ){
                    SObject s = new ShopifyOrders__c();
                    string Ordernumber = 'Name' ;
                    s.put(Ordernumber, typ.name);
                    if(typ.customer!=null)
                    {
                        string CustomerID = 'CustomerID__c' ;
                        s.put(CustomerID, typ.customer.id);
                    }
                    
                    string ShopifyOrderID = 'ShopifyOrderID__c' ;
                    s.put(ShopifyOrderID, typ.id);
                    
                    for(string key : valuesMap.keyset()){
                        if(key =='Total_Price'){
                            string value = String.valueOf(valuesMap.get('Total_Price'));
                            s.put(value, typ.total_price);
                        }
                        else if(key =='Contact_Email'){
                            string value = String.valueOf(valuesMap.get('Contact_Email'));
                            s.put(value, typ.contact_email);
                        }
                        else if(key =='Address1'){
                            if(typ.billing_address != null)
                            {
                                string value = String.valueOf(valuesMap.get('Address1'));
                                s.put(value, typ.billing_address.address1);
                            }
                        }
                        
                        else if(key =='City' && typ.billing_address!= null){
                            string value = String.valueOf(valuesMap.get('City'));
                            s.put(value, typ.billing_address.city);
                        }
                        
                        else if(key =='Country'){
                            if(typ.billing_address!=null)
                            {
                                string value = String.valueOf(valuesMap.get('Country'));
                                s.put(value, typ.billing_address.country);
                            }
                        }
                        
                        else if(key =='Address2' && typ.billing_address!=null){
                            string value = String.valueOf(valuesMap.get('Address2'));
                            s.put(value, typ.billing_address.address2);
                        }
                        
                        else if(key =='First_Name' && typ.customer!=null){
                            string value = String.valueOf(valuesMap.get('First_Name'));
                            s.put(value, typ.customer.first_name);
                        }
                        
                        else if(key =='Last_Name' && typ.customer!=null){
                            string value = String.valueOf(valuesMap.get('Last_Name'));
                            s.put(value, typ.customer.last_name);
                        }
                        else if(key =='Orders_Count' && typ.customer!=null){
                            string value = String.valueOf(valuesMap.get('Orders_Count'));
                            string ordercount = String.valueOf(typ.customer.orders_count);
                            s.put(value, ordercount);
                        }
                        
                        else if(key =='Last_Order_id' &&typ.customer!=null){
                            string value = String.valueOf(valuesMap.get('Last_Order_id'));
                            s.put(value, typ.customer.last_order_id);
                        }
                    }
                    system.debug('here3');
                    for(ShopifyParsingOrders1.line_items var : typ.line_items ){
                        string Product_variant_id = 'Product_variant_id__c';
                        s.put(Product_variant_id, var.variant_id);
                    }
                    string shop = 'ChooseOrg__c';
                    s.put(shop, 'Shopify');
                    string ShopURL = 'ShopURL__c';
                    s.put(ShopURL, shopname);
                    
                    
                     string Created_At = 'Shopify_Created_At__c';
                    
                    String ConvertedCreated_At;
                    ConvertedCreated_At = typ.created_at.substring(0, typ.created_at.indexOf('T'));
                    System.debug('Created_At : '+ConvertedCreated_At);
                    
                    s.put(Created_At, date.ValueOf(ConvertedCreated_At));
                    
                    string Updated_At = 'Shopify_Updated_At__c';
                    
                    String ConvertedUpdatedAt;
                    ConvertedUpdatedAt = typ.updated_at.substring(0, typ.updated_at.indexOf('T'));
                    System.debug('Shopify_Updated_At__c : '+ConvertedUpdatedAt);
                    // System.debug('Shopify_Updated_At__c : '+typ.updated_at);
                    s.put(Updated_At, date.ValueOf(ConvertedUpdatedAt));
                    
                    if(Shopify_Updated_After !=null && Shopify_Updated_Before !=null && Shopify_Created_After !=null && Shopify_Created_Before !=null  ){
                        if(date.ValueOf(ConvertedUpdatedAt) >= Shopify_Updated_After && date.ValueOf(ConvertedUpdatedAt) <= Shopify_Updated_Before ||
                           date.ValueOf(ConvertedCreated_At) >= Shopify_Created_After && date.ValueOf(ConvertedCreated_At) <= Shopify_Created_Before
                          ){
                              System.debug('Shopify_Updated_At__c : '+ConvertedUpdatedAt);
                              
                              orderecords.add(s);
                              
                          }
                    }
                    else if(Shopify_Created_After !=null && Shopify_Created_Before ==null ){
                        
                        orderecords.add(s);
                        
                    }
                    else if(Shopify_Created_After ==null && Shopify_Created_Before !=null ){
                        
                        orderecords.add(s);
                        
                    }
                    else if(Shopify_Created_After !=null && Shopify_Created_Before !=null ){
                        if(date.ValueOf(ConvertedCreated_At) >= Shopify_Created_After && date.ValueOf(ConvertedCreated_At) <= Shopify_Created_Before){
                            
                            orderecords.add(s);
                            
                        }
                    }
                    else if(Shopify_Updated_After !=null && Shopify_Updated_Before ==null){ 
                        
                        orderecords.add(s);
                        
                    }
                    else if(Shopify_Updated_After ==null && Shopify_Updated_Before !=null){ 
                        
                        orderecords.add(s);
                        
                    }
                    else if(Shopify_Updated_After !=null && Shopify_Updated_Before !=null ){
                        if(date.ValueOf(ConvertedUpdatedAt) >= Shopify_Updated_After && date.ValueOf(ConvertedUpdatedAt) <= Shopify_Updated_Before){
                            
                            orderecords.add(s);
                            
                        }
                    }
                    
                    
                    
                    system.debug('###'+s);
                }
            }
        }
        
        System.debug('New list_pbe '+orderecords);
        System.debug('New list_pbe Size : '+orderecords.size());
        
        List<ShopifyOrders__c> OrdersToInsert = new List<ShopifyOrders__c>();
        
        for(sObject s : orderecords) {
            
            OrdersToInsert.add((ShopifyOrders__c) s);
        }
        System.debug('New AccountsToInsert '+OrdersToInsert);
        System.debug('New AccountsToInsert size : '+OrdersToInsert.size());
        
        // Deserialize the JSON string into collections of primitive data types.
        List<ShopifyOrders__c> firstList = [Select ShopifyOrderID__c From ShopifyOrders__c ];
        Map<String, ShopifyOrders__c> firstMap = new Map<String, ShopifyOrders__c>();
        Map<String, ShopifyOrders__c> secondMap = new Map<String, ShopifyOrders__c>();
        for(ShopifyOrders__c ocr : OrdersToInsert){
            secondMap.put(ocr.ShopifyOrderID__c, ocr);
        }
        for(ShopifyOrders__c ocr : firstList){
            firstMap.put(ocr.ShopifyOrderID__c, ocr);
        }
        Map<String, ShopifyOrders__c> result = new Map<String, ShopifyOrders__c>();
        Map<String, ShopifyOrders__c> sameresult = new Map<String, ShopifyOrders__c>();
        
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
        System.debug('List are !equals '+result);
        System.debug('List are !equals Size : '+result.size());
        System.debug('List are equals'+sameresult);
        System.debug('List are equals Size : '+sameresult.size());
        List<ShopifyOrders__c> finalproductlist = new list<ShopifyOrders__c>();
        for(ShopifyOrders__c results : result.values()) {
            finalproductlist.add(results);
        }
        
        insert finalproductlist;
        Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c Where ShopURL__c =:shopname ];
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        
        System.debug('New finalproductlist Size : '+finalproductlist.size());
        //Email 
        objDT.orderList = [Select id,OrderCount__c,Product_variant_id__c,Name,ShopifyOrderID__c,Email__c,FirstName__c,LastName__c,CustomerID__c,ShopURL__c,CreatedDate,Address1__c,Address2__c,City__c,Country__c,TotalPrice__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c Where ShopURL__c =:shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
        
        return objDT;
    }
    
    
    
    @AuraEnabled
    public static OrderDataTableWrapper getSynchronizedOrderDetails(Integer pageNumber, Integer pageSize,String shopid) 
    {
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        Integer recordEnd = pSize * pNumber;
        
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c,Order_Mapping__c from Shopify_Configuration__c where id = :shopids];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name;
        
        OrderDataTableWrapper objDT =  new OrderDataTableWrapper();  
        ShopifyOrders__c ord = new ShopifyOrders__c();
        
        List<ShopifyOrders__c> list_pbe = new List<ShopifyOrders__c>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopname+'/admin/orders.json');
        request.setMethod('GET');
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        String authnull = 'null';
        request.setHeader('Authorization', authorizationHeader);
        // Geting the selected  Fields 
        map<string,string >newlist = new map<string,string>();
        
        
        /* List<Object> objList = (List<Object>)  JSON.deserializeUntyped(selected);

for(Object obj : objList) {

String strObj = String.valueOf(obj);

List<String> keyValueList = strObj.split('=');

if(keyValueList.size() > 1) {
String responseKey = keyValueList[0].replaceAll('[^a-zA-Z0-9\\s+]', '');
String sfFieldName = keyValueList[1].replaceAll('[^a-zA-Z0-9\\s+]', '');
System.debug('responseKey $$$' + responseKey);
System.debug('sfFieldName $$$' +  sfFieldName);
newlist.put(responseKey,sfFieldName);
}                
}*/
        
        String selected = shopdetails.Order_Mapping__c.unescapeHtml4();
        Map<String, Object> valuesMap = new Map<String, Object>();
        for(Object obj : (List<Object>)JSON.deserializeUntyped(selected)){
            //convert values to map
            Map<String, Object> data = (Map<String, Object>)obj;
            valuesMap.putAll(data );
        }
        system.debug('Map VAlue : '+valuesMap);
        List<sObject> orderecords = new List<sObject>();
        List <ShopifyParsingOrders1> myList =new  List <ShopifyParsingOrders1>();
        
        HttpResponse response = http.send(request);
        System.debug('response:--> ' + response.getBody());
        
        if (response.getStatusCode() == 200) {
            
            ShopifyParsingOrders1 myShoipfyData = ShopifyParsingOrders1.parse(response.getBody());
            myList.add(myShoipfyData);
            For(ShopifyParsingOrders1 ab : myList){
                for(ShopifyParsingOrders1.Orders typ : ab.Orders ){
                    SObject s = new ShopifyOrders__c();
                    string Ordernumber = 'Name' ;
                    s.put(Ordernumber, typ.name);
                    
                    //error no typ.customer found
                    if(typ.customer!=null)
                    {
                        string CustomerID = 'CustomerID__c' ;
                        s.put(CustomerID, typ.customer.id);
                    }
                    
                    string ShopifyOrderID = 'ShopifyOrderID__c' ;
                    s.put(ShopifyOrderID, typ.id);
                    
                    for(string key : valuesMap.keyset()){
                        //  Order_Customer_id     Order_ID   Order_Name ShopifyOrderID__c
                        
                        if(key =='Total_Price'){
                            string value = String.valueOf(valuesMap.get('Total_Price'));
                            s.put(value, typ.total_price);
                        }
                        else if(key =='Contact_Email'){
                            string value = String.valueOf(valuesMap.get('Contact_Email'));
                            s.put(value, typ.contact_email);
                        }
                        /* else if(key =='Order_Number'){
string value = String.valueOf(valuesMap.get('Order_Number'));
//  s.put(value, typ.order_number);
}*/
                        
                        else if(key =='Address1'){
                            if(typ.billing_address != null)
                            {
                                string value = String.valueOf(valuesMap.get('Address1'));
                                s.put(value, typ.billing_address.address1);
                            }
                        }
                        
                        else if(key =='City' && typ.billing_address!= null){
                            string value = String.valueOf(valuesMap.get('City'));
                            s.put(value, typ.billing_address.city);
                        }
                        
                        else if(key =='Country'){
                            if(typ.billing_address!=null)
                            {
                                string value = String.valueOf(valuesMap.get('Country'));
                                s.put(value, typ.billing_address.country);
                            }
                        }
                        
                        else if(key =='Address2' && typ.billing_address!=null){
                            string value = String.valueOf(valuesMap.get('Address2'));
                            s.put(value, typ.billing_address.address2);
                        }
                        
                        else if(key =='First_Name' && typ.customer!=null){
                            string value = String.valueOf(valuesMap.get('First_Name'));
                            s.put(value, typ.customer.first_name);
                        }
                        
                        else if(key =='Last_Name' && typ.customer!=null){
                            string value = String.valueOf(valuesMap.get('Last_Name'));
                            s.put(value, typ.customer.last_name);
                        }
                        else if(key =='Orders_Count' && typ.customer!=null){
                            string value = String.valueOf(valuesMap.get('Orders_Count'));
                            string ordercount = String.valueOf(typ.customer.orders_count);
                            s.put(value, ordercount);
                        }
                        
                        else if(key =='Last_Order_id' &&typ.customer!=null){
                            string value = String.valueOf(valuesMap.get('Last_Order_id'));
                            s.put(value, typ.customer.last_order_id);
                        }
                        
                    }
                    system.debug('here3');
                    for(ShopifyParsingOrders1.line_items var : typ.line_items ){
                        string Product_variant_id = 'Product_variant_id__c';
                        s.put(Product_variant_id, var.variant_id);
                    }
                    /*  else if(key =='Customer_id'){
string value = String.valueOf(valuesMap.get('Customer_id'));
s.put(value, typ.customer.id);
}*/
                    
                    // Choose Shop 
                    //  ord.ChooseOrg__c= 'Shopify';
                    string shop = 'ChooseOrg__c';
                    s.put(shop, 'Shopify');
                    
                    // ord.ShopURL__c = shopname;
                    string ShopURL = 'ShopURL__c';
                    s.put(ShopURL, shopname);
                    orderecords.add(s);
                    system.debug('###'+s);
                }
            }
        }
        
        System.debug('New list_pbe '+orderecords);
        System.debug('New list_pbe Size : '+orderecords.size());
        
        List<ShopifyOrders__c> OrdersToInsert = new List<ShopifyOrders__c>();
        
        for(sObject s : orderecords) {
            
            OrdersToInsert.add((ShopifyOrders__c) s);
        }
        System.debug('New AccountsToInsert '+OrdersToInsert);
        System.debug('New AccountsToInsert size : '+OrdersToInsert.size());
        
        // Deserialize the JSON string into collections of primitive data types.
        List<ShopifyOrders__c> firstList = [Select ShopifyOrderID__c From ShopifyOrders__c ];
        Map<String, ShopifyOrders__c> firstMap = new Map<String, ShopifyOrders__c>();
        Map<String, ShopifyOrders__c> secondMap = new Map<String, ShopifyOrders__c>();
        for(ShopifyOrders__c ocr : OrdersToInsert){
            secondMap.put(ocr.ShopifyOrderID__c, ocr);
        }
        for(ShopifyOrders__c ocr : firstList){
            firstMap.put(ocr.ShopifyOrderID__c, ocr);
        }
        Map<String, ShopifyOrders__c> result = new Map<String, ShopifyOrders__c>();
        Map<String, ShopifyOrders__c> sameresult = new Map<String, ShopifyOrders__c>();
        
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
        System.debug('List are !equals '+result);
        System.debug('List are !equals Size : '+result.size());
        System.debug('List are equals'+sameresult);
        System.debug('List are equals Size : '+sameresult.size());
        List<ShopifyOrders__c> finalproductlist = new list<ShopifyOrders__c>();
        for(ShopifyOrders__c results : result.values()) {
            finalproductlist.add(results);
        }
        
        insert finalproductlist;
        Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c Where ShopURL__c =:shopname ];
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        
        System.debug('New finalproductlist Size : '+finalproductlist.size());
        //Email 
        objDT.orderList = [Select id,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Name,ShopifyOrderID__c,Email__c,FirstName__c,LastName__c,CustomerID__c,ShopURL__c,CreatedDate,Address1__c,Address2__c,City__c,Country__c,TotalPrice__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c Where ShopURL__c =:shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
        
        return objDT;
    }
    
    public class OrderDataTableWrapper {
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
        public List<ShopifyOrders__c> orderList {get;set;}
    }
    
    @AuraEnabled
    public static List < ShopifyOrders__c > SearchOrder(String searchKeyWord) {
        String searchKey ='%' + searchKeyWord + '%';
        List < ShopifyOrders__c > returnList = new List < ShopifyOrders__c > ();
        //Email
        List < ShopifyOrders__c > lstOfProduct = [Select Name,Product_variant_id__c,Email__c,FirstName__c,LastName__c, CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,OrderCount__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c WHERE Name LIKE: searchKey ];
        for (ShopifyOrders__c pro: lstOfProduct) {
            returnList.add(pro);
        }
        return returnList;
    }
    
    @Auraenabled
    public static OrderDeleteWrapper deleteSingleOrder(String accid,Integer pageNumber, Integer pageSize,String shopid,string OrderDataType)
    { 
        system.debug('OrderDataType: '+OrderDataType);
         id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c,Order_Mapping__c from Shopify_Configuration__c where id = :shopids];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name;
        
        OrderDeleteWrapper objDT =  new OrderDeleteWrapper();  
        ShopifyOrders__c deleteOrder =[Select Id,Name,ShopifyOrderID__c from ShopifyOrders__c where Id =:accid];
        if(deleteOrder.ShopifyOrderID__c != null){
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(shopname+'/admin/orders/'+ deleteOrder.ShopifyOrderID__c +'.json');
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
                delete deleteOrder;
            }
            else{
                objDT.message =response.getBody();
            }
        }
        else{
            objDT.message = 'success';
            delete deleteOrder;
        }
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        Integer offset = (pNumber - 1) * pSize;
        
        if(OrderDataType == 'Salesforce'){
            //Instance of Contact DataTable Wrapper Class
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c where ShopURL__c =:shopname and ChooseOrg__c = 'Salesforce' ];
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            //Email
            objDT.deletedSingleorderList = [Select Product_variant_id__c,TechnologyMind__ProductVariantID__c,Name,Email__c,OrderCount__c,FirstName__c,LastName__c, CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c where ShopURL__c =:shopname ORDER BY Name ASC LIMIT :pSize OFFSET :offset ];
        }
        else if(OrderDataType == 'Shopify'){
            //Instance of Contact DataTable Wrapper Class
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c where ShopURL__c =:shopname and ChooseOrg__c = 'Shopify' ];
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            //Email
            objDT.deletedSingleorderList = [Select Product_variant_id__c,TechnologyMind__ProductVariantID__c,Name,Email__c,OrderCount__c,FirstName__c,LastName__c, CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c where ShopURL__c =:shopname ORDER BY Name ASC LIMIT :pSize OFFSET :offset ];
        }
        
        else{
            //Instance of Contact DataTable Wrapper Class
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c where ShopURL__c =:shopname or ChooseOrg__c = 'Salesforce' ];
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            //Email
            objDT.deletedSingleorderList = [Select Product_variant_id__c,Name,Email__c,OrderCount__c,FirstName__c,LastName__c, CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c where ShopURL__c =:shopname or ChooseOrg__c = 'Salesforce' ORDER BY Name ASC LIMIT :pSize OFFSET :offset ];
        }
        
        
        
        
        
        return  objDT;
    }
    
    public class OrderDeleteWrapper {
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
        public List<ShopifyOrders__c> deletedSingleorderList {get;set;}
    }
    
    
    @AuraEnabled
    public static OrderSingleSyncDataTableWrapper syncSingleOrder(String id,Integer pageNumber, Integer pageSize) {
        
        
        ShopifyOrders__c Cust = [Select Id,Name,ShopifyOrderID__c FROM ShopifyOrders__c WHERE ShopifyOrderID__c = :id limit 1];                                          
        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://healthyxpressdemo.myshopify.com/admin/orders.json');
        request.setMethod('GET');
        String username = '61aa8cff33084fb5eebfd721b7a6e3e5';
        String password = '51f5bfdbd12e120d34fe3669a3ed1949';
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        String authnull = 'null';
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response = http.send(request);
        System.debug('response'+response.getBody());
        if (response.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(response.getBody());
            while(parser.nextToken()!= null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    parser.nextValue();
                    if(parser.getCurrentName() == 'contact_email') {
                        //Email
                        Cust.Email__c= parser.getText();
                        system.debug('Email :  '+Cust.Email__c);
                    }                    
                    
                    else if (parser.getCurrentName() == 'billing_address') {
                        while(parser.nextToken()!= JSONToken.END_ARRAY) {
                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                parser.nextValue();
                                if(parser.getCurrentName() == 'first_name') {
                                    Cust.FirstName__c = parser.getText();
                                    system.debug('first_name:  '+Cust.FirstName__c);
                                }
                                else if(parser.getCurrentName() == 'address1') {
                                    Cust.Address1__c = parser.getText();
                                    system.debug('Address1__c:  '+Cust.Address1__c);
                                }
                                else if(parser.getCurrentName() == 'phone') {
                                    Cust.Phone__c = parser.getText();
                                    system.debug('Phone__c:  '+Cust.Phone__c);
                                }
                                else if(parser.getCurrentName() == 'city') {
                                    Cust.City__c = parser.getText();
                                    system.debug('City:  '+Cust.City__c);
                                }
                                else if(parser.getCurrentName() == 'zip') {
                                    Cust.ZIPCode__c = parser.getText();
                                    system.debug('ZIP:  '+Cust.City__c);
                                }
                                else if(parser.getCurrentName() == 'province') {
                                    Cust.State__c = parser.getText();
                                    system.debug('State__c:  '+Cust.State__c);
                                }
                                else if(parser.getCurrentName() == 'country') {
                                    Cust.Country__c = parser.getText();
                                    system.debug('Country__c:  '+Cust.Country__c);
                                }
                                else if(parser.getCurrentName() == 'last_name') {
                                    Cust.LastName__c = parser.getText();
                                    system.debug('LastName__c:  '+Cust.LastName__c);
                                }
                                
                                else if(parser.getCurrentName() == 'address2') {
                                    Cust.Address2__c  = parser.getText();
                                    system.debug('Address2__c:  '+Cust.Address2__c );
                                }
                            }
                        }
                    }
                    else if (parser.getCurrentName() == 'customer') {
                        while(parser.nextToken()!= JSONToken.END_ARRAY) {
                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                parser.nextValue();
                                if(parser.getCurrentName() == 'total_price') {
                                    Cust.TotalPrice__c = parser.getText();
                                    system.debug('TotalPrice__c:  '+Cust.TotalPrice__c);
                                }
                                
                                else if(parser.getCurrentName() == 'orders_count') {
                                    Cust.OrderCount__c = parser.getText();
                                    system.debug('OrderCount__c:  '+Cust.OrderCount__c);
                                }
                                else if(parser.getCurrentName() == 'last_order_id') {
                                    Cust.ShopifyOrderID__c = parser.getText();
                                    system.debug('ShopifyOrderID__c:  '+Cust.ShopifyOrderID__c);
                                }
                                else if(parser.getCurrentName() == 'last_order_name') {
                                    Cust.Name = parser.getText();
                                    system.debug('Name:  '+Cust.Name);
                                }
                                else  if(parser.getCurrentName() == 'admin_graphql_api_id') {
                                    string filename;
                                    filename = parser.getText();
                                    List<String> parts = filename.split('/');
                                    Cust.CustomerID__c = parts[parts.size()-1];
                                    system.debug('CustomerID__c:  '+Cust.CustomerID__c);
                                }
                            }
                        }
                    }
                    else if(parser.getCurrentToken() == JSONToken.END_OBJECT) {
                        continue;
                    } else if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        continue;
                    }
                }
            }
        }
        update Cust;
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        Integer offset = (pNumber - 1) * pSize;
        
        Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c];
        Integer recordEnd = pSize * pNumber;
        
        OrderSingleSyncDataTableWrapper objDT =  new OrderSingleSyncDataTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        //Email
        objDT.singlesyncorderList = [Select Name,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,OrderCount__c,FirstName__c,LastName__c, CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c ORDER BY Name LIMIT :pSize OFFSET :offset];
        return objDT;
    }
    
    public class OrderSingleSyncDataTableWrapper {
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
        public List<ShopifyOrders__c> singlesyncorderList {get;set;}
    }
    
    @AuraEnabled
    public static DeleteMultipleOrderDataTableWrapper deleteMultipleOrders(String lstRecordId, Integer pageNumber, Integer pageSize,String shopid,String OrderDataType) {
        system.debug(lstRecordId);
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        
        
        DeleteMultipleOrderDataTableWrapper objDT =  new DeleteMultipleOrderDataTableWrapper();
        ShopifyOrders__c lstDeleteRec = [Select Id,Name,TechnologyMind__ShopifyOrderID__c from TechnologyMind__ShopifyOrders__c where id =: lstRecordId];
        //Database.DeleteResult[] DR_Dels = Database.delete(lstDeleteRec, false);
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(shopname+'/admin/api/2019-07/orders/'+ lstDeleteRec.TechnologyMind__ShopifyOrderID__c +'.json'); //lstDeleteRec.ShopifyOrderID__c
         //   request.setEndpoint(shopname+'/admin/api/2019-07/orders/'+ 'a002w00000NPCSwAAP' +'.json');
            System.debug(shopname+'/admin/api/2019-07/orders/'+ lstDeleteRec.TechnologyMind__ShopifyOrderID__c +'.json');
            request.setMethod('DELETE'); 
            //   String username = '61aa8cff33084fb5eebfd721b7a6e3e5';
            //  String password = '51f5bfdbd12e120d34fe3669a3ed1949';
            Blob headerValue = Blob.valueOf(Token + ':' + Password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            system.debug('64code '+ authorizationHeader);
            
            request.setHeader('Authorization', authorizationHeader);
            HttpResponse response = http.send(request);
            System.debug(response);
            System.debug('response'+response.getBody());
            if (response.getStatusCode() == 200) {
                system.debug('Product Deleted');
                delete lstDeleteRec;
                objDT.message = 'success';
            }
            else{
                system.debug('Product Not Deleted');
                objDT.message =response.getBody();
            }
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        Integer offset = (pNumber - 1) * pSize;
        
        if(OrderDataType == 'Salesforce'){
            //Instance of Contact DataTable Wrapper Class
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c where ShopURL__c =:shopname and ChooseOrg__c = 'Salesforce' ];
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            //Email
            objDT.deletedmultipleorderList = [Select Product_variant_id__c,TechnologyMind__ProductVariantID__c,Name,Email__c,OrderCount__c,FirstName__c,LastName__c, CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c where ShopURL__c =:shopname ORDER BY Name ASC LIMIT :pSize OFFSET :offset ];
        }
        else if(OrderDataType == 'Shopify'){
            //Instance of Contact DataTable Wrapper Class
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c where ShopURL__c =:shopname and ChooseOrg__c = 'Shopify' ];
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            //Email
            objDT.deletedmultipleorderList = [Select Product_variant_id__c,TechnologyMind__ProductVariantID__c,Name,Email__c,OrderCount__c,FirstName__c,LastName__c, CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c where ShopURL__c =:shopname ORDER BY Name ASC LIMIT :pSize OFFSET :offset ];
        }
        
        else{
            //Instance of Contact DataTable Wrapper Class
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c where ShopURL__c =:shopname or ChooseOrg__c = 'Salesforce' ];
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            //Email
            objDT.deletedmultipleorderList = [Select Product_variant_id__c,Name,Email__c,OrderCount__c,FirstName__c,LastName__c, CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c where ShopURL__c =:shopname or ChooseOrg__c = 'Salesforce' ORDER BY Name ASC LIMIT :pSize OFFSET :offset ];
        }
        
        return objDT;
    }
    
    public class DeleteMultipleOrderDataTableWrapper {
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
        public List<ShopifyOrders__c> deletedmultipleorderList {get;set;}
        @AuraEnabled
        public String message {get;set;}
    }
    
    @AuraEnabled
    public static ShopifyDataTableWrapper getShopifyData(String shopid,Integer pageNumber, Integer pageSize) {
        system.debug('Value of id :'+ shopid);
        
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        
        Shopify_Configuration__c shopdetails = [Select id,Name from Shopify_Configuration__c where id = :shopids];
        String shopname = shopdetails.Name;
        ShopifyDataTableWrapper objDT =  new ShopifyDataTableWrapper();
        if(shopname !='' || shopname!= null){
            Integer pSize = (Integer)pageSize;
            Integer pNumber = (Integer)pageNumber;
            //Offset for SOQL
            Integer offset = (pNumber - 1) * pSize;
            //Total Records
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c WHERE  ChooseOrg__c = 'Shopify' and ShopURL__c =:shopname];
            Integer recordEnd = pSize * pNumber;
            //Instance of Contact DataTable Wrapper Class
            
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            //Email
            objDT.shopifyList = [Select Name,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,FirstName__c,LastName__c,CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c WHERE ChooseOrg__c = 'Shopify'and ShopURL__c =:shopname  ORDER BY Name ASC LIMIT :pSize OFFSET :offset];
            
        }
        return objDT;
    }
    
    public class ShopifyDataTableWrapper {
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
        public List<ShopifyOrders__c> shopifyList {get;set;}
    }
    
    @AuraEnabled
    public static SalesforceOrderDataTableWrapper getSalesforceOrderList(String shopid,Integer pageNumber, Integer pageSize) {
        Shopify_Configuration__c shopdetails = [Select id,Name from Shopify_Configuration__c where id = :shopid];
        String shopname = shopdetails.Name;
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c WHERE ShopURL__c = :shopdetails.Name and ChooseOrg__c != 'Shopify'];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        SalesforceOrderDataTableWrapper objDT =  new SalesforceOrderDataTableWrapper();
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        //Email
        objDT.salesforceOrderList = [Select Name,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,FirstName__c,LastName__c,CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c WHERE ShopURL__c = :shopdetails.Name and ChooseOrg__c != 'Shopify'  ORDER BY Name ASC LIMIT :pSize OFFSET :offset];
        return objDT;
    }
    
    public class SalesforceOrderDataTableWrapper {
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
        public List<ShopifyOrders__c> salesforceOrderList {get;set;}
    }
    
    @AuraEnabled
    public static AllOrderDataTableWrapper getAllOrderList(String shopid,Integer pageNumber, Integer pageSize) {
        system.debug('Shopid : '+shopid);
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        Shopify_Configuration__c shopdetails = [Select id,name from Shopify_Configuration__c where id = :shopid ];
        Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c where ShopURL__c = :shopdetails.Name];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        AllOrderDataTableWrapper objDT =  new AllOrderDataTableWrapper();
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        //Email
        objDT.allOrderList = [Select Name,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,FirstName__c,LastName__c,CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c where ShopURL__c Like :shopdetails.Name  ORDER BY Name ASC LIMIT :pSize OFFSET :offset];
        
        List<String> Shopnames = new List<String>();
        List<Shopify_Configuration__c> shopdetail = [Select id,name from Shopify_Configuration__c];
        for(Shopify_Configuration__c st: shopdetail ){
            Shopnames.add(st.name);
            system.debug('value'+Shopnames);
        }
        objDT.Shopnames = Shopnames;
        
        return objDT;
    }
    
    public class AllOrderDataTableWrapper {
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
        public List<String> Shopnames {get;set;}
        @AuraEnabled
        public List<ShopifyOrders__c> allOrderList {get;set;}
    }
    
    // Export order data from salesforce to shopify
    @AuraEnabled
    public static string exportToShopify(String shopid,String variant_id) 
    {        
        string message ;
        system.debug('Productid'+variant_id);
        system.debug('shopid'+shopid);
         id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids limit 1];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        system.debug('shopdetails'+shopdetails);
        system.debug('shopname'+shopdetails.Name);
        //email
        ShopifyOrders__c Orderstoinsert = [Select customer__r.Shopifyprovincecode__c,Id,Email__c,address1__c,address2__c,firstname__c,phone__c,lastname__c,city__c,state__c,country__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,orderCount__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,ZIPCode__c from ShopifyOrders__c where Id = :variant_id limit 1];
        system.debug('order'+Orderstoinsert);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        //request.setEndpoint(shopname+'/admin/api/2019-10/products.json');
        request.setEndpoint(shopname+'admin/api/2019-10/orders.json');
        request.setMethod('POST');
        
       /* Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization',authorizationHeader);
        request.setHeader('Content-Type','application/json');*/
        
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', 'application/json');
        
        
        List<String> line_items= new List<String>();
      //  if(Orderstoinsert.Product_variant_id__c!=null)
          if(Orderstoinsert.TechnologyMind__ProductVariantID__c!=null) 
        {
            String val = String.valueOf(Orderstoinsert.TechnologyMind__ProductVariantID__c);
            system.debug('val' +val);
            line_items.add(val);
        }
        //String val = String.valueOf(Orderstoinsert.Product_variant_id__c);
        
        String email = Orderstoinsert.Email__c;
        String first_name =Orderstoinsert.firstname__c;
        String last_name =Orderstoinsert.lastname__c;
        String cusAdd1 =Orderstoinsert.address1__c ;
        String cusCity =Orderstoinsert.city__c;
        String cusProvince =Orderstoinsert.Customer__r.Shopifyprovincecode__c;
        String cusAddrPhone = Orderstoinsert.phone__c;
        String cusZip =Orderstoinsert.zipcode__c;
        String cusCountry =Orderstoinsert.country__c;
        String transKind = '' ;
        String transStatus = '' ;
        String transAmt =Orderstoinsert.TotalPrice__c ;
        system.debug('Orderstoinsert====  ' +Orderstoinsert.TechnologyMind__ProductVariantID__c);
        String liVarId = String.valueOf(Orderstoinsert.TechnologyMind__ProductVariantID__c) ;
        String liQty =Orderstoinsert.orderCount__c;
        string cusAddress =Orderstoinsert.address2__c ;
        //transtatus and transKind are not mapping from initially
        OrderPost ordobj= new OrderPost(email,first_name,last_name,cusAdd1,cusCity,cusProvince,cusAddrPhone,cusZip,first_name,last_name,cusCountry,transKind,transStatus,transAmt,liVarId,liQty);
        
        system.debug('Till Here 1');
        system.debug(ordobj);
        
        String jsonBody = json.serialize(ordobj); 
        
        system.debug('Value '+jsonBody);
        if (jsonBody != null){
            request.setBody(jsonBody);
        }
        HttpResponse response = http.send(request);
        //HttpResponse response;
        system.debug(response.getStatusCode());
        system.debug('request'+request);
        if (response.getStatusCode() == 200) {
            message = 'success';
        }
        else{
           //message = 'error export failed due to Unprocessable Entity'; //response.getBody();
             message = response.getBody();
         }
        system.debug('response message :'+response.getBody());
        return message;
    }
    @AuraEnabled
    public static OrderDataTypeTableWrapper Order_Type_Data(String OrderType,Integer pageNumber, Integer pageSize,String shopid) {
        // List<Product2> list_pbe = new List<Product2>();
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids limit 1];
        String shopname = shopdetails.Name; 
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        
        //Total Records
        //Instance of Contact DataTable Wrapper Class
        OrderDataTypeTableWrapper objDT =  new OrderDataTypeTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        
        if(OrderType == 'All'){
            List<ShopifyOrders__c> prod = [Select Name,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,FirstName__c,LastName__c,CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c WHERE ChooseOrg__c = 'Salesforce' or ShopURL__c = :shopname  ORDER BY Name ASC LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c where ChooseOrg__c = 'Salesforce' or ShopURL__c = :shopname];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.orderList = prod;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
        }
        else if(OrderType == 'Salesforce'){
            List<ShopifyOrders__c> prod = [Select Name,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,FirstName__c,LastName__c,CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c WHERE ChooseOrg__c = :OrderType ORDER BY Name ASC LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c Where ChooseOrg__c =:OrderType ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.orderList = prod;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
        }
        else if(OrderType == 'Shopify'){
            List<ShopifyOrders__c> prod = [Select Name,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,FirstName__c,LastName__c,CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c WHERE ChooseOrg__c = 'Shopify'and ShopURL__c =:shopname  ORDER BY Name ASC LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c Where ChooseOrg__c =:OrderType  And ShopURL__c like :shopname ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.orderList = prod;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
        }
        system.debug('objDT :'+objDT);
        return objDT;
    }
    public class OrderDataTypeTableWrapper {
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
        public List<ShopifyOrders__c> orderList {get;set;}
    } 
    
    // Search Specific Order record
    @AuraEnabled
    public static OrderDataTableSearchWrapper fetchSearchOrder(String searchKeyWord,String shopid,Integer pageNumber, Integer pageSize,String OrderType) {
        OrderDataTableSearchWrapper objDT =  new OrderDataTableSearchWrapper();  
        
        String searchKey ='%' + searchKeyWord + '%';
        system.debug('VAlue : '+OrderType);
         id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name from Shopify_Configuration__c where id = :shopids limit 1];
        String shopname = shopdetails.Name; 
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        if(OrderType == 'All'){
            List<ShopifyOrders__c> prod = [Select Name,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,FirstName__c,LastName__c,CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c WHERE (ChooseOrg__c = 'Salesforce' or ShopURL__c like :shopname) and Name LIKE: searchKey  ORDER BY Name ASC LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c where (ChooseOrg__c = 'Salesforce' or ShopURL__c like :shopname) and Name LIKE: searchKey];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.OrderList = prod;
        }
        else if(OrderType == 'Salesforce'){
            List<ShopifyOrders__c> prod = [Select Name,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,FirstName__c,LastName__c,CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c WHERE ChooseOrg__c = :OrderType  and Name LIKE: searchKey  ORDER BY Name ASC LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c Where ChooseOrg__c =:OrderType and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.OrderList = prod;
        }
        else if(OrderType == 'Shopify'){
            List<ShopifyOrders__c> prod = [Select Name,OrderCount__c,Product_variant_id__c,TechnologyMind__ProductVariantID__c,Email__c,FirstName__c,LastName__c,CreatedDate,CustomerID__c,OrderStatus__c,ShopifyOrderID__c,Address1__c,Address2__c,City__c,State__c,Country__c,TotalPrice__c,ShopURL__c,ChooseOrg__c,Phone__c,ZIPCode__c,Shopify_Created_At__c FROM ShopifyOrders__c WHERE ChooseOrg__c = :OrderType and ShopURL__c like :shopname and Name LIKE: searchKey  ORDER BY Name ASC LIMIT :pSize OFFSET :offset];
            
            Integer totalRecords = [SELECT COUNT() FROM ShopifyOrders__c Where ChooseOrg__c =:OrderType and ShopURL__c like :shopname and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.recordStart = offset + 1;
            objDT.pageNumber = pNumber;
            objDT.OrderList = prod;
        }			
        return objDT;
    }
    public class OrderDataTableSearchWrapper {
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
        public List<ShopifyOrders__c> OrderList {get;set;}
    }
}