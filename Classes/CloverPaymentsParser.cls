public class CloverPaymentsParser {
	public class Order {
		public String id {get;set;} public String currenci {get;set;} 
		public Customers customers {get;set;} 
		public Employee employee {get;set;} 
		public Integer total {get;set;} public Boolean taxRemoved {get;set;} public Boolean isVat {get;set;} 
		public String state {get;set;} 
		public Boolean manualTransaction {get;set;} 
		public Boolean groupLineItems {get;set;} public Boolean testMode {get;set;} 
		public String payType {get;set;} public Long createdTime {get;set;} public Long clientCreatedTime {get;set;} public Long modifiedTime {get;set;} public Employee device {get;set;} 
	}
	public class Tender {
		public String id {get;set;} public String label {get;set;} 
	}
	public class CardTransaction {
		public String cardType {get;set;} public String entryType {get;set;} public String first6 {get;set;} public String last4 {get;set;} public String type_Z {get;set;} /*in json: type*/ public String authCode {get;set;} public String referenceId {get;set;} public String transactionNo {get;set;} public String state {get;set;} public Extra extra {get;set;} public String cardholderName {get;set;} 
	}
	public class Device {
		public String id {get;set;} 
	}
	public class Customers {
		public List<CustomerElements> elements {get;set;}
	}
    public class CustomerElements {
		public String id {get;set;} public String firstName {get;set;} public String lastName {get;set;} 
	}
    public class Employee {
		public String id {get;set;} public String name {get;set;} public String email {get;set;} 
	}
	public class Extra {
		public String applicationLabel {get;set;} public String common {get;set;} public String func {get;set;} public String exp {get;set;} public String authorizingNetworkName {get;set;} public String athNtwkId {get;set;} public String cvmResult {get;set;} public String applicationIdentifier {get;set;} public String card {get;set;} public String tkntype {get;set;} 
	}
	public List<Elements> elements {get;set;} 
	public class Elements {
		public String id {get;set;} 
		public Order order {get;set;} public Device device {get;set;} 
		public Tender tender {get;set;} 
		public Integer amount {get;set;} 
		public Integer taxAmount {get;set;} public Integer cashbackAmount {get;set;} 
		public Long createdTime {get;set;} 
		public Long clientCreatedTime {get;set;} public Long modifiedTime {get;set;} public Boolean offline {get;set;} 
		public String result {get;set;} 
		public CardTransaction cardTransaction {get;set;} 
	}
}