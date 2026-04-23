const fs = require('fs');
const path = require('path');
const businessObjectives = require('./business_objectives.js');

const flowsDir = path.join(__dirname, 'force-app/main/default/flows');
const outputFile = path.join(__dirname, 'Documentacao_Flows.md');

let outputLines = [
    "# Documentação de Flows do Salesforce\n"
];

if (!fs.existsSync(flowsDir)) {
    console.error(`Directory not found: ${flowsDir}`);
    process.exit(1);
}

const files = fs.readdirSync(flowsDir).filter(f => f.endsWith('.flow-meta.xml')).sort();

function extractText(xml, tagName) {
    const regex = new RegExp(`<${tagName}>(.*?)</${tagName}>`, 's');
    const match = xml.match(regex);
    return match ? match[1].trim() : "";
}

function getTarget(xmlChunk) {
    const match = xmlChunk.match(/<connector>.*?<targetReference>(.*?)<\/targetReference>.*?<\/connector>/s);
    return match ? match[1].trim() : null;
}

files.forEach(file => {
    const filePath = path.join(flowsDir, file);
    try {
        const xml = fs.readFileSync(filePath, 'utf8');
        let flowLabel = extractText(xml, 'label') || file.replace('.flow-meta.xml', '');
        let flowDesc = extractText(xml, 'description');
        const apiName = file.replace('.flow-meta.xml', '');
        
        let businessDesc = businessObjectives[apiName] || flowDesc || 'Fluxo automatizado do Salesforce responsável por processar e transacionar eventos de negócios vitais entre o CRM e os endpoints.';
        const processType = extractText(xml, 'processType') || 'Desconhecido';
        
        outputLines.push(`## Fluxo: ${flowLabel}\n`);
        outputLines.push(`**Objetivo do Fluxo**: ${businessDesc}  `);
        outputLines.push(`**Especificações Técnicas Gerais:**\n`);
        outputLines.push(`* **Nome de API:** ${apiName}`);
        
        let typeDesc = "";
        if (processType === 'AutoLaunchedFlow') typeDesc = " (Fluxo iniciado automaticamente)";
        else if (processType === 'Flow') typeDesc = " (Fluxo de Tela)";
        
        outputLines.push(`* **Tipo de Fluxo:** ${processType}${typeDesc}.\n`);

        const typesMap = {
            'recordLookups': 'Busca de Registro',
            'assignments': 'Atribuição de Variável',
            'decisions': 'Decisão Lógica',
            'recordUpdates': 'Atualização de Registro',
            'recordCreates': 'Criação de Registro',
            'actionCalls': 'Ação (Action)'
        };

        let nodesDict = {};
        Object.keys(typesMap).forEach(type => {
            const blockRegex = new RegExp(`<${type}>(.*?)</${type}>`, 'gs');
            let match;
            while ((match = blockRegex.exec(xml)) !== null) {
                let nodeXml = match[1];
                let name = extractText(nodeXml, 'name');
                if (name) {
                    nodesDict[name] = { xml: nodeXml, type: type, typeName: typesMap[type], name: name };
                }
            }
        });

        const startMatch = xml.match(/<start>(.*?)<\/start>/s);
        let startRef = extractText(xml, 'startElementReference');
        
        if (startMatch) {
            const snode = startMatch[1];
            const obj = extractText(snode, 'object');
            if (obj) {
                const trigger = extractText(snode, 'triggerType');
                outputLines.push(`### Gatilho de Início (Start): Entrada do Fluxo\n`);
                outputLines.push(`Ponto de entrada do sistema identificando os eventos ativos da transação.\n`);
                outputLines.push(`* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: ${trigger || 'Geral'} sobre a base de ${obj}.`);
                outputLines.push(`* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.\n`);
            }
            if (!startRef) {
                startRef = getTarget(snode);
            }
        }

        let visited = new Set();
        let lastPrintedCondition = "Fluxo Primário (Raiz)";

        function traverse(nodeName, currentCond) {
            if (!nodeName || visited.has(nodeName)) return; // Prevents loop and cleanly handles merges natively
            visited.add(nodeName);

            let nodeInfo = nodesDict[nodeName];
            if (!nodeInfo) return;

            let nx = nodeInfo.xml;
            let label = extractText(nx, 'label') || nodeInfo.name;
            let desc = extractText(nx, 'description');
            let obj = extractText(nx, 'object');
            let actType = extractText(nx, 'actionType');

            // Handling Groupings Visually in Markdown
            if (currentCond !== lastPrintedCondition) {
                outputLines.push(`> 🔀 **TRILHA CONDICIONAL ATIVA:** *${currentCond}*\n`);
                lastPrintedCondition = currentCond;
            }

            outputLines.push(`### ${nodeInfo.typeName}: ${label}\n`);
            if (desc) outputLines.push(`${desc}\n`);
            
            let finalAction = "";
            let finalObj = "";

            if (nodeInfo.type === 'recordLookups') {
                finalAction = `Busca e reestruturação da tabela de base contendo o objeto ${obj || 'relacionado'} usando chaves atreladas à etapa.`;
                finalObj = `Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de ${obj || 'registro'}.`;
            } else if (nodeInfo.type === 'assignments') {
                finalAction = `Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.`;
                finalObj = `Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.`;
            } else if (nodeInfo.type === 'recordUpdates') {
                finalAction = `Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de ${obj || 'registros'}.`;
                finalObj = `Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.`;
            } else if (nodeInfo.type === 'recordCreates') {
                finalAction = `Inicia geração transacional do tipo ${obj || 'registro'} preenchendo todos as propriedades mapeadas no decorrer do flow.`;
                finalObj = `Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.`;
            } else if (nodeInfo.type === 'actionCalls') {
                finalAction = `Dispara o endpoint de capacidades restritas e externas mapeado por ${actType || 'Action'}.`;
                finalObj = `Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.`;
            }

            if (nodeInfo.type === 'decisions') {
                if (!desc) outputLines.push(`O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.\n`);
                
                let rulesRegex = /<rules>(.*?)<\/rules>/gs;
                let rm;
                let ruleIdx = 1;

                while ((rm = rulesRegex.exec(nx)) !== null) {
                    let rx = rm[1];
                    let rLabel = extractText(rx, 'label') || `Cenário ${ruleIdx}`;
                    outputLines.push(`* **Cenário ${ruleIdx} (${rLabel}):** Assumirá a execução atrelada a esta lógica em caso próspero.`);
                    
                    let target = getTarget(rx);
                    if (target) {
                        outputLines.push(""); // spacer
                        traverse(target, `Cenário do(a) '${label}': ${rLabel}`);
                    }
                    ruleIdx++;
                }

                let dConnMatch = nx.match(/<defaultConnector>.*?<targetReference>(.*?)<\/targetReference>.*?<\/defaultConnector>/s);
                let dTarget = dConnMatch ? dConnMatch[1].trim() : null;
                let dLabel = extractText(nx, 'defaultConnectorLabel') || 'Ponto de Partida Falho / Padrão';
                outputLines.push(`* **Cenário ${ruleIdx} (${dLabel}):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.`);
                if (dTarget) {
                    outputLines.push("");
                    traverse(dTarget, `Cenário Padrão do(a) '${label}': ${dLabel}`);
                }
            } else {
                outputLines.push(`* **Ação:** ${finalAction}`);
                outputLines.push(`* **Objetivo:** ${finalObj}\n`);

                let target = getTarget(nx);
                if (target) {
                    traverse(target, currentCond);
                }
            }
        }

        if (startRef) {
            traverse(startRef, "Fluxo Principal");
        }

        // Failsafe para nós desconectados graficamente 
        Object.keys(nodesDict).forEach((k) => {
            if (!visited.has(k)) {
                traverse(k, "Trilha Desconectada / Fluxos Assíncronos / Orfãos");
            }
        });

        outputLines.push("---\n");

    } catch (e) {
        outputLines.push(`## Fluxo: ${file} (Erro ao processar Grafo)\n\n---\n`);
    }
});

fs.writeFileSync(outputFile, outputLines.join('\n').trim() + '\n', 'utf8');
console.log('Documentacao_Flows.md was grouped conceptually via DFS successfully in UTF-8.');
