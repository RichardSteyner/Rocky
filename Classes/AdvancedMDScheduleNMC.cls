global class AdvancedMDScheduleNMC implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AdvancedMDGetProvidersBatch('NMC', false), 60);
    }

}