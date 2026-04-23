public class Postocustomer {
    
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
    
    public Customer customer;
    public Postocustomer(String email, String first_name, String last_name, String cusPhone, String CusVerifiedEmail, String cusAdd1, 
                         String cusCity, String cusProvince, String cusAddrPhone, String cusZip, String cusFName, String cusLName, String cusCountry) {
        this.Customer = new Customer(email, first_name, last_name, cusPhone, CusVerifiedEmail, cusAdd1, cusCity, cusProvince,
                                     cusAddrPhone, cusZip, cusFName, cusLName, cusCountry);
    }
    public class Customer {
        public String email;
        public String first_name;
        public String last_name;
        public String phone;
        public String verified_email;
        public List<AddressData> addresses = new List<AddressData>();
        public Customer(String emailCus, String first_nameCus, String last_nameCus, String phoneCus, String isCusVerifiedEmail, 
                        String add1Cus, String custCity, String custProvince, String custAddPhone, String custZip, String custFName,
                        String custLName, String custCountry){
            this.email = emailCus;
            this.first_name = first_nameCus;
            this.last_name = last_nameCus;
            this.phone = phoneCus;
            this.verified_email = isCusVerifiedEmail;
            this.addresses.add(new AddressData(add1Cus, custCity, custProvince, custAddPhone, custZip, custFName, custLName, custCountry));
        }
    }
    public static Postocustomer parse(String json) {
        return (Postocustomer) System.JSON.deserialize(json, Postocustomer.class);
    }
}