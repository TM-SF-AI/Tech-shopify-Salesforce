({
    callaction : function(component,event,helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.pageSize");
        console.log("Helper Start : "+pageSize+'v' +pageNumber);
        var action = component.get("c.Adminconfig");
         action.setParams({
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
             
                var resultData = result.getReturnValue();
                component.set("v.Shoplist",resultData.config);
                component.set("v.Salesforcefields",resultData.Shopnames);
                component.set("v.SalesforceStringfields",resultData.ShopStringFields);
                 component.set("v.SalesforceEmailfields",resultData.ShopEmailFields);
                 component.set("v.SalesforcePhonefields",resultData.ShopPhoneFields);
                component.set("v.SalesforceNumberfields",resultData.ShopNumberFields);
                component.set("v.Productfields",resultData.Product);  
                 component.set("v.ProductStringFields",resultData.ProductStringFields);
                 component.set("v.ProductEmailFields",resultData.ProductEmailFields);
                component.set("v.ProductPhoneFields",resultData.ProductPhoneFields);
                component.set("v.ProductNumberFields",resultData.ProductNumberFields);
                component.set("v.OrderFields",resultData.Order);
                  component.set("v.OrderStringFields",resultData.orderStringFields);
                  component.set("v.OrderNumberFields",resultData.orderNumberFields);
                component.set("v.OrderPhoneFields",resultData.orderPhoneFields);
                component.set("v.OrderEmailFields",resultData.orderEmailFields);
                component.set("v.TotalRecords",component.get("v.Shoplist").length);
                 component.set("v.TotalRecords", resultData.totalRecords);
                component.set("v.RecordStart", resultData.recordStart);
                component.set("v.RecordEnd", resultData.recordEnd);
                component.set("v.Allshopid", resultData.AllShopID);
                component.set("v.TotalPages", Math.ceil(resultData.totalRecords / pageSize));
                console.log('TotalPages :',component.get("v.TotalPages"));
            }
            else{
                console.log("Failed");
            }
        });
        console.log("Helper getContactList End");
        $A.enqueueAction(action);
    },    
    Checkthetoken : function(component,event,helper,Password,Token,Url) {
        console.log("Checkthetoken  Start");
        var action = component.get("c.checkShopDetials");
        
        action.setParams({
            "Token": Token,
            "Passwords": Password,
            "Url": Url
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                console.log('resultData : ',resultData.message);
                component.set("v.messageshow", 'slds-show');
                var msg =  resultData.message;
                console.log('Message : '+msg);
                if(msg.includes("errors")){
                    component.set("v.messageType", 'error');
                    component.set("v.message", resultData.message);
                }
                else{
                    component.set("v.NewShopName", resultData.NewShopName);
                    component.set("v.ShopToken", resultData.ShopToken);
                    component.set("v.ShopPasswords", resultData.ShopPasswords);
                    var getselectedStep = component.get("v.selectedStep");
                    if(getselectedStep == "step1"){
                        component.set("v.selectedStep", "step2");
                    }
                    else if(getselectedStep == "step2"){
                        component.set("v.selectedStep", "step4");
                    }
                        else if(getselectedStep == "step4"){
                            component.set("v.selectedStep", "step5");
                        }
                            else if(getselectedStep == "step5"){
                                component.set("v.selectedStep", "step6");
                            }
                    component.set("v.messageshow", 'slds-hide');
                    component.set("v.messageType", 'success');
                    component.set("v.message", 'Success');
                }
                /*  var getselectedStep = component.get("v.selectedStep");
                    if(getselectedStep == "step1"){
                        component.set("v.selectedStep", "step2");
                    }
                    else if(getselectedStep == "step2"){
                        component.set("v.selectedStep", "step4");
                    }
                }*/
            }
            else{
                component.set("v.messageshow", 'slds-show');
                component.set("v.messageType", 'error');
                component.set("v.message", 'Please Fill Proper Details');
            }
        });
        $A.enqueueAction(action);
        console.log("Helper getContactList End");
        
    },
    CustomerFields : function(component,event,helper) {
        console.log("Helper Start");
        var action = component.get("c.AccountsFields");
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                var resultData = result.getReturnValue();
                component.set("v.Shoplist",resultData.config);
                component.set("v.Salesforcefields",resultData.Shopnames);
                component.set("v.TotalRecords",component.get("v.Shoplist").length);
            }
            else{
                console.log("Failed");
            }
        });
        console.log("Helper getContactList End");
        $A.enqueueAction(action);
    }, 
    checkfields : function(component,event,helper,pageNumber) {
        console.log("Helper checkfields Start");
        var value =component.get("v.Shopid");
        console.log("value : "+component.get("v.Shopid"));
        var action = component.get("c.Shopify_fields");
        action.setParams({
            "shopid": component.get("v.Shopid"),
            "msg": pageNumber
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS"){
                console.log('Get : ');
                var resultData = result.getReturnValue();
                console.log('resultData : '+resultData);
                console.log('resultData.config : '+resultData.Customer_Mapping);
                component.set("v.Customermapfields",resultData.Customer_Mapping);
                console.log('resultData.config');
                component.set("v.Productmapfields",resultData.Product_Mapping); 
                component.set("v.Ordermapfields",resultData.Order_Mapping);
                console.log('in Salesforcemapping ');
                var Customerfields = component.get("v.Customermapfields"); 
                
                var Shopify_Country_Code = component.get("v.Country_Code");
                var Created_at = component.get("v.Created_at");
                var MapCreated_at = component.get("v.MapCreated_at");
                var Customer_id = component.get("v.Customer_id");
                var MapCustomer_id = component.get("v.MapCustomer_id");
                var First_Name = component.get("v.First_Name");
                var MapFirst_Name = component.get("v.MapFirst_Name"); 
                var Last_Name = component.get("v.Last_Name");
                var MapLast_Name = component.get("v.MapLast_Name");
                var Last_Order_Name = component.get("v.Last_Order_Name");  
                var MapLast_Order_Name = component.get("v.MapLast_Order_Name");
                var Customer_Orders_Count = component.get("v.Customer_Orders_Count");  
                var MapCustomer_Orders_Count = component.get("v.MapCustomer_Orders_Count");  
                var Phone = component.get("v.Phone");  
                var MapPhone = component.get("v.MapPhone");  
                var Province_Code = component.get("v.Province_Code");  
                var MapProvince_Code = component.get("v.MapProvince_Code"); 
                var Total_Spent = component.get("v.Total_Spent");  
                var MapTotal_Spent = component.get("v.MapTotal_Spent");
                var Updated_at = component.get("v.Updated_at");
                var MapUpdated_at = component.get("v.MapUpdated_at"); 
                var Zip = component.get("v.Zip");
                var MapZip = component.get("v.MapZip");
                var Email = component.get("v.Email");
                var MapEmail = component.get("v.MapEmail"); 
                var Billing_State = component.get("v.Billing_State");
                var MapBilling_State = component.get("v.MapBilling_State");
                var Billing_Country = component.get("v.Billing_Country"); 
                var MapBilling_Country = component.get("v.MapBilling_Country");
                
                //customer fields
                for(var key in Customerfields)
                {
                    if(key == Shopify_Country_Code)
                    {
                        
                        component.set("v.testcountryfield", Customerfields[key]); 
                    }   
                    else if(key == Created_at){
                        console.log(' MapCreated_at ');
                        component.set("v.MapCreated_at", Customerfields[key]); 
                    }
                        else if(key == Customer_id){
                            console.log(' MapCustomer_id ');
                            component.set("v.MapCustomer_id", Customerfields[key]); 
                        }
                            else if(key == First_Name){
                                console.log(' MapFirst_Name ');
                                component.set("v.MapFirst_Name", Customerfields[key]); 
                            }
                                else if(key == Last_Name){
                                    console.log(' MapLast_Name ');
                                    component.set("v.MapLast_Name", Customerfields[key]); 
                                }else if(key == Last_Order_Name){
                                    console.log(' MapLast_Order_Name ');
                                    component.set("v.MapLast_Order_Name", Customerfields[key]); 
                                }else if(key == Customer_Orders_Count){
                                    console.log(' MapCustomer_Orders_Count ');
                                    component.set("v.MapCustomer_Orders_Count", Customerfields[key]); 
                                }
                                    else if(key == Phone){
                                        console.log(' MapPhone ');
                                        component.set("v.MapPhone", Customerfields[key]); 
                                    }
                                        else if(key == Province_Code){
                                            console.log(' MapProvince_Code ');
                                            component.set("v.MapProvince_Code", Customerfields[key]); 
                                        }else if(key == Updated_at){
                                            console.log(' MapUpdated_at ');
                                            component.set("v.MapUpdated_at", Customerfields[key]); 
                                        }
                                            else if(key == Zip){
                                                console.log(' MapZip ');
                                                component.set("v.MapZip", Customerfields[key]); 
                                            }
                                                else if(key == Email){
                                                    console.log(' MapEmail ');
                                                    component.set("v.MapEmail", Customerfields[key]); 
                                                }
                                                    else if(key == Billing_State){
                                                        console.log(' MapBilling_State ');
                                                        component.set("v.MapBilling_State", Customerfields[key]); 
                                                    }else if(key == Billing_Country){
                                                        console.log(' MapBilling_Country ');
                                                        component.set("v.MapBilling_Country", Customerfields[key]); 
                                                    }
                                                        else if(key == Total_Spent){
                                                            
                                                            component.set("v.MapTotal_Spent", Customerfields[key]); 
                                                        }
                    
                }
                //product fields
                var productfields = component.get("v.Productmapfields"); 
                var Title = component.get("v.Title");
                var MapTitle = component.get("v.MapTitle");
                var Product_type = component.get("v.Product_type");
                var MapProduct_type = component.get("v.MapProduct_type");
                var Vendor = component.get("v.Vendor");
                var MapVendor = component.get("v.MapVendor");
                var Handle = component.get("v.Handle"); 
                var MapHandle = component.get("v.MapHandle");
                var Product_Id = component.get("v.Product_Id");
                var MapProduct_Id = component.get("v.MapProduct_Id");  
                var Image_Src = component.get("v.Image_Src");
                var MapImage_Src = component.get("v.MapImage_Src");  
                var Variants_price = component.get("v.Variants_price");  
                var MapVariants_price = component.get("v.MapVariants_price");  
                var Tags = component.get("v.Tags");  
                var MapTags = component.get("v.MapTags");  
                
                for(var key in productfields)
                {
                    if(key == Title)
                    {
                        component.set("v.MapTitle", productfields[key]); 
                    }   
                    else if(key == Product_type){
                        console.log(' MapProduct_type ');
                        component.set("v.MapProduct_type", productfields[key]); 
                    }
                        else if(key == Vendor){
                            console.log(' MapVendor ');
                            component.set("v.MapVendor", productfields[key]); 
                        }
                            else if(key == Handle){
                                console.log(' Handle ');
                                component.set("v.MapHandle", productfields[key]); 
                            }
                                else if(key == Product_Id){
                                    console.log(' Product_Id ');
                                    component.set("v.MapProduct_Id", productfields[key]); 
                                }else if(key == Image_Src){
                                    console.log(' Image_Src ');
                                    component.set("v.MapImage_Src", productfields[key]); 
                                }else if(key == Variants_price){
                                    console.log(' MapVariants_price ');
                                    component.set("v.MapVariants_price", productfields[key]); 
                                }
                                    else if(key == Tags){
                                        console.log(' Tags ');
                                        component.set("v.MapTags", productfields[key]); 
                                    }
                    
                }
                
                
                //Order fields
                
                var Ordermapfields = component.get("v.Ordermapfields"); 
                var Address1 = component.get("v.Address1");
                var MapAddress1 = component.get("v.MapAddress1");
                var Address2 = component.get("v.Address2");
                var MapAddress2 = component.get("v.MapAddress2");
                var City = component.get("v.City");
                var MapCity = component.get("v.MapCity");
                var Contact_Email = component.get("v.Contact_Email"); 
                var MapContact_Email = component.get("v.MapContact_Email");
                var Country = component.get("v.Country");
                var MapCountry = component.get("v.MapCountry");  
                var Order_Customer_id = component.get("v.Order_Customer_id");
                var MapOrder_Customer_id = component.get("v.MapOrder_Customer_id");  
                var Order_First_Name = component.get("v.Order_First_Name");  
                var MapOrder_First_Name = component.get("v.MapOrder_First_Name");  
                var Order_Last_Name = component.get("v.Order_Last_Name");  
                var MapOrder_Last_Name = component.get("v.MapOrder_Last_Name");  
                var Last_Order_id = component.get("v.Last_Order_id");  
                var MapLast_Order_id = component.get("v.MapLast_Order_id");   
                var Order_Name = component.get("v.Order_Name");   
                var MapOrder_Name = component.get("v.MapOrder_Name");   
                var Orders_Count = component.get("v.Orders_Count");   
                var MapOrders_Count = component.get("v.MapOrders_Count");  
                var Total_Price = component.get("v.Total_Price");  
                var MapTotal_Price = component.get("v.MapTotal_Price");  
                var Order_ID = component.get("v.MapOrder_ID");  
                
                for(var key in Ordermapfields)
                {
                    if(key == Address1)
                    {
                        component.set("v.MapAddress1", Ordermapfields[key]); 
                    }   
                    else if(key == Address2){
                        console.log(' MapAddress2 ');
                        component.set("v.MapAddress2", Ordermapfields[key]); 
                    }
                        else if(key == City){
                            console.log(' City ');
                            component.set("v.MapCity", Ordermapfields[key]); 
                        }
                            else if(key == Contact_Email){
                                console.log(' Contact_Email ');
                                component.set("v.MapContact_Email", Ordermapfields[key]); 
                            }
                                else if(key == Country){
                                    console.log(' Country ');
                                    component.set("v.MapCountry", Ordermapfields[key]); 
                                }else if(key == Order_Customer_id){
                                    console.log(' Order_Customer_id ');
                                    component.set("v.MapOrder_Customer_id", Ordermapfields[key]); 
                                }else if(key == Order_First_Name){
                                    console.log(' Order_First_Name ');
                                    component.set("v.MapOrder_First_Name", Ordermapfields[key]); 
                                }
                                    else if(key == Order_Last_Name){
                                        console.log(' Order_Last_Name ');
                                        component.set("v.MapOrder_Last_Name", Ordermapfields[key]); 
                                    }
                                        else if(key == Last_Order_id){
                                            console.log(' Last_Order_id ');
                                            component.set("v.MapLast_Order_id", Ordermapfields[key]); 
                                        }
                                            else if(key == Order_Name){
                                                console.log(' Order_Name ');
                                                component.set("v.MapOrder_Name", Ordermapfields[key]); 
                                            }
                                                else if(key == Orders_Count){
                                                    console.log(' Orders_Count ');
                                                    component.set("v.MapOrders_Count", Ordermapfields[key]); 
                                                }
                                                    else if(key == Total_Price){
                                                        console.log(' Total_Price ');
                                                        component.set("v.MapTotal_Price", Ordermapfields[key]); 
                                                    }
                                                        else if(key == Order_ID){
                                                            console.log(' Order_ID ');
                                                            component.set("v.MapOrder_ID", Ordermapfields[key]); 
                                                        }
                    
                }
            }
            else{
                console.log("Failed");
            }
            
        });
        console.log("Helper checkfields End");
        $A.enqueueAction(action);
    }, 
    SearchHelper: function(component, event,helper) {
        var pageNumber = component.get("v.PageNumber");  
        var pageSize = component.get("v.pageSize");
        console.log("Helper Start");
        // show spinner message
        // component.set("v.HideButtons","slds-hide");
        var action = component.get("c.fetchSearchshophelper");
        action.setParams({
            'searchKeyWord': component.get("v.searchKeyword"),
            "pageNumber": pageNumber,
            "pageSize": pageSize
        });
        action.setCallback(this, function(response) {
            console.log("4");
            // hide spinner when response coming from server 
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
            
        });
        $A.enqueueAction(action);
    },
})