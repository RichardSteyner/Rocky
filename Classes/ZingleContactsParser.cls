public class ZingleContactsParser {
	public class Status {
		public String text {get;set;} public Integer status_code {get;set;} public String description {get;set;} public String sort_field {get;set;} public String sort_direction {get;set;} public Integer page {get;set;} public Integer page_size {get;set;} public Integer total_pages {get;set;} public Integer total_records {get;set;}
	}
	public class Custom_field_values {
		public String value {get;set;} public Custom_field custom_field {get;set;}
	}
	public class Last_message {
		public String id {get;set;} public String body {get;set;} public Long created_at {get;set;}
	}
	public class Options {
		public String value {get;set;} public String display_name {get;set;} public String is_default {get;set;} public String sort_order {get;set;} public String id {get;set;}
	}
	public class Channel_type {
		public String id {get;set;} public String type_class {get;set;} public String display_name {get;set;} public String inbound_notification_url {get;set;} public String outbound_notification_url {get;set;} public Boolean allow_communications {get;set;}
	}
	public class Custom_field {
		public String id {get;set;} public String display_name {get;set;} public String data_type {get;set;} public String code {get;set;} public String replacement_variable {get;set;} public Boolean is_global {get;set;} public List<Options> options {get;set;}
	}
	public Status status {get;set;}
	public List<Result> result {get;set;}
	public class Labels {
		public String id {get;set;} public String code {get;set;} public String display_name {get;set;} public String background_color {get;set;} public String text_color {get;set;} public Boolean is_automatic {get;set;} public Boolean is_global {get;set;}
	}
	public class Channels {
		public String id {get;set;} public String display_name {get;set;} public String value {get;set;} public String formatted_value {get;set;} public String country {get;set;}
		public Boolean is_default {get;set;} public Boolean is_default_for_type {get;set;} public Boolean block_inbound {get;set;} public Boolean block_outbound {get;set;} public Boolean is_messageable {get;set;} public Channel_type channel_type {get;set;}
	}
	public class Result {
		public String id {get;set;} public String title {get;set;}
		public String fullName {get;set;} public String notes {get;set;}
		public String external_id {get;set;} public String service_id {get;set;}
		public String first_name {get;set;}	public String last_name {get;set;}
		public String assigned_to_team_id {get;set;} public String assigned_to_user_id {get;set;}
		public Boolean is_messageable {get;set;} public Boolean is_confirmed {get;set;}
		public Boolean is_starred {get;set;} public Boolean is_closed {get;set;}
		public String avatar_uri {get;set;} public String optin_status {get;set;}
		public Long unconfirmed_at {get;set;} public Long created_at {get;set;}
		public Long updated_at {get;set;} public String locked_by_source {get;set;}
		public Last_message last_message {get;set;}	public List<Channels> channels {get;set;}
		public List<Custom_field_values> custom_field_values {get;set;}	public List<Labels> labels {get;set;}
	}
}