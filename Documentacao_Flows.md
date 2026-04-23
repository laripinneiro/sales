# Documentação de Flows do Salesforce

## Fluxo: Rotear o caso para o mesmo agente da sessão

**Objetivo do Fluxo**: Garantir a retenção de contexto no relacionamento, enviando as próximas interações do cliente diretamente para o agente que tratou o caso ativo na sessão anterior.  
**Especificações Técnicas Gerais:**

* **Nome de API:** AgentWork_Roteia_o_caso_para_o_mesmo_agente_da_sess_o_de_mensagem
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: RecordAfterSave sobre a base de AgentWork.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter sessão

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: Obter caso da sessão

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Decisão Lógica: Caso deve ser roteado?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Nao deve ser roteado):** Assumirá a execução atrelada a esta lógica em caso próspero.
* **Cenário 2 (Sessao sem caso, continua):** Assumirá a execução atrelada a esta lógica em caso próspero.
* **Cenário 3 (Deve ser roteado):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Caso deve ser roteado?': Deve ser roteado*

### Busca de Registro: Obter agente (user) da sessão

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Ação (Action): Rotear o caso para o mesmo agente da sessão

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

---

## Fluxo: A data é hoje?

**Objetivo do Fluxo**: Automatizar e registrar as tratativas de aviso prévio para desocupação de imóvel, garantindo consistência no distrato e nos cálculos processuais de locação.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Aluguel_TransacionalDesocupao_AvisoPrevio
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: RecordAfterSave sobre a base de Contract.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Decisão Lógica: A data é hoje?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim):** Assumirá a execução atrelada a esta lógica em caso próspero.
* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
---

## Fluxo: [Bot] Assign Case to Messaging Session

**Objetivo do Fluxo**: Realizar e estabelecer o vínculo relacional no banco de dados entre a sessão ativa do WhatsApp/Bot e o Caso correspondente a solicitação atual do cliente.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Assign_Case_to_Messaging_Session
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Atualização de Registro: Atualiza a Session com o CaseId

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: [Bot] Assign new account to case

**Objetivo do Fluxo**: Atualizar retroativamente um caso já criado pelo chatbot para associá-lo ao perfil do cliente, logo após ele se autenticar ou ser cadastrado com sucesso.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Assign_new_account_to_case
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Atualização de Registro: Update Case with New Account

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Case.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: Assign new AcountId

**Objetivo do Fluxo**: Responsável por processar a árvore de triagem do bot e preencher massivamente o registro do Caso (assunto, tipo de problema, tags de agrupamento) visando o painel de atendimento.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Atualiza_Campos_do_Caso
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Case Infos

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Busca de Registro: Get Imovel do Contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisContratos__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisContratos__c.

### Decisão Lógica: Has AccountId changed?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Yes, different account):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Has AccountId changed?': Yes, different account*

### Atribuição de Variável: Assign new AcountId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Has ContractId changed?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (yes,different contract):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Has ContractId changed?': yes,different contract*

### Atribuição de Variável: Assign new ContractId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Has ImovelId changed?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (yes,different imovel):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Has ImovelId changed?': yes,different imovel*

### Atribuição de Variável: Assign new ImovelId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Update case imovel

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Case.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (no, same imovel):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Has ImovelId changed?': no, same imovel*

### Atribuição de Variável: Assign same ImovelId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 3 (no, imovel its null):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Has ImovelId changed?': no, imovel its null*

### Atribuição de Variável: Assign same ImovelId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 4 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

* **Cenário 2 (no, same contract):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Has ContractId changed?': no, same contract*

### Atribuição de Variável: Assign same ContractId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 3 (no, contract its null):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Has ContractId changed?': no, contract its null*

### Atribuição de Variável: Assign ContractId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 4 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

* **Cenário 2 (No, same account):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Has AccountId changed?': No, same account*

### Atribuição de Variável: Assign same AcountId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 3 (No, its null):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Has AccountId changed?': No, its null*

### Atribuição de Variável: Assign same AcountId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 4 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

---

## Fluxo: Atribui contractId à variavel

**Objetivo do Fluxo**: Consolidar alterações em tempo real nas propriedades do contrato imobiliário via solicitações guiadas pelo assistente virtual no canal de ponta.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Atualiza_o_Contrato
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Account

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Busca de Registro: Get Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Busca de Registro: Get imovel do Contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisContratos__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisContratos__c.

### Busca de Registro: Get Contract

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Contract usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Contract.

### Atualização de Registro: Update Contract

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Contract.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atribuição de Variável: Atribui contractId à variavel

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Add Infos Conta do Usuario

**Objetivo do Fluxo**: Atuar como motor primário de resolução de identidade, responsável por descobrir quem é o cliente por trás do chat, buscar seu perfil no CRM e atrelar contatos identificáveis.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Busca_Conta
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Sessao do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atribuição de Variável: Add infos Sessao

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obter Usuario do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Busca de Registro: Obter Conta do Usuario

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Usuario com Conta?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Com Conta):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Usuario com Conta?': Com Conta*

### Atribuição de Variável: Add Infos Conta do Usuario

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Usuario com Conta?': Resultado padrão*

### Busca de Registro: Obter Conta pelo Telefone Whatsapp

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Conta Encontrada?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Encontrada):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Conta Encontrada?': Encontrada*

### Atribuição de Variável: Add Infos Conta Encontrada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Atualiza Usuario do Messaging com Conta

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingEndUser.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Conta Encontrada?': Resultado padrão*

### Atribuição de Variável: Add Infos Conta Nao Encontrada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Atribui TRUE à vistoriaAgendada

**Objetivo do Fluxo**: Buscar no histórico e status logísticos da gestão do imóvel se existem atividades ou pendências ativas de vistorias pré-aluguel ou rescisórias neste contrato.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Checa_se_existem_vistorias_no_contrato
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Contract usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Contract.

### Busca de Registro: Get Vistorias do Contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Vistoria__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Vistoria__c.

### Decisão Lógica: Existem vistorias no contrato?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim, existem vistorias):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Existem vistorias no contrato?': Sim, existem vistorias*

### Decisão Lógica: Qual é a situação da vistoria?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Vistoria agendada):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Qual é a situação da vistoria?': Vistoria agendada*

### Atribuição de Variável: Atribui TRUE à vistoriaAgendada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Outra situação):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
* **Cenário 2 (Não):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
---

## Fluxo: Assign output: status  !=  ROTEIROABERTO

**Objetivo do Fluxo**: Informar ao proprietário do imóvel acompanhamentos e andamentos operacionais referentes à esteira e cronograma de desocupação do seu futuro inquilino sacado em rescisão.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Checa_status_da_desocupacao_Proprietario
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Messaging Session

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: Get Contracts

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Contract usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Contract.

### Decisão Lógica: Check contract status

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Contains ROTEIRO ABERTO):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Check contract status': Contains ROTEIRO ABERTO*

### Atribuição de Variável: Assign output: status  =  ROTEIROABERTO

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Check contract status': Default Outcome*

### Atribuição de Variável: Assign output: status  !=  ROTEIROABERTO

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Assign EnderecoFormatado to imovel and isBeforeToday

**Objetivo do Fluxo**: Analisar as cláusulas temporais de validade na locação, definindo se o aluguel do cliente encontra-se na janela legal para ser renovado, encerrado ou reajustado.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Check_Contract_End_Date
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Contract

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Contract usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Contract.

### Busca de Registro: Get Imovel do Contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisContratos__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisContratos__c.

### Busca de Registro: Get Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Decisão Lógica: Check contract end date

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (before today):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Check contract end date': before today*

### Atribuição de Variável: Assign EnderecoFormatado to imovel and isBeforeToday

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (before today is null):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Check contract end date': before today is null*

### Atribuição de Variável: beforeToday = false

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 3 (after today):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Check contract end date': after today*

### Atribuição de Variável: beforeToday = false

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Atribui confirmação de horário comercial

**Objetivo do Fluxo**: Motor condicional vital de roteamento que avalia globalmente se o contato do cliente encontra-se em horário operacional corporativo evitando transbordo falho em horários mortos.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Check_business_hours
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Atribuição de Variável: Atribui o horário atual

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Está dentro do horário comercial?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Está dentro do horário comercial?': Sim*

### Atribuição de Variável: Atribui confirmação de horário comercial

A variavel confirmaHorarioComercial será enviada ao bot como confirmação

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Está dentro do horário comercial?': Default Outcome*

### Decisão Lógica: Quem executa é adm?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim, estamos testando):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Quem executa é adm?': Sim, estamos testando*

### Atribuição de Variável: Confirma que é teste

A variavel confirmaHorarioComercial será enviada ao bot como confirmação

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
---

## Fluxo: Messaging Protocolo

**Objetivo do Fluxo**: Forjar, compilar e gravar a string oficial de protocolo com registro transacional durante a sessão de mensagens para auditoria legal no auto-atendimento.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Create_Protocol_Number_In_Msg
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Criação de Registro: Gerar Numero Protocolo

* **Ação:** Inicia geração transacional do tipo Protocolo__c preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Atribuição de Variável: Protocolo Id

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Is Null

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Outcome 1 of Decision 1):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Is Null': Outcome 1 of Decision 1*

### Busca de Registro: MessagingSession

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Decisão Lógica: Decision 2

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (MessagingSession Null):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Decision 2': MessagingSession Null*

### Atribuição de Variável: Messaging Protocolo

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Atualizar Messaging Session com Protocolo

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
---

## Fluxo: [Bot] Cria Caso Sem Conta

**Objetivo do Fluxo**: Efetuar a criação sistêmica do Caso primário de atendimento para contatos onde a identidade do cliente era anônima, retendo o canal conversacional solto em triagem.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Cria_Caso_Sem_Conta
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Sessao do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: Obter Tipo de Registro

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Busca de Registro: Obter Fila

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Criação de Registro: Cria Caso

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Atualização de Registro: Atualiza Sessao do Messaging Com Caso

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: Add Infos Caso

**Objetivo do Fluxo**: Mecanismo core que materializa no CRM a queixa do cliente recém logado, transcrevendo atributos do assistente virtual diretamente pro Caso referenciando o id Conta (Account) existente.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Cria_caso_para_conta_encontrada
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Sessao do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atribuição de Variável: Add infos Sessao

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obter Usuario do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Busca de Registro: Obter Conta do Usuario

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Usuario com Conta?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Com Conta):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Usuario com Conta?': Com Conta*

### Atribuição de Variável: Add Infos Conta do Usuario

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Criação de Registro: Cria Caso

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Atribuição de Variável: Add Infos Caso

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Usuario com Conta?': Resultado padrão*

### Busca de Registro: Obter Conta pelo Telefone Whatsapp

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Conta Encontrada?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Encontrada):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Conta Encontrada?': Encontrada*

### Atribuição de Variável: Add Infos Conta Encontrada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Atualiza Usuario do Messaging com Conta

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingEndUser.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Conta Encontrada?': Resultado padrão*

### Atribuição de Variável: Add Infos Conta Nao Encontrada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Assign Protocolo Id In Messaging Session

**Objetivo do Fluxo**: Componente modular orquestrador e gerador de hashes sequenciais utilizados para fins de identificação da transação ou emissão oficial da agência.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Criar_Protocolo
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Messaging Session by Id

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Criação de Registro: Create Protocolo with Messaging Session

* **Ação:** Inicia geração transacional do tipo Protocolo__c preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Atribuição de Variável: Assign Protocolo Id In Messaging Session

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Update Messaging Session with Protocolo Id

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Busca de Registro: Get Protocolo Id

Protocolo Id é o auto number do protocolo, também pode ser chamado de &quot;Protocolo Number&quot;

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Protocolo__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Protocolo__c.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: Error assignment

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Protocolo Id

**Objetivo do Fluxo**: Resgatar em tempo real a identificação registrada para entregar a resposta visível e confiável via mensagem direta com o cliente via provedor numérico.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Get_Protocol_Number
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Criação de Registro: Gerar Numero Protocolo

* **Ação:** Inicia geração transacional do tipo Protocolo__c preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Atribuição de Variável: Protocolo Id

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Assign Assistente de Conta to Output Variable

**Objetivo do Fluxo**: Rotear as peculiaridades de perfis alta-renda ou contas segmentadas trazendo para memória qual atendente/assistente especial cuida exclusivamente de tal carteira.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Obter_Assistente_de_Conta
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Busca de Registro: Obter conta do proprietário do Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Busca de Registro: Obtem UserServicePresence do Assistente conta do proprietário

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto UserServicePresence usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de UserServicePresence.

### Decisão Lógica: Are there available assistentes?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Available Assistentes):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Are there available assistentes?': Available Assistentes*

### Atribuição de Variável: Assign Assistente de Conta to Output Variable

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Are there available assistentes?': Default Outcome*

### Atribuição de Variável: Enviar Para Fila

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Assign Output Variables

**Objetivo do Fluxo**: Pesquisar de forma centralizada todas as variáveis físicas e documentais do contrato do imóvel negociado para contextualizar os macrofluxos subsequentes no assistente.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Obter_Campos_do_Contrato
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Decisão Lógica: Is ImovelId Filled?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Blank):** Assumirá a execução atrelada a esta lógica em caso próspero.
* **Cenário 2 (Filled):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Is ImovelId Filled?': Filled*

### Busca de Registro: Get ImoveisContratos

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisContratos__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisContratos__c.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Get Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Atribuição de Variável: Assign Output Variables

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Get Locação Contract

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Contract usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Contract.

### Busca de Registro: Get Record Type

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Decisão Lógica: Is &quot;Locação&quot; Contract?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Locacão):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Other type):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

---

## Fluxo: Atribui Fila às variáveis de Output

**Objetivo do Fluxo**: Procurar dados estruturais descobrindo quem é o Gestor responsável atrelado ao proprietário específico, unindo canais físicos e interações digitais em rede.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Obter_Gestor_Conta_do_prop_do_Imovel_online_ou_offline
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Busca de Registro: Obter conta do proprietario do Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Busca de Registro: Obter User do Gestor de Conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Decisão Lógica: Gestor está nulo?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim, vai pra fila):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Gestor está nulo?': Sim, vai pra fila*

### Busca de Registro: Obter Fila &quot;Relacionamento de Desocupação&quot;

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Atribuição de Variável: Atribui Fila às variáveis de Output

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Não, vai pro gestor):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Gestor está nulo?': Não, vai pro gestor*

### Atribuição de Variável: Atribui Gestor de Conta às variáveis de Output

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Assign Assistente de Conta to Output Variable

**Objetivo do Fluxo**: Motor de leitura organizacional que busca na carteira de CRM quem é o titular empregado do balcão para transferir diretamente o chamado para seu portfólio restrito.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Obter_Gestor_de_Conta
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Busca de Registro: Obter conta do proprietário do Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Busca de Registro: Obter UserServicePresence do Gestor do prop da conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto UserServicePresence usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de UserServicePresence.

### Decisão Lógica: Gestor está online?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim, gestor online):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Gestor está online?': Sim, gestor online*

### Atribuição de Variável: Assign Gestor de Conta to Output Variable

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Não, gestor offline):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Gestor está online?': Não, gestor offline*

### Busca de Registro: Get Assistente UserServicePresence

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto UserServicePresence usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de UserServicePresence.

### Decisão Lógica: Assistente online?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim, assistente online):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Assistente online?': Sim, assistente online*

### Atribuição de Variável: Assign Assistente de Conta to Output Variable

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Assistente online?': Default Outcome*

### Atribuição de Variável: Enviar Para Fila

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 3 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Gestor está online?': Default Outcome*

### Atribuição de Variável: Enviar para Fila

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Add Imovel.Id To imovelIds

**Objetivo do Fluxo**: Executar um roteamento reverso, tentando desvendar o perfil completo e endereço de um patrimônio administrado usando pequenas chaves transacionais (códigos do imóvel ou id).  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Obter_Imovel_com_Id_ou_Id_com_Imovel
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Decisão Lógica: imovelId or Imovel filled?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (imovelId (Text)):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'imovelId or Imovel filled?': imovelId (Text)*

### Busca de Registro: Get Imovel By imovelId

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

* **Cenário 2 (Imovel (Record)):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'imovelId or Imovel filled?': Imovel (Record)*

### Atribuição de Variável: Assign Id By Imovel.Id

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 3 (Both or none):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'imovelId or Imovel filled?': Both or none*

### Decisão Lógica: imovelIds or Imoveis filled?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (imovelIds (List&lt;Id&gt;)):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Imoveis (List&lt;CA_Imovel__c&gt;)):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 3 (Both or none):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Get Imovel by imovelId

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Atribuição de Variável: Add Imovel To Imoveis

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atribuição de Variável: Add Imovel.Id To imovelIds

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Atribui fila (output) e nova descrição (para concatenar)

**Objetivo do Fluxo**: Conectar e resgatar o proprietário/User ID associado ao Caso aberto anteriormente pra priorizações e fallback dinâmico caso ocorra transbordo para agentes humanos.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Obter_agente_responsavel_pelo_caso
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obtem o caso selecionado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Decisão Lógica: O Owner é fila ou usuário?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (É fila):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'O Owner é fila ou usuário?': É fila*

### Busca de Registro: Obtem CMT

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MapQueue__mdt usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MapQueue__mdt.

### Atribuição de Variável: Atribui fila de MS (output) e nova descrição (para concatenar)

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Atualiza descrição

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Case.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (É usuário):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'O Owner é fila ou usuário?': É usuário*

### Atribuição de Variável: Atribui fila (output) e nova descrição (para concatenar)

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Atribui o contrato

**Objetivo do Fluxo**: Varredura pontual em contratos para buscar a amarração jurídica atrelada a uma unidade imobiliária definida no funil pelo cliente final.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Obter_contrato_do_imovel_selecionado
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Relação: Imovel e Contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisContratos__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisContratos__c.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Obter Sessão de Mensagem

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atualização de Registro: Atualiza a sessão de mensagem

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atribuição de Variável: Atribui o contrato

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Atribuiu o contrato?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim, contrato atribuido):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
### Decisão Lógica: Verificar critérios do contrato

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Contrato Certo):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

---

## Fluxo: [Bot] Resgate de sessões perdidas

**Objetivo do Fluxo**: Restauração de conversação em filas órfãs; recupera contextos de mensagerias falhas, inoperantes ou caídas fora de timing ressuscitando a conexão de canal.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Resgate_de_sessoes_perdidas
* **Tipo de Fluxo:** RoutingFlow.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Buscar PSR Travado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto PendingServiceRouting usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de PendingServiceRouting.

### Atualização de Registro: Forçar a troca de Owner

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: Enviar Mensagem de Aviso de Inatividade

**Objetivo do Fluxo**: Gerenciador automático e encerramento sanitizado de conexões, evitando poluição nas métricas de abandono ao detectar longo tempo de inatividade do usuário no canal do Bot.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Bot_Timeout_Handler
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: PlatformEvent sobre a base de BotTimeoutEvent__e.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Messaging Session

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atribuição de Variável: Atribuição do Destinatário

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Qual Tipo de Mensagem?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Warning):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Qual Tipo de Mensagem?': Warning*

### Ação (Action): Enviar Mensagem de Aviso de Inatividade

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por sendConversationMessages.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

* **Cenário 2 (Closed):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Qual Tipo de Mensagem?': Closed*

### Ação (Action): Enviar Mensagem de Encerramento

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por sendConversationMessages.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

* **Cenário 3 (Other):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
---

## Fluxo: Montagem unique key

**Objetivo do Fluxo**: Fluxo macro de readequação e migração documental focada na substituição, inclusão ou partilha das definições operacionais perante a troca do dono do fundo do imóvel associado.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_AlteracaoProprietario
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Record Type Alteração do Proprietário

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Busca de Registro: Get Record Type Gestão Contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Busca de Registro: Get Formulário do caso

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_FormularioCaso__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_FormularioCaso__c.

### Busca de Registro: Get Group/Queue

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Busca de Registro: Get Imóvel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Decisão Lógica: Já foi encontrado um formulário com esses dados?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Já existe formulário):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Não existe):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Obter caso criado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Criação de Registro: Criar Formulário do caso

* **Ação:** Inicia geração transacional do tipo CA_FormularioCaso__c preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Busca de Registro: Obter formulários com imovel Semelhantes

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_FormularioCaso__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_FormularioCaso__c.

### Decisão Lógica: Verifica Unique Key se existe duplicata

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Não existe registro semelhante):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Verifica Unique Key se existe duplicata': Não existe registro semelhante*

### Criação de Registro: Criar caso

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

* **Cenário 2 (Existe):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: Montagem unique key

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Add Id Fila Central Alugueis Casos

**Objetivo do Fluxo**: Injetar metadados complexos do diálogo no recém forjado caso, adicionando histórico, transcrição ou detalhamentos colaterais sem precisar fechar o chamado de origem.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotAtualizaCasoCriado
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Tipo de Registro

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Busca de Registro: Obter Conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Fila ou Priprietario

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Proprietario):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Fila ou Priprietario': Proprietario*

### Decisão Lógica: Gestor De Conta Aluguéis ou Assistente Aluguéis

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Gestor De Conta Aluguéis):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Gestor De Conta Aluguéis ou Assistente Aluguéis': Gestor De Conta Aluguéis*

### Busca de Registro: Obter Gestor De Conta Aluguéis

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Atribuição de Variável: Atribui Id Owner

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Possui Gestor ou Assistente

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Possui Gestor ou Assistente': Sim*

### Atualização de Registro: Atualiza Caso

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Case.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Nao):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Possui Gestor ou Assistente': Nao*

### Busca de Registro: Obter Fila Central Alugueis Casos

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Atribuição de Variável: Add Id Fila Central Alugueis Casos

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Assistente Aluguéis):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Gestor De Conta Aluguéis ou Assistente Aluguéis': Assistente Aluguéis*

### Busca de Registro: Obter Assistente Aluguéis

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

* **Cenário 2 (Fila):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Fila ou Priprietario': Fila*

### Busca de Registro: Obter Fila

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

---

## Fluxo: Route Work (Agent)

**Objetivo do Fluxo**: Reposicionar e redirecionar ativamente o ticket conversacional na central de filas do Lightning Omni-Channel a partir de definições de SLA, habilidade ou saturação de atendimentos.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotAtualizaFilaSessaoMessaging
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Decisão Lógica: É usuário ou fila?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (É usuário):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'É usuário ou fila?': É usuário*

### Atribuição de Variável: Atribui usuário

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obtem Sessão de Mensagem

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atualização de Registro: Atualiza Fila na Sessao

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Ação (Action): Route Work (Agent)

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

* **Cenário 2 (É fila):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'É usuário ou fila?': É fila*

### Decisão Lógica: Obter fila pelo Id ou pelo Nome?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Id da Fila):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Obter fila pelo Id ou pelo Nome?': Id da Fila*

### Busca de Registro: Obtem Fila pelo Id

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Atribuição de Variável: Atribui fila

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obtem Sessão de Mensagem

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atualização de Registro: Atualiza Fila na Sessao

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Ação (Action): Route Work (Fila)

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

* **Cenário 2 (Nome da Fila):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Obter fila pelo Id ou pelo Nome?': Nome da Fila*

### Busca de Registro: Obtem Fila pelo Nome

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Atribuição de Variável: Atribui fila

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Assignment 2

**Objetivo do Fluxo**: Consumidor e pesquisador de base de conhecimento corporativa usando intenções naturalísticas propostas pelo locatário, afim de aplicar o método de 'Case Deflection'.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotBuscaArtigo
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Artigo

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Knowledge__kav usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Knowledge__kav.

### Atribuição de Variável: Contagem Artigos

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Quantos Artigos Encontrados?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Apenas 1):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Mais de 1):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 3 (Nenhum):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Quantos Artigos Encontrados?': Nenhum*

### Busca de Registro: Obter Artigos Todos

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Knowledge__kav usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Knowledge__kav.

* **Cenário 4 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Obter Artigo Selecionado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Knowledge__kav usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Knowledge__kav.

### Atribuição de Variável: Atribui Pergunta e Resposta Artigo Escolhido

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atribuição de Variável: Assignment 2

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Add Infos Caso

**Objetivo do Fluxo**: Centralizar a orquestração e desambiguação de quem é o locatário ou o proprietário, identificando registros complexos no CRM baseando-se nas interações ativas do chat AI.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotBuscaConta
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Sessao do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atribuição de Variável: Add infos Sessao

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obter Usuario do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Busca de Registro: Obter Conta do Usuario

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Usuario com Conta?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Com Conta):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Usuario com Conta?': Com Conta*

### Atribuição de Variável: Add Infos Conta do Usuario

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Criação de Registro: Cria Caso

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Atribuição de Variável: Add Infos Caso

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Usuario com Conta?': Resultado padrão*

### Busca de Registro: Obter Conta pelo Telefone Whatsapp

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Conta Encontrada?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Encontrada):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Conta Encontrada?': Encontrada*

### Atribuição de Variável: Add Infos Conta Encontrada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Atualiza Usuario do Messaging com Conta

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingEndUser.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Conta Encontrada?': Resultado padrão*

### Atribuição de Variável: Add Infos Conta Nao Encontrada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Add Com Cadastro

**Objetivo do Fluxo**: Processo resolutivo para B2B locatário ou imobiliário que executa uma validação pesada contra as contas ativas varrendo propriedades através da máscara e número do CNPJ comercial.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotBuscaContaPeloCNPJ
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Sessao do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: Obter Conta Pelo CPFCNPJ

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Com Cadastro?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Com Cadastro?': Sim*

### Atualização de Registro: Atualiza Conta no Usuario do Messaging

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingEndUser.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atribuição de Variável: Add Com Cadastro

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Não):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Com Cadastro?': Não*

### Atribuição de Variável: Add Sem Cadastro

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Ação Consultar Boletos Auxiliadora Predial

**Objetivo do Fluxo**: Realizar leitura das pendências, gerando retornos sistêmicos de extratos parcelados do aluguel viabilizando auto-pagamento e diminuição do tempo gasto pelas cobranças humanas.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotConsultaBoletos
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Ação (Action): Ação Consultar Boletos Auxiliadora Predial

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por apex.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

### Atribuição de Variável: Atribui Sucesso

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Retorno Consulta

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sucesso true):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Retorno Consulta': Sucesso true*

### Atribuição de Variável: Add Quantidade Boletos

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Ha Boletos Em Atraso?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Nao):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Ha Boletos Em Atraso?': Nao*

### Atribuição de Variável: Atribui Boletos Sem Atraso

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Erro):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Retorno Consulta': Erro*

### Atribuição de Variável: Atribui Mensagem de Erro

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: Add Lista Boletos

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atribuição de Variável: Informa Vencido Mais de 7 Dias

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Ate 7 Dias ou Mais

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Ate 7 Dias):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Mais de 7 dias):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 3 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
---

## Fluxo: Add Info Caso

**Objetivo do Fluxo**: Identificar métricas transacionais verificando volumetria de requisições por usuários, provendo inteligência corporativa, ou identificando limites diários (Rate limitations/SPAM).  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotContagemCasos
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Casos

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: Add Info Caso

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atribuição de Variável: Add Info Casos

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atribuição de Variável: Contagem Casos

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Apenas 1 ou Mais

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (1):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Default outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

### Atribuição de Variável: Preenche assunto

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Assunto está preenchido?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Preenchido):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Vazio):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

### Atualização de Registro: Atualiza Sesssao do Caso

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Case.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: Rotear o caso para agente

**Objetivo do Fluxo**: Criação complexa de caso envolvendo sub-esteiras customizadas, acionamento de SLAs de retenção e acoplamentos paralelos de dados colhidos em múltiplos forms durante sessão interativa.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotCriaCaso
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Sessao do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Decisão Lógica: Já tem caso?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Tem caso, atualiza):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Já tem caso?': Tem caso, atualiza*

### Busca de Registro: Obtem caso

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Decisão Lógica: Rotear para fila ou agente?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Para agente de atendimento):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Rotear para fila ou agente?': Para agente de atendimento*

### Busca de Registro: Obter agente (user)

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Ação (Action): Rotear o caso para agente

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

### Atualização de Registro: Atualiza Sessao do Messaging Com Caso

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Para fila de atendimento):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Rotear para fila ou agente?': Para fila de atendimento*

### Busca de Registro: Obter Fila

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Atualização de Registro: Atualiza a fila do caso

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Case.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Não tem caso, cria):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Já tem caso?': Não tem caso, cria*

### Busca de Registro: Obter Tipo de Registro

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Busca de Registro: Obter Imevel da Conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisConta__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisConta__c.

### Decisão Lógica: Redirecionar para o gestor?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim, falar com gestor):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Redirecionar para o gestor?': Sim, falar com gestor*

### Decisão Lógica: Veio do diálogo de IPTU Inq?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim, não rotear para o Omni):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Veio do diálogo de IPTU Inq?': Sim, não rotear para o Omni*

### Criação de Registro: Cria Caso sem rotear

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Busca de Registro: Obter caso criado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Atualização de Registro: Atualizar Fila do caso criado

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Case.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atribuição de Variável: Atribui endereço do imovel e caseId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Não, rotear para o Omni):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Veio do diálogo de IPTU Inq?': Não, rotear para o Omni*

### Criação de Registro: Cria Caso

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Busca de Registro: Obtem fila de fallback (caso o agente esteja indisponível)

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Ação (Action): Rotear o caso para o gestor

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

### Atribuição de Variável: Atribui endereço do imovel e caseId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Não, fila de atendimento):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Redirecionar para o gestor?': Não, fila de atendimento*

### Busca de Registro: Obter Fila

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Busca de Registro: Obtem usuário Padrão

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Criação de Registro: Cria Caso

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Atribuição de Variável: Atribui endereço do imovel e caseId

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: [Bot] Não é Cliente, Apaga Conta do Usuario

**Objetivo do Fluxo**: Sanear e desativar informações residuais na base atreladas a usuários temporários de mensageria que não passaram na validação primária ou são leads improdutivos perante as contas ativas do CRM.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotNaoClienteApagaContaUsuario
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Sessao

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atualização de Registro: Atualizar Usuario do Messagin

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingEndUser.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: Add infos Caso Selecionado

**Objetivo do Fluxo**: Permitir que o cliente que detém mais de um processo ativo selecione e o bot carregue a integridade de dados exata para tratamento focado na dúvida referente à respectiva demanda da pauta corrente.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotObterCasoSelecionado
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Sessao

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: Obter Conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Busca de Registro: Obter Caso Selecionado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Decisão Lógica: Caso Encontrado?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Encontrado):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Caso Encontrado?': Encontrado*

### Atualização de Registro: Atualiza Caso na Sessao

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atualização de Registro: Atualiza Sessao no Caso

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Case.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atribuição de Variável: Add infos Caso Selecionado

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Não Encontrado):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Caso Encontrado?': Não Encontrado*

### Atribuição de Variável: Caso Nao encontrado

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Add Ids Imoveis

**Objetivo do Fluxo**: Levantamento panorâmico que localiza e compila todas as edificações/lotes vinculados a uma conta e exibe como portfólio num menu carrossel guiando a tomada de decisão do dono do patrimônio.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotObterImoveisConta
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Imoveis da Conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisConta__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisConta__c.

### Decisão Lógica: Conta Com Imoveis?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Não):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Conta Com Imoveis?': Não*

### Atribuição de Variável: Informa Sem Imoveis

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Obter Imoveis

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Atribuição de Variável: Contagem de Imóveis

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obter Imoveis do Contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisContratos__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisContratos__c.

### Busca de Registro: Obter sessão

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atualização de Registro: Atualizar sessão com imóvel

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atribuição de Variável: imovelContract assignment

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atribuição de Variável: Add Ids Imoveis

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atribuição de Variável: Add Lista Imoveis

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atribuição de Variável: Imovel do Contrato Assignment

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Contrato é da mesma conta e ativo?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Mesma conta e ativo):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Conta diferente ou inativo):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

### Decisão Lógica: Quantidade de imóveis é um

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Um):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Não):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
---

## Fluxo: Add Se Proprietario ou Inquilino

**Objetivo do Fluxo**: Triar as instâncias do imóvel com alta granularidade filtrada por qual tipo de parte operante (Fiador, Proprietário Exclusivo ou Cônjuge) determinou o contato central validando papéis específicos de acesso.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotObterImovelContaTipoRelacionamento
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter seção do messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: Obter Imovel Selecionado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Decisão Lógica: Imovel foi Encontrado?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Imovel Encontrado):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Imovel foi Encontrado?': Imovel Encontrado*

### Busca de Registro: Obter Imovel da Conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisConta__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisConta__c.

### Atribuição de Variável: Assign Tipo de Relacionamento

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obter Imovel do contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisContratos__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisContratos__c.

* **Cenário 2 (Nao Encontrado):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Imovel foi Encontrado?': Nao Encontrado*

### Atribuição de Variável: Atribui Erro na Busca

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: Add Se Proprietario ou Inquilino

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atribuição de Variável: Imovel do Contrato Assignment

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Atualizar a seção do messaging

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Decisão Lógica: Imovel da Conta Foi Encontrado?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Encontrado):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Nao Encontrado):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

### Decisão Lógica: Contrato é da mesma conta?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Mesma conta):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Conta diferente):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

---

## Fluxo: Add Conferencia

**Objetivo do Fluxo**: Pilar de segurança perimetral transacional; valida rigorosamente o formato, checksum e a identidade documental repassada, coibindo vazamento de informação de faturamento corporativo.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_BotValidaCPFCNPJParaBuscarBoletos
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Atribuição de Variável: Assignment 2

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: CPF/CNPJ normalizado?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (sim, normalizado):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'CPF/CNPJ normalizado?': sim, normalizado*

### Decisão Lógica: Confere CPF/CNPJ da Conta

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Confere):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Confere CPF/CNPJ da Conta': Confere*

### Atribuição de Variável: Add Conferencia

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Não Confere):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
---

## Fluxo: Verificar se o E-mail pertence a uma Conta

**Objetivo do Fluxo**: Direcionamento interno de suporte focado em escalar assistentes especializados para demandas financeiras complexas de faturamento das contas em andamento na Auxiliadora Predial.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_CasoAssistenteContas
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: RecordAfterSave sobre a base de Case.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Fila Central Aluguéis

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Busca de Registro: Obter Email Conta Assistente

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Verificar se o E-mail pertence a uma Conta

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Achou Email):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Verificar se o E-mail pertence a uma Conta': Achou Email*

### Atualização de Registro: Atualizar Caso Com Conta Vinculado

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atualização de Registro: Atualizar Owner

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Não achou Email):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Verificar se o E-mail pertence a uma Conta': Não achou Email*

### Atualização de Registro: Atualizar case Owner Fila Central Aluguéis

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: atribuiParentCase

**Objetivo do Fluxo**: Tratativa generalista em back-office gerada ativamente durante a prospecção ou suporte de um negócio imobiliário isolado garantindo que a base crie o invólucro do Case Salesforce.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_CasoNovoCaso
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: getCaseRecordId

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Atribuição de Variável: atribuiParentCase

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: getCase

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Atribuição de Variável: atribuiVariaveisVarCase

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Criação de Registro: criarLead

* **Ação:** Inicia geração transacional do tipo registro preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

---

## Fluxo: [Casos] - Automatizar alteração do status de Novo → Trabalhando (omni)

**Objetivo do Fluxo**: Motor gatilho de SLA no tempo de tela focado no atendente: detecta manipulação do objeto do chamado em 'Novo' e o transaciona massivamente pra 'Trabalhando' no clique primário.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_CasosAutomatizarAlteracaoStatusNovoTrabalhando
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: RecordAfterSave sobre a base de AgentWork.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Case

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Atualização de Registro: Atualizar Casos

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de Case.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: [Casos] - Preencher com os Campos de Contato da Conta em Casos

**Objetivo do Fluxo**: Fluxo utilitário responsável por enriquecer o contexto isolado e o tracking retroativo, garantindo que telefones e contatos essenciais fiquem espelhados em cache instantâneo nas properties cruciais na mesa do operador.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_CasosPreencherCamposContatoContaCasos
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: RecordAfterSave sobre a base de Case.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Buscar dados da Conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Atualização de Registro: Atualizar Whatsapp

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atualização de Registro: Atualizar Telefone

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atualização de Registro: Atualizar Telefone Comercial

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: Rotear para Fila Central Alugueis

**Objetivo do Fluxo**: O cérebro maestro do Omni-Channel da operação Auxiliadora Predial: categoriza pesos, define aptidões cruciais da conversação e transborda à carteira de atendimento humano garantindo melhor skill e SLA.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_RotearAuxiliadoraPredial
* **Tipo de Fluxo:** RoutingFlow.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter Sessao

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: Obter Conta

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Fila Preenchida?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Sim):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Fila Preenchida?': Sim*

### Atribuição de Variável: Add Nome Fila Encontrada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obter Fila

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Decisão Lógica: Fila ou Owner

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Owner):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Fila ou Owner': Owner*

### Decisão Lógica: Verifica Perfil Alugueis

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Premium):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Verifica Perfil Alugueis': Premium*

### Decisão Lógica: Gestor ou Assistente

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Gestor):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Gestor ou Assistente': Gestor*

### Busca de Registro: Obter Gestor De Conta Aluguéis

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Decisão Lógica: Gestor Preenchido na Conta?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Gestor Preenchido):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Gestor Preenchido na Conta?': Gestor Preenchido*

### Atribuição de Variável: Atribui Id Agente

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: agentId Preenchida?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Preenchida):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'agentId Preenchida?': Preenchida*

### Ação (Action): Verifica Disponibilidade

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por checkAvailabilityForRouting.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

### Decisão Lógica: Tranfere ou Aguarda

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Transfere):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Tranfere ou Aguarda': Transfere*

### Ação (Action): Rotear para Owner

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Tranfere ou Aguarda': Resultado padrão*

### Ação (Action): Rotear para Fila Central Alugueis

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

* **Cenário 2 (Nao):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

* **Cenário 2 (Gestor Não Preeenchido):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Gestor Preenchido na Conta?': Gestor Não Preeenchido*

### Busca de Registro: Obter Assistente Aluguéis

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Decisão Lógica: Assistente Preenchido na Conta?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Assistente Preenchido):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Nao Preenchido):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

* **Cenário 2 (Assistente Aluguéis):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

* **Cenário 2 (Essencial):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

* **Cenário 2 (Proprietario do Caso):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Fila ou Owner': Proprietario do Caso*

### Atribuição de Variável: Atribui Id do Proprietario do caso na Variaval Agent Id

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 3 (Fila):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Fila ou Owner': Fila*

### Ação (Action): Rotear de Auxiliadora Predial

Roteia todas as mensagens para fila Atendimento

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

* **Cenário 2 (Não):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Fila Preenchida?': Não*

### Atribuição de Variável: Add Nome Fila Central Alugueis

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: atribuiCasoPai

**Objetivo do Fluxo**: Componentização do fechamento das conversões conversacionais que solidifica pontualmente em background toda e qualquer thread interativa aberta gerada durante roteamento nativo sem interjeições.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_SessaoMensagemCriarNovoCaso
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: getSessionMessage

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: getCaseSessaoMensagem

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Atribuição de Variável: atribuiCasoPai

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: getCase

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Atribuição de Variável: atribuiVariaveisVarCase

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Criação de Registro: criarLead

* **Ação:** Inicia geração transacional do tipo registro preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

---

## Fluxo: atribuicaoNovoAtribuido

**Objetivo do Fluxo**: Atribuição em loop pós-inatividade da thread: rotear conversas ativas ou sessões abandonadas pelo antigo proprietário relocado, definindo a transição ao melhor novo humano operante do salão.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_SessaoMensagemNovaAtribuicao
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: getBuscarUser

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Atribuição de Variável: atribuicaoNovoAtribuido

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: atualizaVarNovoAtribuido

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: [Sessão de Mensagem] Vincula Conta Proprietário

**Objetivo do Fluxo**: Amarração de canal focada fortemente no Perfil Proprietário, vinculando sessões do MessagingSession especificamente focadas nas peculiaridades de administração unificando métricas e jornadas separadas entre Inquilino VIP e Dono.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_SessaoMensagemVinculaContaProprietario
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: RecordAfterSave sobre a base de MessagingSession.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: getUsuarioMensagem

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Busca de Registro: getImovelContaProprietario

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_ImoveisConta__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_ImoveisConta__c.

### Atualização de Registro: updateProprietárioImovel

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: Montagem unique key

**Objetivo do Fluxo**: Processo massivo jurídico para analisar viabilidade, colher registros creditícios e encaminhar o subcaso focado exclusivamente no refatoramento de assinaturas e troca de um Fiador ativo em um contrato assinado.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_TrocaGarantiaFiador
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Record Type Troca Garantia Fiador

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Busca de Registro: Get Record Type Gestão Contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Busca de Registro: Get Formulário do caso

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_FormularioCaso__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_FormularioCaso__c.

### Busca de Registro: Get Group/Queue

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Busca de Registro: Get Imóvel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Decisão Lógica: Verifica Existência do formulário

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Já existe formulário):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Não existe):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Obter caso criado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Criação de Registro: Criar Formulário do caso

* **Ação:** Inicia geração transacional do tipo CA_FormularioCaso__c preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Busca de Registro: Obter formulários com imovel Semelhantes

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_FormularioCaso__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_FormularioCaso__c.

### Decisão Lógica: Verifica Unique Key se existe duplicata

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Não existe registro semelhante):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Verifica Unique Key se existe duplicata': Não existe registro semelhante*

### Criação de Registro: Criar caso

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

* **Cenário 2 (Existe):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: Montagem unique key

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Montagem unique key

**Objetivo do Fluxo**: Sub-variação da trilha de seguros aluguel, efetuando o fluxo resolutivo guiado da transação da modificação de títulos de capitalização, CredPago ou depósitos isolados, focando nas especificações e portais desses terceiros extra-Salesforce.  
**Especificações Técnicas Gerais:**

* **Nome de API:** CA_TrocaGarantiaNaoFiador
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Record Type Troca Garantia (Não Fiador)

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Busca de Registro: Get Record Type Gestão Contrato

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto RecordType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de RecordType.

### Busca de Registro: Get Formulário do caso

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_FormularioCaso__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_FormularioCaso__c.

### Busca de Registro: Get Group/Queue

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Busca de Registro: Get Imóvel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Decisão Lógica: Já foi encontrado um formulário com esses dados?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Já existe formulário):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Não existe):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Obter caso criado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Criação de Registro: Criar Formulário do caso

* **Ação:** Inicia geração transacional do tipo CA_FormularioCaso__c preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Busca de Registro: Obter formulários com imovel Semelhantes

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_FormularioCaso__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_FormularioCaso__c.

### Decisão Lógica: Verifica Unique Key se existe duplicata

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Não existe registro semelhante):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Verifica Unique Key se existe duplicata': Não existe registro semelhante*

### Criação de Registro: Criar caso

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

* **Cenário 2 (Existe):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: Montagem unique key

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: [Case] Assign Case MessagingSession Manually

**Objetivo do Fluxo**: Utilitário on-demand de ação manual perante o desktop do Operador permitindo que o humano vincule forçosamente um Messaging Session desconexo para fins de tracking posterior, fundindo as tabelas de conversas à base dos registros analíticos.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Case_Assign_Case_MessagingSession_Manually
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: RecordAfterSave sobre a base de Case.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Atualização de Registro: Update Case-MS field

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Busca de Registro: Get MS by Updated MS in Case

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atualização de Registro: Update MS by MS selected in case

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: Assign true to hadUploaded

**Objetivo do Fluxo**: Automatizador responsável por atrelar fisicamente arquivos, assinaturas digitais ou fotos tiradas remotamente pelo aplicativo no repositório final de Salesforce Content anexado ao seu Caso respectivo de reparos/suportes limitando ruídos de perda sistêmica.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Case_Attach_File_Flow
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: Assign true to hadUploaded

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Files Uploaded

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Has Uploaded is True):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Erro):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

### Decisão Lógica: Has Uploaded?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (SUCESS):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Erro):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.
---

## Fluxo: SendEmailApex

**Objetivo do Fluxo**: Componente robusto de notificação asíncrona; dispara em transações e alterações de status definidos na API de tickets, templates validados via e-mail direto pro fornecedor parceiro ou cliente do imóvel locado gerando log interno.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Case_Send_Email_Action
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Case Infos

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Busca de Registro: Get Case Owner User

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Busca de Registro: Get Imovel-Account from Case Info

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

### Busca de Registro: Get Case-Account Infos

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: setEmailToSend

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Ação (Action): SendEmailApex

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por apex.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

---

## Fluxo: Send WhatsApp Action

**Objetivo do Fluxo**: Trabalhar de forma desacoplada efetuando envio das HSMs oficiais nativos da META usando variáveis de interpolação baseadas em gatilhos do processo de vida de um caso na nuvem da Salesforce interagindo o usuário.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Case_Send_WhatsApp
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Case

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Busca de Registro: Get Imovel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Get Messaging User With 9

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Decisão Lógica: Check User Existence With 9

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (User Found With 9):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Check User Existence With 9': User Found With 9*

### Decisão Lógica: Check Consent Status With 9

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Any &quot;Opted In&quot; Option w/9):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Check Consent Status With 9': Any &quot;Opted In&quot; Option w/9*

### Atribuição de Variável: Assign Existing ID With 9

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Update Messaging User With 9

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Atribuição de Variável: Add to Collection

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Ação (Action): Send WhatsApp Action

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por sendConversationMessages.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

### Atribuição de Variável: Assign Task Fields

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Criação de Registro: Create Completed Whatsapp Task

* **Ação:** Inicia geração transacional do tipo Task preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Criação de Registro: Create WhatsApp_Session_Update__e

* **Ação:** Inicia geração transacional do tipo WhatsApp_Session_Update__e preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

* **Cenário 2 (Opted Out w/9):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

* **Cenário 2 (Non-existent User):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Check User Existence With 9': Non-existent User*

### Decisão Lógica: Is With or Without 9?

regra atual (14/01/2026):
DDD 11 até 28: com 9
outro DDD: sem 9

* **Cenário 1 (With 9):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Is With or Without 9?': With 9*

### Atribuição de Variável: Assign With 9

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Criação de Registro: Create New Messaging User

* **Ação:** Inicia geração transacional do tipo MessagingEndUser preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

* **Cenário 2 (Without 9):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Is With or Without 9?': Without 9*

### Atribuição de Variável: Assign Without 9

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Get Messaging User With Cleaned Phone

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Decisão Lógica: Check User Existence With Cleaned Phone

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (User Found With Cleaned Phone):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Check User Existence With Cleaned Phone': User Found With Cleaned Phone*

### Decisão Lógica: Check Consent Status With Cleaned Phone

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Any &quot;Opted In&quot; Option w/cleanedPhone):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Check Consent Status With Cleaned Phone': Any &quot;Opted In&quot; Option w/cleanedPhone*

### Atribuição de Variável: Assign Existing Id With Cleaned Phone

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Update Messaging User With Cleaned Phone

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Opted Out w/cleanedPhone):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

* **Cenário 2 (User Not Found With Cleaned Phone):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Get Messaging User Without 9

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Decisão Lógica: Check User Existence Without 9

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (User Found Without 9):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Check User Existence Without 9': User Found Without 9*

### Decisão Lógica: Check Consent Status Without 9

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Any &quot;Opted In&quot; Option wo/9):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Check Consent Status Without 9': Any &quot;Opted In&quot; Option wo/9*

### Atribuição de Variável: Assign Existing ID Without 9

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Update Messaging User Without 9

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Opted Out wo/9):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

* **Cenário 2 (User Not Found Without 9):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Get Whatsapp Channel

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingChannel usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingChannel.

### Decisão Lógica: Validate Mobile BR Phone Format

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Valid Mobile BR Phone):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Invalid Mobile BR Phone):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

### Criação de Registro: Create New Messaging User With Cleaned Phone

* **Ação:** Inicia geração transacional do tipo MessagingEndUser preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

---

## Fluxo: Send Whatsapp

**Objetivo do Fluxo**: Ação global exposta para outras arquiteturas e Flows paralelos delegarem o processamento de entrega e enfileiramento proativo de mensageria Whatsapp para alertar e mover a jornada ativamente para a palma do inquilino de um Caso específico.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Case_Send_WhatsApp_Action
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Case Infos

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Busca de Registro: Get Case-Account Info

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Busca de Registro: Get Imovel-Account from Case Info

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CA_Imovel__c usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CA_Imovel__c.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: Get MessagingSession by Account

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atualização de Registro: Update Messag. Session CaseId

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Ação (Action): Send Whatsapp

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por sendConversationMessages.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

### Busca de Registro: Get Messaging Users from messaging platform key

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Busca de Registro: Get Messaging Users from Selected Accounts

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Decisão Lógica: Has it found some messaging user?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Not found):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Yes):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

### Busca de Registro: Get MessagingSession by Account

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Decisão Lógica: Has It Found MessagingSession?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Not found):** Assumirá a execução atrelada a esta lógica em caso próspero.

* **Cenário 2 (Yes):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

### Atribuição de Variável: Assign each MessagingUser to MessagingUserList

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Decisão Lógica: Is MessagingConsentStatus Opted Out?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Yes):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Is MessagingConsentStatus Opted Out?': Yes*

### Atribuição de Variável: Assign MessagingConsentStatus To list

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Atribuição de Variável: Assign phones values

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Update MessagingEndUsers

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

---

## Fluxo: Set variable

**Objetivo do Fluxo**: Operação silenciosa retroativa de limpeza e indexação de dados, garantindo que lookup pointers (chaves estrangeiras) de total dimensionamento fiquem consistentes ao se contar volume agregado ao cliente de faturamento mensal.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Caso_Preenche_Campo_Casos_da_Conta
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: RecordBeforeSave sobre a base de MessagingSession.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Atribuição de Variável: Set variable

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Send Custom Notification Action 1

**Objetivo do Fluxo**: Motor de retenção de SLAs e alertas que soa notificações CustomPush no sino interno do console Lightning para o atendente corretor encarregado sempre que seu cliente devolver uma réplica por correio eletrônico em andamento em instâncias fechadas de email.  
**Especificações Técnicas Gerais:**

* **Nome de API:** EmailMessage_Send_custom_notification_when_an_email_is_replied
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: RecordAfterSave sobre a base de EmailMessage.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter caso relacionado

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Busca de Registro: Obter owner (user) do caso

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto User usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de User.

### Atribuição de Variável: Atribuir o owner à lista de owners

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obter notificação personalizada

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto CustomNotificationType usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de CustomNotificationType.

### Ação (Action): Send Custom Notification Action 1

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por customNotificationAction.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

---

## Fluxo: [MessagingSession] Log a Call - Custom Action

**Objetivo do Fluxo**: Acelerador focado em produtizar CallLogs pós encerramentos de tickets da esteira unificada transcrevendo resumos dos bate papos escritos aos relatórios gerenciais nativos de telemetria baseados nos contatos ativos telefônicos operantes na imobiliária.  
**Especificações Técnicas Gerais:**

* **Nome de API:** MessagingSession_Log_a_Call_Custom_Action
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get MessagingSession Records

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: Get Account infos From MS Records

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Criação de Registro: Create new task

* **Ação:** Inicia geração transacional do tipo Task preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

---

## Fluxo: Send Email Action 1

**Objetivo do Fluxo**: Fluxo que intertextualiza canais: permite compilar uma transcrição, fatura ou resumo conversacional em PDF nativamente provindo do chat para um correio eletrônico assíncrono repassado como termo contábil final formal aos envolvidos na sessão.  
**Especificações Técnicas Gerais:**

* **Nome de API:** MessagingSession_Send_Email
* **Tipo de Fluxo:** Flow (Fluxo de Tela).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get MessagingSession

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Trilha Desconectada / Fluxos Assíncronos / Orfãos*

### Busca de Registro: GetSelectedAccountEmail

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Ação (Action): Send Email Action 1

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por emailSimple.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

---

## Fluxo: Rotear para a fila Error Handling

**Objetivo do Fluxo**: Mecanismo defensivo de tratamento de lógicas quebradas operacionais durante conexões corrompidas de mensageria onde este flow entra exibindo alertas de degradação finalizando lógicas mortas para as equipes infra sem aborrecer no endpoint final cliente.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Messaging_Session_Error_Handling
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Obter sessão de mensagem

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Busca de Registro: Obter Fila Error Handling

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Ação (Action): Rotear para a fila Error Handling

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

---

## Fluxo: Rotear(Fila)

**Objetivo do Fluxo**: Cerebro logístico da alocação via Lightning Omni-Studio: verifica as premissas, a fila de contingência global da arquitetura, e direciona o pedaço virtual das sessões instantâneas ao próximo analista imobiliário apto e disponível das métricas estipuladas.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Omni_flow_Rotear_para_usuario_ou_fila
* **Tipo de Fluxo:** RoutingFlow.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Decisão Lógica: É usuário ou fila?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (É usuario):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'É usuário ou fila?': É usuario*

### Atribuição de Variável: Atribui usuário

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obtem a sessão de mensagem

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atribuição de Variável: Atribui valores

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Atualiza Fila na Sessao

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Ação (Action): Rotear(Usuario)

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

* **Cenário 2 (É fila):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'É usuário ou fila?': É fila*

### Busca de Registro: Obtem Fila

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Group usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Group.

### Atribuição de Variável: Atribui fila

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obtem a sessão de mensagem

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atribuição de Variável: Atribui valores

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Atualiza Fila na Sessao

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de registros.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Ação (Action): Rotear(Fila)

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

---

## Fluxo: Add Infos Conta do Usuario

**Objetivo do Fluxo**: Algoritmo estritamente operacional atrelado nos blocos formativos para auto-incremento, hash padronizado e formatações exigidas nos diários de contato formal sob portarias gerando unicidade para cada interação da operação Auxiliadora Predial.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Protocol_Number
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Atribuição de Variável: Atribuição 6

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obter Sessao do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atribuição de Variável: Add infos Sessao

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Busca de Registro: Obter Usuario do Messaging

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingEndUser usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingEndUser.

### Busca de Registro: Obter Conta do Usuario

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Usuario com Conta?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Com Conta):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Usuario com Conta?': Com Conta*

### Atribuição de Variável: Add Infos Conta do Usuario

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Criação de Registro: Cria Caso

* **Ação:** Inicia geração transacional do tipo Case preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

### Busca de Registro: Obter Numero Caso

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Case usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Case.

### Atribuição de Variável: Atribui CaseNumber

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Usuario com Conta?': Resultado padrão*

### Busca de Registro: Obter Conta pelo Telefone Whatsapp

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto Account usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de Account.

### Decisão Lógica: Conta Encontrada?

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Encontrada):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Conta Encontrada?': Encontrada*

### Atribuição de Variável: Add Infos Conta Encontrada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

### Atualização de Registro: Atualiza Usuario do Messaging com Conta

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingEndUser.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

* **Cenário 2 (Resultado padrão):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Conta Encontrada?': Resultado padrão*

### Atribuição de Variável: Add Infos Conta Nao Encontrada

* **Ação:** Atribui ou manipulação local computacional aos arrays ou variáveis da estrutura.
* **Objetivo:** Montar e consolidar os pacotes de dados processados utilizados internamente na continuidade ou devolução.

---

## Fluxo: Rotear para agente atual

**Objetivo do Fluxo**: Integração central de triagem base da marca onde consolida dezenas de esteiras numa malha comum determinando as origens macros perante as necessidades vitais do negócio entre locações comerciais, transações residenciais, corretores etc.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Route_to_Auxiliadora_Predial
* **Tipo de Fluxo:** RoutingFlow.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Buscar Sessão

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Decisão Lógica: Verificar Dono da Sessão

O sistema toma a bifurcação de caminho baseando-se em lógicas booleanas exclusivas calculadas.

* **Cenário 1 (Agente Humano):** Assumirá a execução atrelada a esta lógica em caso próspero.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário do(a) 'Verificar Dono da Sessão': Agente Humano*

### Ação (Action): Rotear para agente atual

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

* **Cenário 2 (Default Outcome):** Via fallback o sistema executa esta rota em caso de invalidações nas validações centrais.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Cenário Padrão do(a) 'Verificar Dono da Sessão': Default Outcome*

### Ação (Action): Rotear para Auxiliadora Predial

Roteia todas as mensagens para o bot aprimorado.

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

---

## Fluxo: Route to Teste Debug

**Objetivo do Fluxo**: Redirecionamento isolado com premissas dummy desenvolvido perante o ambiente core para fins de Quality Assurance, viabilizando que desenvolvedores testem scripts e bots na UI e validações com dados sem sujar logs comerciais reais operantes no piso da central de processamentos.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Route_to_Teste_Debug
* **Tipo de Fluxo:** RoutingFlow.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Ação (Action): Route to Teste Debug

Routes all messages to your enhanced bot.

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por routeWork.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

---

## Fluxo: Update MessagingSession From WhatsApp Activation - PlatformEvent Handler

**Objetivo do Fluxo**: Subscritor arquitetado e ativado via 'Platform Events' escutando retornos da mensageria (Opt-ins), destravando gatilhos contínuos de atualizações nos registros e abrindo interatividade oficial para contatos perante regulamentações WhatsApp/Meta e LGPD estritas.  
**Especificações Técnicas Gerais:**

* **Nome de API:** Update_MessagingSession_From_WhatsApp_Activation_PlatformEvent_Handler
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

### Gatilho de Início (Start): Entrada do Fluxo

Ponto de entrada do sistema identificando os eventos ativos da transação.

* **Ação:** Espera e valida alterações ativando execução automática sob condição Trigger: PlatformEvent sobre a base de WhatsApp_Session_Update__e.
* **Objetivo:** Estabelecer arquitetura sistêmica em tempo real e orquestrar metadados da mesa deste processo.

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Busca de Registro: Get Messaging Session By PlatformEvent

* **Ação:** Busca e reestruturação da tabela de base contendo o objeto MessagingSession usando chaves atreladas à etapa.
* **Objetivo:** Identificar localmente de forma unitária via lookups permitindo que próximos branches herdem as instâncias de MessagingSession.

### Atualização de Registro: Update Messaging Session

* **Ação:** Alteração restrita (update/upsert) nos dados da nuvem referenciadas em IDs de MessagingSession.
* **Objetivo:** Gravar com persistência absoluta o bloco mutado pela lógica gerando log no repositório.

### Criação de Registro: Save SessionId and UserId on Platform Event

* **Ação:** Inicia geração transacional do tipo NewMessagingSession__e preenchendo todos as propriedades mapeadas no decorrer do flow.
* **Objetivo:** Registrar existencialmente para rastreamento físico criando ligações orgânicas em banco de dados.

---

## Fluxo: Ação Enviar mensagem de WhatsApp

**Objetivo do Fluxo**: Processo atrelado à cadência e orquestração residual das campanhas (Pardot/Marketing Cloud) de comunicação sistêmica do sistema identificadas como numerais na rede interna para acoplamentos analíticos de envios automáticos para a publicidade na ponta.  
**Especificações Técnicas Gerais:**

* **Nome de API:** flow_701U600000pWkwoIAC_1769558910010
* **Tipo de Fluxo:** AutoLaunchedFlow (Fluxo iniciado automaticamente).

> 🔀 **TRILHA CONDICIONAL ATIVA:** *Fluxo Principal*

### Ação (Action): Ação Enviar mensagem de WhatsApp

* **Ação:** Dispara o endpoint de capacidades restritas e externas mapeado por sendWhatsAppMessage.
* **Objetivo:** Acionar comportamentos e engenharias assíncronas do negócio que escapam o simples manipulamento de variaveis locais.

---

## Fluxo: Pontuação de promotor líquida

**Objetivo do Fluxo**: Coleta, centraliza, e tabula pesquisas relacionais e táticas do modelo clássico Net Promoter Score (NPS), fornecendo estatísticas de viabilidade estratégica de alocações e indicações calculadas pela retenção líquida dos promotores sobre passivos nos núcleos centrais da companhia.  
**Especificações Técnicas Gerais:**

* **Nome de API:** pontua_o_de_promotor_l_quida
* **Tipo de Fluxo:** Survey.

---

## Fluxo: Satisfação do cliente

**Objetivo do Fluxo**: Rastrear de forma macro as classificações absolutas das notas dadas e transcrições em sentimentos de usuários repassados pro funil CSAT logo em decorrência do término dos contratos fechados e operacionais transacionais avaliando a equipe como global de satisfação CS.  
**Especificações Técnicas Gerais:**

* **Nome de API:** satisfa_o_do_cliente
* **Tipo de Fluxo:** Survey.

---
