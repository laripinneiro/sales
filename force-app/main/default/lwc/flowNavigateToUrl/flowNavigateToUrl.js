import { LightningElement, api } from 'lwc';

export default class FlowNavigateToUrl extends LightningElement {
    @api url;

    connectedCallback() {
        if (this.url) {
            window.open(this.url, '_blank');
        }
    }
}