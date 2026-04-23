public class OrderPost {
    
    public class AddressData {
        public String address1;
        public String city;
        public String province;
        public String phone;
        public String zip;
        public String last_name;
        public String first_name;
        public String country;
        
        public AddressData(String add1, String custCity, String custProvince, String custPhone, String custZip, String custFName,
                           String custLName, String custCountry) {
            this.address1 = add1;
            this.city = custCity;
            this.province = custProvince;
            this.phone = custPhone;
            this.zip = custZip;
            this.last_name = custLName;
            this.first_name = custFName;
            this.country = custCountry;                   
        }
    }
	
	public Class LineItem {
		public String variant_id;
		public String quantity;
		
		public LineItem(String variantId, String itemQuantity) {
			this.variant_id = variantId;
			this.quantity = itemQuantity;
		}
	}
	
	public Class Customer {
	
		public String first_name;
		public String last_name;
		public String email;

		
		Public Customer(String fname, String lname, String emailAdd) {
			this.first_name = fname;
			this.last_name = lname;
			this.email = emailAdd;

		}
	}
    
    
    	public Class AddressData1 {
	
		public String first_name;
		public String last_name;
		public String email;
		
		Public AddressData1(String fname, String lname, String emailAdd) {
			this.first_name = fname;
			this.last_name = lname;
			this.email = emailAdd;
		}
	}
    
    
    
    public class TransactionData {
        public String kind;
        public String status;
        public String amount;
        
        public TransactionData(String transKind, String transStatus, String transAmt) {
            this.kind = transKind;
            this.status = transStatus;
            this.amount = transAmt;
        }
    }
    public Order order;
		
    public OrderPost(String email, String first_name, String last_name, String cusAdd1, String cusCity, String cusProvince, 
                     String cusAddrPhone, String cusZip, String cusFName, String cusLName, String cusCountry, String transKind, 
                     String transStatus, String transAmt, String liVarId, String liQty) {
        this.order = new Order(email, first_name, last_name, cusAdd1, cusCity, cusProvince, cusAddrPhone, cusZip, cusFName, cusLName, cusCountry, transKind, transStatus, transAmt, liVarId, liQty);
    }
    public class Order {
        public String email;

        public List<TransactionData> transactions = new List<TransactionData>();
        public List<LineItem> line_items =  new List<LineItem>();
		public Customer customer;
	public AddressData billing_address;
        public AddressData shipping_address;

        public Order(String emailCus, String first_nameCus, String last_nameCus, String add1Cus, String custCity, String custProvince, String custAddPhone, String custZip, 
					String custFName, String custLName, String custCountry, String kind, String status, String amount, String variantID, String quantity 
                    ){
					
            this.customer = new Customer(first_nameCus, last_nameCus, emailCus );
           this.billing_address = new AddressData(add1Cus, custCity, custProvince, custAddPhone, custZip, custFName, custLName, custCountry);
          // this.billing_address.add(new AddressData(add1Cus, custCity, custProvince, custAddPhone, custZip, custFName, custLName, custCountry));
            this.shipping_address = new AddressData(add1Cus, custCity, custProvince, custAddPhone, custZip, custFName, custLName, custCountry);
			this.line_items.add(new LineItem(variantID, quantity));
			this.transactions.add(new TransactionData(kind, status, amount));
			this.email = emailCus;

        }
    }
    public static OrderData parse(String json) {
        return (OrderData) System.JSON.deserialize(json, OrderData.class);
    }
}