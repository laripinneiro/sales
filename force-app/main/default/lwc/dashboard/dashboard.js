import { LightningElement, track } from 'lwc';
import getDashboardNumbers from '@salesforce/apex/DashboardController.getDashboardNumbers';
import getUserStatus from '@salesforce/apex/DashboardController.getUserStatus';
import getReportIds from '@salesforce/apex/DashboardController.getReportIds';
import getReportData from '@salesforce/apex/DashboardController.getReportData';

export default class Dashboard extends LightningElement {

    @track data = {};
    @track filter = 'week';
    @track userStatus = 'Carregando...';
    @track statusSince = '--';
    @track userPhotoUrl;

    interval;

    connectedCallback() {
        this.loadData();
        this.loadUserStatus();
        this.loadReportIds();

        
        this.interval = setInterval(() => {
            this.loadData();
            this.loadUserStatus();
        }, 10000);
    }

    disconnectedCallback() {
        clearInterval(this.interval);
    }

   
    formatMinutesToHM(minutes) {
        if (!minutes || isNaN(minutes) || minutes === 0) {
            return '0';
        }

        const h = Math.floor(minutes / 60);
        const m = Math.round(minutes % 60);

        if (h > 0) {
            return `${h}h ${m}min`;
        }

        return `${m}min`;
    }

    
    loadData() {
        getDashboardNumbers({ range: this.filter })
            .then(result => {
                this.data = result;
            })
            .catch(error => {
                console.error('Erro:', error);
            });
    }

   
    loadUserStatus() {
        getUserStatus()
            .then(res => {
                this.userStatus = res.status;
                this.statusSince = res.since;
                this.userPhotoUrl = res.photoUrl;
            })
            .catch(err => {
                console.error('Erro ao carregar status:', err);
            });
    }

    
    changeFilter(event) {
        this.filter = event.target.value;
        this.loadData();
        this.loadChartData();
    }

    get todayClass() { return this.filter === 'today' ? 'active' : ''; }
    get weekClass() { return this.filter === 'week' ? 'active' : ''; }
    get monthClass() { return this.filter === 'month' ? 'active' : ''; }

   
    get startDate() {
        const today = new Date();

        if (this.filter === 'today') {
            return today;
        }

        if (this.filter === 'week') {
            const startOfWeek = new Date(today);
            const day = today.getDay(); 
            const diff = day === 0 ? 6 : day - 1; 
            startOfWeek.setDate(today.getDate() - diff);
            return startOfWeek;
        }

        if (this.filter === 'month') {
            return new Date(today.getFullYear(), today.getMonth(), 1);
        }

        return today;
    }

    get startDateFormatted() {
        const d = this.startDate;
        const options = { day: '2-digit', month: 'short', year: 'numeric' };
        return d.toLocaleDateString('pt-BR', options);
    }

  
    get casesAbertos() { return this.data.casesAbertos || 0; }
    get casesCriados() { return this.data.casesCriados || 0; }
    get casesAtraso() { return this.data.casesAtraso || 0; }
    get msgsAbertas() { return this.data.mensagensAbertas || 0; }
    get slaViolado() { return this.data.slaViolado || 0; }

    get casesFechados() { return this.data.casosFechados || 0; }
    get tarefasFechadas() { return this.data.tarefasFechadas || 0; }
    get sessoesEncerradas() { return this.data.sessoesEncerradas || 0; }

    
    get tmaCasos() { return this.formatMinutesToHM(this.data.tmaCasos); }
    get tmaMensagens() { return this.formatMinutesToHM(this.data.tmaMensagens); }
    get tmeAtendimento() { return this.formatMinutesToHM(this.data.tmeAtendimento); }

    @track reportIds = {};
    @track clientChartData = [];
    @track supportChartData = [];
    
    colors = ['#00A63E', '#9810FA', '#F0B100', '#6CA9FF', '#FF5B5B', '#8A8A8A'];

    loadReportIds() {
        getReportIds()
            .then(result => {
                this.reportIds = result;
                this.loadChartData();
            })
            .catch(error => {
                console.error('Erro ao carregar IDs de relatórios:', error);
            });
    }

    loadChartData() {
        if (!this.reportIds) return;
        
        let suffix = 'Hoje';
        if (this.filter === 'week') suffix = 'EssaSemana';
        if (this.filter === 'month') suffix = 'EsseMes';

        const clientId = this.reportIds['TiposDeCliente' + suffix];
        const supportId = this.reportIds['TiposDeAtendimento' + suffix];

        this.fetchReportData(clientId, 'client');
        this.fetchReportData(supportId, 'support');
    }

    fetchReportData(reportId, type) {
        if (!reportId) return;

        getReportData({ reportId: reportId })
            .then(result => {
                const processed = result.map((item, index) => {
                    const c = this.colors[index % this.colors.length];
                    return {
                        ...item,
                        color: c,
                        colorStyle: `background-color: ${c}`
                    };
                });
                
                if (type === 'client') {
                    this.clientChartData = processed;
                } else if (type === 'support') {
                    this.supportChartData = processed;
                }
            })
            .catch(err => {
                console.error('Erro buscando dados do relatorio', reportId, err);
            });
    }
    
    get clientChartStyle() {
        return this.getConicGradient(this.clientChartData);
    }

    get supportChartStyle() {
        return this.getConicGradient(this.supportChartData);
    }

    getConicGradient(data) {
        if (!data || data.length === 0) return 'background: #f5f5f5';

        let total = data.reduce((acc, item) => acc + item.value, 0);
        let gradient = 'background: conic-gradient(';
        let currentDeg = 0;

        data.forEach((item, index) => {
            let color = this.colors[index % this.colors.length];
            let deg = (item.value / total) * 360;
            if (isNaN(deg)) deg = 0;
            gradient += `${color} ${currentDeg}deg ${currentDeg + deg}deg, `;
            currentDeg += deg;
        });

        if (total === 0) return 'background: #f5f5f5';

        gradient = gradient.slice(0, -2) + ')';
        return gradient;
    }


}