import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import MS_CASE_ID from '@salesforce/schema/MessagingSession.CaseId';
import MS_IMOVEL_ID from '@salesforce/schema/MessagingSession.CA_Imovel__c';
import IMOVEL_OWNER from '@salesforce/schema/MessagingSession.CA_Imovel__r.CA_ProprietarioImovel__c';

export default class CardImovelInfoMessaging extends LightningElement {
    @api recordId; 
    @track mode = 'view';
    
    get isView() { 
        return this.mode === 'view'; 
    }
    get isEdit() { 
        return this.mode === 'edit'; 
    }

    caseId;
    directImovelId; 
    isLoading = true;
    imovelOwnerId;

    @wire(getRecord, { recordId: '$recordId', fields: [MS_CASE_ID,MS_IMOVEL_ID, IMOVEL_OWNER] })
    wiredMessagingSession({ error, data }) {
        this.isLoading = false;
        if (data) {
            this.caseId = getFieldValue(data, MS_CASE_ID);
            this.directImovelId = getFieldValue(data, MS_IMOVEL_ID);
            this.imovelOwnerId = getFieldValue(data, IMOVEL_OWNER);
        } else if (error) {
            console.error('Erro ao buscar MessagingSession:', error);
            this.caseId = null;
            this.directImovelId = null;
        }
    }    
    
    get hasImovelOnly() {
        return !this.caseId && !!this.directImovelId;
    }
    get hasCase() {
        return !!this.caseId;
    }
    get hasNoRecords() {
        return !this.caseId && !this.directImovelId;
    }
    get isView() { 
        return this.mode === 'view'; 
    }
    get isEdit() { 
        return this.mode === 'edit'; 
    }

    handleEdit() {
        this.mode = 'edit';
    }
    handleCancel() {
        this.mode = 'view';
    }
    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Saved',
                message: 'Informações do imóvel foram atualizadas.',
                variant: 'success'
            })
        );
        this.mode = 'view';            
    }
    handleError(event) {
        const message = (event.detail && event.detail.detail) ? event.detail.detail : 'Unknown error';
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error saving',
                message,
                variant: 'error'
            })
        );
    }
}