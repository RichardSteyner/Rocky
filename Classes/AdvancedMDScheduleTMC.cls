global class AdvancedMDScheduleTMC implements Schedulable {

    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AdvancedMDGetProvidersBatch('TMC', false), 60);
    }
    
}