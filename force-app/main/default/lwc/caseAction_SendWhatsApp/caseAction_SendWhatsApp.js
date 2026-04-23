import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import PHONE_FIELD from '@salesforce/schema/Account.Phone';

export default class OpenMessagingChannel extends NavigationMixin(LightningElement) {
    @api recordId;
    phone;

    @wire(getRecord, { recordId: '$recordId', fields: [PHONE_FIELD] })
    wiredRecord({ data }) {
        if (data) {
            this.phone = data.fields.Phone.value;
        }
    }

    handleOpen() {
        if (!this.phone) {
            alert('Nenhum telefone encontrado nesta conta.');
            return;
        }

        const cleanPhone = this.phone.replace(/\D/g, '');
        const url = `https://wa.me/${cleanPhone}`;

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        });
    }
}