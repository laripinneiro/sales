public with sharing class ContractController {
    
    @AuraEnabled(cacheable=true)
    public static Contract getActiveContractByImovel(String imoveId, Boolean filterByRecordType) {
        if (String.isBlank(imoveId)) return null;

        try {
            List<CA_ImoveisContratos__c> relacionamentos = [
                SELECT CA_Contratos__c FROM CA_ImoveisContratos__c
                WHERE CA_Imovel__c = :imoveId LIMIT 100
            ];

            if (relacionamentos.isEmpty()) return null;

            List<Id> contractIds = new List<Id>();
            for (CA_ImoveisContratos__c rel : relacionamentos) {
                contractIds.add(rel.CA_Contratos__c);
            }

            return queryContract(contractIds, null, filterByRecordType);
        } catch (Exception e) {
            System.debug('Erro ao buscar contrato: ' + e.getMessage());
            return null;
        }
    }

    @AuraEnabled(cacheable=true)
    public static Contract getContractById(String contractId, Boolean filterByRecordType) {
        if (String.isBlank(contractId)) return null;
        try {
            return queryContract(null, contractId, filterByRecordType);
        } catch (Exception e) {
            System.debug('Erro ao buscar contrato por ID: ' + e.getMessage());
            return null;
        }
    }

    private static Contract queryContract(List<Id> ids, String singleId, Boolean filterByRecordType) {
        String query = 'SELECT Id, CA_GarantiaContratada__c, CA_DiaBaseGarantia__c, CA_ValorAluguel__c, ' +
                       'CA_ValorBaseComissao__c, CA_DataInicioContrato__c, EndDate, CA_DiaVencimentoBoleto__c, ' +
                       'CA_DataProximoReajuste__c, Status, RecordType.DeveloperName FROM Contract WHERE ';
        
        if (singleId != null) {
            query += 'Id = :singleId ';
        } else {
            query += 'Id IN :ids ';
        }

        if (filterByRecordType) {
            query += 'AND RecordType.Name = \'Tipo Locação\' ';
        } else {
            query += 'AND RecordType.DeveloperName = \'CA_TipoLocacao\' ';
        }

        query += 'AND Status IN (\'Ativado\', \'Ativo\') ORDER BY CA_DataInicioContrato__c DESC LIMIT 1';
        
        List<Contract> results = Database.query(query);
        return results.isEmpty() ? null : results[0];
    }
}