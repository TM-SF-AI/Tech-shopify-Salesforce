({   
    getShopNameList: function(component, event, helper) {
        console.log("Helper getShopNameList Function called");
        var action = component.get("c.getShopName");
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                // component.set("v.ShopName", resultData);
                var finalnames = [];
                for(var i =0;i<resultData.length;i++){
                    var url = resultData[i];
                    var hostname;
                    //find & remove protocol (http, ftp, etc.) and get hostname
                    if (url.indexOf("//") > -1) {
                        hostname = url.split('/')[2];
                    }
                    else {
                        hostname = url.split('/')[0];
                    }
                    //find & remove port number
                    hostname = hostname.split(':')[0];
                    //find ( . ) remove port number
                    hostname = hostname.split('.')[0];
                    //find & remove "?"
                    hostname = hostname.split('?')[0];
                    finalnames.push(hostname);
                }
                console.log("finalnames : "+finalnames);
            }
            
            else{
                console.log("Failed");
            }
        });
        console.log("Helper getShopNameList End");
        $A.enqueueAction(action);
    },
    getContactList: function(component, event,helper,pageNumber, pageSize) {
        console.log("Helper getContactList Function called");
         console.log("Value : ",component.get("v.Shopid"));
        var action = component.get("c.getProductData");
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
             //"shopid":  'a012w00000kxpP4AAI'
           "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.productList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.allids", resultData.productidsList);
               
                component.set("v.TotalRecords", resultData.totalRecords);
                //console.log('resultData.totalRecords ==> '+resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                console.log('TotalPages :',component.get("v.TotalPages"));
            }
            else{
                console.log("Failed");
                console.log('TotalPages :',component.get("v.TotalPages"));
            }
        });
        console.log("Helper getContactList End");
        $A.enqueueAction(action);
    },
    SearchHelper: function(component, event,helper,pageNumber, pageSize) {
         console.log("Value : ",pageNumber);
        console.log("Value : ",pageSize);
        // show spinner message
        component.find("Id_spinner").set("v.class" , 'slds-show');
        
        // component.set("v.HideButtons","slds-hide");
        var action = component.get("c.fetchSearchProduct");
        
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword"),
            "shopid": component.get("v.Shopid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "ProductType":component.get("v.ProductDataType")
        });
        action.setCallback(this, function(response) {
            console.log("4");
            // hide spinner when response coming from server 
            component.find("Id_spinner").set("v.class" , 'slds-hide');
            var state = response.getState();
            if (state === "SUCCESS") {
                 var resultData = response.getReturnValue();
                component.set("v.ProductList", resultData.productList);
                console.log("ProductList : "+resultData.productList.length);
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
            
        });
        $A.enqueueAction(action);
    },
    deleteProduct : function(component, event,helper,pageNumber, pageSize) {
        console.log('Helper');
        var action = component.get("c.deleteProductById");
        action.setParams({
            accid : component.get("v.deleteProductid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid"),
            "ProductDataType":component.get('v.ProductDataType')
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.productList);
                console.log("ProductList"+component.get("v.ProductList"));
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("errors")){
                    component.set("v.messageType", 'error');
                    var msg = component.get("v.deleteProductid")+resultData.message;
                    console.log('Msg :',msg);
                    component.set("v.message", resultData.message);
                    
                }
                else{
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Deleted Successfully!');  
                }
            }else{
                console.log("failed succeed");
            }
        });
        $A.enqueueAction(action);
        console.log('End of Helper');
    },
    Sync_single_Product_Data : function(component, event,helper,pageNumber, pageSize) {
        console.log('Helper');
        var action = component.get("c.Get_single_Product_Data");
        action.setParams({
            id : component.get("v.SyncProductid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid"),
             "ProductType":component.get('v.ProductDataType')
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                 console.log("succeed");
                
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.productList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }else{
                console.log("failed succeed");
            }
        });
        $A.enqueueAction(action);
        console.log('End of Helper');
    },
    Allsyncdata: function(component,event,helper,pageNumber,pageSize) {
        console.log("Helper called"); 
        var action = component.get("c.getProductSyncData");
        console.log("Shopid is :",component.get("v.Shopid"));
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid"),
           "Productfilter": component.get("v.ProductDataType") 
            //'searchKeyWord': component.get("v.searchKeyword")
        });
        console.log("Helper Parms pass called"); 
        action.setCallback(this, function(result) {
            console.log("Helper Parms get state"); 
            var state = result.getState();
            console.log("Helper Parms in action"); 
            if (component.isValid() && state === "SUCCESS") {
                var resultData = result.getReturnValue();
                console.log("resultdata" + resultData);
                component.set("v.ProductList", resultData.productList);
                console.log("ProductList"+component.get("v.ProductList"));
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                 
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("errors")){
                    component.set("v.messageType", 'error');
                   var msg = component.get("v.deleteProductid")+resultData.message;
                    console.log('Msg :',msg);
                    component.set("v.message", resultData.message);
                    
                }
                else{
                  
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Sync Successfully!');  
                }
             /*   console.log("Names: ",resultData.Shopnames); 
                var finalnames = [];
                for(var i =0;i<resultData.Shopnames.length;i++){
                    var url = resultData.Shopnames[i];
                    var hostname;
                    //find & remove protocol (http, ftp, etc.) and get hostname
                    if (url.indexOf("//") > -1) {
                        hostname = url.split('/')[2];
                    }
                    else {
                        hostname = url.split('/')[0];
                    }
                    //find & remove port number
                    hostname = hostname.split(':')[0];
                    //find ( . ) remove port number
                    hostname = hostname.split('.')[0];
                    //find & remove "?"
                    hostname = hostname.split('?')[0];
                    hostname = hostname[0].toUpperCase() + hostname.slice(1); 
                    finalnames.push(hostname);
                }
                component.set("v.ShopName", finalnames);
                */
            }
             else{
               console.log("failed sync");
            }
        });
        $A.enqueueAction(action);
        console.log("Helper Parms end log"); 
    },
    productFieldsNames: function(component, event,helper) {
        console.log("Helper productFieldsNames Function called");
        var action = component.get("c.productFieldsList");
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                component.set("v.options", opts);
            }
            
        });
        
        $A.enqueueAction(action);
    },
    deleteSelectedHelper: function(component, event, productid,pageNumber, pageSize) {
        var action = component.get('c.deleteProductById');
        action.setParams({
            "accid": productid,
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.productList);
                console.log("ProductList"+component.get("v.ProductList"));
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                console.log("TotalRecord"+ resultData.totalRecords)
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("errors")){
                    component.set("v.messageType", 'error');
                    var msg = component.get("v.deleteProductid")+resultData.message;
                    console.log('Msg :',msg);
                    component.set("v.message", resultData.message);
                    
                }
                else{
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Deleted Successfully!');  
                }
            }else{
                console.log("failed succeed");
            }
        });
        $A.enqueueAction(action);
        console.log('End of Helper');
    },
    ListOfProductTypeHelper: function(component, event, ProductDataType,pageNumber, pageSize) {
        var action = component.get('c.Product_Type_Data');
        action.setParams({
            "ProductType": ProductDataType,
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall Product_Type_Data back");
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.productList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                console.log("TotalRecord"+ resultData.totalRecords)
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.allids", resultData.productidsList);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }else{
                console.log("failed ");
            }
        });
        $A.enqueueAction(action);
        console.log('End of ListOfProductTypeHelper Helper');
    },
    
    exporttoShopifySingleHelper: function(component, event,helper) {
        
        console.log('Helper exporttoShopifySingleHelper is called');
        var action = component.get('c.exportToShopify');
        action.setParams({
            "shopid": component.get("v.Shopid"),
            "productId": component.get("v.ExportProductid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                console.log("SUCCESS");
                var resultData = result.getReturnValue();
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("errors")){
                    component.set("v.messageType", 'error');
                    component.set("v.message", resultData.message);
                }
                else{
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Exported Successfully!');  
                }
            }else{
                console.log("failed succeed");
            }
        });
        $A.enqueueAction(action);
        console.log('End of Helper');
         
    },
    
    getAllProductList: function(component, pageNumber, pageSize) {
        var action = component.get("c.getAllProductData");
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.productList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.allids", resultData.productidsList);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }
            else{
            }
        });
        $A.enqueueAction(action);
    },
    exporttoShopifyHelper: function(component, event,helper,ids,ShopidId) {
        console.log('Helper exporttoShopifyHelper is called');
        var action = component.get('c.exportToShopify');
        action.setParams({
            "shopid": ShopidId,
            "productId": ids
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                console.log("SUCCESS exporttoShopifyHelper");
                var resultData = result.getReturnValue();
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("errors")){
                    component.set("v.messageType", 'error');
                    component.set("v.message", resultData.message);
                }
                else{
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Export Successfully!');  
                }
            }else{
                console.log("failed succeed");
            }
        });
        $A.enqueueAction(action);
        console.log('End of exporttoShopifyHelper Helper');
    },
    SyncConditionalProductHelper: function(component, event, helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        var action = component.get('c.getConditionalProductSyncData');
        action.setParams({
            "Shopify_Updated_After": component.get("v.UpdatedAfter"),
            "Shopify_Updated_Before": component.get("v.UpdatedBefore"),
            "Shopify_Published_After": component.get("v.PublishedAfter"),
            "Shopify_Published_Before": component.get("v.PublishedBefore"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid"),
            "Productfilter": component.get("v.ProductDataType") 
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                console.log("succeed");
                component.set("v.ProductList", resultData.productList);
                console.log("ProductList"+component.get("v.ProductList"));
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                console.log("TotalRecord"+ resultData.totalRecords)
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("errors")){
                    component.set("v.messageType", 'error');
                    var msg = component.get("v.deleteProductid")+resultData.message;
                    console.log('Msg :',msg);
                    component.set("v.message", resultData.message);
                    
                }
                else{
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Sync Successfully!');  
                }
            }else{
                console.log("failed succeed");
            }
        });
        $A.enqueueAction(action);
        console.log('SyncConditionalProductHelper End of Helper');
    },
})