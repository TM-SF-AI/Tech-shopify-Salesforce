public class ShopifyParsingOrders1 {
    public class Total_line_items_price_set {
		public Shop_money shop_money {get;set;} 
		public Shop_money presentment_money {get;set;} 

		public Total_line_items_price_set(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'shop_money') {
							shop_money = new Shop_money(parser);
						} else if (text == 'presentment_money') {
							presentment_money = new Shop_money(parser);
						} else {
							//System.debug(LoggingLevel.WARN, 'Total_line_items_price_set consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Default_address {
		public String id {get;set;} 
		public String customer_id {get;set;} 
		public String first_name {get;set;} 
		public String last_name {get;set;} 
		public String company {get;set;} 
		public String address1 {get;set;} 
		public String address2 {get;set;} 
		public String city {get;set;} 
		public String province {get;set;} 
		public String country {get;set;} 
		public String zip {get;set;} 
		public String phone {get;set;} 
		public String name {get;set;} 
		public String province_code {get;set;} 
		public String country_code {get;set;} 
		public String country_name {get;set;} 
		public Boolean default_Z {get;set;} // in json: default

		public Default_address(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'customer_id') {
							customer_id = parser.getText();
						} else if (text == 'first_name') {
							first_name = parser.getText();
						} else if (text == 'last_name') {
							last_name = parser.getText();
						} else if (text == 'company') {
							company = parser.getText();
						} else if (text == 'address1') {
							address1 = parser.getText();
						} else if (text == 'address2') {
							address2 = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'phone') {
							phone = parser.getText();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'province_code') {
							province_code = parser.getText();
						} else if (text == 'country_code') {
							country_code = parser.getText();
						} else if (text == 'country_name') {
							country_name = parser.getText();
						} else if (text == 'default') {
							default_Z = parser.getBooleanValue();
						} else {
							//System.debug(LoggingLevel.WARN, 'Default_address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Orders {
		public String id {get;set;} 
		public String email {get;set;} 
		public String closed_at {get;set;} 
		public String created_at {get;set;} 
		public String updated_at {get;set;} 
		public Integer number_Z {get;set;} // in json: number
		public String note {get;set;} 
		public String token {get;set;} 
		public String gateway {get;set;} 
		public Boolean test {get;set;} 
		public String total_price {get;set;} 
		public String subtotal_price {get;set;} 
		public String total_weight {get;set;} 
		public String total_tax {get;set;} 
		public Boolean taxes_included {get;set;} 
		//public String currency {get;set;} 
		public String financial_status {get;set;} 
		public Boolean confirmed {get;set;} 
		public String total_discounts {get;set;} 
		public String total_line_items_price {get;set;} 
		public String cart_token {get;set;} 
		public Boolean buyer_accepts_marketing {get;set;} 
		public String name {get;set;} 
		public String referring_site {get;set;} 
		public String landing_site {get;set;} 
		public String cancelled_at {get;set;} 
		public String cancel_reason {get;set;} 
		public String total_price_usd {get;set;} 
		public String checkout_token {get;set;} 
		public String reference {get;set;} 
		public Long user_id {get;set;} 
		public String location_id {get;set;} 
		public String source_identifier {get;set;} 
		public String source_url {get;set;} 
		public String processed_at {get;set;} 
		public String device_id {get;set;} 
		public String phone {get;set;} 
		public String customer_locale {get;set;} 
		public Integer app_id {get;set;} 
		public String browser_ip {get;set;} 
		public String landing_site_ref {get;set;} 
		public Integer order_number {get;set;} 
		public List<Discount_applications> discount_applications {get;set;} 
		public List<Discount_applications> discount_codes {get;set;} 
		public List<Discount_applications> note_attributes {get;set;} 
		public List<String> payment_gateway_names {get;set;} 
		public String processing_method {get;set;} 
		public String checkout_id {get;set;} 
		public String source_name {get;set;} 
		public String fulfillment_status {get;set;} 
		public List<Discount_applications> tax_lines {get;set;} 
		public String tags {get;set;} 
		public String contact_email {get;set;} 
		public String order_status_url {get;set;} 
		public String presentment_currency {get;set;} 
		public Total_line_items_price_set total_line_items_price_set {get;set;} 
		public Total_line_items_price_set total_discounts_set {get;set;} 
		public Total_line_items_price_set total_shipping_price_set {get;set;} 
		public Total_line_items_price_set subtotal_price_set {get;set;} 
		public Total_line_items_price_set total_price_set {get;set;} 
		public Total_line_items_price_set total_tax_set {get;set;} 
		public List<Line_items> line_items {get;set;} 
		public List<Discount_applications> fulfillments {get;set;} 
		public List<Discount_applications> refunds {get;set;} 
		public String total_tip_received {get;set;} 
		public String admin_graphql_api_id {get;set;} 
		public List<Discount_applications> shipping_lines {get;set;} 
		public Billing_address billing_address {get;set;} 
		public Billing_address shipping_address {get;set;} 
		public Customer customer {get;set;} 

		public Orders(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'closed_at') {
							closed_at = parser.getText();
						} else if (text == 'created_at') {
							created_at = parser.getText();
						} else if (text == 'updated_at') {
							updated_at = parser.getText();
						} else if (text == 'number') {
							number_Z = parser.getIntegerValue();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'token') {
							token = parser.getText();
						} else if (text == 'gateway') {
							gateway = parser.getText();
						} else if (text == 'test') {
							test = parser.getBooleanValue();
						} else if (text == 'total_price') {
							total_price = parser.getText();
						} else if (text == 'subtotal_price') {
							subtotal_price = parser.getText();
						} else if (text == 'total_weight') {
							total_weight = parser.getText();
						} else if (text == 'total_tax') {
							total_tax = parser.getText();
						} else if (text == 'taxes_included') {
							taxes_included = parser.getBooleanValue();
						} /*else if (text == 'currency') {
							currency = parser.getText();
						}*/ else if (text == 'financial_status') {
							financial_status = parser.getText();
						} else if (text == 'confirmed') {
							confirmed = parser.getBooleanValue();
						} else if (text == 'total_discounts') {
							total_discounts = parser.getText();
						} else if (text == 'total_line_items_price') {
							total_line_items_price = parser.getText();
						} else if (text == 'cart_token') {
							cart_token = parser.getText();
						} else if (text == 'buyer_accepts_marketing') {
							buyer_accepts_marketing = parser.getBooleanValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'referring_site') {
							referring_site = parser.getText();
						} else if (text == 'landing_site') {
							landing_site = parser.getText();
						} else if (text == 'cancelled_at') {
							cancelled_at = parser.getText();
						} else if (text == 'cancel_reason') {
							cancel_reason = parser.getText();
						} else if (text == 'total_price_usd') {
							total_price_usd = parser.getText();
						} else if (text == 'checkout_token') {
							checkout_token = parser.getText();
						} else if (text == 'reference') {
							reference = parser.getText();
						} else if (text == 'user_id') {
							user_id = parser.getLongValue();
						} else if (text == 'location_id') {
							location_id = parser.getText();
						} else if (text == 'source_identifier') {
							source_identifier = parser.getText();
						} else if (text == 'source_url') {
							source_url = parser.getText();
						} else if (text == 'processed_at') {
							processed_at = parser.getText();
						} else if (text == 'device_id') {
							device_id = parser.getText();
						} else if (text == 'phone') {
							phone = parser.getText();
						} else if (text == 'customer_locale') {
							customer_locale = parser.getText();
						} else if (text == 'app_id') {
							app_id = parser.getIntegerValue();
						} else if (text == 'browser_ip') {
							browser_ip = parser.getText();
						} else if (text == 'landing_site_ref') {
							landing_site_ref = parser.getText();
						} else if (text == 'order_number') {
							order_number = parser.getIntegerValue();
						} else if (text == 'discount_applications') {
							discount_applications = arrayOfDiscount_applications(parser);
						} else if (text == 'discount_codes') {
							discount_codes = arrayOfDiscount_applications(parser);
						} else if (text == 'note_attributes') {
							note_attributes = arrayOfDiscount_applications(parser);
						} else if (text == 'payment_gateway_names') {
							payment_gateway_names = arrayOfString(parser);
						} else if (text == 'processing_method') {
							processing_method = parser.getText();
						} else if (text == 'checkout_id') {
							checkout_id = parser.getText();
						} else if (text == 'source_name') {
							source_name = parser.getText();
						} else if (text == 'fulfillment_status') {
							fulfillment_status = parser.getText();
						} else if (text == 'tax_lines') {
							tax_lines = arrayOfDiscount_applications(parser);
						} else if (text == 'tags') {
							tags = parser.getText();
						} else if (text == 'contact_email') {
							contact_email = parser.getText();
						} else if (text == 'order_status_url') {
							order_status_url = parser.getText();
						} else if (text == 'presentment_currency') {
							presentment_currency = parser.getText();
						} else if (text == 'total_line_items_price_set') {
							total_line_items_price_set = new Total_line_items_price_set(parser);
						} else if (text == 'total_discounts_set') {
							total_discounts_set = new Total_line_items_price_set(parser);
						} else if (text == 'total_shipping_price_set') {
							total_shipping_price_set = new Total_line_items_price_set(parser);
						} else if (text == 'subtotal_price_set') {
							subtotal_price_set = new Total_line_items_price_set(parser);
						} else if (text == 'total_price_set') {
							total_price_set = new Total_line_items_price_set(parser);
						} else if (text == 'total_tax_set') {
							total_tax_set = new Total_line_items_price_set(parser);
						} else if (text == 'line_items') {
							line_items = arrayOfLine_items(parser);
						} else if (text == 'fulfillments') {
							fulfillments = arrayOfDiscount_applications(parser);
						} else if (text == 'refunds') {
							refunds = arrayOfDiscount_applications(parser);
						} else if (text == 'total_tip_received') {
							total_tip_received = parser.getText();
						} else if (text == 'admin_graphql_api_id') {
							admin_graphql_api_id = parser.getText();
						} else if (text == 'shipping_lines') {
							shipping_lines = arrayOfDiscount_applications(parser);
						} else if (text == 'billing_address') {
							billing_address = new Billing_address(parser);
						} else if (text == 'shipping_address') {
							shipping_address = new Billing_address(parser);
						} else if (text == 'customer') {
							customer = new Customer(parser);
						} else {
							//System.debug(LoggingLevel.WARN, 'Orders consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Line_items {
		public String id {get;set;} 
		public String variant_id {get;set;} 
		public String title {get;set;} 
		public String quantity {get;set;} 
		public String sku {get;set;} 
		public String variant_title {get;set;} 
		public String vendor {get;set;} 
		public String fulfillment_service {get;set;} 
		public String product_id {get;set;} 
		public Boolean requires_shipping {get;set;} 
		public Boolean taxable {get;set;} 
		public Boolean gift_card {get;set;} 
		public String name {get;set;} 
		public String variant_inventory_management {get;set;} 
		public List<Discount_applications> properties {get;set;} 
		public Boolean product_exists {get;set;} 
		public Integer fulfillable_quantity {get;set;} 
		public Integer grams {get;set;} 
		public String price {get;set;} 
		public String total_discount {get;set;} 
		public String fulfillment_status {get;set;} 
		public Total_line_items_price_set price_set {get;set;} 
		public Total_line_items_price_set total_discount_set {get;set;} 
		public List<Discount_applications> discount_allocations {get;set;} 
		public String admin_graphql_api_id {get;set;} 
		public List<Discount_applications> tax_lines {get;set;} 

		public Line_items(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'variant_id') {
							variant_id = parser.getText();
						} else if (text == 'title') {
							title = parser.getText();
						} else if (text == 'quantity') {
							quantity = parser.getText();
						} else if (text == 'sku') {
							sku = parser.getText();
						} else if (text == 'variant_title') {
							variant_title = parser.getText();
						} else if (text == 'vendor') {
							vendor = parser.getText();
						} else if (text == 'fulfillment_service') {
							fulfillment_service = parser.getText();
						} else if (text == 'product_id') {
							product_id = parser.getText();
						} else if (text == 'requires_shipping') {
							requires_shipping = parser.getBooleanValue();
						} else if (text == 'taxable') {
							taxable = parser.getBooleanValue();
						} else if (text == 'gift_card') {
							gift_card = parser.getBooleanValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'variant_inventory_management') {
							variant_inventory_management = parser.getText();
						} else if (text == 'properties') {
							properties = arrayOfDiscount_applications(parser);
						} else if (text == 'product_exists') {
							product_exists = parser.getBooleanValue();
						} else if (text == 'fulfillable_quantity') {
							fulfillable_quantity = parser.getIntegerValue();
						} else if (text == 'grams') {
							grams = parser.getIntegerValue();
						} else if (text == 'price') {
							price = parser.getText();
						} else if (text == 'total_discount') {
							total_discount = parser.getText();
						} else if (text == 'fulfillment_status') {
							fulfillment_status = parser.getText();
						} else if (text == 'price_set') {
							price_set = new Total_line_items_price_set(parser);
						} else if (text == 'total_discount_set') {
							total_discount_set = new Total_line_items_price_set(parser);
						} else if (text == 'discount_allocations') {
							discount_allocations = arrayOfDiscount_applications(parser);
						} else if (text == 'admin_graphql_api_id') {
							admin_graphql_api_id = parser.getText();
						} else if (text == 'tax_lines') {
							tax_lines = arrayOfDiscount_applications(parser);
						} else {
							//System.debug(LoggingLevel.WARN, 'Line_items consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Customer {
		public String id {get;set;} 
		public String email {get;set;} 
		public Boolean accepts_marketing {get;set;} 
		public String created_at {get;set;} 
		public String updated_at {get;set;} 
		public String first_name {get;set;} 
		public String last_name {get;set;} 
		public Integer orders_count {get;set;} 
		public String state {get;set;} 
		public String total_spent {get;set;} 
		public String last_order_id {get;set;} 
		public String note {get;set;} 
		public Boolean verified_email {get;set;} 
		public String multipass_identifier {get;set;} 
		public Boolean tax_exempt {get;set;} 
		public String phone {get;set;} 
		public String tags {get;set;} 
		public String last_order_name {get;set;} 
		//public String currency {get;set;} 
		public String accepts_marketing_updated_at {get;set;} 
		public String marketing_opt_in_level {get;set;} 
		public String admin_graphql_api_id {get;set;} 
		public Default_address default_address {get;set;} 

		public Customer(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'email') {
							email = parser.getText();
						} else if (text == 'accepts_marketing') {
							accepts_marketing = parser.getBooleanValue();
						} else if (text == 'created_at') {
							created_at = parser.getText();
						} else if (text == 'updated_at') {
							updated_at = parser.getText();
						} else if (text == 'first_name') {
							first_name = parser.getText();
						} else if (text == 'last_name') {
							last_name = parser.getText();
						} else if (text == 'orders_count') {
							orders_count = parser.getIntegerValue();
						} else if (text == 'state') {
							state = parser.getText();
						} else if (text == 'total_spent') {
							total_spent = parser.getText();
						} else if (text == 'last_order_id') {
							last_order_id = parser.getText();
						} else if (text == 'note') {
							note = parser.getText();
						} else if (text == 'verified_email') {
							verified_email = parser.getBooleanValue();
						} else if (text == 'multipass_identifier') {
							multipass_identifier = parser.getText();
						} else if (text == 'tax_exempt') {
							tax_exempt = parser.getBooleanValue();
						} else if (text == 'phone') {
							phone = parser.getText();
						} else if (text == 'tags') {
							tags = parser.getText();
						} else if (text == 'last_order_name') {
							last_order_name = parser.getText();
						} /*else if (text == 'currency') {
							currency = parser.getText();
						}*/ else if (text == 'accepts_marketing_updated_at') {
							accepts_marketing_updated_at = parser.getText();
						} else if (text == 'marketing_opt_in_level') {
							marketing_opt_in_level = parser.getText();
						} else if (text == 'admin_graphql_api_id') {
							admin_graphql_api_id = parser.getText();
						} else if (text == 'default_address') {
							default_address = new Default_address(parser);
						} else {
							//System.debug(LoggingLevel.WARN, 'Customer consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public List<Orders> orders {get;set;} 

	public ShopifyParsingOrders1(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'orders') {
						orders = arrayOfOrders(parser);
					} else {
						//System.debug(LoggingLevel.WARN, 'JSON2Apex--orders consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Discount_applications {

		public Discount_applications(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						{
							//System.debug(LoggingLevel.WARN, 'Discount_applications consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Billing_address {
		public String first_name {get;set;} 
		public String address1 {get;set;} 
		public String phone {get;set;} 
		public String city {get;set;} 
		public String zip {get;set;} 
		public String province {get;set;} 
		public String country {get;set;} 
		public String last_name {get;set;} 
		public String address2 {get;set;} 
		public String company {get;set;} 
		public Double latitude {get;set;} 
		public Double longitude {get;set;} 
		public String name {get;set;} 
		public String country_code {get;set;} 
		public String province_code {get;set;} 

		public Billing_address(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'first_name') {
							first_name = parser.getText();
						} else if (text == 'address1') {
							address1 = parser.getText();
						} else if (text == 'phone') {
							phone = parser.getText();
						} else if (text == 'city') {
							city = parser.getText();
						} else if (text == 'zip') {
							zip = parser.getText();
						} else if (text == 'province') {
							province = parser.getText();
						} else if (text == 'country') {
							country = parser.getText();
						} else if (text == 'last_name') {
							last_name = parser.getText();
						} else if (text == 'address2') {
							address2 = parser.getText();
						} else if (text == 'company') {
							company = parser.getText();
						} else if (text == 'latitude') {
							latitude = parser.getDoubleValue();
						} else if (text == 'longitude') {
							longitude = parser.getDoubleValue();
						} else if (text == 'name') {
							name = parser.getText();
						} else if (text == 'country_code') {
							country_code = parser.getText();
						} else if (text == 'province_code') {
							province_code = parser.getText();
						} else {
							//System.debug(LoggingLevel.WARN, 'Billing_address consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Shop_money {
		public String amount {get;set;} 
		public String currency_code {get;set;} 

		public Shop_money(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'amount') {
							amount = parser.getText();
						} else if (text == 'currency_code') {
							currency_code = parser.getText();
						} else {
							//System.debug(LoggingLevel.WARN, 'Shop_money consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static ShopifyParsingOrders1 parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new ShopifyParsingOrders1(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	
    private static List<Discount_applications> arrayOfDiscount_applications(System.JSONParser p) {
        List<Discount_applications> res = new List<Discount_applications>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Discount_applications(p));
        }
        return res;
    }

    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

    private static List<Orders> arrayOfOrders(System.JSONParser p) {
        List<Orders> res = new List<Orders>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Orders(p));
        }
        return res;
    }
    
    private static List<Line_items> arrayOfLine_items(System.JSONParser p) {
        List<Line_items> res = new List<Line_items>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Line_items(p));
        }
        return res;
    }
}