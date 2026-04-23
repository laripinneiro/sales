trigger CaseAfterUpdateNotifyOwner on Case (after update) {

    // Busca o tipo de notificação com segurança
    List<CustomNotificationType> notificationTypes = [
        SELECT Id, DeveloperName
        FROM CustomNotificationType
        WHERE DeveloperName = 'Case_Assigned'
        LIMIT 1
    ];

    // Se não existir no org, não executa o envio
    if (notificationTypes.isEmpty()) {
        return;
    }

    Id notificationTypeId = notificationTypes[0].Id;

    // Agrupa 1 case por novo owner para evitar spam
    Map<Id, Case> firstCaseByNewOwner = new Map<Id, Case>();

    for (Case c : Trigger.new) {
        Case oldC = Trigger.oldMap.get(c.Id);

        if (
            c.OwnerId != oldC.OwnerId &&
            c.OwnerId != null &&
            c.OwnerId.getSObjectType() == User.SObjectType
        ) {
            if (!firstCaseByNewOwner.containsKey(c.OwnerId)) {
                firstCaseByNewOwner.put(c.OwnerId, c);
            }
        }
    }

    // Se não houve mudança de owner para usuário, não faz nada
    if (firstCaseByNewOwner.isEmpty()) {
        return;
    }

    // Envia as notificações
    for (Id newOwnerId : firstCaseByNewOwner.keySet()) {
        Case c = firstCaseByNewOwner.get(newOwnerId);

        Messaging.CustomNotification n = new Messaging.CustomNotification();
        n.setTitle('Novo caso atribuído');
        n.setBody('Você recebeu o caso ' + c.CaseNumber + ' - ' + String.valueOf(c.Subject));
        n.setNotificationTypeId(notificationTypeId);
        n.setTargetId(c.Id);

        n.send(new Set<String>{ String.valueOf(newOwnerId) });
    }
}