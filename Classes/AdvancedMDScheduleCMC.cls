global class AdvancedMDScheduleCMC implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AdvancedMDGetProvidersBatch('CMC', false), 60);
    }

}