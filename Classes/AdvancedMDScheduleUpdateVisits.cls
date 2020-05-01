global class AdvancedMDScheduleUpdateVisits implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AuxAdvancedMDGetVisitsUpdateBatch(0, 150), 150);
    }

}