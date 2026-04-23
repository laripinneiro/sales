import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import LOCALE from '@salesforce/i18n/locale';
import CURRENCY from '@salesforce/i18n/currency';
import getActiveContractByImovel from '@salesforce/apex/ContractController.getActiveContractByImovel';
import getContractById from '@salesforce/apex/ContractController.getContractById';
import { NavigationMixin } from 'lightning/navigation';

export default class ContractInformation extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;

    @api accessButtonLabel = 'Acessar Contrato';
    @api noContractMessage;
    @api label_ca_garantiaContratada = 'Garantia Contratada';
    @api label_ca_diaBaseGarantia = 'Dia Base Garantia';
    @api label_ca_valorAluguel = 'Valor Aluguel';
    @api label_ca_valorBaseComissao = 'Valor Base Comissão';
    @api label_ca_dataInicioContrato = 'Data Início Contrato';
    @api label_endDate = 'Data Fim';
    @api label_ca_diaVencimentoBoleto = 'Dia Vencimento Boleto';
    @api label_ca_dataProximoReajuste = 'Data Próximo Reajuste';
    @api filterByRecordType = false;

    contractData = {};
    contractId = null;
    isLoading = false;
    hasContract = false;
    isButtonDisabled = true;
    accessButtonTooltip = 'Nenhum contrato disponível';
    wiredRecordResult;

    get fields() {
        if (this.objectApiName === 'Case') {
            return ['Case.CA_Imovel__c', 'Case.CA_Contrato__c'];
        } else if (this.objectApiName === 'MessagingSession') {
            return ['MessagingSession.CA_Contrato__c', 'MessagingSession.CA_Imovel__c'];
        }
        return [];
    }

    @wire(getRecord, { recordId: '$recordId', fields: '$fields' })
    wiredRecord(result) {
        this.wiredRecordResult = result;
        const { error, data } = result;

        if (data) {
            this.hasContract = false;
            const contractId = data.fields.CA_Contrato__c?.value;
            const imoveId = data.fields.CA_Imovel__c?.value;

            if (contractId) {
                this.loadContractById(contractId, imoveId);
            } else if (imoveId) {
                this.loadContract(imoveId);
            } else {
                this.isLoading = false;
                this.processContractResult(null);
            }
        } else if (error) {
            console.error('Erro ao obter registro:', error);
            this.isLoading = false;
        }
    }
    
    handleEditContract(){
        this.hasContract = false;
        this.contractId = null;
        this.isButtonDisabled = true;
    }    

    handleContractSelectionSuccess(){
        this.isLoading = true;
        refreshApex(this.wiredRecordResult).then(() => { this.isLoading = false; });
    }

    loadContract(imoveId) {
        this.isLoading = true;
        getActiveContractByImovel({ imoveId: imoveId, filterByRecordType: this.filterByRecordType })
            .then((result) => { this.processContractResult(result); })
            .catch((error) => {
                console.error('Erro ao obter contrato:', error);
                this.isLoading = false;
            });
    }

    loadContractById(contractId, imoveId) {
        this.isLoading = true;
        getContractById({ contractId: contractId, filterByRecordType: this.filterByRecordType })
            .then((result) => {
                if (!result && imoveId) {
                    this.loadContract(imoveId);
                } else {
                    this.processContractResult(result);
                }
            })
            .catch((error) => {
                console.error('Erro ao obter contrato por ID:', error);
                this.isLoading = false;
            });
    }

    processContractResult(result) {
        if (result) {
            this.contractData = {
                ...result,
                CA_DataInicioContrato__c: this.formatDate(result.CA_DataInicioContrato__c),
                EndDate: this.formatDate(result.EndDate),
                CA_DataProximoReajuste__c: this.formatDate(result.CA_DataProximoReajuste__c),
                CA_ValorAluguel__c: this.formatCurrency(result.CA_ValorAluguel__c),
                CA_ValorBaseComissao__c: this.formatCurrency(result.CA_ValorBaseComissao__c)
            };
            this.contractId = result.Id;
            this.hasContract = true;
            this.isButtonDisabled = false;
            this.accessButtonTooltip = 'Abrir contrato';
        } else {
            this.contractData = {};
            this.hasContract = false;
            this.isButtonDisabled = true;
            this.accessButtonTooltip = 'Nenhum contrato disponível';
        }
        this.isLoading = false;
    }

    formatCurrency(value) {
        if (value === undefined || value === null) return '';
        return new Intl.NumberFormat(LOCALE, { style: 'currency', currency: CURRENCY }).format(value);
    }

    formatDate(dateString) {
        if (!dateString) return '';
        const parts = dateString.split('-');
        if (parts.length === 3) {
            const [year, month, day] = parts;
            return `${day}/${month}/${year}`;
        }
        return dateString;
    }

    handleAccessContract() {
        if (!this.contractId || this.isButtonDisabled) return;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: { recordId: this.contractId, actionName: 'view' }
        });
    }
}