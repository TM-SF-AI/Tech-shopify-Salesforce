({
    doInit: function(component, event, helper) {

        component.set("v.messageshow", 'slds-hide');
        console.log('doinit function called ');
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.find("pageSize").get("v.value");
        console.log('shop id ',component.get("v.Shopid"));
        var Oname = component.find("orgtype").set("v.value",'Shopify');
        helper.getShopifyList(component,event,helper, pageNumber, pageSize);
    },
    SelectOrgType : function(component, event, helper,pageNumber, pageSize) {
        /*console.log('In SelectOrgType');
        var Oname = component.find("orgtype").get("v.value");
        console.log('orgname'+Oname);
        if (Oname == 'All') 
        {
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.find("pageSize").get("v.value");
            helper.getAllList(component,event,helper, pageNumber, pageSize);
        }
        else if (Oname == 'Shopify') 
        {
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.find("pageSize").get("v.value");
            helper.getShopifyList(component, pageNumber, pageSize);
        }
            else if (Oname == 'Salesforce')
            {
                var pageNumber = component.get("v.PageNumber");
                var pageSize = component.find("pageSize").get("v.value");
                helper.getSalesforceOrderList(component, pageNumber, pageSize);
            }
        
        component.set("v.OrderDataType",Oname);
        */
        
        component.set("v.searchKeyword",'');
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = 1;  
        var pageSize = component.find("pageSize").get("v.value");
        var OrderDataType = event.getSource().get("v.value");
        console.log("Value is : "+ OrderDataType);
        component.set("v.OrderDataType ", OrderDataType);
        helper.ListOfOrderTypeHelper(component, event, OrderDataType,pageNumber, pageSize);
    },
  
    Productcomponent: function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Product_data_table",
            componentAttributes: {
                Shopid : component.get("v.Shopid")
            }
        });
        evt.fire();
    },
    selectTab : function(component, event, helper) {
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
    Search: function(component, event, helper,pageNumber, pageSize) {
        component.set("v.messageshow", 'slds-hide');
        var OrderDataType =  component.get("v.OrderDataType");
        console.log('OrderDataType : '+OrderDataType);
        var fetchkey = component.get("v.searchKeyword");
        console.log('getting search key '+fetchkey);
        if(fetchkey.length === 0 || !fetchkey.trim()){
            console.log('ListOfOrderTypeHelper ');
            var pageNumber = component.get("v.PageNumber");  
            var pageSize = component.find("pageSize").get("v.value");
            helper.ListOfOrderTypeHelper(component, event, OrderDataType,pageNumber, pageSize);
        }
        else{
            console.log('SearchHelper ');
            var pageNumber = 1;  
            var pageSize = component.find("pageSize").get("v.value");
            helper.SearchHelper(component, event,OrderDataType,pageNumber, pageSize);
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
        
        /*if(fetchkey.length === 0 || !fetchkey.trim()){
            var pageNumber = component.get("v.PageNumber");  
            var pageSize = component.find("pageSize").get("v.value");
            var Oname = component.find("orgtype").get("v.value");
            if (Oname == 'All') 
            {
                helper.getAllList(component,event,helper, pageNumber, pageSize);
            }
            else if (Oname == 'Shopify') 
            {
                helper.getShopifyList(component, pageNumber, pageSize);
            }
                else if (Oname == 'Salesforce')
                {
                    helper.getSalesforceOrderList(component, pageNumber, pageSize);
                }
        }else{
            console.log('SearchHelper called');
            helper.getShopifyList(component, pageNumber, pageSize);
           // helper.SearchHelper(component,event);
        }*/
    },
    createNewCustomer : function (component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "TechnologyMind__ShopifyOrders__c"
        });
        createRecordEvent.fire();
    },
    
    SyncAllData : function(component, event, helper,pageNumber, pageSize) {
        debugger;
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        console.log('shopid ',component.get("v.Shopid"));
        helper.getSynchronizedList(component,event,helper, pageNumber, pageSize);
    },
    
    handleNext: function(component, event, helper) {
        
         component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber++;
        var OrderDataType =  component.find("orgtype").get("v.value");
        console.log("Value is : "+ OrderDataType);
      
        var fetchkey = component.get("v.searchKeyword");
        console.log('getting search key '+fetchkey);
          console.log("5");
         helper.ListOfOrderTypeHelper(component, event, OrderDataType,pageNumber, pageSize); 
       
        //console.log("6");
       /* if(fetchkey.length === 0 || !fetchkey.trim()){
             console.log("Value is in if : "+ OrderDataType);
              helper.ListOfOrderTypeHelper(component, event, OrderDataType,pageNumber, pageSize);        
           // helper.getContactList(component, event,helper,pageNumber, pageSize);
        }
        else{
             console.log("Value is in else : "+ OrderDataType);
            helper.SearchHelper(component, event,OrderDataType,pageNumber, pageSize);
        }*/
        var empty = [];
         console.log("1");
        component.set("v.totalids", empty);
        console.log("2");
        component.set("v.selectedCount", 0);
         console.log("3");
        component.find("box3").set("v.value", false);
     console.log("Value is in end ");
        
    },
    
    handlePrev: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        
        
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value");
        pageNumber--;
        var OrderDataType =  component.find("orgtype").get("v.value");
        console.log("Value is : "+ OrderDataType);
      
         console.log("5");
         helper.ListOfOrderTypeHelper(component, event, OrderDataType,pageNumber, pageSize); 
        
        
        
        /*
        var Oname = component.find("orgtype").get("v.value");
        console.log('orgname'+Oname);
        if (Oname == 'All') 
        {
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.find("pageSize").get("v.value");
            pageNumber--;
            helper.getAllList(component,event,helper, pageNumber, pageSize);
        }
        else if (Oname == 'Shopify') 
        {
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.find("pageSize").get("v.value");
            pageNumber--;
            helper.getShopifyList(component, pageNumber, pageSize);
        }
            else if (Oname == 'Salesforce')
            {
                var pageNumber = component.get("v.PageNumber");
                var pageSize = component.find("pageSize").get("v.value");
                pageNumber--;
                helper.getSalesforceOrderList(component, pageNumber, pageSize);
            }
        */
    },
    
    onSelectChange: function(component, event, helper) {
        component.set("v.searchKeyword",'');
        console.log('2');
        component.set("v.messageshow", 'slds-hide');
        console.log('1');
        var OrderDataType = component.get("v.OrderDataType");
        console.log('orgname :'+OrderDataType);
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.find("pageSize").get("v.value");
        helper.ListOfOrderTypeHelper(component, event, OrderDataType,pageNumber, pageSize);
       /* if (Oname == 'All') 
        {
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.find("pageSize").get("v.value");
            helper.getAllList(component,event,helper, pageNumber, pageSize);
        }
        else if (Oname == 'Shopify') 
        {
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.find("pageSize").get("v.value");
            helper.getShopifyList(component, pageNumber, pageSize);
        }
            else if (Oname == 'Salesforce')
            {
                var pageNumber = component.get("v.PageNumber");
                var pageSize = component.find("pageSize").get("v.value");
                helper.getSalesforceOrderList(component, pageNumber, pageSize);
            }*/
    },
    
    DeleteProduct :function(component, event, helper,pageNumber, pageSize){
        
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        var val =  event.getSource().get("v.value");
        component.set('v.deleteProductid', val);
        //console.log('Value '+ val);
        //alert('Are you sure ?');
        var r = confirm('Are you sure?');
        if (r == true) {
            console.log("You pressed OK!");
            helper.deleteProduct(component, event, helper,pageNumber, pageSize);
        } else {
            console.log("You pressed Cancel!");
        }
        
        
    },
    
    
    SyncProduct :function(component, event, helper,pageNumber, pageSize){
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        var val =  event.getSource().get("v.value");
        component.set('v.SyncProductid', val);  
        console.log('Sync id :'+val); 
        helper.Sync_single_Customer_Data(component, event, helper,pageNumber, pageSize);
    },
    
    checkboxSelect: function(component, event, helper,pageNumber, pageSize) {
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.find("pageSize").get("v.value");
        var tolalselectedid =  component.get("v.totalids");
        
        var emptyarry = [];
        var selectedRec = event.getSource().get("v.checked");
        var getSelectedNumber = component.get("v.selectedCount");
        if(getSelectedNumber==pageSize){
            component.find("box3").set("v.value", true);
        }
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
        console.log("All ids = "+tolalselectedid)
    },
    
    selectAll: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var selectedHeaderCheck = event.getSource().get("v.value");
        console.log('selectedHeaderCheck ',selectedHeaderCheck);
        var tolalid =  component.get("v.allids");
        var getAllId = component.find("boxPack");
        console.log('value of box pack',getAllId);
        var emptyarry = [];
        if (selectedHeaderCheck == true) {
            for (var i = 0; i < getAllId.length; i++) {
                console.log('i',i);
                component.find("boxPack")[i].set("v.checked", true);
                component.set("v.totalids", tolalid);
                component.set("v.selectedCount", tolalid.length);
                console.log("length : "+tolalid.length);
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
    
    deleteSelected: function(component, event, helper,pageNumber, pageSize) {
        debugger;
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.find("pageSize").get("v.value");
        var listtodelete = component.get("v.totalids");
        //alert(listtodelete);
        var getAllId = component.find("boxPack");
        if(listtodelete.length > 0){
            var r = confirm('Are you sure?');
            if (r == true) {
                for (var i = 0; i < listtodelete.length; i++) {
                    var productid = listtodelete[i];
                    console.log("id "+productid);
                    helper.deleteSelectedHelper(component, event, productid,pageNumber, pageSize);
                }
            }
            else {
                console.log("You pressed Cancel!");
            }
        }
        else{
            alert('Select Any Order From List');
        }
        var emty='';
        component.set("v.searchKeyword",emty);
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
    },
    
    ShowFilterDiv : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideFilterDiv");
        if(abc == 'slds-show'){
            component.set("v.HideFilterDiv",'slds-hide');
        }
        else{
            component.set("v.HideFilterDiv",'slds-show');
        }
        
    },
    
    ShowName : function(component, event, helper){
        var abc =  component.get("v.HideName");
        if(abc == 'slds-show'){
            component.set("v.HideName",'slds-hide');
        }
        else{
            component.set("v.HideName",'slds-show');
        }
        
    },
    
    ShowFirstName : function(component, event, helper){
        var abc =  component.get("v.HideFirstName");
        if(abc == 'slds-show'){
            component.set("v.HideFirstName",'slds-hide');
        }
        else{
            component.set("v.HideFirstName",'slds-show');
        }
        
    },
    
    ShowLastName : function(component, event, helper){
        var abc =  component.get("v.HideLastName");
        if(abc == 'slds-show'){
            component.set("v.HideLastName",'slds-hide');
        }
        else{
            component.set("v.HideLastName",'slds-show');
        }
        
    },
    ShowEmail : function(component, event, helper){
        var abc =  component.get("v.HideEmail");
        if(abc == 'slds-show'){
            component.set("v.HideEmail",'slds-hide');
        }
        else{
            component.set("v.HideEmail",'slds-show');
        }
        
    },
    ShowShopifyBillingAddress : function(component, event, helper){
        var abc =  component.get("v.HideShopifyBillingAddress");
        if(abc == 'slds-show'){
            component.set("v.HideShopifyBillingAddress",'slds-hide');
        }
        else{
            component.set("v.HideShopifyBillingAddress",'slds-show');
        }
        
    },
    
    
    ShowCreatedDate : function(component, event, helper){
        var abc =  component.get("v.HideCreatedDate");
        if(abc == 'slds-show'){
            component.set("v.HideCreatedDate",'slds-hide');
        }
        else{
            component.set("v.HideCreatedDate",'slds-show');
        }
        
    },
    ShowCustomerID : function(component, event, helper){
        var abc =  component.get("v.HideCustomerID");
        if(abc == 'slds-show'){
            component.set("v.HideCustomerID",'slds-hide');
        }
        else{
            component.set("v.HideCustomerID",'slds-show');
        }
        
    },
    ShowOrderStatus : function(component, event, helper){
        var abc =  component.get("v.HideOrderStatus");
        if(abc == 'slds-show'){
            component.set("v.HideOrderStatus",'slds-hide');
        }
        else{
            component.set("v.HideOrderStatus",'slds-show');
        }
        
    },
    ShowShopifyOrderID : function(component, event, helper){
        var abc =  component.get("v.HideShopifyOrderID");
        if(abc == 'slds-show'){
            component.set("v.HideShopifyOrderID",'slds-hide');
        }
        else{
            component.set("v.HideShopifyOrderID",'slds-show');
        }
    },
    ShowAddress1 : function(component, event, helper){
        var abc =  component.get("v.HideAddress1");
        if(abc == 'slds-show'){
            component.set("v.HideAddress1",'slds-hide');
        }
        else{
            component.set("v.HideAddress1",'slds-show');
        }
    },
    ShowAddress2: function(component, event, helper){
        var abc =  component.get("v.HideAddress2");
        if(abc == 'slds-show'){
            component.set("v.HideAddress2",'slds-hide');
        }
        else{
            component.set("v.HideAddress2",'slds-show');
        }
    },
    ShowCity: function(component, event, helper){
        var abc =  component.get("v.HideCity");
        if(abc == 'slds-show'){
            component.set("v.HideCity",'slds-hide');
        }
        else{
            component.set("v.HideCity",'slds-show');
        }
    },
    ShowState: function(component, event, helper){
        var abc =  component.get("v.HideState");
        if(abc == 'slds-show'){
            component.set("v.HideState",'slds-hide');
        }
        else{
            component.set("v.HideState",'slds-show');
        }
    },
    ShowCountry: function(component, event, helper){
        var abc =  component.get("v.HideCountry");
        if(abc == 'slds-show'){
            component.set("v.HideCountry",'slds-hide');
        }
        else{
            component.set("v.HideCountry",'slds-show');
        }
    },
    Showzipcode: function(component, event, helper){
        var abc =  component.get("v.Hidezipcode");
        if(abc == 'slds-show'){
            component.set("v.Hidezipcode",'slds-hide');
        }
        else{
            component.set("v.Hidezipcode",'slds-show');
        }
    },
    ShowCreatedDate: function(component, event, helper){
        var abc =  component.get("v.HideCreatedDate");
        if(abc == 'slds-show'){
            component.set("v.HideCreatedDate",'slds-hide');
        }
        else{
            component.set("v.HideCreatedDate",'slds-show');
        }
    },
     Showphone: function(component, event, helper){
        var abc =  component.get("v.Hidephone");
        if(abc == 'slds-show'){
            component.set("v.Hidephone",'slds-hide');
        }
        else{
            component.set("v.Hidephone",'slds-show');
        }
    },
     ShowshopifycreatedDate: function(component, event, helper){
        var abc =  component.get("v.HideshopifycreatedDate");
        if(abc == 'slds-show'){
            component.set("v.HideshopifycreatedDate",'slds-hide');
        }
        else{
            component.set("v.HideshopifycreatedDate",'slds-show');
        }
    },
    ShowshopifyupdatedDate: function(component, event, helper){
        var abc =  component.get("v.HideshopifyupdatedDate");
        if(abc == 'slds-show'){
            component.set("v.HideshopifyupdatedDate",'slds-hide');
        }
        else{
            component.set("v.HideshopifyupdatedDate",'slds-show');
        }
    },
     Showordercount: function(component, event, helper){
        var abc =  component.get("v.HideOrderCount");
        if(abc == 'slds-show'){
            component.set("v.HideOrderCount",'slds-hide');
        }
        else{
            component.set("v.HideOrderCount",'slds-show');
        }
    },
    
    ShowTotalPrice: function(component, event, helper){
        var abc =  component.get("v.HideTotalPrice");
        if(abc == 'slds-show'){
            component.set("v.HideTotalPrice",'slds-hide');
        }
        else{
            component.set("v.HideTotalPrice",'slds-show');
        }
    },
    exporttoShopifySingle: function(component, event, helper) {
        //debugger
        component.set("v.messageshow", 'slds-hide');
        var ids = event.target.getAttribute('data-Id');
        var ShopidId =  component.get("v.Shopid");
      
        component.set("v.ExportOrderid", ids);
        helper.exporttoShopifySingleHelper(component, event,helper);
    },
    
    exporttoShopifySelected: function(component, event, helper) {
        debugger;
        component.set("v.messageshow", 'slds-hide');
        var ShopidId =  component.get("v.Shopid");
        var listtoexport = component.get("v.totalids");
        var delId = [];
        for (var i = 0; i < listtoexport.length; i++) {
            var ids = listtoexport[i];
            console.log("id  : "+ids);
            component.set('v.ExportOrderid',ids);
            helper.exporttoShopifySingleHelper(component, event,ids,ShopidId);
        }
        var empty = [];
        component.set("v.totalids", empty);
        component.set("v.selectedCount", 0);
        component.find("box3").set("v.value", false);
    },
   /*  SyncConditionalProduct: function(component, event, helper){
         var ToggleClass = component.get("v.ConditionalSyncToggleClass"); 
        if(ToggleClass == 'slds-hide'){
            component.set("v.ConditionalSyncToggleClass",'slds-show');
        }else{
             component.set("v.ConditionalSyncToggleClass",'slds-hide');
        }
    },   */
     SyncConditional: function(component, event, helper){
     //    alert('Sync clicked');
       helper.SyncConditionalOrderHelper(component, event, helper);
    },
})