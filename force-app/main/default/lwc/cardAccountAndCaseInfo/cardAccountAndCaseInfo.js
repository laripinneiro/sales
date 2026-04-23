import { LightningElement, api, wire, track } from 'lwc';
import getAccountAndCaseFromSession from '@salesforce/apex/CardAccountAndCaseInfoController.getAccountAndCaseFromSession';
import updateCaseRecord from '@salesforce/apex/CardAccountAndCaseInfoController.updateCaseRecord';
import { NavigationMixin } from 'lightning/navigation';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';

import CASE_OBJECT from '@salesforce/schema/Case';
import CASE_ID from '@salesforce/schema/Case.Id';
import CASE_SUBJECT from '@salesforce/schema/Case.Subject';
import CASE_STATUS from '@salesforce/schema/Case.Status';
import CASE_PRIORITY from '@salesforce/schema/Case.Priority';
import CASE_TYPE from '@salesforce/schema/Case.Type';
import CASE_ORIGIN from '@salesforce/schema/Case.Origin';

export default class CardAccountAndCaseInfo extends NavigationMixin(LightningElement) {
    @api recordId;
    account;
    caseData;
    
    @track isEditing = false;
    @track statusOptions = [];
    @track priorityOptions = [];
    @track typeOptions = [];
    @track originOptions = [];

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    caseObjectInfo;

    @wire(getPicklistValues, { recordTypeId: '$caseObjectInfo.data.defaultRecordTypeId', fieldApiName: CASE_STATUS })
    wiredStatus({ error, data }) {
        if (data) this.statusOptions = data.values;
    }

    @wire(getPicklistValues, { recordTypeId: '$caseObjectInfo.data.defaultRecordTypeId', fieldApiName: CASE_PRIORITY })
    wiredPriority({ error, data }) {
        if (data) this.priorityOptions = data.values;
    }

    /*@wire(getPicklistValues, { recordTypeId: '$caseObjectInfo.data.defaultRecordTypeId', fieldApiName: CASE_TYPE })
    wiredOptions({ error, data }) {
        if (data) this.typeOptions = data.values;
    }

    @wire(getPicklistValues, { recordTypeId: '$caseObjectInfo.data.defaultRecordTypeId', fieldApiName: CASE_ORIGIN })
    wiredOrigin({ error, data }) {
        if (data) this.originOptions = data.values;
    }*/
   @wire(getPicklistValues, { 
        recordTypeId: '$caseData.RecordTypeId',
        fieldApiName: CASE_TYPE 
    })
    wiredType({ error, data }) {
        if (data) this.typeOptions = data.values;
    }

    @wire(getPicklistValues, { 
        recordTypeId: '$caseData.RecordTypeId', 
        fieldApiName: CASE_ORIGIN 
    })
    wiredOrigin({ error, data }) {
        if (data) this.originOptions = data.values;
    }

    @wire(getAccountAndCaseFromSession, { sessionId: '$recordId' })
    wiredData({ data, error }) {
        if (data) {
            this.account = data.account;
            this.caseData = data.caseData;
        } else if (error) {
            console.error(error);
        }
    }

    openAccountTab() {
        if (!this.account?.Id) return;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.account.Id,
                actionName: 'view'
            }
        });
    }

    get ownerPhotoUrl() {
        return this.account?.Owner?.SmallPhotoUrl || null;
    }

    get displayPhone(){
        if (!this.account) return '';

        const conta = this.account.Name;
        //console.log(conta);
        const whatsapp = this.account.CA_Whatsapp__c;
        console.log(whatsapp);

        const phone = this.account.CA_Telefone__c;
        const commercialPhone = this.account.CA_Telefonecomercial__c;

        if(whatsapp) return whatsapp;
        if(phone) return phone;
        if(commercialPhone) return commercialPhone;

        return 'Não há telefone disponível';
    }

    openCaseTab() {
        if (!this.caseData?.Id) return;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.caseData.Id,
                actionName: 'view'
            }
        });
    }

    handleEdit() {
        this.isEditing = true;
    }

    handleCancel() {
        this.isEditing = false;
    }

    async handleSave() {
        const caseFields = {
            Id: this.caseData.Id,
            Subject: this.template.querySelector('[data-field="Subject"]').value,
            Status: this.template.querySelector('[data-field="Status"]').value,
            Priority: this.template.querySelector('[data-field="Priority"]').value,
            Type: this.template.querySelector('[data-field="Type"]').value,
            Origin: this.template.querySelector('[data-field="Origin"]').value,
            Numero_de_Protocolo__c: this.template.querySelector('[data-field="Numero_de_Protocolo__c"]').value
        };

        try {
            await updateCaseRecord({ caseToUpdate: caseFields });

            this.caseData = { ...this.caseData, ...caseFields };
            this.isEditing = false;
            
            console.log('Sucesso!');

        } catch (error) {
            console.error('Erro no Apex:', error.body.message);
            alert('Erro ao salvar: ' + error.body.message);
        }
    }

    // CSS badges
    get statusClass() {
        const tipo = this.caseData?.Status;
        switch (tipo) {
            case 'Novo': return 'badge-colored badge-colored-default';
            case 'Trabalhando':
            case 'Aguardando':
            case 'Delegado':
            case 'Finalizando': return 'badge-colored badge-colored-orange';
            case 'Finalizado': return 'badge-colored badge-colored-green';
            case 'Analisar': return 'badge-colored badge-colored-yellow';
            case 'Ajustar': return 'badge-colored badge-colored-red';
            default: return 'badge-colored badge-colored-default';
        }
    }

    get priorityClass() {
        const tipo = this.caseData?.Priority;
        switch (tipo) {
            case 'Critical': return 'badge-colored badge-colored-red';
            case 'Alto': return 'badge-colored badge-colored-orange';
            case 'Médio': return 'badge-colored badge-colored-yellow';
            case 'Baixo': return 'badge-colored badge-colored-green';
            default: return 'badge-colored badge-colored-default';
        }
    }
}