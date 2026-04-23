/*
* Developer : Manish 
* Class: ProductData
*/
@isTest(SeeAllData=false)
public class ConfigurationTestClass {
    
    @testSetup static void setup() {
        // Create common test shop and product
        Shopify_Configuration__c testshop = new Shopify_Configuration__c ();
        testshop.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshop.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshop.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        insert testshop; 
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
    @isTest static void testAdminconfig() {
        Configuration.Adminconfig(5,5);
    }
    @isTest static void testfetchSearchshop() {
        List < Shopify_Configuration__c > testresult =  Configuration.fetchSearchshop('https');
        System.assert(testresult != null); 
    }
    @isTest static void testfetchSearchshophelper() {
        Configuration.fetchSearchshophelper('https',5,5);
    }
    @isTest static void testcheckShopDetials() {
        
        Test.startTest(); 
        Test.setMock(HttpCalloutMock.class, new MockTest());
       Configuration.checkShopDetials('Token','Passwords','https://healthyxpressdemo.myshopify.com/');
        Test.stopTest();
    }
    @isTest static void testAccountsFields() {
        Configuration.AccountsFields();
    }
    //Added By: Yashveer
    @isTest static void accountsFieldsTest() {
     //  Configuration.AccountsFields('Phone','Phone');
        Configuration.AccountsFields();
    }
    @isTest static void testAccountsMappingFields() {
        Shopify_Configuration__c testshop = new Shopify_Configuration__c ();
        testshop.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshop.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshop.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        insert testshop;
        List<String> SalesforceField= new List<String>{'Phone'};
            List<String> ShopifyField=new List<String>{'Phone'};
                Configuration.AccountsMappingFields(SalesforceField,ShopifyField,testshop.Id);
    }
    @isTest static void testCheckMappingFields() {
        Shopify_Configuration__c testshop = new Shopify_Configuration__c ();
        testshop.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshop.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshop.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        insert testshop;
        Configuration.CheckMappingFields('Phone','Phone','Phone',testshop.Id);
    }
    @isTest static void testShopify_fields() {
        Shopify_Configuration__c testshop = new Shopify_Configuration__c ();
        testshop.Name = 'https://healthyxpressdemo.myshopify.com/';
        testshop.Shopify_Access_Token__c = '61aa8cff33084fb5eebfd721b7a6e3e5';
        testshop.Password__c = '51f5bfdbd12e120d34fe3669a3ed1949';
        testshop.Customer_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        testshop.Product_Mapping__c = '[{"Product_type":"Shopify_Product_Type__c"},{"Vendor":"Shopify_Vendor_Name__c"},{"Image_Src":"Shopify_Product_Image_URL__c"},{"Variants_price":"Price__c"},{"Tags":"Tags__c"}]';
        testshop.Order_Mapping__c='[{"Country_Code":"Shopifycountrycode__c"}]';
        insert testshop;
        Configuration.Shopify_fields(testshop.Id,1);
    }
    @isTest static void testShopSaveFunction() {
        Configuration.ShopSaveFunction('Phone','Phone','Phone','https://healthyxpressdemo.myshopify.com/','61aa8cff33084fb5eebfd721b7a6e3e5','51f5bfdbd12e120d34fe3669a3ed1949',5,1);
    }
}