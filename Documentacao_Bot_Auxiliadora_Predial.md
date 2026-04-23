# Documentação de Negócio — Bot Auxiliadora Predial (v37)

> Documentação gerada a partir do arquivo de metadados 37.botVersion-meta.xml.
> Contém **151 diálogos** organizados por grupo de diálogo, documentados com objetivos de negócio, interações, automações e regras de roteamento.

---

## Início - Busca Casos

### Diálogo: BuscaCasos (BuscaCasos)

**Objetivo do Diálogo:** Verificar a existência de chamados em aberto vinculados à conta do cliente. Define o caminho do atendimento: clientes sem casos são direcionados para abertura de novo chamado; clientes com casos recebem a opção de tratar um chamado existente.

#### Ação 1 : Consulta ao Salesforce — CA_BotContagemCasos

O bot aciona a automação **CA_BotContagemCasos** para: **Consultar o número de casos em aberto vinculados à conta do cliente autenticado**.

* **Dados Enviados para a Automação:**
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *CaseSubject* ← parâmetro de retorno *CaseSubject*
  * Variável de sessão *CasesId* ← parâmetro de retorno *CasesId*
  * Variável de sessão *QtdCasos* (*Quantidade de casos em aberto do cliente*) ← parâmetro de retorno *QtdCasos*
  * Variável de sessão *ListaCasos* ← parâmetro de retorno *ListaCasos*
  * Variável de sessão *CaseStatus* ← parâmetro de retorno *CaseStatus*
  * Variável de sessão *CaseNumber* (*Número legível do caso, apresentado ao cliente*) ← parâmetro de retorno *CaseNumber*
  * Variável de sessão *UnicoCaso* ← parâmetro de retorno *IdCaso*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *QtdCasos* (*Quantidade de casos em aberto do cliente*) é igual a *"0"*
  * **Destino:** [Caso Novo]
* **Cenario B:** Se a variável *QtdCasos* (*Quantidade de casos em aberto do cliente*) é maior que *"0"*
  * **Destino:** [Com Casos]

---

### Diálogo: Com Casos (Com_Casos)

**Objetivo do Diálogo:** Apresentar ao cliente a lista de chamados em aberto e perguntar se deseja prosseguir com um deles. Permite ao cliente optar por interagir com um chamado existente ou abrir um novo.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"BUSCA_CASO_COM_CASO"*
  * **CasoExistenteNovo** (*Intenção do cliente: tratar caso existente ou abrir novo*) → limpo/redefinido

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Verificamos que você possui chamados abertos. *Quer falar sobre um deles?*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **CasoExistenteNovo** (*Intenção do cliente: tratar caso existente ou abrir novo*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Sim"*
  * *"Não"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *CasoExistenteNovo* (*Intenção do cliente: tratar caso existente ou abrir novo*) é igual a *"Sim"*
  * **Destino:** [CasoExistente]
* **Cenario B:** Se a variável *CasoExistenteNovo* (*Intenção do cliente: tratar caso existente ou abrir novo*) é igual a *"Não"*
  * Limpa **CaseId** (*ID do caso (chamado) vinculado ao atendimento atual*)
  * **Destino:** [Caso Novo]

---

### Diálogo: CasoExistente (CasoExistente)

**Objetivo do Diálogo:** Ramificar o tratamento de casos existentes conforme a quantidade: um único caso é apresentado diretamente; múltiplos casos exigem que o cliente selecione o desejado.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *QtdCasos* (*Quantidade de casos em aberto do cliente*) é maior que *"1"*
  * **Destino:** [VariosCasos]
* **Cenario B:** Se a variável *QtdCasos* (*Quantidade de casos em aberto do cliente*) é igual a *"1"*
  * **Destino:** [UnicoCaso]

---

### Diálogo: Caso Novo (CasoNovo)

**Objetivo do Diálogo:** Buscar os imóveis vinculados à conta do cliente para determinar o perfil do atendimento. Direciona para o menu específico (Inquilino ou Proprietário) quando há um único imóvel, ou para seleção de imóvel quando há múltiplos.

#### Ação 1 : Consulta ao Salesforce — CA_BotObterImoveisConta

O bot aciona a automação **CA_BotObterImoveisConta** para: **Recuperar a lista de imóveis ativos vinculados à conta do cliente, incluindo perfil do relacionamento (Inquilino ou Proprietário)**.

* **Dados Enviados para a Automação:**
  * Parâmetro *idRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *imovelContractId* ← parâmetro de retorno *imovelContract*
  * Variável de sessão *ImoveisId* ← parâmetro de retorno *ColecaoImoveis*
  * Variável de sessão *ListaImoveis* (*Lista de imóveis vinculados à conta (ou 'Sem Imóveis')*) ← parâmetro de retorno *ListaImoveis*
  * Variável de sessão *NumeroDeImoveis* (*Contagem de imóveis ativos vinculados à conta*) ← parâmetro de retorno *numeroDeImoveis*
  * Variável de sessão *relacionamentoNome* (*Tipo de relacionamento do cliente com o imóvel (Inquilino ou Proprietário)*) ← parâmetro de retorno *relacionamentoNome*
  * Variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*) ← parâmetro de retorno *imovelId*
  * Variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*) ← parâmetro de retorno *ImovelSelecionado*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *ListaImoveis* (*Lista de imóveis vinculados à conta (ou 'Sem Imóveis')*) é igual a *"Sem Imóveis"*
  * **Destino:** [Sem Imóveis]
* **Cenario B:** Se a variável *NumeroDeImoveis* (*Contagem de imóveis ativos vinculados à conta*) é igual a *"1"* **E** a variável *relacionamentoNome* (*Tipo de relacionamento do cliente com o imóvel (Inquilino ou Proprietário)*) é igual a *"Inquilino"*
  * **Destino:** [Menu Inquilino]
* **Cenario C:** Se a variável *NumeroDeImoveis* (*Contagem de imóveis ativos vinculados à conta*) é igual a *"1"* **E** a variável *relacionamentoNome* (*Tipo de relacionamento do cliente com o imóvel (Inquilino ou Proprietário)*) é igual a *"Proprietário"*
  * **Destino:** [Menu Proprietario]
* **Cenario D (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Caso Novo - Selecione Um Imovel Para Falar]

---

### Diálogo: Sem Imóveis (Sem_Imoveis)

**Objetivo do Diálogo:** Tratar clientes autenticados mas sem imóveis vinculados à conta. Apresenta alternativas de autoatendimento (Auxiliadora Digital e Central de Ajuda) ou transferência para atendente humano.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Não encontramos nenhum imóvel vinculado à sua conta.* O que você deseja fazer agora?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **OqueFazerAgora** (*Opção escolhida pelo cliente sem imóveis vinculados*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Auxiliadora Digital"*
  * *"Central de Ajuda"*
  * *"Falar com atendente"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *OqueFazerAgora* (*Opção escolhida pelo cliente sem imóveis vinculados*) é igual a *"Auxiliadora Digital"*
  * Mensagem exibida: *"Acesse pelo site https://portal.auxiliadorapredial.com.br/Login.aspx"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *OqueFazerAgora* (*Opção escolhida pelo cliente sem imóveis vinculados*) é igual a *"Central de Ajuda"*
  * Mensagem exibida: *"Acesse pelo site https://auxiliadorapredial.my.site.com/centraldeajuda/s/"*
  * **Destino:** [Lógica de Resolução]
* **Cenario C:** Se a variável *OqueFazerAgora* (*Opção escolhida pelo cliente sem imóveis vinculados*) é igual a *"Falar com atendente"*
  * **Destino:** [Cria Caso Sem Imoveis]

---

### Diálogo: Cria Caso Sem Imoveis (Atualiza_Caso_Sem_Imoveis)

**Objetivo do Diálogo:** Criar e configurar um caso no Salesforce para clientes sem imóveis vinculados que optaram por falar com um atendente. Define os metadados do caso e encaminha para a fila correta.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Outros Assuntos"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → copiado de *OqueFazerAgora*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixo"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Central Aluguéis"*

#### Ação 2 : Consulta ao Salesforce — CA_BotCriaCaso

O bot aciona a automação **CA_BotCriaCaso** para: **Criar um novo caso no Salesforce com os metadados coletados durante o atendimento (tipo, motivo, prioridade, fila e imóvel)**.

* **Dados Enviados para a Automação:**
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *newCaseId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Atualiza Sessão de Mensagem (Transfere a sessão)]

---

### Diálogo: UnicoCaso (UnicoCaso)

**Objetivo do Diálogo:** Apresentar o único caso em aberto do cliente e encaminhá-lo para atendimento humano vinculado a esse chamado específico.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 Certo! Verifiquei que você tem o seguinte chamado em andamento {!CaseSubject}.

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **CaseId** (*ID do caso (chamado) vinculado ao atendimento atual*) → copiado de *UnicoCaso*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Transferir para Agente Responsável]

---

### Diálogo: VariosCasos (VariosCasos)

**Objetivo do Diálogo:** Exibir a lista de múltiplos chamados em aberto e permitir que o cliente selecione o de interesse. Valida a seleção e redireciona para transferência ao atendente responsável.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"BUSCA_CASOS_VARIOS_CASOS"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Certo!* Verifiquei que você tem os seguintes chamados em andamento. *Sobre qual* deles *você gostaria de falar?*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **CasoSelecionado** (*Caso escolhido pelo cliente quando há múltiplos em aberto*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.

#### Ação 3 : Consulta ao Salesforce — CA_BotObterCasoSelecionado

O bot aciona a automação **CA_BotObterCasoSelecionado** para: **Buscar os detalhes do caso selecionado pelo cliente para vinculação ao atendimento**.

* **Dados Enviados para a Automação:**
  * Parâmetro *CaseSelected* ← variável de sessão *CaseSelected*
  * Parâmetro *CasoSelecionado* ← variável de sessão *CasoSelecionado* (*Caso escolhido pelo cliente quando há múltiplos em aberto*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *CaseId*
  * Variável de sessão *CaseStatus* ← parâmetro de retorno *CaseStatus*
  * Variável de sessão *CasoEncontrado* (*Flag de resultado da busca pelo caso selecionado pelo cliente*) ← parâmetro de retorno *CasoEncontrado*
  * Variável de sessão *CaseSubject* ← parâmetro de retorno *CaseSubject*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *CasoEncontrado* (*Flag de resultado da busca pelo caso selecionado pelo cliente*) é igual a *"Não"*
  * Limpa **CasoSelecionado** (*Caso escolhido pelo cliente quando há múltiplos em aberto*)
  * Limpa **CasoEncontrado** (*Flag de resultado da busca pelo caso selecionado pelo cliente*)
  * Mensagem exibida: *"Não encontrado! Digite corretamente o número do caso."*
  * **Destino:** [VariosCasos]
* **Cenario B:** Se a variável *CasoEncontrado* (*Flag de resultado da busca pelo caso selecionado pelo cliente*) é diferente de *"Não"*
  * **Destino:** [Transferir para Agente Responsável]
* **Cenario C (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Atualiza Caso Chamado Em Atendimento (Atualiza_Caso_Chamado_Em_Atendimento)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Atualiza Caso Chamado Em Atendimento** dentro do contexto de busca e tratamento de casos existentes. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Compreendi!* Para ajudar você com essa questão, estou *te transferindo para um atendente.*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Aguarde um momento, ele vai te responder aqui mesmo.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Outros Assuntos"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → copiado de *UnicoCaso*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixo"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Assistente Aluguéis"*

#### Ação 4 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)

#### Ação 5 : Automação de Retaguarda — CA_BotAtualizaCasoCriado

O bot aciona a automação **CA_BotAtualizaCasoCriado** para: **Atualizar o caso já criado no Salesforce com as informações complementares coletadas durante o atendimento**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *Descricao* ← variável de sessão *Descricao* (*Descrição livre informada pelo cliente sobre sua demanda*)
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *CaseSelected* ← variável de sessão *CaseSelected*
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *ImovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)

#### Ação 6 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 7 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Olá! Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**

---

### Diálogo: Caso Novo - Selecione Um Imovel Para Falar (Selecione_Um_Imovel_Para_Falar)

**Objetivo do Diálogo:** Quando o cliente possui múltiplos imóveis, exibir a lista e solicitar que selecione aquele sobre o qual deseja falar. O imóvel selecionado determina o perfil e o menu de atendimento subsequente.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"CASONOVO_SELEC_IMOVEL"*
  * **ImovelSelecionado** (*Nome/endereço do imóvel selecionado*) → limpo/redefinido

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Para começar o seu atendimento, por favor, *me diga sobre qual dos seus imóveis você gostaria de falar:*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **ImovelSelecionado** (*Nome/endereço do imóvel selecionado*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **ImovelSelecionado** (*Nome/endereço do imóvel selecionado*) → copiado de *ImovelSelecionado*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Ação 4 : Consulta ao Salesforce — CA_BotObterImovelContaTipoRelacionamento

O bot aciona a automação **CA_BotObterImovelContaTipoRelacionamento** para: **Executar a automação **CA_BotObterImovelContaTipoRelacionamento** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *IdRoteavel* ← variável de sessão *MessagingSession* (*ID da sessão de messaging no Salesforce*)
  * Parâmetro *ImovelSelected* ← variável de sessão *ImovelSelectecd*
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *FalhaBuscaImovel* ← parâmetro de retorno *FalhaBuscaImovel*
  * Variável de sessão *TipoRelacionamento* ← parâmetro de retorno *TipoRelacionamento*
  * Variável de sessão *Endereco* ← parâmetro de retorno *Endereco*
  * Variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*) ← parâmetro de retorno *ImovelId*
  * Variável de sessão *Cidade* ← parâmetro de retorno *Cidade*
  * Variável de sessão *imovelContractId* ← parâmetro de retorno *imovelContract*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *FalhaBuscaImovel* é igual a *"true"*
  * Mensagem exibida: *"Não encontrado! Confira o número do imóvel."*
  * **Destino:** [Caso Novo]
* **Cenario B:** Se a variável *FalhaBuscaImovel* é igual a *"false"* **OU** a variável *TipoRelacionamento* está preenchido
  * **Destino:** [Obter o contrato do imóvel selecionado]
* **Cenario C:** Se a variável *TipoRelacionamento* é igual a *"Inquilino"* **E** a variável *FalhaBuscaImovel* é igual a *"false"*
  * **Destino:** [Menu Inquilino]
* **Cenario D:** Se a variável *TipoRelacionamento* é igual a *"Proprietário"* **E** a variável *FalhaBuscaImovel* é igual a *"false"*
  * **Destino:** [Menu Proprietario]

---

### Diálogo: Transferir para Agente Responsável (Trasferir_para_um_Agente)

**Objetivo do Diálogo:** Executar a transferência da conversa para um agente humano vinculado ao caso em andamento. Consolida as informações da sessão antes da transferência.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"BUSCA_CASO_TRANSFERE_AGENTE_RESP"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Enquanto *transfiro seu atendimento*, me conta: *qual é a sua dúvida sobre esse chamado*?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **RespostaDigitada**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"BUSCA_CASOS_VARIOS_CASOS"*
  * Mensagem exibida: *"*Ok*! 😊"*
* **Cenario B:** Se a variável *RespostaDigitada* está preenchido
  * **Destino:** [Obter agente responsável pelo caso]
* **Cenario C (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Obter agente responsável pelo caso (Obter_agente_responsavel_pelo_caso)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Obter agente responsável pelo caso** dentro do contexto de busca e tratamento de casos existentes. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — Bot_Obter_agente_responsavel_pelo_caso

O bot aciona a automação **Bot_Obter_agente_responsavel_pelo_caso** para: **Executar a automação **Bot_Obter_agente_responsavel_pelo_caso** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *newDescriptionToAdd* ← variável de sessão *NovaDescricao*
  * Parâmetro *recordId* ← variável de sessão *UnicoCaso*
* **Dados Retornados pela Automação:**
  * Variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*) ← parâmetro de retorno *fila*

---

## Confusos

### Diálogo: Confuso 2 (Confuso_2)

**Objetivo do Diálogo:** Tratamento da segunda entrada inválida consecutiva. Verifica o horário comercial e, se disponível, realiza a transferência imediata para um atendente humano. Fora do horário, notifica o cliente e encerra o chat.

#### Ação 1 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Novamente, não te compreendi, então vou te transferir para um atendente.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Aguarde um momento, ele vai te responder aqui mesmo.

#### Ação 4 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Novamente, não te compreendi, mas nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**

---

### Diálogo: Confuso (Confused)

**Objetivo do Diálogo:** Tratamento da primeira entrada inválida do cliente. Registra o evento com contador de erros, emite resposta de não compreensão e reapresenta o último menu ativo com base na variável de rastreamento de contexto (LastMenu).

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Desculpe, não entendi isso.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *InvalidInputCount* (*Contador de entradas inválidas consecutivas, usado para acionar a escalada para atendimento humano*) é igual a *"0"*
  * **InvalidInputCount** (*Contador de entradas inválidas consecutivas, usado para acionar a escalada para atendimento humano*) = *"1"*
* **Cenario B:** Se a variável *InvalidInputCount* (*Contador de entradas inválidas consecutivas, usado para acionar a escalada para atendimento humano*) não está preenchido
  * **InvalidInputCount** (*Contador de entradas inválidas consecutivas, usado para acionar a escalada para atendimento humano*) = *"0"*
* **Cenario C:** Se a variável *InvalidInputCount* (*Contador de entradas inválidas consecutivas, usado para acionar a escalada para atendimento humano*) é maior ou igual a *"1"*
  * **Destino:** [Confuso 2]
* **Cenario D:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"CONTA_ENCONTRADA"*
  * **Destino:** [Conta Encontrada]
* **Cenario E:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"SIM_SOU_CLIENTE"*
  * **Destino:** [SimSouCliente]
* **Cenario F:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"COM_CADASTRO"*
  * **Destino:** [ComCadastro]
* **Cenario G:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"CASONOVO_SELEC_IMOVEL"*
  * **Destino:** [Caso Novo - Selecione Um Imovel Para Falar]
* **Cenario H:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MENU_INQ"*
  * **Destino:** [Menu Inquilino]
* **Cenario I:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MENU_PROP"*
  * **Destino:** [Menu Proprietario]
* **Cenario J:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"PAG_FINAN_INQ"*
  * **Destino:** [Pagamentos e Financeiro Inquilino]
* **Cenario K:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"2_VIA_BOL_INQ"*
  * **Destino:** [2 via do Boleto]
* **Cenario L:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"2_VIA_BOL_ERRO"*
  * **Destino:** [2 via bol- Erro Consulta]
* **Cenario M:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"2_VIA_BOL_CNPJCPF_NAOCONFERE"*
  * **Destino:** [2 via bol- CPFCNPJNaoConfere]
* **Cenario N:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"2_VIA_BOL_SEM_BOL"*
  * **Destino:** [2 via bol- Sem Boletos Vencidos]
* **Cenario O:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DUV_BOL_INQ"*
  * **Destino:** [Dúvidas Boletos Inquilino]
* **Cenario P:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"COMPROV_INQ"*
  * **Destino:** [Comprovantes de Pagamento Inquilino]
* **Cenario Q:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"COMPROV_INQ_MENSAL"*
  * **Destino:** [Comprovante mensal inquilino]
* **Cenario R:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"COMPROV_INQ_PERIODO"*
  * **Destino:** [Comprovante de um período Inquilino]
* **Cenario S:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DEB_CONT_INQ"*
  * **Destino:** [Débito em Conta Inquilino]
* **Cenario T:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DEB_CONT_INQ_CADASTRO"*
  * **Destino:** [Débito em conta - Cadastrar]
* **Cenario U:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DEB_CONT_INQ_EXCLUI"*
  * **Destino:** [Débito em conta - Excluir]
* **Cenario V:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"NEGOC_INQ"*
  * **Destino:** [Negociação Inquilino]
* **Cenario W:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"IPTU_INQ"*
  * **Destino:** [IPTU inquilino]
* **Cenario X:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"PAG_FINAN_PROP"*
  * **Destino:** [Pagamentos e Financeiro Proprietario]
* **Cenario Y:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"EXTRATO_PROP"*
  * **Destino:** [Extrato]
* **Cenario Z:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"EXT_TENHO_DUV"*
  * **Destino:** [Extrato Prop - Tenho dúvidas sobre o extrato]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"EXT_RECEBE_DEMONSTRATIVO"*
  * **Destino:** [Extrato Prop - Receber demonstrativo]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"ALT_DADOS_BANC_PROP"*
  * **Destino:** [Alteração de dados bancários]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"INF_REND_PROP"*
  * **Destino:** [Informe de Rendimentos/DIMOB]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"INF_REND_DUVIDA"*
  * **Destino:** [Informe Rend - Dúvidas ou ajustes no informe]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"INF_REND_RECEBE_INF"*
  * **Destino:** [Informe Rend- Receber Informe de Rendimentos]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"NAO_RECEB_ALUG_PROP"*
  * **Destino:** [Não Recebi Meu Aluguel - Cria Caso]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"IPTU_PROP"*
  * **Destino:** [IPTU Proprietario]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"NF_PROP"*
  * **Destino:** [NF Proprietario]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_PROP"*
  * **Destino:** [Desocup. & Vist. (Prop)]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_INQ"*
  * **Destino:** [Desocup. & Vist. (Inquilino)]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_INQ_FINALIZADO"*
  * **Destino:** [D & V(Inqui) - Contrato Finalizado]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_INQ_DESOCUPAR"*
  * **Destino:** [D & V(Inqui) - Solicitar a desocupação]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_INQ_VISTORIA"*
  * **Destino:** [D & V (Inqui) - Vistoria]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_INQ_NEGOCIAR"*
  * **Destino:** [D & V (Inqui) - Negociar desocupação]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_INQ_2_VIA"*
  * **Destino:** [D & V (Inqui) - 2ª via do contrato]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_INQ_CONTESTAR_VISTORIA"*
  * **Destino:** [D & V (Inqui) - Contestar laudo/reparos da vistoria]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CONT_PROP"*
  * **Destino:** [Meu Contrato Proprietario]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CONT_INQ"*
  * **Destino:** [Meu Contrato Inquilino]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MAN_REP_PROP"*
  * **Destino:** [Manutenção e Reparos Proprietario]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MAN_REP_INQ"*
  * **Destino:** [Manutenção e Reparos Inquilino]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MAN_REP_INQ"*
  * **Destino:** [Manutenção e Reparos Inquilino]
* **Cenario :** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MAN_REP_INQ_SOLICITA_MANU"*
  * **Destino:** [ManRepInq - Solicitar manutenção]
* **Cenario  (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso 1]

---

### Diálogo: Confuso 1 (Confuso_1)

**Objetivo do Diálogo:** Tratamento da primeira entrada inválida do cliente. Registra o evento com contador de erros, emite resposta de não compreensão e reapresenta o último menu ativo com base na variável de rastreamento de contexto (LastMenu).

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CONT_INQ_TROCA_TITULAR"*
  * **Destino:** [MeuCtrt - Troca de titularidade]
* **Cenario B:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CONT_INQ_TROCA_GARANTIA"*
  * **Destino:** [MeuCtrt - Troca de garantia]
* **Cenario C:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CONT_INQ_ATUALIZA_DADOS"*
  * **Destino:** [MeuCtrt - Atualização de dados cadastrais]
* **Cenario D:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CONT_INQ_ACESSA_AUXI"*
  * **Destino:** [MeuCtrt - Acessar Auxiliadora Digital]
* **Cenario E:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MAN_REP_PROP_DUVIDA_RESPONSA"*
  * **Destino:** [ManRepProp - Dúvida de responsabilidade]
* **Cenario F:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MAN_REP_PROP_SOLICITA_MANU"*
  * **Destino:** [ManRepProp - Solicitar manutenção]
* **Cenario G:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_PROP_SEM_DESOCUP"*
  * **Destino:** [D & V(Prop) - Sem desocupação]
* **Cenario H:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_PROP_VISTORIA_SAIDA"*
  * **Destino:** [D & V(Prop) - Vistoria de saída]
* **Cenario I:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DESOC_VIS_PROP_SOLICITA_DESOCUPA"*
  * **Destino:** [D & V(Prop) - Solicitar a desocupação]
* **Cenario J:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CONT_PROP_ALTERAR_PROP"*
  * **Destino:** [MeuCtrt - Alterar proprietário]
* **Cenario K:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CONT_PROP_INFOS"*
  * **Destino:** [MeuCtrt - Informações sobre contrato]
* **Cenario L:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CONT_PROP_VENDER_IMOVEL"*
  * **Destino:** [MeuCtrt - Quero vender meu imóvel]
* **Cenario M:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"BUSCA_CASO_TRANSFERE_AGENTE_RESP"*
  * **Destino:** [Transferir para Agente Responsável]
* **Cenario N:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"BUSCA_CASOS_VARIOS_CASOS"*
  * **Destino:** [VariosCasos]
* **Cenario O:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DUV_BOL_INQ_ART_NAO_ENCONTRADO"*
  * **Destino:** [Dúvida Boleto - ArtigoNaoEncontrado - Inquilino]
* **Cenario P:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"DUV_BOL_INQ_ART_ENCONTRADO"*
  * **Destino:** [Dúvida Boleto - ArtigoEncontrado - Inquilino]
* **Cenario Q:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"BUSCA_CASO_COM_CASO"*
  * **Destino:** [Com Casos]
* **Cenario R:** Se a variável *LastMenu* (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) é igual a *"MEU_CTRT_PROP_ATUALIZACAOCADASTRAL"*
  * **Destino:** [AtualizacaoCadastralProprietario]
* **Cenario S (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso 2]

---

## Desocupação e Vistoria (Inquilino)

### Diálogo: D & V (Inqui) - Informações sobre a desocupação (D_V_Inqui_Informacoes_sobre_a_desocupacao)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - Informações sobre a desocupação** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — Bot_Check_Contract_End_Date

O bot aciona a automação **Bot_Check_Contract_End_Date** para: **Executar a automação **Bot_Check_Contract_End_Date** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *contractId* ← variável de sessão *imovelContractId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *imovelEndereco* ← parâmetro de retorno *imovelEnderecoFormatado*
  * Variável de sessão *isBeforeToday* ← parâmetro de retorno *isBeforeToday*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *isBeforeToday* é igual a *"false"*
  * **Destino:** [D & V(Inqui) - Contrato não finalizado]
* **Cenario B (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [D & V(Inqui) - Contrato Finalizado]

---

### Diálogo: D & V(Inqui) - Contrato Finalizado (D_V_Inqui_Contrato_Finalizado)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Inqui) - Contrato Finalizado** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_INQ_FINALIZADO"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 📝 Verificamos seu contrato. Para seguir com a desocupação, é necessário enviar o Aviso Prévio com 30 dias de antecedência. Nesse período, o aluguel e encargos continuam sendo cobrados. Deseja iniciar o processo e registrar o aviso prévio?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **selectedDesocupacaoEVistoria**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Quero iniciar"*
  * *"Agora não"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Quero iniciar"* **E** a variável *isAvisoDesocupacao* é igual a *"false"*
  * Mensagem exibida: *"✅ O *aviso prévio do imóvel {!imovelEndereco}* foi registrado."*
  * **Destino:** [D & V (Inqui) - Motivo da desocupação]
* **Cenario B:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Quero iniciar"* **E** a variável *isAvisoDesocupacao* é igual a *"true"*
  * Mensagem exibida: *"✅ O *aviso prévio do imóvel {!imovelEndereco}* foi registrado."*
* **Cenario C:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Agora não"*
  * **Destino:** [Lógica de Resolução]
* **Cenario D (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [D & V(Inqui) - Solicitar a desocupação]

---

### Diálogo: D & V(Inqui) - Contrato não finalizado (D_V_Inqui_Contrato_n_o_finalizado)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Inqui) - Contrato não finalizado** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📝 Para seguir com a desocupação do imóvel, precisamos confirmar se o seu contrato já venceu ou não:

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *- Aviso Prévio*: quando o contrato *já venceu* ou *cumpriu os 12 meses mínimos (se houver)*. Você tem *30 dias para desocupar*, e *os dias restantes são cobrados* mesmo com entrega antecipada das chaves.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *- Multa Contratual*: se a saída for *antes do término do contrato*, será aplicada *multa proporcional* ao tempo que *faltar*.

#### Ação 4 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **DV_Inqui_Contrato_nao_finalizado_o_que_deseja_fazer** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **selectedDesocupacaoEVistoria**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Simulação da multa"*
  * **Destino:** [D & V (Inqui) - Quero simulação de multa]
* **Cenario B:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"2ª via do meu contrato"*
  * **Destino:** [D & V (Inqui) - 2ª via do contrato]
* **Cenario C:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Solicitar desocupação"*
  * **Destino:** [D & V (Inqui) - Quero solicitar a desocupação]
* **Cenario D:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Não vou desocupar"*
  * **Destino:** [Lógica de Resolução]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: D & V (Inqui) - Aviso de desocupação (D_V_Inqui_Aviso_de_desocupa_o)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - Aviso de desocupação** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **isAvisoDesocupacao** → *"true"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [D & V (Inqui) - Informações sobre a desocupação]

---

### Diálogo: D & V (Inqui) - Devoluções de chaves (D_V_Inqui_Devolucoes_de_chaves)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - Devoluções de chaves** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Devolução de chaves"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Devolução de Chaves"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Média"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **falarComGestor_inputFlow** → *"false"*
  * **deveCriarCaso** → *"false"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: D & V (Inqui) - Vistoria (D_V_Inqui_Vistoria)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - Vistoria** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_INQ_VISTORIA"*
  * **selectedDesocupacaoEVistoria** → limpo/redefinido

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Menu_devolu_o_e_vistoria_inquilino_Visitoria** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **selectedDesocupacaoEVistoria**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Agendar vistoria"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Vistoria"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Agendamento de vistoria"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Alta"*
* **Cenario B:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Agendar vistoria"*
  * **falarComGestor_inputFlow** = *"false"*
  * **deveCriarCaso** = *"false"*
* **Cenario C:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Cancelar vistoria"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Vistoria"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Cancelamento de vistoria"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Alta"*
* **Cenario D:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Cancelar vistoria"*
  * **falarComGestor_inputFlow** = *"false"*
  * **deveCriarCaso** = *"false"*
* **Cenario E:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Contestar laudo"*
  * **Destino:** [D & V (Inqui) - Contestar laudo/reparos da vistoria]
* **Cenario F:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Desocup. & Vist. (Inquilino)]
* **Cenario G (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: D & V (Inqui) - Negociar desocupação (D_V_Inqui_Negociar_desocupa_o)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - Negociar desocupação** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_INQ_NEGOCIAR"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 🏡 Para analisarmos sua solicitação, preciso que me informe:

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 1. *Motivo da desocupação* 2. *Data* que pretende entregar o imóvel 3. Se deseja negociar *multa contratual* 4. Se precisa de prazo para realizar *reparos/manutenções* 5. Outras condições que gostaria de propor (ex.: desconto, carência, benfeitorias etc.)

#### Ação 4 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Com essas informações conseguimos avaliar e apresentar sua proposta ao proprietário de forma mais rápida e assertiva 😉

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **RespostaDigitada**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *RespostaDigitada* está preenchido
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Negociação"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Negociação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Condições de Desocupação"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Alta"*
* **Cenario B:** Se a variável *RespostaDigitada* está preenchido
  * **Destino:** [Cria ou atualiza caso]
* **Cenario C:** Se a variável *RespostaDigitada* está preenchido
  * Mensagem exibida: *"✅ *Sua proposta foi registrada!* Nossa equipe encaminhará ao proprietário, que terá um prazo para avaliar. Assim que tivermos um retorno, entraremos em contato com você!"*
* **Cenario D (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Lógica de Resolução]

---

### Diálogo: D & V(Inqui) - Solicitar a desocupação (D_V_Inqui_Solicitar_a_desocupa_o)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Inqui) - Solicitar a desocupação** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_INQ_DESOCUPAR"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Você tem *30 dias para desocupar* a partir de hoje.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> - A vistoria deve ser *agendada com 10 dias de antecedência* por este canal.

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> - Se entregar as chaves antes, *os dias restantes* do aviso prévio *serão cobrados* no boleto final.

#### Ação 5 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **D_V_Inqui_Agendar_vistoria** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **selectedDesocupacaoEVistoria**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.

#### Ação 6 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alta"*
  * **motivoEscolhido** → copiado de *motivoDesocupacaoSelecionado*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Agendar vistoria agora"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Vistoria"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Agendamento de vistoria"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Alta"*
* **Cenario B:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Agendar vistoria agora"*
  * **Destino:** [Falar Com Atendente (Cria Caso)]
* **Cenario C:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Agendar vistoria depois"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Aviso de desocupação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Aviso Previo"*
* **Cenario D:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Agendar vistoria depois"*
  * **Destino:** [Lógica de Resolução]

---

### Diálogo: D & V (Inqui) - 2ª via do contrato (D_V_Inqui_2_via_do_contrato)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - 2ª via do contrato** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_INQ_2_VIA"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 📲 *Entendido!* Sem problemas. Você pode *acessar seus documentos e informações* de forma rápida e segura pela *Auxiliadora Digital*, usando seu CPF e senha.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **selectedDesocupacaoEVistoria**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Auxiliadora Digital"*
  * *"Falar com atendente"*
  * *"Menu anterior"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Auxiliadora Digital"*
  * Mensagem exibida: *"Para acessar a Auxiliadora Digital, clique aqui: https://portal.auxiliadorapredial.com.br/Login.aspx"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Falar com atendente"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Gestão Contrato"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Informações do contrato"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"2ª via contrato"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Baixa"*
* **Cenario C:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Falar com atendente"*
  * **deveCriarCaso** = *"false"*
  * **falarComGestor_inputFlow** = *"false"*
* **Cenario D:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Menu anterior"*
  * **Destino:** [D & V(Inqui) - Contrato não finalizado]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: D & V (Inqui) - Contestar laudo/reparos da vistoria (D_V_Inqui_Contestar_laudo_reparos_da_vistoria)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - Contestar laudo/reparos da vistoria** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_INQ_CONTESTAR_VISTORIA"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 *Entendido*! Após a *vistoria de desocupação*, caso sejam *apontados reparos*, você receberá um *relatório com a descrição dos itens*.

#### Ação 3 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Se *discorda* ou *tem dúvidas* sobre algum ponto, *liste aqui os itens e o motivo da sua contestação* para que nossa equipe *possa analisar*.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **RespostaDigitada**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Vistoria"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Contestação de vistoria"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alta"*

#### Ação 5 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **motivoEscolhido** → copiado de *RespostaDigitada*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: D & V (Inqui) - Motivo da desocupação (D_V_Inqui_Motivo_da_desocupacao)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - Motivo da desocupação** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Devolu_o_e_vistoria_do_inquilino_Motivo_da_Desocupa_o** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **motivoDesocupacaoSelecionado**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.

#### Ação 2 : Automação de Retaguarda — Bot_Atualiza_o_Contrato

O bot aciona a automação **Bot_Atualiza_o_Contrato** para: **Executar a automação **Bot_Atualiza_o_Contrato** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *imovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *motivoEscolhido* ← variável de sessão *motivoEscolhido*
  * Parâmetro *messagingSessionId* ← variável de sessão *MessagingSession* (*ID da sessão de messaging no Salesforce*)
  * Parâmetro *contractId* ← variável de sessão *imovelContractId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *motivoDesocupacaoSelecionado* está preenchido
  * **deveCriarCaso** = *"false"*

---

### Diálogo: D & V (Inqui) - Quero simulação de multa (D_V_Inqui_Quero_simula_o_de_multa)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - Quero simulação de multa** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Desocupação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Simulação Multa Contratual"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alta"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **deveCriarCaso** → *"false"*
  * **falarComGestor_inputFlow** → *"false"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: D & V (Inqui) - Quero solicitar a desocupação (D_V_Inqui_Quero_solicitar_a_desocupacao)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V (Inqui) - Quero solicitar a desocupação** dentro do contexto de processos de desocupação e vistoria do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Desocupação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Aviso de desocupação"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alta"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **deveCriarCaso** → *"false"*
  * **falarComGestor_inputFlow** → *"false"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

## Desocupação e Vistoria (Proprietário)

### Diálogo: D & V(Prop) -  Informações sobre desocupação (Status_do_Aviso_Previo_do_Contrato_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) -  Informações sobre desocupação** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — Bot_Checa_status_da_desocupacao_Proprietario

O bot aciona a automação **Bot_Checa_status_da_desocupacao_Proprietario** para: **Executar a automação **Bot_Checa_status_da_desocupacao_Proprietario** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *recordId* ← variável de sessão *RoutableId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *isStatusRoteiroAberto* ← parâmetro de retorno *IsStatusRoteiroAberto*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *isStatusRoteiroAberto* é igual a *"true"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Desocupação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Informações de desocupação"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Média"*
* **Cenario B:** Se a variável *isStatusRoteiroAberto* é igual a *"true"*
  * **deveCriarCaso** = *"false"*
  * **Destino:** [Falar Com Atendente (Cria Caso)]
* **Cenario C (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [D & V(Prop) - Sem desocupação]

---

### Diálogo: D & V(Prop) - Solicitar a desocupação (Solicitar_a_desocupa_o)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Solicitar a desocupação** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_PROP_SOLICITA_DESOCUPA"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Ok. Enquanto verifico as condições do seu contrato, você poderia me contar por qual motivo deseja solicitar a desocupação do imóvel?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MotivoDesocupacao**.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **motivoEscolhido** → copiado de *MotivoDesocupacao*

#### Ação 4 : Consulta ao Salesforce — Bot_Check_Contract_End_Date

O bot aciona a automação **Bot_Check_Contract_End_Date** para: **Executar a automação **Bot_Check_Contract_End_Date** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *contractId* ← variável de sessão *imovelContractId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *isBeforeToday* ← parâmetro de retorno *isBeforeToday*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *isBeforeToday* é igual a *"false"*
  * **Destino:** [D & V(Prop) - Desocupar antes do fim do contrato]
* **Cenario B (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [D & V(Prop) - Solicitação de desocupação]

---

### Diálogo: D & V(Prop) - Vistoria de saída (Vistoria_de_saida)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Vistoria de saída** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_PROP_VISTORIA_SAIDA"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Vistoria_de_sa_da_proprietario** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **vistoriaDeSaidaProprietario**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *vistoriaDeSaidaProprietario* é igual a *"Resultado"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Vistoria"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Resultado da vistoria"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Média"*
* **Cenario B:** Se a variável *vistoriaDeSaidaProprietario* é igual a *"Data da vistoria"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Data da vistoria"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Vistoria"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Média"*
* **Cenario C:** Se a variável *vistoriaDeSaidaProprietario* é igual a *"Data da vistoria"*
  * **Destino:** [D & V(Prop) - Saber a data da vistoria]
* **Cenario D:** Se a variável *vistoriaDeSaidaProprietario* é igual a *"Dúvida relatório"*
  * **Destino:** [D & V(Prop) - Dúvida sobre relatório de vistoria]
* **Cenario E:** Se a variável *vistoriaDeSaidaProprietario* é igual a *"Participar da vistoria"*
  * **Destino:** [D & V(Prop) - Quero participar da vistoria]
* **Cenario F:** Se a variável *vistoriaDeSaidaProprietario* é igual a *"Menu anterior"*
  * **Destino:** [Desocup. & Vist. (Prop)]
* **Cenario G (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: D & V(Prop) - Sem desocupação (Informacoes_sobre_a_desocupacao_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Sem desocupação** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_PROP_SEM_DESOCUP"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 📲 Compreendi! Não localizamos nenhuma desocupação para o seu imóvel. O que você gostaria de fazer agora?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **selectedDesocupacaoEVistoria**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Encerrar atendimento"*
  * *"Falar com atendente"*
  * *"Menu anterior"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Encerrar atendimento"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Falar com atendente"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Desocupação e Vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Desocupação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Informações de desocupação"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Alta"*
* **Cenario C:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Falar com atendente"*
  * **deveCriarCaso** = *"false"*
  * **Destino:** [Falar Com Atendente (Cria Caso)]
* **Cenario D:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Menu anterior"*
  * **Destino:** [Desocup. & Vist. (Prop)]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: D & V(Prop) - Solicitação de desocupação (D_V_Prop_Solicitacao_de_desocupacao)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Solicitação de desocupação** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> ✅ *Verifiquei seu contrato!* Podemos seguir com a *solicitação de desocupação*, mas antes precisamos alinhar alguns detalhes. Você deseja *continuar* e falar com o seu *gestor* sobre isso?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **solicitarDesocupacao**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Sim, continuar"*
  * *"Não, obrigado(a)"*
  * *"Menu anterior"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *solicitarDesocupacao* é igual a *"Sim, continuar"*
  * **falarComGestor_inputFlow** = *"true"*
* **Cenario B:** Se a variável *solicitarDesocupacao* é igual a *"Não, obrigado(a)"*
  * **Destino:** [Lógica de Resolução]
* **Cenario C:** Se a variável *solicitarDesocupacao* é igual a *"Menu anterior"*
  * **Destino:** [Desocup. & Vist. (Prop)]
* **Cenario D (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [D & V(Prop) - Falar com Gestor da Conta]

---

### Diálogo: D & V(Prop) - Falar com Gestor da Conta (D_V_Prop_Falar_com_Gestor_da_Conta)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Falar com Gestor da Conta** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Para ajudar você com essa questão, estou *te transferindo para o seu Gestor de Conta*. Aguarde um momento, ele vai te responder aqui mesmo. 💬

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Desocupação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Aviso de desocupação"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *gestorDeContaId*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alta"*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **deveCriarCaso** → *"false"*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Ação 4 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 5 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *recordId* ← variável de sessão *RoutableId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *enviarParaFila* é igual a *"true"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Central Aluguéis"*
  * **falarComGestor_inputFlow** = *"false"*
* **Cenario B:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Olá! Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**
* **Cenario C (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [End Chat]

---

### Diálogo: D & V(Prop) - Saber a data da vistoria (D_V_Prop_Saber_a_data_da_vistoria)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Saber a data da vistoria** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — Bot_Checa_se_existem_vistorias_no_contrato

O bot aciona a automação **Bot_Checa_se_existem_vistorias_no_contrato** para: **Executar a automação **Bot_Checa_se_existem_vistorias_no_contrato** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *contractId* ← variável de sessão *imovelContractId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *dataHoraVistoriaFormatada* ← parâmetro de retorno *dataHoraFormatada_output*
  * Variável de sessão *vistoriaAgendada* ← parâmetro de retorno *vistoriaAgendada*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Lógica de Resolução]

---

### Diálogo: D & V(Prop) - Dúvida sobre relatório de vistoria (Duvida_sobre_relatario_de_vistoria)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Dúvida sobre relatório de vistoria** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Certo! Após a *vistoria de saída*, podemos identificar itens de manutenção que são *responsabilidade do proprietário* e outros que são *responsabilidade do inquilino*. ✨ Esse processo garante que o imóvel permaneça *em ótimo estado*, valorizado e pronto

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 📲 Enquanto aguarda o atendimento, você pode me contar *quais são suas dúvidas*? Estou aqui para ajudar!

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **RespostaDigitada**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Desocupação e vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Vistoria"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvidas relatório de reparos"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Média"*

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **deveCriarCaso** → *"false"*
  * **motivoEscolhido** → copiado de *RespostaDigitada*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: D & V(Prop) - Desocupar antes do fim do contrato (D_V_Prop_Desocupar_antes_do_fim_do_contrato)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Desocupar antes do fim do contrato** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 🔎 Verifiquei seu contrato.

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Devido à data de término, ainda não é possível solicitar a desocupação diretamente por aqui. Você deseja falar com o seu *Gestor de Contas* sobre isso?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **selectedDesocupacaoEVistoria**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Sim, por favor"*
  * *"Não, obrigado(a)"*
  * *"Menu anterior"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Sim, por favor"*
  * **falarComGestor_inputFlow** = *"true"*
  * **Destino:** [D & V(Prop) - Falar com Gestor da Conta]
* **Cenario B:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Não, obrigado(a)"*
  * **Destino:** [Lógica de Resolução]
* **Cenario C:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Menu anterior"*
  * **Destino:** [Desocup. & Vist. (Prop)]

---

### Diálogo: D & V(Prop) - Quero participar da vistoria (D_V_Prop_Quero_participar_da_vistoria)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Quero participar da vistoria** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — Bot_Checa_se_existem_vistorias_no_contrato

O bot aciona a automação **Bot_Checa_se_existem_vistorias_no_contrato** para: **Executar a automação **Bot_Checa_se_existem_vistorias_no_contrato** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *contractId* ← variável de sessão *imovelContractId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *dataHoraVistoriaFormatada* ← parâmetro de retorno *dataHoraFormatada_output*
  * Variável de sessão *vistoriaAgendada* ← parâmetro de retorno *vistoriaAgendada*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Desocupação e Vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Vistoria"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Participar de vistoria"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixa"*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **deveCriarCaso** → *"false"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: D & V(Prop) - Cria caso (D_V_Prop_Cria_caso)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Cria caso** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — CA_BotCriaCaso

O bot aciona a automação **CA_BotCriaCaso** para: **Criar um novo caso no Salesforce com os metadados coletados durante o atendimento (tipo, motivo, prioridade, fila e imóvel)**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *IdRoteavel* ← variável de sessão *MessagingSession* (*ID da sessão de messaging no Salesforce*)
  * Parâmetro *motivoEscolhido* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *falarComGestor* ← variável de sessão *falarComGestor_inputFlow*
  * Parâmetro *naoDeveCriarCaso_inputDoBot* ← variável de sessão *deveCriarCaso*
* **Dados Retornados pela Automação:**
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *newCaseId*

---

### Diálogo: D & V(Prop) - Saber o resultado da vistoria (D_V_Prop_Saber_o_resultado_da_vistoria)

**Objetivo do Diálogo:** Gerenciar o fluxo de **D & V(Prop) - Saber o resultado da vistoria** dentro do contexto de processos de desocupação e vistoria do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Para ajudar você com essa questão, estou te transferindo para um atendente. Aguarde um momento, ele vai te responder aqui mesmo. 💬

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Desocupação e Vistoria"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Vistoria"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Resultado da vistoria"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Vistoria"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Média"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

## Início - Identifica o cliente

### Diálogo: Conta Nao Encontrada (Conta_Nao_Encontrada)

**Objetivo do Diálogo:** Ponto de entrada para sessões em que o sistema não reconhece automaticamente o cliente. Qualifica o visitante (cliente existente ou novo interessado) e direciona para o fluxo adequado: identificação manual via CPF/CNPJ ou fluxo de não-clientes.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Olá! Eu sou o *assistente virtual da Auxiliadora Predial.* Bem-vindo(a) ao nosso canal de *atendimento exclusivo para clientes de Aluguéis.* Para começarmos, me diga:

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Você já é nosso cliente?*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **InquilinoProprietario** (*Perfil declarado do usuário (Inquilino ou Proprietário)*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Sou cliente"*
  * *"Não sou cliente"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *InquilinoProprietario* (*Perfil declarado do usuário (Inquilino ou Proprietário)*) é igual a *"Não sou cliente"*
  * **Destino:** [Nao, ainda nao sou cliente]
* **Cenario B:** Se a variável *InquilinoProprietario* (*Perfil declarado do usuário (Inquilino ou Proprietário)*) é igual a *"Sou cliente"*
  * **Destino:** [SimSouCliente]

---

### Diálogo: Conta Encontrada (Conta_Encontrada)

**Objetivo do Diálogo:** Apresentar ao cliente reconhecido automaticamente pelo sistema uma saudação personalizada e confirmar sua identidade antes de prosseguir. Trata o cenário de falso positivo (cliente nega ser a pessoa identificada) redirecionando para reidentificação manual.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"CONTA_ENCONTRADA"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 😀 Olá, *{!NomeConta}!* Que bom ter você de volta ao *canal de atendimento da Auxiliadora Predial* — exclusivo para *clientes de Aluguéis.* Vamos começar?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **VamosComecar** (*Confirmação do cliente para iniciar o atendimento após identificação*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Sim, vamos lá."*
  * *"Não sou esta pessoa"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *VamosComecar* (*Confirmação do cliente para iniciar o atendimento após identificação*) é igual a *"Sim, vamos lá."*
  * **Destino:** [ComCadastro]
* **Cenario B:** Se a variável *VamosComecar* (*Confirmação do cliente para iniciar o atendimento após identificação*) é igual a *"Não sou esta pessoa"*
  * **Destino:** [Ops Não sou esta pessoa]
* **Cenario C (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Boas-vindas (Welcome)

**Objetivo do Diálogo:** Ponto de entrada do bot. Responsável por gerar o número de protocolo da sessão e realizar a identificação automática do cliente com base no contexto de sessão de messaging. Ramifica o fluxo conforme o resultado da busca: cliente reconhecido ou desconhecido.

#### Ação 1 : Consulta ao Salesforce — Bot_Get_Protocol_Number

O bot aciona a automação **Bot_Get_Protocol_Number** para: **Gerar um número de protocolo único para a sessão de atendimento**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *varProtocolId* (*Número de protocolo gerado para a sessão de atendimento*) ← parâmetro de retorno *varProtocoloId*

#### Ação 2 : Consulta ao Salesforce — Bot_Busca_Conta

O bot aciona a automação **Bot_Busca_Conta** para: **Identificar automaticamente a conta do cliente com base no contexto de sessão de messaging do Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *tipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *idRoteavel* ← variável de sessão *RoutableId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *Email* (*Endereço de e-mail do cliente recuperado do cadastro*) ← parâmetro de retorno *Email*
  * Variável de sessão *ContaEncontrada* (*Resultado da busca automática de conta (Sim/Não)*) ← parâmetro de retorno *ContaEncontrada*
  * Variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*) ← parâmetro de retorno *PerfilAlugueis*
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *CaseId*
  * Variável de sessão *MessagingSession* (*ID da sessão de messaging no Salesforce*) ← parâmetro de retorno *messagingSession*
  * Variável de sessão *AccountId* (*ID do registro de conta no Salesforce*) ← parâmetro de retorno *AccountId*
  * Variável de sessão *EmailMascarado* (*E-mail parcialmente ocultado para confirmação segura de identidade*) ← parâmetro de retorno *EmailMascarado*
  * Variável de sessão *CaseNumber* (*Número legível do caso, apresentado ao cliente*) ← parâmetro de retorno *CaseNumber*
  * Variável de sessão *NomeConta* (*Nome do cliente identificado, usado para personalização das mensagens*) ← parâmetro de retorno *NomeConta*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *ContaEncontrada* (*Resultado da busca automática de conta (Sim/Não)*) é igual a *"Sim"*
  * **Destino:** [Conta Encontrada]
* **Cenario B:** Se a variável *ContaEncontrada* (*Resultado da busca automática de conta (Sim/Não)*) é igual a *"Não"*
  * **Destino:** [Conta Nao Encontrada]
* **Cenario C (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Menu principal]

---

### Diálogo: Nao, ainda nao sou cliente (Nao_ainda_nao_sou_cliente)

**Objetivo do Diálogo:** Tratar visitantes que se identificam como não clientes da Auxiliadora Predial. Captura a intenção declarada (alugar, anunciar imóvel, falar com Condomínios ou Vendas) e encaminha para o destino correto, incluindo telefone de contato para áreas não atendidas pelo bot.

#### Ação 1 : Automação de Retaguarda — CA_BotNaoClienteApagaContaUsuario

O bot aciona a automação **CA_BotNaoClienteApagaContaUsuario** para: **Remover o vínculo de conta automaticamente identificado para a sessão, limpando o contexto antes de reiniciar a identificação manual**.

* **Dados Enviados para a Automação:**
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **CA_AindaNaosSouCliente** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **AindaNaoCliente** (*Intenção declarada pelo não-cliente (alugar, anunciar, falar com área específica)*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *AindaNaoCliente* (*Intenção declarada pelo não-cliente (alugar, anunciar, falar com área específica)*) é igual a *"Quero alugar"* **OU** a variável *AindaNaoCliente* (*Intenção declarada pelo não-cliente (alugar, anunciar, falar com área específica)*) é igual a *"Quero anunciar"*
  * **Destino:** [Quero Alugar ou Anunciar]
* **Cenario B:** Se a variável *AindaNaoCliente* (*Intenção declarada pelo não-cliente (alugar, anunciar, falar com área específica)*) é igual a *"Falar com Condomínios"*
  * Mensagem exibida: *"*Compreendi!* 😊 Para falar com *Condomínios*, o atendimento é feito por uma *equipe especializada*. Por favor, entre em contato pelo *4004-2814* para receber todas as informações. 📞"*
  * **Destino:** [Lógica de Resolução]
* **Cenario C:** Se a variável *AindaNaoCliente* (*Intenção declarada pelo não-cliente (alugar, anunciar, falar com área específica)*) é igual a *"Falar com Vendas"*
  * Mensagem exibida: *"*Compreendi!* 😊 Para falar com *Vendas*, o atendimento é feito por uma *equipe especializada*. Por favor, entre em contato pelo *4004-2814* para receber todas as informações. 📞"*
  * **Destino:** [Lógica de Resolução]

---

### Diálogo: Menu principal (Main_Menu)

**Objetivo do Diálogo:** Gateway central do fluxo. Revalida o estado da sessão antes de exibir opções: se a conta já foi identificada, reapresenta a tela de boas-vindas; caso contrário, retorna ao fluxo de identificação.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *ContaEncontrada* (*Resultado da busca automática de conta (Sim/Não)*) é igual a *"Sim"*
  * **Destino:** [Conta Encontrada]

---

### Diálogo: SimSouCliente (SimSouCliente)

**Objetivo do Diálogo:** Coletar o CPF ou CNPJ do cliente para realizar a identificação manual no Salesforce. Este diálogo é ativado tanto para clientes que ainda não passaram pela identificação automática quanto para usuários que negaram a identidade sugerida pelo sistema.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"SIM_SOU_CLIENTE"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Que bom ter você por aqui!* Para localizar seu cadastro e garantir a segurança das suas informações, por favor, *digite seu CPF ou CNPJ.*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **CPFCNPJ** (*CPF ou CNPJ digitado pelo cliente para autenticação manual*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

---

### Diálogo: ValidaCadastro (ValidaCadastro)

**Objetivo do Diálogo:** Executar a busca da conta do cliente no Salesforce com base no CPF/CNPJ coletado. Ramifica o fluxo conforme o resultado: cadastro localizado (prossegue para o menu de serviços) ou não localizado (reinicia a coleta com nova tentativa).

#### Ação 1 : Consulta ao Salesforce — CA_BotBuscaContaPeloCNPJ

O bot aciona a automação **CA_BotBuscaContaPeloCNPJ** para: **Buscar e autenticar a conta do cliente no Salesforce usando o CPF ou CNPJ informado, retornando dados cadastrais e de vinculação**.

* **Dados Enviados para a Automação:**
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *CPFCNPJ* ← variável de sessão *CPFCNPJ* (*CPF ou CNPJ digitado pelo cliente para autenticação manual*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *ContaExiste* (*Resultado da busca por CPF/CNPJ (Sim/Não)*) ← parâmetro de retorno *CadastroExiste*
  * Variável de sessão *NomeConta* (*Nome do cliente identificado, usado para personalização das mensagens*) ← parâmetro de retorno *NomeConta*
  * Variável de sessão *EmailMascarado* (*E-mail parcialmente ocultado para confirmação segura de identidade*) ← parâmetro de retorno *EmailMascarado*
  * Variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*) ← parâmetro de retorno *PerfilAlugueis*
  * Variável de sessão *CaseNumber* (*Número legível do caso, apresentado ao cliente*) ← parâmetro de retorno *CaseNumber*
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *CaseId*
  * Variável de sessão *AccountId* (*ID do registro de conta no Salesforce*) ← parâmetro de retorno *AccountId*
  * Variável de sessão *CaseProtocolNumber* ← parâmetro de retorno *ProtocolNumber*
  * Variável de sessão *Email* (*Endereço de e-mail do cliente recuperado do cadastro*) ← parâmetro de retorno *Email*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *ContaExiste* (*Resultado da busca por CPF/CNPJ (Sim/Não)*) é igual a *"Sim"*
  * **Destino:** [ComCadastro]
* **Cenario B:** Se a variável *ContaExiste* (*Resultado da busca por CPF/CNPJ (Sim/Não)*) é igual a *"Não"*
  * **Destino:** [SemCadastro]

---

### Diálogo: ComCadastro (ComCadastro)

**Objetivo do Diálogo:** Confirmar a autenticação do cliente e apresentar o número de protocolo da sessão. Após a apresentação do protocolo, inicia a busca por casos abertos para definir o próximo passo: atendimento a chamado existente ou abertura de novo.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"COM_CADASTRO"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Perfeito, {!NomeConta}!* Seu número de *protocolo* é: {!varProtocolId}. Por favor, *guarde este número* para consultas futuras.

---

### Diálogo: SemCadastro (SemCadastro)

**Objetivo do Diálogo:** Segunda tentativa de coleta de CPF/CNPJ após falha na validação anterior. Orienta o cliente sobre os critérios do canal exclusivo (clientes de aluguéis, documento do contrato) e reinicia o processo de validação.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Hmm... *Não conseguimos confirmar o seu cadastro* com o CPF/CNPJ informado. 😕 *Lembre-se:* este canal é exclusivo para clientes de aluguéis e o *documento deve ser o mesmo do contrato de locação.* Por favor, *digite novamente* o CPF ou CNPJ do titular.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **CPFCNPJ** (*CPF ou CNPJ digitado pelo cliente para autenticação manual*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

---

### Diálogo: Ops Não sou esta pessoa (Ops_Nao_sou_esta_pessoa)

**Objetivo do Diálogo:** Tratar usuários que negaram a identidade sugerida automaticamente pelo sistema (falso positivo na identificação de sessão). Requalifica o visitante (cliente existente ou novo interessado) e o encaminha para o fluxo correto de reidentificação.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Desculpe o inconveniente! Vamos continuar? Por favor, me diga: *você já é nosso cliente?*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **ClienteOuNao** (*Resultado da requalificação após falso positivo de identificação*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Sou cliente"*
  * *"Não sou cliente"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *ClienteOuNao* (*Resultado da requalificação após falso positivo de identificação*) é igual a *"Não sou cliente"*
  * **Destino:** [Nao, ainda nao sou cliente]
* **Cenario B:** Se a variável *ClienteOuNao* (*Resultado da requalificação após falso positivo de identificação*) é igual a *"Sou cliente"*
  * **Destino:** [SimSouCliente]

---

### Diálogo: RevalidaCadastro (RevalidaCadastro)

**Objetivo do Diálogo:** Segunda tentativa de validação de cadastro após falha inicial. Executa nova busca com base em CPF/CNPJ reinformado. Se confirmado, avança para o menu; caso contrário, encerra o atendimento e orienta o cliente a verificar os dados informados.

#### Ação 1 : Consulta ao Salesforce — CA_BotBuscaContaPeloCNPJ

O bot aciona a automação **CA_BotBuscaContaPeloCNPJ** para: **Buscar e autenticar a conta do cliente no Salesforce usando o CPF ou CNPJ informado, retornando dados cadastrais e de vinculação**.

* **Dados Enviados para a Automação:**
  * Parâmetro *CPFCNPJ* ← variável de sessão *CPFCNPJ* (*CPF ou CNPJ digitado pelo cliente para autenticação manual*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *AccountId* (*ID do registro de conta no Salesforce*) ← parâmetro de retorno *AccountId*
  * Variável de sessão *ContaExiste* (*Resultado da busca por CPF/CNPJ (Sim/Não)*) ← parâmetro de retorno *CadastroExiste*
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *CaseId*
  * Variável de sessão *CaseNumber* (*Número legível do caso, apresentado ao cliente*) ← parâmetro de retorno *CaseNumber*
  * Variável de sessão *NomeConta* (*Nome do cliente identificado, usado para personalização das mensagens*) ← parâmetro de retorno *NomeConta*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *ContaExiste* (*Resultado da busca por CPF/CNPJ (Sim/Não)*) é igual a *"Sim"*
  * **Destino:** [ComCadastro]
* **Cenario B:** Se a variável *ContaExiste* (*Resultado da busca por CPF/CNPJ (Sim/Não)*) é igual a *"Não"*
  * **Destino:** [Nao Identificado]

---

### Diálogo: Nao Identificado (Nao_Identificado)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Nao Identificado** dentro do contexto de identificação e autenticação do cliente. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Realmente não encontramos seu cadastro por aqui.* Não se preocupe! Você pode acessar todas as *informações da sua locação* pelo *Auxiliadora Digital.* Se preferir algo mais rápido, pode consultar a nossa *Central de Ajuda.* *Como você prefere seguir?*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **NaoIdentificado**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Auxiliadora Digital"*
  * *"Central de Ajuda"*
  * *"Falar com Atendente"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *NaoIdentificado* é igual a *"Auxiliadora Digital"*
  * Mensagem exibida: *"Acesse o portal pelo link https://portal.auxiliadorapredial.com.br/Login.aspx"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *NaoIdentificado* é igual a *"Central de Ajuda"*
  * Mensagem exibida: *"Acesse a central de ajuda pelo link https://auxiliadorapredial--homolog.sandbox.my.site.com/centraldeajuda/s/"*
  * **Destino:** [Lógica de Resolução]
* **Cenario C:** Se a variável *NaoIdentificado* é igual a *"Falar com Atendente"*
  * **Destino:** [Atualiza Caso Cliente Nao identificado]

---

### Diálogo: Quero Alugar ou Anunciar (Quero_Alugar_ou_Anunciar)

**Objetivo do Diálogo:** Tratar visitantes interessados em alugar ou anunciar imóveis. Apresenta informações e recursos de autoatendimento disponíveis para este perfil de interesse.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Compreendi!* Para ajudar você com essa questão, estou *te transferindo para um atendente.* Aguarde um momento, ele vai te responder aqui mesmo.

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Outros Assuntos"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"{!AindaNaoCliente}"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixo"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Central Aluguéis"*

#### Ação 3 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)
  * Parâmetro *recordId* ← variável de sessão *RoutableId*

#### Ação 4 : Automação de Retaguarda — CA_BotAtualizaCasoCriado

O bot aciona a automação **CA_BotAtualizaCasoCriado** para: **Atualizar o caso já criado no Salesforce com as informações complementares coletadas durante o atendimento**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *CaseSelected* ← variável de sessão *CaseSelected*
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *ImovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *Descricao* ← variável de sessão *Descricao* (*Descrição livre informada pelo cliente sobre sua demanda*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)

#### Ação 5 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 6 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**

---

### Diálogo: Atualiza Caso Cliente Nao identificado (Atualiza_Caso_Cliente_Nao_identificado)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Atualiza Caso Cliente Nao identificado** dentro do contexto de identificação e autenticação do cliente. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Outros Assuntos"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"{!NaoIdentificado}"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixo"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Central Aluguéis"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

## Lógica de Resolução

### Diálogo: Lógica de Resolução (Logica_de_Resolucao)

**Objetivo do Diálogo:** Diálogo de encerramento após resolução de demanda via autoatendimento. Verifica se o cliente necessita de alguma outra ajuda e, conforme a resposta, retoma o menu ou encerra o atendimento.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Consigo te ajudar com *algum outro assunto?*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **OutroAssunto**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Sim"*
  * *"Não"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *OutroAssunto* é igual a *"Sim"*
  * **Destino:** [Sim, ainda preciso de ajuda]
* **Cenario B:** Se a variável *OutroAssunto* é igual a *"Não"*
  * **Destino:** [Não, obrigado(a)]

---

### Diálogo: Sim, ainda preciso de ajuda (Sim_ainda_preciso_de_ajuda)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Sim, ainda preciso de ajuda** dentro do contexto de lógica de resolução e encerramento do atendimento. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Que ótimo!* Fico feliz em ajudar. Selecione a *opção que melhor corresponde ao que você precisa.*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **VoltarOuFalar**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Ver menu inicial"*
  * *"Falar com atendente"*

#### Ação 2 : Consulta ao Salesforce — CA_BotObterImoveisConta

O bot aciona a automação **CA_BotObterImoveisConta** para: **Recuperar a lista de imóveis ativos vinculados à conta do cliente, incluindo perfil do relacionamento (Inquilino ou Proprietário)**.

* **Dados Enviados para a Automação:**
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *relacionamentoNome* (*Tipo de relacionamento do cliente com o imóvel (Inquilino ou Proprietário)*) ← parâmetro de retorno *relacionamentoNome*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **CaseId** (*ID do caso (chamado) vinculado ao atendimento atual*) → limpo/redefinido
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → limpo/redefinido
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → limpo/redefinido
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → limpo/redefinido

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → limpo/redefinido
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → limpo/redefinido

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *VoltarOuFalar* é igual a *"Ver menu inicial"* **E** a variável *TipoRelacionamento* é igual a *"Inquilino"*
  * **Destino:** [Menu Inquilino]
* **Cenario B:** Se a variável *VoltarOuFalar* é igual a *"Ver menu inicial"* **E** a variável *TipoRelacionamento* é igual a *"Proprietário"*
  * **Destino:** [Menu Proprietario]
* **Cenario C:** Se a variável *VoltarOuFalar* é igual a *"Falar com atendente"*
  * **Destino:** [Atualiza Caso Voltar ou Falar]

---

### Diálogo: Não, obrigado(a) (Nao_obrigado_a)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Não, obrigado(a)** dentro do contexto de lógica de resolução e encerramento do atendimento. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Certo! A *Auxiliadora Predial agradece o seu contato.*

---

## Manutenção e Reparos Proprietario

### Diálogo: Atualiza Caso Status de Manutenção (Atualiza_Caso_Manutencao_Reparos_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Atualiza Caso Status de Manutenção** dentro do contexto de solicitações de manutenção e reparos do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Consultas sobre Manutenção"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Status do Caso"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Manutenção"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Médio"*

---

### Diálogo: Atualiza Caso Duvida Respons. Proprietario (Atualiza_Caso_Duvida_Respons_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Atualiza Caso Duvida Respons. Proprietario** dentro do contexto de solicitações de manutenção e reparos do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Entendido. Para que eu possa te ajudar, me conte um pouco mais sobre qual manutenção você tem dúvida se a responsabilidade é sua ou do inquilino. Por exemplo: 'Troca de chuveiro queimado'.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **DuvidaResponsProprietario**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Consultas sobre Manutenção"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvida sobre responsabilidade"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Médio"*
  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *DuvidaResponsProprietario*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Assistente de Conta"*
  * **Titulo** → copiado de *DuvidaResponsProprietario*

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Acesse nossa central de ajuda pelo link: https://auxiliadorapredial--homolog.sandbox.my.site.com/centraldeajuda/s/?varTitulo={!Titulo}

#### Ação 5 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)

#### Ação 6 : Automação de Retaguarda — CA_BotAtualizaCasoCriado

O bot aciona a automação **CA_BotAtualizaCasoCriado** para: **Atualizar o caso já criado no Salesforce com as informações complementares coletadas durante o atendimento**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *ImovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *Descricao* ← variável de sessão *Descricao* (*Descrição livre informada pelo cliente sobre sua demanda*)
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *CaseSelected* ← variável de sessão *CaseSelected*
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)

#### Ação 7 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 8 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Olá! Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**

---

### Diálogo: Atualiza Caso Informar necessidade de manutenção Proprietario (Atualiza_Caso_Informar_necessidade_de_manuten_o_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Atualiza Caso Informar necessidade de manutenção Proprietario** dentro do contexto de solicitações de manutenção e reparos do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Compreendi. Por favor, descreva em detalhes a necessidade de manutenção do imóvel para que eu possa registrar e encaminhar para um atendente.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **DuvidaResponsProprietario**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 2 : Consulta ao Salesforce — Bot_Obter_Assistente_de_Conta

O bot aciona a automação **Bot_Obter_Assistente_de_Conta** para: **Executar a automação **Bot_Obter_Assistente_de_Conta** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *assistenteContaId* ← parâmetro de retorno *assistenteDeContaId*
  * Variável de sessão *enviarParaFila* ← parâmetro de retorno *enviarParaFila*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Manutenção e Reparos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Solicitações de Manutenção"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Solicitação de manutenção"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alto"*

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *DuvidaResponsProprietario*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*

---

### Diálogo: ManRepProp - Status Manutenção (Status_Manutencao)

**Objetivo do Diálogo:** Gerenciar o fluxo de **ManRepProp - Status Manutenção** dentro do contexto de solicitações de manutenção e reparos do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Consultas sobre Manutenção"*
  * **CaseStatus** → *"Status Caso"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Assistente de Conta"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Média"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Consultas sobre Manutenção"*
  * **CaseStatus** → *"Status Caso"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Manutenção"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Média"*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Status Caso"*

---

### Diálogo: ManRepProp - Dúvida de responsabilidade (Duvida_Sobre_Responsabilidade)

**Objetivo do Diálogo:** Gerenciar o fluxo de **ManRepProp - Dúvida de responsabilidade** dentro do contexto de solicitações de manutenção e reparos do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MAN_REP_PROP_DUVIDA_RESPONSA"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Entendido. Para que eu possa te ajudar, me conte um pouco mais sobre qual manutenção você tem dúvida se a responsabilidade é sua ou do inquilino. Por exemplo: 'Troca de chuveiro queimado'.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Busca_Sobre_Responsabilidade**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Consultas sobre Manutenção"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvida Sobre Responsabilidade"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Manutenção"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Média"*

#### Ação 4 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Encontrei os seguintes artigos. Digite o número da opção desejada:

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **KnowledgeSelecionado**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
  * **Coleta Opcional:** Este passo não bloqueia o fluxo caso o cliente não responda diretamente.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Caso nenhum artigo se encaixe no que você precisa, digite "Falar com atendente""* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Ação 5 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> {!KnowledgeSelecionado.Summary} Segue link para acessar o artigo completo: https://auxiliadorapredial.my.site.com/centraldeajuda/s/article/{!KnowledgeSelecionado.UrlName}

#### Ação 6 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Estou te transferindo para um de nossos atendentes. Por favor, aguarde um momento, que ele já irá te responder aqui mesmo.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Knowledge* é igual a *"0"*
  * **Destino:** [Knowledge Não Encontrado]
* **Cenario B:** Se a variável *KnowledgeSelecionado* não está preenchido
  * **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: ManRepProp - Solicitar manutenção (Informar_Necessidade_de_Manutencao)

**Objetivo do Diálogo:** Gerenciar o fluxo de **ManRepProp - Solicitar manutenção** dentro do contexto de solicitações de manutenção e reparos do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MAN_REP_PROP_SOLICITA_MANU"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Compreendi. Por favor, descreva em detalhes a necessidade de manutenção do imóvel para que eu possa registrar e encaminhar para um atendente.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **motivoSolicitacaoManutencao**.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Manutenção e Reparos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Solicitações de Manutenção"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Solicitação de Manutenção"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alta"*

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*
  * **motivoEscolhido** → copiado de *motivoSolicitacaoManutencao*

---

### Diálogo: Voltar ao Menu Anterior (Voltar_ao_Menu_Anterior)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Voltar ao Menu Anterior** dentro do contexto de solicitações de manutenção e reparos do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedManutencaoEReparos* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Menu Proprietario]

---

## Manutenção e Reparos (Inquilino)

### Diálogo: ManRepInq - Afeta outros também (Afeta_outros_tambem)

**Objetivo do Diálogo:** Coletar a descrição detalhada do problema de manutenção reportado pelo inquilino e criar/atualizar o chamado com prioridade Alta. Após a criação do caso, verifica o horário comercial e transfere para atendimento humano ou encerra com mensagem de retorno.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Entendido. Por favor, nos conte um pouco mais sobre o que está acontecendo.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **AfetaOutrosTambem** (*Descrição do problema de manutenção informada pelo cliente*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Manutenção e Reparos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Solicitações de Manutenção"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Solicitação de Manutenção"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alto"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Assistente de Conta"*

#### Ação 3 : Automação de Retaguarda — CA_BotAtualizaCasoCriado

O bot aciona a automação **CA_BotAtualizaCasoCriado** para: **Atualizar o caso já criado no Salesforce com as informações complementares coletadas durante o atendimento**.

* **Dados Enviados para a Automação:**
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *ImovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
  * Parâmetro *CaseSelected* ← variável de sessão *CaseSelected*
  * Parâmetro *Descricao* ← variável de sessão *Descricao* (*Descrição livre informada pelo cliente sobre sua demanda*)
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)

#### Ação 4 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 5 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)
  * Parâmetro *Extrato* ← variável de sessão *Extrato* (*Dados de extrato financeiro do imóvel*)
  * Parâmetro *recordId* ← variável de sessão *RoutableId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**
* **Cenario B (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: ManRepInq - Solicitar manutenção (Preciso_de_um_reparo_no_imovel)

**Objetivo do Diálogo:** Gerenciar o fluxo de **ManRepInq - Solicitar manutenção** dentro do contexto de este fluxo de atendimento. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MAN_REP_INQ_SOLICITA_MANU"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Menu_solicitar_manuten_o_inquilino** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Preciso_de_um_reparo_no_imovel_inquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Preciso_de_um_reparo_no_imovel_inquilino* é igual a *"Afeta só meu imóvel"*
  * Mensagem exibida: *"A solicitação de manutenção é feita 100% online, no site da nossa parceira, a Refera. Para abrir o seu chamado, basta clicar no link abaixo. https://admin.refera.com.br/solicitar-servico/auxiliadora-predial"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *Preciso_de_um_reparo_no_imovel_inquilino* é igual a *"Afeta outros também"*
  * **Destino:** [ManRepInq - Afeta outros também]
* **Cenario C:** Se a variável *Preciso_de_um_reparo_no_imovel_inquilino* é igual a *"Menu anterior"*
  * **Destino:** [Manutenção e Reparos Inquilino]

---

### Diálogo: ManRepInq - Preciso de um reparo no imóvel1 (Preciso_de_um_reparo_no_im_vel1)

**Objetivo do Diálogo:** Gerenciar o fluxo de **ManRepInq - Preciso de um reparo no imóvel1** dentro do contexto de este fluxo de atendimento. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Esse problema afeta apenas o seu imóvel ou também as áreas comuns ou outros apartamentos do condomínio?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Preciso_de_um_reparo_no_imovel_inquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Afeta só meu imóvel"*
  * *"Afeta outros também"*
  * *"Voltar ao menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Preciso_de_um_reparo_no_imovel_inquilino* é igual a *"Afeta só meu imóvel"*
  * Mensagem exibida: *"A solicitação de manutenção é feita 100% online, no site da nossa parceira, a Refera. Para abrir o seu chamado, basta clicar no link abaixo. https://admin.refera.com.br/solicitar-servico/auxiliadora-predial"*
  * Ação do sistema: **EndChat**
* **Cenario B:** Se a variável *Preciso_de_um_reparo_no_imovel_inquilino* é igual a *"Afeta outros também"*
  * **Destino:** [ManRepInq - Afeta outros também]
* **Cenario C:** Se a variável *Preciso_de_um_reparo_no_imovel_inquilino* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Manutenção e Reparos Proprietario]

---

### Diálogo: ManRepInq - Solicitação de Reembolso (Solicita_o_de_Reembolso)

**Objetivo do Diálogo:** Gerenciar o fluxo de **ManRepInq - Solicitação de Reembolso** dentro do contexto de este fluxo de atendimento. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Para que nossa equipe possa analisar sua solicitação de reembolso, precisamos de algumas informações adicionais. Para agilizar o processo, pedimos que nos envie:

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> - Número do chamado anterior; - Fotos ou vídeos que mostrem o problema antes e depois do reparo (se possível); - Nota fiscal ou recibo do serviço emitido em nome do titular do contrato; - Comprovante de pagamento do serviço.

#### Ação 3 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Você pode relatar o ocorrido e anexar os arquivos diretamente aqui. Com todas essas informações, conseguiremos avaliar sua solicitação e informar se o reembolso será aprovado.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **InformacoesReembolsoManutencao**.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Manutencao_e_Reparos_Inquilino** → *"Manutenção e Reparo"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Solicitações de Manutenção"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Reembolso"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Gestor de Conta"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alta"*

#### Ação 5 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Manutenção e Reparos"*
  * **motivoEscolhido** → copiado de *InformacoesReembolsoManutencao*

---

### Diálogo: ManRepInq - Status de uma manutenção (Status_Manuten_o_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **ManRepInq - Status de uma manutenção** dentro do contexto de este fluxo de atendimento. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 Para ajudar você com essa questão, estou te transferindo para um de nossos atendentes. Por favor, aguarde um momento, que ele já irá te responder aqui mesmo..

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Consultas sobre Manutenção"*
  * **CaseStatus** → *"Status Caso"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Manutenção"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixa"*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Status Caso"*

---

### Diálogo: ManRepInq - Informar Necessidade de Manutenção (Informar_Necessidade_de_Manuten_o_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **ManRepInq - Informar Necessidade de Manutenção** dentro do contexto de este fluxo de atendimento. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Compreendi. Por favor, descreva em detalhes a necessidade de manutenção do imóvel para que eu possa registrar e encaminhar para um atendente.

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Estou te transferindo para um de nossos atendentes. Por favor, aguarde um momento, que ele já irá te responder aqui mesmo.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Manutenção e Reparos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Solicitações de Manutenção"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Solicitação de Manutenção"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Premium"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alta"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: Voltar ao Menu Anterior Inquilino (Voltar_ao_Menu_Anterior_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Voltar ao Menu Anterior Inquilino** dentro do contexto de este fluxo de atendimento. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Manutencao_e_Reparos_Inquilino* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Menu Inquilino]

---

## Menu Inquilino

### Diálogo: Menu Inquilino (Menu_Inquilino)

**Objetivo do Diálogo:** Menu principal de serviços disponíveis para o perfil Inquilino. Apresenta as categorias de atendimento (Pagamentos e Financeiro, Manutenção e Reparos, Desocupação e Vistoria, Meu Contrato) e direciona para o sub-fluxo correspondente.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MENU_INQ"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **CA_MenuIncialInquilino** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MenuInquilino** (*Opção de serviço selecionada pelo Inquilino no menu principal*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
  * **Coleta Opcional:** Este passo não bloqueia o fluxo caso o cliente não responda diretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MenuInquilino* (*Opção de serviço selecionada pelo Inquilino no menu principal*) é igual a *"Pagamentos e Financeiro"*
  * **Destino:** [Pagamentos e Financeiro Inquilino]
* **Cenario B:** Se a variável *MenuInquilino* (*Opção de serviço selecionada pelo Inquilino no menu principal*) é igual a *"Manutenção e Reparos"*
  * **Destino:** [Manutenção e Reparos Inquilino]
* **Cenario C:** Se a variável *MenuInquilino* (*Opção de serviço selecionada pelo Inquilino no menu principal*) é igual a *"Desocupação e Vistoria"*
  * **Destino:** [Desocup. & Vist. (Inquilino)]
* **Cenario D:** Se a variável *MenuInquilino* (*Opção de serviço selecionada pelo Inquilino no menu principal*) é igual a *"Meu Contrato"*
  * **Destino:** [Meu Contrato Inquilino]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Pagamentos e Financeiro Inquilino (Pagamentos_e_Financeiro_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Pagamentos e Financeiro Inquilino** dentro do contexto de serviços para o perfil Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"PAG_FINAN_INQ"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **CA_InquilinoPagamentosEFinaceiro** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Pagamentos_e_Financeiro_Inquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Consultas Financeiras Gerais"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Assistente de Conta"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Pagamentos_e_Financeiro_Inquilino* é igual a *"2ª via do Boleto"*
  * **Destino:** [2 via do Boleto]
* **Cenario B:** Se a variável *Pagamentos_e_Financeiro_Inquilino* é igual a *"Dúvida de Boleto"*
  * **Destino:** [Dúvidas Boletos Inquilino]
* **Cenario C:** Se a variável *Pagamentos_e_Financeiro_Inquilino* é igual a *"Comprovantes"*
  * **Destino:** [Comprovantes de Pagamento Inquilino]
* **Cenario D:** Se a variável *Pagamentos_e_Financeiro_Inquilino* é igual a *"Débito em Conta"*
  * **Destino:** [Débito em Conta Inquilino]
* **Cenario E:** Se a variável *Pagamentos_e_Financeiro_Inquilino* é igual a *"Negociação"*
  * **Destino:** [Negociação Inquilino]
* **Cenario F:** Se a variável *Pagamentos_e_Financeiro_Inquilino* é igual a *"IPTU"*
  * **Destino:** [IPTU inquilino]
* **Cenario G:** Se a variável *Pagamentos_e_Financeiro_Inquilino* é igual a *"Menu anterior"*
  * **Destino:** [Menu Inquilino]
* **Cenario H (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Busca Knowledge - Resposta digitada]

---

### Diálogo: Manutenção e Reparos Inquilino (Manuten_o_e_Reparos_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Manutenção e Reparos Inquilino** dentro do contexto de serviços para o perfil Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MAN_REP_INQ"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Menu_manuten_o_e_reparo_inquilino** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Manutencao_e_Reparos_Inquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Manutencao_e_Reparos_Inquilino* é igual a *"Solicitar manutenção"*
  * **Destino:** [ManRepInq - Solicitar manutenção]
* **Cenario B:** Se a variável *Manutencao_e_Reparos_Inquilino* é igual a *"Status de uma manutenção"*
  * **Destino:** [ManRepInq - Status de uma manutenção]
* **Cenario C:** Se a variável *Manutencao_e_Reparos_Inquilino* é igual a *"Solicitação de reembolso"*
  * **Destino:** [ManRepInq - Solicitação de Reembolso]
* **Cenario D:** Se a variável *Manutencao_e_Reparos_Inquilino* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Menu Inquilino]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Meu Contrato Inquilino (Meu_Contrato_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Meu Contrato Inquilino** dentro do contexto de serviços para o perfil Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CONT_INQ"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Menu_meu_contrato_inquilino** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MeuContratoInquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MeuContratoInquilino* é igual a *"Troca de titularidade"*
  * **Destino:** [MeuCtrt - Troca de titularidade]
* **Cenario B:** Se a variável *MeuContratoInquilino* é igual a *"Troca de garantia"*
  * **Destino:** [MeuCtrt - Troca de garantia]
* **Cenario C:** Se a variável *MeuContratoInquilino* é igual a *"2° via contrato"*
  * **Destino:** [MeuCtrt - 2° via contrato]
* **Cenario D:** Se a variável *MeuContratoInquilino* é igual a *"Atualização de cadastro"*
  * **Destino:** [MeuCtrt - Atualização de dados cadastrais]
* **Cenario E:** Se a variável *MeuContratoInquilino* é igual a *"Menu Anterior"*
  * **Destino:** [Menu Inquilino]
* **Cenario F (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Desocup. & Vist. (Inquilino) (Desocup_Vist_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Desocup. & Vist. (Inquilino)** dentro do contexto de serviços para o perfil Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_INQ"*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Menu_Desocupacao_e_Vistoria_Inquilino** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **selectedDesocupacaoEVistoria**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Mais informações"*
  * **Destino:** [D & V (Inqui) - Informações sobre a desocupação]
* **Cenario B:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Aviso de desocupação"*
  * **Destino:** [D & V (Inqui) - Aviso de desocupação]
* **Cenario C:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Devoluções de chaves"*
  * **Destino:** [D & V (Inqui) - Devoluções de chaves]
* **Cenario D:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Vistoria"*
  * **Destino:** [D & V (Inqui) - Vistoria]
* **Cenario E:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Negociar desocupação"*
  * **Destino:** [D & V (Inqui) - Negociar desocupação]
* **Cenario F:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Menu Inquilino]
* **Cenario G (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

## Menu Proprietario

### Diálogo: Menu Proprietario (Menu_Proprietario)

**Objetivo do Diálogo:** Menu principal de serviços disponíveis para o perfil Proprietário. Apresenta as categorias de atendimento (Pagamentos e Financeiro, Manutenção e Reparos, Desocupação e Vistoria, Meu Contrato) e direciona para o sub-fluxo correspondente.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MENU_PROP"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **MenuProprietario** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MenuProprietario** (*Opção de serviço selecionada pelo Proprietário no menu principal*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MenuProprietario* (*Opção de serviço selecionada pelo Proprietário no menu principal*) é igual a *"Pagamentos e Financeiro"*
  * **Destino:** [Pagamentos e Financeiro Proprietario]
* **Cenario B:** Se a variável *MenuProprietario* (*Opção de serviço selecionada pelo Proprietário no menu principal*) é igual a *"Manutenção e Reparos"*
  * **Destino:** [Manutenção e Reparos Proprietario]
* **Cenario C:** Se a variável *MenuProprietario* (*Opção de serviço selecionada pelo Proprietário no menu principal*) é igual a *"Desocupação e Vistoria"*
  * **Destino:** [Desocup. & Vist. (Prop)]
* **Cenario D:** Se a variável *MenuProprietario* (*Opção de serviço selecionada pelo Proprietário no menu principal*) é igual a *"Meu Contrato"*
  * **Destino:** [Meu Contrato Proprietario]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Pagamentos e Financeiro Proprietario (Pagamentos_e_Financeiro_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Pagamentos e Financeiro Proprietario** dentro do contexto de serviços para o perfil Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"PAG_FINAN_PROP"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Menu_pagamentos_e_financeiro_proprietario** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **PagamentosFinanceiroProprietario**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *PagamentosFinanceiroProprietario* é igual a *"Extrato"*
  * **Destino:** [Extrato]
* **Cenario B:** Se a variável *PagamentosFinanceiroProprietario* é igual a *"Dados bancários"*
  * **Destino:** [Alteração de dados bancários]
* **Cenario C:** Se a variável *PagamentosFinanceiroProprietario* é igual a *"IR/DIMOB"*
  * **Destino:** [Informe de Rendimentos/DIMOB]
* **Cenario D:** Se a variável *PagamentosFinanceiroProprietario* é igual a *"Não recebi meu aluguel"*
  * **Destino:** [Não Recebi Meu Aluguel - Cria Caso]
* **Cenario E:** Se a variável *PagamentosFinanceiroProprietario* é igual a *"IPTU"*
  * **Destino:** [IPTU Proprietario]
* **Cenario F:** Se a variável *PagamentosFinanceiroProprietario* é igual a *"Notas fiscais"*
  * **Destino:** [NF Proprietario]
* **Cenario G:** Se a variável *PagamentosFinanceiroProprietario* é igual a *"Menu anterior"*
  * **Destino:** [Menu Proprietario]
* **Cenario H (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Busca Knowledge - Resposta digitada]

---

### Diálogo: Desocup. & Vist. (Prop) (D_V_Prop)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Desocup. & Vist. (Prop)** dentro do contexto de serviços para o perfil Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DESOC_VIS_PROP"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Desocupacao_e_Vistoria_Proprietario** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **selectedDesocupacaoEVistoria**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Mais Informações"*
  * **Destino:** [D & V(Prop) -  Informações sobre desocupação]
* **Cenario B:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Solicitar a desocupação"*
  * **Destino:** [D & V(Prop) - Solicitar a desocupação]
* **Cenario C:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Vistoria de saída"*
  * **Destino:** [D & V(Prop) - Vistoria de saída]
* **Cenario D:** Se a variável *selectedDesocupacaoEVistoria* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Menu Proprietario]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Meu Contrato Proprietario (Meu_Contrato_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Meu Contrato Proprietario** dentro do contexto de serviços para o perfil Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CONT_PROP"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Menu_meu_contrato_proprietario** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MeuContratoProprietario**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MeuContratoProprietario* é igual a *"Alterar proprietário"*
  * **Destino:** [MeuCtrt - Alterar proprietário]
* **Cenario B:** Se a variável *MeuContratoProprietario* é igual a *"Informações gerais"*
  * **Destino:** [MeuCtrt - Informações sobre contrato]
* **Cenario C:** Se a variável *MeuContratoProprietario* é igual a *"Quero vender meu imóvel"*
  * **Destino:** [MeuCtrt - Quero vender meu imóvel]
* **Cenario D:** Se a variável *MeuContratoProprietario* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Menu Proprietario]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Manutenção e Reparos Proprietario (Manuten_o_e_Reparos_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Manutenção e Reparos Proprietario** dentro do contexto de serviços para o perfil Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MAN_REP_PROP"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Menu_manutencao_e_reparo_proprietario** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Manutencao_e_Reparos_Proprietario**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Manutencao_e_Reparos_Proprietario* é igual a *"Status de manutenção"*
  * **Destino:** [ManRepProp - Status Manutenção]
* **Cenario B:** Se a variável *Manutencao_e_Reparos_Proprietario* é igual a *"Responsabilidade"*
  * **Destino:** [ManRepProp - Dúvida de responsabilidade]
* **Cenario C:** Se a variável *Manutencao_e_Reparos_Proprietario* é igual a *"Solicitar manutenção"*
  * **Destino:** [ManRepProp - Solicitar manutenção]
* **Cenario D:** Se a variável *Manutencao_e_Reparos_Proprietario* é igual a *"Menu anterior"*
  * **Destino:** [Menu Proprietario]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

## Meu Contrato (Inquilino)

### Diálogo: MeuCtrt - Troca de titularidade (Troca_de_titularidade)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - Troca de titularidade** dentro do contexto de informações sobre o contrato do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CONT_INQ_TROCA_TITULAR"*

#### Ação 2 : Consulta ao Salesforce — Bot_Obter_Gestor_de_Conta

O bot aciona a automação **Bot_Obter_Gestor_de_Conta** para: **Executar a automação **Bot_Obter_Gestor_de_Conta** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *imovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *falarComGestor_inputFlow* ← parâmetro de retorno *falarComGestor*
  * Variável de sessão *gestorDeContaId* ← parâmetro de retorno *gestorDeContaId*
  * Variável de sessão *enviarParaFila* ← parâmetro de retorno *enviaParaFila*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *gestorDeContaId*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Gestão do Contrato"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Alteração cadastral e contratual"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Troca titularidade"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Média"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: MeuCtrt - Troca de garantia (Troca_de_garantia)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - Troca de garantia** dentro do contexto de informações sobre o contrato do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CONT_INQ_TROCA_GARANTIA"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 Para ajudar você com essa questão, estou te transferindo para um de nossos atendentes. Por favor, aguarde um momento, que ele já irá te responder aqui mesmo.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *gestorDeContaId*

#### Ação 4 : Consulta ao Salesforce — CA_BotCriaCaso

O bot aciona a automação **CA_BotCriaCaso** para: **Criar um novo caso no Salesforce com os metadados coletados durante o atendimento (tipo, motivo, prioridade, fila e imóvel)**.

* **Dados Enviados para a Automação:**
  * Parâmetro *TipoRegistro* ← variável de sessão **
  * Parâmetro *falarComGestor* ← variável de sessão *falarComGestor*
  * Parâmetro *motivoEscolhido* ← variável de sessão *motivoEscolhido*
  * Parâmetro *naoDeveCriarCaso_inputDoBot* ← variável de sessão *deveCriarCaso*
  * Parâmetro *MotivoCaso* ← variável de sessão **
  * Parâmetro *Prioridade* ← variável de sessão **
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *TipoCaso* ← variável de sessão **
  * Parâmetro *Fila* ← variável de sessão *gestorDeContaId*
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *newCaseId*

#### Ação 5 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*
  * Variável de sessão *estaSendoTestado* ← parâmetro de retorno *isTest*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"* **E** a variável *estaSendoTestado* é igual a *"false"*
  * Mensagem exibida: *"Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**
* **Cenario B (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Atualiza Sessão de Mensagem (Transfere a sessão)]

---

### Diálogo: MeuCtrt - 2° via contrato (MeuCtt_2_via_contrato)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - 2° via contrato** dentro do contexto de informações sobre o contrato do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 📲 *Entendido!* Você pode acessar seus documentos e informações de forma rápida e segura diretamente na *Auxiliadora Digital*, utilizando seu CPF e senha.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MeuCtrt_2a_via_contrato**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Auxiliadora Digital"*
  * *"Falar com atendente"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MeuCtrt_2a_via_contrato* é igual a *"Auxiliadora Digital"*
  * Mensagem exibida: *"Clique no Link para acessar: https://portal.auxiliadorapredial.com.br/Login.aspx"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *MeuCtrt_2a_via_contrato* é igual a *"Falar com atendente"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Gestão Contrato"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Informações do contrato"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"2° via contrato"*
  * **Destino:** [MeuCtrt - Falar com atendente - Assistente de conta]
* **Cenario C:** Se a variável *MeuCtrt_2a_via_contrato* é igual a *"Menu anterior"*
  * **Destino:** [MeuCtrt - Informações sobre contrato]

---

### Diálogo: MeuCtrt - Atualização de dados cadastrais (Atualizacao_de_dados_cadastrais)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - Atualização de dados cadastrais** dentro do contexto de informações sobre o contrato do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CONT_INQ_ATUALIZA_DADOS"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 📲 Qual dado cadastral você gostaria de atualizar?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MeuCtrt_Atualizacao_de_dados_cadastrais**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Telefone, E-mail ou Dados Bancários"*
  * *"Outros dados"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MeuCtrt_Atualizacao_de_dados_cadastrais* é igual a *"Telefone, E-mail ou Dados Bancários"*
  * **Destino:** [MeuCtrt - Acessar Auxiliadora Digital]
* **Cenario B:** Se a variável *MeuCtrt_Atualizacao_de_dados_cadastrais* é igual a *"Outros dados"*
  * **Destino:** [MeuCtrt - Outros dados]
* **Cenario C:** Se a variável *MeuCtrt_Atualizacao_de_dados_cadastrais* é igual a *"Menu anterior"*
  * **Destino:** [Meu Contrato Inquilino]

---

### Diálogo: MeuCtrt - Falar com atendente - Assistente de conta (MeuCtrt_Falar_com_atendente)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - Falar com atendente - Assistente de conta** dentro do contexto de informações sobre o contrato do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*
  * Variável de sessão *estaSendoTestado* ← parâmetro de retorno *isTest*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 Para ajudar você com essa questão, estou te transferindo para um de nossos atendentes.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Por favor, aguarde um momento, que ele já irá te responder aqui mesmo.

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Atualizar dados cadastrais"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Gestão Contrato"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Alteração cadastral e contratual"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixa"*

#### Ação 5 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *Extrato* ← variável de sessão *Extrato* (*Dados de extrato financeiro do imóvel*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)
  * Parâmetro *recordId* ← variável de sessão *RoutableId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**
* **Cenario B:** Se a variável *Fila* (*Fila de atendimento humano para onde a sessão será roteada*) não está preenchido
* **Cenario C (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [End Chat]

---

### Diálogo: MeuCtrt - Acessar Auxiliadora Digital (Acessar_Auxiliadora_Digital)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - Acessar Auxiliadora Digital** dentro do contexto de informações sobre o contrato do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CONT_INQ_ACESSA_AUXI"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 📲 Entendido. Sem problemas. Para sua segurança você deve atualizar os seus dados diretamente na *Auxiliadora Digital*, utilizando seu CPF e senha.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MeuCtrt_Acessar_Auxiliadora_Digital**.
* **Opções Disponibilizadas (Intenções):**
  * *"Auxiliadora Digital"*
  * *"Falar com atendente"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MeuCtrt_Acessar_Auxiliadora_Digital* é igual a *"Auxiliadora Digital"*
  * Mensagem exibida: *"Clique no Link para acessar: https://portal.auxiliadorapredial.com.br/Login.aspx"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *MeuCtrt_Acessar_Auxiliadora_Digital* é igual a *"Falar com atendente"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Gestão Contrato"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Alteração cadastral e contratual"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Atualizar dados cadastrais"*
  * **Destino:** [MeuCtrt - Falar com atendente - Assistente de conta]
* **Cenario C:** Se a variável *MeuCtrt_Acessar_Auxiliadora_Digital* é igual a *"Menu anterior"*
  * **Destino:** [MeuCtrt - Atualização de dados cadastrais]
* **Cenario D (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: MeuCtrt - Outros dados (Outros_dados)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - Outros dados** dentro do contexto de informações sobre o contrato do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Gestão Contrato"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Alteração cadastral e contratual"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Atualizar dados cadastrais"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [MeuCtrt - Falar com atendente - Assistente de conta]

---

## Meu Contrato (Proprietário)

### Diálogo: MeuCtrt - Alterar proprietário (Alterar_proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - Alterar proprietário** dentro do contexto de informações sobre o contrato do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CONT_PROP_ALTERAR_PROP"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 Para alterar ou adicionar um proprietário ao contrato, o primeiro passo é o preenchimento do nosso formulário com os documentos do novo titular.

#### Ação 3 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Após o envio do formulário, nossa equipe analisará as informações. Se tudo estiver correto, prepararemos o aditivo ao contrato de administração para a assinatura de todos. Você será comunicado sobre cada etapa do processo.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MeuCtrt_AlterarProprietario**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Formulário"*
  * *"Falar com atendente"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MeuCtrt_AlterarProprietario* é igual a *"Formulário"*
  * Mensagem exibida: *"Link do formulário: https://portal.auxiliadorapredial.com.br/documentos//FICHA%20DE%20PROPRIET%C3%81RIO.pdf"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *MeuCtrt_AlterarProprietario* é igual a *"Falar com Atendente"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Gestão do contrato"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Alteração cadastral e contratual"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Troca de titularidade"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Gestor de conta"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Média"*
* **Cenario C:** Se a variável *MeuCtrt_AlterarProprietario* é igual a *"Falar com Atendente"*
  * **Destino:** [Obter gestor da conta]
* **Cenario D:** Se a variável *MeuCtrt_AlterarProprietario* é igual a *"Menu anterior"*
  * **Destino:** [Meu Contrato Proprietario]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: MeuCtrt - Informações sobre contrato (Informacoes_sobre_contrato)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - Informações sobre contrato** dentro do contexto de informações sobre o contrato do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CONT_PROP_INFOS"*
  * **MeuCtrt_InformacoesSobreContrato** → limpo/redefinido

#### Ação 2 : Consulta ao Salesforce — Bot_Check_Contract_End_Date

O bot aciona a automação **Bot_Check_Contract_End_Date** para: **Executar a automação **Bot_Check_Contract_End_Date** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *contractId* ← variável de sessão *imovelContractId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *isBeforeToday* ← parâmetro de retorno *isBeforeToday*
  * Variável de sessão *imovelEndereco* ← parâmetro de retorno *imovelEnderecoFormatado*

#### Ação 3 : Consulta ao Salesforce — Bot_Obter_Campos_do_Contrato

O bot aciona a automação **Bot_Obter_Campos_do_Contrato** para: **Executar a automação **Bot_Obter_Campos_do_Contrato** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *ImovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
  * Parâmetro *ContractId* ← variável de sessão *imovelContractId*
* **Dados Retornados pela Automação:**
  * Variável de sessão *DataDeTermino* ← parâmetro de retorno *DataDeTermino*
  * Variável de sessão *DataProximoReajuste* ← parâmetro de retorno *DataProximoReajuste*
  * Variável de sessão *imovelEndereco* ← parâmetro de retorno *imovelEnderecoFormatado*
  * Variável de sessão *PercentualTaxaAdministrativa* ← parâmetro de retorno *PercentualTaxaAdministrativa*
  * Variável de sessão *ModalidadeContrato* ← parâmetro de retorno *RecordTypeName*
  * Variável de sessão *DataAssinaturaContrato* ← parâmetro de retorno *DataAssinaturaContrato*

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 {!NomeConta}, seguem os dados do contrato do seu imóvel em {!imovelEndereco}:

#### Ação 5 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Data de assinatura: {!DataAssinaturaContrato} Data de término: {!DataDeTermino} Data do próximo reajuste: {!DataProximoReajuste} Modalidade do contrato: {!ModalidadeContrato}

#### Ação 6 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Repasse do aluguel: Creditado em sua conta até o dia 10 de cada mês.

#### Ação 7 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **MeuCtrt_Informacoes_sobre_contrato** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MeuCtrt_InformacoesSobreContrato**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MeuCtrt_InformacoesSobreContrato* é igual a *"2° via do contrato"*
  * **Destino:** [MeuCtrt - 2° via contrato]
* **Cenario B:** Se a variável *MeuCtrt_InformacoesSobreContrato* é igual a *"Tirar dúvidas"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Consultas sobre Contrato"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"Outras dúvidas"*
* **Cenario C:** Se a variável *MeuCtrt_InformacoesSobreContrato* é igual a *"Tirar dúvidas"*
  * **Destino:** [Obter assistente de conta] / [Falar Com Atendente (Cria Caso)]
* **Cenario D:** Se a variável *MeuCtrt_InformacoesSobreContrato* é igual a *"Atualização cadastral"*
  * **Destino:** [AtualizacaoCadastralProprietario]
* **Cenario E:** Se a variável *MeuCtrt_InformacoesSobreContrato* é igual a *"Menu anterior"*
  * **Destino:** [Meu Contrato Proprietario]
* **Cenario F:** Se a variável *MeuCtrt_InformacoesSobreContrato* é igual a *"Encerrar atendimento"*
  * **Destino:** [Lógica de Resolução]
* **Cenario G (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: MeuCtrt - Quero vender meu imóvel (MeuCtrtQuero_vender_meu_imovel)

**Objetivo do Diálogo:** Gerenciar o fluxo de **MeuCtrt - Quero vender meu imóvel** dentro do contexto de informações sobre o contrato do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CONT_PROP_VENDER_IMOVEL"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 Certo! Nesse caso, é importante você saber que, de acordo com a Lei do Inquilinato (Lei nº 8.245/91), o inquilino tem o direito de preferência na compra e um prazo de 30 dias para manifestar seu interesse após a comunicação.

#### Ação 3 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **Inquilino_notificado_intencao_de_venda** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **MeuCtrt_QueroVenderMeuImovel**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *MeuCtrt_QueroVenderMeuImovel* é igual a *"Sim"*
  * Mensagem exibida: *"📲 Ótimo! Se o inquilino demonstrou interesse de compra, é importante alinhar os próximos passos com o corretor responsável para conduzir a venda."*
* **Cenario B:** Se a variável *MeuCtrt_QueroVenderMeuImovel* é igual a *"Sim"*
  * **Destino:** [Lógica de Resolução]
* **Cenario C:** Se a variável *MeuCtrt_QueroVenderMeuImovel* é igual a *"Não"*
  * Mensagem exibida: *"📲 Antes de efetuar a venda é *necessário notificar o inquilino* sobre o desejo de venda. *Essa notificação deve ser enviada por você ou pelo seu corretor*. Para facilitar, clique no botão abaixo para ver um modelo de notificação que pode ser utilizado."*
  * **Destino:** [Lógica de Resolução]
* **Cenario D:** Se a variável *MeuCtrt_QueroVenderMeuImovel* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Meu Contrato Proprietario]
* **Cenario E (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: AtualizacaoCadastralProprietario (AtualizacaoCadastralProprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **AtualizacaoCadastralProprietario** dentro do contexto de informações sobre o contrato do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"MEU_CTRT_PROP_ATUALIZACAOCADASTRAL"*
  * **alterarDadosProprietario** → limpo/redefinido

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 📲 Compreendi. Para que eu possa te ajudar da melhor forma, por favor, me diga em poucas palavras *o que você gostaria de alterar.*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **alterarDadosProprietario**.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Gestão Contratual"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Alteração cadastral e contratual"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Atualizar dados cadastrais"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Media"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **motivoEscolhido** → copiado de *alterarDadosProprietario*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

## Pag e Financeiro Inquilino

### Diálogo: 2 via do Boleto (X2_via_do_Boleto)

**Objetivo do Diálogo:** Gerenciar o fluxo de **2 via do Boleto** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"2_VIA_BOL_INQ"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Por questões de *segurança*, confirme seu *CPF ou CNPJ*.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **ValidaCPFCNPJ**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Consulta ao Salesforce — CA_BotValidaCPFCNPJParaBuscarBoletos

O bot aciona a automação **CA_BotValidaCPFCNPJParaBuscarBoletos** para: **Executar a automação **CA_BotValidaCPFCNPJParaBuscarBoletos** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *CPFCNPJrecebido* ← variável de sessão *ValidaCPFCNPJ*
* **Dados Retornados pela Automação:**
  * Variável de sessão *CPFConferido* ← parâmetro de retorno *CPFConferido*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *CPFConferido* está preenchido
  * Limpa **CPFConferido**
* **Cenario B:** Se a variável *CPFConferido* é igual a *"true"*
  * **Destino:** [2 via bol - CPFCNPJConferido]
* **Cenario C:** Se a variável *CPFConferido* é igual a *"false"*
  * **Destino:** [2 via bol- CPFCNPJNaoConfere]

---

### Diálogo: 2 via bol - CPFCNPJConferido (CPFCNPJConferido)

**Objetivo do Diálogo:** Gerenciar o fluxo de **2 via bol - CPFCNPJConferido** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **CPFCNPJ** (*CPF ou CNPJ digitado pelo cliente para autenticação manual*) → copiado de *ValidaCPFCNPJ*

#### Ação 2 : Consulta ao Salesforce — CA_BotConsultaBoletos

O bot aciona a automação **CA_BotConsultaBoletos** para: **Executar a automação **CA_BotConsultaBoletos** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *CPFCNPJ* ← variável de sessão *CPFCNPJ* (*CPF ou CNPJ digitado pelo cliente para autenticação manual*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *BoletosEmAtrasoAluguel* ← parâmetro de retorno *BoletosAtrasoAluguel*
  * Variável de sessão *QuantidadeBoletos* ← parâmetro de retorno *QuantidadeBoletos*
  * Variável de sessão *CodigoErro* ← parâmetro de retorno *CodigoErro*
  * Variável de sessão *Mensagem* ← parâmetro de retorno *Mensagem*
  * Variável de sessão *VencidoMais7Dias* ← parâmetro de retorno *VencMais7Dias*
  * Variável de sessão *BoletosEmAtrasoCondominio* ← parâmetro de retorno *BoletosAtrasoCondominio*
  * Variável de sessão *ListaBoletos* ← parâmetro de retorno *ListaBoletos*
  * Variável de sessão *Sucesso* ← parâmetro de retorno *Sucesso*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Sucesso* é igual a *"false"*
  * **Destino:** [2 via bol- Erro Consulta]
* **Cenario B:** Se a variável *QuantidadeBoletos* é igual a *"0"* **E** a variável *Sucesso* é igual a *"true"*
  * **Destino:** [2 via bol- Sem Boletos Vencidos]
* **Cenario C:** Se a variável *VencidoMais7Dias* é igual a *"false"* **E** a variável *QuantidadeBoletos* é diferente de *"0"* **E** a variável *Sucesso* é igual a *"true"*
  * **Destino:** [2 via bol- VencidoMenos7Dias]
* **Cenario D:** Se a variável *VencidoMais7Dias* é igual a *"true"* **E** a variável *QuantidadeBoletos* é diferente de *"0"* **E** a variável *Sucesso* é igual a *"true"*
  * **Destino:** [2 via bol- VencidoMais7Dias]

---

### Diálogo: 2 via bol- VencidoMais7Dias (VencidoMais7Dias)

**Objetivo do Diálogo:** Gerenciar o fluxo de **2 via bol- VencidoMais7Dias** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Verificamos que o seu boleto está vencido.* Para te ajudar da melhor forma, *vou transferir você para a área de Cobrança.* Por favor, *aguarde um momento* — o atendente vai te *responder aqui mesmo.*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Boleto"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"2º via de boleto"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Cobrança Aluguéis"*

#### Ação 3 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)

#### Ação 4 : Automação de Retaguarda — CA_BotAtualizaCasoCriado

O bot aciona a automação **CA_BotAtualizaCasoCriado** para: **Atualizar o caso já criado no Salesforce com as informações complementares coletadas durante o atendimento**.

* **Dados Enviados para a Automação:**
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *CaseSelected* ← variável de sessão *CaseSelected*
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *ImovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)

#### Ação 5 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

---

### Diálogo: 2 via bol- VencidoMenos7Dias (VencidoMenos7Dias)

**Objetivo do Diálogo:** Gerenciar o fluxo de **2 via bol- VencidoMenos7Dias** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Encontramos {!QuantidadeBoletos} boleto(s) disponível(is) no seu CPF.* Antes de pagar, *confira sempre* se o beneficiário é *Auxiliadora Predial LTDA.*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> {!ListaBoletos}

---

### Diálogo: 2 via bol- CPFCNPJNaoConfere (CPFCNPJNaoConfere)

**Objetivo do Diálogo:** Gerenciar o fluxo de **2 via bol- CPFCNPJNaoConfere** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"2_VIA_BOL_CNPJCPF_NAOCONFERE"*
  * **ValidaCPFCNPJ** → limpo/redefinido
  * **CPFCNPJNaoConfere** → limpo/redefinido

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> O CPF ou CNPJ informado *não confere com o dado cadastrado*.

#### Ação 3 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **CPF_ou_CNPJ_Nao_encontrado** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **CPFCNPJNaoConfere**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *CPFCNPJNaoConfere* é igual a *"Digitar novamente"*
  * **Destino:** [2 via do Boleto]
* **Cenario B:** Se a variável *CPFCNPJNaoConfere* é igual a *"Falar com atendente"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) = *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) = *"Boleto"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) = *"2ª via de Boleto"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) = *"Média"*
  * **motivoEscolhido** = *"Desejo gerar a segunda via do Boleto"*
* **Cenario C:** Se a variável *CPFCNPJNaoConfere* é igual a *"Falar com atendente"*
  * **Destino:** [Obter assistente de conta] / [Falar Com Atendente (Cria Caso)]
* **Cenario D:** Se a variável *CPFCNPJNaoConfere* é igual a *"Encerrar"*
  * **Destino:** [Encerrar bate-papo]
* **Cenario E:** Se a variável *CPFCNPJNaoConfere* está preenchido **E** a variável *CPFCNPJNaoConfere* é diferente de *"Falar com atendente"* **E** a variável *CPFCNPJNaoConfere* é diferente de *"Digitar novamente"* **E** a variável *CPFCNPJNaoConfere* é diferente de *"Encerrar"*
  * **Destino:** [2 via boleto: Confuso]

---

### Diálogo: 2 via bol- Sem Boletos Vencidos (Sem_Boletos_Vencidos)

**Objetivo do Diálogo:** Gerenciar o fluxo de **2 via bol- Sem Boletos Vencidos** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"2_VIA_BOL_SEM_BOL"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Oops! Não encontrei nenhum boleto por aqui.*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Boleto"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"2ª via de boleto"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Médio"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*

---

### Diálogo: 2 via bol- Erro Consulta (Erro_Consulta)

**Objetivo do Diálogo:** Gerenciar o fluxo de **2 via bol- Erro Consulta** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Outros Assuntos"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"2ª Via do boleto"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alto"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*

---

### Diálogo: 2 via boleto: Confuso (X2_via_boleto_Confuso_CPF_CNPJ_nao_confere)

**Objetivo do Diálogo:** Gerenciar o fluxo de **2 via boleto: Confuso** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Desculpe, não entendi isso.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [2 via bol- CPFCNPJNaoConfere]

---

### Diálogo: Dúvidas Boletos Inquilino (Duvidas_sobre_Lan_amentos_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Dúvidas Boletos Inquilino** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DUV_BOL_INQ"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Claro!*😊 Para eu te ajudar a esclarecer sua dúvida, me conta *qual lançamento do seu boleto você gostaria de entender melhor.*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **DuvidasSobreLancamentos**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Knowledge* é diferente de *"0"*
  * **Destino:** [Dúvida Boleto - ArtigoEncontrado - Inquilino]
* **Cenario B (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Dúvida Boleto - ArtigoNaoEncontrado - Inquilino]

---

### Diálogo: Dúvida Boleto - ArtigoEncontrado - Inquilino (Duvidas_Boletos_Inq_ArtigoEncontrado)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Dúvida Boleto - ArtigoEncontrado - Inquilino** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DUV_BOL_INQ_ART_ENCONTRADO"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Encontrei os seguintes artigos sobre esse tema. *Para saber mais, digite o número da opção desejada.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **KnowledgeSelecionado**.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> {!KnowledgeSelecionado.Summary} Segue link para acessar o artigo completo: https://auxiliadorapredial--homolog.sandbox.my.site.com/centraldeajuda/s/article/{!KnowledgeSelecionado.UrlName}

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Dúvida Boleto - ArtigoNaoEncontrado - Inquilino (Duvida_Boleto_ArtigoNaoEncontrado_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Dúvida Boleto - ArtigoNaoEncontrado - Inquilino** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DUV_BOL_INQ_ART_NAO_ENCONTRADO"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Boleto"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvida sobre lançamentos"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Médio"*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *DuvidasSobreLancamentos*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: Comprovantes de Pagamento Inquilino (Comprovantes_de_Pagamento_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Comprovantes de Pagamento Inquilino** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"COMPROV_INQ"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Entendido!* Posso te ajudar a obter seus *comprovantes de pagamento.* Você precisa de um comprovante de *um mês* ou de *vários meses*?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Comprovantes_de_Pagamento_Inquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Mensal"*
  * *"Vários meses"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Comprovantes_de_Pagamento_Inquilino* é igual a *"Mensal"*
  * **Destino:** [Comprovante mensal inquilino]
* **Cenario B:** Se a variável *Comprovantes_de_Pagamento_Inquilino* é igual a *"Vários meses"*
  * **Destino:** [Comprovante de um período Inquilino]
* **Cenario C:** Se a variável *Comprovantes_de_Pagamento_Inquilino* é igual a *"Menu anterior"*
  * **Destino:** [Pagamentos e Financeiro Inquilino]

---

### Diálogo: Comprovante mensal inquilino (Comprovante_mensal_inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Comprovante mensal inquilino** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"COMPROV_INQ_MENSAL"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Ok!* Digite o *mês e o ano* _(Ex: 'Maio 2024')_ do comprovante que precisa.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Comprovante_Mensal_Inquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *Comprovante_Mensal_Inquilino*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Comprovantes de Pag - Atualiza Caso (Atualiza_Caso_Comprovantes_de_Pagamento_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Comprovantes de Pag - Atualiza Caso** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Boleto"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Comprovantes de pagamentos"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixo"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*

#### Ação 2 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

---

### Diálogo: Comprovante de um período Inquilino (Comprovante_de_um_per_odo_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Comprovante de um período Inquilino** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"COMPROV_INQ_PERIODO"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Ok!* Digite o *mês/ano de início e o mês/ano de fim* _(Ex: 'Janeiro 2024 a Junho 2024')_ do comprovante que precisa.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Comprovante_de_um_perioro_Inquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *Comprovante_de_um_perioro_Inquilino*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Débito em Conta Inquilino (Debito_em_Conta_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Débito em Conta Inquilino** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DEB_CONT_INQ"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Entendido!* Sobre Débito em Conta, *selecione o que deseja fazer.*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Debito_em_Conta_Inquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Cadastrar"*
  * *"Excluir"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Debito_em_Conta_Inquilino* é igual a *"Cadastrar"*
  * **Destino:** [Débito em conta - Cadastrar]
* **Cenario B:** Se a variável *Debito_em_Conta_Inquilino* é igual a *"Excluir"*
  * **Destino:** [Débito em conta - Excluir]
* **Cenario C:** Se a variável *Debito_em_Conta_Inquilino* é igual a *"Menu anterior"*
  * **Destino:** [Pagamentos e Financeiro Inquilino]

---

### Diálogo: Débito em conta - Cadastrar (Cadastrar_debito_em_conta)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Débito em conta - Cadastrar** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DEB_CONT_INQ_CADASTRO"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Ótima escolha!* O *débito automático* realmente facilita o seu dia a dia. Para concluir o cadastro de forma *rápida e segura*, é só preencher seus dados na *Auxiliadora Digital*. Por favor, *clique no botão abaixo* para acessar.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> https://portal.auxiliadorapredial.com.br/Login.aspx

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Para cadastrar o débito em conta, acesse o Auxiliadora Digital e siga o caminho: *Para você > Financeiro > Boleto > Solicitação de Débito em Conta.* Depois, é só preencher o formulário — *é rápido e fácil!*

---

### Diálogo: Débito em conta - Excluir (Excluir_debito_em_conta)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Débito em conta - Excluir** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"DEB_CONT_INQ_EXCLUI"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Prontinho!* Sua solicitação para *excluir o débito automático* foi recebida. A partir do *próximo vencimento*, seu boleto será enviado para o e-mail {!EmailMascarado} e também ficará disponível *aqui neste canal.*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Boleto"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Excluir Débito em Conta"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixo"*

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Operações Adm Financeiro"*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: Negociação Inquilino (Negociacao_Inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Negociação Inquilino** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"NEGOC_INQ"*

#### Ação 2 : Interação e Coleta de Dados

O bot exibe ao cliente o menu/mensagem definido pelo template **CA_NegociacaoInquilino** no Salesforce.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Negociacao_Inquilino**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Negociacao_Inquilino* é igual a *"Valor do Aluguel"*
  * **Destino:** [Negociação - Valor do Aluguel]
* **Cenario B:** Se a variável *Negociacao_Inquilino* é igual a *"Melhoria no Imóvel"*
  * **Destino:** [Negociação - Melhoria no Imóvel]
* **Cenario C:** Se a variável *Negociacao_Inquilino* é igual a *"Condições de Desocupação"*
  * **Destino:** [Negociação - Condições de Desocupação]
* **Cenario D:** Se a variável *Negociacao_Inquilino* é igual a *"Voltar ao menu anterior"*
  * **Destino:** [Pagamentos e Financeiro Inquilino]

---

### Diálogo: Negociação - Valor do Aluguel (Valor_do_Aluguel)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Negociação - Valor do Aluguel** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Compreendo.* Para registrar sua proposta, preciso que me informe: *1. Novo valor desejado* *2. Motivo da proposta* Assim conseguimos encaminhar sua solicitação ao proprietário de forma mais rápida e clara.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **ValorAluguel**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Sua proposta foi registrada!* Nossa equipe vai encaminhá-la ao *proprietário*, que terá um prazo para avaliar.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Assim que tivermos um retorno, *entramos em contato com você!*

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Se o seu boleto ainda *não venceu*, o pagamento deve ser feito no *valor integral até a data de vencimento* para evitar multas e juros.

#### Ação 5 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Caso sua proposta seja aprovada, o *desconto será aplicado no próximo boleto.*

#### Ação 6 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Negociação"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Negociação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Valor do Aluguel"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alto"*
  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *ValorAluguel*

#### Ação 7 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *gestorDeContaId*
  * **motivoEscolhido** → copiado de *ValorAluguel*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Lógica de Resolução]

---

### Diálogo: Negociação - Melhoria no Imóvel (Melhoria_no_Imovel)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Negociação - Melhoria no Imóvel** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Ótimo! Para propor uma melhoria, precisamos da aprovação do proprietário. Por favor, me informe: - *O que você deseja fazer* (descrição detalhada) - *Marca, modelo ou referência* do item - *Fotos ou documentos* que ajudem na análise - Estimativa de custos

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Assim conseguimos enviar sua solicitação de forma completa para o proprietário.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Melhoria_no_Imovel**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Sua proposta foi registrada!* Nossa equipe vai encaminhá-la ao *proprietário*, que terá um prazo para avaliar.

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Assim que tivermos um retorno, *entramos em contato com você!*

#### Ação 5 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Se sua solicitação envolve *reembolso ou desconto* e o boleto ainda *não venceu*, o pagamento deve ser feito no *valor integral até o vencimento* para evitar multas e juros.

#### Ação 6 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Caso sua proposta seja aprovada, o *desconto poderá ser aplicado no próximo boleto.*

#### Ação 7 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Negociação"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Negociação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Melhoria no imóvel"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Médio"*

#### Ação 8 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *Melhoria_no_Imovel*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*
  * **motivoEscolhido** → copiado de *Melhoria_no_Imovel*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *gestorDeContaId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Lógica de Resolução]

---

### Diálogo: Negociação - Condições de Desocupação (Condicoes_de_Desocupacao)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Negociação - Condições de Desocupação** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Para analisarmos sua solicitação, informe: *1. Motivo da desocupação* *2. Data que pretende entregar o imóvel* *3. Se quer negociar multa contratual* *4. Se precisa de prazo* para realizar reparos/manutenções *5. Outras condições* que gostaria de propor

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Com essas informações conseguimos avaliar e apresentar sua proposta ao proprietário de forma mais rápida e assertiva. 😉

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Condicoes_de_Desocupacao**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> ✅*Sua proposta foi registrada!* Nossa equipe vai encaminhá-la ao *proprietário*, que terá um prazo para avaliar.

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Assim que tivermos um retorno, *entramos em contato com você!*✨

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Negociação - Condições de Desocupação - Cria Caso]

---

### Diálogo: Negociação - Condições de Desocupação - Cria Caso (Negocia_o_Condi_es_de_Desocupa_o_Cria_Caso)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Negociação - Condições de Desocupação - Cria Caso** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Negociação"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Negociação"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Condições de Desocupação"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alto"*

#### Ação 2 : Consulta ao Salesforce — Bot_Obter_Gestor_Conta_do_prop_do_Imovel_online_ou_offline

O bot aciona a automação **Bot_Obter_Gestor_Conta_do_prop_do_Imovel_online_ou_offline** para: **Executar a automação **Bot_Obter_Gestor_Conta_do_prop_do_Imovel_online_ou_offline** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *imovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *falarComGestor_inputFlow* ← parâmetro de retorno *falarComGestor*
  * Variável de sessão *enviarParaFila* ← parâmetro de retorno *enviarParaFila*
  * Variável de sessão *gestorDeContaId* ← parâmetro de retorno *gestorDeContaId*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *gestorDeContaId*

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *Condicoes_de_Desocupacao*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → *"0MwU600000OeduZKAR"*
  * **motivoEscolhido** → copiado de *Condicoes_de_Desocupacao*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Lógica de Resolução]

---

### Diálogo: IPTU inquilino (IPTU_inquilino)

**Objetivo do Diálogo:** Gerenciar o fluxo de **IPTU inquilino** dentro do contexto de pagamentos e financeiro do Inquilino. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"IPTU_INQ"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"IPTU"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvidas de IPTU"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Operações Adm Financeiro"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixa"*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *gestorDeContaId*
  * **iptu_naoRotear** → *"true"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

## Pag e Financeiro Proprietario

### Diálogo: Extrato (Extrato)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Extrato** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"EXTRATO_PROP"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Entendido!* Sobre o extrato, qual opção melhor se encaixa com *o que você precisa?*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Extrato** (*Dados de extrato financeiro do imóvel*).
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Demonstrativo"*
  * *"Tirar dúvidas"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Extrato* (*Dados de extrato financeiro do imóvel*) é igual a *"Demonstrativo"*
  * **Destino:** [Extrato Prop - Receber demonstrativo]
* **Cenario B:** Se a variável *Extrato* (*Dados de extrato financeiro do imóvel*) é igual a *"Tirar dúvidas"*
  * **Destino:** [Extrato Prop - Tenho dúvidas sobre o extrato]
* **Cenario C:** Se a variável *Extrato* (*Dados de extrato financeiro do imóvel*) é igual a *"Menu anterior"*
  * **Destino:** [Pagamentos e Financeiro Proprietario]
* **Cenario D (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Extrato Prop - Receber demonstrativo (Receber_demonstrativo_do_extrato)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Extrato Prop - Receber demonstrativo** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"EXT_RECEBE_DEMONSTRATIVO"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Ok!* Você pode acessar seus extratos de forma rápida e segura *diretamente na Auxiliadora Digital*, utilizando seu CPF e senha.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Receber_demonstrativo_do_extrato**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Auxiliadora Digital"*
  * *"Falar com atendente"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Receber_demonstrativo_do_extrato* é igual a *"Auxiliadora Digital"*
  * **Destino:** [Extrato Prop - Link auxiliadora]
* **Cenario B:** Se a variável *Receber_demonstrativo_do_extrato* é igual a *"Falar com atendente"*
  * **Destino:** [Extrato Prop - Cria Caso]
* **Cenario C:** Se a variável *Receber_demonstrativo_do_extrato* é igual a *"Menu anterior"*
  * **Destino:** [Extrato]
* **Cenario D (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: Extrato Prop - Cria Caso (Cria_Caso_Extrato_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Extrato Prop - Cria Caso** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Extrato"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"2º via Extrato"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixa"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: Extrato Prop - Link auxiliadora (LinkAuxiliadora)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Extrato Prop - Link auxiliadora** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Lógica de Resolução]

---

### Diálogo: Extrato Prop - Tenho dúvidas sobre o extrato (Tenho_duvidas_sobre_o_extrato)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Extrato Prop - Tenho dúvidas sobre o extrato** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"EXT_TENHO_DUV"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Ok!* Para eu te ajudar melhor, me diz *qual lançamento ou valor do seu extrato* gerou a dúvida?

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **TenhoDuvidasSsobreExtrato**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Extrato"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvidas no extrato"*

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Médio"*
  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *TenhoDuvidasSsobreExtrato*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar com Gestor da Conta]

---

### Diálogo: Alteração de dados bancários (Alteracao_de_dados_bancarios)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Alteração de dados bancários** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"ALT_DADOS_BANC_PROP"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Alteração de Dados Bancarios"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alta"*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Dados Bancarios"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Outros Assuntos"*

#### Ação 4 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Entendido!* Você pode acessar seus dados bancários de *forma rápida e segura diretamente na Auxiliadora Digital*, utilizando seu CPF e senha.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Alteracao_de_dados_bancarios**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Auxiliadora Digital"*
  * *"Falar com atendente"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Alteracao_de_dados_bancarios* é igual a *"Auxiliadora Digital"*
  * Mensagem exibida: *"Acesse a *Auxiliadora Digital* clicando neste link: https://portal.auxiliadorapredial.com.br/Login.aspx"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *Alteracao_de_dados_bancarios* é igual a *"Falar com atendente"*
  * **Destino:** [Atualiza Caso Voltar ou Falar]
* **Cenario C:** Se a variável *Alteracao_de_dados_bancarios* é igual a *"Menu anterior"*
  * **Destino:** [Pagamentos e Financeiro Proprietario]

---

### Diálogo: Alteração Dados Bancários - Cria Caso (Cria_Caso_Alteracao_Dados)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Alteração Dados Bancários - Cria Caso** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Gestão Contrato"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Alteração cadastral e contratual"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Atualizar dados bancários"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Médio"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Gestor De Conta Aluguéis"*

#### Ação 2 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*

#### Ação 3 : Automação de Retaguarda — CA_BotAtualizaCasoCriado

O bot aciona a automação **CA_BotAtualizaCasoCriado** para: **Atualizar o caso já criado no Salesforce com as informações complementares coletadas durante o atendimento**.

* **Dados Enviados para a Automação:**
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *CaseSelected* ← variável de sessão *CaseSelected*
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *Descricao* ← variável de sessão *Descricao* (*Descrição livre informada pelo cliente sobre sua demanda*)

#### Ação 4 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 5 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Olá! Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**

---

### Diálogo: Informe de Rendimentos/DIMOB (Informe_de_Rendimentos_DIMOB)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Informe de Rendimentos/DIMOB** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"INF_REND_PROP"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Entendido!* Sobre o seu informe para a declaração do Imposto de Renda, por favor, *escolha a opção desejada:*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Informe_de_Rendimentos_DIMOB**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Solicitar Informe"*
  * *"Dúvida ou Ajuste"*
  * *"Menu Anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Informe_de_Rendimentos_DIMOB* é igual a *"Solicitar Informe"*
  * **Destino:** [Informe Rend- Receber Informe de Rendimentos]
* **Cenario B:** Se a variável *Informe_de_Rendimentos_DIMOB* é igual a *"Dúvida ou Ajuste"*
  * **Destino:** [Informe Rend - Dúvidas ou ajustes no informe]
* **Cenario C:** Se a variável *Informe_de_Rendimentos_DIMOB* é igual a *"Menu Anterior"*
  * **Destino:** [Pagamentos e Financeiro Proprietario]

---

### Diálogo: Informe Rend- Receber Informe de Rendimentos (Receber_Informe_de_Rendimentos)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Informe Rend- Receber Informe de Rendimentos** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"INF_REND_RECEBE_INF"*

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Ok!* Você pode acessar seu Informe de Rendimentos de forma rápida e segura diretamente na *Auxiliadora Digital*, utilizando seu CPF e senha.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Receber_Informe_de_Rendimentos**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Opções Disponibilizadas (Intenções):**
  * *"Auxiliadora Digital"*
  * *"Falar com atendente"*
  * *"Menu anterior"*
* **Tratamento de Entradas Inválidas:** Caso o cliente não selecione uma opção válida, o bot exibe: *"Por favor, selecione uma das opções do menu!"* — bloqueando entradas livres para garantir a integridade dos dados que alimentarão o roteamento.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Receber_Informe_de_Rendimentos* é igual a *"Auxiliadora Digital"*
  * Mensagem exibida: *"Acesse pelo site https://portal.auxiliadorapredial.com.br/Login.aspx"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *Receber_Informe_de_Rendimentos* é igual a *"Falar com atendente"*
  * Mensagem exibida: *"Estou te transferindo para um de nossos atendentes. Por favor, aguarde um momento, que ele já irá te responder aqui mesmo."*
  * **Destino:** [Informe Rend/DIMOB Cria Caso]
* **Cenario C:** Se a variável *Receber_Informe_de_Rendimentos* é igual a *"Menu anterior"*
  * **Destino:** [Informe de Rendimentos/DIMOB]

---

### Diálogo: Informe Rend/DIMOB Cria Caso (Cria_Caso_Informe_de_Rendimentos_DIMOB)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Informe Rend/DIMOB Cria Caso** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Extrato"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Informe de rendimentos"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixo"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: Informe Rend - Dúvidas ou ajustes no informe (Duvidas_ou_ajustes_no_informe)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Informe Rend - Dúvidas ou ajustes no informe** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"INF_REND_DUVIDA"*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Compreendi!* Se você encontrou alguma *inconsistência no seu informe, caiu na malha fina ou precisa de ajuda com dados da sua locação*, o ideal é falar com o seu Gestor de Contas.

#### Ação 3 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Para agilizar, me *descreva rapidamente a dúvida ou o ajuste que você identificou.* Em seguida, faço a transferência do seu atendimento.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **Duvidas_ou_ajustes_no_informe**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Obrigado!* Para uma *análise detalhada da sua dúvida*, estou encaminhando suas informações ao seu Gestor de Contas. Por favor, *aguarde um momento*, ele vai te responder aqui mesmo.

---

### Diálogo: Informe Rend - Dúvidas ou ajustes no informe Cria Caso (Cria_Caso_Duvidas_ou_ajustes_no_informe)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Informe Rend - Dúvidas ou ajustes no informe Cria Caso** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Extrato"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvidas/Ajustes no IR"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Médio"*
  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *Duvidas_ou_ajustes_no_informe*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Gestor de Conta"*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: Não Recebi Meu Aluguel - Cria Caso (Cria_Caso_Nao_Recebi_Meu_Aluguel)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Não Recebi Meu Aluguel - Cria Caso** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"NAO_RECEB_ALUG_PROP"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Inadimplência e Repasses"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Aluguel não Recebido"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Alto"*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *gestorDeContaId*

---

### Diálogo: IPTU Proprietario (IPTU_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **IPTU Proprietario** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"IPTU_PROP"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"IPTU"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvidas de IPTU"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixa"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *assistenteContaId* está preenchido
* **Cenario B (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: Cria Caso Pagamentos Assistente (Cria_Caso_Pagamentos_Assistente)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Cria Caso Pagamentos Assistente** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Dúvidas Pagamentos"*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvida não encontrada na Knowledge Base"*

#### Ação 4 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Descricao** (*Descrição livre informada pelo cliente sobre sua demanda*) → copiado de *AssuntoPagamentosFinanceiro*

#### Ação 5 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Assistente Aluguéis"*

#### Ação 6 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 Obrigado pela informação. Não encontrei nenhum artigo relacionado à sua dúvida. Para uma análise detalhada, estou encaminhando sua conversa para o seu Assistente de Contas. Por favor, aguarde.

#### Ação 7 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*

#### Ação 8 : Automação de Retaguarda — CA_BotAtualizaCasoCriado

O bot aciona a automação **CA_BotAtualizaCasoCriado** para: **Atualizar o caso já criado no Salesforce com as informações complementares coletadas durante o atendimento**.

* **Dados Enviados para a Automação:**
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *Descricao* ← variável de sessão *Descricao* (*Descrição livre informada pelo cliente sobre sua demanda*)
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)

#### Ação 9 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

---

### Diálogo: NF Proprietario (NF_Proprietario)

**Objetivo do Diálogo:** Gerenciar o fluxo de **NF Proprietario** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **LastMenu** (*Rastreador de contexto: armazena o identificador do último menu exibido, usado para reapresentar o menu correto após uma entrada inválida*) → *"NF_PROP"*
  * **NF_Proprietario** → limpo/redefinido

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> 📲 Ok! Você pode acessar as suas Notas Fiscais de forma rápida e segura diretamente na Auxiliadora Digital, utilizando seu CPF e senha.

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **NF_Proprietario**.
* **Opções Disponibilizadas (Intenções):**
  * *"Auxiliadora Digital"*
  * *"Falar com atendente"*
  * *"Menu anterior"*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *NF_Proprietario* é igual a *"Auxiliadora Digital"*
  * Mensagem exibida: *"Acesse pelo site https://portal.auxiliadorapredial.com.br/Login.aspx"*
  * **Destino:** [Lógica de Resolução]
* **Cenario B:** Se a variável *NF_Proprietario* é igual a *"Falar com atendente"*
  * **Destino:** [NF Proprietário - Falar com atendente]
* **Cenario C:** Se a variável *NF_Proprietario* é igual a *"Menu anterior"*
  * **Destino:** [Pagamentos e Financeiro Proprietario]
* **Cenario D (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Confuso]

---

### Diálogo: NF Proprietário - Falar com atendente (Cria_caso_NF_Prop)

**Objetivo do Diálogo:** Gerenciar o fluxo de **NF Proprietário - Falar com atendente** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Pagamentos e Financeiro"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Notas Fiscais"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Solicitação de Nota Fiscal"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixa"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

### Diálogo: Pagamentos Financeiro - Busca Knowledge (Pagamentos_Financeiro_Busca_Knowledge)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Pagamentos Financeiro - Busca Knowledge** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Ok!* Para te ajudar melhor, *me conta brevemente qual é a sua dúvida sobre Pagamentos ou Financeiro?*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **AssuntoPagamentosFinanceiro**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Ação 2 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Encontrei os seguintes artigos que podem te ajudar. Escolha uma opção:

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **KnowledgeSelecionado**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> {!KnowledgeSelecionado.Summary} Segue link para acessar o artigo completo: https://auxiliadorapredial.my.site.com/centraldeajuda/s/article/{!KnowledgeSelecionado.UrlName}

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Lógica de Resolução]

---

### Diálogo: Atualiza Caso Voltar ou Falar (Atualiza_Caso_Voltar_ou_Falar)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Atualiza Caso Voltar ou Falar** dentro do contexto de pagamentos e financeiro do Proprietário. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Outros Assuntos"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → copiado de *VoltarOuFalar*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Baixo"*

#### Ação 2 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → copiado de *assistenteContaId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Falar Com Atendente (Cria Caso)]

---

## Utilitários

### Diálogo: Atualiza Sessão de Mensagem (Transfere a sessão) (Atualiza_Sessao_de_Mensagem)

**Objetivo do Diálogo:** Atualizar os dados da sessão de messaging no Salesforce e encaminhar para a fila de atendimento humano configurada. Responsável pelo roteamento final do atendimento.

#### Ação 1 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *recordId* ← variável de sessão *RoutableId*
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)
  * Parâmetro *Extrato* ← variável de sessão *Extrato* (*Dados de extrato financeiro do imóvel*)

---

### Diálogo: Cria ou atualiza caso (D_V_Inqui_Cria_caso)

**Objetivo do Diálogo:** Criar um caso de Desocupação e Vistoria para o inquilino a partir das informações coletadas no fluxo anterior. Registra o imóvel e demais metadados antes de transferir para atendimento.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Ação 2 : Consulta ao Salesforce — CA_BotCriaCaso

O bot aciona a automação **CA_BotCriaCaso** para: **Criar um novo caso no Salesforce com os metadados coletados durante o atendimento (tipo, motivo, prioridade, fila e imóvel)**.

* **Dados Enviados para a Automação:**
  * Parâmetro *motivoEscolhido* ← variável de sessão *motivoEscolhido*
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *IdRoteavel* ← variável de sessão *MessagingSession* (*ID da sessão de messaging no Salesforce*)
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *falarComGestor* ← variável de sessão *falarComGestor_inputFlow*
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *naoDeveCriarCaso_inputDoBot* ← variável de sessão *deveCriarCaso*
* **Dados Retornados pela Automação:**
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *newCaseId*
  * Variável de sessão *imovelEndereco* ← parâmetro de retorno *imovelEndereco*

---

### Diálogo: End Chat (End_Chat)

**Objetivo do Diálogo:** Encerramento programático da sessão de chat. Executa o comando de sistema para fechar o canal sem mensagem adicional ao usuário.

---

### Diálogo: Falar Com Atendente (Cria Caso) (Falar_Com_Atendente)

**Objetivo do Diálogo:** Preparar e executar a transferência da sessão para um atendente humano na fila correta. Atualiza os metadados da sessão de messaging antes de iniciar a transferência.

#### Ação 1 : Consulta ao Salesforce — CA_BotCriaCaso

O bot aciona a automação **CA_BotCriaCaso** para: **Criar um novo caso no Salesforce com os metadados coletados durante o atendimento (tipo, motivo, prioridade, fila e imóvel)**.

* **Dados Enviados para a Automação:**
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *falarComGestor* ← variável de sessão *falarComGestor_inputFlow*
  * Parâmetro *iptu_naoRotear* ← variável de sessão *iptu_naoRotear*
  * Parâmetro *motivoEscolhido* ← variável de sessão *motivoEscolhido*
  * Parâmetro *naoDeveCriarCaso_inputDoBot* ← variável de sessão *deveCriarCaso*
* **Dados Retornados pela Automação:**
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *newCaseId*

#### Ação 2 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 3 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Compreendi!* Para ajudar você com essa questão, estou *te transferindo para um atendente.*

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Aguarde um momento, ele vai te responder aqui mesmo.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**
* **Cenario B (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Atualiza Sessão de Mensagem (Transfere a sessão)]

---

### Diálogo: Falar Com Atendente Default (Falar_Com_Atendente_Default)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Falar Com Atendente Default** dentro do contexto de utilitários e recursos auxiliares do bot. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Central Aluguéis"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Falar com atendente"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Outros Assuntos"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Média"*

#### Ação 2 : Automação de Retaguarda — CA_BotCriaCaso

O bot aciona a automação **CA_BotCriaCaso** para: **Criar um novo caso no Salesforce com os metadados coletados durante o atendimento (tipo, motivo, prioridade, fila e imóvel)**.

* **Dados Enviados para a Automação:**
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *MotivoCaso* ← variável de sessão *MotivoCaso* (*Motivo específico de abertura do caso*)
  * Parâmetro *Prioridade* ← variável de sessão *PrioridadeCaso* (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*)
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
  * Parâmetro *TipoRegistro* ← variável de sessão *TipoRegistro* (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*)
  * Parâmetro *falarComGestor* ← variável de sessão *falarComGestor_inputFlow*
  * Parâmetro *motivoEscolhido* ← variável de sessão *motivoEscolhido*
  * Parâmetro *naoDeveCriarCaso_inputDoBot* ← variável de sessão *deveCriarCaso*

#### Ação 3 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 4 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> *Compreendi!* Para ajudar você com essa questão, estou *te transferindo para um atendente.*

#### Ação 5 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Aguarde um momento, ele vai te responder aqui mesmo.

#### Ação 6 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**

---

### Diálogo: Falar com Gestor da Conta (Falar_com_Gestor_da_Conta)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Falar com Gestor da Conta** dentro do contexto de utilitários e recursos auxiliares do bot. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Para ajudar você com essa questão, estou *te transferindo para o seu Gestor de Conta*. Aguarde um momento, ele vai te responder aqui mesmo. 💬

#### Ação 2 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **deveCriarCaso** → *"false"*
  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *enviarParaFila* é igual a *"true"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) = *"Central Aluguéis"*
  * **falarComGestor_inputFlow** = *"false"*
* **Cenario B:** Se a variável *enviarParaFila* é igual a *"false"*
* **Cenario C:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"*
  * Mensagem exibida: *"Olá! Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**
* **Cenario D (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [End Chat]

---

### Diálogo: Busca Knowledge - Resposta digitada (Busca_Knowledge)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Busca Knowledge - Resposta digitada** dentro do contexto de utilitários e recursos auxiliares do bot. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> *Ok!* Para te ajudar melhor, *me conta brevemente qual é a sua dúvida?*

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **AssuntoKnowledge**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.
* **Formato de Entrada:** Texto livre — o cliente pode digitar qualquer resposta, que será interpretada pelo NLU do Einstein Bot.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *Knowledge* é maior que *"0"*
  * **Destino:** [Knowledge Encontrado]
* **Cenario B (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Knowledge Não Encontrado]

---

### Diálogo: Knowledge Encontrado (Knowledge_Encontrado)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Knowledge Encontrado** dentro do contexto de utilitários e recursos auxiliares do bot. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Interação e Coleta de Dados

O bot apresenta ao cliente o seguinte prompt de interação:

> Encontrei os seguintes artigos que podem te ajudar. Escolha uma opção:

* **Mecanismo de Coleta:**
  * **Variável de Destino:** A resposta do cliente é armazenada na variável de conversação **KnowledgeSelecionado**.
  * **Comportamento de Memória:** Sobrescrever valor anterior — garante que mudanças de intenção dentro da mesma sessão sejam registradas corretamente.

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> {!KnowledgeSelecionado.Summary} Segue link para acessar o artigo completo: https://auxiliadorapredial.my.site.com/centraldeajuda/s/article/{!KnowledgeSelecionado.UrlName}

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Lógica de Resolução]

---

### Diálogo: Knowledge Não Encontrado (Knowledge_Nao_Encontrado)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Knowledge Não Encontrado** dentro do contexto de utilitários e recursos auxiliares do bot. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — Bot_Check_business_hours

O bot aciona a automação **Bot_Check_business_hours** para: **Verificar se o horário atual está dentro do horário comercial definido (segunda a sexta, 9h–18h)**.

* **Dados Retornados pela Automação:**
  * Variável de sessão *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) ← parâmetro de retorno *confirmaHorarioComercial*
  * Variável de sessão *estaSendoTestado* ← parâmetro de retorno *isTest*

#### Ação 2 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> 📲 Para ajudar você com essa questão, estou te transferindo para um de nossos atendentes. Por favor, aguarde um momento, que ele já irá te responder aqui mesmo.

#### Ação 3 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Central Aluguéis"*
  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Outros Assuntos"*

#### Ação 4 : Consulta ao Salesforce — CA_BotCriaCaso

O bot aciona a automação **CA_BotCriaCaso** para: **Criar um novo caso no Salesforce com os metadados coletados durante o atendimento (tipo, motivo, prioridade, fila e imóvel)**.

* **Dados Enviados para a Automação:**
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
  * Parâmetro *TipoRegistro* ← variável de sessão **
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)
  * Parâmetro *Prioridade* ← variável de sessão **
  * Parâmetro *motivoEscolhido* ← variável de sessão *motivoEscolhido*
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *MotivoCaso* ← variável de sessão **
  * Parâmetro *TipoCaso* ← variável de sessão *TipoCaso* (*Classificação do caso por categoria de serviço*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*) ← parâmetro de retorno *newCaseId*

#### Ação 5 : Automação de Retaguarda — CA_BotAtualizaFilaSessaoMessaging

O bot aciona a automação **CA_BotAtualizaFilaSessaoMessaging** para: **Atualizar os metadados da sessão de messaging (fila destino, caso vinculado, extrato) e acionar o roteamento para o atendimento humano**.

* **Dados Enviados para a Automação:**
  * Parâmetro *Extrato* ← variável de sessão *Extrato* (*Dados de extrato financeiro do imóvel*)
  * Parâmetro *PerfilAlugueis* ← variável de sessão *PerfilAlugueis* (*Perfil de aluguéis da conta (Inquilino, Proprietário ou ambos)*)
  * Parâmetro *CaseId* ← variável de sessão *CaseId* (*ID do caso (chamado) vinculado ao atendimento atual*)
  * Parâmetro *IdRoteavel* ← variável de sessão *RoutableId*
  * Parâmetro *Fila* ← variável de sessão *Fila* (*Fila de atendimento humano para onde a sessão será roteada*)

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A:** Se a variável *horarioComercialConfirmado* (*Flag booleana indicando se o horário corrente está dentro do expediente comercial*) é igual a *"false"* **E** a variável *estaSendoTestado* é igual a *"false"*
  * Mensagem exibida: *"Olá! Nosso atendimento é de segunda a sexta, das 9h às 18h (exceto feriados). Assim que estivermos disponíveis, um atendente retornará sua mensagem."*
  * Ação do sistema: **EndChat**

---

### Diálogo: Obter gestor da conta (Obter_gestor_da_conta)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Obter gestor da conta** dentro do contexto de utilitários e recursos auxiliares do bot. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — Bot_Obter_Gestor_de_Conta

O bot aciona a automação **Bot_Obter_Gestor_de_Conta** para: **Executar a automação **Bot_Obter_Gestor_de_Conta** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *imovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *falarComGestor_inputFlow* ← parâmetro de retorno *falarComGestor*
  * Variável de sessão *enviarParaFila* ← parâmetro de retorno *enviaParaFila*
  * Variável de sessão *gestorDeContaId* ← parâmetro de retorno *gestorDeContaId*

---

### Diálogo: Obter assistente de conta (Obter_assistente_de_conta)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Obter assistente de conta** dentro do contexto de utilitários e recursos auxiliares do bot. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Consulta ao Salesforce — Bot_Obter_Assistente_de_Conta

O bot aciona a automação **Bot_Obter_Assistente_de_Conta** para: **Executar a automação **Bot_Obter_Assistente_de_Conta** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *accountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *imovelId* ← variável de sessão *ImovelId* (*ID do imóvel selecionado pelo cliente*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *enviarParaFila* ← parâmetro de retorno *enviarParaFila*
  * Variável de sessão *assistenteContaId* ← parâmetro de retorno *assistenteDeContaId*
  * Variável de sessão *falarComGestor_inputFlow* ← parâmetro de retorno *falarComAssistente*

---

### Diálogo: Obter o contrato do imóvel selecionado (Obter_o_contrato_do_imovel_selecionado)

**Objetivo do Diálogo:** Gerenciar o fluxo de **Obter o contrato do imóvel selecionado** dentro do contexto de utilitários e recursos auxiliares do bot. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **MessagingSession** (*ID da sessão de messaging no Salesforce*) → copiado de *RoutableId*

#### Ação 2 : Consulta ao Salesforce — Bot_Obter_contrato_do_imovel_selecionado

O bot aciona a automação **Bot_Obter_contrato_do_imovel_selecionado** para: **Executar a automação **Bot_Obter_contrato_do_imovel_selecionado** no Salesforce**.

* **Dados Enviados para a Automação:**
  * Parâmetro *AccountId* ← variável de sessão *AccountId* (*ID do registro de conta no Salesforce*)
  * Parâmetro *MessagingSessionId* ← variável de sessão *MessagingSession* (*ID da sessão de messaging no Salesforce*)
  * Parâmetro *TipoRelacionamento* ← variável de sessão *TipoRelacionamento*
  * Parâmetro *ImovelSelecionado* ← variável de sessão *ImovelSelecionado* (*Nome/endereço do imóvel selecionado*)
* **Dados Retornados pela Automação:**
  * Variável de sessão *imovelContractId* ← parâmetro de retorno *ContractId*

---

## Utilitários e Diálogos do Sistema

### Diálogo: Encerrar bate-papo (Rich_Content_End_Chat)

**Objetivo do Diálogo:** Diálogo de encerramento voluntário de conversa. Exibe mensagem de agradecimento, encerra formalmente a sessão e aguarda que o cliente inicie uma nova interação se desejar.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Agradecemos por reservar um tempo para conversar. Eu encerrei a conversa. Para iniciar uma nova conversa, insira um texto.

---

### Diálogo: Sem agente (No_Agent_Available)

**Objetivo do Diálogo:** Tratamento do cenário de indisponibilidade de agentes humanos. Notifica o cliente e encerra a sessão, mantendo o caso aberto para retomada assim que um agente estiver disponível.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Infelizmente, não temos nenhum atendente disponível no momento. Mas não se preocupe — *assim que alguém ficar online, vamos te atender!*

---

### Diálogo: Manipulador de erro (Rich_Content_Error_Handling)

**Objetivo do Diálogo:** Tratamento de erros críticos de sistema. Notifica o cliente sobre a falha e reinicia o fluxo a partir das boas-vindas para garantir a continuidade do atendimento.

#### Ação 1 : Comunicação com o Cliente

O bot transmite a seguinte mensagem ao cliente:

> Infelizmente, ocorreu um *erro do sistema.* Vamos começar novamente?

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após as interações e/ou processamentos descritos acima, o bot avalia as condições de sessão para determinar automaticamente o destino do fluxo:

* **Cenario A (Fallback):** Nenhuma das condicoes anteriores satisfeita - **Destino:** [Boas-vindas]

---

### Diálogo: NaoEncontrouArtigos (NaoEncontrouArtigos)

**Objetivo do Diálogo:** Gerenciar o fluxo de **NaoEncontrouArtigos** dentro do contexto de este fluxo de atendimento. Este nó coordena as interações necessárias e realiza o roteamento para os destinos apropriados conforme as respostas e o estado da sessão.

#### Ação 1 : Configuração de Contexto da Sessão

O bot inicializa os parâmetros internos necessários para classificar e tratar a demanda:

  * **TipoRegistro** (*Tipo de registro do caso a ser criado (ex: Manutenção e Reparos, Outros Assuntos)*) → *"Outros Assuntos"*
  * **TipoCaso** (*Classificação do caso por categoria de serviço*) → *"Consultas sobre manutenção"*
  * **MotivoCaso** (*Motivo específico de abertura do caso*) → *"Dúvida sobre responsabilidade"*
  * **Fila** (*Fila de atendimento humano para onde a sessão será roteada*) → *"Relacionamento Manutenção"*
  * **PrioridadeCaso** (*Prioridade atribuída ao caso (Baixo, Médio, Alto)*) → *"Media"*

#### Ação 2 : Transferência para Atendimento Humano

O bot emite o comando de sistema **Transfer**, iniciando a transferência imediata da conversa para um agente humano na fila de atendimento configurada.

---

## Inicio - Encontrar conta

### Diálogo: Menu principal (Main_Menu)

**Objetivo do Diálogo:** Atuar como o roteador inteligente inicial após a tentativa de identificação do cliente nos bastidores. Ele avalia se a conta (registro `Account`) do cliente foi localizada com sucesso no CRM — baseando-se no telefone da Sessão de Mensageria — e direciona o contato para o menu autenticado de clientes ou para a rota de não identificados.

#### Regras de Redirecionamento (Roteamento de Diálogo)

Após processamentos paramétricos iniciais, o bot avalia as condições sistêmicas para determinar automaticamente o destino do fluxo de atendimento:

* **Cenario A:** Se a variável *ContaEncontrada* (*Status de localização do cliente na base Salesforce*) é igual a *"Sim"*
  * **Destino:** [Conta_Encontrada]
* **Cenario B:** Caso nenhuma das condições numéricas ou textuais listadas acima seja satisfeita (Ação padrão):
  * **Destino:** [Conta_Nao_Encontrada]
