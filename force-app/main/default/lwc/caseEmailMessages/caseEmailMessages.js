import { LightningElement, api, wire } from 'lwc';
import getEmails from '@salesforce/apex/CaseEmailMessageController.getEmails';

export default class CaseEmailMessages extends LightningElement {

     @api recordId;

    emails;
    error;

    @wire(getEmails, { caseId: '$recordId' })
    wiredEmails({ error, data }) {
        if (data) {
            this.emails = data.map(email => ({
                ...email,
                direction: email.Incoming ? 'Recebido' : 'Enviado'
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.emails = undefined;
        }
    }
}