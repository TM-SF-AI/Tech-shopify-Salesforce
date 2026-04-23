global class OrderMockTest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{'+
                '"orders": ['+
                  '  {'+
                       ' "id": 1993406414882,'+
                           ' "email": "freshorder@gmail.com",'+
            '"closed_at": null,'+
            '"created_at": "2020-02-20T11:55:28-05:00",'+
            '"updated_at": "2020-02-20T11:55:29-05:00",'+
            '"number": 101,'+
            '"note": null,'+
            '"token": "6b9706ba76c9a2596481d5cd79833f48",'+
            '"gateway": "",'+
            '"test": false,'+
            '"total_price": "59.25",'+
            '"subtotal_price": "59.25",'+
            '"total_price_usd": "59.25",'+
            '"checkout_token": null,'+
            '"processed_at": "2020-02-20T11:55:28-05:00",'+
            '"admin_graphql_api_id": "gid://shopify/Order/1993406414882",'+
           ' "shipping_lines": [],'+
                    '"billing_address": {'+
                '"first_name": "abhi",'+
                '"address1": "200 vardhman nagar ",'+
                '"phone": "+19823456879",'+
               ' "city": "jaipur",'+
                '"zip": "303030",'+
                '"province": "Alabama",'+
                '"country": "United States",'+
                '"last_name": "jain",'+
                '"address2": null,'+
               ' "company": "mm",'+
               ' "latitude": null,'+
                '"longitude": null,'+
                '"name": "abhi jain",'+
                '"country_code": "US",'+
                '"province_code": "AL"'+
         '   },'+
                   ' "line_items": ['+
               ' {'+
                    '"id": 4967477870626,'+
                    '"variant_id": 31122501435426,'+
                    '"title": "Paleo Meal Plan NL",'+
                    '"quantity": 1,'+
                    '"sku": "P-L-5",'+
                    '"variant_title": "Paleo Meal Plan - 1 Meal a Day",'+
                   ' "vendor": "Healthy Xpress",'+
                    '"fulfillment_service": "manual",'+
                    '"product_id": 4334864400418,'+
                    '"requires_shipping": false,'+
                    '"taxable": false,'+
                   ' "gift_card": false,'+
                    '"name": "Paleo Meal Plan NL - Paleo Meal Plan - 1 Meal a Day",'+
                    '"variant_inventory_management": null,'+
                    '"properties": [],'+
                   ' "product_exists": true,'+
                    '"fulfillable_quantity": 1,'+
                    '"grams": 4536,'+
                    '"price": "59.25",'+
                   ' "total_discount": "0.00",'+
                   ' "fulfillment_status": null,'+
                   ' "price_set": {'+
                        '"shop_money": {'+
                            '"amount": "59.25",'+
                           ' "currency_code": "USD"'+
                      '  },'+
                        '"presentment_money": {'+
                           ' "amount": "59.25",'+
                           ' "currency_code": "USD"'+
                       ' }'+
                   ' },'+
                    '"total_discount_set": {'+
                        '"shop_money": {'+
                            '"amount": "0.00",'+
                            '"currency_code": "USD"'+
                       ' },'+
                       ' "presentment_money": {'+
                           ' "amount": "0.00",'+
                           ' "currency_code": "USD"'+
                       ' }'+
                   ' },'+
                   ' "discount_allocations": [],'+
                    '"duties": [],'+
                    '"admin_graphql_api_id": "gid://shopify/LineItem/4967477870626",'+
                    '"tax_lines": []'+
              '  }'+
           ' ],'+
           ' "customer": {'+
               ' "id": 2876173942818,'+
                '"email": "freshorder@gmail.com",'+
                '"accepts_marketing": false,'+
                '"created_at": "2020-02-20T11:50:40-05:00",'+
               ' "updated_at": "2020-02-20T11:55:29-05:00",'+
                '"first_name": "fresh customer order",'+
               ' "last_name": null,'+
                '"orders_count": 2,'+
                '"state": "disabled",'+
               ' "total_spent": "118.50",'+
                '"last_order_id": 1993406414882,'+
                '"note": null,'+
                '"verified_email": true,'+
                '"multipass_identifier": null,'+
                '"tax_exempt": false,'+
                '"phone": null,'+
                '"tags": "",'+
                '"last_order_name": "#TR1101",'+
                '"currency": "USD",'+
                '"accepts_marketing_updated_at": "2020-02-20T11:50:41-05:00",'+
               ' "marketing_opt_in_level": null,'+
               ' "tax_exemptions": [],'+
                '"admin_graphql_api_id": "gid://shopify/Customer/2876173942818"'+
           ' }} ]}');
        res.setStatusCode(200);
        return res;
    }
}