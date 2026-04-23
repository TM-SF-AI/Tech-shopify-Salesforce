({
    doInit: function(component, event, helper){
        
        component.set("v.messageshow", 'slds-hide');
        console.log('doinit function called ');
        var Oname = component.find("orgtype").get("v.value");
        var pageNumber = component.get("v.PageNumber");
        var pageSize = component.find("pageSize").get("v.value");
        var ProductDataType =  component.find("orgtype").set("v.value",'Shopify');
        helper.getCustomerAllData(component,event,helper, pageNumber, pageSize);
    },
    Productcomponent: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
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
        component.set("v.messageshow", 'slds-hide');
        /* General utility */
        var selected = component.get("v.key");
        component.find("tabs").set("v.selectedTabId",selected);
    },
    Configurationcomponent : function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:Salesforce_Shopify",
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
    SelectOrgType : function(component, event, helper,pageNumber, pageSize) {
        component.set("v.messageshow", 'slds-hide');
        console.log('In SelectOrgType');
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
                helper.getAccountList(component, pageNumber, pageSize);
            }
         component.set("v.CustomerDataType", Oname);
        //console.log('CustomerDataType : '+component.get("v.CustomerDataType"));
    },
    Search: function(component, event, helper,pageNumber, pageSize) {
         component.set("v.messageshow", 'slds-hide');
        // var searchkeylength = component.get("v.searchKeyword");
        var fetchkey = component.get("v.searchKeyword");
        console.log('getting search key '+fetchkey);
        if(fetchkey.length === 0 || !fetchkey.trim()){
            var pageNumber = component.get("v.PageNumber");  
            var pageSize = component.find("pageSize").get("v.value");
            var CustomerDataType =  component.get("v.CustomerDataType");
            helper.ListOfCustomerTypeHelper(component, event, CustomerDataType,pageNumber, pageSize);
        }
        else{
            var pageNumber = 1;  
            var pageSize = component.find("pageSize").get("v.value");
            helper.SearchHelper(component, event,helper,pageNumber, pageSize);
        }
        
      /*  component.set("v.messageshow", 'slds-hide');
        var fetchkey = component.get("v.searchKeyword");
        console.log('getting search key '+fetchkey);
        if(fetchkey.length === 0 || !fetchkey.trim()){
            var pageNumber = component.get("v.PageNumber"); 
            if(pageNumber == 'undefined'){
                pageNumber = 1;
            }
            var pageSize = component.find("pageSize").get("v.value");
            var Oname = component.find("orgtype").get("v.value");
            console.log('Oname' +Oname);
            if (Oname == 'All') 
            {
                if(pageNumber == 'undefined'){
                    pageNumber = 1;
                }
                helper.getAllList(component,event,helper, pageNumber, pageSize);
            }
            else if (Oname == 'Shopify') 
            {
                if(pageNumber == 'undefined'){
                    pageNumber = 1;
                }
                helper.getShopifyList(component, pageNumber, pageSize);
            }
                else if (Oname == 'Salesforce')
                {
                    if(pageNumber == 'undefined'){
                        pageNumber = 1;
                    }
                    helper.getAccountList(component, pageNumber, pageSize);
                }
        }else{
            var pageNumber = component.get("v.PageNumber");  
            if(pageNumber == 'undefined'){
                pageNumber = 1;
            }
            console.log('Number : '+pageNumber);
            var pageSize = component.find("pageSize").get("v.value");
            console.log('SearchHelper called');
            helper.SearchHelper(component,event,helper, pageNumber, pageSize);
        }*/
    },
    createNewCustomer : function (component, event, helper){
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Account"
        });
        createRecordEvent.fire();
    },
    SyncAllData : function(component, event, helper,pageNumber, pageSize) {
debugger;        
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        helper.getSynchronizedList(component,event,helper, pageNumber, pageSize);
    },
    handleNext: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
        var Oname = component.find("orgtype").get("v.value");
        console.log('orgname'+Oname);
        if (Oname == 'All') 
        {
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.find("pageSize").get("v.value");
            pageNumber++;
            helper.getAllList(component,event,helper, pageNumber, pageSize);
        }
        else if (Oname == 'Shopify') 
        {
            var pageNumber = component.get("v.PageNumber");
            var pageSize = component.find("pageSize").get("v.value");
            pageNumber++;
            helper.getShopifyList(component, pageNumber, pageSize);
        }
            else if (Oname == 'Salesforce')
            {
                var pageNumber = component.get("v.PageNumber");
                var pageSize = component.find("pageSize").get("v.value");
                pageNumber++;
                helper.getAccountList(component, pageNumber, pageSize);
            }
        
    },
    handlePrev: function(component, event, helper) {
        component.set("v.messageshow", 'slds-hide');
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
                helper.getAccountList(component, pageNumber, pageSize);
            }
    },
    onSelectChange: function(component, event, helper) {
         component.set("v.searchKeyword",'');
        component.set("v.messageshow", 'slds-hide');
        var page = 1
        var Oname = component.find("orgtype").get("v.value");
        console.log('orgname'+Oname);
        if (Oname == 'All') 
        {
           // var pageNumber = component.get("v.PageNumber");
           var pageNumber = 1;
            var pageSize = component.find("pageSize").get("v.value");
            helper.getAllList(component,event,helper, pageNumber, pageSize);
        }
        else if (Oname == 'Shopify') 
        {
            //var pageNumber = component.get("v.PageNumber");
             var pageNumber = 1;
            var pageSize = component.find("pageSize").get("v.value");
            helper.getShopifyList(component, pageNumber, pageSize);
        }
            else if (Oname == 'Salesforce')
            {
               // var pageNumber = component.get("v.PageNumber");
                 var pageNumber = 1;
                var pageSize = component.find("pageSize").get("v.value");
                helper.getAccountList(component, pageNumber, pageSize);
            }
        
    },
    DeleteProduct :function(component, event, helper,pageNumber, pageSize){
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");  
        
        var pageSize = component.find("pageSize").get("v.value"); 
        var val =  event.getSource().get("v.value");
        component.set('v.deleteProductid', val);
        console.log('Value '+ val);
        //alert('Are you sure ?');
        //confirm('Are you sure?');
        
        
        var r = confirm('Are you sure?');
        if (r == true) {
            console.log("You pressed OK!");
          helper.deleteProduct(component, event, helper,pageNumber, pageSize);
        } else {
            console.log("You pressed Cancel!");
        }
        var emty='';
        component.set("v.searchKeyword",emty);
    },
    SyncProduct :function(component, event, helper,pageNumber, pageSize){
        component.set("v.messageshow", 'slds-hide');
        component.set("v.messageshow", 'slds-hide');
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.find("pageSize").get("v.value"); 
        var val =  event.getSource().get("v.value");
        component.set('v.SyncProductid', val);  
        console.log('Sync id :'+val); 
        helper.Sync_single_Customer_Data(component, event, helper,pageNumber, pageSize);
        var emty='';
        component.set("v.searchKeyword",emty);
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
        var getAllId = component.find("boxPack");
        if(listtodelete.length > 0){
            var r = confirm('Are you sure?');
            if (r == true) {
                for (var i = 0; i < listtodelete.length; i++) {
                    console.log("You pressed OK!");
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
            alert('Select Any Customer From List');
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
    
    ShowCustomerID : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideCustomerID");
        if(abc == 'slds-show'){
            component.set("v.HideCustomerID",'slds-hide');
        }
        else{
            component.set("v.HideCustomerID",'slds-show');
        }
    },
    
    ShowConditionalSyncDiv : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideConditionalSyncDiv");
        if(abc == 'slds-show'){
            component.set("v.HideConditionalSyncDiv",'slds-hide');
        }
        else{
            component.set("v.HideConditionalSyncDiv",'slds-show');
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
    
    ShowID : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideId");
        if(abc == 'slds-show'){
            component.set("v.HideId",'slds-hide');
        }
        else{
            component.set("v.HideId",'slds-show');
        }
    },
    ShowName : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideName");
        if(abc == 'slds-show'){
            component.set("v.HideName",'slds-hide');
        }
        else{
            component.set("v.HideName",'slds-show');
        }
    },
    ShowShopifyBillingAddress : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideShopifyBillingAddress");
        if(abc == 'slds-show'){
            component.set("v.HideShopifyBillingAddress",'slds-hide');
        }
        else{
            component.set("v.HideShopifyBillingAddress",'slds-show');
        }
    },
    
    ShowOrderCount : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideOrderCount");
        if(abc == 'slds-show'){
            component.set("v.HideOrderCount",'slds-hide');
        }
        else{
            component.set("v.HideOrderCount",'slds-show');
        }
    },
    ShowZIPCode : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideZIPCode");
        if(abc == 'slds-show'){
            component.set("v.HideZIPCode",'slds-hide');
        }
        else{
            component.set("v.HideZIPCode",'slds-show');
        }
    },
    ShowProvinceCode : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideProvinceCode");
        if(abc == 'slds-show'){
            component.set("v.HideProvinceCode",'slds-hide');
        }
        else{
            component.set("v.HideProvinceCode",'slds-show');
        }
    },
    ShowCountryCode : function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideCountryCode");
        if(abc == 'slds-show'){
            component.set("v.HideCountryCode",'slds-hide');
        }
        else{
            component.set("v.HideCountryCode",'slds-show');
        }
    },
    ShowShopifyCreatedDate: function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideShopifyCreatedDate");
        if(abc == 'slds-show'){
            component.set("v.HideShopifyCreatedDate",'slds-hide');
        }
        else{
            component.set("v.HideShopifyCreatedDate",'slds-show');
        }
    },
    ShowAccountCreatedDate: function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideAccountCreatedDate");
        if(abc == 'slds-show'){
            component.set("v.HideAccountCreatedDate",'slds-hide');
        }
        else{
            component.set("v.HideAccountCreatedDate",'slds-show');
        }
    },
    ShowShopifyUpdatedDate: function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideShopifyUpdatedDate");
        if(abc == 'slds-show'){
            component.set("v.HideShopifyUpdatedDate",'slds-hide');
        }
        else{
            component.set("v.HideShopifyUpdatedDate",'slds-show');
        }
    },
    ShowAccountUpdatedDate: function(component, event, helper){
        component.set("v.messageshow", 'slds-hide');
        var abc =  component.get("v.HideAccountUpdatedDate");
        if(abc == 'slds-show'){
            component.set("v.HideAccountUpdatedDate",'slds-hide');
        }
        else{
            component.set("v.HideAccountUpdatedDate",'slds-show');
        }
    },
    ShowEmail: function(component, event, helper){
        var abc =  component.get("v.HideEmail");
        if(abc == 'slds-show'){
            component.set("v.HideEmail",'slds-hide');
        }
        else{
            component.set("v.HideEmail",'slds-show');
        }
    },
    LastOrderName: function(component, event, helper){
        var abc =  component.get("v.HideLastOrderName");
        if(abc == 'slds-show'){
            component.set("v.HideLastOrderName",'slds-hide');
        }
        else{
            component.set("v.HideLastOrderName",'slds-show');
        }
    },
    TotalSpent: function(component, event, helper){
        var abc =  component.get("v.HideTotalSpent");
        if(abc == 'slds-show'){
            component.set("v.HideTotalSpent",'slds-hide');
        }
        else{
            component.set("v.HideTotalSpent",'slds-show');
        }
    },
     ShowIndustry: function(component, event, helper){
        var abc =  component.get("v.HideIndustry");
        if(abc == 'slds-show'){
            component.set("v.HideIndustry",'slds-hide');
        }
        else{
            component.set("v.HideIndustry",'slds-show');
        }
    },
     ShowEmployees: function(component, event, helper){
        var abc =  component.get("v.HideEmployees");
        if(abc == 'slds-show'){
            component.set("v.HideEmployees",'slds-hide');
        }
        else{
            component.set("v.HideEmployees",'slds-show');
        }
    },
     ShowAnnualRevenue: function(component, event, helper){
        var abc =  component.get("v.HideAnnualRevenue");
        if(abc == 'slds-show'){
            component.set("v.HideAnnualRevenue",'slds-hide');
        }
        else{
            component.set("v.HideAnnualRevenue",'slds-show');
        }
    },
     ShowOwnership: function(component, event, helper){
        var abc =  component.get("v.HideOwnership");
        if(abc == 'slds-show'){
            component.set("v.HideOwnership",'slds-hide');
        }
        else{
            component.set("v.HideOwnership",'slds-show');
        }
    },
    exporttoShopifySingle: function(component, event, helper,pageNumber, pageSize) {
        component.set("v.messageshow", 'slds-hide');
        var ids = event.target.getAttribute('data-Id');
        var ShopidId =  component.get("v.Shopid");
        component.set("v.ExportAccountid", ids);
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
           component.set('v.ExportAccountid',ids);
            helper.exporttoShopifySingleHelper(component, event,helper,ids,ShopidId);
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
    }, */
     SyncConditional: function(component, event, helper){
     //    alert('Sync clicked');
       helper.SyncConditionalCustomerHelper(component, event, helper);
    }, 
})