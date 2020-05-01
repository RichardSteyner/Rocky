global class CloverGetPaymentsSchedule implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CloverGetPaymentsBatch(false, 60), 100);
    }

}