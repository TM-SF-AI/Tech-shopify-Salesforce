({
    doInit: function(component, event, helper) {
        //debugger;
        component.set("v.messageshow", 'slds-hide');
        console.log('value is ',component.get("v.PageNumber"));
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        var string = 'CreatedById CreatedDate DisplayUrl LastModifiedDate ';
        var string2 = string + 'ProductCode Shopify_Product_Price ';
        var string3 = string2 + 'Tag Shopify_Vendor_Name';
        var array = string3.split(" "); 
        var ProductDataType =  component.find("OrgType").set("v.value",'Shopify');
        component.set("v.options", array);
        helper.getContactList(component, event,helper,pageNumber, pageSize);
        //helper.ListOfProductTypeHelper(component, event, helper,pageNumber, pageSize);
        //helper.getAllProductList(component, pageNumber, pageSize);
    },
    createRecordProduct : function (component, event, helper) {
        //debugger;
        component.set("v.messageshow", 'slds-hide');
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Product2"
        });
        createRecordEvent.fire();
        //helper.getContactList(component, event,helper,pageNumber, pageSize);
        
    },  
    buttonpress : function(component, event, helper) {
        //deleteSelectedAll
        console.log('olla');
        helper.getShopNameList(component, event, helper);
    },
    selectTab : function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        /* General utility */
        
        var selected = component.get("v.key");
        component.find("tabs").set("v.selectedTabId",selected);
        
    },
    Configurationcomponent : function(component, event, helper) {
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Salesforce_Shopify",
             
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
    createRecordAccount : function (component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account"
        });
        createRecordEvent.fire();
    },
    GetShopname:function(component,event,helper)
    {  component.set("v.messageshow", 'slds-hide');
     var url =  component.get("v.shopurl");
     console.log("ALl shop"+url);
     var hostname;
     
     //find & remove protocol (http, ftp, etc.) and get hostname
     /*  if (url.indexOf("//") > -1) {
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
       // alert(hostname);*/
    },
    Search: function(component, event, helper,pageNumber, pageSize) {
        component.set("v.messageshow", 'slds-hide');
        // var searchkeylength = component.get("v.searchKeyword");
        var fetchkey = component.get("v.searchKeyword");
        console.log('getting search key '+fetchkey);
        if(fetchkey.length === 0 || !fetchkey.trim()){
            var pageNumber = component.get("v.PageNumber");  
            var pageSize = component.find("pageSize").get("v.value");
            var ProductDataType =  component.get("v.ProductDataType");
            helper.ListOfProductTypeHelper(component, event, ProductDataType,pageNumber, pageSize);
        }
        else{
            //var pageNumber = component.get("v.PageNumber");  
            var pageNumber = 1
            var pageSize = component.find("pageSize").get("v.value");
            helper.SearchHelper(component, event,helper,pageNumber, pageSize);
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    PreviewSalesforceProduct: function(component, event, helper) {
        console.log('Salesforce product');
      //  alert('Salesforce product');
      //  https://shopify-test-dev-ed.lightning.force.com
         var val =  event.getSource().get("v.value");
         window.open("/lightning/r/Product2/"+val+"/view/", '_blank');
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    PreviewProduct: function(component, event, helper,pageNumber, pageSize) {
        component.set("v.messageshow", 'slds-hide');
        var val =  event.getSource().get("v.value");
        var url = event.target.getAttribute('data-value');
        var productid = event.target.getAttribute('data-Id');
        console.log('Shopifyproductid :',productid);
         console.log('val :',val);
      //  console.log(String(url));
        var onload = String(url); 
        if(productid == null|| productid== undefined||productid == ''){
            alert('Preview is unavailable, please export the product.');
        }
        else{
            window.open(onload+"/products/"+val, '_blank'); 
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    handleNext: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        var ProductDataType =  component.find("OrgType").get("v.value");
        console.log("Value is : "+ ProductDataType);
      
        /*  if(ProductDataType == 'Salesforce'){
            helper.ListOfProductTypeHelper(component, event,ProductDataType,pageNumber, pageSize);
        }
        else if(ProductDataType == 'All'){
            helper.getAllProductList(component, pageNumber, pageSize);
        }   
            else if(ProductDataType =='Shopify'){
                helper.getContactList(component, event,helper,pageNumber, pageSize);
            }
        */
        var fetchkey = component.get("v.searchKeyword");
        console.log('getting search key '+fetchkey);
        if(fetchkey.length === 0 || !fetchkey.trim()){
              helper.ListOfProductTypeHelper(component, event,ProductDataType,pageNumber, pageSize);        
           // helper.getContactList(component, event,helper,pageNumber, pageSize);
        }
        else{
            helper.SearchHelper(component, event,helper,pageNumber, pageSize);
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    
    handlePrev: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        var ProductDataType =  component.find("OrgType").get("v.value");
        console.log("Value is : "+ ProductDataType);
       // helper.ListOfProductTypeHelper(component, event,ProductDataType,pageNumber, pageSize);  
       /* if(ProductDataType == 'Salesforce'){
            helper.ListOfProductTypeHelper(component, event,ProductDataType,pageNumber, pageSize);
        }
        else if(ProductDataType == 'All'){
            helper.getAllProductList(component, pageNumber, pageSize);
        }   
            else if(ProductDataType =='Shopify'){
                helper.getContactList(component, event,helper,pageNumber, pageSize);
            } */
        
         var fetchkey = component.get("v.searchKeyword");
        console.log('getting search key '+fetchkey);
        if(fetchkey.length === 0 || !fetchkey.trim()){
              helper.ListOfProductTypeHelper(component, event,ProductDataType,pageNumber, pageSize);        
           // helper.getContactList(component, event,helper,pageNumber, pageSize);
        }
        else{
            helper.SearchHelper(component, event,helper,pageNumber, pageSize);
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    
    onSelectChange: function(component, event, helper) {
        component.set("v.searchKeyword",'');
        component.set("v.messageshow", 'slds-hide');
        console.log('Set value');
        var ProductDataType = component.get("v.ProductDataType");
        var pageNumber = 1;
        var pageSize = component.find("pageSize").get("v.value");
         helper.ListOfProductTypeHelper(component, event,ProductDataType,pageNumber, pageSize);
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    
    //Select all contacts
    handleSelectAllContact: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var getID = component.get("v.productList");
        var checkvalue = component.find("selectAll").get("v.value");        
        var checkContact = component.find("checkContact"); 
        if(checkvalue == true){
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",true);
            }
        }
        else{ 
            for(var i=0; i<checkContact.length; i++){
                checkContact[i].set("v.value",false);
            }
        }
    },
    //Process the selected contacts
    handleSelectedContacts: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var selectedContacts = [];
        var checkvalue = component.find("checkContact");
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedContacts.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedContacts.push(checkvalue[i].get("v.text"));
                }
            }
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
        console.log('selectedContacts-' + selectedContacts);
    },
    filterProduct:function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var zipor = component.get('v.Toggleclass');
        if(zipor == 'slds-show'){
            
            component.set("v.Toggleclass", "slds-hide");
        }
        else{
            component.set("v.Toggleclass", "slds-show");
            console.log('else '+zipor);
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    
	activechange : function(component, event, helper) {
        var Active = component.get("v.activelable");
        if(Active == 'false') {
            component.set("v.activelable",true);
        } else {
            component.set("v.activelable",false);
        }
	},

    DeleteProduct :function(component, event, helper,pageNumber, pageSize){
        //  console.log(component.find("ButtonProducts").get("v.value"));
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        var val =  event.getSource().get("v.value");
        console.log('Type: ',component.get('v.ProductDataType'));
        component.set('v.deleteProductid', val);
        console.log('Value '+ val);
        //alert('Are you sure?');
        var r = confirm('Are you sure?');
        if (r == true) {
            console.log("You pressed OK!");
           helper.deleteProduct(component, event, helper,pageNumber, pageSize);
        } else {
            console.log("You pressed Cancel!");
        }
       
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
   SyncConditionalProduct: function(component, event, helper){
         var ToggleClass = component.get("v.ConditionalSyncToggleClass"); 
        if(ToggleClass == 'slds-hide'){
            component.set("v.ConditionalSyncToggleClass",'slds-show');
        }else{
             component.set("v.ConditionalSyncToggleClass",'slds-hide');
        }
    },  
     SyncConditional: function(component, event, helper){
     //    alert('Sync clicked');
       helper.SyncConditionalProductHelper(component, event, helper);
    },
     
    
    deleteSelectedAll: function(component, event, helper,pageNumber, pageSize) {
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.find("pageSize").get("v.value");
        var listtodelete = component.get("v.totalids");
        var delId = [];
        if(listtodelete.length > 0){
            var r = confirm('Are you sure?');
            if (r == true) {
                for (var i = 0; i < listtodelete.length; i++) {
                    console.log("You pressed OK!");
                    var productid = listtodelete[i];
                    console.log("id "+productid);
                    helper.deleteSelectedHelper(component, event, productid,pageNumber, pageSize);
                }
            } else {
                console.log("You pressed Cancel!");
            }
        }
        else{
            alert('Select Any Product From List');
        }
        component.find("box3").set("v.value", false);
        console.log("4");
        var getAllId = component.find("boxPack"); 
        console.log("5");
        var emptyarry = [];
        console.log("5.1");
        for (var i = 0; i < getAllId.length; i++) {
            console.log("5.6");
            component.find("boxPack")[i].set("v.checked", false);
            console.log("5.0");
            component.set("v.totalids", emptyarry);
           }
        console.log("6");
    },
    singleSyncProduct :function(component, event, Helper,pageNumber, pageSize){
        component.set("v.messageshow", 'slds-hide');
        //  console.log(component.find("ButtonProducts").get("v.value"));
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        var val =  event.getSource().get("v.value");
        component.set('v.SyncProductid', val);  
        console.log('Sync id :'+val);  
        var ProductDataType =  component.find("OrgType").get("v.value");
        console.log("Value is : "+ ProductDataType);
        /* if(ProductDataType == 'Salesforce'|| ProductDataType =='Shopify' ){
            helper.ListOfProductTypeHelper(component, event,ProductDataType,pageNumber, pageSize);
        }
        else{
            helper.Sync_single_Product_Data(component, event, helper,pageNumber, pageSize);    
        }
        */        
        helper.Sync_single_Product_Data(component, event, Helper,pageNumber, pageSize);    
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    SyncProduct:function(component, event, helper,pageNumber, pageSize){
        debugger;
        component.set("v.messageshow", 'slds-hide');
      //  console.log(component.find("ButtonProducts").get("v.value"));
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        // var ProductDataType =  component.find("OrgType").get("v.value");
      //  console.log("Value is : "+ ProductDataType);
       // component.set("v.ProductDataType", ProductDataType);
        helper.Allsyncdata(component, event, helper,pageNumber, pageSize);
       var empty = [];
        component.set("v.totalids", empty);
       component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    productFields :function(component, event, helper){
        console.log("Function called");
    },
    checkboxSelect: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var tolalselectedid =  component.get("v.totalids");
        console.log("totalids is "+tolalselectedid);
        var emptyarry = [];
        var selectedRec = event.getSource().get("v.checked");
        var getSelectedNumber = component.get("v.selectedCount");   
        var ids = event.target.getAttribute('data-Id');
        if (selectedRec == true) {
            getSelectedNumber++;
            tolalselectedid.push(ids);
        } else {
            getSelectedNumber--;
            for( var i = 0; i < tolalselectedid.length; i++){ 
                if ( tolalselectedid[i] === ids) {
                    tolalselectedid.splice(i, 1); 
                    i--;
                }
            }
            component.find("box3").set("v.value", false);
        }
        component.set("v.totalids",tolalselectedid); 
        component.set("v.selectedCount",getSelectedNumber); 
        
        var tolalid =  component.get("v.allids");
        if (getSelectedNumber == tolalid.length) {
            component.find("box3").set("v.value", true);
            
        }
    },
    selectAll: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var selectedHeaderCheck = event.getSource().get("v.value");
        var tolalid =  component.get("v.allids");
        var getAllId = component.find("boxPack");     
        var emptyarry = [];
        if (selectedHeaderCheck == true) {
            for (var i = 0; i < getAllId.length; i++) {
                component.find("boxPack")[i].set("v.checked", true);
                component.set("v.totalids", tolalid);
                component.set("v.selectedCount", tolalid.length);
                console.log("lenght : "+tolalid.length);
            }
        } else {
            for (var i = 0; i < getAllId.length; i++) {
                component.find("boxPack")[i].set("v.checked", false);
                component.set("v.totalids", emptyarry);
                component.set("v.selectedCount", 0);
                console.log("lenght : "+tolalid.length);
            }
        }
    },
    onCheck: function(component, event, helper) {
        debugger;
        component.set("v.messageshow", 'slds-hide');
        var checked = event.getSource().get("v.value");
        var value = event.getSource().get("v.text");
        console.log("value is checked is : "+value);
        console.log("Checked Value is : "+checked);
        
        if(value == 'Id'){
            var abc =  component.get("v.IdHide");
            if(abc == 'slds-show' ){
                component.set("v.IdHide",'slds-hide');
            }
            else{
                component.set("v.IdHide",'slds-show');
            }
        }
        else if(value == 'CreatedById'){
            var abc =  component.get("v.CreatedByIdHide");
            if(abc == 'slds-show' ){
                component.set("v.CreatedByIdHide",'slds-hide');
            }
            else{
                component.set("v.CreatedByIdHide",'slds-show');
            }
        }  
            else if(value == 'CreatedDate'){
                var abc =  component.get("v.CreatedDateHide");
                if(abc == 'slds-show' ){
                    component.set("v.CreatedDateHide",'slds-hide');
                }
                else{
                    component.set("v.CreatedDateHide",'slds-show');
                }
            }  
              /*  else if(value == 'Description'){
                    var abc =  component.get("v.DescriptionHide");
                    if(abc == 'slds-show' ){
                        component.set("v.DescriptionHide",'slds-hide');
                    }
                    else{
                        component.set("v.DescriptionHide",'slds-show');
                    }
                } */
                    else if(value == 'DisplayUrl'){
                        var abc =  component.get("v.DisplayUrlHide");
                        if(abc == 'slds-show' ){
                            component.set("v.DisplayUrlHide",'slds-hide');
                        }
                        else{
                            component.set("v.DisplayUrlHide",'slds-show');
                        }
                    }
                        else if(value == 'LastModifiedDate'){
                            var abc =  component.get("v.LastModifiedDateHide");
                            if(abc == 'slds-show' ){
                                component.set("v.LastModifiedDateHide",'slds-hide');
                            }
                            else{
                                component.set("v.LastModifiedDateHide",'slds-show');
                            }
                        }
                            else if(value == 'IsActive'){
                                var abc =  component.get("v.IsActiveHide");
                                if(abc == 'slds-show' ){
                                    component.set("v.IsActiveHide",'slds-hide');
                                }
                                else{
                                    component.set("v.IsActiveHide",'slds-show');
                                }
                            }
                                else if(value == 'IsDeleted'){
                                    var abc =  component.get("v.IsDeletedHide");
                                    if(abc == 'slds-show' ){
                                        component.set("v.IsDeletedHide",'slds-hide');
                                    }
                                    else{
                                        component.set("v.IsDeletedHide",'slds-show');
                                    } 
                                }
                                    else if(value == 'ProductCode'){
                                        var abc =  component.get("v.ProductCodeHide");
                                        if(abc == 'slds-show' ){
                                            component.set("v.ProductCodeHide",'slds-hide');
                                        }
                                        else{
                                            component.set("v.ProductCodeHide",'slds-show');
                                        } 
                                    }  
                                      /*  else if(value == 'Shopify_Handle'){
                                            var abc =  component.get("v.Shopify_HandleHide");
                                            if(abc == 'slds-show' ){
                                                component.set("v.Shopify_HandleHide",'slds-hide');
                                            }
                                            else{
                                                component.set("v.Shopify_HandleHide",'slds-show');
                                            } 
                                        }  
                                            else if(value == 'Shopify_Product_Type'){
                                                var abc =  component.get("v.Shopify_Product_TypeHide");
                                                if(abc == 'slds-show' ){
                                                    component.set("v.Shopify_Product_TypeHide",'slds-hide');
                                                }
                                                else{
                                                    component.set("v.Shopify_Product_TypeHide",'slds-show');
                                                } 
                                            }  */ 
                                                else if(value == 'Shopify_Product_Description'){
                                                    var abc =  component.get("v.Shopify_Product_DescriptionHide");
                                                    if(abc == 'slds-show' ){
                                                        component.set("v.Shopify_Product_DescriptionHide",'slds-hide');
                                                    }
                                                    else{
                                                        component.set("v.Shopify_Product_DescriptionHide",'slds-show');
                                                    }  
                                                } 
                                                    else if(value == 'Shopify_Shop_Url'){
                                                        var abc =  component.get("v.Shopify_Shop_UrlHide");
                                                        if(abc == 'slds-show' ){
                                                            component.set("v.Shopify_Shop_UrlHide",'slds-hide');
                                                        }
                                                        else{
                                                            component.set("v.Shopify_Shop_UrlHide",'slds-show');
                                                        }  
                                                    }  
                                                        else if(value == 'Tag'){
                                                            var abc =  component.get("v.TagHide");
                                                            if(abc == 'slds-show' ){
                                                                component.set("v.TagHide",'slds-hide');
                                                            }
                                                            else{
                                                                component.set("v.TagHide",'slds-show');
                                                            }  
                                                        } 
                                                           else if(value == 'Shopify_Vendor_Name'){
                                                            var abc =  component.get("v.VendorName");
                                                            if(abc == 'slds-show' ){
                                                                component.set("v.VendorName",'slds-hide');
                                                            }
                                                            else{
                                                                component.set("v.VendorName",'slds-show');
                                                            }  
                                                        } 
                                                          else if(value == 'Shopify_Product_Price'){
                                                            var abc =  component.get("v.PriceHide");
                                                            if(abc == 'slds-show' ){
                                                                component.set("v.PriceHide",'slds-hide');
                                                            }
                                                            else{
                                                                component.set("v.PriceHide",'slds-show');
                                                            }  
                                                        } 
        
    },
    ListOfProductType: function(component, event, helper,pageNumber, pageSize) {
        component.set("v.searchKeyword",'');
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = 1;  
        var pageSize = component.find("pageSize").get("v.value");
        var ProductDataType =  event.getSource().get("v.value");
        console.log("Value is : "+ ProductDataType);
        component.set("v.ProductDataType", ProductDataType);
        helper.ListOfProductTypeHelper(component, event,ProductDataType,pageNumber, pageSize);
    },
    exporttoShopifySingle: function(component, event, helper,pageNumber, pageSize) {
        component.set("v.messageshow", 'slds-hide');
        var ids = event.getSource().get("v.value");
        var ShopidId =  component.get("v.Shopid");
        console.log("data is : "+ ids); 
        component.set("v.ExportProductid", ids);
        console.log("Shopid is : "+ ShopidId); 
        helper.exporttoShopifySingleHelper(component, event,helper);
    },
    
    exporttoShopifySelected: function(component, event, helper,pageNumber, pageSize) {
        debugger;
        component.set("v.messageshow", 'slds-hide');
        var ShopidId =  component.get("v.Shopid");
        var listtoexport = component.get("v.totalids");
        console.log("ShopidId :  "+ShopidId);
        var delId = [];
        for (var i = 0; i < listtoexport.length; i++) {
            var ids = listtoexport[i];
            console.log("id  : "+ids);
            helper.exporttoShopifyHelper(component, event,helper,ids,ShopidId);
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
    
    
    ChooseFieldDisplay: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var ShopidId =  component.get("v.Shopid");
        var display =  component.get("v.fieldDisplay");
        
        if(display == 'slds-hide'){
            component.set("v.fieldDisplay", 'slds-show');
        }
        else{
            component.set("v.fieldDisplay", 'slds-hide');
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
     EditProduct: function(component, event, helper) {
     }
})