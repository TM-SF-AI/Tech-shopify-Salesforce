({
    getSynchronizedList: function(component,event,helper, pageNumber, pageSize) {
        var action = component.get("c.getSynchronizedOrderDetails");
        console.log('action '+action);
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
                component.set("v.ProductList", resultData.orderList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.messageshow", 'slds-show');
                var msg =  'Success';
                console.log('msg'+msg);
                if(msg.includes("errors")){
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
    Getallorderdata : function(component,event,helper, pageNumber, pageSize) {
        var action = component.get("c.getAllOrderList");
        console.log('action '+action);
        action.setParams({
            "shopid": component.get("v.Shopid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize
            
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('result.getReturnValue()'+result.getReturnValue());
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('response : '+resultData);
                component.set("v.ProductList", resultData.allOrderList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }
        });
        $A.enqueueAction(action);
    },
    getSalesforceOrderList: function(component, pageNumber, pageSize) {
        console.log('in the salesforceOrderList helper');
        var action = component.get("c.getSalesforceOrderList");
        console.log('action '+action);
        action.setParams({
             "shopid": component.get("v.Shopid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('State '+state);
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('List : '+resultData.salesforceOrderList);
                component.set("v.ProductList", resultData.salesforceOrderList);
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
    getShopifyList: function(component,event,helper, pageNumber, pageSize) {
        console.log('in the getShopifyList helper');
        var action = component.get("c.getShopifyData");
        action.setParams({
             "shopid": component.get("v.Shopid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize
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
        var action = component.get("c.getAllOrderList");
        console.log("action",action);
        var shopids = component.get("v.Shopid");
        console.log("Shopid: ",shopids);
        
        action.setParams({
            "shopid": shopids,
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log('State ',state);
            if (component.isValid() && state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('result data ',resultData);
                component.set("v.ProductList", resultData.allOrderList);
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
    
    SearchHelper: function(component, event,OrderDataType,pageNumber, pageSize) {
        console.log('in search helper ');
        var action = component.get("c.fetchSearchOrder");
        
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword"),
            "shopid": component.get("v.Shopid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "OrderType":OrderDataType
        });
        action.setCallback(this, function(response) {
            console.log("4");
            // hide spinner when response coming from server 
            
            var state = response.getState();
            if (state === "SUCCESS") {
                 var resultData = response.getReturnValue();
                component.set("v.ProductList", resultData.OrderList);
                console.log("ProductList : "+resultData.OrderList.length);
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
        var action = component.get("c.deleteSingleOrder");
        action.setParams({
            accid : component.get("v.deleteProductid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid"),
            "OrderDataType":component.get("v.OrderDataType")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.deletedSingleorderList);
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
        var action = component.get("c.syncSingleOrder");
        
        action.setParams({
            id : component.get("v.SyncProductid"),
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.singlesyncorderList);
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
        var action = component.get('c.deleteMultipleOrders');
        action.setParams({
            "lstRecordId": productid,
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid":component.get("v.Shopid"),
             "OrderDataType":component.get("v.OrderDataType")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                component.find("box3").set("v.value", false);
                component.set("v.ProductList", resultData.deletedmultipleorderList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                console.log(resultData.deletedmultipleorderList);
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                if(msg.includes("error")){
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
        debugger;
        console.log('Helper exporttoShopifySingleHelper is called');
        var action = component.get('c.exportToShopify');
        action.setParams({
            "shopid": component.get("v.Shopid"),
            "variant_id": component.get("v.ExportOrderid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall back");
            if (state === "SUCCESS") {
                console.log("SUCCESS");
                var resultData = result.getReturnValue();
                component.set("v.messageshow", 'slds-show');
               
                if(resultData.includes("errors")){
                    component.set("v.messageType", 'error');
                    component.set("v.message", resultData);
                }
                else{
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Export Successfully!');  
                }
            }else{
                console.log("failed");
            }
        });
        $A.enqueueAction(action);
        console.log('End of Helper');
    },   
    ListOfOrderTypeHelper: function(component, event, OrderDataType,pageNumber, pageSize) {
         console.log("7");
        var action = component.get('c.Order_Type_Data');
        action.setParams({
            "OrderType": OrderDataType,
            "pageNumber": pageNumber,
            "pageSize": pageSize,
            "shopid": component.get("v.Shopid")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            console.log("InCall Product_Type_Data back");
            if (state === "SUCCESS") {
                var resultData = result.getReturnValue();
                component.set("v.ProductList", resultData.orderList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                console.log("TotalRecord"+ resultData.totalRecords)
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
            }else{
                console.log("failed ");
            }
        });
        $A.enqueueAction(action);
        console.log('End of ListOfProductTypeHelper Helper');
    },
     SyncConditionalOrderHelper: function(component, event, helper){
         var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        var action = component.get('c.getConditionalOrderSyncData');
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
                component.set("v.ProductList", resultData.orderList);
                component.set("v.PageNumber", resultData.pageNumber);
                component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                component.set("v.messageshow", 'slds-show');
                var msg =  'Success';
                console.log('msg'+msg);
                if(msg.includes("errors")){
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