public class TerritoryTriggerHandler {
    public static void beforeInsert() {
    	TerritoryTriggerService.checkRecord(Trigger.new);
  	}
    
    public static void beforeUpdate() { 
        TerritoryTriggerService.checkRecord(Trigger.new);
    }
}