@isTest
public class Shopify_OrderDataTestClass {
    testmethod static void getConditionalOrderSyncData(){
        
        date Shopify_Updated_After=date.newInstance(11,20,2020);
        date Shopify_Updated_Before=date.newInstance(11,20,2020);
        date Shopify_Created_After=date.newInstance(11,20,2020);
        date Shopify_Created_Before=date.newInstance(11,20,2020);
        
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        shorder.ShopifyOrderID__c=testshopSC.id;
        insert shorder;
        
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
        OrderData.getConditionalOrderSyncData(Shopify_Updated_After, Shopify_Updated_Before, Shopify_Created_After, Shopify_Created_Before, 5, 1, testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void getSynchronizedOrderDetailsTest(){
       
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        shorder.ShopifyOrderID__c=testshopSC.id;
        insert shorder;
        
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
        OrderData.getSynchronizedOrderDetails(5, 1, testshopSC.Id);
        Test.stopTest();
    }
    testmethod static void SearchOrderTest(){
        Test.startTest();
        OrderData.SearchOrder('abcd');
        Test.stopTest();
    }
    testmethod static void deleteSingleOrderTest(){
      
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        shorder.ShopifyOrderID__c=testshopSC.id;
        insert shorder;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Customer_Id__c=testshopSC.id;
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        insert acc;
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
        OrderData.deleteSingleOrder(shorder.id,5, 1,testshopSC.Id,'Salesforce');
        Test.stopTest();
    }
    
    testmethod static void deleteSingleOrderTestShopify(){
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        shorder.ShopifyOrderID__c=testshopSC.id;
        insert shorder;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Customer_Id__c=testshopSC.id;
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        insert acc;
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
        OrderData.deleteSingleOrder(shorder.id,5, 1,testshopSC.Id,'Shopify');
        Test.stopTest();
    }
    testmethod static void deleteSingleOrderTestAll(){
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        shorder.ShopifyOrderID__c=testshopSC.id;
        insert shorder;
        
        Account acc = new Account();
        acc.Name = 'Testproduct1';
        acc.Shopify_Customer_Id__c=testshopSC.id;
        acc.Shopify_Shop_Url__c=testshopSC.Name;
        insert acc;
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
        OrderData.deleteSingleOrder(shorder.id,5, 1,testshopSC.Id,'All');
        Test.stopTest();
    }
    
    testmethod static void syncSingleOrderTest(){
        
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        shorder.ShopifyOrderID__c=testshopSC.id;
        insert shorder;
        
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
        OrderData.syncSingleOrder(shorder.ShopifyOrderID__c, 5, 1);
        Test.stopTest();
    }
    testmethod static void deleteMultipleOrdersTest(){
     
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
         testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        insert shorder;
        
       
          Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
         OrderData.deleteMultipleOrders(shorder.Id, 5, 1, testshopSC.id, 'Salesforce');
        Test.stopTest();
    }
     testmethod static void deleteMultipleOrdersShopify(){
     
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
         testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
         
         //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        insert shorder;
        
       
          Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
         OrderData.deleteMultipleOrders(shorder.Id, 5, 1, testshopSC.id, 'Shopify');
        Test.stopTest();
    }
     testmethod static void deleteMultipleOrdersAll(){
     
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
         testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
         
         //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        insert shorder;
        
       
          Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
         OrderData.deleteMultipleOrders(shorder.Id, 5, 1, testshopSC.id, 'All');
        Test.stopTest();
    }
    testmethod static void getShopifyDataTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
         testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        insert shorder;
        
        OrderData.getShopifyData(testshopSC.id, 5, 1);
        Test.stopTest();
    }
    testmethod static void getSalesforceOrderListTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
         testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        insert shorder;
        
        OrderData.getSalesforceOrderList(testshopSC.id, 5, 1);
        Test.stopTest();
    }
    testmethod static void getAllOrderListTest(){
        Test.startTest();
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
         testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        insert shorder;
        
        OrderData.getAllOrderList(testshopSC.id, 5, 1);
        Test.stopTest();
    }
    testmethod static void exportToShopifyTest(){
        
        Shopify_Configuration__c testshopSC = new Shopify_Configuration__c();
        testshopSC.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshopSC.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshopSC.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
         testshopSC.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshopSC;
        
        //add App_Configuration__c record
        string sid = [select id from Shopify_Configuration__c limit 1].id;
        system.debug('sid : '+sid);
        TechnologyMind__App_Configuration__c selectedshop = new TechnologyMind__App_Configuration__c();
        selectedshop.TechnologyMind__Selected_App__c = sid; 
        system.debug('selectedshop :'+selectedshop);
        insert selectedshop;
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='31358131372066';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        insert shorder;
        
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new OrderMockTest());
        OrderData.exportToShopify(testshopSC.id, shorder.Id);
        Test.stopTest();
    }
    testmethod static void Order_Type_DataTest(){
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
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='abcdjaslks';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        insert shorder;
        
        OrderData.Order_Type_Data('Salesforce',5,1,testshopSC.id);
        OrderData.Order_Type_Data('Shopify',5,1,testshopSC.id);
        OrderData.Order_Type_Data('All',5,1,testshopSC.id);
        Test.stopTest();
    }
    testmethod static void fetchSearchOrderTest(){
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
        
        ShopifyOrders__c shorder = new ShopifyOrders__c();
        shorder.Name='TestOrder1';
        shorder.FirstName__c='TestABC';
        shorder.ChooseOrg__c='Salesforce';
        shorder.Phone__c='9468758068';
        shorder.Product_variant_id__c='abcdjaslks';
        shorder.TotalPrice__c='500';
        shorder.Email__c='abcd@test1.com';
        insert shorder;
        
        OrderData.fetchSearchOrder('All',testshopSC.id,5,1,'Salesforce');
        OrderData.fetchSearchOrder('All',testshopSC.id,5,1,'Shopify');
        OrderData.fetchSearchOrder('All',testshopSC.id,5,1,'All');
        Test.stopTest();
    }
}