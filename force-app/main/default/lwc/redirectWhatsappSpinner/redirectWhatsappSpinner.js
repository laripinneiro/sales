import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class RedirectWhatsappSpinner extends NavigationMixin(LightningElement) {
    @api messagingSessionId;
    @api delayMs = 1500; 

    connectedCallback() {
        this.startRedirectSequence();
    }

    startRedirectSequence() {
        setTimeout(() => {
            this.doRedirect();
        }, this.delayMs);
    }

    doRedirect() {
        if (this.messagingSessionId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.messagingSessionId,
                    actionName: 'view'
                }
            });
        } else {
            console.error('MessagingSessionId não informado.');
        }

        const finishEvent = new FlowNavigationFinishEvent();
        this.dispatchEvent(finishEvent);
    }
}