public class Configuration {
    
    @AuraEnabled
    public static String getSelectedApp(){
       /* List<App_Configuration__c> apconfig = [SELECT TechnologyMind__Selected_App__c  FROM TechnologyMind__App_Configuration__c];
        system.debug('apconfig :'+apconfig[0]);
        if(!apconfig.isEmpty()){
            return apconfig[0].TechnologyMind__Selected_App__c;
        }else{
            return null;
        } */
        return null;
    }
      
    @AuraEnabled
    public static  ProductDataTableWrapper Adminconfig(Integer pageNumber,Integer pageSize){
        system.debug('pageNumber Value : '+pageNumber);
        system.debug('pageSize Value : '+pageSize);
        system.debug('pagesize');
        
        ProductDataTableWrapper config = new ProductDataTableWrapper();
        /// start product code
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Shopify_Configuration__c ];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        List<Shopify_Configuration__c> configlist = [Select Id,Name,Default_Shop__c,Shopify_Access_Token__c,Salesforce_Site_URL__c,Password__c From Shopify_Configuration__c ORDER BY Name LIMIT :pSize OFFSET :offset];
        List<String> allshopid = new list<string>();
        for(Shopify_Configuration__c shopids : configlist){
            allshopid.add(shopids.ID);
        }
   
        config.AllShopID = allshopid;
        config.config = configlist;
        config.pageSize = pSize;
        config.pageNumber = pNumber;
        config.recordStart = offset + 1;
        config.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        config.totalRecords = totalRecords;   
        /// product code end
        
        
        List < String > allOpts = new list < String > ();
        List < String > stringOpts = new list < String > ();
        List < String > numberOpts = new list < String > ();
        List < String > PhoneOpts = new list < String > ();
        List < String > EmailOpts = new list < String > ();
        SObjectType objToken = Schema.getGlobalDescribe().get('Account');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        Set<String> fieldSet = fields.keySet();
        system.debug('keys'+fieldSet);
        for(String s:fieldSet)
        {
            SObjectField fieldToken = fields.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            system.debug(fieldToken+' '+selectedField.getType());
            allOpts.add(selectedField.getName());
            if(string.valueof(selectedField.getType())!='INTEGER' &&string.valueof(selectedField.getType())!='DOUBLE' && string.valueof(selectedField.getType())!='CURRENCY' && string.valueof(selectedField.getType())!='DATETIME' &&string.valueof(selectedField.getType())!='DATE' && string.valueof(selectedField.getType())!='PICKLIST' && string.valueof(selectedField.getType())!='EMAIL' &&string.valueof(selectedField.getType())!='PHONE')
            { 
                system.debug('selectedField.getType()'+selectedField.getType()+' '+selectedField.getName());
                stringOpts.add(selectedField.getName());
                //   system.debug('Phone type'+selectedField.getName()+selectedField.getType());
                //  system.debug('not numbers'+selectedField.getName()+selectedField.getType());
                //  if(string.valueof(selectedField.getType())=='PHONE' && selectedField.getName()!=null){
                //      PhoneOpts.add(selectedField.getName());
                //   system.debug('Phone type'+selectedField.getName()+selectedField.getType());
                // }
            }
            else if(string.valueof(selectedField.getType())=='PHONE')
            {
                PhoneOpts.add(selectedField.getName());
            }
            else if(string.valueof(selectedField.getType())=='EMAIL')
            {
                EmailOpts.add(selectedField.getName());
            }
            else 
            {
                numberOpts.add(selectedField.getName());
                //  system.debug('numbers'+selectedField.getName()+selectedField.getType());
            } 
            
            //  if(string.valueOf(selectedField.getType())=='INTEGER'
        }
        list<string> customfields = new list<string>();
        list<string> customStringfields = new list<string>();
        list<string> customNumberfields = new list<string>();
        list<string> customPhonefields = new list<string>();
        list<string> customEmailfields = new list<string>();
        
        for(string flds : allOpts){
            if(flds.contains('__c')){
                customfields.add(flds);
            }
        }
        
        for(string flds : stringOpts){
            if(flds.contains('__c')){
                customStringfields.add(flds);
            }
        }
        
        for(string flds : numberOpts){
            if(flds.contains('__c')){
                customNumberfields.add(flds);
            }
        }
        for(string flds : PhoneOpts){
            if(flds.contains('__c')){
                customPhonefields.add(flds);
            }
        }
        for(string flds : EmailOpts){
            if(flds.contains('__c')){
                customEmailfields.add(flds);
            }
        }
        
        customfields.sort();
        customNumberfields.sort();
        customStringfields.sort();
        customPhonefields.sort();
        customEmailfields.sort();
        config.Shopnames = customfields;   
        config.ShopStringFields = customStringFields;
        config.ShopNumberFields = customNumberFields;
        config.ShopEmailFields = customEmailFields;
        config.ShopPhoneFields = customPhoneFields;
        System.debug('ValuePhoneOpts : '+PhoneOpts);
        config.ShopPhoneFields = PhoneOpts;
        
        List < String > Products = new list < String > ();
        List < String > productsStringFields = new list < String > ();
        List < String > productsNumberFields = new list < String > ();
        List < String > productsEmailFields = new list < String > ();
        List < String > productsPhoneFields = new list < String > ();
        
        SObjectType objTokenProduct = Schema.getGlobalDescribe().get('Product2');
        DescribeSObjectResult objDefProduct = objTokenProduct.getDescribe();
        Map<String, SObjectField> fieldsProducts = objDefProduct.fields.getMap(); 
        Set<String> fieldSetProducts = fieldsProducts.keySet();
        for(String s:fieldSetProducts)
        {
            SObjectField fieldToken = fieldsProducts.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            Products.add(selectedField.getName());
            if(string.valueof(selectedField.getType())!='INTEGER' &&string.valueof(selectedField.getType())!='DOUBLE' && string.valueof(selectedField.getType())!='CURRENCY' && string.valueof(selectedField.getType())!='DATETIME' &&string.valueof(selectedField.getType())!='DATE' && string.valueof(selectedField.getType())!='PICKLIST' && string.valueof(selectedField.getType())!='EMAIL' &&string.valueof(selectedField.getType())!='PHONE')
            { 
                
                productsStringFields.add(selectedField.getName());
                
            }
            else if(string.valueof(selectedField.getType())=='PHONE')
            {
                productsPhoneFields.add(selectedField.getName());
            }
            else if(string.valueof(selectedField.getType())=='EMAIL')
            {
                productsEmailFields.add(selectedField.getName());
            }
            else 
            {
                productsNumberFields.add(selectedField.getName());
                
            } 
        }
        system.debug('Products ---->' + Products);
        list<string> Productscustomfields = new list<string>();
        list<string> productsCustomStringFields = new list<string>();
        list<string> productsCustomNumberFields = new list<string>();
        list<string> productsCustomEmailFields = new list<string>();
        list<string> productsCustomPhoneFields = new list<string>();
        for(string flds : Products){
            if(flds.contains('__c')){
                Productscustomfields.add(flds);
            }
        }
        for(string flds : productsStringFields){
            if(flds.contains('__c')){
                productsCustomStringFields.add(flds);
            }
        }
        for(string flds : productsNumberFields){
            if(flds.contains('__c')){
                productsCustomNumberFields.add(flds);
            }
        }
        for(string flds : productsEmailFields){
            if(flds.contains('__c')){
                productsCustomEmailFields.add(flds);
            }
        }
        for(string flds : productsPhoneFields){
            if(flds.contains('__c')){
                productsCustomPhoneFields.add(flds);
            }
        }
        Productscustomfields.sort();
        productscustomnumberfields.sort();
        productsCustomEmailFields.sort();
        productsCustomStringFields.sort();
        productsCustomPhoneFields.sort();
        
        config.Product = Productscustomfields;
        config.ProductStringFields = productsCustomStringFields;
        config.ProductNumberFields = productsCustomNumberFields;
        config.ProductEmailFields = productsCustomEmailFields;
        config.ProductPhoneFields = productsCustomPhoneFields;
        
        List < String > Orders = new list < String > ();
        List < String > OrdersStringFields = new list < String > ();
        List < String > OrdersNumberFields = new list < String > ();
        List < String > OrdersPhoneFields = new list < String > ();
        List < String > OrdersEmailFields = new list < String > ();
        SObjectType objTokenOrders = Schema.getGlobalDescribe().get('TechnologyMind__ShopifyOrders__c');
        DescribeSObjectResult objDefOrders = objTokenOrders.getDescribe();
        Map<String, SObjectField> fieldsOrders = objDefOrders.fields.getMap(); 
        Set<String> fieldSetOrders = fieldsOrders.keySet();
        string fieldvalue = 'Name';
        string value = 'email';
        for(String s:fieldSetOrders)
        {
            SObjectField fieldToken = fieldsOrders.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            if(fieldvalue == selectedField.getName()) {
                value = 'Name';
            }
            Orders.add(selectedField.getName());
            /*     if(string.valueof(selectedField.getType())!='INTEGER' &&string.valueof(selectedField.getType())!='DOUBLE' && string.valueof(selectedField.getType())!='CURRENCY' && string.valueof(selectedField.getType())!='DATE'&& string.valueof(selectedField.getType())!='DATETIME')
ordersStringFields.add(selectedField.getName());
else
ordersNumberFields.add(selectedField.getName()); */
            if(string.valueof(selectedField.getType())!='INTEGER' &&string.valueof(selectedField.getType())!='DOUBLE' && string.valueof(selectedField.getType())!='CURRENCY' && string.valueof(selectedField.getType())!='DATETIME' &&string.valueof(selectedField.getType())!='DATE' && string.valueof(selectedField.getType())!='PICKLIST' && string.valueof(selectedField.getType())!='EMAIL' &&string.valueof(selectedField.getType())!='PHONE')
            { 
                system.debug('selectedField.getType()'+selectedField.getType()+' '+selectedField.getName());
                OrdersStringFields.add(selectedField.getName());
            }
            else if(string.valueof(selectedField.getType())=='PHONE')
            {
                OrdersPhoneFields.add(selectedField.getName());
            }
            else if(string.valueof(selectedField.getType())=='EMAIL')
            {
                OrdersEmailFields.add(selectedField.getName());
            }
            else 
            {
                OrdersNumberFields.add(selectedField.getName());
                //  system.debug('numbers'+selectedField.getName()+selectedField.getType());
            } 
        } 
        system.debug('Orders ---->' + Orders);
        list<string> Orderscustomfields = new list<string>();
        list<string> OrderscustomStringfields = new list<string>();
        list<string> OrderscustomNumberfields = new list<string>();
        list<string> OrderscustomPhonefields = new list<string>();
        list<string> OrderscustomEmailfields = new list<string>();
        for(string flds : Orders){
            if(flds.contains('__c')){
                Orderscustomfields.add(flds);
            }
        }
        for(string flds : ordersStringFields){
            if(flds.contains('__c')){
                OrderscustomStringfields.add(flds);
            }
        }
        for(string flds : ordersNumberFields){
            if(flds.contains('__c')){
                OrderscustomNumberfields.add(flds);
            }
        }
        for(string flds : OrdersPhoneFields){
            if(flds.contains('__c')){
                OrderscustomPhonefields.add(flds);
            }
        }
        for(string flds : OrdersEmailFields){
            if(flds.contains('__c')){
                OrderscustomEmailfields.add(flds);
            }
        }
        Orderscustomfields.sort();
        OrderscustomNumberfields.sort();
        OrderscustomStringfields.sort();
        OrderscustomEmailfields.sort();
        OrderscustomPhonefields.sort();
        config.Order = Orderscustomfields;
        config.orderStringFields=OrderscustomStringfields;
        config.orderNumberFields =OrderscustomNumberfields;
        config.orderPhoneFields =OrderscustomPhonefields;
        config.orderEmailFields =OrderscustomEmailfields;
        
        
        return config;
    }
    
    @AuraEnabled
    public static List < Shopify_Configuration__c > fetchSearchshop(String searchKeyWord) {
        String searchKey ='%' + searchKeyWord + '%';
        List < Shopify_Configuration__c > returnList = new List < Shopify_Configuration__c > ();
        List < Shopify_Configuration__c > lstOfProduct = [Select Id,Name,Default_Shop__c,Shopify_Access_Token__c,Salesforce_Site_URL__c,Password__c From Shopify_Configuration__c where Name LIKE: searchKey ];
        for (Shopify_Configuration__c pro: lstOfProduct) {
            returnList.add(pro);
        }
        return returnList;
    }
    
    // Search Shop by getting shop name
    @AuraEnabled
    public static ProductDataTableWrapper fetchSearchshophelper(String searchKeyWord,Integer pageNumber, Integer pageSize) {
        ProductDataTableWrapper objDT =  new ProductDataTableWrapper();  
        String searchKey ='%' + searchKeyWord + '%';
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        List<Shopify_Configuration__c> prod = [Select Id,Name,Default_Shop__c,Shopify_Access_Token__c,Salesforce_Site_URL__c,Password__c From Shopify_Configuration__c where Name LIKE: searchKey  ORDER BY Name LIMIT :pSize OFFSET :offset];
        Integer totalRecords = [SELECT COUNT() FROM Shopify_Configuration__c where Name LIKE: searchKey ];
        Integer recordEnd = pSize * pNumber;
        objDT.recordStart = offset + 1;
        objDT.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        objDT.totalRecords = totalRecords;
        objDT.pageSize = pSize;
        objDT.pageNumber = pNumber;
        objDT.config = prod;
        return objDT;
    }
    
    public class ProductDataTableWrapper {
        
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
        public List<Shopify_Configuration__c> config {get;set;}
        @AuraEnabled
        public List<String> Shopnames {get;set;}  
        @AuraEnabled
        public List<String> AllShopID {get;set;} 
        @AuraEnabled
        public List<String> ShopStringFields {get;set;}  
        @AuraEnabled
        public List<String> ShopNumberFields {get;set;} 
        @AuraEnabled
        public List<String> ShopPhoneFields {get;set;}
        @AuraEnabled
        public List<String> ShopEmailFields {get;set;}
        @AuraEnabled
        public List<String> Product {get;set;}
        @AuraEnabled
        public List<String> ProductStringFields {get;set;}
        @AuraEnabled
        public List<String> ProductNumberFields {get;set;}
        @AuraEnabled
        public List<String> ProductEmailFields {get;set;}
        @AuraEnabled
        public List<String> ProductPhoneFields {get;set;}
        @AuraEnabled
        public String message {get;set;}
        @AuraEnabled
        public String NewShopName {get;set;}
        @AuraEnabled
        public String ShopToken {get;set;}
        @AuraEnabled
        public String ShopPasswords {get;set;}
        @AuraEnabled
        public List<String> Order {get;set;}
        @AuraEnabled
        public List<String> orderStringFields {get;set;}
        @AuraEnabled
        public List<String> orderNumberFields {get;set;}
        @AuraEnabled
        public List<String> orderEmailFields {get;set;}
        @AuraEnabled
        public List<String> orderPhoneFields {get;set;}
        @AuraEnabled
        public Map<String, String> mapfields {get;set;}
    }
    
    @AuraEnabled
    public static ProductDataTableWrapper checkShopDetials(String Token,String Passwords,String Url) {
        ProductDataTableWrapper ShopWrapper = new ProductDataTableWrapper();
        System.debug('Token'+Token);
        System.debug('String'+Passwords);
        System.debug('Url'+Url);
        string pass ;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        try {
            request.setEndpoint(Url+'admin/api/2019-10/products.json');
        } catch(DmlException e) {
            ShopWrapper.message ='Set the endpoint : ' + e.getMessage();
        }
        
        request.setMethod('GET');
        String username = Token;
        String password = Passwords;
        Blob headerValue = Blob.valueOf(Token + ':' + Password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        system.debug('64code '+ authorizationHeader);
        system.debug('req=='+request);
        String authnull = 'null';
        request.setHeader('Authorization', authorizationHeader);
        try {
            
                HttpResponse response = http.send(request);
                System.debug('response'+response.getBody());
                if (response.getStatusCode() == 200) {
                    //
                    list<Shopify_Configuration__c> newshopornot = [select name from Shopify_Configuration__c where name like :Url];
                    if(newshopornot.size()> 0){
                        system.debug('value found '+ newshopornot.size());
                        ShopWrapper.message = 'errors : Shop is already added';
                    }else{
                        ShopWrapper.message = 'success';
                    }
                    ShopWrapper.NewShopName = Url ;
                    ShopWrapper.ShopToken =Token ;
                    ShopWrapper.ShopPasswords =Passwords ;
                }
                else{
                    ShopWrapper.message =response.getBody();
                }
            
        } catch(DmlException e) {
            ShopWrapper.message ='Set the endpoint : ' + e.getMessage();
        }
        return ShopWrapper;
        
    }
    @AuraEnabled
    public static  ProductDataTableWrapper AccountsFields(){
        ProductDataTableWrapper config = new ProductDataTableWrapper();
        List<Shopify_Configuration__c> configlist = [Select Id,Name,Default_Shop__c,Shopify_Access_Token__c,Salesforce_Site_URL__c,Password__c From Shopify_Configuration__c];
        config.config = configlist;
        
        List < String > allOpts = new list < String > ();
        SObjectType objToken = Schema.getGlobalDescribe().get('Account');
        DescribeSObjectResult objDef = objToken.getDescribe();
        Map<String, SObjectField> fields = objDef.fields.getMap(); 
        Set<String> fieldSet = fields.keySet();
        for(String s:fieldSet)
        {
            SObjectField fieldToken = fields.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            allOpts.add(selectedField.getName());
        }
        system.debug('allOpts ---->' + allOpts);
        allOpts.sort();
        config.Shopnames = allOpts;
        
        return config;
    }
    @AuraEnabled
    public static  void AccountsFields(String SalesforceField, String ShopifyField){
        List < string > ShopifyFields = new list < string > {'Name','Phone','Email','Address'};  
            ShopifyOrders__c neworder = new ShopifyOrders__c();
        SObjectType objTokenOrders = Schema.getGlobalDescribe().get('ShopifyOrders__c');
        DescribeSObjectResult objDefOrders = objTokenOrders.getDescribe();
        Map<String, SObjectField> fieldsOrders = objDefOrders.fields.getMap(); 
        Set<String> fieldSetOrders = fieldsOrders.keySet();
        for(String s:fieldSetOrders)
        {
            SObjectField fieldToken = fieldsOrders.get(s);
            DescribeFieldResult selectedField = fieldToken.getDescribe();
            if(SalesforceField == selectedField.getName()) {
                /*    
                for(list<string> comparefields : ShopifyFields ){
                if(ShopifyField === ShopifyFields){
                JSONParser parser = JSON.createParser(response.getBody());
                // Parsing of string      product_type tags /Variants price sku weight weight_unit created_at
                while(parser.nextToken()!= null) { 
                if(parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                parser.nextValue();
                //here the neworder field is map with shopify field 
                if(parser.getCurrentName() == ShopifyField) {   // here find the field from json response
                neworder.SalesforceField = parser.getText(); // here insert the value in selected salesforce field 
                system.debug('prod.Name '+prod.Name);
                }
                }	
                }
                }
                }
				*/
                system.debug('SalesforceField : '+selectedField.getName());
            }
        }
    }
    @AuraEnabled
    public static string AccountsMappingFields(list<String> SalesforceField, list<String> ShopifyField, string shopId)
    {   
        // string field1 = SalesforceField;
        //string field2 = ShopifyField;
        system.debug('field1 :'+ SalesforceField); 
        system.debug('field2 :'+ ShopifyField);    
        system.debug('SalesforceField :'+ shopId);    
        
        
        //  List<SopifySalesforceFieldMapping> myMapping = new List<SopifySalesforceFieldMapping>(String ShopifyField, String SalesforceField);
        
        //upsert 	myshop;     {"Country_Code":"BillingAddress"},{"Created_at":"BillingAddress"},{"Customer_id":"Description"}]
        string field1 = 'done';
        return field1;
    }    
    
    
    /* @AuraEnabled
public static string CheckMappingFields(List<object> Productmapping,string shopId)
{   
string field1 = 'dones'; 
Shopify_Configuration__c myshop = [select id,Customer_Mapping__c,Order_Mapping__c,Product_Mapping__c from Shopify_Configuration__c where id = :shopId limit 1];
// public static string CheckMappingFields(String AccountSalesforceField,List<object> Productmapping,string Ordermapping,string shopId)
//  List<SopifySalesforceFieldMapping> myMapping = new List<SopifySalesforceFieldMapping>(String ShopifyField, String SalesforceField);
//   myshop.Customer_Mapping__c = AccountSalesforceField;
List<Object> reqs = (List<Object>) Productmapping;
List<string> lsstr= new List<string> ();

for(Object a: reqs){
lsstr.add(String.valueOf(a));
system.debug('lsstr'+lsstr);
}

String str = JSON.serialize(lsstr);
string str2 = JSON.serialize(Productmapping);
system.debug('String value of product'+str);
system.debug('Productmapping value '+str2);
myshop.Product_Mapping__c = str2;
//   myshop.Order_Mapping__c = Ordermapping;

upsert 	myshop; 
//SObject s = [SELECT AccountNumber FROM Account LIMIT 1];
//Object o = s.get('AccountNumber');
//s.put('AccountNumber', 'abc');
// system.debug('Values'+SalesforceField);
// List<Object> fieldList = (List<Object>)JSON.deserializeUntyped(SalesforceField);
// for(Object fld : fieldList){    
//    Map<String,Object> data = (Map<String,Object>)fld;

//Magic!
//   system.debug(data.keySet());
// }

return field1;
}*/
    
    
    @AuraEnabled
    public static string CheckMappingFields(String Customersmapping,String Productmapping,String Ordermapping,string shopId)
    {   
        string field1 = 'dones'; 
        Shopify_Configuration__c myshop = [select id,Customer_Mapping__c,Order_Mapping__c,Product_Mapping__c from Shopify_Configuration__c where id = :shopId limit 1];
        
        // List<Object> reqs = (List<Object>) Productmapping;
        // List<string> lsstr= new List<string> ();
        
        // for(Object a: reqs){
        ///     lsstr.add(String.valueOf(a));
        //     system.debug('lsstr'+lsstr);
        // }
        
        //String str = JSON.serialize(lsstr);
        // string str2 = JSON.serialize(Productmapping);
        // system.debug('String value of product'+str);
        // system.debug('Productmapping value '+str2);
        System.debug('Productmapping$$$' + Productmapping);
        myshop.Product_Mapping__c = Productmapping;
        myshop.Order_Mapping__c = Ordermapping;
        myshop.Customer_Mapping__c = Customersmapping;
        upsert 	myshop; 
        
        return field1;
    }
    @AuraEnabled
    public static configureshopdetails Shopify_fields(String shopid,integer msg) 
    {  
        //new method start here
        list<Shopify_Configuration__c> newshop = new list<Shopify_Configuration__c>();
        Delete[SELECT Selected_App__c FROM App_Configuration__c];
         for(Shopify_Configuration__c shop : [select id,Default_Shop__c from Shopify_Configuration__c]){
            Shopify_Configuration__c shopy = new Shopify_Configuration__c();
            if(shop.id == shopid){
                shopy.id = shopid;
                shopy.Default_Shop__c = true;
            }
            else{
                shopy.id = shop.id;
                shopy.Default_Shop__c = false;
            }
            newshop.add(shopy); 
        }
        App_Configuration__c apconfig = new App_Configuration__c();
        apconfig.Selected_App__c = shopid;
        try{
            system.debug('Sop Id New '+apconfig);
            insert apconfig; 
            update newshop;
            
        }catch(DMLException e){
            throw new AuraHandledException(e.getMessage());
        }
        
        //end here
        system.debug('Value '+shopid+'Msg : '+msg);
        configureshopdetails details = new configureshopdetails();
        TechnologyMind__Shopify_Configuration__c shopdetails = [Select id,name,Shopify_Access_Token__c,Password__c,Customer_Mapping__c,Product_Mapping__c,Order_Mapping__c from Shopify_Configuration__c where id = :shopid limit 1];
        //Customer Fields
        string Customerfields ;
        Customerfields = shopdetails.TechnologyMind__Customer_Mapping__c.unescapeHtml4();
        List<Object> objList = (List<Object>)  JSON.deserializeUntyped(Customerfields);
        map<string,string >newlist = new map<string,string>();
        Map<String, Object> valuesMap = new Map<String, Object>();
        
        for(Object obj : (List<Object>)JSON.deserializeUntyped(Customerfields)){
            //convert values to map
            Map<String, Object> data = (Map<String, Object>)obj;
            valuesMap.putAll(data );
        }
        system.debug('CustomerValue : '+valuesMap);
        
        for (String id : valuesMap.keySet())
        {
            newlist.put(id,String.valueOf(valuesMap.get(id))); 
        }
        details.Customer_Mapping =newlist;
        //Product Mapping 
        string Productfields ;
        Productfields = shopdetails.TechnologyMind__Product_Mapping__c.unescapeHtml4();
        map<string,string >Productfield = new map<string,string>();
        Map<String, Object> ProductfieldvaluesMap = new Map<String, Object>();
        
        for(Object obj : (List<Object>)JSON.deserializeUntyped(Productfields)){
            //convert values to map
            Map<String, Object> data = (Map<String, Object>)obj;
            ProductfieldvaluesMap.putAll(data );
        }
        system.debug('ProductValue : '+ProductfieldvaluesMap);
        
        for (String id : ProductfieldvaluesMap.keySet())
        {
            Productfield.put(id,String.valueOf(ProductfieldvaluesMap.get(id))); 
        }
        details.Product_Mapping =Productfield;
        //Order_Mapping
        string Orderfields ;
        Orderfields = shopdetails.TechnologyMind__Order_Mapping__c.unescapeHtml4();
        map<string,string >Orderfield = new map<string,string>();
        Map<String, Object> OrderfieldvaluesMap = new Map<String, Object>();
        
        for(Object obj : (List<Object>)JSON.deserializeUntyped(Orderfields)){
            //convert values to map
            Map<String, Object> data = (Map<String, Object>)obj;
            OrderfieldvaluesMap.putAll(data );
        }
        system.debug('OrderValue : '+OrderfieldvaluesMap);
        
        for (String id : OrderfieldvaluesMap.keySet())
        {
            Orderfield.put(id,String.valueOf(OrderfieldvaluesMap.get(id))); 
        }
        details.Order_Mapping =Orderfield;
        
        return details;
    }
    public class configureshopdetails {
        @AuraEnabled
        public Map<String, String> Customer_Mapping {get;set;}
        @AuraEnabled
        public Map<String, String> Product_Mapping {get;set;}
        @AuraEnabled
        public Map<String, String> Order_Mapping {get;set;}
        
    }
    
    // save App 
    @AuraEnabled
    public static ShopSaveFunctionwrapper ShopSaveFunction(String Customersmapping,String Productmapping,String Ordermapping,String NewShopName,string ShopToken,string ShopPasswords,Integer pageNumber,Integer pageSize) 
    {  
        ShopSaveFunctionwrapper obj = new ShopSaveFunctionwrapper();
        system.debug('Customersmapping '+Customersmapping+'Productmapping : '+Productmapping);
        system.debug('NewShopName '+NewShopName+'ShopToken : '+ShopToken);
        Shopify_Configuration__c newshop = new Shopify_Configuration__c();
        newshop.Name = NewShopName;
        newshop.Password__c = ShopPasswords;
        newshop.Shopify_Access_Token__c = ShopToken;
        newshop.Order_Mapping__c = Ordermapping;
        newshop.Customer_Mapping__c =Customersmapping ;
        newshop.Product_Mapping__c = Productmapping;
        insert newshop;
        obj.msg ='created';
        Integer pSize = (Integer)pageSize;
        Integer pNumber = (Integer)pageNumber;
        //Offset for SOQL
        Integer offset = (pNumber - 1) * pSize;
        //Total Records
        Integer totalRecords = [SELECT COUNT() FROM Shopify_Configuration__c ];
        Integer recordEnd = pSize * pNumber;
        //Instance of Contact DataTable Wrapper Class
        List<Shopify_Configuration__c> configlist = [Select Id,Name,Default_Shop__c,Shopify_Access_Token__c,Salesforce_Site_URL__c,Password__c From Shopify_Configuration__c ORDER BY Name  LIMIT :pSize OFFSET :offset];
        obj.shoplist = configlist;
        obj.pageSize = pSize;
        obj.pageNumber = pNumber;
        obj.recordStart = offset + 1;
        obj.recordEnd = totalRecords >= recordEnd ? recordEnd : totalRecords;
        obj.totalRecords = totalRecords; 
        return obj;
    }
    public class ShopSaveFunctionwrapper{
        @AuraEnabled
        public String msg {get;set;}
        @AuraEnabled
        public  List<Shopify_Configuration__c> shoplist {get;set;}
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
        
    }
        @AuraEnabled
    public static List<Shopify_Configuration__c> getshopData(){
        return [select Id,Name from Shopify_Configuration__c];
        
}
    
    // delete Shop
      @AuraEnabled
    public static List<Shopify_Configuration__c> deleteAccount(String id)
    {
		//App_Configuration__c selectedshop = [SELECT id,Selected_App__c FROM App_Configuration__c where Selected_App__c =: id];
        Shopify_Configuration__c delshop=[Select Id from Shopify_Configuration__c where id=:id];
        delete delshop;
       // delete selectedshop;
        return getshopData(); 
    }
}