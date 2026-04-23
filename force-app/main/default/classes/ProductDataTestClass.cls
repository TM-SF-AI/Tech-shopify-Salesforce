/*
* Developer : Manish 
* Class: ProductData
*/
@isTest(SeeAllData=false)
public class ProductDataTestClass {
    
    @testSetup static void setup() {
        // Create common test shop and product
        Shopify_Configuration__c testshop = new Shopify_Configuration__c ();
        testshop.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshop.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshop.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        insert testshop; 
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        //add shopify product
        List<Product2> testproducts = new List<Product2>();
        for(Integer i=0;i<5;i++) {
            testproducts.add(new Product2(Name = 'Testproduct'+i ,Shopify_Shop_Url__c =  testshop.Name ,Product__c ='Shopify'));
        }
        insert testproducts;
        //add salesforce product
        List<Product2> testproducts2 = new List<Product2>();
        for(Integer i=0;i<5;i++) {
            testproducts2.add(new Product2(Name = 'TestSalesforceproduct1'+i ,Product__c ='Salesforce'));
        }
        insert testproducts2;   
    }
    @isTest static void testgetProductSyncData() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        testshop.Product_Mapping__c = '[{"Product_type":"Shopify_Product_Type__c"},{"Vendor":"Shopify_Vendor_Name__c"},{"Image_Src":"Shopify_Product_Image_URL__c"},{"Variants_price":"Price__c"},{"Tags":"Tags__c"}]';
        update testshop;
        Product2 testproducttoexport = [SELECT Id,Name from Product2 LIMIT 1];
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.getProductSyncData(5, 5,testshop.Id,'All');
        Test.stopTest();
    }
    @isTest static void testgetProductDataShopify() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        testshop.Product_Mapping__c = '[{"Product_type":"Shopify_Product_Type__c"},{"Vendor":"Shopify_Vendor_Name__c"},{"Image_Src":"Shopify_Product_Image_URL__c"},{"Variants_price":"Price__c"},{"Tags":"Tags__c"}]';
        update testshop;
        Product2 testproducttoexport = [SELECT Id,Name from Product2 LIMIT 1];
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.getProductSyncData(5, 5,testshop.Id,'Shopify');
        Test.stopTest();
    }
    @isTest static void testgetProductDataSalesforce() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        testshop.Product_Mapping__c = '[{"Product_type":"Shopify_Product_Type__c"},{"Vendor":"Shopify_Vendor_Name__c"},{"Image_Src":"Shopify_Product_Image_URL__c"},{"Variants_price":"Price__c"},{"Tags":"Tags__c"}]';
        update testshop;
        Product2 testproducttoexport = [SELECT Id,Name from Product2 LIMIT 1];
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.getProductSyncData(5, 5,testshop.Id,'Salesforce');
        Test.stopTest();
    }
    @isTest static void testgetProductData() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        ProductData.getProductData(5,5,testshop.id);
    }
    @isTest static void testgetAllProductData() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        ProductData.getAllProductData(5,5,testshop.id);
    }
    @isTest static void testProduct_Type_Data() {  
        
       Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c  LIMIT 1];
        system.debug('testshop' + testshop);
        //ProductData.Product_Type_Data('Shopify',5, 5,testshop.Id);
        //ProductData.Product_Type_Data('All',5, 5,testshop.id);
        //ProductData.Product_Type_Data('Salesforce',5, 5,testshop.id);
    }
    @isTest static void testproductFieldsList() {
        list<string> testresult =  ProductData.productFieldsList();
        System.assert(testresult != null);
    }
    @isTest static void testfetchSearchProduct() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        ProductData.fetchSearchProduct('Testproduct',testshop.Id,5, 5,'Shopify');
        ProductData.fetchSearchProduct('Testproduct',testshop.Id,5, 5,'All');
        ProductData.fetchSearchProduct('Testproduct',testshop.Id,5, 5,'Salesforce');
    }
    @isTest static void testdeleteProductByIdSalesforce() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        Product2 testproducts = new Product2();
        testproducts.Name = 'Testproduct12';
        testproducts.Shopify_Shop_Url__c =  testshop.Name ;
        testproducts.Product__c ='Shopify' ;
        testproducts.Shopify_Product_Id__c = '12345';
        insert testproducts;
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.deleteProductById(testproducts.Id,5,5,testshop.Id,'Salesforce');
        Test.stopTest();
    }
    @isTest static void testdeleteProductByIdShopify() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
         Product2 testproducts = new Product2();
        testproducts.Name = 'Testproduct12';
        testproducts.Shopify_Shop_Url__c =  testshop.Name ;
        testproducts.Product__c ='Shopify' ;
        testproducts.Shopify_Product_Id__c = '12345';
        insert testproducts;
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.deleteProductById(testproducts.Id,5,5,testshop.Id,'Shopify');
        Test.stopTest();
    }
    @isTest static void testdeleteProductByIdAll() {
        id shopid = [Select id,TechnologyMind__Selected_App__c from TechnologyMind__App_Configuration__c].TechnologyMind__Selected_App__c;
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c where id =: shopid];
         Product2 testproducts = new Product2();
        testproducts.Name = 'Testproduct12';
        testproducts.Shopify_Shop_Url__c =  testshop.Name ;
        testproducts.Product__c ='Shopify' ;
        testproducts.Shopify_Product_Id__c = '12345';
        insert testproducts;
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.deleteProductById(testproducts.Id,5,5,testshop.Id,'All');
        //ProductData.deleteProductById(testproducts.Id,5,5,testshop1.Id,'All');
        Test.stopTest();
    }
    
    
    @isTest static void testexportToShopify() {
       /* Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        
       Product2 testproducttoexport = [SELECT Id,Name from Product2 LIMIT 1];
       ProductData.exportToShopify(testshop.Id,testproducttoexport.Id); */
        
      //   id shopid = [Select id,TechnologyMind__Selected_App__c from TechnologyMind__App_Configuration__c].TechnologyMind__Selected_App__c;
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c ];
         Product2 testproducts = new Product2();
        testproducts.Name = 'Testproduct12';
        testproducts.Shopify_Shop_Url__c =  testshop.Name ;
        testproducts.Product__c ='Shopify' ;
        testproducts.Shopify_Product_Id__c = '12345';
        testproducts.isactive= true;
        insert testproducts;
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
      // Product2 testproducttoexport = [SELECT Id,Name from Product2 LIMIT 1];
       ProductData.exportToShopify(testshop.Id,testproducts.Id);
        //ProductData.deleteProductById(testproducts.Id,5,5,testshop1.Id,'All');
        Test.stopTest();
        
    }
    @isTest static void testGet_single_Product_Data() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        Product2 testproducts = new Product2();
        testproducts.Name = 'Testproduct12';
        testproducts.Shopify_Shop_Url__c =  testshop.Name ;
        testproducts.Product__c ='Shopify' ;
        testproducts.Shopify_Product_Id__c = '12345';
        insert testproducts;
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.Get_single_Product_Data(testproducts.Shopify_Product_Id__c,5,5,testshop.Id,'All');
        Test.stopTest();
    }
    @isTest static void testGet_single_Product_DataShopify() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        Product2 testproducts = new Product2();
        testproducts.Name = 'Testproduct12';
        testproducts.Shopify_Shop_Url__c =  testshop.Name ;
        testproducts.Product__c ='Shopify' ;
        testproducts.Shopify_Product_Id__c = '12345';
        insert testproducts;
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.Get_single_Product_Data(testproducts.Shopify_Product_Id__c,5,5,testshop.Id,'Shopify');
        Test.stopTest();
    }
    @isTest static void testGet_single_Product_DataSalesforce() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        Product2 testproducts = new Product2();
        testproducts.Name = 'Testproduct12';
        testproducts.Product__c ='Salesforce' ;
        insert testproducts;
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.Get_single_Product_Data(testproducts.Shopify_Product_Id__c,5,5,testshop.Id,'Salesforce');
        Test.stopTest();
    }
    
    @isTest static void testgetConditionalProductSyncData() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        testshop.Product_Mapping__c = '[{"Product_type":"Shopify_Product_Type__c"},{"Vendor":"Shopify_Vendor_Name__c"},{"Image_Src":"Shopify_Product_Image_URL__c"},{"Variants_price":"Price__c"},{"Tags":"Tags__c"}]';
        update testshop;
        Product2 testproducttoexport = [SELECT Id,Name from Product2 LIMIT 1];
        date Shopify_Updated_After = date.newInstance(1990, 11, 21);
        date Shopify_Updated_Before = date.newInstance(1990, 11, 21);
        date Shopify_Published_After = date.newInstance(1990, 11, 21);
        date Shopify_Published_Before = date.newInstance(1990, 11, 21);
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.getConditionalProductSyncData(Shopify_Updated_After,Shopify_Updated_Before,Shopify_Published_After,Shopify_Published_Before,5,5,testshop.Id,'All');
        Test.stopTest();
    }
    @isTest static void testgetConditionalProductSyncDataShopify() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        testshop.Product_Mapping__c = '[{"Product_type":"Shopify_Product_Type__c"},{"Vendor":"Shopify_Vendor_Name__c"},{"Image_Src":"Shopify_Product_Image_URL__c"},{"Variants_price":"Price__c"},{"Tags":"Tags__c"}]';
        update testshop;
        Product2 testproducttoexport = [SELECT Id,Name from Product2 LIMIT 1];
        date Shopify_Updated_After = date.newInstance(1990, 11, 21);
        date Shopify_Updated_Before = date.newInstance(1990, 11, 21);
        date Shopify_Published_After = date.newInstance(1990, 11, 21);
        date Shopify_Published_Before = date.newInstance(1990, 11, 21);
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.getConditionalProductSyncData(Shopify_Updated_After,Shopify_Updated_Before,Shopify_Published_After,Shopify_Published_Before,5,5,testshop.Id,'Shopify');
        Test.stopTest();
    }
    @isTest static void testgetConditionalProductSyncDataSalesforce() {
        Shopify_Configuration__c testshop = [SELECT Id,Name,Shopify_Access_Token__c,Password__c FROM Shopify_Configuration__c LIMIT 1];
        testshop.Product_Mapping__c = '[{"Product_type":"Shopify_Product_Type__c"},{"Vendor":"Shopify_Vendor_Name__c"},{"Image_Src":"Shopify_Product_Image_URL__c"},{"Variants_price":"Price__c"},{"Tags":"Tags__c"}]';
        update testshop;
        Product2 testproducttoexport = [SELECT Id,Name from Product2 LIMIT 1];
        
        date Shopify_Updated_After = date.newInstance(1990, 11, 21);
        date Shopify_Updated_Before = date.newInstance(1990, 11, 21);
        date Shopify_Published_After = date.newInstance(1990, 11, 21);
        date Shopify_Published_Before = date.newInstance(1990, 11, 21);
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
        ProductData.getConditionalProductSyncData(Shopify_Updated_After,Shopify_Updated_Before,Shopify_Published_After,Shopify_Published_Before,5,5,testshop.Id,'Salesforce');
        Test.stopTest();
    }
}