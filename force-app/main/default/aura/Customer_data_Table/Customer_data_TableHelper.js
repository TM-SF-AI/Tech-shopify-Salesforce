({   
    getSynchronizedList: function(component,event,helper,pageNumber,pageSize) {
        debugger;
        var action = component.get("c.getCustomerData");
        console.log('In Customer Shopid :  '+component.get("v.Shopid"));
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('result.getReturnValue()'+result.getReturnValue());
            if (component.isValid() && state === "SUCCESS"){
                
                var resultData = result.getReturnValue();
                console.log('response : '+resultData);
                component.set("v.ProductList", resultData.accountList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("error")){
                    component.set("v.messageType", 'error');
                    component.set("v.message", resultData.message);
                }
                else{
                    component.find("orgtype").set("v.value",'Shopify');
                    
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Sync Successfully!');  
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getCustomerAllData: function(component,event,helper, pageNumber, pageSize) {
        var action = component.get("c.getCustomerAllData");
        console.log('In Customer Shopid :  '+component.get("v.Shopid"));
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('result.getReturnValue()'+result.getReturnValue());
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('response : '+resultData);
                component.set("v.ProductList", resultData.accountList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                

            }
        });
        $A.enqueueAction(action);
    },
    
    
    getAccountList: function(component, pageNumber, pageSize) {
        console.log('in the getAccountList helper');
        var action = component.get("c.getAccountData");
        console.log('action '+action);
        console.log('Shopid '+component.get("v.Shopid"));
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('State '+state);
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('List : '+resultData.contactList);
                component.set("v.ProductList", resultData.contactList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.selectedCount", 0);
            }
        });
        $A.enqueueAction(action);
    },      
    getAlllistdoint: function(component,event,helper, pageNumber, pageSize) {
        console.log('in the getAlllistdoint helper');
        var action = component.get("c.getAllDoinitData");
        console.log("action",action);
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('State ',state);
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('result data ',resultData);
                component.set("v.ProductList", resultData.allList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.selectedCount", 0);
                component.find("box3").set("v.value", false);
                var list = component.get("v.ProductList");
                var ids=[];
                list.forEach(function(element){
                    ids.push(element.Id);  
                });
                component.set("v.allids", ids);
                
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
                console.log("finalnames : "+finalnames);
                component.set("v.ShopName", finalnames);
            }
        });
        $A.enqueueAction(action);
    },
    getShopifyList: function(component, pageNumber, pageSize) {
        console.log('in the getShopifyList helper');
        var action = component.get("c.getShopifyData");
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('state ',state);
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.shopifyList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.selectedCount", 0);
                component.find("box3").set("v.value", false);
            }
        });
        $A.enqueueAction(action);
    },
    getAllList: function(component,event,helper, pageNumber, pageSize) {
        console.log('in the getAllList helper');
        var action = component.get("c.getAllData");
        console.log("action",action);
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('State ',state);
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('result data ',resultData);
                component.set("v.ProductList", resultData.allList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.selectedCount", 0);
                component.find("box3").set("v.value", false);
                var list = component.get("v.ProductList");
                var ids=[];
                list.forEach(function(element){
                    ids.push(element.Id);  
                });
                component.set("v.allids", ids);
            }
        });
        $A.enqueueAction(action);
    },
    
    /*SearchHelper: function(component,event,helper, pageNumber, pageSize) {
        console.log('in search helper ',pageNumber);
        var action = component.get("c.fetchSearchProduct");
        console.log('action '+action);
        action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            'searchKeyWord': component.get("v.searchKeyword"),
            "shopid": component.get("v.Shopid"),
            "OrgType" :component.find("orgtype").get("v.value")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //component.set("v.TotalNumberOfRecord", storeResponse.length);
                //component.set("v.ProductList", storeResponse); 
                component.set("v.ProductList", response.shopifyList);
                component.set("v.PageNumber", response.pageNumber);
                component.set("v.TotalRecords", response.totalRecords);
                component.set("v.RecordStart", response.recordStart);
                component.set("v.RecordEnd", response.recordEnd);
                component.set("v.TotalPages", Math.ceil(response.totalRecords / pageSize));
                
                
            }
        });
        $A.enqueueAction(action);
    },*/
    
    SearchHelper: function(component, event,helper,pageNumber, pageSize) {
         console.log("Value : ",pageNumber);
        console.log("Value : ",component.get("v.CustomerDataType"));
        // show spinner message
       
        
        // component.set("v.HideButtons","slds-hide");
        var action = component.get("c.fetchSearchCustomer");
        
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword"),
            "shopid": component.get("v.Shopid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "AccountType":component.get("v.CustomerDataType")
        });
        action.setCallback(this, function(response) {
            console.log("4");
            // hide spinner when response coming from server 
            var state = response.getState();
            console.log("5");
            if (state === "SUCCESS") {
                console.log("6");
                 var resultData = response.getReturnValue();
                console.log("7");
                component.set("v.ProductList", resultData.accountList);
                console.log("ProductList : "+resultData.accountList.length);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                // set numberOfRecord attribute value with length of return value from server
                //component.set("v.TotalNumberOfRecord", resultData.totalRecords);
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
            "CustomerDataType":component.get("v.CustomerDataType")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.accountList2);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("errors")){
                    component.set("v.messageType", 'error');
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
    Sync_single_Customer_Data : function(component, event,helper,pageNumber, pageSize) {
        console.log('Helper');
        var action = component.get("c.syncsinglecustomer");
        action.setParams({
            id : component.get("v.SyncProductid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.accountList);
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
    deleteSelectedHelper: function(component, event, productid,pageNumber, pageSize) {
        var action = component.get('c.deleteRecords');
        action.setParams({
            "lstRecordId": productid,
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.find("box3").set("v.value", false);
                component.set("v.ProductList", resultData.deleteList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                // component.set("v.message", resultData.message); 
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("errors")){
                    component.set("v.messageType", 'error');
                    component.set("v.message", resultData.message);
                }
                else{
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Deleted Successfully!');  
                }
            }
        });
        $A.enqueueAction(action);
    },
    exporttoShopifySingleHelper: function(component, event,helper) {
        console.log('Helper exporttoShopifySingleHelper is called');
        var action = component.get('c.exportToShopify');
        action.setParams({
            "shopid": component.get("v.Shopid"),
            "Accountid": component.get("v.ExportAccountid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                console.log("SUCCESS");
                var resultData = result.getReturnValue();
                component.set("v.messageshow", 'slds-show');
               var msg =  resultData.message;
                if(resultData.includes("errors")){
                    component.set("v.messageType", 'error');
                    component.set("v.message", resultData.message);
                }
                else{
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Exported Successfully!');  
                }
            }else{
                console.log("failed");
            }
        
        });
        $A.enqueueAction(action);
        console.log('End of Helper');
           
    },
    ListOfCustomerTypeHelper: function(component, event, CustomerDataType,pageNumber, pageSize) {
        var action = component.get('c.ListOfCustomerTypeHelper');
        action.setParams({
            "AccountType": CustomerDataType,
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall Product_Type_Data back");
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.accountList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                console.log("TotalRecord"+ resultData.totalRecords)
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
               // component.set("v.allids", resultData.productidsList);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }else{
                console.log("failed ");
            }
        });
        $A.enqueueAction(action);
        console.log('End of ListOfProductTypeHelper Helper');
    },
    SyncConditionalCustomerHelper: function(component, event, helper){
         var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        var action = component.get('c.getConditionalCustomerSyncData');
        action.setParams({
            "Shopify_Updated_After": component.get("v.UpdatedAfter"),
            "Shopify_Updated_Before": component.get("v.UpdatedBefore"),
            "Shopify_Created_After": component.get("v.CreatedAfter"),
            "Shopify_Created_Before": component.get("v.CreatedBefore"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                console.log('response : '+resultData);
                component.set("v.ProductList", resultData.accountList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("error")){
                    component.set("v.messageType", 'error');
                    component.set("v.message", resultData.message);
                }
                else{
                    component.find("orgtype").set("v.value",'Shopify');
                    
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Sync Successfully!');  
                }
            }
        });
        $A.enqueueAction(action);
        console.log('SyncConditionalProductHelper End of Helper');
    },
})