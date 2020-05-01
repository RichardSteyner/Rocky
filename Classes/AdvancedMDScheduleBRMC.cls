global class AdvancedMDScheduleBRMC implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new AdvancedMDGetProvidersBatch('BRMC', false), 60);
    }

}