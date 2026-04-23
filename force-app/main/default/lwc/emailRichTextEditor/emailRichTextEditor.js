import { LightningElement, api, track } from 'lwc';
import getFileDetails from '@salesforce/apex/FlowSendEmailInvocableRepository.getFileDetails';

export default class EmailRichTextEditor extends LightningElement {
    @track value = '';
    @track isRichText = true;    
    @track uploadedFiles = [];
    
    get acceptedFormats() {
        return ['.pdf', '.png', '.jpg', '.jpeg', '.doc', '.docx', '.xls', '.xlsx'];
    }

    formats = ['bold', 'italic', 'underline', 'strike',
        'list', 'indent', 'align', 'link', 'color',
        'background', 'font', 'size', 'image'
    ];

    @api recordId;

    @api
    set htmlValue(v){
        this.value = v;
    }

    get htmlValue(){
        return this.value;
    }

    @api 
    get contentDocumentIds() {
        return this.uploadedFiles.map(file => file.documentId);
    }

    get toggleLabel(){
        return this.isRichText ? 'Ver HTML' : 'Ver Rich Text';
    }

    get hasFiles() {
        return this.uploadedFiles.length > 0;
    }

    toggleMode(){
        this.isRichText = !this.isRichText;
    }

    handleRichTextChange(event){
        this.value = event.target.value;
        this.fireFlowEvent('htmlValue', this.value);
    }

    handleHtmlChange(event){
        this.value = event.target.value;
        this.fireFlowEvent('htmlValue', this.value);    
    }

    handleUploadFinished(event) {
        console.log('--- [LWC] Upload Finalizado Iniciado ---');

        const newFiles = event.detail.files; 
        console.log('[LWC] Arquivos recebidos do evento:', JSON.stringify(newFiles));

        if (!newFiles || newFiles.length === 0) {
            console.warn('[LWC] Nenhum arquivo detectado.');
            return;
        }

        const newDocIds = newFiles.map(file => file.documentId);
        console.log('[LWC] IDs extraídos para enviar ao Apex:', JSON.stringify(newDocIds));

        console.log('[LWC] Chamando getFileDetails...');
        
        getFileDetails({ contentDocumentIds: newDocIds })
            .then(result => {
                console.log('[LWC] Apex respondeu com sucesso!');
                console.log('[LWC] Dados crus do Apex:', JSON.stringify(result));

                if (!result) {
                    console.error('[LWC] O resultado do Apex veio nulo/undefined');
                    return;
                }

                try {
                    const filesWithDetails = result.map(cv => {
                        const size = cv.ContentSize ? cv.ContentSize : 0;
                        const sizeFormatted = this.formatBytes(size);
                        
                        const displayName = `${cv.Title}.${cv.FileExtension} (${sizeFormatted})`;

                        return {
                            name: displayName, 
                            documentId: cv.ContentDocumentId,
                            size: size
                        };
                    });

                    console.log('[LWC] Arquivos processados:', JSON.stringify(filesWithDetails));

                    this.uploadedFiles = [...this.uploadedFiles, ...filesWithDetails];
                    this.fireFlowEvent('contentDocumentIds', this.contentDocumentIds);

                } catch (innerError) {
                    console.error('[LWC] Erro LÓGICO dentro do .then (provavelmente formatBytes):', innerError);
                }
            })
            .catch(error => {
                console.error('--- [LWC] CAIU NO CATCH ---');
                console.error('Mensagem de Erro:', error.message);
                console.error('Erro Completo (Stringify):', JSON.stringify(error));
                
                if (error.body) {
                    console.error('Error Body:', JSON.stringify(error.body));
                }
            });
    }

    handleRemoveFile(event) {
        const fileIdToRemove = event.detail.name;
        this.uploadedFiles = this.uploadedFiles.filter(file => file.documentId !== fileIdToRemove);
        this.fireFlowEvent('contentDocumentIds', this.contentDocumentIds);
    }

    fireFlowEvent(attributeName, value){
        this.dispatchEvent(
            new CustomEvent('valuechange', {
                detail: {
                    name: attributeName,
                    value: value
                }
            })
        );
    }

    get totalSizeFormatted() {
        if (!this.uploadedFiles.length) return '0 Bytes';
        const totalBytes = this.uploadedFiles.reduce((acc, file) => acc + (file.size || 0), 0);
        
        if(this.formatBytes) {
            return this.formatBytes(totalBytes);
        }
        return totalBytes + ' Bytes';
    }

    formatBytes(bytes, decimals = 2) {
        if (!+bytes) return '0 Bytes';

        const k = 1024;
        const dm = decimals < 0 ? 0 : decimals;
        const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

        const i = Math.floor(Math.log(bytes) / Math.log(k));

        return `${parseFloat((bytes / Math.pow(k, i)).toFixed(dm))} ${sizes[i]}`;
    }
}