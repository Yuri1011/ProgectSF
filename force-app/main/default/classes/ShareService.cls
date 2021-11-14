public class ShareService {
    public static void shareRecords(List<TerrUser__c> terrUserRecords) {
        final String EDIT_ACCESS = 'Edit';
        final String READ_ACCESS = 'Read';

        Map<Id, Id> terrIdToUserId = new Map<Id, Id>(); 
        
        for (TerrUser__c record : terrUserRecords) {
            terrIdToUserId.put(record.Territory__c, record.User__c);
        }

        List<Territory__c> childsSecondLevel = [
            SELECT Id, Territory__c
            FROM Territory__c 
            WHERE Territory__c IN :terrIdToUserId.keySet()
        ];

        for (Territory__c child : childsSecondLevel) {
            terrIdToUserId.put(child.Id, terrIdToUserId.get(child.Territory__c));
        }

        List<Territory__c> childsThirdLevel = [
            SELECT Id, Territory__c
            FROM Territory__c 
            WHERE Territory__c IN :terrIdToUserId.keySet()
        ];

        for (Territory__c child : childsThirdLevel) {
            terrIdToUserId.put(child.Id, terrIdToUserId.get(child.Territory__c));
        }
        
        List<Reference__c> referenceOnAccAndCon = [
            SELECT Account__c, Contact__c, Account__r.Territory__c 
            FROM Reference__c 
            WHERE Account__r.Territory__c IN :terrIdToUserId.keySet()];
        
        List<AccountShare> accountShareL = new List<AccountShare>();
        List<ContactShare> contactShareL = new List<ContactShare>();
        List<Territory__Share> territoryChildRecords = new List<Territory__Share>();
        List<Territory__Share> territoryRecords = new List<Territory__Share>();

        for (Id territoryId : terrIdToUserId.keySet()) {
         
            Territory__Share newShareRecordForUser  = new Territory__Share();
            newShareRecordForUser.ParentId = territoryId;
            newShareRecordForUser.AccessLevel = READ_ACCESS;
            newShareRecordForUser.UserOrGroupId = terrIdToUserId.get(territoryId);
            
            territoryRecords.add(newShareRecordForUser);
        }
        
        for (Reference__c ref : referenceOnAccAndCon) {

            AccountShare accountShare = new AccountShare();
        	accountShare.AccountId = ref.Account__c;
        	accountShare.AccountAccessLevel = EDIT_ACCESS;
        	accountShare.OpportunityAccessLevel = READ_ACCESS;
        	accountShare.UserOrGroupId = terrIdToUserId.get(ref.Account__r.Territory__c);
            
            accountShareL.add(accountShare);
            
            ContactShare contactShare = new ContactShare();
        	contactShare.ContactId = ref.Contact__c;
        	contactShare.ContactAccessLevel = EDIT_ACCESS;
        	contactShare.UserOrGroupId = terrIdToUserId.get(ref.Account__r.Territory__c);
        
            contactShareL.add(contactShare);
        }
         
        insert territoryRecords;
        insert accountShareL;
        insert contactShareL;
	}

    public static void deleteShareRecords(List<TerrUser__c> terrUserOldRecords) {
        final String ROW_CAUSE_MANUAL = 'Manual'; 
        Set<Id> terrOldIds = new Set<Id>();
        Set<Id> oldUserIds = new Set<Id>();
        Set<Id> oldAccountIds = new Set<Id>();
        Set<Id> oldContactIds = new Set<Id>();
        Set<Id> oldChildIds = new Set<Id>();

        for (TerrUser__c record : terrUserOldRecords) {
            terrOldIds.add(record.Territory__c);
            oldUserIds.add(record.User__c);
        }
        
        Map<Id, Territory__c> shildSecondTerrRecords = new Map<Id, Territory__c>([
            SELECT Id
            FROM Territory__c 
            WHERE Territory__c IN :terrOldIds]);

        terrOldIds.addAll(shildSecondTerrRecords.keySet());

        Map<Id, Territory__c> shildThirdTerrRecords = new Map<Id, Territory__c>([
            SELECT Id
            FROM Territory__c
            WHERE Territory__c IN :terrOldIds]);

        terrOldIds.addAll(shildThirdTerrRecords.keySet());
        
        List<Reference__c> referenceOnAccAndCon = [
            SELECT Account__c, Contact__c
            FROM Reference__c];
        
        for (Reference__c ref : referenceOnAccAndCon) {
            oldAccountIds.add(ref.Account__c);
            oldContactIds.add(ref.Contact__c);
        }
        
        delete [
            SELECT Id 
            FROM Territory__Share 
            WHERE ParentId IN :terrOldIds AND UserOrGroupId IN :oldUserIds AND RowCause = :ROW_CAUSE_MANUAL];
        delete [
            SELECT Id 
            FROM AccountShare 
            WHERE AccountId IN :oldAccountIds AND RowCause = :ROW_CAUSE_MANUAL];
        delete [
            SELECT Id 
            FROM ContactShare 
            WHERE ContactId IN :oldContactIds AND RowCause = :ROW_CAUSE_MANUAL];
    } 
}