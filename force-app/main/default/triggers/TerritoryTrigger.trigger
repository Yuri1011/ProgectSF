trigger TerritoryTrigger on Territory__c (before insert, before update) {
	if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TerritoryTriggerHandler.beforeInsert();
        }
        
        if (Trigger.isUpdate) {
        	TerritoryTriggerHandler.beforeUpdate();
    	}
    }
}