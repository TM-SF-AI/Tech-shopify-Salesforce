@isTest
public class Shopify_Customer_DataTestClass {
    
    testmethod static void getCustomerAllDataTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        
        Customers_Data.getCustomerAllData(5, 1, testshopSC.id);
        Test.stopTest();
    }
    testmethod static void getConditionalCustomerSyncDataTest(){
       
        date Shopify_Updated_After=date.newInstance(11,20,2020);
        date Shopify_Updated_Before=date.newInstance(11,20,2020);
        date Shopify_Created_After=date.newInstance(11,20,2020);
        date Shopify_Created_Before=date.newInstance(11,20,2020);
        
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new CustomerMockTest());
        Customers_Data.getConditionalCustomerSyncData(Shopify_Updated_After,Shopify_Updated_Before,Shopify_Created_After,Shopify_Created_Before,5,1,testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void deleteProductByIdTest(){
        
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;

        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Customer_Id__c=testshopSC.id;
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        insert acc;
      
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new CustomerMockTest());
        Customers_Data.deleteProductById(acc.id,5,5,testshopSC.Id,'All');
        Test.stopTest();
    }
    testmethod static void deleteProductByIdSalesforceTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c='Salesforce';
        insert acc;
        Customers_Data.deleteProductById(acc.id,5,5,testshopSC.Id,'Salesforce');
        Test.stopTest();
    }
    testmethod static void deleteProductByIdShopifyTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c='Shopify';
        insert acc;
        Customers_Data.deleteProductById(acc.id,5,5,testshopSC.Id,'Shopify');
        Test.stopTest();
    }
    testmethod static void syncsinglecustomerTest(){
       
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Shopify_Customer_Id__c=testshopSC.id;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
       
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new CustomerMockTest());
        Customers_Data.syncsinglecustomer(acc.Shopify_Customer_Id__c,5,5,testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void getCustomerDataTest(){
        
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new CustomerMockTest());
        Customers_Data.getCustomerData(5,5,testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void exportToShopifyTest(){
       
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new CustomerMockTest());
        Customers_Data.exportToShopify(testshopSC.Id,acc.id);
        Test.stopTest();
    }
    testmethod static void fetchSearchCustomerTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Salesforce';
        insert acc;
        Customers_Data.fetchSearchCustomer('All',testshopSC.Id,5,1,'All');
        Customers_Data.fetchSearchCustomer('All',testshopSC.Id,5,1,'Salesforce');
        Customers_Data.fetchSearchCustomer('All',testshopSC.Id,5,1,'Shopify');
        Test.stopTest();
    }
    testmethod static void ListOfCustomerTypeHelperTest(){
        Test.startTest();
         
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Salesforce';
        insert acc;
        Customers_Data.ListOfCustomerTypeHelper('All',5,1,testshopSC.Id);
        Customers_Data.ListOfCustomerTypeHelper('Salesforce',5,1,testshopSC.Id);
        Customers_Data.ListOfCustomerTypeHelper('Shopify',5,1,testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void deleteRecordsTest(){
       
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new CustomerMockTest());
        Customers_Data.deleteRecords(acc.id,5,1,testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void fetchSearchProductTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        Customers_Data.fetchSearchProduct(5,1,'All',testshopSC.Id,'All');
        Customers_Data.fetchSearchProduct(5,1,'All',testshopSC.Id,'Salesforce');
        Customers_Data.fetchSearchProduct(5,1,'All',testshopSC.Id,'Shopify');
        Test.stopTest();
    }
    testmethod static void getAccountDataTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        Customers_Data.getAccountData(5,1,testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void getShopifyDataTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        Customers_Data.getShopifyData(5,1,testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void getAllDataTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        Customers_Data.getAllData(5,1,testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void getAllDoinitDataTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Customer_Mapping__c='{"Country_Code":"Shopifycountrycode__c"}';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        acc.Choose_Customer__c = 'Shopify';
        insert acc;
        Customers_Data.getAllDoinitData(5,1,testshopSC.Id);
        Test.stopTest();
    }
}