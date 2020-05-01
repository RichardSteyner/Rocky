public class ZingleMessagesParser {
	public class Status {
        public String text {get; set;} public Integer status_code {get; set;} public String description {get; set;} public String sort_field {get; set;} public String sort_direction {get; set;} public Integer page {get; set;} public Integer page_size {get; set;} public Integer total_pages {get; set;} public Integer total_records {get; set;}
	}
	public class Sender {
		public String id {get; set;} public Channel channel {get; set;}
	}
	public Status status {get; set;}
	public List<Result> result {get; set;}
	public class Channel {
		public String type_class {get; set;} public String display_name {get; set;} public String value {get; set;} public String formatted_value {get; set;}
	}
	public class Triggered_by_user {
		public String id {get; set;} public String email {get; set;} public String first_name {get; set;} public String last_name {get; set;} public String title {get; set;} public String username {get; set;} public String avatar_uri {get; set;}
	}
	public class Result {
		public String body {get; set;} public String id {get; set;} public String template_id {get; set;}
		public Long created_at {get; set;} public Long updated_at {get; set;}
		public String read_at {get; set;} public String deleted_by_contact_at {get; set;}
		public String triggered_by_user_id {get; set;} public Triggered_by_user triggered_by_user {get; set;}
		public String sender_type {get; set;} public Sender sender {get; set;}
		public String recipient_type {get; set;} public Sender recipient {get; set;}
		public String communication_direction {get; set;} public Boolean is_delayed {get; set;}
		public Long execute_at {get; set;} public String executed_at {get; set;}
		public String forwarded_by_service_uuid {get; set;}	public String translated_body_language_code {get; set;}
		public String translated_body {get; set;} public String body_language_code {get; set;}
	}
}