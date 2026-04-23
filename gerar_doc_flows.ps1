$flowsDir = "force-app\main\default\flows"
$outputFile = "Documentacao_Flows.md"

if (-Not (Test-Path $flowsDir)) {
    Write-Host "Erro: Diretório $flowsDir não encontrado."
    exit
}

$outputLines = New-Object System.Collections.Generic.List[string]
$outputLines.Add("# Documentação de Flows do Salesforce")
$outputLines.Add("")
$outputLines.Add("> Documento gerado de forma automática com base no processamento lógico dos metadados (*.flow-meta.xml*) para centralização da fundação dos dados do ambiente.")
$outputLines.Add("")

$files = Get-ChildItem -Path $flowsDir -Filter "*.flow-meta.xml" | Sort-Object Name

# Registro do Namespace
$nsManager = New-Object System.Xml.XmlNamespaceManager((New-Object System.Xml.XmlDocument).NameTable)
$nsManager.AddNamespace("ns", "http://soap.sforce.com/2006/04/metadata")

foreach ($file in $files) {
    Write-Host "Processando: $($file.Name)"
    try {
        $xml = New-Object System.Xml.XmlDocument
        $xml.Load($file.FullName)
        
        $root = $xml.DocumentElement
        $flowLabelNode = $root.SelectSingleNode("ns:label", $nsManager)
        $flowDescNode = $root.SelectSingleNode("ns:description", $nsManager)
        
        $flowLabel = if ($flowLabelNode) { $flowLabelNode.InnerText } else { $file.BaseName }
        $flowDesc = if ($flowDescNode) { $flowDescNode.InnerText } else { "" }
        
        $outputLines.Add("## Fluxo: $flowLabel")
        if ($flowDesc) {
            $outputLines.Add("**Objetivo do Fluxo**: $flowDesc`n")
        } else {
            $outputLines.Add("**Objetivo do Fluxo**: Fluxo automatizado do Salesforce utilizado no núcleo de negócio.`n")
        }
        
        $components = New-Object System.Collections.Generic.List[PSObject]
        
        $starts = $root.SelectNodes("ns:start", $nsManager)
        if ($starts) {
            foreach ($s in $starts) {
                $startObjNode = $s.SelectSingleNode("ns:object", $nsManager)
                $triggerNode = $s.SelectSingleNode("ns:triggerType", $nsManager)
                if ($startObjNode) {
                    $startObj = $startObjNode.InnerText
                    $trigger = if ($triggerNode) { $triggerNode.InnerText } else { "" }
                    $details = New-Object System.Collections.Generic.List[string]
                    $details.Add("**Objeto do Gatilho:** $startObj")
                    $details.Add("**Tipo do Gatilho:** $trigger")
                    $comp = New-Object PSObject -Property @{
                        Type = "Gatilho de Início (Start)"
                        Label = "Início do Fluxo"
                        Desc = ""
                        Action = "Espera alterações e avalia condições de início disparando de forma proativa o sistema."
                        Objective = "Garantir a iniciação correta da execução para modificações de $startObj."
                        Details = $details
                    }
                    $components.Add($comp)
                }
            }
        }
        
        function Process-Node([System.Xml.XmlNodeList]$nodeList, [string]$typeName, $listObj) {
            if ($null -eq $nodeList) { return }
            foreach ($node in $nodeList) {
                $compNameNode = $node.SelectSingleNode("ns:name", $nsManager)
                $compLabelNode = $node.SelectSingleNode("ns:label", $nsManager)
                $compDescNode = $node.SelectSingleNode("ns:description", $nsManager)
                
                $compName = if ($compNameNode) { $compNameNode.InnerText } else { "" }
                $compLabel = if ($compLabelNode) { $compLabelNode.InnerText } elseif ($compName) { $compName } else { "Passo sem nome" }
                $compDesc = if ($compDescNode) { $compDescNode.InnerText } else { "" }
                
                $details = New-Object System.Collections.Generic.List[string]
                $action = ""
                $objective = ""
                
                if ($typeName -eq "Busca de Registro") {
                    $objNode = $node.SelectSingleNode("ns:object", $nsManager)
                    $obj = if ($objNode) { $objNode.InnerText } else { "Desconhecido" }
                    $details.Add("**Objeto:** $obj")
                    $action = "Busca e recuperação de dados presentes no objeto $obj de acordo com as condições definidas."
                    $objective = if ($compDesc) { $compDesc } else { "Extratificar ou identificar o registro do objeto $obj para uso nos próximos cenários." }
                } elseif ($typeName -eq "Atribuição de Variável") {
                    $action = "Armazena ou transforma informações atualizando os valores em memória."
                    $objective = if ($compDesc) { $compDesc } else { "Preparação ou formatação do pacote de dados utilizado internamente na continuidade do atendimento." }
                } elseif ($typeName -eq "Decisão Lógica") {
                    $action = "Avalia variáveis da sessão usando regras combinadas e desvia para rotas apropriadas."
                    $objective = if ($compDesc) { $compDesc } else { "Identificação lógica do estado (ex: se cliente foi localizado ou não) e definição da experiência em ramificações do cenário." }
                } elseif ($typeName -eq "Atualização de Registro") {
                    $objNode = $node.SelectSingleNode("ns:object", $nsManager)
                    $obj = if ($objNode) { $objNode.InnerText } else { "Desconhecido" }
                    $details.Add("**Objeto:** $obj")
                    $action = "Altera pontualmente os dados de um ou mais registros do objeto $obj em nuvem."
                    $objective = if ($compDesc) { $compDesc } else { "Salvar o estado final da ação atualizando permanentemente as propriedades de $obj no banco da Org." }
                } elseif ($typeName -eq "Criação de Registro") {
                    $objNode = $node.SelectSingleNode("ns:object", $nsManager)
                    $obj = if ($objNode) { $objNode.InnerText } else { "Desconhecido" }
                    $details.Add("**Objeto:** $obj")
                    $action = "Instancia e grava um novo registro único dentro de $obj."
                    $objective = if ($compDesc) { $compDesc } else { "Processar a criação e vinculação de informações inéditas referentes a $obj geradas neste fluxo." }
                } elseif ($typeName -eq "Ação (Action)") {
                    $actionTypeNode = $node.SelectSingleNode("ns:actionType", $nsManager)
                    $actionType = if ($actionTypeNode) { $actionTypeNode.InnerText } else { "Adicional/Apex" }
                    $action = "Dispara a capacidade de sistema: $actionType."
                    $objective = if ($compDesc) { $compDesc } else { "Acionar capacidades da plataforma ou de classe invocável complementar à lógica primária." }
                }
                
                $objResult = New-Object PSObject -Property @{
                    Type = $typeName
                    Label = $compLabel
                    Desc = $compDesc
                    Action = $action
                    Objective = $objective
                    Details = $details
                }
                $listObj.Add($objResult)
            }
        }
        
        Process-Node $root.SelectNodes("ns:recordLookups", $nsManager) "Busca de Registro" $components
        Process-Node $root.SelectNodes("ns:assignments", $nsManager) "Atribuição de Variável" $components
        Process-Node $root.SelectNodes("ns:decisions", $nsManager) "Decisão Lógica" $components
        Process-Node $root.SelectNodes("ns:recordUpdates", $nsManager) "Atualização de Registro" $components
        Process-Node $root.SelectNodes("ns:recordCreates", $nsManager) "Criação de Registro" $components
        Process-Node $root.SelectNodes("ns:actionCalls", $nsManager) "Ação (Action)" $components
        
        foreach ($comp in $components) {
            $outputLines.Add("### $($comp.Type): $($comp.Label)")
            if ($comp.Desc) {
                $outputLines.Add("$($comp.Desc)`n")
            }
            $outputLines.Add("* **Ação:** $($comp.Action)")
            $outputLines.Add("* **Objetivo:** $($comp.Objective)")
            foreach ($d in $comp.Details) {
                $outputLines.Add("* $d")
            }
            $outputLines.Add("")
        }
        
        $outputLines.Add("---`n")
        
    } catch {
        Write-Host "Erro ao processar $($file.Name): $_"
        $outputLines.Add("## Fluxo: $($file.Name) (Erro ao ler arquivo XML)`n`n---`n")
    }
}

$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
[System.IO.File]::WriteAllLines((Join-Path (Get-Location) $outputFile), $outputLines, $Utf8NoBomEncoding)
Write-Host "Documentação gerada com sucesso em: $outputFile"
