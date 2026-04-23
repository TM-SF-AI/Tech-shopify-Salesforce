({
    doInit: function(component, event, helper) {
        helper.setDefaultAppToggle(component, event, helper);
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.pageSize");
        console.log('value : '+pageNumber);
        component.set("v.PageNumber", pageNumber);
        component.set("v.pageSize", pageSize);
        var string2 ='Title Product_type Vendor Handle Product_Id Image_Src Description Variants_price';
        var array = string2.split(" "); 
        array = array.sort();
        component.set("v.Shopifyfields", array);
        
        var CustomerFields = 'Created_at Updated_at Total_Spent Last_Order_Name Orders_Count Customer_id First_Name Last_Name Province Country';
        var CustomerFields1 = CustomerFields+ 'Zip Phone Province_Code Country_Code';
        var array2 = CustomerFields1.split(" "); 
        array2 = array2.sort();
        component.set("v.ShopifyCustomerFields", array2);
        
        
        var OrderFields = 'Total_Price Contact_Email Order_Number Address1 City Country Address2 First_Name Last_Name Orders_Count Last_Order_id Customer_id';
        var array3 = OrderFields.split(" "); 
        array3 = array3.sort();
        component.set("v.ShopifyOrderFields", array3);
        
        component.find("shopifyRecordCreator").getNewRecord(
            "TechnologyMind__Shopify_Configuration__c", // sObject type 
            null,      // recordTypeId
            false,     // skip cache?
            $A.getCallback(function() {
                var rec = component.get("v.newShopify");
                var error = component.get("v.newShopifyError");
                if(error || (rec === null)) {
                    console.log("Error initializing record template: " + error);
                    return;
                }
                console.log("Record template initialized: " + rec.sobjectType);
            })
        );
        helper.callaction(component,event,helper);
        
        
        /*
           var zipor = component.find("toggle");
        var ids = event.target.getAttribute('data-Id');
        var shopids = event.target.getAttribute('data-value');
        for(var i = 0;i < zipor.length; i++) {
            if(i == ids){
                component.find("toggle")[i].set("v.checked", true);
                var shopname = event.target.getAttribute('data-value');
                component.set("v.ShopName", shopname);
                component.set("v.Shopid", shopids);
                console.log("Shopid :"+ shopids);
            }
            else{
                component.find("toggle")[i].set("v.checked", false);
            }
         }
          */
    },
    
    SelectedOrderField: function(component, event, helper) {
        var selectedValue = component.find("SelectedOrderField").get("v.value");
        if(selectedValue == 'Total_Price'){
            component.set("v.SelectedOrderField", 'Totalprice');
        }
        else if(selectedValue == 'Contact_Email'){
            component.set("v.SelectedOrderField", 'Email');
        }
            else if(selectedValue == 'Order_Number'){
                component.set("v.SelectedOrderField", 'Name');
            }
                else if(selectedValue == 'Address1'){
                    component.set("v.SelectedOrderField", 'Address1');
                }
                    else if(selectedValue == 'City'){
                        component.set("v.SelectedOrderField", 'City');
                    }
                        else if(selectedValue == 'Country'){
                            component.set("v.SelectedOrderField", 'Country');
                        }
                            else if(selectedValue == 'Address2'){
                                component.set("v.SelectedOrderField", 'Address2');
                            }
                                else if(selectedValue == 'Last_Name'){
                                    component.set("v.SelectedOrderField", 'LastName');
                                }
                                    else if(selectedValue == 'First_Name'){
                                        component.set("v.SelectedOrderField", 'FirstName');
                                    }
                                        else if(selectedValue == 'Orders_Count'){
                                            component.set("v.SelectedOrderField", 'OrderCount');
                                        }
                                            else if(selectedValue == 'Last_Order_id'){
                                                component.set("v.SelectedOrderField", 'ShopifyOrderID');
                                            }
                                                else if(selectedValue == 'Customer_id'){
                                                    component.set("v.SelectedOrderField", 'CustomerID');
                                                }
                                                    else if(selectedValue == 'None'){
                                                        component.set("v.SelectedOrderField", 'None');
                                                    }
    },
    
    SelectedCustomerField: function(component, event, helper) {
        var selectedValue = component.find("SelectedCustomerField").get("v.value");
        if(selectedValue == 'Created_at'){
            component.set("v.SelectedCustomerField", 'ShopifyCreatedDate');
        }
        else if(selectedValue == 'Updated_at'){
            component.set("v.SelectedCustomerField", 'ShopifyUpdatedDate');
        }
            else if(selectedValue == 'Total_Spent'){
                component.set("v.SelectedCustomerField", 'ShopifyTotalSpent');
            }
                else if(selectedValue == 'Last_Order_Name'){
                    component.set("v.SelectedCustomerField", 'Shopifylastordername');
                }
                    else if(selectedValue == 'Orders_Count'){
                        component.set("v.SelectedCustomerField", 'ShopifyOrderCount');
                    }
                        else if(selectedValue == 'Customer_id'){
                            component.set("v.SelectedCustomerField", 'Shopify_Customer_Id');
                        }
                            else if(selectedValue == 'First_Name'){
                                component.set("v.SelectedCustomerField", 'Name');
                            }
                                else if(selectedValue == 'Last_Name'){
                                    component.set("v.SelectedCustomerField", 'ShopifyLastName');
                                }
                                    else if(selectedValue == 'Province'){
                                        component.set("v.SelectedCustomerField", 'Shopify_Billing_State');
                                    }
                                        else if(selectedValue == 'Country'){
                                            component.set("v.SelectedCustomerField", 'ShopifyBillingCountry');
                                        }
                                            else if(selectedValue == 'Zip'){
                                                component.set("v.SelectedCustomerField", 'ShopifyZipCode');
                                            }
                                                else if(selectedValue == 'Phone'){
                                                    component.set("v.SelectedCustomerField", 'ShopifyPhone');
                                                }
                                                    else if(selectedValue == 'Province_Code'){
                                                        component.set("v.SelectedCustomerField", 'Shopifyprovincecode');
                                                    }
                                                        else if(selectedValue == 'Country_Code'){
                                                            component.set("v.SelectedCustomerField", 'Shopifycountrycode');
                                                        }else if(selectedValue == 'None'){
                                                            component.set("v.SelectedCustomerField", 'None');
                                                        }
    },
    
    Selectedshopifyfield : function(component, event, helper) {
        var selectedValue = component.find("selectedProductField").get("v.value");
        if(selectedValue == 'Title'){
            component.set("v.Selectedfields", 'Name');
        }
        else if(selectedValue == 'Product_type'){
            component.set("v.Selectedfields", 'Shopify_Product_Type');
        }
            else if(selectedValue == 'Vendor'){
                component.set("v.Selectedfields", 'Shopify_Vendor_Name');
            }
                else if(selectedValue == 'Handle'){
                    component.set("v.Selectedfields", 'Shopify_Handle');
                }
                    else if(selectedValue == 'Product_Id'){
                        component.set("v.Selectedfields", 'Shopify_Product_Id');
                    }
                        else if(selectedValue == 'Image_Src'){
                            component.set("v.Selectedfields", 'Shopify_Product_Image_URL');
                        }
                            else if(selectedValue == 'Variants_price'){
                                component.set("v.Selectedfields", 'Price');
                            }
                                else if(selectedValue == 'None'){
                                    component.set("v.Selectedfields", 'None');
                                }
    },
    Productcomponent: function(component, event, helper) {
        debugger;
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Product_data_table",
            componentAttributes: {
                Shopid : component.get("v.Shopid")
            }
        });
        evt.fire();
    },
    DocsComponent: function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:ShopifyDocu",
        });
        evt.fire();
    },
    Customerscomponent : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Customer_data_Table",
            componentAttributes: {
                Shopid : component.get("v.Shopid")
            }
        });
        evt.fire();
    },
    Orderscomponent : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Order_data_table",
            componentAttributes: {
                Shopid : component.get("v.Shopid")
            }
        });
        evt.fire();
    },
    toggleDefaultShop:function(component,event,helper){
        console.log("0");
        var zipor = component.find("toggleid");
        console.log("1 : "+zipor.length);
         var ids = event.target.getAttribute('data-Id');
        console.log("2 : "+ids);
        var shopids = event.target.getAttribute('data-value');
        console.log("3 : "+shopids); //shop id
        component.set("v.Shopid", shopids);
        console.log("3.1 : ");
        if(zipor.length == undefined){
            console.log("3.2 : ");
            for(var i = 0;i <= 1; i++) {
                 console.log("3.3 : ");
                if(i == ids){
                    console.log("3.4 : ");
                    component.find("toggleid").set("v.checked", true);
                    var shopname = event.target.getAttribute('data-value');
                    component.set("v.ShopName", shopname);
                    component.set("v.Shopid", shopids);
                    console.log("Shopid :"+ shopids);
                    var pageNumber = 1;
                    helper.checkfields(component,event,helper,pageNumber);
                }
               
            }   
        }
        else{
            console.log("else 3.1 : ");
            for(var i = 0;i <zipor.length; i++) {
                if(i == ids){
                    component.find("toggleid")[i].set("v.checked", true);
                    var shopname = event.target.getAttribute('data-value');
                    component.set("v.ShopName", shopname);
                    component.set("v.Shopid", shopids);
                    console.log("Shopid :"+ shopids);
                    var pageNumber = 1;
                    helper.checkfields(component,event,helper,pageNumber);
                }
                else{
                    console.log("else");
                    component.find("toggleid")[i].set("v.checked", false);
                }
            }   
        }
        // var selectedValue = component.find("toggleid").get("v.checked");
        // console.log('Value : '+ selectedValue);
       
        
        console.log("4");
    },  
    handleSaveShopify: function(component, event, helper) {
        component.set("v.selectedStep", "step1");
        component.set("v.messageshow", 'slds-hide');
        var Shopid = component.get("v.Shopid");
        var Shopifymapping  = component.get("v.Shopifymapping");
        var Salesforcemapping = component.get("v.Salesforcemapping");
        
        var Accmap = component.get("v.mapping");
        
        var Acc = JSON.stringify(Accmap);
        console.log(Acc);
        var Productmap = component.get("v.Productmapping");
        var Product = JSON.stringify(Productmap);
        
        console.log(Product);
        
        var Ordermap = component.get("v.Ordermapping");
        var Order = JSON.stringify(Ordermap);
        
        
        var action = component.get("c.CheckMappingFields");
        action.setParams({
            "Customersmapping":Acc,
            "Productmapping":Product,
            "Ordermapping":Order,
            "shopId" : Shopid
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('Done'+resultData);
            }
        });
        $A.enqueueAction(action);
        console.log("Helper handleSaveShopify End");
        component.set("v.selectedStep", "step1");
        component.set("v.EditselectedStep", "step1");
        
    },
    
    
    handleSaveEditShopify: function(component, event, helper) {
         var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.pageSize");
        
        component.set("v.selectedStep", "step1");
        component.set("v.messageshow", 'slds-hide');
        
        var Shopifymapping  = component.get("v.Shopifymapping");
        var Salesforcemapping = component.get("v.Salesforcemapping");
        
        var Accmap = component.get("v.mapping");
        
        var Acc = JSON.stringify(Accmap);
        console.log(Acc);
        var Productmap = component.get("v.Productmapping");
        var Product = JSON.stringify(Productmap);
        
        console.log(Product);
        
        var Ordermap = component.get("v.Ordermapping");
        var Order = JSON.stringify(Ordermap);
        
        var action = component.get("c.ShopSaveFunction");
        action.setParams({
            "Customersmapping":Acc,
            "Productmapping":Product,
            "Ordermapping":Order,
            "NewShopName":component.get("v.NewShopName"),
            "ShopToken":component.get("v.ShopToken"),
            "ShopPasswords":component.get("v.ShopPasswords"),
             "pageNumber": pageNumber,
            "pageSize": pageSize
            
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('Done'+resultData);
                component.set("v.Shoplist",resultData.shoplist);
                 component.set("v.TotalRecords",component.get("v.Shoplist").length);
                 component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                console.log('TotalPages :',component.get("v.TotalPages"));
                component.set("v.isOpen", false);
            }
            else{
                console.log('Failed');
            }
        });
        $A.enqueueAction(action);
        console.log("Helper handleSaveShopify End");
        component.set("v.selectedStep", "step1");
        component.set("v.EditselectedStep", "step1");
        
    },
    
    
    
    
    
    handleSaveShopifyalsert: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        component.find("shopifyRecordCreator").saveRecord(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
                console.log('Problem saving contact, error: ' + JSON.stringify(saveResult.error));
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        });
        // <button class="slds-button slds-button--brand" onclick="{!c.handleFinish}">Finish</button>  
        alert('Finished...');
        component.set("v.selectedStep", "step1");
        component.set("v.EditselectedStep", "step1");
        $A.get('e.force:refreshView').fire();
    },
    
    handleEditNext : function(component,event,helper){
        
        console.log('value');  
        var Url = component.get("v.EditShopURL");
        console.log('value2');  
        var Token = component.get("v.EditAccessToken");
        console.log('value3'); 
        var Password = component.get("v.EditPassword");
        console.log('value4'); 
        // Url = Url.trim();
        console.log('value5'); 
        // Token = Token.trim();
        console.log('value6'); 
        if(Url == null || Url == '' && Token == null || Token == ''){
            console.log('value7'); 
            component.set("v.messageshow", 'slds-show');
            component.set("v.messageType", 'error');
            component.set("v.message", 'Please Fill the details');
            component.set("v.EditselectedStep", "step1");
        }
        
        else{
            component.set("v.messageshow", 'slds-hide');
            var getselectedStep = component.get("v.EditselectedStep");
            if(getselectedStep == "step2"){
                component.set("v.EditselectedStep", "step4");
            }
            else if(getselectedStep == "step1"){
                component.set("v.EditselectedStep", "step2");
            }
                else if(getselectedStep == "step4"){
                    component.set("v.EditselectedStep", "step5");
                }
                    else if(getselectedStep == "step5"){
                        component.set("v.EditselectedStep", "step6");
                    }
        }
    },
    handleNext : function(component,event,helper){
        console.log('value');  
        var Url = component.find("Url").get("v.value");
        console.log('value2');  
        var Token = component.find("AccessToken").get("v.value");
        console.log('value3'); 
        var Password = component.find("AppPassword").get("v.value");
        console.log('value4'); 
        // Url = Url.trim();
        console.log('value5'); 
        // Token = Token.trim();
        console.log('value6'); 
        if(Url == null || Url == '' && Token == null || Token == ''){
            console.log('value7'); 
            component.set("v.messageshow", 'slds-show');
            component.set("v.messageType", 'error');
            component.set("v.message", 'Please Fill the details');
            component.set("v.selectedStep", "step1");
        }
        /* else if (Token == null){
            console.log('Token : '+Token);    
        }
            else{
                console.log('Password : '+Password);
            }
        */
        else{
            console.log('Else value6'); 
            component.set("v.messageshow", 'slds-hide');
            helper.Checkthetoken(component,event,helper,Password,Token,Url);    
        } 
        console.log('value8'); 
    },
    
    handleEditPrev : function(component,event,helper){
        component.set("v.messageshow", 'slds-hide');
        var getselectedStep = component.get("v.EditselectedStep");
        if(getselectedStep == "step2"){
            component.set("v.EditselectedStep", "step1");
        }
        else if(getselectedStep == "step1"){
            component.set("v.EditselectedStep", "step1");
        }
            else if(getselectedStep == "step4"){
                component.set("v.EditselectedStep", "step2");
            }
                else if(getselectedStep == "step5"){
                    component.set("v.EditselectedStep", "step4");
                }
                    else if(getselectedStep == "step6"){
                        component.set("v.EditselectedStep", "step5");
                    }
    },
    handlePrev : function(component,event,helper){
        component.set("v.messageshow", 'slds-hide');
        var getselectedStep = component.get("v.selectedStep");
        if(getselectedStep == "step2"){
            component.set("v.selectedStep", "step1");
        }
        else if(getselectedStep == "step4"){
            component.set("v.selectedStep", "step2");
        } 
            else if(getselectedStep == "step5"){
                component.set("v.selectedStep", "step4");
            }
                else if(getselectedStep == "step6"){
                    component.set("v.selectedStep", "step5");
                }
    },
    
    ChecktheAction : function(component,event,helper,Url) {
        console.log("ChecktheAction  Start");
        var action = component.get("c.checkShopAction");
        action.setParams({
            "Token": component.get("v.Shoplist")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                console.log('State is success');
            }
            else{
                console.log('state failed');
            }
        });
        console.log("Helper ChecktheAction End");
        $A.enqueueAction(action);
    },
    selectStep1 : function(component,event,helper){
        component.set("v.selectedStep", "step1");
    },
    EditselectStep1 : function(component,event,helper){
        debugger;
        component.set("v.messageshow", 'slds-hide');
        component.set("v.EditselectedStep", "step1");
    },
    selectStep2 : function(component,event,helper){
        
        var msg = component.get("v.messageType");
        if(msg === 'success'){
            component.set("v.messageshow", 'slds-hide');
            component.set("v.messageType", 'success');
            component.set("v.selectedStep", "step2");
            component.set("v.message", 'success');
        }
        else{
            component.set("v.messageshow", 'slds-show');
            component.set("v.messageType", 'error');
            component.set("v.message", 'Please complete the first step');
            component.set("v.selectedStep", "step1");
        } 
        // component.set("v.selectedStep", "step2");
    },
    EditselectStep2 : function(component,event,helper){
        component.set("v.messageshow", 'slds-hide');
        var msg = component.get("v.EditselectedStep");
        component.set("v.EditselectedStep", "step2");
        // component.set("v.selectedStep", "step2");
    },
    EditselectStep4 : function(component,event,helper){
        component.set("v.messageshow", 'slds-hide');
        var msg = component.get("v.EditselectedStep");
        component.set("v.EditselectedStep", "step4");
        // component.set("v.selectedStep", "step2");
    },
    EditselectStep5 : function(component,event,helper){
        component.set("v.messageshow", 'slds-hide');
        var msg = component.get("v.EditselectedStep");
        component.set("v.EditselectedStep", "step5");
        // component.set("v.selectedStep", "step2");
    },
    EditselectStep6 : function(component,event,helper){
        component.set("v.messageshow", 'slds-hide');
        var msg = component.get("v.EditselectedStep");
        component.set("v.EditselectedStep", "step6");
        // component.set("v.selectedStep", "step2");
    },
    selectStep4 : function(component,event,helper){
        var msg = component.get("v.messageType");
        if(msg === 'success'){
            component.set("v.messageshow", 'slds-hide');
            component.set("v.messageType", 'success');
            component.set("v.message", 'success');
            component.set("v.selectedStep", "step4");
        }
        else{
            component.set("v.messageshow", 'slds-show');
            component.set("v.messageType", 'error');
            component.set("v.message", 'Please complete the first step');
            component.set("v.selectedStep", "step1");
        }
        //component.set("v.selectedStep", "step4");
    },
    
    openModel: function(component, event, helper) {
        // for Display Model,set the "isOpen" attribute to "true"
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
        component.set("v.isOpen", false);
        component.set("v.selectedStep", "step1");
        component.set("v.EditselectedStep", "step1");
        component.set("v.isEdit", false);
    },
    editModel: function(component, event, helper) {
        //  var msg = event.getSource().get("data-value");
        component.set("v.messageshow", 'slds-hide');
        
        var value =  event.target.getAttribute('data-value');
       
        var shopdetails = component.get("v.Shoplist");
        for(var i =0 ;i<shopdetails.length;i++){
            if(shopdetails[i].Id == value){
                component.set("v.EditShopURL", shopdetails[i].Name);
                component.set("v.EditAccessToken", shopdetails[i].TechnologyMind__Shopify_Access_Token__c);
                component.set("v.EditPassword", shopdetails[i].TechnologyMind__Password__c);
            }
        }
        component.set("v.isEdit", true);
    },
   
    
    likenClose: function(component, event, helper) {
        // Display alert message on the click on the "Like and Close" button from Model Footer 
        // and set set the "isOpen" attribute to "False for close the model Box.
        alert('thanks for like Us :)');
        component.set("v.isOpen", false);
    },
    createRecordProduct : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Product2"
        });
        createRecordEvent.fire();
    },
    createRecordAccount : function (component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account"
        });
        createRecordEvent.fire();
    },
    SearchShop: function(component, event) {
        console.log('in search helper ');
         var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
         console.log('in pageSize  ');
       var action = component.get("c.fetchSearchshophelper");
        console.log('action '+action);
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword"),
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(response) {
             var state = response.getState();
            if (state === "SUCCESS") {
                 var resultData = response.getReturnValue();
                component.set("v.Shoplist", resultData.config);
                console.log("Shoplist : "+resultData.config.length);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                // set numberOfRecord attribute value with length of return value from server
                component.set("v.TotalNumberOfRecord", resultData.totalRecords);
                // set searchResult list with return value from server.
               // component.set("v.ProductList", storeResponse); 
            }
            else{
                console.log("error");
            }
            
          /*  if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.TotalRecords", storeResponse.length);
                component.set("v.Shoplist", storeResponse); 
            }*/
        });
        $A.enqueueAction(action); 
     /*    var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        component.set("v.PageNumber", pageNumber);
        component.set("v.pageSize", pageSize);
        var fetchkey = component.get("v.searchKeyword");
        console.log('getting search key '+fetchkey);
        helper.SearchHelper(component, event,helper);
       if(fetchkey.length === 0 || !fetchkey.trim()){
            component.set("v.PageNumber", pageNumber);
            component.set("v.pageSize", pageSize);
            helper.callaction(component, event,helper);        
        }
        else{
            helper.SearchHelper(component, event,helper,pageNumber, pageSize);
        }*/
    },
    Customer_Zip: function(component, event, helper) {
        
        var Shopify_Zip = component.get("v.Zip");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Zip);
        console.log('in Shopifymapping'+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping'+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Zip] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Zip");
    },  
    Customer_Updated_at: function(component, event, helper) {
        
        var Shopify_Updated_at = component.get("v.Updated_at");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Updated_at);
        console.log('in Shopifymapping'+Shopifymapping);
        
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping'+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Updated_at] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Updated_at");
    },  
    Customer_Total_Spent: function(component, event, helper) {
        
        var Total_Spent = component.get("v.Total_Spent");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Total_Spent);
        
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Total_Spent] = SalesforceField_val;
        array.push(obj);
        
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        
        
        
    },  
    Customer_Province_Code: function(component, event, helper) {
        
        var Shopify_Province_Code = component.get("v.Province_Code");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Province_Code);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Province_Code] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Province_Code");
    },  
    Customer_Billing_Country: function(component, event, helper) {
        
        var Shopify_Phone = component.get("v.Billing_Country");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Phone);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Phone] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Billing_Country");
    }, 
    Customer_Phone: function(component, event, helper) {
        
        var Shopify_Phone = component.get("v.Phone");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Phone);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Phone] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Phone");
    }, 
    Customer_Orders_Count: function(component, event, helper) {
        
        var Shopify_Orders_Count = component.get("v.Customer_Orders_Count");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Orders_Count);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Orders_Count] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Orders_Count");
    }, 
    Customer_Last_Order_Name: function(component, event, helper) {
        
        var Shopify_Last_Order_Name= component.get("v.Last_Order_Name");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Last_Order_Name);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Last_Order_Name] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Last_Order_Name");
    }, 
    Customer_Billing_State:function(component,event,helper)
    {
        var Billing_State= component.get("v.Billing_State");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Billing_State);
        
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Billing_State] = SalesforceField_val;
        array.push(obj);
        
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        
    },
    Customer_Last_Name: function(component, event, helper) {
        
        var Shopify_Last_Name= component.get("v.Last_Name");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Last_Name);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Last_Name] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Last_Name");   
    },  
    Customer_Email: function(component, event, helper) {
        
        var Shopify_Last_Name= component.get("v.Email");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Last_Name);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Last_Name] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Email");   
    },  
    
    Customer_First_Name: function(component, event, helper) {
        
        var Shopify_First_Name= component.get("v.First_Name");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_First_Name);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_First_Name] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("First_Name");
    }, 
    Customer_Customer_id: function(component, event, helper) {
        
        var Shopify_Customer_id= component.get("v.Customer_id");
        
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Customer_id);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        
        var obj = {};
        
        obj[Shopify_Customer_id] = SalesforceField_val;
        array.push(obj);
        //component.set("v.mapping", JSON.stringify(array));
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Customer_id");
    },
    Customer_Country_Code: function(component, event, helper) {
        
        var Customerfields = component.get("v.Customermapfields");
        console.log("Customerfields ==> "+Customerfields);
        
        var Shopify_Country_Code = component.get("v.Country_Code");
        console.log("Shopify_Country_Code ==> "+Shopify_Country_Code);
        var SalesforceField_val = event.getSource().get("v.value");	// SF field selected option name
        console.log("SalesforceField_val ==> "+SalesforceField_val);	
        var Shopifymapping = component.get("v.Shopifymapping");
        
        
        Shopifymapping.push(Shopify_Country_Code);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        
        
        
        
        
        var array = component.get("v.mapping");
        //debugger
        
        
        
        
        var obj = {};
        obj[Shopify_Country_Code] = SalesforceField_val;
        array.push(obj);
        console.log('array ==> '+array);
        console.log(JSON.stringify(array));
        component.set("v.mapping", array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        
        
    },
    Customer_Created_at: function(component, event, helper) {
        var Shopify_Created_at = component.get("v.Created_at");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.Shopifymapping");
        Shopifymapping.push(Shopify_Created_at);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.Salesforcemapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.mapping");
        var obj = {};
        obj[Shopify_Created_at] = SalesforceField_val;
        array.push(obj);
        component.set("v.mapping",array);
        component.set("v.Shopifymapping",Shopifymapping);
        component.set("v.Salesforcemapping",Salesforcemapping);
        console.log("Created_at ");
    },
    Product_Title: function(component, event, helper) {
        var Shopify_Product = component.get("v.Title");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.productShopifyMapping");
        Shopifymapping.push(Shopify_Product);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.productSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Productmapping");
        var obj = {};
        obj[Shopify_Product] = SalesforceField_val;
        array.push(obj);
        component.set("v.mapping",array);
        component.set("v.productShopifyMapping",Shopifymapping);
        component.set("v.productSalesforceMapping",Salesforcemapping);
        console.log("Productmapping ");
    },    
    Product_Product_type: function(component, event, helper) {
        var Shopify_Product = component.get("v.Product_type");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.productShopifyMapping");
        Shopifymapping.push(Shopify_Product);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.productSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Productmapping");
        var obj = {};
        obj[Shopify_Product] = SalesforceField_val;
        array.push(obj);
        component.set("v.Productmapping",array);
        component.set("v.productShopifyMapping",Shopifymapping);
        component.set("v.productSalesforceMapping",Salesforcemapping);
        console.log("Product_type ");
    },    
    Product_Vendor: function(component, event, helper) {
        var Shopify_Product = component.get("v.Vendor");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.productShopifyMapping");
        Shopifymapping.push(Shopify_Product);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.productSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Productmapping");
        var obj = {};
        obj[Shopify_Product] = SalesforceField_val;
        array.push(obj);
        component.set("v.Productmapping",array);
        component.set("v.productShopifyMapping",Shopifymapping);
        component.set("v.productSalesforceMapping",Salesforcemapping);
        console.log("Vendor ");
    },     
    Product_Handle: function(component, event, helper) {
        var Shopify_Product = component.get("v.Handle");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.productShopifyMapping");
        Shopifymapping.push(Shopify_Product);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.productSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Productmapping");
        var obj = {};
        obj[Shopify_Product] = SalesforceField_val;
        array.push(obj);
        component.set("v.Productmapping",array);
        component.set("v.productShopifyMapping",Shopifymapping);
        component.set("v.productSalesforceMapping",Salesforcemapping);
        console.log("Handle ");
    },
    Product_Product_Id: function(component, event, helper) {
        var Shopify_Product = component.get("v.Product_Id");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.productShopifyMapping");
        Shopifymapping.push(Shopify_Product);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.productSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Productmapping");
        var obj = {};
        obj[Shopify_Product] = SalesforceField_val;
        array.push(obj);
        component.set("v.Productmapping",array);
        component.set("v.productShopifyMapping",Shopifymapping);
        component.set("v.productSalesforceMapping",Salesforcemapping);
        console.log("Product_Id ");
    },
    Product_Image_Src: function(component, event, helper) {
        var Shopify_Product = component.get("v.Image_Src");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.productShopifyMapping");
        Shopifymapping.push(Shopify_Product);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.productSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Productmapping");
        var obj = {};
        obj[Shopify_Product] = SalesforceField_val;
        array.push(obj);
        component.set("v.Productmapping",array);
        component.set("v.productShopifyMapping",Shopifymapping);
        component.set("v.productSalesforceMapping",Salesforcemapping);
        console.log("Image_Src ");
    },  
    Product_Variants_price: function(component, event, helper) {
        var Shopify_Product = component.get("v.Variants_price");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.productShopifyMapping");
        Shopifymapping.push(Shopify_Product);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.productSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Productmapping");
        var obj = {};
        obj[Shopify_Product] = SalesforceField_val;
        array.push(obj);
        component.set("v.Productmapping",array);
        component.set("v.productShopifyMapping",Shopifymapping);
        component.set("v.productSalesforceMapping",Salesforcemapping);
        console.log("Variants_price ");
    },   
    Product_Tags: function(component, event, helper) {
        var Shopify_Product = component.get("v.Tags");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.productShopifyMapping");
        Shopifymapping.push(Shopify_Product);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.productSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Productmapping");
        var obj = {};
        obj[Shopify_Product] = SalesforceField_val;
        array.push(obj);
        component.set("v.Productmapping",array);
        component.set("v.productShopifyMapping",Shopifymapping);
        component.set("v.productSalesforceMapping",Salesforcemapping);
        console.log("Tags ");
    },
    Order_Address1: function(component, event, helper) {
        var Shopify_Order = component.get("v.Address1");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Address1 ");
    },  
    Order_Address2: function(component, event, helper) {
        var Shopify_Order = component.get("v.Address2");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Address2 ");
    }, 
    Order_City: function(component, event, helper) {
        var Shopify_Order = component.get("v.City");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order City ");
    }, 
    Order_Contact_Email: function(component, event, helper) {
        var Shopify_Order = component.get("v.Contact_Email");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Contact_Email ");
    }, 
    Order_Country: function(component, event, helper) {
        var Shopify_Order = component.get("v.Country");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Country ");
    }, 
    Order_Customer_id: function(component, event, helper) {
        var Shopify_Order = component.get("v.Order_Customer_id");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Order_Customer_id ");
    },  
    Order_First_Name: function(component, event, helper) {
        var Shopify_Order = component.get("v.Order_First_Name");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log(" Order_First_Name ");
    },
    Order_Last_Name: function(component, event, helper) {
        var Shopify_Order = component.get("v.Order_Last_Name");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Order_Last_Name ");
    },
    Order_Last_Order_id: function(component, event, helper) {
        var Shopify_Order = component.get("v.Last_Order_id");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Last_Order_id ");
    }, 
    Order_Order_Number: function(component, event, helper) {
        var Shopify_Order = component.get("v.Order_Name");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Order_Name ");
    }, 
    Orders_Count: function(component, event, helper) {
        var Shopify_Order = component.get("v.Orders_Count");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Orders_Count ");
    },   
    Order_Total_Price: function(component, event, helper) {
        var Shopify_Order = component.get("v.Total_Price");
        var SalesforceField_val = event.getSource().get("v.value");
        
        var Shopifymapping = component.get("v.OrderShopifyMapping");
        Shopifymapping.push(Shopify_Order);
        console.log('in Shopifymapping '+Shopifymapping);
        
        var Salesforcemapping = component.get("v.OrderSalesforceMapping");
        Salesforcemapping.push(SalesforceField_val);
        console.log('in Salesforcemapping '+Salesforcemapping);
        
        var array = component.get("v.Ordermapping");
        var obj = {};
        obj[Shopify_Order] = SalesforceField_val;
        array.push(obj);
        component.set("v.Ordermapping",array);
        component.set("v.OrderShopifyMapping",Shopifymapping);
        component.set("v.OrderSalesforceMapping",Salesforcemapping);
        console.log("Order Total_Price ");
    },
    
    onSelectChange: function(component, event, helper) {
        component.set("v.searchKeyword",'');
        component.set("v.messageshow", 'slds-hide');
        console.log('Set value');
        var ProductDataType = component.get("v.ProductDataType");
        var pageNumber = 1;
        component.set("v.PageNumber",pageNumber);
        var pageSize = component.find("pageSize").get("v.value");
        console.log('value : '+pageSize);
        component.set("v.pageSize",pageSize); 
        helper.callaction(component,event,helper,ProductDataType);
    },
    Next: function(component, event, helper) {
        console.log('1');
        //component.set("v.messageshow", 'slds-hide');
        console.log('2');
        var pageNumber = component.get("v.PageNumber"); 
         console.log('3');
        var pageSize = component.find("pageSize").get("v.value");
        console.log('4');
        pageNumber++;
        console.log('5');
        var fetchkey = component.get("v.searchKeyword");
        console.log('6');
        console.log('getting search key '+fetchkey);
       // if(fetchkey.length === 0 || !fetchkey.trim()){
        if(fetchkey == undefined || !fetchkey.trim()){    
            console.log('7');
            component.set("v.PageNumber", pageNumber);
            component.set("v.pageSize", pageSize);
            helper.callaction(component, event,helper);       
        }
        else{
             component.set("v.PageNumber", pageNumber);
            component.set("v.pageSize", pageSize);
            console.log('8');
            helper.SearchHelper(component, event,helper);
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    
    Prev: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        var fetchkey = component.get("v.searchKeyword");
        console.log('getting search key '+fetchkey);
        if(fetchkey == undefined || !fetchkey.trim() ){
             console.log('previous pass');
            component.set("v.PageNumber", pageNumber);
            component.set("v.pageSize", pageSize);
            helper.callaction(component, event,helper);        
        }
        else{
             console.log('previous 8');
            component.set("v.PageNumber", pageNumber);
            component.set("v.pageSize", pageSize);
            helper.SearchHelper(component, event,helper);
        }
    },
    
    deleteshop: function(component, event, helper) {
     
        console.log('pro3');
        var deleteID = event.target.getAttribute('data-value');
        var action = component.get("c.deleteAccount");
        
        action.setParams(
            {
                "id": deleteID
                
            }
        );
        action.setCallback(this, function(response) {
            
            if (response.getState() === "SUCCESS" ){
                
                alert('Record Deleted');
            }
            else{
                alert('Not deleted');
            }
        //component.set("v.shoplist",response.getReturnValue());
        });
        $A.enqueueAction(action);
 },
       
})