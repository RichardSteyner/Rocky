global class AdvancedMDScheduleAMC implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AdvancedMDGetProvidersBatch('AMC', false), 60);
    }

}