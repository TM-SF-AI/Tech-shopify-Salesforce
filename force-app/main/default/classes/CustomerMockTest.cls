global class CustomerMockTest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"customers": [{'+
            '"id": 2876173942818,'+
            '"email": "freshorder@gmail.com",'+
            '"accepts_marketing": false,'+
            '"created_at": "2020-02-20T11:50:40-05:00",'+
            '"updated_at": "2020-02-20T11:55:29-05:00",'+
            '"first_name": "fresh customer order",'+
            '"last_name": null,'+
            '"orders_count": 2,'+
           ' "state": "disabled",'+
            '"total_spent": "118.50",'+
           ' "last_order_id": 1993406414882,'+
            '"note": null,'+
            '"verified_email": true,'+
            '"multipass_identifier": null,'+
           ' "tax_exempt": false,'+
           ' "phone": null,'+
           ' "tags": "",'+
            '"last_order_name": "#TR1101",'+
            '"currency": "USD",'+
            '"addresses": ['+
                   ' {'+
                   ' "id": 3040060178466,'+
                   ' "customer_id": 2876133736482,'+
                   ' "first_name": "a fresh test customer",'+
                   ' "last_name": null,'+
                    '"company": null,'+
                    '"address1": null,'+
                   ' "address2": null,'+
                   ' "city": null,'+
                   ' "province": null,'+
                   ' "country": null,'+
                   ' "zip": null,'+
                   ' "phone": "+1416-555-0824",'+
                    '"name": "a fresh test customer",'+
                    '"province_code": null,'+
                   ' "country_code": null,'+
                    '"country_name": null,'+
                    '"default": true'+
             '   }'+
                    '],'+
            '"accepts_marketing_updated_at": "2020-02-20T11:50:41-05:00",'+
            '"marketing_opt_in_level": null,'+
           ' "tax_exemptions": [],'+
            '"admin_graphql_api_id": "gid://shopify/Customer/2876173942818"}'+
        ']}');
        res.setStatusCode(200);
        return res;
    }
}