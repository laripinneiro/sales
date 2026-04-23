import os
import xml.etree.ElementTree as ET

FLOWS_DIR = r"force-app\main\default\flows"
OUTPUT_FILE = r"Documentacao_Flows.md"
NS = {'ns': 'http://soap.sforce.com/2006/04/metadata'}

def extract_text(element, path):
    if element is None:
        return ""
    node = element.find(f"ns:{path}", NS)
    return node.text if node is not None else ""

def parse_flow(filepath):
    tree = ET.parse(filepath)
    root = tree.getroot()
    
    flow_label = extract_text(root, 'label')
    flow_desc = extract_text(root, 'description')
    
    if not flow_label:
        flow_label = os.path.basename(filepath).split('.')[0]
        
    doc_lines = []
    doc_lines.append(f"## Fluxo: {flow_label}")
    if flow_desc:
        doc_lines.append(f"**Objetivo do Fluxo**: {flow_desc}\n")
    else:
        doc_lines.append(f"**Objetivo do Fluxo**: Fluxo automatizado do Salesforce utilizado no núcleo de negócio.\n")
    
    components = []
    
    def process_node(node, type_name):
        name = extract_text(node, 'name')
        label = extract_text(node, 'label') or name
        desc = extract_text(node, 'description')
        
        comp_info = {"type": type_name, "label": label, "desc": desc, "details": []}
        
        if type_name == "Busca de Registro":
            obj = extract_text(node, 'object')
            comp_info['details'].append(f"**Objeto:** {obj}")
            action = f"Busca e recuperação de dados presentes no objeto {obj} de acordo com as condições definidas."
            objective = desc if desc else f"Extratificar ou identificar o registro do objeto {obj} para uso nos próximos cenários."
            comp_info['action'] = action
            comp_info['objective'] = objective
        elif type_name == "Atribuição de Variável":
            action = "Armazena ou transforma informações atualizando os valores em memória."
            objective = desc if desc else "Preparação ou formatação do pacote de dados utilizado internamente na continuidade do atendimento."
            comp_info['action'] = action
            comp_info['objective'] = objective
        elif type_name == "Decisão Lógica":
            action = "Avalia variáveis da sessão usando regras combinadas e desvia para rotas apropriadas."
            objective = desc if desc else "Identificação lógica do estado (ex: se cliente foi localizado ou não) e definição da experiência em ramificações do cenário."
            comp_info['action'] = action
            comp_info['objective'] = objective
        elif type_name == "Atualização de Registro":
            obj = extract_text(node, 'object')
            comp_info['details'].append(f"**Objeto:** {obj}")
            action = f"Altera pontualmente os dados de um ou mais registros do objeto {obj} em nuvem."
            objective = desc if desc else f"Salvar o estado final da ação atualizando permanentemente as propriedades de {obj} no banco da Org."
            comp_info['action'] = action
            comp_info['objective'] = objective
        elif type_name == "Criação de Registro":
            obj = extract_text(node, 'object')
            comp_info['details'].append(f"**Objeto:** {obj}")
            action = f"Instancia e grava um novo registro único dentro de {obj}."
            objective = desc if desc else f"Processar a criação e vinculação de informações inéditas referentes a {obj} geradas neste fluxo."
            comp_info['action'] = action
            comp_info['objective'] = objective
        elif type_name == "Ação (Action)":
            actionType = extract_text(node, 'actionType')
            action = f"Dispara a capacidade de sistema: {actionType}."
            objective = desc if desc else "Acionar capacidades da plataforma ou de classe invocável complementar à lógica primária."
            comp_info['action'] = action
            comp_info['objective'] = objective
        else:
            comp_info['action'] = "Execução de lógica intrínseca e declarada dentro do ambiente isolado da Salesforce."
            comp_info['objective'] = desc if desc else "Garantir a fluidez, resgate de valor ou continuidade para resolução final."
            
        components.append(comp_info)

    for node in root.findall('ns:start', NS):
        # Para starts, pegamos o objeto se for trigger
        start_obj = extract_text(node, 'object')
        trigger = extract_text(node, 'triggerType')
        if start_obj:
            comp_info = {
                "type": "Gatilho de Início (Start)",
                "label": "Início do Fluxo",
                "desc": "",
                "details": [f"**Objeto do Gatilho:** {start_obj}", f"**Tipo do Gatilho:** {trigger}"]
            }
            comp_info['action'] = "Espera alterações e avalia condições de início disparando de forma proativa o sistema."
            comp_info['objective'] = f"Garantir a iniciação correta da execução para modificações de {start_obj}."
            components.append(comp_info)

    for node in root.findall('ns:recordLookups', NS):
        process_node(node, "Busca de Registro")
        
    for node in root.findall('ns:assignments', NS):
        process_node(node, "Atribuição de Variável")

    for node in root.findall('ns:decisions', NS):
        process_node(node, "Decisão Lógica")

    for node in root.findall('ns:recordUpdates', NS):
        process_node(node, "Atualização de Registro")

    for node in root.findall('ns:recordCreates', NS):
        process_node(node, "Criação de Registro")
        
    for node in root.findall('ns:actionCalls', NS):
        process_node(node, "Ação (Action)")
        
    for comp in components:
        doc_lines.append(f"### {comp['type']}: {comp['label']}")
        if comp['desc']:
            doc_lines.append(f"{comp['desc']}\n")
        doc_lines.append(f"* **Ação:** {comp['action']}")
        doc_lines.append(f"* **Objetivo:** {comp['objective']}")
        for detail in comp['details']:
            doc_lines.append(f"* {detail}")
        doc_lines.append("")

    return "\n".join(doc_lines)

def main():
    root_dir = os.path.abspath(os.path.dirname(__file__))
    flows_abs_dir = os.path.join(root_dir, FLOWS_DIR)
    
    if not os.path.exists(flows_abs_dir):
        print(f"Erro: Diretório {flows_abs_dir} não encontrado.")
        return
        
    output_lines = [
        "# Documentação de Flows do Salesforce",
        "",
        "> Documento gerado de forma automática com base no processamento lógico dos metadados (*.flow-meta.xml*) para centralização da fundação dos dados do ambiente.",
        ""
    ]
    
    files = [f for f in os.listdir(flows_abs_dir) if f.endswith('.flow-meta.xml')]
    files.sort()
    
    for filename in files:
        filepath = os.path.join(flows_abs_dir, filename)
        print(f"Processando: {filename}")
        try:
            doc = parse_flow(filepath)
            output_lines.append(doc)
            output_lines.append("\n---\n")
        except Exception as e:
            print(f"Erro ao processar {filename}: {e}")
            output_lines.append(f"## Fluxo: {filename} (Erro ao ler arquivo XML)\n\n---\n")
            
    out_path = os.path.join(root_dir, OUTPUT_FILE)
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write("\n".join(output_lines))
        
    print(f"Documentado com sucesso {len(files)} arquivos de fluxo! Gerado em: {out_path}")

if __name__ == '__main__':
    main()
