public class TerritoryTriggerService {
    public static final String ERROR_MESSAGE = 'Such a territory already exists.'; 
    
    public static List<Territory__c> getTerritory(Set<String> terNames) {
        return [ 
        	SELECT Id, Name, Territory__c
        	FROM Territory__c 
            WHERE Name IN :terNames];
    }
  
    public static void checkRecord(List<Territory__c> territoriesFromTrigger) {
        Set<String> terNames = new Set<String>();
        for (Territory__c ter : territoriesFromTrigger) {
            terNames.add(ter.Name);
        }
        
        List<Territory__c> territoriesFromBD = getTerritory(terNames);
        
        for	(Territory__c territoryRecordBD : territoriesFromBD) { 
       		for (Territory__c territoryRecord : territoriesFromTrigger) {
           		if (territoryRecordBD.Name == territoryRecord.Name && territoryRecordBD.Territory__c == territoryRecord.Territory__c) {
              		territoryRecord.addError(ERROR_MESSAGE);
           		}
      		} 
    	}    
  	}
}