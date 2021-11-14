trigger TerrUserTrigger on TerrUser__c (before insert, before update, before delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TerrUserTriggerHandler.beforeInsert();
        }
        if (Trigger.isUpdate) {
            TerrUserTriggerHandler.beforeUpdate();
        }
        if (Trigger.isDelete) {
            TerrUserTriggerHandler.beforeDelete();
        }
    }
}