({
    doInit: function (cmp) {
        var recordId = cmp.get("v.recordId");
        var sourceType = cmp.get("v.sourceType");
        var displayField = cmp.get("v.displayField");
        var lookupField = cmp.get("v.lookupField");
        
        if (recordId) {
            if (sourceType === "direct" && displayField) {
                cmp.find("recordLoader").set("v.recordId", recordId);
                cmp.find("recordLoader").set("v.fields", [displayField]);
                cmp.find("recordLoader").reloadRecord();
            } else if (sourceType === "related" && lookupField) {
                cmp.find("recordLoader").set("v.recordId", recordId);
                cmp.find("recordLoader").set("v.fields", [lookupField]);
                cmp.find("recordLoader").reloadRecord();
            }
        }
    },

    handleRecordUpdated: function (cmp, event, helper) {
        var sourceType = cmp.get("v.sourceType");
        var lookupField = cmp.get("v.lookupField");
        var displayField = cmp.get("v.displayField");
        var simpleRecord = cmp.get("v.simpleRecord");
        var recordError = cmp.get("v.recordError");
        
        if (recordError || !simpleRecord) {
            return;
        }
        
        if (sourceType === "direct") {
            helper.handleDirectField(cmp);
        } else if (sourceType === "related") {
            var targetId = cmp.get("v.simpleRecord." + lookupField);
            
            if (targetId) {
                cmp.find("targetLoader").set("v.recordId", targetId);
                cmp.find("targetLoader").set("v.fields", [displayField]);
                cmp.find("targetLoader").reloadRecord();
            }
        }
    },

    handleTargetUpdated: function (cmp, event, helper) {
        var displayField = cmp.get("v.displayField");
        var targetValue = cmp.get("v.targetRecord." + displayField);
        var autoRename = cmp.get("v.autoRename");
        var customTabLabel = cmp.get("v.customTabLabel");
        
        if (targetValue && !customTabLabel) {
            cmp.set("v.customTabLabel", targetValue);
        }
        
        if (autoRename && targetValue) {
            helper.renameTab(cmp);
        }
    }
})