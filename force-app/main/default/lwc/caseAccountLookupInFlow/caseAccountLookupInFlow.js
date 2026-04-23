import { LightningElement, api, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';

import CA_IMOVEL from '@salesforce/schema/Case.CA_Imovel__c';
import TIP_IMOVEL from '@salesforce/schema/Case.IM_Tipologia_do_imovel__c';

const FIELDS = [
    CA_IMOVEL,
    TIP_IMOVEL
];

export default class CaseAccountLookupInFlow extends LightningElement {
    @api recordId;

    @track mode = 'view'; // 'view' or 'edit'
    get isView() { return this.mode === 'view'; }
    get isEdit() { return this.mode === 'edit'; }

    wiredCaseResult;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredCase(res) {
        this.wiredCaseResult = res;
        const { data, error } = res;
        if (data) {
            // no 
        } else if (error) {
            // console.error('Error:', error);
        }
    }

    handleEdit() {
        this.mode = 'edit';
    }

    handleCancel() {
        // revert to view without saving
        this.mode = 'view';

        if (this.wiredCaseResult) {
            refreshApex(this.wiredCaseResult);
        }
    }

    handleSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Saved',
                message: 'Informações do imóvel foram atualizadas.',
                variant: 'success'
            })
        );

        if (this.wiredCaseResult) {
            refreshApex(this.wiredCaseResult)
                .then(() => {
                    // switch back to view AFTER refresh
                    this.mode = 'view';
                })
                .catch(() => {
                    // even if refresh fails, go to view
                    this.mode = 'view';
                });
        } else {
            this.mode = 'view';
        }
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