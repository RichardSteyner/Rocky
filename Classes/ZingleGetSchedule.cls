global class ZingleGetSchedule implements Schedulable {
    
    global void execute(SchedulableContext ctx){
        Database.executeBatch(new ZingleGetContactsBatch(false, 60), 100);
    }

}