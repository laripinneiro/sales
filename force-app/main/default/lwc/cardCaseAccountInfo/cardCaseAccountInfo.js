import { LightningElement, api, wire } from 'lwc';
import getAccountFromCase from '@salesforce/apex/CardAccountInfoController.getAccountFromCase';
import { NavigationMixin } from 'lightning/navigation';

export default class CardAccountInfoCase extends NavigationMixin(LightningElement) {
    @api recordId;
    account;

    @wire(getAccountFromCase, { caseId: '$recordId' })
    wiredAccount({ data, error }) {
        if (data) {
            this.account = data;
        } else if (error) {
            console.error(error);
        }
    }

    get displayPhone(){
        if (!this.account) return '';

        const whatsapp = this.account.CA_Whatsapp__c;
        const phone = this.account.CA_Telefone__c;
        const commercialPhone = this.account.CA_Telefonecomercial__c;

        if(whatsapp) return whatsapp;
        if(phone) return phone;
        if(commercialPhone) return commercialPhone;

        return 'Não há telefone disponível';
    }

    get italicPhoneClass(){
        return this.displayPhone === 'Não há telefone disponível' ? 'italic-text' : '';
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
}