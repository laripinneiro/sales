import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class RedirectWhatsappButton extends NavigationMixin(LightningElement) {
    @api messagingSessionId; 

    handleClick() {
        if (!this.messagingSessionId) {
            console.error('messagingSessionId não informado.');
            return;
        }

        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.messagingSessionId,
                actionName: 'view'
            }
        });

        //const next = new FlowNavigationNextEvent();
        //this.dispatchEvent(next);
    }
}