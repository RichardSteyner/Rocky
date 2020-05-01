global class AdvancedMDScheduleRMMC implements Schedulable{
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AdvancedMDGetProvidersBatch('RMMC', false), 60);
    }

}