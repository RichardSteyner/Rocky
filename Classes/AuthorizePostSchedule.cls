global class AuthorizePostSchedule implements Schedulable {
	
    global String org;
    
    global AuthorizePostSchedule(String org){
        this.org=org;
    }
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AuthorizePostCustomersBatch(org), 30);
    }

}