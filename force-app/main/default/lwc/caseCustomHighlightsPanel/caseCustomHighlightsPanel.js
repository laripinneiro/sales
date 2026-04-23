import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const CASE_FIELDS = ['Case.CaseNumber', 'Case.Subject'];

export default class CaseCustomHighlightsPanel extends NavigationMixin(
    LightningElement
) {
    @api recordId;
    @api caseTitle;
    @api showCreateButton;
    @api caseNumberFieldLabel;

    caseData;
    isLoading = false;
    errorMessage = '';
    caseNumberValue = '';
    caseNumberLabel = 'Número do Caso';
    titleToDisplay = '';

    @wire(getRecord, { recordId: '$recordId', fields: CASE_FIELDS })
    wiredCase({ data, error }) {
        if (data) {
            this.caseData = data;
            this.updateDisplayValues();
            this.errorMessage = '';
        } else if (error) {
            this.errorMessage = 'Erro ao carregar dados do caso';
            console.error('Erro ao buscar Case:', error);
        }
    }

    connectedCallback() {
        if (this.caseNumberFieldLabel && this.caseNumberFieldLabel.trim()) {
            this.caseNumberLabel = this.caseNumberFieldLabel;
        }
    }

    updateDisplayValues() {
        if (!this.caseData) return;

        const caseNumber = getFieldValue(this.caseData, 'Case.CaseNumber');
        this.caseNumberValue = caseNumber || '-';

        const caseSubject = getFieldValue(this.caseData, 'Case.Subject');

        if (this.caseTitle && this.caseTitle.trim()) {
            this.titleToDisplay = this.caseTitle;
        } else {
            this.titleToDisplay = caseSubject || 'Caso';
        }
    }

    get showCreateButtonComputed() {
        return this.showCreateButton === true || this.showCreateButton === undefined || this.showCreateButton === '';
    }

    handleCreateCase() {
        this.isLoading = true;

        try {
            this[NavigationMixin.Navigate]({
                type: 'standard__quickAction',
                attributes: {
                    apiName: 'Case.CA_CriarNovoCaso',
                },
                state: {
                    recordId: this.recordId,
                },
            });
        } catch (error) {
            console.error('Erro ao executar custom action:', error);
            this.showErrorToast(
                'Erro ao criar novo caso',
                'Verifique se a ação customizada está disponível'
            );
        } finally {
            this.isLoading = false;
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