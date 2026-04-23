import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import ENDUSERNAME from '@salesforce/schema/MessagingSession.MessagingEndUser.Name'; 
import ENDUSERCONTACT from '@salesforce/schema/MessagingSession.MessagingEndUser.MessagingPlatformKey';
import MSGSESSION_CASEID from '@salesforce/schema/MessagingSession.CaseId'; 
import MSGSESSION_CASESUBJECT from '@salesforce/schema/MessagingSession.Case.Subject'; 

const MSGSESSION_FIELDS = [ENDUSERNAME, MSGSESSION_CASESUBJECT, MSGSESSION_CASEID, ENDUSERCONTACT];
const DEFAULT_DETAIL_LABEL = 'Assunto do Caso';
const DEFAULT_TITLE_IF_EMPTY = 'Sessão de Mensagens';
const ERROR_MESSAGE_LOADING = 'Erro ao carregar dados da Sessão';
const QUICK_ACTION_API_NAME = 'MessagingSession.CA_CriarNovoCaso';
const END_USER_CONTACT_LABEL = 'Contato da Conta';

export default class MsgSessionCustomHighlightPanel extends NavigationMixin(LightningElement){
    @api recordId;
    @api panelTitle;
    @api showCreateCaseButton;
    @api detailFieldLabel;

    msgSessionData;
    isLoading = false;
    errorMessage = '';

    detailLabel = DEFAULT_DETAIL_LABEL;
    endUserContactLabel = END_USER_CONTACT_LABEL;
    titleToDisplay = '';
    detailFieldValue = '';
    endUserContactValue = '';

    @wire(getRecord, { recordId: '$recordId', fields: MSGSESSION_FIELDS }) 
    wiredSession({ data, error }) {
        if (data) {
            console.log('RAW RECORD:', JSON.parse(JSON.stringify(data)));

            this.msgSessionData = data;
            this.updateDisplayValues();
            this.errorMessage = '';
        } else if (error) {
            console.error('WIRE ERROR:', JSON.stringify(error, null, 2));
            this.errorMessage = ERROR_MESSAGE_LOADING;

            this.titleToDisplay = this.panelTitle || DEFAULT_TITLE_IF_EMPTY;
        }
    }

    connectedCallback(){
        if (this.detailFieldLabel && this.detailFieldLabel.trim()) {
            this.detailLabel = this.detailFieldLabel;
        } else {
            this.detailLabel = DEFAULT_DETAIL_LABEL;
        }
    }

    updateDisplayValues(){
        if (!this.msgSessionData) return;

        const endUserName = getFieldValue(this.msgSessionData, ENDUSERNAME);
        this.titleToDisplay = this.panelTitle && this.panelTitle.trim() ? this.panelTitle : endUserName || DEFAULT_TITLE_IF_EMPTY;

        const caseSubject = getFieldValue(this.msgSessionData, MSGSESSION_CASESUBJECT);
        this.detailFieldValue = caseSubject || '---';

        const endUserContact = getFieldValue(this.msgSessionData, ENDUSERCONTACT);
        this.endUserContactValue = endUserContact || '---';
    }

    get isCreateCaseButtonVisible() {
        return this.showCreateCaseButton !== false;
    }

    get caseId() {
        if (this.msgSessionData) {
            return getFieldValue(this.msgSessionData, MSGSESSION_CASEID); 
        }
        return null;
    }

    handleCreateCase() {
        this.isLoading = true;

        try {
            this[NavigationMixin.Navigate]({
                type: 'standard__quickAction',
                attributes: {
                    apiName: QUICK_ACTION_API_NAME,
                },
                state: {
                    recordId: this.recordId,
                },
            });
        } catch (error) {
            console.error('Erro ao executar a criação de caso!', error);
            this.showErrorToast(
                'Erro de Navegação',
                'Não foi possível iniciar a Quick Action "CA_CriarNovoCaso"'
            );
        } finally {
            setTimeout(() => {
                this.isLoading = false;
            }, 500);
        }
    }

    showErrorToast(title, message) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: 'error',
            mode: 'pester',
        });
        this.dispatchEvent(event);
    }
}