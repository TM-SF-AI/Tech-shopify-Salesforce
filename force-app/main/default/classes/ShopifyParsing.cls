public class ShopifyParsing {

	public class Variants {
		public Long id;
		public Long product_id;
		public String title;
		public String price;
		public String sku;
		public Integer position;
		public String inventory_policy;
		public String compare_at_price;
		public String fulfillment_service;
		public String inventory_management;
		public String option1;
		public String option2;
		public String option3;
		public String created_at;
		public String updated_at;
		public Boolean taxable;
		public String barcode;
		public Integer grams;
		public Long image_id;
		public Double weight;
		public String weight_unit;
		public Long inventory_item_id;
		public Integer inventory_quantity;
		public Integer old_inventory_quantity;
		public Boolean requires_shipping;
		public String admin_graphql_api_id;
	}

	public class Options {
		public Long id;
		public Long product_id;
		public String name;
		public Integer position;
		public List<String> values;
	}

	public class Products {
		public Long id;
		public String title;
		public String body_html;
		public String vendor;
		public String product_type;
		public String created_at;
		public String handle;
		public String updated_at;
		public String published_at;
		public String template_suffix;
		public String tags;
		public String published_scope;
		public String admin_graphql_api_id;
		public List<Variants> variants;
		public List<Options> options;
		public List<Images> images;
		public Images image;
	}

	//public class Variant_ids {
       
//	}

	public List<Products> products;

	public class Images {
		public Long id;
		public Long product_id;
		public Integer position;
		public String created_at;
		public String updated_at;
		public String alt;
		public Integer width;
		public Integer height;
		public String src;
	//	public List<Variant_ids> variant_ids;
		public String admin_graphql_api_id;
	}

	
	public static ShopifyParsing parse(String json) {
		return (ShopifyParsing) System.JSON.deserialize(json, ShopifyParsing.class);
	}
}