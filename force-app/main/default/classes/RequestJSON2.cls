public class RequestJSON2 {
	public Product product;
    
    public RequestJSON2(String title, String bodyHtml, String vendor, String productType, String price, String sku, String variantId, String tags, List<String> images) {
        this.product = new Product(title, bodyHtml, vendor, productType, price, sku, variantId, tags, images);
    }
    
	public class Variant {
		public String sku;
        public String option1;
        public String price;
        
        public Variant(String prodSku, String variantId, String prodPrice) {
            this.sku = prodSku;
            this.option1 = variantId;
            this.price = prodPrice;
        }
	}
    
    public class Images {
		public String src;
        
        public Images(String imgSrc) {
            this.src = imgSrc;
        }
	}
    
	public class Product {
		public String title;
		public String body_html;
		public String vendor;
		public String product_type;
        public String tags;
		public List<Variant> variants;
        public List<Images> images;
        
        public Product(String titleProd, String bodyHtmlProd, String vendorProd, String productTypeProd, String priceProd, String skuProd, String variantIdProd, String tagsProd, List<String> imagesProd){
            this.title = titleProd;
            this.body_html = bodyHtmlProd;
            this.vendor = vendorProd;
            this.product_type = productTypeProd;
            this.tags = tagsProd;
            this.variants = new List<Variant>();
            this.variants.add(new Variant(skuProd, variantIdProd, priceProd));
            this.images = new List<Images>();
            if(imagesProd != null && imagesProd.size() > 0) {
                for(String img : imagesProd) {
                    this.images.add(new Images(img));
                }
            }
        }
	}
	public static RequestJSON2 parse(String json) {
		return (RequestJSON2) System.JSON.deserialize(json, RequestJSON2.class);
	}
}