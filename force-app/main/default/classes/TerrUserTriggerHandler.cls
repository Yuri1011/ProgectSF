public class TerrUserTriggerHandler {
    public static void beforeInsert() {
        ShareService.shareRecords(Trigger.new);
    }
    public static void beforeUpdate() {
        ShareService.deleteShareRecords(Trigger.old);
        ShareService.shareRecords(Trigger.new);
    }
    public static void beforeDelete() {
        ShareService.deleteShareRecords(Trigger.old);
    }
}