import { LightningElement, api } from 'lwc';

export default class MessagingSessionActivitiesActions extends LightningElement {
    @api recordId;

    showFlow = false;

    async startNewFlow(flowApiName) {
        this.showFlow = false;
        await Promise.resolve();

        this.showFlow = true;
        await Promise.resolve();

        const flow = this.template.querySelector('lightning-flow');
        console.log('Flow encontrado? ', flow);

        flow.startFlow(flowApiName, [{
            name: 'recordId',
            type: 'String',
            value: this.recordId
            
        }]);
    }

    handleOpenFlow1() {
        this.startNewFlow('MessagingSession_Send_Email');
    }

    handleOpenFlow2() {
        this.startNewFlow('MessagingSession_Log_a_Call_Custom_Action');
    }

    handleOpenFlow3() {
        this.startNewFlow('Case_Attach_File_Flow');
    }

    handleFlowStatusChange(event) {
        if (event.detail.status === "FINISHED") {
            this.showFlow = false;

            notifyRecordUpdateAvailable([{ recordId: this.recordId }]);
        }
    }

    //ajustes para fechhar o flow quand oclica fora:
    connectedCallback() {
        this.handleGlobalClick = this.handleGlobalClick.bind(this);
        window.addEventListener('click', this.handleGlobalClick);
    }

    disconnectedCallback() {
        window.removeEventListener('click', this.handleGlobalClick);
    }

    handleGlobalClick(event) {
        const path = event.composedPath();

        if (path.includes(this.template.host)) { //se clicar em qualquer elemento DESTE componente, não fecha o flow
            return;
        }
        this.showFlow = false;
    }
}