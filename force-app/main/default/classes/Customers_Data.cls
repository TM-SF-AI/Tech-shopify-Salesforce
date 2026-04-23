public class Customers_Data {
    
    @AuraEnabled
    public static CustomerDataTableWrapper getCustomerAllData(Integer pageNumber, Integer pageSize,String shopid){
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        Integer recordEnd = pSize * pNumber;
        
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c,Customer_Mapping__c from Shopify_Configuration__c where id = :shopids limit 1];
        Integer totalRecords = [SELECT COUNT() FROM Account where Shopify_Shop_Url__c = :shopdetails.Name and Choose_Customer__c = 'Shopify'];
        
        system.debug('s'+shopdetails);
        system.debug('t'+totalRecords);
        
        CustomerDataTableWrapper objDT =  new CustomerDataTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.accountList = [Select Id,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,BillingCity,Shopify_Customer_Id__c, Shopify_Email__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Shopify_Shop_Url__c,Type,Rating,Choose_Customer__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees,phone from Account Where Shopify_Shop_Url__c = :shopdetails.Name and Choose_Customer__c = 'Shopify' ORDER BY Name LIMIT :pSize OFFSET :offset];
        system.debug('Shop Data :'+objDT.accountList);
        return objDT;
    }
    
    
    @AuraEnabled
    public static CustomerDataTableWrapper getConditionalCustomerSyncData(date Shopify_Updated_After,date Shopify_Updated_Before,date Shopify_Created_After,date Shopify_Created_Before,Integer pageNumber, Integer pageSize,String shopid){
        CustomerDataTableWrapper objDT =  new CustomerDataTableWrapper();  
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        
        system.debug('p'+pSize+' '+pNumber+' ' +offset);
        
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c,Customer_Mapping__c from Shopify_Configuration__c where id = :shopid limit 1];
        
        Account Cust = new Account();                                               
        List<Account> list_pbe = new List<Account>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopdetails.Name+'/admin/customers.json');
        request.setMethod('GET');
        String username = shopdetails.Shopify_Access_Token__c;
        String password = shopdetails.Password__c;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        String authnull = 'null';
        request.setHeader('Authorization',authorizationHeader);
        
        String selected = shopdetails.Customer_Mapping__c.unescapeHtml4();
        Map<String, Object> valuesMap = new Map<String, Object>();
        
        for(Object obj : (List<Object>)JSON.deserializeUntyped(selected)){
            //convert values to map
            Map<String, Object> data = (Map<String, Object>)obj;
            valuesMap.putAll(data );
        }
        system.debug('Map Values : '+valuesMap);
        HttpResponse response = http.send(request);
        System.debug('response'+response.getBody());
        
        ShopifyParsingCustomer myShoipfyData = ShopifyParsingCustomer.parse(response.getBody());
        
        List<sObject> Custrecords = new List<sObject>();
        
        if (response.getStatusCode() == 200) 
        {
            
            List <ShopifyParsingCustomer> myList =new  List <ShopifyParsingCustomer>();
            myList.add(myShoipfyData);
            For(ShopifyParsingCustomer ab : myList){
                system.debug('ab'+ab);
                for(ShopifyParsingCustomer.Customers typ : ab.Customers ){
                    system.debug('type'+typ);
                    SObject s = new Account();  
                    
                    string Choose_Customer = 'Choose_Customer__c';
                    s.put(Choose_Customer, 'Shopify');
                    
                    for(string key : valuesMap.keyset()){
                        string Email = 'Shopify_Email__c';
                        s.put(Email, typ.email);
                        string Shop_Url = 'Shopify_Shop_Url__c';
                        s.put(Shop_Url, shopdetails.Name);
                        if(key == 'Total_Spent'){
                            string value = String.valueOf(valuesMap.get('Total_Spent'));
                            s.put(value, typ.total_spent);
                        }
                        else if(key == 'Last_Order_Name'){
                            string value = String.valueOf(valuesMap.get('Last_Order_Name'));
                            s.put(value, typ.last_order_name);
                        }
                        else if(key == 'Orders_Count'){
                            string value = String.valueOf(valuesMap.get('Orders_Count'));
                            s.put(value, typ.orders_count);
                        }
                        for(ShopifyParsingCustomer.Addresses var : typ.Addresses ){
                            string First_Name = 'Name';
                            s.put(First_Name, var.first_name);
                            string Customer_Id = 'Shopify_Customer_Id__c';
                            s.put(Customer_Id, var.customer_id);
                            
                            if(key == 'Last_Name'){
                                string value = String.valueOf(valuesMap.get('Last_Name'));
                                s.put(value, var.last_name);
                            }
                            
                            else if(key == 'Billing_State'){
                                string value = String.valueOf(valuesMap.get('Billing_State'));
                                s.put(value, var.province);
                            }
                            
                            else if(key == 'Billing_Country'){
                                string value = String.valueOf(valuesMap.get('Billing_Country'));
                                s.put(value, var.country);
                            }
                            
                            else if(key == 'Zip'){
                                string value = String.valueOf(valuesMap.get('Zip'));
                                s.put(value, var.zip);
                            }
                            
                            else if(key == 'Phone'){
                                string value = String.valueOf(valuesMap.get('Phone'));
                                s.put(value, var.phone);
                            }
                            else if(key == 'Country_Code'){
                                string value = String.valueOf(valuesMap.get('Country_Code'));
                                s.put(value, var.country_code);
                            }
                        }
                    }
                    system.debug('here='+s.get('Name'));
                    
                    string Created_At = 'ShopifyCreatedDate__c';
                    
                    String ConvertedCreated_At;
                    ConvertedCreated_At = typ.created_at.substring(0, typ.created_at.indexOf('T'));
                    System.debug('Created_At : '+ConvertedCreated_At);
                    
                    s.put(Created_At, date.ValueOf(ConvertedCreated_At));
                    
                    string Updated_At = 'ShopifyUpdatedDate__c';
                    
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
                              if(s.get('Name')!=null){
                                  Custrecords.add(s);
                              }
                          }
                    }
                    else if(Shopify_Created_After !=null && Shopify_Created_Before ==null ){
                        if(s.get('Name')!=null){
                            Custrecords.add(s);
                        }
                    }
                    else if(Shopify_Created_After ==null && Shopify_Created_Before !=null ){
                        if(s.get('Name')!=null){
                            Custrecords.add(s);
                        }
                    }
                    else if(Shopify_Created_After !=null && Shopify_Created_Before !=null ){
                        if(date.ValueOf(ConvertedCreated_At) >= Shopify_Created_After && date.ValueOf(ConvertedCreated_At) <= Shopify_Created_Before){
                            if(s.get('Name')!=null){
                                Custrecords.add(s);
                            }
                        }
                    }
                    else if(Shopify_Updated_After !=null && Shopify_Updated_Before ==null){ 
                        if(s.get('Name')!=null){
                            Custrecords.add(s);
                        } 
                    }
                    else if(Shopify_Updated_After ==null && Shopify_Updated_Before !=null){ 
                        if(s.get('Name')!=null){
                            Custrecords.add(s);
                        } 
                    }
                    else if(Shopify_Updated_After !=null && Shopify_Updated_Before !=null ){
                        if(date.ValueOf(ConvertedUpdatedAt) >= Shopify_Updated_After && date.ValueOf(ConvertedUpdatedAt) <= Shopify_Updated_Before){
                            if(s.get('Name')!=null){
                                Custrecords.add(s);
                            } 
                        }
                    }
                    
                    
                }
            }  
        }
        List<Account> AccountsToInsert = new List<Account>();
        
        for(sObject s : Custrecords) {
            
            AccountsToInsert.add((Account) s);
        }
        System.debug('New AccountsToInsert '+AccountsToInsert);
        System.debug('New AccountsToInsert size : '+AccountsToInsert.size());
        
        List<Account> firstList = [Select id,Shopify_Customer_Id__c,Name From Account ];
        
        Map<String, Account> firstMap = new Map<String, Account>();
        Map<String, Account> secondMap = new Map<String, Account>();
        
        for(Account ocr : AccountsToInsert){
            secondMap.put(ocr.Shopify_Customer_Id__c, ocr);
        }
        for(Account ocr : firstList){
            firstMap.put(ocr.Shopify_Customer_Id__c, ocr);
        }
        Map<String, Account> result = new Map<String, Account>();
        Map<String, Account> Sameresult = new Map<String, Account>();
        System.debug('firstMap size '+firstMap.size());
        System.debug('secondMap Size '+secondMap.size());
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
        
        // System.debug('List are equals'+result);
        System.debug('List are not equals size'+result.size());
        system.debug('result'+result);
        List<Account> finalproductlist = new list<Account>();
        for(Account results : result.values()) {
            system.debug('iii='+results);
            system.debug('Email ='+results.Shopify_Email__c);
            finalproductlist.add(results);
        }
        system.debug('final'+finalproductlist);
        try {
            // database.upsert(finalproductlist, false);
            // insert Custrecords;
            insert finalproductlist;
            //System.debug('New list_pbe '+finalproductlist);
            System.debug('New finalproductlist : '+finalproductlist.size());
            // This doesn't execute since insert causes an exception
            System.debug('Statement after insert.');
            objDt.message =response.getBody();
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            objDt.message = e.getMessage();
        }
        Integer totalRecords = [SELECT COUNT() FROM Account where Shopify_Shop_Url__c = :shopdetails.Name and Choose_Customer__c = 'Shopify'];
        Integer recordEnd = pSize * pNumber;
        
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.accountList = [Select Id,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Shopify_Shop_Url__c,Type,Rating,Choose_Customer__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees,phone from Account Where Shopify_Shop_Url__c = :shopdetails.Name and Choose_Customer__c = 'Shopify' ORDER BY Name LIMIT :pSize OFFSET :offset];
        return objDT;
    }
    @AuraEnabled
    public static CustomerDataTableWrapper getCustomerData (Integer pageNumber, Integer pageSize,String shopid){
        CustomerDataTableWrapper objDT =  new CustomerDataTableWrapper();  
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        
        system.debug('p'+pSize+' '+pNumber+' ' +offset);
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c,Customer_Mapping__c from Shopify_Configuration__c where id = :shopids limit 1];
        
        Account Cust = new Account();                                               
        List<Account> list_pbe = new List<Account>();
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopdetails.Name+'/admin/customers.json');
        request.setMethod('GET');
        String username = shopdetails.Shopify_Access_Token__c;
        String password = shopdetails.Password__c;
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        String authnull = 'null';
        request.setHeader('Authorization', authorizationHeader);
        
        String selected = shopdetails.Customer_Mapping__c.unescapeHtml4();
        Map<String, Object> valuesMap = new Map<String, Object>();
        
        for(Object obj : (List<Object>)JSON.deserializeUntyped(selected)){
            //convert values to map
            Map<String, Object> data = (Map<String, Object>)obj;
            valuesMap.putAll(data );
        }
        system.debug('Map Values : '+valuesMap);
        HttpResponse response = http.send(request);
        System.debug('response'+response.getBody());
        
        ShopifyParsingCustomer myShoipfyData = ShopifyParsingCustomer.parse(response.getBody());
        
        List<sObject> Custrecords = new List<sObject>();
        
        if (response.getStatusCode() == 200) 
        {
            
            List <ShopifyParsingCustomer> myList =new  List <ShopifyParsingCustomer>();
            myList.add(myShoipfyData);
            For(ShopifyParsingCustomer ab : myList){
                system.debug('ab'+ab);
                for(ShopifyParsingCustomer.Customers typ : ab.Customers ){
                    system.debug('type'+typ);
                    SObject s = new Account();  
                    
                    string Choose_Customer = 'Choose_Customer__c';
                    s.put(Choose_Customer, 'Shopify');
                    
                    for(string key : valuesMap.keyset()){
                        string Email = 'Shopify_Email__c';
                        s.put(Email, typ.email);
                        
                        //Cust.Choose_Customer__c= 'Shopify';
                        
                        
                        // Cust.Shopify_Shop_Url__c = shopdetails.Name;
                        string Shop_Url = 'Shopify_Shop_Url__c';
                        s.put(Shop_Url, shopdetails.Name);
                        
                        /*    if(key =='Email'){
string value = String.valueOf(valuesMap.get('Email'));
s.put(value, typ.email);
// Cust.Shopify_Email__c=typ.email;
//  System.debug('email ' + typ.email);
}*/
                        if(key == 'Total_Spent'){
                            string value = String.valueOf(valuesMap.get('Total_Spent'));
                            s.put(value, typ.total_spent);
                            //  Cust.ShopifyTotalSpent__c=typ.total_spent;
                            // System.debug('total_spent ' + Cust.ShopifyTotalSpent__c);
                        }
                        else if(key == 'Last_Order_Name'){
                            string value = String.valueOf(valuesMap.get('Last_Order_Name'));
                            s.put(value, typ.last_order_name);
                            //   Cust.Shopifylastordername__c=typ.last_order_name;
                            //  System.debug('last_order_name ' + Cust.Shopifylastordername__c);
                        }
                        else if(key == 'Orders_Count'){
                            string value = String.valueOf(valuesMap.get('Orders_Count'));
                            s.put(value, typ.orders_count);
                            //   Cust.ShopifyOrderCount__c=typ.orders_count;
                            // System.debug('orders_count ' + Cust.ShopifyOrderCount__c);
                        }
                        for(ShopifyParsingCustomer.Addresses var : typ.Addresses ){
                            // First_Name
                            string First_Name = 'Name';
                            s.put(First_Name, var.first_name);
                            // Customer_id
                            string Customer_Id = 'Shopify_Customer_Id__c';
                            s.put(Customer_Id, var.customer_id);
                            
                            /*  if(key == 'Customer_id'){
//  string value = String.valueOf(valuesMap.get('Customer_id'));
string value = 'Shopify_Customer_Id__c';
s.put(value, var.customer_id);
//  Cust.Shopify_Customer_Id__c=var.customer_id;
//  System.debug('customer_id ' + Cust.Shopify_Customer_Id__c);
}

else if(key == 'First_Name'){
//string value = String.valueOf(valuesMap.get('First_Name'));

//   Cust.Name=var.first_name;
//  System.debug('first_name ' + Cust.Name);
}*/
                            
                            if(key == 'Last_Name'){
                                string value = String.valueOf(valuesMap.get('Last_Name'));
                                s.put(value, var.last_name);
                                //   Cust.ShopifyLastName__c=var.last_name;
                                //  System.debug('last_name  ' + Cust.ShopifyLastName__c);
                            }
                            
                            else if(key == 'Billing_State'){
                                string value = String.valueOf(valuesMap.get('Billing_State'));
                                s.put(value, var.province);
                                //   Cust.Shopify_Billing_State__c=var.province;
                                //  System.debug('province  ' + Cust.Shopify_Billing_State__c);
                            }
                            
                            else if(key == 'Billing_Country'){
                                string value = String.valueOf(valuesMap.get('Billing_Country'));
                                s.put(value, var.country);
                                //   Cust.ShopifyBillingCountry__c=var.country;
                                //  System.debug('country  ' + Cust.ShopifyBillingCountry__c);
                            }
                            
                            else if(key == 'Zip'){
                                string value = String.valueOf(valuesMap.get('Zip'));
                                s.put(value, var.zip);
                                //  Cust.ShopifyZipCode__c=var.zip;
                                // System.debug('zip  ' + Cust.ShopifyZipCode__c);
                            }
                            
                            else if(key == 'Phone'){
                                string value = String.valueOf(valuesMap.get('Phone'));
                                s.put(value, var.phone);
                                // Cust.ShopifyPhone__c=var.phone;
                                //System.debug('phone  ' + Cust.ShopifyPhone__c);
                            }
                            else if(key == 'Country_Code'){
                                string value = String.valueOf(valuesMap.get('Country_Code'));
                                s.put(value, var.country_code);
                                // Cust.Shopifycountrycode__c=var.country_code;
                                // System.debug('country_code  ' + Cust.Shopifycountrycode__c);
                            }
                        }
                        //list_pbe.add(Cust);   
                        //Cust = new Account();
                    }
                    system.debug('here='+s.get('Name'));
                    if(s.get('Name')!=null)
                        Custrecords.add(s);
                    
                }
            }  
        }
        List<Account> AccountsToInsert = new List<Account>();
        
        for(sObject s : Custrecords) {
            
            AccountsToInsert.add((Account) s);
        }
        System.debug('New AccountsToInsert '+AccountsToInsert);
        System.debug('New AccountsToInsert size : '+AccountsToInsert.size());
        
        List<Account> firstList = [Select id,Shopify_Customer_Id__c,Name From Account ];
        
        Map<String, Account> firstMap = new Map<String, Account>();
        Map<String, Account> secondMap = new Map<String, Account>();
        
        for(Account ocr : AccountsToInsert){
            secondMap.put(ocr.Shopify_Customer_Id__c, ocr);
        }
        for(Account ocr : firstList){
            firstMap.put(ocr.Shopify_Customer_Id__c, ocr);
        }
        Map<String, Account> result = new Map<String, Account>();
        Map<String, Account> Sameresult = new Map<String, Account>();
        //  System.debug('firstMap list '+firstMap);
        System.debug('firstMap size '+firstMap.size());
        System.debug('secondMap Size '+secondMap.size());
        // System.debug('New list '+secondMap);
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
        
        // System.debug('List are equals'+result);
        System.debug('List are not equals size'+result.size());
        system.debug('result'+result);
        List<Account> finalproductlist = new list<Account>();
        for(Account results : result.values()) {
            system.debug('iii='+results);
            system.debug('Email ='+results.Shopify_Email__c);
            finalproductlist.add(results);
        }
        system.debug('final'+finalproductlist);
        try {
            // database.upsert(finalproductlist, false);
            // insert Custrecords;
            insert finalproductlist;
            //System.debug('New list_pbe '+finalproductlist);
            System.debug('New finalproductlist : '+finalproductlist.size());
            // This doesn't execute since insert causes an exception
            System.debug('Statement after insert.');
            objDt.message =response.getBody();
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            objDt.message = e.getMessage();
        }
        Integer totalRecords = [SELECT COUNT() FROM Account where Shopify_Shop_Url__c = :shopdetails.Name and Choose_Customer__c = 'Shopify'];
        Integer recordEnd = pSize * pNumber;
        
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.accountList = [Select Id,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Shopify_Shop_Url__c,Type,Rating,Choose_Customer__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees,phone from Account Where Shopify_Shop_Url__c = :shopdetails.Name and Choose_Customer__c = 'Shopify' ORDER BY Name LIMIT :pSize OFFSET :offset];
        
        return objDT;
    }
    
    
    // Searching .......
    @AuraEnabled
    public static ShopifyDataTableWrapperSearch fetchSearchProduct(Integer pageNumber, Integer pageSize,String searchKeyWord,String shopid,String OrgType) {
        String searchKey ='%' + searchKeyWord + '%';
        ShopifyDataTableWrapperSearch objDT =  new ShopifyDataTableWrapperSearch();
        List < Account > returnList = new List < Account > ();
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopid];
        String shopname = shopdetails.Name; 
        if(OrgType == 'Salesforce')
        { 
            Integer pSize = (Integer)pageSize;
            Integer pNumber = (Integer)pageNumber;
            Integer offset = (pNumber - 1) * pSize;
            Integer totalRecords = [SELECT COUNT() FROM Account WHERE (Shopify_Shop_Url__c = :shopname and Choose_Customer__c ='Salesforce') and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;        
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.shopifyList = [Select Id,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees from Account WHERE (Shopify_Shop_Url__c = :shopname AND Choose_Customer__c ='Salesforce' ) AND Name LIKE: searchKey ORDER BY Name LIMIT :pSize OFFSET :offset];
        }   
        else if(OrgType == 'Shopify')
        { 
            Integer pSize = (Integer)pageSize;
            Integer pNumber = (Integer)pageNumber;
            Integer offset = (pNumber - 1) * pSize;
            Integer totalRecords = [SELECT COUNT() FROM Account WHERE Shopify_Shop_Url__c = :shopname and Name LIKE: searchKey and Choose_Customer__c ='Shopify'];
            Integer recordEnd = pSize * pNumber;        
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.shopifyList = [Select Id,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees,phone from Account WHERE (Shopify_Shop_Url__c = :shopname AND Choose_Customer__c = 'Shopify' ) AND Name LIKE: searchKey ORDER BY Name LIMIT :pSize OFFSET :offset];
        }  
        
        else if(OrgType == 'All')
        { 
            Integer pSize = (Integer)pageSize;
            Integer pNumber = (Integer)pageNumber;
            Integer offset = (pNumber - 1) * pSize;
            Integer totalRecords = [SELECT COUNT() FROM Account WHERE (Shopify_Shop_Url__c = :shopname and Choose_Customer__c ='Salesforce') and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;        
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.shopifyList = [Select Id,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees,phone from Account WHERE (Shopify_Shop_Url__c = :shopname OR Choose_Customer__c = 'Salesforce' ) AND Name LIKE: searchKey ORDER BY Name LIMIT :pSize OFFSET :offset];
        }
        
        return objDT;
        
    }
    
    public class ShopifyDataTableWrapperSearch {
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
        public List<Account> shopifyList {get;set;}
    }
    
    
    @Auraenabled
    public static ProductDeleteDataTableWrapper deleteProductById(String accid,Integer pageNumber, Integer pageSize,String shopid,String CustomerDataType)
    {
        system.debug('Value :'+CustomerDataType);
        ProductDeleteDataTableWrapper objDT =  new ProductDeleteDataTableWrapper();  
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        
        try{
            Account delAccount =[Select Id,Shopify_Customer_Id__c from Account where Id =:accid];
            if(delAccount.Shopify_Customer_Id__c != null){
                Http http = new Http();
                HttpRequest request = new HttpRequest();
                request.setEndpoint(shopname+'/admin/api/2019-07/customers/'+ delAccount.Shopify_Customer_Id__c +'.json');
                request.setMethod('DELETE');
                //   String username = '61aa8cff33084fb5eebfd721b7a6e3e5';
                //  String password = '51f5bfdbd12e120d34fe3669a3ed1949';
                Blob headerValue = Blob.valueOf(Token + ':' + Password);
                String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                system.debug('64code '+ authorizationHeader);
                
                request.setHeader('Authorization', authorizationHeader);
                HttpResponse response = http.send(request);
                System.debug('response'+response.getBody());
                if (response.getStatusCode() == 200) {
                    system.debug('Product Deleted');
                    delete delAccount;
                    objDT.message = 'success';
                }
                else{
                    system.debug('Product Not Deleted');
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
        }
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        
        if(CustomerDataType == 'Salesforce'){
            Integer totalRecords = [SELECT COUNT() FROM Account where Choose_Customer__c = 'Salesforce'];
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.accountList2 = [Select Id, Name,BillingCity,BillingState, AnnualRevenue, Phone, Website, CreatedDate, LastModifiedDate FROM Account where  Shopify_Shop_Url__c = :shopname and Choose_Customer__c = 'Salesforce'  ORDER BY Name LIMIT :pSize OFFSET :offset ];
        }
        else if(CustomerDataType == 'Shopify'){
            Integer totalRecords = [SELECT COUNT() FROM Account where Shopify_Shop_Url__c = :shopname and Choose_Customer__c = 'Shopify'];
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.accountList2 = [Select Id,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Shopify_Shop_Url__c,Type,Rating,Choose_Customer__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees, Phone from Account where Shopify_Shop_Url__c = :shopname AND Choose_Customer__c = 'Shopify' ORDER BY Name LIMIT :pSize OFFSET :offset ];
        }
        else if(CustomerDataType == 'All'){
            Integer totalRecords = [SELECT COUNT() FROM Account];
            Integer recordEnd = pSize * pNumber;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.accountList2 = [Select Id,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Shopify_Shop_Url__c,Type,Rating,Choose_Customer__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees, Phone from Account ORDER BY Name LIMIT :pSize OFFSET :offset ];
        }
        
        return  objDT;
    }    
    public class ProductDeleteDataTableWrapper {
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
        
        public List<Account> accountList2 {get;set;}
    }
    
    @AuraEnabled
    public static CustomerSingleSyncDataTableWrapper syncsinglecustomer(String id,Integer pageNumber, Integer pageSize,String shopid) {
        
        
        Account Cust = [Select Id,Name,Shopify_Customer_Id__c FROM Account WHERE Shopify_Customer_Id__c= :id limit 1];                                          
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopid];
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(shopname+'/admin/api/2019-07/customers/'+id+'.json');
        request.setMethod('GET');
        //  String username = '61aa8cff33084fb5eebfd721b7a6e3e5';
        // String password = '51f5bfdbd12e120d34fe3669a3ed1949';
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        system.debug('64code '+ authorizationHeader);
        String authnull = 'null';
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response = http.send(request);
        System.debug('response'+response.getBody());
        
        if (response.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(response.getBody());
            String Name ;
            while(parser.nextToken()!= null) {
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                    parser.nextValue();    
                    if(parser.getCurrentName() == 'email') {
                        Cust.Shopify_Email__c = parser.getText();
                        system.debug('Shopify_Email:  '+Cust.Shopify_Email__c);
                    }
                    else if(parser.getCurrentName() == 'created_at') {
                        Cust.ShopifyCreatedDate__c = parser.getDateTimeValue();
                        system.debug('ShopifyCreatedDate__c:  '+Cust.ShopifyCreatedDate__c);
                    } 
                    else if(parser.getCurrentName() == 'updated_at') {
                        Cust.ShopifyUpdatedDate__c = parser.getDateTimeValue();
                        system.debug('ShopifyUpdatedDate__c:  '+Cust.ShopifyUpdatedDate__c);
                    }
                    else if(parser.getCurrentName() == 'total_spent') {
                        Cust.ShopifyTotalSpent__c = parser.getText();
                        system.debug('ShopifyTotalSpent__c:  '+Cust.ShopifyTotalSpent__c);
                    }
                    
                    else if(parser.getCurrentName() == 'last_order_name') {
                        Cust.Shopifylastordername__c = parser.getText();
                        system.debug('Shopifylastordername__c:  '+Cust.Shopifylastordername__c);
                    } 
                    else if(parser.getCurrentName() == 'orders_count') {
                        Cust.ShopifyOrderCount__c = parser.getText();
                        system.debug('ShopifyOrderCount__c:  '+Cust.ShopifyOrderCount__c);
                    } 
                    
                    else if (parser.getCurrentName() == 'addresses') {
                        while(parser.nextToken()!= JSONToken.END_ARRAY) {
                            if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                                parser.nextValue();
                                if (parser.getCurrentName() == 'customer_id') {
                                    Cust.Shopify_Customer_Id__c = parser.getText();
                                    system.debug('Customer_Id : '+ Cust.Shopify_Customer_Id__c);
                                }
                                else if(parser.getCurrentName() == 'first_name') {
                                    Cust.Name = parser.getText();
                                    system.debug('first_name:  '+Cust.Name);
                                }
                                else if(parser.getCurrentName() == 'last_name') {
                                    Cust.ShopifyLastName__c = parser.getText();
                                    system.debug('lastname:  '+Cust.ShopifyLastName__c);
                                }
                                else if (parser.getCurrentName() == 'province') {
                                    Cust.Shopify_Billing_State__c = parser.getText();
                                    system.debug('BillingState:  '+Cust.Shopify_Billing_State__c);
                                }
                                else  if(parser.getCurrentName() == 'country') {
                                    Cust.ShopifyBillingCountry__c = parser.getText();
                                    system.debug('BillingCountry:  '+Cust.ShopifyBillingCountry__c);
                                } 
                                else  if(parser.getCurrentName() == 'zip') {
                                    Cust.ShopifyZipCode__c = parser.getText();
                                    system.debug('ShopifyZipCode__c:  '+Cust.ShopifyZipCode__c);
                                }  
                                else  if(parser.getCurrentName() == 'phone') {
                                    Cust.ShopifyPhone__c = parser.getText();
                                    system.debug('ShopifyPhone__c:  '+Cust.ShopifyPhone__c);
                                } 
                                else  if(parser.getCurrentName() == 'province_code') {
                                    Cust.Shopifyprovincecode__c = parser.getText();
                                    system.debug('Shopifyprovincecode__c:  '+Cust.Shopifyprovincecode__c);
                                } 
                                else  if(parser.getCurrentName() == 'country_code') {
                                    Cust.Shopifycountrycode__c = parser.getText();
                                    system.debug('Shopifycountrycode__c:  '+Cust.Shopifycountrycode__c);
                                }
                            } 
                            else if(parser.getCurrentToken() == JSONToken.END_OBJECT) {continue;} 
                            else if (parser.getCurrentToken() == JSONToken.START_OBJECT) {continue;}
                        }
                    }
                }
            }
        }
        update Cust;
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        
        Integer offset = (pNumber - 1) * pSize;
        
        Integer totalRecords = [SELECT COUNT() FROM Account where Shopify_Shop_Url__c = :shopname];
        Integer recordEnd = pSize * pNumber;
        
        CustomerSingleSyncDataTableWrapper objDT =  new CustomerSingleSyncDataTableWrapper();  
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.accountList = [Select Id,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees, Phone from Account where Shopify_Shop_Url__c = :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
        return objDT;
    }
    
    // Get Salesforce Data related to shop
    @AuraEnabled
    public static AccountDataTableWrapper getAccountData(Integer pageNumber, Integer pageSize,String shopid) {
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids];
        String shopname = shopdetails.Name; 
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Account WHERE Choose_Customer__c = 'Salesforce' ];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        AccountDataTableWrapper objDT =  new AccountDataTableWrapper();
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.contactList = [Select Id, Name,BillingCity,BillingState, AnnualRevenue, Phone, Website, CreatedDate, LastModifiedDate FROM Account WHERE  Choose_Customer__c = 'Salesforce' ORDER BY Name LIMIT :pSize OFFSET :offset];
        return objDT;
    }
    
    // Get Shopify Data related to shop
    @AuraEnabled
    public static ShopifyDataTableWrapper getShopifyData(Integer pageNumber, Integer pageSize,String shopid) {
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids];
        String shopname = shopdetails.Name; 
        
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Account WHERE Shopify_Shop_Url__c = :shopname ];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        ShopifyDataTableWrapper objDT =  new ShopifyDataTableWrapper();
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.shopifyList = [Select Id,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,Shopify_Billing_State__c,ShopifyBillingCountry__c,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c,Industry,Ownership,AnnualRevenue,NumberOfEmployees, Phone from Account WHERE Shopify_Shop_Url__c = :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
        return objDT;
    }
    @AuraEnabled
    public static FilterDataTableWrapper getAllData(Integer pageNumber, Integer pageSize,String shopid) {
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name from Shopify_Configuration__c where id = :shopids];
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Account where Shopify_Shop_Url__c = :shopdetails.Name OR Choose_Customer__c = 'Salesforce'];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        FilterDataTableWrapper objDT =  new FilterDataTableWrapper();
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.allList = [Select Id,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,Shopify_Shop_Url__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,BillingCity,BillingState,BillingPostalCode,AnnualRevenue, Phone, Website, CreatedDate, LastModifiedDate,Shopify_Billing_State__c,ShopifyBillingCountry__c,Type,Rating,Choose_Customer__c,Industry,Ownership,NumberOfEmployees from Account where  Shopify_Shop_Url__c = :shopdetails.Name OR Choose_Customer__c = 'Salesforce' ORDER BY Name LIMIT :pSize OFFSET :offset];
        return objDT;
    }
    
    @AuraEnabled
    public static FilterDataTableWrapper getAllDoinitData(Integer pageNumber, Integer pageSize,String shopid) {
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        Shopify_Configuration__c shopdetails = [Select id,name from Shopify_Configuration__c where id = :shopid];
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Account where Shopify_Shop_Url__c = :shopdetails.Name];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        FilterDataTableWrapper objDT =  new FilterDataTableWrapper();
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.allList = [Select Id,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,Shopify_Shop_Url__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,BillingCity,BillingState,BillingPostalCode,AnnualRevenue, Phone, Website, CreatedDate, LastModifiedDate,Shopify_Billing_State__c,ShopifyBillingCountry__c,Type,Rating,Choose_Customer__c,Industry,Ownership,NumberOfEmployees from Account where  Shopify_Shop_Url__c = :shopdetails.Name ORDER BY Name LIMIT :pSize OFFSET :offset];
        
        List<String> Shopnames = new List<String>();
        List<Shopify_Configuration__c> shopdetail = [Select id,name from Shopify_Configuration__c];
        for(Shopify_Configuration__c st: shopdetail ){
            Shopnames.add(st.name);
            system.debug('value'+Shopnames);
        }
        objDT.Shopnames = Shopnames;
        return objDT;
    }
    
    @AuraEnabled
    public static productDeleteWrapper deleteRecords(String lstRecordId, Integer pageNumber, Integer pageSize,String shopid) {
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        Integer offset = (pNumber - 1) * pSize;
        productDeleteWrapper objDT =  new productDeleteWrapper();
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids];
        
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        Account lstDeleteRec = [Select Id,Name,Shopify_Customer_Id__c from Account where id =: lstRecordId];
        //Database.DeleteResult[] DR_Dels = Database.delete(lstDeleteRec, false);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopname+'/admin/api/2019-07/customers/'+ lstDeleteRec.Shopify_Customer_Id__c +'.json');
        request.setMethod('DELETE');
        //String username = '61aa8cff33084fb5eebfd721b7a6e3e5';
        // String password = '51f5bfdbd12e120d34fe3669a3ed1949';
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        system.debug('64code '+ authorizationHeader);
        String authnull = 'null';
        request.setHeader('Authorization', authorizationHeader);
        HttpResponse response = http.send(request);
        System.debug('response'+response.getBody());
        if (response.getStatusCode() == 200) {
            system.debug('Customer Deleted');
            delete lstDeleteRec;
            objDT.message = 'success';
        }
        else{
            objDT.message =response.getBody();
        }
        
        Integer totalRecords = [SELECT COUNT() FROM Account where Shopify_Shop_Url__c = :shopname];
        Integer recordEnd = pSize * pNumber;
        
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.deleteList = [Select Id,Shopify_Shop_Url__c,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c from Account where Shopify_Shop_Url__c = :shopname ORDER BY Name LIMIT :pSize OFFSET :offset];
        return objDT;
    }
    
    
    public class productDeleteWrapper {
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
        public List<Account> deleteList {get;set;}
    }
    
    public class AccountDataTableWrapper {
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
        public List<Account> contactList {get;set;}
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
        public List<Account> shopifyList {get;set;}
    }
    
    public class FilterDataTableWrapper {
        @AuraEnabled
        public Integer pageSize {get;set;}
        @AuraEnabled
        public Integer pageNumber {get;set;}
        @AuraEnabled
        public List<String> Shopnames {get;set;}
        @AuraEnabled
        public Integer totalRecords {get;set;}
        @AuraEnabled
        public Integer recordStart {get;set;}
        @AuraEnabled
        public Integer recordEnd {get;set;}
        @AuraEnabled
        public List<Account> allList {get;set;}
    }
    
    public class CustomerDataTableWrapper {
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
        public List<Account> accountList {get;set;}
        @AuraEnabled
        public string message{get;set;}
    }
    
    
    public class CustomerSingleSyncDataTableWrapper {
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
        public List<Account> accountList {get;set;}
    }
    
    @AuraEnabled
    public static String exportToShopify(String shopid,String Accountid) 
    {        
        
        String message ;
        
        system.debug('Productid'+Accountid);
        system.debug('shopid'+shopid);
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        system.debug('shopid'+shopids);
        Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c from Shopify_Configuration__c where id = :shopids limit 1];
        system.debug('shopdetails '+shopdetails);
        String Token = shopdetails.Shopify_Access_Token__c ;
        String Password = shopdetails.Password__c;
        String shopname = shopdetails.Name; 
        system.debug('shopdetails.Name '+shopname);
        
        Account accounttoinsert = [Select Id, ShopifyLastName__c, Shopify_Email__c, Phone, ShopifyPhone__c, Shopify_Verified_Email__c, BillingStreet, 
                                   BillingCity, Shopifyprovincecode__c, ShopifyZipCode__c, Shopify_Customer_FirstName__c, ShopifyBillingCountry__c,Name ,Type,Rating ,Choose_Customer__c
                                   from Account where id = :Accountid];
        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(shopname+'/admin/api/2019-10/customers.json');
        request.setMethod('POST');
        
       /* Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization',authorizationHeader);
        request.setHeader('Content-Type','application/json');*/
        
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        request.setHeader('Authorization', authorizationHeader);
        request.setHeader('Content-Type', 'application/json');
        
        String email = accounttoinsert.Shopify_Email__c;
        String first_name = accounttoinsert.Name;
        String last_name = accounttoinsert.ShopifyLastName__c;
        String cusPhone = accounttoinsert.Phone;
        String CusVerifiedEmail = accounttoinsert.Shopify_Verified_Email__c;
        String cusAdd1 = accounttoinsert.BillingStreet;
        String cusCity = accounttoinsert.BillingCity;
        String cusProvince = accounttoinsert.Shopifyprovincecode__c;
        String cusAddrPhone = accounttoinsert.ShopifyPhone__c;
        String cusZip = accounttoinsert.ShopifyZipCode__c;
        String cusFName = accounttoinsert.Shopify_Customer_FirstName__c;
        String cusLName = accounttoinsert.ShopifyLastName__c;
        String cusCountry = accounttoinsert.ShopifyBillingCountry__c;
        
        
        Postocustomer jsonObj = new Postocustomer(email,first_name, last_name, cusPhone, CusVerifiedEmail, cusAdd1, cusCity, 
                                                  cusProvince, cusAddrPhone, cusZip, cusFName, cusLName, cusCountry);
        system.debug('Till Here 1');
        system.debug(jsonObj);
        
        String jsonBody = json.serialize(jsonObj); 
        system.debug('Value '+jsonBody);
        if (jsonBody != null){
            request.setBody(jsonBody);
        }
        HttpResponse response = http.send(request);
        system.debug(response.getStatus());
        if (response.getStatusCode() == 200) {
            message = 'success';
        }
        else{
            message =response.getBody();
        }
        return message;
    }
    
    @AuraEnabled
    public static CustomerSearchWrapper fetchSearchCustomer(String searchKeyWord,String shopid,Integer pageNumber, Integer pageSize,String AccountType) {
        CustomerSearchWrapper objDT =  new CustomerSearchWrapper();  
        
        String searchKey ='%' + searchKeyWord + '%';
        system.debug('VAlue : '+AccountType);
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name from Shopify_Configuration__c where id = :shopids limit 1];
        String shopname = shopdetails.Name; 
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        if(AccountType == 'All'){
            List<Account> prod = [Select Id,Shopify_Shop_Url__c,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c, Phone from Account where (Choose_Customer__c = 'Salesforce' or Shopify_Shop_Url__c like :shopname ) and Name LIKE: searchKey  ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Account where (Choose_Customer__c = 'Salesforce' or Shopify_Shop_Url__c like :shopname ) and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.accountList = prod;
        }
        else if(AccountType == 'Salesforce'){
            List<Account> prod = [Select Id,Shopify_Shop_Url__c,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c, Phone from Account where Choose_Customer__c = :AccountType and Name LIKE: searchKey  ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Account Where  Choose_Customer__c = :AccountType and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.accountList = prod;
        }
        else if(AccountType == 'Shopify'){
            
            List<Account> prod = [Select Id,Shopify_Shop_Url__c,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c, Phone from Account where Shopify_Shop_Url__c = :shopname and Choose_Customer__c = 'Shopify'and Name LIKE: searchKey  ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Account Where Shopify_Shop_Url__c = :shopname and Choose_Customer__c = 'Shopify'and Name LIKE: searchKey ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.recordStart = offset + 1;
            objDT.pageNumber = pNumber;
            objDT.accountList = prod;
        }			
        return objDT;
    }
    public class CustomerSearchWrapper {
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
        public List<Account> accountList {get;set;}
    } 
    @AuraEnabled  
    public static CustomertypeWrapper ListOfCustomerTypeHelper(String AccountType,Integer pageNumber, Integer pageSize,String shopid) {
        CustomertypeWrapper objDT =  new CustomertypeWrapper();  
        
        system.debug('VAlue : '+AccountType);
        id selectedshopid = [Select id,Selected_App__c from App_Configuration__c].Selected_App__c;
        id shopids = [Select id,name from Shopify_Configuration__c where id = : selectedshopid].id;
        Shopify_Configuration__c shopdetails = [Select id,name from Shopify_Configuration__c where id = :shopids limit 1];
        String shopname = shopdetails.Name; 
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        if(AccountType == 'All'){
            List<Account> prod = [Select Id,Shopify_Shop_Url__c,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c, Phone from Account where Choose_Customer__c = 'Salesforce' or Shopify_Shop_Url__c like :shopname  ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Account where Choose_Customer__c = 'Salesforce' or Shopify_Shop_Url__c like :shopname ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.accountList = prod;
        }
        else if(AccountType == 'Salesforce'){
            List<Account> prod = [Select Id,Shopify_Shop_Url__c,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c, Phone from Account where Choose_Customer__c = 'Salesforce' ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Account Where  Choose_Customer__c = 'Salesforce'];
            Integer recordEnd = pSize * pNumber;
            objDT.recordStart = offset + 1;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.pageNumber = pNumber;
            objDT.accountList = prod;
        }
        else if(AccountType == 'Shopify'){
            
            List<Account> prod = [Select Id,Shopify_Shop_Url__c,CreatedDate,Name,ShopifyTotalSpent__c,ShopifyUpdatedDate__c,ShopifyCreatedDate__c,ShopifyPhone__c,Shopifylastordername__c,ShopifyOrderCount__c,ShopifyZipCode__c,Shopifyprovincecode__c,Shopifycountrycode__c,ShopifyLastName__c,BillingState,BillingCountry,Shopify_Customer_Id__c, Shopify_Email__c,Type,Rating,Choose_Customer__c, Phone from Account where Shopify_Shop_Url__c = :shopname and Choose_Customer__c = 'Shopify' ORDER BY Name LIMIT :pSize OFFSET :offset];
            Integer totalRecords = [SELECT COUNT() FROM Account Where Shopify_Shop_Url__c = :shopname and Choose_Customer__c = 'Shopify' ];
            Integer recordEnd = pSize * pNumber;
            objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
            objDT.totalRecords = totalRecords;
            objDT.pageSize = pSize;
            objDT.recordStart = offset + 1;
            objDT.pageNumber = pNumber;
            objDT.accountList = prod;
        }			
        return objDT;
    }
    public class CustomertypeWrapper {
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
        public List<Account> accountList {get;set;}
    } 
}