@isTest
public class RequestJSON2TestClass {

    @istest static void testparse(){
        String jsonresult = '{"products": [{"id": 4448856145993,"title": "Test 1","body_html": "Teeste12312","vendor": "asds","product_type": "asd","created_at":'+
                    '"2020-05-04T17:40:07+05:30","handle": "test-1","updated_at": "2020-05-04T17:40:09+05:30",'+
                    ' "published_at": "2020-05-04T17:38:52+05:30",'+
                    '"template_suffix": "",'+
                    ' "published_scope": "web",'+
                    '"tags": "",'+
                    ' "admin_graphql_api_id": "gid:4448856145993",'+
                    ' "variants": ['+
                    '  {'+
                    '  "id": 31466017292361,'+
                    '"product_id": 4448856145993,'+
                    ' "title": "Default Title",'+
                    ' "price": "124.00",'+
                    ' "sku": "1",'+
                    ' "position": 1,'+
                    '  "inventory_policy": "deny",'+
                    '"compare_at_price": "142.00",'+
                    '"fulfillment_service": "manual",'+
                    ' "inventory_management": "shopify",'+
                    '"option1": "Default Title",'+
                    '  "option2": null,'+
                    ' "option3": null,'+
                    ' "created_at": "2020-05-04T17:40:07+05:30",'+
                    ' "updated_at": "2020-05-04T17:40:07+05:30",'+
                    ' "taxable": true,'+
                    ' "barcode": "1",'+
                    '  "grams": 0,'+
                    '"image_id": null,'+
                    '"weight": 0.0,'+
                    '"weight_unit": "kg",'+
                    '"inventory_item_id": 33217510801481,'+
                    '"inventory_quantity": 6,'+
                    ' "old_inventory_quantity": 6,'+
                    ' "requires_shipping": true,'+
                    '"admin_graphql_api_id": "gid:31466017292361"'+
                    ' }'+
                    ' ],'+
                    ' "options": ['+
                    ' {'+
                    '"id": 5783628578889,'+
                    '"product_id": 4448856145993,'+
                    ' "name": "Title",'+
                    '"position": 1,'+
                    '"values": ['+
                    '"Default Title"'+
                    ' ]'+
                    ' }'+
                    ' ],'+
                    ' "images": ['+
                    ' {'+
                    '"id": 13900708544585,'+
                    ' "product_id": 4448856145993,'+
                    '"position": 1,'+
                    '"created_at": "2020-05-04T17:40:09+05:30",'+
                    ' "updated_at": "2020-05-04T17:40:09+05:30",'+
                    '"alt": null,'+
                    '"width": 1920,'+
                    '"height": 1080,'+
                    ' "src": "https://cdn.shopify.com/s/files/1/0276/5556/9481/products/0.24.jpg?v=1588594209",'+
                    '"variant_ids": [],'+
                    '"admin_graphql_api_id": "gid://shopify/ProductImage/13900708544585"'+
                    '}'+
                    ' ],'+
                    '  "image": {'+
                    ' "id": 13900708544585,'+
                    ' "product_id": 4448856145993,'+
                    '"position": 1,'+
                    '"created_at": "2020-05-04T17:40:09+05:30",'+
                    '"updated_at": "2020-05-04T17:40:09+05:30",'+
                    ' "alt": null,'+
                    ' "width": 1920,'+
                    ' "height": 1080,'+
                    '"src": "https://cdn.shopify.com/s/files/1/0276/5556/9481/products/0.24.jpg?v=1588594209",'+
                    '"variant_ids": [],'+
                    '"admin_graphql_api_id": "gid://shopify/ProductImage/13900708544585"'+
                    '}'+
                    ' }'+
                    ']'+
                    '}';
        RequestJSON2.parse(jsonresult);
    }
}